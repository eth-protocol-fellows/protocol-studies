# Reth architecture

## Overview

The image represents a rough component flow of reth's architecture:

<img src="images/el-architecture/reth-architecture-overview.png" width="1000"/>

- **Engine**: Similar to other clients, it is the primary driver of reth.
- **Sync**: Reth has two modes of sync historical and live
- **Pipeline**: The pipeline performs historical sync in a sequential manner, enabling us to optimize each stage of the synchronization process. The pipeline is split into stages , where a [stage](https://paradigmxyz.github.io/reth/docs/reth_stages/trait.Stage.html) is a trait that provides us with a function to execute the stage or unwind(undo) it. Currently the pipeline has 12 stages that can be configured, with the first two running separately, the pipeline proceeds top to bottom except when there is a problem encountered then it proceeds to unwind from the issue stage upwards :
  1. **HeaderStage**: Header verification stage.
  2. **BodyStage**: Download blocks over P2P.
  3. **SenderRecoveryStage**: The computation is costly as it retrieves the sender's address from the signature for each transaction in the block's body.
  4. **ExecutionStage**: The most time-consuming & computationally heavy stage involves taking the sender, transaction, and header and executing them within the REVM. This process generates receipts and change sets. Change sets are data structures that function as hash maps and depict the modifications that occur between accounts inside a single block. In addition, the execution stage operates on a plain state that contains only the addresses and account information in the form of key-value pairs.
  5. **MerkleStage**(unwind): Skipped during the execution flow, used when unwinding.
  6. **AccountHashingStage**: Required by the merkle stage,we take the plain state and apply a hashing function to it. Then, we save the resulting hashed account in a database specifically designed for storing accounts.
  7. **StorageHashingStage**: Similar to above but for storage.
  8. **MerkleStage**(execute): generates a state root by using the hashes produced by the two preceding stages and then checks if the resulting state root is accurate for the given block.
  9. **TransactionLookupStage**: Helper stage, allows us to do transaction lookup.
  10. **IndexStorageHistoryStage**: Enables us to retrieve past data, the execution phase generates the change set, which then indexes the data that existed prior to the execution of the block. Enables us to retrieve the historical data for any given block number.
  11. **IndexAccountHistoryStage**: Similar to above.
  12. **FinishStage**:We notify that the engine is now capable of receiving new fork choice updates from the consensus layer's.
- **BlockchainTree**: When we are nearing the end of the chain during the syncing process, we transition to the blockchain tree. The synchronization occurs close to the tip, when state root validation and execution take place in memory.
- **Database**: When a block gets canonicalized, it is moved to the database
- **Provider**: An abstraction over database that provides utility functions to help us avoid directly accessing the keys and values of the underlying database.
- **Downloader**: Retrieves blocks and headers using peer-to-peer(P2P) networks. This tool is utilized by the pipeline during its initial two stages and by the engine in the event that it need to bridge the gap at the tip.
- **P2P**: When we approach the tip, we transfer the transactions we have read over P2P to the transaction pool.
- **Transaction Pool**: Includes DDoS mitigation measures. Consists of transactions arranged in ascending order based on the gas price preferred by the users.
- **Payload Builder**: Extracts the initial n transactions in order to construct a fresh payload.
- **Pruner**: Allows us to have a full node.Once the block has been canonicalized by the blockchain tree, we must wait for an additional 64 blocks for it to reach finalization. Once the finalization process is complete, we can be certain that the block will not undergo reorganization. Therefore, if we are operating a full node, we have the option to eliminate the old block using the pruner.
