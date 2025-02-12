# Block building, processing, and applying transaction to state:

## Intro

Block building is a crucial task for the Ethereum blockchain's functionality, involving various processes determining how a validator acquires a block before proposing it. Ethereum network consists of nodes running interconnected consensus (CL) and execution clients (EL). Both are essential for network participation and producing block at each slot. While the execution client (EL) has numerous important functionalities you can study more about it in the "el-architecture", a key focus here is its role in constructing blocks for consumption by CL.

When a validator is selected to propose a block during a slot, it looks for the block produced by CL. Importantly, a validator isn't limited to broadcasting a block solely from its own EL. It can also broadcast a block produced by external builders; for details, refer to [PBS](https://ethereum.org/en/roadmap/pbs/). This article specifically explores how a block is produced by EL and the elements contributing to its successful production and transaction execution.

## Payload building routine

A block is created when the consensus layer instructs the execution layer client to do so through the engine API's fork choice updated endpoint, which then initiates the process of constructing the block via the payload building routine.

Note: The fee recipient of the built payload may deviate from the suggested fee recipient of the payload attributes:

<img src="images/el-architecture/payload-building-routine.png" width="1000"/>

Nodes are gossiping transactions via a peer-to-peer network. These transactions are deemed valid and are waiting to be included in a block. Validity here, among other things, refers to the condition where the nonce of the transaction is the next valid nonce for the account and the account holds sufficient value to cover the transaction. Occasionally, the node is assigned the responsibility of generating a block. The consensus layer employs a random selection process to determine which validator will construct the block during each epoch. If your validator is chosen to build the block, your consensus layer client will proceed with constructing it using the execution engine's fork choice updated method, providing the necessary context for block construction.

We can simplify and emulate the process of constructing blocks, though this approach is specific to the Go types used in geth. However, the concepts can generally be applied to different clients.

```go
func build(env environment, pool txpool.Pool, state state.StateDB) (types.Block, state.StateDB, error) { //1
    var (
        gasUsed = 0
        txs []types.Transactions
    ) //2

  for ; gasUsed < 30_000_000 || !pool.Empty(); { //3
      transaction := pool.Pop() //4
      res, gas, err := vm.Run(env, transaction, state) //5
      if err != nil { // 6
          // transaction invalid
          continue
      }
      gasUsed += gas // 7
      transactions = append(transactions, transaction)
  }
  return core.Finalize(env, transactions, state) //8
}
```

1. We take in the environment, which contains all the necessary information (similar to the header previously), including the time stamp, block number, preceding block, base fee, and all the withdrawals that need to occur in the block. Essentially, the information originating from the consensus layer, which acts as the central decision-making entity, determines the context in which the block should be constructed. Next, we take in the transaction pool, which is a collection of transactions. For simplicity, we assume that these transactions are arranged in ascending order based on their value. This arrangement helps us construct the most profitable block for the execution client, considering the transactions observed in the network. Additionally, we also consider a state DB, representing the state over which all these transactions are executed.
   - We return a block, a state DB that has accumulated all the transactions in the block and possibly an error.
2. Inside build we track the gas used because there is only a finite amount of gas we can use. And, also store all the transactions that are going to go in the block.
3. We continue adding the transactions until the pool is empty or the amount of gas consumed is greater than the gas limit, which is fixed at 30 million (about the current gas limit on the mainnet) in this example for the sake of simplicity.
4. In order to obtain a transaction, we must query the transaction pool, which is presumed to maintain an ordered list of transactions, ensuring that we always receive the next most valuable transaction.
5. The transaction is executed in the EVM, assuming that run requires an interface that is satisfied by both the block and the environment. We provide the environment, transaction, and state as input. This  will execute the transaction within the context defined by the environment and provide us with an updated state that will include the accumulated transaction.
6. If the transaction execution is unsuccessful, indicated by the occurrence of an error during the run, we simply proceed without interruption. This indicates that the transaction is invalid and since there is still unused gas left in the block, we do not want to generate an error immediately. This is because no error has occurred within the block yet. However, it is highly likely that the transaction is invalid because it did something bad during execution or because the transaction pool is slightly outdated. In which case we allow ourselves to continue and try to get the next transaction from the pool into this block.
7. Once we verify there is no error with running the transaction we add the transaction to the transactions list and we add the gas that was returned by run to the gas used. For example if the first transaction was a simple transfer, which costs 21,000 gas our gas used would go from 0 to 21,000 nd we would keep doing this process steps 3-7 until the conditions of step 3 are met.
8. We finalize our transition by taking set of transactions and relevant block information to generate a fully assembled block. The purpose of doing this is to perform certain calculations at the end. Since the header contains the transactions root, receipts root, and withdrawals root, these values must be computed by merkleizing a list and added to the block's header.
   - We return our block, state DB and our error.

