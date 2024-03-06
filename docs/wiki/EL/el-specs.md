> [!NOTE]
> This topic is open for collaboration on a separate branch

# Overview

The Execution Layer focuses exclusively on executing the state transition function (STF). This role encompasses addressing two primary questions[¹]:

- Is it possible to append the block to the end of the blockchain?
- How does the state change as a result?

Simplified Overview: 
<img src="images/el-architecture/stf_eels.png" width="800"/>

The image above represents the block level state transition function in the yellow-paper. 

$$
\begin{equation}
\sigma_{t+1} \equiv \Pi(\sigma_t, B)
\tag{2}
\end{equation}
$$

In the equation, each symbol represents a specific concept related to the blockchain state transition:

- $\sigma_{t+1}$ represents the **state of the blockchain** after applying the current block, often referred to as the "new state."
- $\Pi$ denotes the [block level state transition function](https://github.com/ethereum/execution-specs/blob/0f9e4345b60d36c23fffaa69f70cf9cdb975f4ba/src/ethereum/shanghai/fork.py#L145), which is responsible for transitioning the blockchain from one state to the next by applying the transactions contained in the current block.
- $\sigma_t$ represents the state of  the **[blockchain](https://github.com/ethereum/execution-specs/blob/0f9e4345b60d36c23fffaa69f70cf9cdb975f4ba/src/ethereum/shanghai/fork.py#L73)** before adding the current block, also known as the "previous state."


- $B$ symbolizes the **[current block](https://github.com/ethereum/execution-specs/blob/0f9e4345b60d36c23fffaa69f70cf9cdb975f4ba/src/ethereum/shanghai/fork_types.py#L217)** that is being sent to the execution layer for processing.

Furthermore, it's crucial to understand that $\sigma$ should not be confused with the `State` class defined in the Python specification. Rather than being stored in a specific location, the system's state is dynamically derived through the application of the state collapse function. This distinction emphasizes the conceptual separation between the mathematical model of blockchain state transitions and the practical implementation details within software specifications.

The specified procedure for the state transition function in the code documentation includes the following steps:

1. **Retrieve the Header**: Obtain the header of the most recent block stored on the chain, referred to as the parent block.
2. **Header Validation**: Compare and validate the current block's header against that of the parent block.
3. **Ommers Field Check**: Verify that the ommers field in the current block is empty. Note: "ommers" is the gender-neutral term that replaces the previously used term "uncles."
4. **Block Execution**: Execute the transactions within the block, which yields the following outputs:
    - **Gas Used**: The total gas consumed by executing all transactions in the block.
    - **Trie Roots**: The roots of the tries for all transactions and receipts contained in the block.
    - **Logs Bloom**: A bloom filter of logs from all transactions within the block.
    - **State Class**: The state of the blockchain after executing all transactions.
5. **Header Parameters Verification**: Confirm that the parameters returned from executing the block are present in the block header. This includes comparing the state's root with the `state_root` field in the block header.
6. **Block Addition**: If all checks are successful, append the block to the blockchain.
7. **Pruning Old Blocks**: Remove blocks that are older than the most recent 255 blocks from the blockchain.
8. **Error Handling**: If any validation checks fail, raise an "Invalid Block" error. Otherwise, return None.

## Header Validation

TODO

## Block Execution

TODO


[¹]: https://archive.devcon.org/archive/watch/6/eels-the-future-of-execution-layer-specifications/?tab=YouTube
