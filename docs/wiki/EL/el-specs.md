# Execution Layer Specifications

> **Where is it specified?**
>
> - [Yellow Paper paris version 705168a – 2024-03-04](https://ethereum.github.io/yellowpaper/paper.pdf) (note: This is outdated does not take into account post merge updates)
> - [Python Execution Layer specification](https://ethereum.github.io/execution-specs/)
> - EIPs [Look at Readme of the repo](https://github.com/ethereum/execution-specs)

Execution Layer at its core is responsible for executing 3 types of transactions legacy, Type 1 and Type 2 . The transactions are processed in a quasi-turing complete Ethereum Virtual Machine , which means you can do any kind of computation on it limited by gas. This characteristic empowers it to serve as a decentralized world computer , facilitating the operation of decentralized applications (DApps) or simple transactions that are recorded in an immutable decentralized ledger. Beyond transaction processing , The Execution Layer is also responsible for Storing the data structures in the State DB that give the layer the capability to observe the current state or revert to any historical state.

<img src="images/el-architecture/state.png" width="800"/>

The actions in the above image as represented in the yellow paper(paris version) :

| Action Id. | equation no. | yellow paper                                               | comments                                                                                                                                                                                                                                                                                                                                                                                                         |
| ---------- | ------------ | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1          | 7            | $$TRIE(L_I^*(\sigma[a]_s)) \equiv \sigma[a]_s $$           | This gives the root of the account storage Trie ,$ \sigma[a]\_s $ on the right, after mapping each node with the function $L_I((k,v)) \equiv (KEC(k), RLP(v))$ . The equation on the left is referring to mapping over underlying key and values of the account storage $ \sigma[a]\_s $ these are two different objects the left $ \sigma[a]\_s $ and the right $ \sigma[a]\_s $ which represents the root hash |
| 2          |              | page 4 paragraph 2                                         | The account state $ \sigma[a] $ is described in the yellow paper                                                                                                                                                                                                                                                                                                                                                 |
| 3          | 10           | $$ L_s(\sigma) \equiv \{p(a) : \sigma[a] \neq \empty \} $$ | This is the world state collapse function , applied to all accounts considered not empty:                                                                                                                                                                                                                                                                                                                        |
| 4 & 5      | 36           | $$ TRIE(L_s(\sigma)) = P(B_H)_{H_{stateRoot}} $$          | The equation defines the Parent block's state root header as the root given by the TRIE function where $P(B_H)$ is the Parent Block                                                                                                                                                                                                                                                                              |
| 6.         | 33b          | $$ H_{stateRoot} \equiv TRIE(L_s(\Pi(\sigma, B))) $$      | this gives us the state root of the current block                                                                                                                                                                                                                                                                                                                                                                |

In addition to its primary function , the Execution layer client is also responsible for syncing its own copy of the blockchain , gossiping with other EL clients and addressing the requirements of the consensus api that actually drives the execution layer.
The Client is built upon a variety of distinct specifications, each detailed in various documents and contributing uniquely to its overall functionality. This document seeks to offer an overview of the core specification. For insights into how these specifications are synergistically integrated within the Execution Layer Client, please refer to [Execution Layer Architecture](/wiki/EL/el-architecture.md).

## Ethereum Execution Layer Specification (EELS)


The Execution Layer, from the EELS perspective, focuses exclusively on executing the state transition function (STF). This role encompasses addressing two primary questions[¹]:

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
- $\sigma_t$ represents the state of the **[blockchain](https://github.com/ethereum/execution-specs/blob/0f9e4345b60d36c23fffaa69f70cf9cdb975f4ba/src/ethereum/shanghai/fork.py#L73)** before adding the current block, also known as the "previous state."

- $B$ symbolizes the **[current block](https://github.com/ethereum/execution-specs/blob/0f9e4345b60d36c23fffaa69f70cf9cdb975f4ba/src/ethereum/shanghai/fork_types.py#L217)** that is being sent to the execution layer for processing.

Furthermore, it's crucial to understand that $\sigma$ should not be confused with the `State` class defined in the Python specification. Rather than being stored in a specific location, the system's state is dynamically derived through the application of the state collapse function. This highlights the conceptual separation between the mathematical model of blockchain state transitions and the practical implementation details within software specifications.

The specified procedure for the state transition function in the code documentation includes the following steps:

1. **Retrieve the Header**: Obtain the header of the most recent block stored on the chain, referred to as the parent block.
2. **Header Validation**: Compare and validate the current block's header against that of the parent block.
3. **Ommers Field Check**: Verify that the ommers field in the current block is empty. Note: "ommers" is the gender-neutral term that replaces the previously used term "uncles."
4. **Block Execution**: Execute the transactions within the block, which yields the following outputs:
   - **Gas Used**: The total gas consumed by executing all transactions in the block.
   - **Trie Roots**: The roots of the tries for all transactions and receipts contained in the block.
   - **Logs Bloom**: A bloom filter of logs from all transactions within the block.
   - **State Object**: The state, as specified in the execution specs, after executing all transactions.
5. **Header Parameters Verification**: Confirm that the parameters returned from executing the block are present in the block header. This includes comparing the state's root with the `state_root` field in the block header.
6. **Block Addition**: If all checks are successful, append the block to the blockchain.
7. **Pruning Old Blocks**: Remove blocks that are older than the most recent 255 blocks from the blockchain.
8. **Error Handling**: If any validation checks fail, raise an "Invalid Block" error. Otherwise, return None.

### Header Validation

Block Header [validity](https://github.com/ethereum/execution-specs/blob/0f9e4345b60d36c23fffaa69f70cf9cdb975f4ba/src/ethereum/shanghai/fork.py#L269) as defined in the yellow paper:
$P(H)$ is the parent block:

$$
V(H) \equiv H_{gasUsed} \leq H_{gasLimit} \tag{57a}$$ $$\land$$ $$ H_{gasLimit} < P(H)_{H_{gasLimit'}} + floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) \tag{57b}$$
$$\land $$ $$ H_{gasLimit} > P(H)_{H_{gasLimit'}} - floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) \tag{57c}$$ $$\land$$ $$ H_{gasLimit} > 5000\tag{57d}$$ $$ \land  $$  $$H_{timeStamp} > P(H)_{H_{timeStamp'}} \tag{57e}$$ $$\land$$ $$ H_{numberOfAncestors} = P(H)_{H_{numberOfAncestors'}} + 1 \tag{57f}$$ $$\land$$ $$ size(H_{extraData}) \leq 32_{bytes} \tag{57g}$$ $$\land$$ $$ H_{baseFeePerGas} = F(H) \tag{57h}$$ $$\land$$ $$ H_{ommersHash} = KEC(RLP(())) \tag{57j}$$ $$\land$$ $$ H_{difficulty} = 0\tag{57k}$$ $$\land $$ $$H_{nonce} = 0x0000000000000000 \tag{57l}$$ $$\land$$ $$ H_{prevRandao} = PREVRANDAO() \tag{57m}$$

 - 57j-57k are artifacts from PoW days. 
- 57b & 57c check the gasLimit 
- 57h  checks the baseFeePerGas

<img src="images/el-architecture/gas-header.png" width="800"/>

TODO

### Block Execution

TODO

### Block  Wholistic Validity

TODO

[¹]: https://archive.devcon.org/archive/watch/6/eels-the-future-of-execution-layer-specifications/?tab=YouTube

> [!NOTE]
> All the topics in this PR are open for collaboration on a separate branch
$$
