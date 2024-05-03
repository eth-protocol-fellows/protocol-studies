# Client Architecture

## Overview

Beyond execution layer's fundamental role of transaction execution, the execution layer client undertakes several critical responsibilities. These include verification of the blockchain data and storing its local copy, facilitating network communication through gossip protocols with other execution layer clients, maintaining a transaction pool, and fulfilling the consensus layer's requirements that drive its functionality. This multifaceted operation ensures the robustness and integrity of the Ethereum network.

The client's architecture is built around a variety of specific standards, each of which plays a unique role in the overall functionality. The execution engine is located at the top, driving the execution layer, which in turn is driven by the consensus layer. The execution layer runs on top of DevP2P, the networking layer, which is initialized by providing legitimate boot nodes that provide an initial access point into the network. When we call one of the engine API methods, such as fork choice updated, we can download blocks from peers by subscribing to topics like our preferred mode of sync.

<img src="images/el-architecture/architecture-overview.png" width="1000"/>

The diagram illustrates a simplified representation of the design, excluding several components.

**EVM**

Ethereum is centered around a virtualized central processing unit (CPU). Computers have their own central processing units (CPUs) at a hardware level, which can be of many types such as x86, ARM, RISC-V, or others. These varied processor architectures have unique instruction sets that enable them to perform tasks such as arithmetic, logic, and data manipulation, allowing the computer to function as a general-purpose computing machine. Therefore, when executing a program written in the hardware-level instruction set, the outcome may vary depending on the specific hardware on which it is executed. Thus In computer science, we address this problem by virtualizing instruction sets through the creation of virtual machines, such as the JVM (Java Virtual Machine). These virtual machines ensure consistent results regardless of the underlying hardware. The EVM is a virtualized execution engine designed for ethereum programs. It ensures consistent results regardless of the hardware it runs on and facilitates consensus among all Ethereum clients regarding computation outcomes.

In addition, Ethereum incorporates a sandwich complexity model as part of its design philosophy. This implies that the outer layers should be uncomplicated, while all the intricacy should be concentrated in the middle layers. In this context, the EVM's code can be seen as the outermost layer, while a high-level language like Solidity may be considered as the top layer. In between, there is a complicated compiler that translates the solidity code into the EVM's bytecode.

**State**

Ethereum is a general purpose computational system that operates as a state machine, meaning it may transition between several states depending on the inputs it receives. In addition, Ethereum differs significantly from other blockchains like Bitcoin in that it maintains a global state, whereas Bitcoin only keeps global unspent transaction outputs (UTXOs). The term "state" refers to the comprehensive collection of data, data structures (such as Merkle-Patricia Tries), and databases that store various information. This includes addresses, balances, code and data for contracts, as well as the current state and network state.

**Transactions**

The EVM produces data and modifies the state of the Ethereum network through a process called state transition. This state transition is triggered by transactions, which are processed within the EVM. If a transaction is deemed legitimate, it results in a state change of the Ethereum network.

**DevP2P**

The interface for communicating with other  the execution layer clients. Transactions initially stored in the mempool, which serves as a repository for all incoming transactions, are disseminated by execution layer clients to other execution layer clients in the network using peer-to-peer communication. Every recipient of the transaction sent over the network confirms its validity before broadcasting it to the network.

**JSON-RPC API**

When utilizing a wallet or a DApp, our communication with the execution layer is conducted over a standardized JSON-RPC API. This enables us to externally query the Ethereum state or dispatch a transaction to it, signed by the wallet, which is subsequently validated by the execution layer client and disseminated around the network.

**Engine API**

This is the only link between the consensus and execution layer. The engine exposes two major classes of endpoints to the consensus layer: **fork choice updated** and **new payload** suffixed by the three versions they are exposed as (V1-V3).These methods encapsulate two major pipelines offered by the execution layer:

1.  **New Payload** _(V1/V2/V3)_: payload validation & insertion pipeline.
2.  **Fork Choice Updated** _(V1/V2/V3)_: state synchronization & block building pipeline.

**Sync**

In order to accurately process transactions on Ethereum, it is imperative that we reach a consensus on the global status of the network, rather than solely relying on our local perspective. The global state synchronization of the execution layer client is triggered by the fork choice rule governed by the LMD-GHOST algorithm in the consensus layer. It is then relayed to the execution layer through the fork choice updated endpoint of the engine API. Syncing entails two possible processes: downloading remote blocks from peers and validating them in the EVM.

