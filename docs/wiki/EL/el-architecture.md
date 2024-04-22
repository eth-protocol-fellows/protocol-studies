# Client Architecture

## Overview

Beyond execution layer's fundamental role of transaction execution, the execution layer client undertakes several critical responsibilities. These include verification of the blockchain data and storing its local copy, facilitating network communication through gossip protocols with other execution layer clients, maintaining a transaction pool, and fulfilling the consensus layer's requirements that drive its functionality. This multifaceted operation ensures the robustness and integrity of the Ethereum network.

The client's architecture is built around a variety of specific standards, each of which plays a unique role in the overall functionality. The execution engine is located at the top, driving the execution layer, which in turn is driven by the consensus layer. The execution layer runs on top of devp2p, the networking layer, which is initialized by providing legitimate boot nodes that provide an initial access point into the network. When we call one of the engine API methods, such as fork choice updated, we can download blocks from peers by subscribing to topics like our preferred mode of sync.

<img src="images/el-architecture/architecture-overview.png" width="1000"/>

The diagram illustrates a simplified representation of the design, excluding several components.

**EVM**

Ethereum is centered around a virtualized central processing unit (CPU). Computers have their own central processing units (CPUs) at a hardware level, which can be of many types such as x86, ARM, RISC-V, or others. These varied processor architectures have unique instruction sets that enable them to perform tasks such as arithmetic, logic, and data manipulation, allowing the computer to function as a general-purpose computing machine. Therefore, when executing a program written in the hardware-level instruction set, the outcome may vary depending on the specific hardware on which it is executed. Thus In computer science, we address this problem by virtualizing instruction sets through the creation of virtual machines, such as the JVM (Java Virtual Machine). These virtual machines ensure consistent results regardless of the underlying hardware. The EVM is a virtualized execution engine designed for ethereum programs. It ensures consistent results regardless of the hardware it runs on and facilitates consensus among all ethereum clients regarding computation outcomes.

In addition, Ethereum incorporates a sandwich complexity model as part of its design philosophy. This implies that the outer layers should be uncomplicated, while all the intricacy should be concentrated in the middle layers. In this context, the EVM's code can be seen as the outermost layer, while a high-level language like Solidity may be considered as the top layer. In between, there is a complicated compiler that translates the Solidity code into the EVM's bytecode.

**State**

Ethereum is a general purpose computational system that operates as a state machine, meaning it may transition between several states depending on the inputs it receives.In addition, Ethereum differs significantly from other blockchains like Bitcoin in that it maintains a global state, whereas Bitcoin only keeps global unspent transaction outputs (UTXOs). The term "state" refers to the comprehensive collection of data, data structures (such as Merkle-Patricia Tries), and databases that store various information. This includes addresses, balances, code and data for contracts, as well as the current state and network state.

**Transactions**

The EVM produces data and modifies the state of the Ethereum network through a process called state transition. This state transition is triggered by transactions, which are processed within the EVM. If a transaction is deemed legitimate, it results in a state change of the Ethereum network.

**Devp2p**

The interface for communicating with other  the execution layer clients. Transactions initially stored in the mempool, which serves as a repository for all incoming transactions, are disseminated by execution layer clients to other execution layer clients in the network using peer-to-peer communication. Every recipient of the transaction sent over the network confirms its validity before broadcasting it to the network.

**JSON-RPC API**

When utilizing a wallet or a DApp, our communication with the execution layer is conducted over a standardized JSON-RPC API. This enables us to externally query the Ethereum state or dispatch a transaction to it, signed by the wallet, which is subsequently validated by the execution layer client and disseminated around the network.

**Engine API**

This is the only link between the consensus and execution layer. The engine exposes two major classes of endpoints to the consensus layer: **fork choice updated** and **new payload** suffixed by the three versions they are exposed as (V1-V3).These methods encapsulate two major pipelines offered by the execution layer :

1.  **New Payload\***(V1/V2/V3)\*: payload validation & insertion pipeline.
2.  **Fork Choice Updated\***(V1/V2/V3)\*: state synchronization & block building pipeline.

**Sync**

In order to accurately process transactions on Ethereum, it is imperative that we reach a consensus on the global status of the network, rather than solely relying on our local perspective. The global state synchronization of the execution layer client is triggered by the fork choice rule governed by the LMD-GHOST algorithm in the consensus layer. It is then relayed to the execution layer through the fork choice updated endpoint of the engine API. Syncing entails two possible processes: downloading remote blocks from peers and validating them in the EVM.

Note: client specific overviews will go here

### Reth

The image represents a rough component flow of reth's architecture:
<img src="images/el-architecture/reth-architecture-overview.png" width="1000"/>

