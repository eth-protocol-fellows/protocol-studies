# Block building, processing, and applying transaction to state:

## Intro

Block building is a crucial task for the Ethereum blockchain's functionality, involving various processes determining how a validator acquires a block before proposing it. Ethereum network consists of nodes running interconnected consensus (CL) and execution clients (EL). Both are essential for network participation and producing block at each slot. While the execution client (EL) has numerous important functionalities you can study more about it in the "el-architecture", a key focus here is its role in constructing blocks for consumption by CL.

When a validator is selected to propose a block during a slot, it looks for the block produced by CL. Importantly, a validator isn't limited to broadcasting a block solely from its own EL. It can also broadcast a block produced by external builders; for details, refer to [PBS](https://ethereum.org/en/roadmap/pbs/). This article specifically explores how a block is produced by EL and the elements contributing to its successful production and transaction execution.

## Code Walkthrough

The following example is using Geth codebase to explain how execution client builds a block.

 1. Firstly when a validator is chosen as a block builder it calls `engine_forkchoiceUpdatedV2` function via Engine API on the EL. Here, EL initiates the block building process.  
    - https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/eth/catalyst/api.go#L398 
 2. Most of the the core logic of block building, and transaction execution resides in `miner` module of Geth. The `buildPayload` function initially creates an empty block so the node doesn't miss the slot and has something to propose. The function implementation also starts a go routine process whose job is to potentially fill the block which we left empty and then later update it with filled transactions concurrently.
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