## Code walk-through

### Geth

The following example is using Geth codebase to explain how execution client builds a block.

 1. Firstly when a validator is chosen as a block builder it calls `engine_forkchoiceUpdatedV2` function via Engine API on the EL. Here, EL initiates the block building process.  
    - https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/eth/catalyst/api.go#L398 
 2. Most of the core logic of block building, and transaction execution resides in `miner` module of Geth. The `buildPayload` function initially creates an empty block so the node doesn't miss the slot and has something to propose. The function implementation also starts a go routine process whose job is to potentially fill the block which we left empty and then later update it with filled transactions concurrently.
    - https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/miner/payload_building.go#L180                                                                        - https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/miner/payload_building.go#L204
 3. In the `buildPayload` function, the go routine is waiting on multiple communication operations "cases" and in the first case it calls `getSealingBlock` with params which explicitly specify that the block should not be empty. Look at the `fullParams` variable i.e `noTxs:False`.
 4. In the definition for `getSealingBlock`, the request is being sent on `getWorkCh` channel. This channel is being listened on in order to retrieve data from it and generate work. 
    - [https://github.com/ethereum/goethereum/blob/master/miner/worker.go#L1222](https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/miner/worker.go#L1222)
 5. This `getWorkCh` channel is being listened on inside `mainLoop` function in the same file. The data which comes from the `getWorkCh` channel is then sent to `w.generateWork`.
    - https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L537
 6. `generateWork`  function is where transactions get filled inside the block.
    - https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/miner/worker.go#L1094
 7. `w.fillTransactions` function retrieves all the pending transactions from the mempool and fills the block. This includes all types of transactions, including blobs.
    - https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L1024
 8. Transactions are filled with ordering based on their fee and then passed to `commitTransactions` function.  
https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L1072
 9. `commitTransactions` function checks that for each transaction we have enough gas left and then commits that particular transaction. Also there is a certain number of blobs allowed per block as specified in eip-4844.  
     - https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L888 
     - https://github.com/ethereum/EIPs/blob/master/EIPS/eip-4844.md
 10. If you look into the `commitTransaction`  function it in return calls `w.applyTransaction` function.
    - https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L760C18-L760C36 
 11. `applyTransaction` function then goes onto call the core package and calls `core.ApplyTransaction` which executes all the transactions against the local EL state.  
    - https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L794.
 12. `ApplyTransaction` function runs the transaction against the local EL state and carries out all the state changes. It creates EVM contexts and environments to execute the transactions in the EVM. The contract calls also all happen here. If all goes well the state is transitioned successfully.     
     - https://github.com/ethereum/go-ethereum/blob/master/core/state_processor.go#L161
13. Also transaction can fail. If transaction fails, it's not applied to the state transition. It can fails due to onchain reasons, e.g. running out of gas, failed contract calls, etc.
14. From this point on after, all transactions are executed one by one. The transactions are then bundled into a block.  
15. CL then requests EL via Engine API to get this transaction filled with a payload `getPayload`. EL returns this payload to the CL which puts this payload to the beacon block and propagates it.
 
## Resources
1. [GETH codebase](https://github.com/ethereum/go-ethereum)
2. [Engine API: A Visual Guide](https://hackmd.io/@danielrachi/engine_api)
