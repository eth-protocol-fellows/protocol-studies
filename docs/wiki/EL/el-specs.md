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

[¹]: https://archive.devcon.org/archive/watch/6/eels-the-future-of-execution-layer-specifications/?tab=YouTube
