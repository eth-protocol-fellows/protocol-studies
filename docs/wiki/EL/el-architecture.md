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

1.  **New Payload** *(V1/V2/V3)*: payload validation & insertion pipeline.
2.  **Fork Choice Updated** *(V1/V2/V3)*: state synchronization & block building pipeline.

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
3. Once the header verification is completed, we consider the environment in the header as the environment in which the transactions should be executed and we apply the transactions. We iterate over the transactions in the block and execute each transaction in the evm.
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

TODO Link to block-production file

###### Geth

TODO

#### Methods

##### New payload

TODO

###### Geth

TODO

###### Reth

TODO

##### Fork choice updated

TODO

###### Geth

TODO

###### Reth

TODO

### Boot nodes and network bootup

TODO

### Execution layer's blockChain

TODO

### Internal Consensus engines

TODO 

#### Geth

TODO

### Downloader

### Transaction Pools

In Ethereum two primary types of transaction pools are recognized.

#### Geth

In Ethereum two primary types of transaction pools are recognized:

1. **Legacy Pools**: Managed by Geth, these pools employ price-sorted heaps or priority queues to organize transactions based on their price. Specifically, transactions are arranged using two heaps: one prioritizes the effective tip for the upcoming block, and the other focuses on the gas fee cap. During periods of saturation, the larger of these two heaps is selected for the eviction of transactions, optimizing the pool's efficiency and responsiveness. [urgent and floating heaps](https://github.com/ethereum/go-ethereum/blob/064f37d6f67a012eea0bf8d410346fb1684004b4/core/txpool/legacypool/list.go#L525)

2. **Blob Pools**: Unlike legacy pools, blob pools maintain a priority heap for transaction eviction but incorporate distinct mechanisms for operation. Notably, the implementation of blob pools is well-documented, with an extensive comments section available for review [here](https://github.com/ethereum/go-ethereum/blob/064f37d6f67a012eea0bf8d410346fb1684004b4/core/txpool/blobpool/blobpool.go#L132). A key feature of blob pools is the use of logarithmic functions in their eviction queues.

### EVM

TODO Link to wiki page

### DevP2P

TODO Link to wiki page

### MPT

TODO Link to wiki page

### RLP

TODO Link to wiki page

### StateDB

TODO