## Components of the architecture

### Engine

The execution layer client acts as an _execution engine_ and exposes the Engine API, an authenticated endpoint, which connects to the consensus layer client. The engine is also referred to as the external consensus engine by the execution layer clients. The execution layer client can be only be driven by a single consensus layer, but a consensus layer client implementations can connect to multiple execution layer clients for redundancy. The Engine API uses the JSON-RPC interface over HTTP and requires authentication via a [JWT](https://jwt.io/introduction) token. Additionally the Engine JSON-RPC is not exposed to anyone besides the consensus layer. However, it's important to note that the JWT is primarily used for authenticating the Payload, i.e. sender is the consensus layer client, it does not encrypt the traffic.

#### Routines

##### Payload validation

Payload is validated with respect to the block header and execution environment rule sets:

<img src="images/el-architecture/payload-validation-routine.png" width="1000"/>

With the merge, the function of the execution layer has been altered within the Ethereum network. Previously, it was tasked with the responsibility of managing the consensus of the blockchain, ensuring the correct order of blocks, as well as handling reorganizations. However, after the merge, these tasks have been delegated to the consensus layer, resulting in a significant simplification of the execution layer. Now, we can conceptualize the execution layer as primarily carrying out the state transition function.

In order to gain a better understanding of the aforementioned concept, it is beneficial to examine the perspective of the consensus layer in relation to the execution layer. The consensus specification defines the _process execution payload_ in the deneb beacon chain specs, which is carried out by the beacon chain while undergoing several verifications required to validate a block and advance the consensus layer. The execution layer here is represented by the `execution_engine` function, which serves as a means of communication between the consensus layer and the execution layer and has a lot of varied complexities to it.

During _process execution payload_ , we begin by conducting several high-level checks, including verifying the accuracy of the parent hash and validating the timestamp. Additionally, we perform various lightweight verifications. Subsequently, we transmit the payload to the execution layer, where it undergoes block verification. The notify payload function, is the lowest level function that serves as the interface between the consensus layer and the execution engine. It contains only the function's signature, without any implementation details. Its sole purpose is to transmit the execution payload to the execution engine, which acts as the client for the execution layer. The execution engine then carries out the actual state transition function, which involves verifying the accuracy of block headers and ensuring that transactions are correctly applied to the state. The execution engine will ultimately return a boolean value indicating whether the state transition was successful or not. From the standpoint of the consensus layer, this is simply the validation of blocks.

This is a simplified description of the block level state transition function (stf) in go. The stf is a crucial component of the block validation and insertion pipeline. Although the example is specific to Geth, it represents the functioning of the stf in other clients as well. It is worth mentioning that the state transition function is rarely referred to by its name in the code of different clients, save for the EELS python spec client. This is because its real operations are divided across many components of the client's architecture.

```go
func stf(parent types.Block, block types.Block, state state.StateDB) (state.StateDB, error) { //1
    if err := core.VerifyHeaders(parent, block); err != nil { //2
            // header error detected
            return nil, err
  }
  for _, tx := range block.Transactions() { //3
      res, err := vm.Run(block.header(), tx, state)
      if err != nil {
              // transaction invalid, block is invalid
              return nil, err
      }
      state = res
  }
  return state, nil
}
```

1. State transition function's parameters and return values
   - In this context, we examine both the parent block and the current block in order to validate certain transition logic from the parent block to the current block.
   - We take the state DB in as an argument, which contains all the state data related to the parent block. This represents the most recent valid state.
   - We return the state DB representing the updated state after the state transition
   - if the state transition fails we don't update the state DB and return the error
2. In the state transition functions procedure we first verify the headers
   - As an illustration of the failure of header verification, let us consider the gas limit field, which is also of historical significance. Currently, the gas limit stands at around 30 million. It's important to note that the gas limit is not fixed within the execution layer. Block producers have the capacity to modify the gas limit using a technique that allows them to increase or decrease it by 1/1024th of the gas limit of the preceding block. Therefore, if you raise the gas limit from 30 million to 40 million within a single block, the header verification will fail because it exceeds the threshold of 30 million plus one-thousandth of 30 million.
   - Additional instances of header verification failure can arise when the block numbers are not in sequential order. Typically, the beacon chain is responsible for detecting such discrepancies, although there are instances where it is detected at this stage as well. Failures may also arise when the 1559 base fee is not accurately updated according to the comparison between the last gas used and the gas limit.
3. Once the header verification is completed, we consider the environment in the header as the environment in which the transactions should be executed and we apply the transactions. We iterate over the transactions in the block and execute each transaction in the EVM.
   - The block headers are passed to the EVM in order to provide the necessary context for processing the transaction. This context includes instructions such as coinbase, gas limit, and timestamp, which are required for proper execution.
   - Additionally we pass in the transaction and the state
   - In the event of a failed execution, we simply return the error, indicating an invalid transaction within the block and thereby rendering the block invalid. Within the execution layer, the presence of anything erroneous in a block renders the entire block invalid, as it contaminates the block as a whole.
   - Once we confirm the validity of the transactions, we proceed to update our state with the result . The state now represent the accumulated state that has all the transaction in the new block applied to it.

From the standpoint of beacon chains, the state transition function mentioned above is encompassed by the invocation of the "new payload" function.

```go
func newPayload(execPayload engine.ExecutionPayload) bool {
    if _, err := stf(..); err != nil {
        return false
  }
  return true
}
```

The beacon chain  invokes the new payload function and transfers the execution payload as an argument. On the execution layer, we invoke the state transition function using the information from the execution payload. If the state transition function does not produce an error, we return true. Otherwise, we return false to indicate that the block is invalid.

##### Geth

TODO: STF code links and walk through in Geth

##### Sync

TODO

##### Payload building

More details in [block production](/wiki/EL/block-production.md)

###### Geth

TODO

#### Methods

##### New payload

Validates the payload that was built earlier by the payload building routine.

<img src="images/el-architecture/new-payload.png" width="1000"/>

###### Geth

TODO

###### Reth

TODO

##### Fork choice updated

Proof-of-stake LMD-GHOST fork choice rule & payload building routine instantiation.

<img src="images/el-architecture/forkchoice-updated.png" width="1000"/>

###### Geth

TODO

###### Reth

TODO

### Internal Consensus engines

The execution layer has its own consensus engine to work with its own copy of the beacon chain. The execution layer consensus engine is known as ethone and has about half the functionality of the full fledged consensus engine of the consensus layer.

| Function                                                                                                                                        | Beacon (Proof-of-stake)                                                                                                                                                                                                                                                                                                                                                                                                                                 | Clique (Proof-of-authority)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Ethash (Proof-of-work) |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| **Author**: Eth address of the block minter                                                                                                     | If the header is classified as a Proof of Stake (PoS) header, with a header difficulty set to 0, we will retrieve the header's coinbase. Otherwise, we will forward the header to the beacon's ethone engine (either clique or ethash) for further processing.                                                                                                                                                                                          | Obtains the account address that created the block. The process of recovering the public key from the header's extraData is performed by ecrerecover.                                                                                                                                                                                                                                                                                                                                                                     |                        |
| **Verify Header(s)**: Processes a batch of headers and validates them according to the rules of the current consensus engine. :                 | Split the headers based on [Terminal Total difficulty](https://eips.ethereum.org/EIPS/eip-3675#definitions) into pre and post TTD batches . Verify the pre batches with the ethone engine and the post by beacon's verify header.                                                                                                                                                                                                                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |                        |
|                                                                                                                                                 | Here we perform block header verification similar to the one in the [execution layer Specs](wiki/EL/el-specs?id=block-header-validation) wiki page and covered below in the client code table.                                                                                                                                                                                                                                                          | We verify the time of the header is not greater than system time.                                                                                                                                                                                                                                                                                                                                                                                                                                                         |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | If it is a checkpoint block (1'st slot of an epoch), then ensure it has no beneficiary.                                                                                                                                                                                                                                                                                                                                                                                                                                   |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | The header nonce can take on two values: 0x00..0, which indicates a vote to add a signer, or 0xff..f, which indicates a vote to drop a signer. However, at checkpoints, we can only vote to drop a signer.                                                                                                                                                                                                                                                                                                                |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | The extraData length mush account for vanity + signature. At checkpoints, the extraData contains the signer list + signature.                                                                                                                                                                                                                                                                                                                                                                                             |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Header gas checks.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Retrieve the snapshot                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | On checkpoint blocks verify the signers in the snapshot against the extraData                                                                                                                                                                                                                                                                                                                                                                                                                                             |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Invoke the verify Seal function to determine whether all the criteria for the signature included in the header have been satisfied. The recovery process involves extracting information from the header and the list of recent signers in the Clique object. We then verify whether the signer is included in the snapshot.                                                                                                                                                                                              |                        |     |
| **Verify Uncles**                                                                                                                               | If the Header is a Proof-of-stake header, check that the length of uncles is 0. If the header is not Proof-of-stake, the process of verifying uncles is done via the ethone engine.                                                                                                                                                                                                                                                                     | In Clique no uncles should be present                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |                        |
| **Prepare**: Initializes the consensus fields of a block's header.                                                                              | If TTD is reached we set the header's difficulty to beacon's difficulty of 0, else we call ethone's prepare                                                                                                                                                                                                                                                                                                                                             | Create the voting snapshot by supplying the parent hash and number.During the reverse iteration process, we start from the block number and proceed backwards. We stop the iteration if we reach the genesis block, if we are using a light client that doesn't store parent blocks, if we reach an epoch by traversing backwards, or if the headers traversed exceed the soft Finality value (indicating that the segment is considered immutable). At the checkpoint where we stop the iteration, we create a snapshot. |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | If we are at the end of an epoch, we will go through the addresses in the proposals field of the snap object and choose one randomly as the coinbase. If the proposal is authorized, we will cast an auth-vote; otherwise, we will cast a drop vote.                                                                                                                                                                                                                                                                      |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Set the header difficulty based on the signer's turn (2 if the signer is in turn and 1 if not)                                                                                                                                                                                                                                                                                                                                                                                                                            |                        |
|                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Verify that the extraData contains all the necessary elements, including extraVanity and a list of signers if the block occurs at the end of the epoch. This is added to the Header's extraData field.                                                                                                                                                                                                                                                                                                                    |                        |
| **Finalize**: After making changes to the state, the state database may be updated, but this action does not involve the assembly of the block. | If the header is not a Proof-of-stake header, we execute the finalize function of ethone. Otherwise, we loop through the withdrawals in the block, converting their amounts from wei to gwei. We then modify the state by adding the converted amount to the address associated with the current withdrawal.                                                                                                                                            | Clique has no post-transaction consensus rules, no block rewards in proof of authority                                                                                                                                                                                                                                                                                                                                                                                                                                    |                        |
| **FinalizeAndAssemble**: Finalizes and assemble the final block                                                                                 | If the header is not a Proof-of-stake header, we invoke ethone's FinalizeAndAssemble. If there are no withdrawals and the block is after the Shanghai fork, we include an empty withdrawals object. Next, we invoke the finalize function to calculate the state root. We then assign this value to the root property of the header object. Finally, we construct a new block by combining the header, transactions, uncles, receipts, and withdrawals. | Verify that there are no withdrawals, invoke the finalize function, calculate the state root of our stateDB, and assign it to the the Header . Construct a new block using the header, transactions, and receipts.                                                                                                                                                                                                                                                                                                        |                        |
| **Seal**: Generates a sealing request for a block and pushes the request into the given channel                                                 | If the header is not a Proof-of-stake header, we invoke ethone's seal. Otherwise, we take no action and return nil. The verification of the seal is performed by the consensus layer.                                                                                                                                                                                                                                                                   | Make sure that the block is not the initial block, obtain the snapshot, and confirm that we have the authority to sign and are not included in the list of recent signers. Coordinate the timing of our respective turns, apply the sign function to  sign, and transmit the securely sealed block through the designated channel.                                                                                                                                                                                        |                        |
| **SealHash**: Hash of the block prior to sealing                                                                                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |                        |
| **CalcDifficulty**: Difficulty adjustment algorithm, returns the difficulty of the new block                                                    |                                                                                                                                                                                                                                                                                                                                                                                                                                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |                        |

#### Client code

|                                                                                           | EELS(cancun)                                                                                                                                                                          | Geth | Reth | Erigon | Nethermind | Besu |
| ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ---- | ------ | ---------- | ---- |
| $V(H) \equiv H_{gasUsed} \leq H_{gasLimit}$                                        | [validate_header](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L294)                                         |      |      |        |            |      |
| $H_{gasLimit} < P(H)_{H_{gasLimit'}} + floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) $ | validate_header -> calculate_base_fee_per_gas -> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L256) |      |      |        |            |      |
| $H_{gasLimit} > P(H)_{H_{gasLimit'}} - floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) $ | ''                                                                                                                                                                                    |      |      |        |            |      |
| $H_{gasLimit} > 5000$                                                              | calculate_base_fee_per_gas -> [check_gas_limit](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L1132)          |      |      |        |            |      |
| $H_{timeStamp} > PH)_{H_{timeStamp'}} $                                           | validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L323)                                |      |      |        |            |      |
| $H_{numberOfAncestors} = PH)_{H_{numberOfAncestors'}} + 1 )$                       | validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L324)                                |      |      |        |            |      |
| $length(H_{extraData}) \leq 32_{bytes} $                                           | validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L325)                                |      |      |        |            |      |
| $H_{baseFeePerGas} = F(H) $                                                        |                                                                                                                                                                                       |      |      |        |            |      |
| $H_{parentHash} = KEC(RLP( P(H)_H ))  $                                            | validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L332)                                |      |      |        |            |      |
| $H_{ommersHash} = KEC(RLP(())) $                                                   | validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L329)                                |      |      |        |            |      |
| $H_{difficulty} = 0 $                                                              | validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L327)                                |      |      |        |            |      |
| $H_{nonce} = 0x0000000000000000 $                                                  | validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L328)                                |      |      |        |            |      |
| $H_{prevRandao} = PREVRANDAO()  $ (this is stale , beacon chain provides this now) |                                                                                                                                                                                       |      |      |        |            |      |
| $H_{withdrawlsHash} \neq nil $                                                     |                                                                                                                                                                                       |      |      |        |            |      |
| $H_{blobGasUsed} \neq nil $                                                        |                                                                                                                                                                                       |      |      |        |            |      |
| $H_{blobGasUsed} \leq  MaxBlobGasPerBlock_{=786432}  $                             |                                                                                                                                                                                       |      |      |        |            |      |
| $H_{blobGasUsed} \% GasPerBlob_{=2^{17}} = 0 $                                     |                                                                                                                                                                                       |      |      |        |            |      |
| $H_{excessBlobGas} = CalcExcessBlobGas(P(H)_H) $                                   | [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L187)                                                 |      |      |        |            |      |

### Downloader

### Transaction Pools

In Ethereum two primary types of transaction pools are recognized.

#### Geth

In Ethereum two primary types of transaction pools are recognized:

1. **Legacy Pools**: Managed by Geth, these pools employ price-sorted heaps or priority queues to organize transactions based on their price. Specifically, transactions are arranged using two heaps: one prioritizes the effective tip for the upcoming block, and the other focuses on the gas fee cap. During periods of saturation, the larger of these two heaps is selected for the eviction of transactions, optimizing the pool's efficiency and responsiveness. [urgent and floating heaps](https://github.com/ethereum/go-ethereum/blob/064f37d6f67a012eea0bf8d410346fb1684004b4/core/txpool/legacypool/list.go#L525)

2. **Blob Pools**: Unlike legacy pools, blob pools maintain a priority heap for transaction eviction but incorporate distinct mechanisms for operation. Notably, the implementation of blob pools is well-documented, with an extensive comments section available for review [here](https://github.com/ethereum/go-ethereum/blob/064f37d6f67a012eea0bf8d410346fb1684004b4/core/txpool/blobpool/blobpool.go#L132). A key feature of blob pools is the use of logarithmic functions in their eviction queues.

### EVM

[Wiki - EVM](/wiki/EL/evm.md)
TODO: Move relevant code from specs into EVM

### DevP2P

[Wiki - DevP2P](/wiki/EL/devp2p.md)

### Data structures

More details in the page on [EL data structures](/wiki/EL/data-structures.md).

### Storage

Blockchain and state data processed by execution client need to be stored in the disk. These are necessary to validate new blocks, verify history and to serve peers in the network. Client stores historical data, also called the ancient database, which include previous blocks. Another database of trie structure contains the current state and small number of recent states. In practice, clients keep various databases for different data categories. Each client can implement a different backend to handle this data, e.g. leveldb, pebble, mdbx.

**Leveldb** 

TODO

**Pebble** 

TODO

**MDBX**.

Read more about its [features](https://github.com/erthink/libmdbx#features). Additionally, boltdb has a page on comparisons with other databases such as leveldb, [here](https://github.com/etcd-io/bbolt#comparison-with-other-databases). The comparative points mentioned on bolt are applicable to mdbx.   