- **Engine**: Similar to other clients, it is the primary driver of reth.
- **Sync**: Reth has two modes of sync historical and live
- **Pipeline**: The pipeline performs historical sync in a sequential manner, enabling us to optimize each stage of the synchronization process. The pipeline is split into stages , where a [stage](https://paradigmxyz.github.io/reth/docs/reth_stages/trait.Stage.html) is a trait that provides us with a function to execute the stage or unwind (undo) it. Currently the pipeline has 12 stages that can be configured, with the first two running separately, the pipeline proceeds top to bottom excpet when there is a problem encountered then it proceeds to unwind from the issue stage upwards :
  1. **HeaderStage**: Header verification stage.
  2. **BodyStage**: Download blocks over p2p.
  3. **SenderRecoveryStage**: The computation is costly as it retrieves the sender's address from the signature for each transaction in the block's body.
  4. **ExecutionStage**: The most time-consuming & computationally heavy stage involves taking the sender, transaction, and header and executing them within the revm. This process generates receipts and change sets. Change sets are data structures that function as hash maps and depict the modifications that occur between accounts inside a single block. In addition, the execution stage operates on a plain state that contains only the addresses and account information in the form of key-value pairs.
  5. **MerkleStage** (unwind): Skipped during the execution flow, used when unwinding.
  6. **AccountHashingStage**: Required by the merkle stage,we take the plain state and apply a hashing function to it. Then, we save the resulting hashed account in a database specifically designed for storing accounts.
  7. **StorageHashingStage**: Similar to above but for storage.
  8. **MerkleStage** (execute): generates a state root by using the hashes produced by the two preceding stages and then checks if the resulting state root is accurate for the given block.
  9. **TransactionLookupStage**: Helper stage, allows us to do transaction lookup.
  10. **IndexStorageHistoryStage**: Enables us to retrieve past data, the execution phase generates the change set, which then indexes the data that existed prior to the execution of the block. Enables us to retrieve the historical data for any given block number.
  11. **IndexAccountHistoryStage**: Similar to above.
  12. **FinishStage**:We notify that the engine is now capable of receiving new fork choice updates from the consensus layer's.
- **BlockchainTree**: When we are nearing the end of the chain during the syncing process, we transition to the blockchain tree. The synchronization occurs close to the tip, when state root validation and execution take place in memory.
- **Database**: When a block gets canonicalized, it is moved to the database
- **Provider**: An abstraction over database that provides utility functions to help us avoid directly accessing the keys and values of the underlying database.
- **Downloader**: Retrieves blocks and headers using peer-to-peer (p2p) networks. This tool is utilized by the pipeline during its initial two stages and by the engine in the event that it need to bridge the gap at the tip.
- **P2P**: When we approach the tip, we transfer the transactions we have read over p2p to the transaction pool.
- **Transaction Pool**: Includes DDoS mitigation measures. Consists of transactions arranged in ascending order based on the gas price preferred by the users.
- **Payload Builder**: Extracts the initial n transactions in order to construct a fresh payload.
- **Pruner**: Allows us to have a full node.Once the block has been canonicalized by the blockchain tree, we must wait for an additional 64 blocks for it to reach finalization. Once the finalization process is complete, we can be certain that the block will not undergo reorganization. Therefore, if we are operating a full node, we have the option to eliminate the old block using the pruner.

## Components of the Architecture

### Engine

The execution layer client acts as an _execution engine_ and exposes the Engine API, an authenticated endpoint, which connects to the consensus layer client. The engine is also referred to as the external consensus engine by the execution layer clients. The execution layer client can be only be driven by a single consensus layer, but a consensus layer client implementations can connect to multiple execution layer clients for redundancy. The Engine API uses the JSON-RPC interface over HTTP and requires authentication via a [JWT](https://jwt.io/introduction) token. Additionally the Engine JSON-RPC is not exposed to anyone besides the consensus layer. However, it's important to note that the JWT is primarily used for authenticating the Payload, i.e. sender is the consensus layer client, it does not encrypt the traffic.

> Note: Everything is WIP below this, the notes below don't reflect the final version

#### Routines

##### Sync

TODO

##### Payload Validation

TODO

#### Methods

##### New Payload

TODO

###### Geth

TODO

###### Reth

TODO

##### Fork Choice Updated

This method expects two parameters:

- **Fork Choice State** :

This parameter provides the required information for the execution layer to initiate a state sync

|                      |                                                                                                                                                                             |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Head Block Hash      | Hash of the head block of the cannonical chain, the execution layer starts the block downloading process for state syncronization in reverse order starting from this block |
| Safe Block Hash      | Represents the justified block hash                                                                                                                                         |
| Finalized Block Hash | The latest finalised block of the cannonical chain                                                                                                                          |

We can view all the three parameters in [Forky](https://forky.mainnet.ethpandaops.io/), with justified block hash appearing at the boundary of the previous to the current epoch and the finalized block an epoch prior the justified block.

- **Payload Attributes** :

Note: Will only be sent set from the consensus layer for the block building pipeline else this parameter will be set to null , which indicates only state syn needs to be initiated during the method's call

|                          |                                                                                                                                                                                                                       |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Timestamp                | Represents the value that will be used by the field of the new payload                                                                                                                                                |
| Prev Randao              | Value generated by the consensus layer, like above, will be used in the new payload field with the same name                                                                                                          |
| Suggested Fee Recipient  | The recipient of block rewards maps to the coinbase field in the generated block's header                                                                                                                             |
| Withdrawls               | Array of withdrawals, each witdrawl represent and object of {index,validatorIndex,address, amount} Note: The amount value is represented asa little-endian value of Gwei that must be converted to a big-endian value |
| Parent Beacon Block Root | Root of the parent beacon block                                                                                                                                                                                       |

- Procedure:
  1.  The execution layer client **may** initiate a sync if the **head block hash** refers to a block that the execution layer client has not seen or if the ancestors required for validation of the block are missing. Thus sync is specified as the process of obtaining data required to validate a payload, with these two optional stages :
      1. Fetching data from remote peers
      2. Passing ancestors of a payload through the payload validation routine, which consists of validating a payload with respect to the rule sets for block header and execution environment :
         1. The client **may** obtain a parent state by executing the ancestors of a payload, i.e. each ancestor must pass the payload validation process
         2.

###### Geth

TODO

###### Reth

TODO

### Boot Nodes and Network Bootup

### Execution Layer's BlockChain

### Internal Consensus Engines

The execution layer has its own consensus engine to work with its own copy of the beacon chain. The execution layer consensus engine is known as ethone and has about half the functionality of the full fledged consensus engine of the consensus layer.

#### Geth

In geth, the algorithm agnostic interface of the consensus engine in execution layer has these functions

| Function                                                                                                               | Beacon (Proof-of-stake)                                                                                                                                                                                                                                                                                                                  | Clique (Proof-of-authority)                                                                                                                                                                                                                                                                                                                                                                                                                                                | Ethash (Proof-of-work) |
| ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| **Author**: Eth address of the block minter                                                                            | If the header is a PoS header (header difficulty is set to 0) then we return the header's coinbase else we send the header for processing to the beacon's ethone engine (clique or ethash)                                                                                                                                               | Retrieves the account address the minted the block. In Clique , this done by ecrerecover that recovers the public key from the header's extraData                                                                                                                                                                                                                                                                                                                          |                        |
| **Verify Header(s)**: Takes a batch of headers and verifies them based on the rules of the current consensus engine. : | Split the headers based on [Terminal Total difficulty](https://eips.ethereum.org/EIPS/eip-3675#definitions) into pre and post TTD batches . Verify the pre batches with the ethone engine and the post by beacon's verify header                                                                                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |                        |
|                                                                                                                        | Here we perform block header verification similar to the one in the [execution layer-Specs](wiki/EL/el-specs?id=block-header-validation) wiki page                                                                                                                                                                                       | We verify the time of the header is not greater than system time.                                                                                                                                                                                                                                                                                                                                                                                                          |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | If it is a checkpoint (1'st slot of epoch) block then ensure it has no beneficiary.                                                                                                                                                                                                                                                                                                                                                                                        |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | The header nonce can be either 0x00..0 (represents vote to add signer) or 0xff..f (represents vote to drop signer ), At checkpoints we can only drop the signer.                                                                                                                                                                                                                                                                                                           |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | The extradata length mush account for vanity + the signature. At Checkpoints, the extradata contains the signer list + signature.                                                                                                                                                                                                                                                                                                                                          |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | Header gas checks.                                                                                                                                                                                                                                                                                                                                                                                                                                                         |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | Retrieve the snapshot (config: Config for Consensus engine, signatureLRUCache: Cache speed up ecrecover, SnapshotBlockNumber, SnapshotBlockHash, Signers: authorized signers at this point , RecentSigners: used for spam protections, Votes : Chronologically ordered votes that were cast, VoteTally )                                                                                                                                                                   |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | On checkpoint blocks verify the signers in the snapshot against the extradata                                                                                                                                                                                                                                                                                                                                                                                              |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | Verify Seal : Verifies if all the requirements are met for the signature contained in the header. This is recovered using the header, and the recent signers in the Clique object, then we check the signer is included in the snapshot.signers obtained in step 6.                                                                                                                                                                                                        |                        |     |
| **Verify Uncles**                                                                                                      | If the Header is a PoS header verify the length of uncles is 0. If not PoS, ethone's verify uncles is called                                                                                                                                                                                                                             | In Clique no uncles should be present                                                                                                                                                                                                                                                                                                                                                                                                                                      |                        |
| **Prepare**: Initializes the consensus fields of a block's header.                                                     | If TTD is reached we set the header's difficulty to beacon's difficulty(0) , else we call ethone's prepare                                                                                                                                                                                                                               | Assemble the voting snapshot by providing the parent hash and number.We iterate backwards from the block number, if we reach genesis or if we are using a light client (which doesn't store parent blocks) or if we reach an epoch by traversing backwards or if the headers traversed are greater than the value for soft Finality (which implies the segment is considered immutable) we create a snapshot at the checkpoint we have arrived at during reverse iteration |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | If we are not at the end of an epoch we iterate over the addresses in proposals field of the snap object and randomly select one as the coinbase; voting auth-vote if the proposal is authorized else we cast a drop vote.                                                                                                                                                                                                                                                 |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | Set the header difficulty based on signer's turn (2 if the signer is in turn and 1 if not)                                                                                                                                                                                                                                                                                                                                                                                 |                        |
|                                                                                                                        |                                                                                                                                                                                                                                                                                                                                          | Ensure the extradata has all the required components such as extraVanity, list of signers if the block is at the end of the epoch. We add this to the Header.extraData.                                                                                                                                                                                                                                                                                                    |                        |
| **Finalize**: Post state modifications, state db might get updated, this does not assemble the block                   | If not a PoS header we call ethone's finalize else we iterate over the block's withdrawals, converting their amounts from wei to gwei and then making a state modification that adds the amount to the address in the current withdrawal                                                                                                 | Clique has no post-transaction consensus rules, no block rewards in proof of authority                                                                                                                                                                                                                                                                                                                                                                                     |                        |
| **FinalizeAndAssemble**: Finalises and assemble the final block                                                        | If not a PoS header we call ethone's FinalizeAndAssemble, If withdrawals are nil, and the block is after the shanghai fork, we add an empty withdrawals object. Then we call finalize, compute the state root and assign it to header's root and build a new block block with the header, transactions, uncles, receipts and withdrawals | Ensure no withdrawals are present, call finalize, compute the state root of our stateDB and assign it to Header's root and build a new block with the header, transactions and receipts                                                                                                                                                                                                                                                                                    |                        |
| **Seal**: Generates a sealing request for a block and pushes the request into the given channel                        | If Not a PoS header we call ethone's seal, else we do nothing and return nil (seal verification is done by the external consensus engine)                                                                                                                                                                                                | Ensure it's not the genesis block, retrieve the snapshot and verify that we are both authorized to sign and are not part of the recent signers, time synchronize our turn , sign with the sign function and propagate the sealed block on the given channel                                                                                                                                                                                                                |                        |
| **SealHash**: Hash of the block prior to sealing                                                                       |                                                                                                                                                                                                                                                                                                                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |                        |
| **CalcDifficulty**: Difficulty adjustment algorithm, returns the difficulty of the new block                           |                                                                                                                                                                                                                                                                                                                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |                        |

### Downloader

### Transaction Pools

In Ethereum two primary types of transaction pools are recognized:

1. **Legacy Pools**: Managed by geth, these pools employ price-sorted heaps or priority queues to organize transactions based on their price. Specifically, transactions are arranged using two heaps: one prioritizes the effective tip for the upcoming block, and the other focuses on the gas fee cap. During periods of saturation, the larger of these two heaps is selected for the eviction of transactions, optimizing the pool's efficiency and responsiveness. [urgent and floating heaps](https://github.com/ethereum/go-ethereum/blob/064f37d6f67a012eea0bf8d410346fb1684004b4/core/txpool/legacypool/list.go#L525)

2. **Blob Pools**: Unlike legacy pools, blob pools maintain a priority heap for transaction eviction but incorporate distinct mechanisms for operation. Notably, the implementation of blob pools is well-documented, with an extensive comments section available for review [here](https://github.com/ethereum/go-ethereum/blob/064f37d6f67a012eea0bf8d410346fb1684004b4/core/txpool/blobpool/blobpool.go#L132). A key feature of blob pools is the use of logarithmic functions in their eviction queues.

### EVM

### DevP2P

### MPT

### RLP

### StateDB

#### Reth

TODO: Add DB and tables walk-through from week 7
