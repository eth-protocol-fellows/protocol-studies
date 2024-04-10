# Execution Layer Specifications

> **Where is it specified?**
>
> - [Yellow Paper paris version 705168a – 2024-03-04](https://ethereum.github.io/yellowpaper/paper.pdf) (note: This is outdated does not take into account post merge updates)
> - [Python Execution Layer specification](https://ethereum.github.io/execution-specs/)
> - EIPs [Look at Readme of the repo](https://github.com/ethereum/execution-specs)

The core of the Ethereum Execution Layer is tasked with executing three types of transactions: legacy, Type 1, and Type 2. These transactions are processed by the quasi-Turing complete Ethereum Virtual Machine (EVM), which allows for virtually any computation, bounded only by gas constraints. This capability positions the EVM as a decentralized world computer, enabling decentralized applications (DApps) to run and transactions to be securely recorded on an immutable ledger. Beyond transaction processing, the EL is instrumental in storing data structures within the State DB. This not only facilitates the observation of current and historical states but also supports the Consensus Layer in block creation and validation. In this analogy, the Execution Layer acts as the CPU, with the Consensus Layer serving as the hard drive. Additionally, the EL defines the parameters of Ethereum's economic model, laying the foundation for blockchain operations.

Beyond its fundamental role, the Execution Layer client undertakes several critical responsibilities. These include synchronizing its blockchain copy, facilitating network communication through gossip protocols with other Execution Layer clients, minting a transaction pool, and fulfilling the Consensus Layer's requirements that drive its functionality. This multifaceted operation ensures the robustness and integrity of the Ethereum network.

The client's architecture is grounded in a series of detailed specifications, each playing a unique role in its comprehensive functionality. This document aims to provide a concise overview of the core specification. For a deeper understanding of how all the specifications seamlessly work together within the Execution Layer Client, please consult the [Execution Layer Architecture](/wiki/EL/el-architecture.md).

# Ethereum Execution Layer Specification (EELS)

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

<img src="images/el-architecture/state.png" width="800"/>

The id's in the above image as represented in the yellow paper(paris version) :

| Id. | equation no. | yellow paper                                               | comments                                                                                                                                                                                                                                                                                                                                                                                                         |
| ---------- | ------------ | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1          | 7            | $$TRIE(L_I^*(\sigma[a]_s)) \equiv \sigma[a]_s $$           | This gives the root of the account storage Trie ,$ \sigma[a]_s $ on the right, after mapping each node with the function $L_I((k,v)) \equiv (KEC(k), RLP(v))$ . The equation on the left is referring to mapping over underlying key and values of the account storage $ \sigma[a]_s $ these are two different objects the left $ \sigma[a]_s $ and the right $ \sigma[a]_s $ which represents the root hash |
| 2          |              | page 4 paragraph 2                                         | The account state $ \sigma[a] $ is described in the yellow paper                                                                                                                                                                                                                                                                                                                                                 |
| 3          | 10           | $$ L_s(\sigma) \equiv \{p(a) : \sigma[a] \neq \empty \} $$ | This is the world state collapse function , applied to all accounts considered not empty:                                                                                                                                                                                                                                                                                                                        |
| 4 & 5      | 36           | $$ TRIE(L_s(\sigma)) = P(B_H)_{H_{stateRoot}} $$          | The equation defines the Parent block's state root header as the root given by the TRIE function where $P(B_H)$ is the Parent Block                                                                                                                                                                                                                                                                              |
| 6.         | 33b          | $$ H_{stateRoot} \equiv TRIE(L_s(\Pi(\sigma, B))) $$      | this gives us the state root of the current block                                                                                                                                                                                                                                                                                                                                                                |

The specified procedure for the state transition function in the code documentation includes the following steps:

1. **Retrieve the Header**: Obtain the header of the most recent block added to the chain, referred to as the parent block.
2. **Excess Blob Gas Validation**: Calculate excess blob gas from the parent header and ensure it matches the current blocks header parameter excess_blob_gas
2. **Header Validation**: Compare and validate the current block's header against that of the parent block.
3. **Ommers Field Check**: Verify that the ommers field in the current block is empty. Note: "ommers" is the gender-neutral term that replaces the previously used term "uncles."
4. **Block Execution**: Execute the transactions within the block, which yields the following outputs:
   - **Gas Used**: The total gas consumed by executing all transactions in the block.
   - **Trie Roots**: The roots of the tries for all transactions and receipts contained in the block.
   - **Logs Bloom**: A bloom filter of logs from all transactions within the block.
   - **State**: The state, as specified in the python execution specs, after executing all transactions.
5. **Header Parameters Verification**: Confirm that the parameters returned from executing the block are present in the block header. This includes comparing the state's root with the `state_root` field in the block header.
6. **Block Addition**: If all checks are successful, append the block to the blockchain.
7. **Pruning Old Blocks**: Remove blocks that are older than the most recent 255 blocks from the blockchain.
8. **Error Handling**: If any validation checks fail, raise an "Invalid Block" error. Otherwise, return None.

Client Code :

| function | EELS(cancun) | Geth | Reth | Erigon | Nethermind | Besu |
|----------|------|------|--------|------------|------|-----|
| Block Level  STF |    | Header verification begins here:  [insertChain]( https://github.com/ethereum/go-ethereum/blob/38eb8b3e20bf237a78fa57e84fa63c2d05a44635/core/blockchain.go#L1628) -> Transaction Iteration : [ Process ](https://github.com/ethereum/go-ethereum/blob/6f1fb0c29ff25318e688c15581d0c28dcefb75ce/core/state_processor.go#L60) -> txLevel STF    |      |        |            |      |

# Block Header Validation

The process of block header validation, rigorously defined within the Yellow Paper + Spec, encompasses extensive checks, including gas usage, timestamp accuracy, among others. This meticulous validation process ensures every block strictly complies with Ethereum's stringent standards, thereby upholding the network's security and operational stability. Furthermore, it delineates the boundaries of Ethereum's economic model, integrating essential safeguards against inefficiencies and vulnerabilities. Through this process, the Ethereum network achieves a delicate balance between flexibility, allowing for evolution and upgrades, and rigidity, ensuring adherence to core principles and safety measures.

 
The Ethereum economic model, as outlined in [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559), introduces a series of mechanisms aimed at enhancing network efficiency and stability:

*    **Targeted Gas Limit for Reduced Volatility**: By setting the gas target at half the maximum gas limit, Ethereum aims to diminish the volatility that full blocks can cause, ensuring a more predictable transaction processing environment.
*    **Prevention of Unnecessary Delays**: This model seeks to eliminate undue delays for users by optimizing transaction processing times, thus improving the overall user experience on the network.
*    **Stabilizing Block Reward Issuance**: The issuance of block rewards contributes to the system's enhanced stability, providing a more predictable economic landscape for participants.
*    **Predictable Base Fee Adjustments**: EIP-1559 introduces a mechanism for predictable base fee changes, a feature particularly beneficial for wallets. This predictability aids in accurately estimating transaction costs ahead of time, streamlining the transaction creation process.
*    **Base Fee Burn and Priority Fee**: Under this model, miners are entitled to keep the priority fee as an incentive, while the base fee is burned, effectively removing it from circulation. This approach serves as a countermeasure to Ethereum's inflation, promoting a healthier economic environment by reducing the overall supply over time.

The [validity](https://github.com/ethereum/execution-specs/blob/0f9e4345b60d36c23fffaa69f70cf9cdb975f4ba/src/ethereum/shanghai/fork.py#L269) of a block header, as specified in the Yellow Paper, employs a series of criteria to ensure each block adheres to Ethereum's protocol requirements. The parent block, denoted as $P(H)$, plays a crucial role in validating the current block header $H$ . The key conditions for validity include:

$$V(H) \equiv H_{gasUsed} \leq H_{gasLimit} \tag{57a}$$ 
$$\land$$
$$ H_{gasLimit} < P(H)_{H_{gasLimit'}} + floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) \tag{57b}$$
$$\land $$ 
$$ H_{gasLimit} > P(H)_{H_{gasLimit'}} - floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) \tag{57c}$$ 
$$\land$$
$$ H_{gasLimit} > 5000\tag{57d}$$ 
$$ \land  $$
$$H_{timeStamp} > P(H)_{H_{timeStamp'}} \tag{57e}$$ 
$$\land$$
$$ H_{numberOfAncestors} = P(H)_{H_{numberOfAncestors'}} + 1 \tag{57f}$$ 
$$\land$$
$$ length(H_{extraData}) \leq 32_{bytes} \tag{57g}$$ 
$$\land$$
$$ H_{baseFeePerGas} = F(H) \tag{57h}$$ 
$$\land$$ 
$$ H_{parentHash} = KEC(RLP( P(H)_H )) \tag{57i} $$
$$\land$$
$$ H_{ommersHash} = KEC(RLP(())) \tag{57j}$$ 
$$\land$$
$$ H_{difficulty} = 0\tag{57k}$$ 
$$\land $$
$$H_{nonce} = 0x0000000000000000 \tag{57l}$$ 
$$\land$$
$$  H_{prevRandao} = PREVRANDAO() \text{?? in yellow but not in eels} \tag{57m}$$ 
$$\land$$ 
$$ H_{withdrawlsHash} \neq nil \tag{57n}$$
$$\land$$
$$ H_{blobGasUsed} \neq nil \tag{57o}$$
$$\land$$
$$ H_{blobGasUsed} \leq  MaxBlobGasPerBlock_{=786432}  \tag{57p}$$ 
$$ \land $$
$$ H_{blobGasUsed} \% GasPerBlob_{=2^{17}} = 0  \tag{57q}$$ 
$$ \land $$
$$ H_{excessBlobGas} = CalcExcessBlobGas(P(H)_H) \tag{57r}$$

$$
CalcExcessBlobGas(P(H)_H) \equiv 
\begin{aligned}
&\begin{cases} 
0, & \text{if} \space P(H)_{blobGasUsed} < TargetBlobGasPerBlock \\
P(H)_{blobGasUsed} - TargetBlobGasPerBlock
\end{cases}
\end{aligned} 
$$

$$
P(H)_{blobGasUsed} \equiv  P(H)_{H_{excessBlobGas}} + P(H)_{H_{blobGasUsed}} \\
TargetBlobGasPerBlock =  393216
$$

*    **Gas Usage**: The gas used by a block   $H_{gasUsed}$ must not exceed the gas limit $H_{gasLimit'}$, ensuring transactions fit within the block's capacity (57a).
*   **Gas Limit Constraints**: The gas limit of a block must remain within specified bounds relative to the parent block's gas limit ${P(H)_{H_{gasLimit'}}}$  , allowing for gradual changes rather than abrupt adjustments (57b, 57c).
*   **Minimum Gas Limit**: A minimum gas limit of 5000 ensures a basic level of transaction processing capacity (57d).
*   **Timestamp Verification**: Each block's timestamp $H_{timeStamp}$ must be greater than that of its parent $P(H)_{H_{timeStamp'}}$, ensuring chronological order (57e).
*   **Ancestry and Extra Data**: The block maintains a lineage through the $H_{numberOfAncestors'}$ field and limits the $H_{extraData}$ size to 32 bytes for efficiency and security (57f, 57g).
*   **Economic Model Compliance**: The base fee per gas $H_{baseFeePerGas}$ is calculated according to the rules established in EIP-1559, reflecting the network's current demand for transaction processing (57h). This along with a,b,c,d & h defines part of the Economic model

Additional checks ensure legacy compatibility and security, such as the ommer hash  and difficulty  fields being set to predefined values, reflecting the transition from Proof of Work to Proof of Stake (57j-57l).

These criteria form part of the Ethereum economic model, particularly influenced by EIP-1559, which introduces a dynamic base fee mechanism. This mechanism aims to optimize network usage and fee predictability, enhancing user experience and economic stability. By examining these equations more closely, we can appreciate the intricate balance Ethereum maintains between flexibility for users and robust protocol standards.

Lets explore this in more depth and try to gain a better understanding on whats going on with these equations thats  not easily visible in either the python spec or the yellow paper . 

Lets start with expanding 57h , this is how it is specified in the yellow paper:  
$$
\begin{equation}
F(H) \equiv
\begin{cases}
10^9 & \text{if } H_{number} = F_{London} \\
P(H)_{H_{baseFeePerGas}} & \text{if } P(H)_{H_{gasUsed}} = \tau \\
P(H)_{H_{baseFeePerGas}} - \nu & \text{if } P(H)_{H_{gasUsed}} < \tau \\
P(H)_{H_{baseFeePerGas}} + \nu & \text{if } P(H)_{H_{gasUsed}} > \tau
\end{cases}
\tag{45}
\end{equation}
$$

$$
% Equation (46)
\tau \equiv \frac {P(H)_{H_{gasLimit}}}  {\rho} \tag{46}
$$

$$
% Equation (47)
\rho \equiv 2 \tag{47}
$$

$$
% Equation (48)
\nu^* \equiv
\begin{cases}
\frac{P(H)_{H_{baseFeePerGas}} \times (\tau - P(H)_{H_{gasUsed}})}{\tau} & \text{if } P(H)_{H_{gasUsed}} < \tau \\
\frac{P(H)_{H_{baseFeePerGas}} \times (P(H)_{H_{gasUsed}} - \tau)}{\tau} & \text{if } P(H)_{H_{gasUsed}} > \tau
\end{cases} \tag{48}
$$

$$
% Equation (49)
\nu \equiv
\begin{cases}
\left\lfloor \frac{\nu^*}{\xi} \right\rfloor & \text{if } P(H)_{H_{gasUsed}} < \tau \\
\max\left(\left\lfloor \frac{\nu^*}{\xi} \right\rfloor, 1\right) & \text{if } P(H)_{H_{gasUsed}} > \tau
\end{cases} \tag{49}
$$

$$
% Equation (50)
\xi \equiv 8 \tag{50}
$$

| Symbol    | What it represents      | value                   |   comments                      |
|-----------|-------------------------|-------------------------|---------------------------------|
| $ F(H) $  | Base Fee per Gas|   | Paid be the sender as part of the Total Fee , The Base Fee is finally burnt by Execution Layer and taken out of the system |
| $ \nu $  | Magnitude increase or decrease in base fee|   | Proportional to the difference between Parent block's gas consumption and gas target|
| $ \tau $  | Gas target              |  $\frac {P(H)_{H_{gasLimit}}}  {\rho}_{= 2}$ | Aimed at reducing volatility, the gas target is set at half the gas limit to moderate transaction throughput per block. |
| $ \rho $  | Elasticity multiplier   |    2                                         | aids in adjusting the gas target to maintain network responsiveness, capacity and price predictability.|
| $ \xi $   | Base fee max denominator|    8                                         | it controls the maximum rate of change in the base fee, ensuring gradual adjustments.|

Furthermore the yellow paper has some crucial definitions on the types of these objects that will be used in reasoning about these equations :

First it provides us with  unbounded block limits, i.e. These limits can be extended infinitely 
$$
H_{\text{gasUsed}} , H_{\text{gasLimit}}, H_{\text{baseFeePerGas}} \in \mathbb{N} \tag{41}
$$

Then it provides us with the types for the transaction parameter , These are bounded by a max value of 2^256 or approx 10^77, thats the max these numbers can go to

$$T_{\text{maxPriorityFeePerGas}} , T_{\text{maxFeePerGas}}, T_{\text{gasLimit}}, T_{\text{gasPrice}} \in\mathbb{N}_{256}$$

#### Additional Insights: The Significance of Natural Numbers 

The Ethereum protocol designates block-level parameters—such as gas used ($H_{gasUsed}$), gas limit ($H_{gasLimit}$), and base fee per gas ($H_{baseFeePerGas}$)—as natural numbers $\mathbb{N}$ This decision is far from arbitrary; it embeds a layer of intuitive logic into the blockchain's foundational economics.

*  Natural Numbers and Blockchain Logic

Natural numbers, starting from 0 and extending infinitely, offer a straightforward framework for understanding and manipulating these parameters. Unlike real numbers, which include an uncountable infinity between any two points, natural numbers allow for exact, discrete steps—making them ideal for blockchain transactions where precision is paramount. This property simplifies the reasoning about functions that manipulate these parameters, facilitating precise calculations and predictions about transaction costs and network capacity.

* Simplicity and Precision

Consider the simplicity of incrementing: each natural number can be thought of as a sum of (0 + 1 + 1 + ... + 1), providing a clear path for incrementation or decrementation within smart contracts or transaction processing. This atomic nature of natural numbers, with 0 and Successor(+ 1)  foundational building blocks, enables the construction of robust and provable logic within the Ethereum blockchain, in other words  natural numbers lead to easier proofs.

* Contrasting with Real Numbers (decimals)

In contrast to the infinite divisibility of real numbers, the discrete nature of natural numbers within Ethereum's economic model ensures that operations remain within computable bounds. This distinction is crucial for maintaining network efficiency and security, avoiding the computational complexity and potential vulnerabilities associated with handling real numbers.

**Transaction Parameters and Bounded Natural Numbers**

Furthermore, Ethereum specifies transaction parameters, such as the maximum priority fee per gas  and maximum fee per gas , within a bounded subset of natural numbers $\mathbb{N}_{256}$. This bounding, capped at $2^{256}$ or approximately $10^{77}$, strikes a balance between allowing a vast range of values for transaction processing and ensuring that these values remain within secure, manageable limits.

#### Dynamics of Gas Price Block to Block
Let's delve into the dynamics of the gas price calculation function by exploring its impact across a spectrum of gas usage scenarios, ranging from the minimum possible (5,000 units) to the set gas limit.Our focus is to understand how this function performs within the scope of a single block.

For those interested in a hands-on approach, this analysis can be replicated in R (download R studio and follow along). The procedure outlined below is straightforward and broadly applicable, allowing for adaptation into Python using the actual execution specs.

We aim to analyze the 'calculate base fee per gas' function, which is integral to understanding Ethereum's gas pricing mechanism. The following R code snippet illustrates the implementation of this function:

<img src="images/el-architecture/gasused-basefee.png" width="800"/>

Observations from the plot:

-    The function exhibits a step-like linear progression, with the widest variance at the midpoint. This reflects the gas target, set at half the gas limit (15,000 units in this case).
-    The maximum upward change in the base fee is approximately 12.5%, observed at the extreme right of the plot. This represents the maximum possible change when the base fee starts at a hundred.
-    A precise hit on the gas target results in a 1% increase in the base fee. Exceeding the target slightly (e.g., between 15,000 and 17,000 units of gas used) still results in only a 1% increase, illustrating the function's designed elasticity around the target.

#### Extended Simulation: Long-term Effects on Gas Limit and Fee

Having visualized the immediate impact of the gas price calculation function over a range of gas usage scenarios, it's intriguing to consider its effect over an extended period. Specifically, how does this dynamic influence the Ethereum network over tens of thousands of blocks, especially under conditions of maximum demand where each block reaches its gas limit?

The following R code simulates this scenario over 100,000 blocks, assuming a constant maximum demand, to project the evolution of the gas limit and base fee:

<img src="images/el-architecture/gas-limit-max.png" width="800"/>

Observations from the simulation reveal several critical insights:

*    Base Fee Sensitivity: The base fee, measured in wei, escalates rapidly, potentially reaching one ether within a mere 200 blocks under continuous maximum demand.
*    Potential to Hit Upper Limits: Under sustained high demand, the base fee could approach its theoretical maximum in under 2,000 blocks.
*    Unbounded Gas Limit Growth: Unlike the base fee, the gas limit itself is not capped, allowing for continuous growth to accommodate increasing network demand.
*    Market Dynamics and Equilibrium: Real-world demand increases, initially reflected in blocks exceeding their gas targets, lead to rising base fees. However, as the gas limit gradually increases, the gas target (half the gas limit) also rises, eventually stabilizing demand against the higher base fee, reaching a new equilibrium.

With a more nuanced understanding of Ethereum's economic model now in hand, we aim to future-proof our analysis by examining the model's underpinnings at a more granular level. Specifically, we focus on the effects of altering the constants central to the model, notably the elasticity multiplier ($\rho$) and the base fee max change denominator ($\xi$). These constants are not expected to change within a fork but can be re-specified in future protocol upgrades:

let's start with $\xi$ :

<img src="images/el-architecture/xi.png" width="800"/>

This is a snapshot between blocks, like our first plot, it represents smallest slice of the potential of the  economic model additionally parameterized by $\xi$ across protocol upgrades

Impact of $\xi$ on base fee:

-    Inflection Point Identification: Analogous to the initial broad observation, this detailed examination reveals the nuanced shifts and inflections attributable to variations in $\xi$. The "kink" or point of inflection in the adjustment trajectory becomes particularly pronounced from this perspective.
-    Adjustment Sensitivity: The slope of the base fee adjustment curve changes significantly beyond the inflection point. As $\xi$ values decrease, we observe a sharp increase in the rate of fee adjustments, indicating heightened sensitivity.
-    Step Width Variability: Increasing $\xi$ results in broader step widths, indicating more gradual fee adjustments. Conversely, decreasing $\xi$ leads to narrower steps and more volatile fee changes.
-    Linear Trend within Target Range: The central portion of the curve, particularly highlighted by the light green line for the current $\xi$ value, showcases a mostly linear trend in fee adjustments as transactions approach or slightly exceed the gas target.

Next, we turn our attention to the elasticity multiplier ($\rho$), another pivotal constant in Ethereum's economic model that directly influences the flexibility and responsiveness of gas limit adjustments. To comprehensively understand its impact, we explore a range of values for $\rho$ from 1 to 6 in conjunction with variations in the base fee max change denominator ($\xi$).

<img src="images/el-architecture/rho-xi.png" width="800"/>

Impact of $\rho$ and $\xi$ on Base Fee :

-    Moment-to-Moment Analysis: Similar to our initial observations, this plot offers a granular view into how adjustments in $\rho$ and $\xi$ shape the economic model's behavior on a per-block basis, especially in the context of protocol upgrades.
-    Distinct Influence of $\rho$: Each subplot represents the nuanced effects of varying $\rho$ values. As the elasticity multiplier, $\rho$ notably shifts the inflection point in the base fee adjustment curve, highlighting its critical role in tuning the network's responsiveness to transaction volume fluctuations.
-    Interplay Between $\rho$ and $\xi$: The elasticity multiplier ($\rho$) not only moves the inflection point but also modulates the sensitivity of adjustments attributable to changes in the base fee max change denominator ($\xi$). This interaction underscores the delicate balance Ethereum maintains to ensure network efficiency and stability amidst varying demands.

<img src="images/el-architecture/gas-header.png" width="800"/>

TODO Blob fee charts

Client Code :

|    | EELS(cancun) | Geth | Reth | Erigon | Nethermind | Besu |
|----|--------------|------|------|--------|------------|------|
| $$V(H) \equiv H_{gasUsed} \leq H_{gasLimit}$$ |  [validate_header](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L294)     | |      |        |            |      |
| $$ H_{gasLimit} < P(H)_{H_{gasLimit'}} + floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) $$  |   validate_header -> calculate_base_fee_per_gas -> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L256)  | |      |        |            |      |
| $$ H_{gasLimit} > P(H)_{H_{gasLimit'}} - floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) $$  |    ''   | |      |        |            |      |
| $$ H_{gasLimit} > 5000$$  |  calculate_base_fee_per_gas -> [check_gas_limit](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L1132)     | |      |        |            |      |
| $$H_{timeStamp} > P(H)_{H_{timeStamp'}} $$  | validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L323)      | |      |        |            |      |
| $$ H_{numberOfAncestors} = P(H)_{H_{numberOfAncestors'}} + 1 $$  |  validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L324)            | |      |        |            |      |
| $$ length(H_{extraData}) \leq 32_{bytes} $$  |    validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L325)                 | |      |        |            |      |
| $$ H_{baseFeePerGas} = F(H) $$  |       | |      |        |            |      |
| $$ H_{parentHash} = KEC(RLP( P(H)_H ))  $$  |        validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L332)                           | |      |        |            |      |
| $$ H_{ommersHash} = KEC(RLP(())) $$  |       validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L329)                     | |      |        |            |      |
| $$ H_{difficulty} = 0 $$  |      validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L327)               | |      |        |            |      |
| $$H_{nonce} = 0x0000000000000000 \tag{57l}$$  |       validate_header-> [ensure](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L328)                     | |      |        |            |      |
| $$  H_{prevRandao} = PREVRANDAO() \text{this is stale , beacon chain provides this now} $$  |       | |      |        |            |      |
| $$ H_{withdrawlsHash} \neq nil $$  |       | |      |        |            |      |
| $$ H_{blobGasUsed} \neq nil $$  |       | |      |        |            |      |
| $$ H_{blobGasUsed} \leq  MaxBlobGasPerBlock_{=786432}  $$  |       | |      |        |            |      |
| $$ H_{blobGasUsed} \% GasPerBlob_{=2^{17}} = 0 $$  |       | |      |        |            |      |
| $$ H_{excessBlobGas} = CalcExcessBlobGas(P(H)_H) $$  |  [ensure ](https://github.com/ethereum/execution-specs/blob/9fc7925c80ff2f3949e1cc340a4a0d36fcd4161c/src/ethereum/cancun/fork.py#L187)     | |      |        |            |      |

# Block Execution Process

After initial header verification, the block advances to the execution phase([apply_body](https://github.com/ethereum/execution-specs/blob/804a529b4b493a61e586329b440abdaaddef9034/src/ethereum/cancun/fork.py#L437)). Performing header checks early allows the State Transition Function (STF) to potentially return an "Invalid Payload" message to the Consensus Layer (CL) without proceeding to the computationally intensive stage of block/transaction execution.

1. **Initialize `blobGasUsed` to 0.** This sets the starting point for gas used by transactions in the block to zero.
2. **Set `gasAvailable` to $H_{gasLimit}$.** This initializes the gas available for the block's execution to the block's gas limit.
3. **Initialize additional execution components:** This includes setting up the receipt's trie, withdrawal's trie, and a block logs tuple (which behaves like an immutable list), ensuring the gas available aligns with the block's gas limit.
4. **Access Beacon Block Roots Contract Code** via the EL constant that specifies the **BEACON ROOTS ADDRESS**:
    - This feature, introduced in Duncan and detailed in [EIP 4788](https://eips.ethereum.org/EIPS/eip-4788), enables the use of beacon chain block roots as cryptographic accumulators for constructing proofs of the Consensus Layer State. This provides a trust-minimized way for the EVM to access consensus layer data, supporting applications such as staking pools, restaking operations, smart contract bridges, and MEV mitigations. [Learn More](https://www.youtube.com/watch?v=GriLSj37RdI) from the spec's creator.
5. **Construct a System Transaction Message:** With the **System Address** as the caller and **BEACON ROOTS ADDRESS** as the target, include $H_{parentBeaconBlockRoot}$ and the retrieved contract code. This introduces a "system contract" in Duncan, a stateful smart contract unlike stateless precompiles, where only the system address can insert data.
6. **Set up the VM environment and process the message call,** storing $H_{parentBeaconBlockRoot}$ in the contract's storage for later retrieval by transactions providing the slot's timestamp.
7. **Delete empty accounts** touched in the previous steps to clean up the state.
8. **Process transactions within the block:**
    - Transactions are decoded and added to the transaction trie for execution.
    - **Execute the Transaction:** Critical to the block execution process, this involves:
        1. Recovering the transaction sender's address using the signature components $T_v, T_r, T_s$.
        2. Verifying intrinsic transaction validity.
        3. Calculating the effective gas price.
        4. Initializing the execution environment.
        5. **Executing the decoded transaction** within the virtual machine, including validation against the current state, gas calculations, and applying state changes upon success.
9. **Process validator withdrawals** validated by the beacon chain ([EIP-4895](https://eips.ethereum.org/EIPS/eip-4895)):
    - Iterate over each [Withdrawal](https://github.com/ethereum/execution-specs/blob/119208cf1a13d5002074bcee3b8ea4ef096eeb0d/src/ethereum/shanghai/fork_types.py#L178), adding them to the trie.
    - Convert withdrawals from Gwei to Wei and credit the specified addresses.
    - Destroy empty withdrawal accounts to maintain a clean state.

## Environment Initialisiation

$$
I_{caller} = T_{Sender_{address}}, \nonumber \\
I_{origin} = T_{Sender_{address}}, \nonumber \\
I_{blockHashes} = blockHashes_{Last255}, \nonumber \\
I_{coinbase} = H_{coinbase}, \nonumber \\
I_{number} = H_{number}, \nonumber \\
I_{gaslimit} = Header_{gasLimit} - cumulativeGasUsed, \nonumber \\
I_{baseFeePerGas} = H_{baseFeePerGas}, \nonumber \\
I_{gasPrice} = effectiveGasPrice, \nonumber \\
I_{time} = H_{timeStamp}, \nonumber \\
I_{prevRandao} = H_{prevRandao}, \nonumber \\
I_{state} = state, \nonumber \\
I_{chainId} = H_{chainId}, \nonumber \\
I_{traces} = [], \nonumber \\
I_{excessBlobGas} = excessBlobGas, \nonumber \\
I_{blobVersionedHashes} = T_{blobVersionedHashes}, \nonumber \\
$$

| Variable                | Description |
|-------------------------|-------------|
| $I_{caller}$            | The address initiating the code execution; typically the sender of the transaction. |
| $I_{origin}$            | The original sender address of the transaction initiating this execution context. |
| $I_{blockHashes}$       | A collection of the hashes from the last 255 blocks. |
| $I_{coinbase}$          | The beneficiary address for block rewards and transaction fees. |
| $I_{number}$            | The sequential number of the current block within the blockchain. |
| $I_{gasLimit}$          | The maximum amount of gas available for executing the transaction, accounting for gas already used in the current block. |
| $I_{baseFeePerGas}$     | The base fee per gas unit, a dynamic parameter that adjusts with block space demand. |
| $I_{gasPrice}$          | The effective gas price, influenced by current network conditions and transaction urgency. |
| $I_{time}$              | The timestamp marking when the block was produced, measured in seconds since the Unix epoch. |
| $I_{prevRandao}$        | The previous RANDAO (randomness) value, contributing to the entropy in block production from the Beacon chain. |
| $I_{state}$             | The current state, encompassing all account balances, storage, and contract code. |
| $I_{chainId}$           | Identifier for the blockchain, ensuring transactions are signed for a specific chain. |
| $I_{traces}$            | A placeholder for execution traces, intended for future use or debugging purposes. |
| $I_{excessBlobGas}$     | Calculated from the parent block, it represents surplus gas allocated for blob transactions. |
| $I_{blobVersionedHashes}$ |  |

| | EELS   | Geth | Reth | Erigon | Nethermind | Besu |
|----------|------|--|------|--------|------------|------|
| instantiate Env | [env](https://github.com/ethereum/execution-specs/blob/804a529b4b493a61e586329b440abdaaddef9034/src/ethereum/cancun/fork.py#L578)  | Process ->  [NewEVMBlockContext](https://github.com/ethereum/go-ethereum/blob/a3829178af6cec64d6def9131b9340a3328cc4fc/core/evm.go#L42)  | [execute_inner calls init_env](https://github.com/paradigmxyz/reth/blob/bfadc26b37c24128c14323c7f99078a0c2dd965a/crates/revm/src/processor.rs#L295) -> [BlockEnv](https://github.com/bluealloy/revm/blob/57825ff8c6b3ff82796171c3965c45004c1acb1a/crates/primitives/src/env.rs#L395)   | [BLockContext](https://github.com/ledgerwatch/erigon/blob/1d04dc52b7ad90caa472833b13c77d1c0d447de0/core/state_processor.go#L115)             |           |    |     |

# Gas Accounting

## Intrinsic Gas Calculation

Intrinsic gas represents the minimum gas required for a transaction to begin execution. This cost encompasses the computational resources needed by the EVM and the costs associated with data transfer. The intrinsic gas is subtracted from the transaction's $T_{gasLimit}$ to set up the execution context within the EVM.

Updated to align with the Shanghai Specification, the intrinsic gas formula, where $T$ stands for Transaction and $G$ for Gas Cost, is as follows:

$$
g_0 \equiv 
$$ 
$$
\begin{aligned}
G_{\text{initCodeWordCost}} \times
&\begin{cases} 
\text{length}, & \text{if length} \mod 32 = 0 \\
\text{length} + 32 - (\text{length} \mod 32), & \text{otherwise}
\end{cases}\\
&\qquad\text{if } \text{CALLDATA} = T_{\text{initialisationCode}} 
\end{aligned}
$$
$$+$$
$$
\begin{aligned}
&\begin{cases}
\sum_{i \in \{T_{\text{inputData}}\}} 
\begin{cases}
G_{\text{txdatazero}} & \text{if } i = 0 \\
G_{\text{txdatanonzero}} & \text{otherwise}
\end{cases}
\end{cases}\\
&\qquad\text{if } \text{CALLDATA} = T_{inputData} \lor T_{initialisationCode}
\end{aligned}
$$
$$+$$
$$
\{ \begin{array}{ll}
G_{\text{txcreate}} & \text{if } T_{to} = \emptyset \\
0 & \text{otherwise}
\end{array}
$$
$$+$$
$$
G_{\text{transaction}}
$$
$$+$$
$$ \sum_{j=0}^{ length(T_{accessList}) - 1} \left( G_{\text{accesslistaddress}} + length(T_{accessList}[j]_s) *  G_{\text{accessliststorage}} \right)
$$

### Intrinsic Gas Components:

| Component | Description |
|-----------|-------------|
| $g_0$ | Represents the total intrinsic gas cost of a transaction, covering initial code execution and data transfer. |
| $G_{\text{transaction}}$ | The base cost for every transaction, set at 21000 gas. |
| $T_{\text{initialisationCode}}$ | When $T_{to} = 0_{\text{Bytes}}$, CALLDATA is considered as $T_{\text{initialisationCode}}$. Costs are normalized to 32-byte intervals. |
| $T_{inputData}$ and $T_{initialisationCode}$ | Collectively, $T_{inputData}$ and $T_{initialisationCode}$ represent the CallData parameter of the transaction. If $T_{to} \neq 0_{Bytes}$, CALLDATA is treated as the input to the contract's entry point. The gas cost for processing CALLDATA is defined as 16 gas per non-zero byte and 4 gas per zero byte, impacting block size and potentially network delay due to increased processing. This gas cost model was based on a balance of block creation rate, chain growth rate, and network latency, initially optimized for Proof of Work systems. Adapting this model for Proof of Stake remains a research opportunity and area for future optimization. These parameters are defined as an unlimited size byte array, with the initialization cost set at 16 gas for each non-zero byte and 4 gas for each zero byte. More |
| $G_{\text{txCreate}}$ | An additional 32000 gas is required for contract creation transactions. |
| $G_{\text{accesslistaddress}}, G_{\text{accessliststorage}}$ | Additional gas costs for each address and storage key specified in the access list, facilitating optimized state access. |

### Client Code

| function | Geth | Reth | Erigon | Nethermind | Besu |
|----------|------|------|--------|------------|------|
| intrinsic gas  | [IntrinsicGas](https://github.com/ethereum/go-ethereum/blob/14cc967d1964d3366252193cadd4bfcb4c927ac1/core/state_transition.go#L71)    |   [validate_initial_tx_gas](https://github.com/bluealloy/revm/blob/1ce5a52dc0f5701800d496605ad3d20cbd0d967f/crates/interpreter/src/gas/calc.rs#L347)   |[IntrinsicGas](https://github.com/ledgerwatch/erigon/blob/b5d1e85492a4e8ef88f4b507c775a9750de68769/core/state_transition.go#L135) -> [CalcIntrinsicGas](https://github.com/ledgerwatch/erigon/blob/b5d1e85492a4e8ef88f4b507c775a9750de68769/erigon-lib/txpool/txpoolcfg/txpoolcfg.go#L183)       |            |      |

##  Effective Gas Price & Priority Fee

The equations below were modified to include blob transactions ( $T_{type} = 3$ )

$$p \equiv effectiveGasPrice \equiv 
\begin{aligned}
&\begin{cases} 
T_{gasPrice}, & \text{if} \space T_{type} = 0 \lor 1\\
priorityFee + H_{baseFeePerGas} , & \text{if} \space T_{type} = 2 \lor 3
\end{cases}\\
\end{aligned} \tag{62}
$$

$$f \equiv priorityFee \equiv 
\begin{aligned}
&\begin{cases} 
T_{gasPrice} - H_{baseFeePerGas}, & \text{if} \space T_{type} = 0 \lor 1\\
min(T_{maxPriorityFeePerGas} , T_{maxFeePerGas} -  H_{baseFeePerGas}) , & \text{if} \space T_{type} = 2 \lor 3
\end{cases}\\
\end{aligned} 
$$

|  |  |
|--|--|
| effectiveGasPrice | The amount of wei the Transaction signer will pay per unit Gas consumed during the execution of the transaction |
| priorityFee | The amount of wei the Transaction's beneficiary will recieve per unit Gas consumed during the execution of the tranasaction|

### Client Code 

| function | Geth | Reth | Erigon | Nethermind | Besu |
|----------|------|------|--------|------------|------|
| Effective Gas Price | [effectiveGasPrice](https://github.com/ethereum/go-ethereum/blob/14cc967d1964d3366252193cadd4bfcb4c927ac1/core/types/tx_blob.go#L166)    |  *questions here? [effective_gas_price](https://github.com/paradigmxyz/reth/blob/a31202670b3ca2348b6dbca807b6b00a86a1539c/crates/primitives/src/transaction/eip4844.rs#L88)   |       |            |      |

## Effective Gas Fee

$$ effectiveGasFee \equiv effectiveGasPrice \times T_{gasLimit} $$
Deducted as part of the upfront cost

## Total Blob Gas 
$$ totalBlobGas  \equiv  (G_{gasPerBlob = 2^{17}} \times length(T_{blobVersionedHashes}) ) $$ 

##  Blob Gas Price 
The Blob Gas Price is determined through a formula that adjusts based on the excess blob gas generated in the network. The formula is as follows:

$$ 
factor_{minBlobBaseFee = 1} \times e^{numerator_{excessBlobGas} / denominator_{blobGaspriceUpdateFraction = 3338477}} \approx  \\ blobGasPrice \equiv \\ taylorExponential(factor_{minBlobBaseFee = 1}, numerator_{excessBlobGas}, denominator_{blobGaspriceUpdateFraction = 3338477}) \equiv \\ \left\lfloor \frac{1}{denominator} \left( \sum_{i=1}^{N} \left\lfloor \frac{factor \cdot denominator \cdot numerator^{i-1}}{denominator^{i-1} \cdot (i-1)!} \right\rfloor \right) \right\rfloor \\
\text{where }N = \max \left\{ i \in \mathbb{N} : \left\lfloor \frac{f \cdot d \cdot n^{i-1}}{d^{i-1} \cdot (i-1)!} \right\rfloor > 0 \right\} 
$$
Where $N$ represents the largest integer for which the term remains positive, indicating the series' summation continues until adding another term would result in zero. This process effectively applies a Taylor series approximation to calculate exponential growth, particularly for modeling the blob gas price's response to excess blob gas.

* The formula returns 1 for any input under the current maximum blob gas per block (set at 786432) , if excess gas has not accumulated. 
* However it starts increasing when the target is breached over blocks , which causes the Excess Blob Gas Parameter to start accumulating , this triggers the Blob Gas Price to  exponentially increase
* With the target set at approximately half of the maximum blob gas per block (393216), the function starts to show an increase to a value of 2 at ten times the target, after which it rises exponentially.### Blob Gas Price Dynamics

### Dynamics of Blob Gas Price

The dynamics of the Blob Gas Price are modeled in the following scenarios, starting from zero and increasing the gas used per block by a constant factor of 1000 from one block to the next.

* Figure E: Illustrates the relationship between blob gas and its price. Code to all the figures is in the appendix

<img src="images/el-architecture/blob-gas-and-price.png" width="800"/>

* Figure F: Normalizes the data to highlight the price dynamics relative to gas usage. 
<img src="images/el-architecture/blob-gas-and-price-norm.png" width="800"/>

* The blob gas price remains at 1 when the parent block's gas usage is below the target (~400K, corresponding to approximately 400KB or 3 blobs per block). A maximum of about 800K maps to roughly 800KB or 6 blobs per block.
* Surpassing the target does not immediately affect the gas price, but excess gas begins to accumulate.
* Persistent demand increases, causing the accumulated excess gas to surpass a threshold, triggering an exponential increase in the gas price as a regulatory measure.
* Accumulated excess gas can be cleared in one block if the gas usage of the preceding block falls below the target, resetting the adjustment mechanism.

#TODO link client code

## Blob Gas Fee
$$ blobGasFee \equiv totalBlobGas \times blobGasPrice $$

##  Max  Gas Fee
$$
 maxGasFee \equiv 
\begin{aligned}
&\begin{cases} 
T_{gasLimit} \times  T_{gasPrice}    , & \text{if} \space T_{type} = 0 \lor 1\\
T_{gasLimit} \times  T_{maxFeePerGas}   , & \text{if} \space T_{type} = 2 \\
(T_{gasLimit} \times  T_{maxFeePerGas}) +  maxBlobFee  , & \text{if} \space T_{type} =  3 
\end{cases}\\
\end{aligned} 
$$

$$
maxBlobFee \equiv 
T_{maxFeePerBlobGas} \times totalBlobGas 
$$

## Up-Front Cost
$$
v_0 \equiv upfrontCost \equiv  effectiveGasFee + blobGasFee
$$

| function | Geth | Reth | Erigon | Nethermind | Besu |
|----------|------|------|--------|------------|------|
| upfront cost  | [buyGas](https://github.com/ethereum/go-ethereum/blob/14cc967d1964d3366252193cadd4bfcb4c927ac1/core/state_transition.go#L236)    |[deduct_caller_inner](https://github.com/bluealloy/revm/blob/e7363d7dc5693550c72cd2773e4278f167b1cac9/crates/revm/src/handler/mainnet/pre_execution.rs#L48) calls [calc_data_fee](https://github.com/bluealloy/revm/blob/e7363d7dc5693550c72cd2773e4278f167b1cac9/crates/primitives/src/env.rs#L55) for blob calculation |   [buyGas](https://github.com/ledgerwatch/erigon/blob/8e39498d5d49935dbdc2b071007a74fb85b9e42b/core/state_transition.go#L195)   |            |      |

# Transaction Execution 

The process of executing a transaction within the Ethereum network is governed by the transaction-level state transition function:

$$ \Upsilon(\sigma_t, T_{index}) \tag{4}$$

Upon invocation of $\Upsilon$, the system first verifies the intrinsic validity of the transaction. Once validated, the Ethereum Virtual Machine (EVM) initiates state modifications based on the transaction's directives.

## Transaction  Intrinsic Validity
The intrinsic validity of a transaction is determined through a series of checks:

$$
\begin{align}
(65)\quad Sender(T) &\neq EMPTY(\sigma, account) \\ \land \nonumber\\
\sigma[Sender(T)]_{code} &= \text{KEC}(\emptyset) \\ \land \nonumber\\
T_{nonce} &< 2^{64} - 1 \\ \land \nonumber \\
T_{inputData} &\leq 2 \times MaxCodeSize_{=24576}\\ \land \nonumber \\
T_{nonce} &= \sigma[Sender(T)]_{nonce} \\ \land \nonumber \\
intrinsicGas &\leq T_{gasLimit}\\ \land \nonumber \\
maxGasFee + T_{value} &\leq \sigma[Sender(T)]_{balance}\\ \land \nonumber \\
m &\geq H_{baseFeePerGas}\\ \land \nonumber \\
\text{if} \space T_{type} = 2 \lor 3 : T_{maxFeePerGas} &\geq T_{maxPriorityFeePerGas} \\ \land \nonumber \\
T_{gasLimit} \leq Header_{gasLimit} \nonumber \\ &− last( \left[ Block_{reciept} \right] )_{cumulativeGasUsed} \\
\end{align}
$$
$$\text{Where, }m \equiv 
\begin{aligned} \\
&\begin{cases} 
T_{gasPrice}, & \text{if} \space T_{type} = 0 \lor 1\\
T_{maxFeePerGas} , & \text{if} \space T_{type} = 2 \lor 3
\end{cases}\\
\end{aligned} 
$$
And $EMPTY(\sigma, account)$ is defined as an account with no code, zero nonce, and zero balance:
$$
\begin{align}
EMPTY(\sigma, account) \nonumber \\ \equiv \nonumber \\
\sigma[account]_{code} = \text{KEC}(\emptyset) \nonumber \\ \land  \nonumber \\
\sigma[account]_{nonce} = 0 \nonumber \\ \land  \nonumber \\
\sigma[account]_{balance} = 0 \nonumber \\
\end{align}
$$
|||
|-|-|
|1 |The transaction sender must exist and cannot be an uninitialized account|
|2 |The sender cannot be a contract|
|3 |Transactions from an account are capped, ensuring a nonce less than $2^{64} - 1$.|
|4 |The size of input data or CALLDATA must not exceed twice the maximum code size (24576 bytes).|
|5 |The transaction's nonce must match the current nonce of the sender in the state|
|6 |The intrinsic gas calculation must not exceed the transaction's gas limit.|
|7 |The sender must have sufficient balance to cover the maximum gas fee plus the value being sent.|
|8 |Ensures the transaction meets the minimum base fee per gas of the block|
|9 |For EIP-1559 transactions, the max fee per gas must be at least as high as the max priority fee per gas|
|10 |The transaction's gas limit, plus the gas used by previous transactions in the block, must not exceed the block'|

## $T$ Execution stage 1 : checkpoint state $\sigma_0$

The initial stage of transaction execution includes the following steps:

1. **Validate Transaction**: Assess the transaction's validity; if it passes, changes to the state are irrevocably initiated.
2. **Deduct Intrinsic Gas**: The intrinsic gas amount $g_0$ is subtracted from the transaction's gas limit to establish the gas parameter for message preparation: $gas = T_{gasLimit} - g_0$.
3. **Increment Sender's Nonce**: Reflect an irrevocable change in the sender's state by incrementing the nonce.
4. **Deduct Upfront Cost**: The sender's balance is reduced by the upfront cost, another irreversible change to the state.

$$ \sigma_0 \equiv \sigma \space \text{except:} $$
$$ \sigma_0[Sender]_{balance} \equiv \sigma[Sender]_{balance} - upfrontCost_{\nu_0} $$
$$ \sigma_0[Sender]_{nonce} \equiv \sigma[Sender]_{nonce} + 1 $$

This checkpoint state represents the modified state after initial validations and deductions, setting the groundwork for subsequent execution steps.


## $T$ Execution stage 2 :  Transaction Normalization and Substate Initialisiation

EVM executions fundamentally require just an environment and a message. Therefore, transactions within a transaction envelope, which categorize transactions by type, are streamlined into four main types. These transactions are then unified into a singular Message Data structure, delineating two main actions: initiating contract creations and executing calls to addresses. Notably, for transactions predating EIP-1559 that lack a base fee, they undergo normalization to integrate the [Gas price](https://github.com/ethereum/go-ethereum/blob/100c0f47debad7924acefd48382bd799b67693cf/core/state_transition.go#L168) during their transformation into the message format. Moreover, the execution path is determined based on the $T_{to}$ parameter:

* if $T_{to} = 0Bytes$ : Proceed with execution of contract creation  
* if $T_{to} = Address$ : Proceed with execution of a call  

This maps to the internal Message type in EELS as :

$$
message(caller, target, gas, value,\\  data, code, depth, current Target ,\\ codeAddress,  shouldTransferValue, isStatic,\\ preAccessedAddresses, preAccesedStorageKeys,\\ parentEVM)
$$

| Message Field parameter | Initial Call Value  | Initial Creation Value | Execution Environment Forward Mapping
|---|---|---|---|
| caller  |  Recovered Sender Address   | Recovered Sender Address |  $I_origin$ or  $I_{sender}$ |
| target  |  $T_{to}$ is a valid Address   | $T_{to} = 0_{bytes}$  |  |
| gas  |  $T_{gasLimit} - intrinsicCost$   |  $T_{gasLimit} - intrinsicCost$ |
| value  |  $T_{value}$   |  $T_{value}$ | yp: $I_v$ or $I_{value}$  |
| data  |  $T_{data}$    |  $0_{bytes}$ | yp: $I_d$ or  $I_{data}$|
| code  |  $(T_{to})_{code}$    |  $T_{data}$ | yp: $I_b$ or  $I_{[byteCode]}$|
| depth  |  $0$    |  $0$ | yp: $I_e$ or  $I_{depth}$|
| currentTarget  |  $T_{to}$ |  We compute the contract address by taking the last 20 bytes of $KEC(RLP([Sender_{address}, Sender_{nonce} -1]))$   |  
| codeAddress  |  $T_{to}$ default except when an alternative accounts code needs execution . e.g. 'CALLCODE' calling a precompile|     | yp: $I_a$ or  $I_{codeOwnerAddress}$| 
| shouldTransferValue  | default is True, indicates if ETH should be transferred during executing this message |    default is True  |  
| isStatic  | default is False, indicates is State Modifications are allowed (false means state modifications are allowed) |    default is False  | inveresly related to yp: $I_w$ or $I_{permissionToModifyState}$  | 
| accesslistAddress  | See below | - |  
| accesslistStorageKeys  | - | -|  
| parentEvm  | initially None |  initially None  |  

###  Substate initialisation

The initialization of the substate sets the groundwork for transaction execution, defined as follows:

- **Self-Destruct Set**: Initially empty, indicating no contracts are marked for self-destruction.
- **Log Series**: Starts as an empty tuple, ready to record logs produced during execution.
- **Touched Accounts**: Also begins empty, listing accounts that become "touched" through the transaction.
- **Refund Balance**: Set to 0, accounting for gas refunds that may accumulate.

Depending on the transaction type, accessed addresses are initialized differently:

- For $T_{type} = 0$, the coinbase address, the caller , the current target and all the pre-compile contract addressees are added to the  accessed account  substate
-  For $T_{type} = 1, 2, or \space 3$, the coinbase address , the caller , the current target, all the pre-compiles and those in the access list are  added

$$ A^*  \equiv (A^{*}_{selfDestructSet} = \empty, $$ 
$$ A^{*}_{logSeries} = (), $$
$$ A^{*}_{touchedAcounts} = \empty, $$ 
$$ A^{*}_{refundBalance} = 0 , $$
if $T_{type} = 0$:
$$ A^{*}_{accesedAccountAddresses} =  \{ H_{coinBase},$$ 
$$ Message_{caller}, Message_{current_target}  $$ 
$$ allPrecompiledContract_{addresses}\}$$ 
$$ A^{*}_{accesedStorageKeys} = \empty $$
if $T_{type} = 1 \lor 2 \lor 3$:
$$ A^{*}_{accesedAccountAddresses} =  \{ H_{coinBase},$$ 
$$ { \bigcup_{Entry \in T_{accessList}} \{ Entry_{address}  \}},$$ 
$$ Message_{caller}, Message_{current_target}  $$ 
$$ allPrecompiledContract_{addresses}\}$$ 
$$ A^{*}_{accesedStorageKeys}= $$
$$ { \bigcup_{Entry \in T_{accessList}} \{ \forall i < length(Entry_{storageKeys}), i \in \mathbb{N} : (Entry_{address_{20byte}}, Entry_{storageKeys}[i]_{32byte}  \}}$$ 

`A_{accessedAccountAddresses}` and `A_{accessedStorageKeys}` leverage the mechanism introduced by [Ethereum Access Lists (EIP-2930)](https://eips.ethereum.org/EIPS/eip-2930), detailed further in [this EIP-2930 overview](https://www.rareskills.io/post/eip-2930-optional-access-list-ethereum). This approach creates a distinction in gas costing between addresses and storage keys declared within the transaction's access list (incurring a "warm" cost) and those not included (incurring a "cold" cost). For comprehensive details on the gas costs associated with cold and warm accesses, please refer to [EIP-2929: Gas cost increases for state access opcodes](https://eips.ethereum.org/EIPS/eip-2929), which adjusts the costs to account for state access operations within the EVM.

$ A_{accesedAccountAddresses}$ and  $A_{accesedStorageKeys}$  belong to [Ethereum Access lists](https://www.rareskills.io/post/eip-2930-optional-access-list-ethereum)  [ EIP ](https://eips.ethereum.org/EIPS/eip-2930) which makes a [cost](https://eips.ethereum.org/EIPS/eip-2929) distinction between the addresses the transaction declares it will call and others. The ones outside the access list have have only a cold cost of account access set at 2600 each time we call the address or 2100 when we access the state. Where as the access list eip specifies that the  subsequent calls to the state and account access ,termed "warm cost", will incur a gas of 100. [EIP 3651](https://eips.ethereum.org/EIPS/eip-3651) added the coinbase to the list of accounts that need to be warm before the start of the execution. 

### Message Type : Contract Creation

In the context of the Ethereum Yellow Paper, contract creation is represented by the function:

$$
\Lambda(\sigma, A, s, o, g, p, v, i, e, \zeta, w) \\ or \\
\Lambda(state_{\sigma}, AccruedSubState_{A} , sender_s , originalTransactor_o ,\\  availableGas_g , effectiveGasPrice_p , \\ endowment_v, []evmInitCodeByteArray_i , stackDepth_e , \\  saltForNewAccountAddress_{\zeta}, stateModificationPermission_w)
$$

| $\Lambda$ Call Parameter               | Mapping                    | Notes |
|---------------------------------------|----------------------------|-------|
| $state_{\sigma}$                      | $I_{state}$                | The current state before contract creation begins. |
| $AccruedSubState_{A}$                 | $A^0$                      | Represents the initial substate. |
| $sender_s$                            | $I_{origin}$               | The origin address of the transaction, initiating the contract creation. |
| $originalTransactor_o$                | $I_{origin}$               | The original transactor, identical to the sender in direct transactions. |
| $availableGas_g$                      | $T_{gasLimit} - intrinsicCost$ | The gas available for the contract creation, after deducting the intrinsic cost of the transaction. |
| $effectiveGasPrice_p$                 | $I_{gasPrice}$             | The gas price set for the transaction. |
| $endowment_v$                         | $T_{value}$                | The value transferred to the new contract. |
| $[]evmInitCodeByteArray_i$            | $T_{CALLDATA}$             | The initialization bytecode for the new contract. |
| $stackDepth_e$                        | 0                          | The depth of the call stack at the point of contract creation; initially 0. |
| $saltForNewAccountAddress_{\zeta}$    | $\emptyset$                | Salt used for generating the new contract's address, relevant for create2 operations. |
| $stateModificationPermission_w$       | True, inversely referred by the `is_static` parameter in the Message object, which is set to false | Indicates if the contract creation can modify the state. |

Note: $originalTransactor_o$ can differ from $sender_s$ when the message is not directly triggered by a transaction but rather comes from the execution of EVM code, indicating the versatility of message origination within the EVM execution context.

### Message Type:  Call
TODO

## $T$ Execution Stage 3 :  Main Execution ($\Xi)  $

### Machine State $\mu$ 

$$ \mu \equiv (\mu_{gasAvailable}, \mu_{programCounter},\\ \mu_{memoryContents}, \mu_{activeWordsInMemory},\\ \mu_{stackContents} ) $$
| | initial Value | notes |
|-|-|-|
|$$\mu$$ | | Initial Machine State |
|$$\mu'$$ | | Resultant Machine State after an operation where $ \mu' \equiv \mu \space \text{except :} \\  \mu'_{gas} \equiv \mu_{gas} - C_{generalGasCost}(\sigma, \mu, A, I) $   |
|$$\mu_{gasAvailable}$$ | | total gas available for the transaction |
|$$\mu_{programCounter}$$ | 0 | Natural number counter to track the code position we are in , max number size is 256 bits |
|$$\mu_{memoryContents}$$ | $$[0_{256Bit}, ..., 0_{256Bit}]$$ | word(256bit) Addressed byte array |
|$$\mu_{activeWordsInMemory}$$ | 0  | Length of the active words in memory, expanded in chunks of 32bytes |
|$$ \mu_{stackContents}$$ | | Stack item : word(256bit), Max Items = 1024 |
|$$ \mu_{outputFromNormalHalting}$$ | () | Represents the output(bytes) from the last function call, determined by the normal halting function. While the EELS pyspec features a dedicated field in the EVM object for the output , Geth doesn't; instead, it utilizes the returnData field, which serves the same purpose.|

### Current Operation
The `currentOperation` is determined based on the position of the `programCounter` within the bytecode array:

$$ currentOperation \equiv \\ w \equiv 
\begin{cases}
I_{[byteCode]}[\mu_{programCounter} ] & \text{if} \space  \mu_{programCounter} < length(I_{[byteCode]}) \\
STOP & \text{otherwise} 
\end{cases}
$$
This logic fetches the current operation by accessing the byte at the programCounter's position within the bytecode array. If the programCounter exceeds the length of the bytecode, a STOP operation is issued to halt execution.

Consider the Yellow Paper's definition of the add operator as an illustrative example:
$$ \mu'_{stackContents}[0] \equiv \mu_{stackContents}[0] + \mu_{stackContents}[1]$$

This representation implies a left-sided addition and removal in the stack, akin to queue operations. However, traditional stack operations add and remove items from the right. Translating this to stack-based operations:

$$ 
Add \Rightarrow
$$

$$
x =  Pop(\mu_{stackContents}) \\
y =  Pop(\mu_{stackContents_{itemsRemoved=1}}) \\
result = x + y  \\
Push(\mu_{stackContents_{itemsRemoved=2}}, result)
$$

$$
\Rightarrow \mu_{stackContents^{itemsAdded_{\alpha}=1}_{itemsRemoved_{\delta}=2}} 
$$

When converting to code, the notation $\mu_{s}[number]$ translates to $\mu_{stackContents}[stackLength - 1 - number]$, aligning with the conventional understanding of stack operations.

The Yellow Paper elegantly notates stack-based operations and provides a framework for interpreting these operations within the execution cycle. It specifies that stack items are manipulated from the left-most, lower-indexed part of the array, with unaffected items remaining constant:
$$
\begin{align}
\Delta \equiv \alpha^{itemsAdded}_w - \delta^{itemsRemoved}_w \quad (160) \nonumber\\
& \nonumber \\
\mu'_{stackContents}.length \equiv \mu_{stackContents}.length + \Delta \quad (161) \nonumber \\
& \nonumber \\
\forall x \in [\alpha^{itemsAdded}_w , \mu'_{stackContents}.length) : \mu'_{stackContents}[x] \equiv \mu_{stackContents}[x - \Delta] \quad (162) \nonumber
\end{align}
$$

Equation 162 demonstrates that for each x within the specified range, the modified stack mirrors the original stack at position $x - \Delta$, effectively tracking the original position of stack items post-operation. For example, adding an item [2] to an existing stack [10] results in [2,10], where the original item's new position aligns with $x=Delta$, maintaining the integrity of stack order post-operation.

### Single Execution Cycle

$$
O((\sigma, \mu, A, I)) \equiv (\sigma', \mu', A', I) \quad (159)\\
$$

Where $O$ represents the Execution Cycle, encapsulating the outcome of a single cycle within the state machine. This cycle can modify all components of $\mu$, with explicit specifications for changes to $\mu_{gas}$ and $\mu_{programCounter}$:

| function | EELS(cancun) | Geth | Reth | Erigon | Nethermind | Besu |
|----------|--------------|------|--------|------------|------|-----|
| O |  call [op implementation](https://github.com/ethereum/execution-specs/blob/804a529b4b493a61e586329b440abdaaddef9034/src/ethereum/cancun/vm/interpreter.py#L303) which takes care of deducting gas and incrementing programCounter  | scope of O: [current op](https://github.com/ethereum/go-ethereum/blob/7bb3fb1481acbffd91afe19f802c29b1ae6ea60c/core/vm/interpreter.go#L222)  -> deduct gas -> [execute op](https://github.com/ethereum/go-ethereum/blob/7bb3fb1481acbffd91afe19f802c29b1ae6ea60c/core/vm/interpreter.go#L286) -> [increment programCounter](https://github.com/ethereum/go-ethereum/blob/7bb3fb1481acbffd91afe19f802c29b1ae6ea60c/core/vm/interpreter.go#L290) |||||

#### Resultant Program Counter of a Single Execution Cycle 

The following equation outlines how the execution cycle processes one instruction at a time:

$$
\mu'_{programCounter} \equiv 
\begin{cases}
J_{JUMP}(\mu) \space \text{if }  currentOperation = JUMP \\
J_{JUMP1}(\mu) \space \text{if }  currentOperation = JUMP1 \\
N(\mu_{programCounter}, currentOperation) \space \text{otherwise}
\end{cases}
$$

$$
\text{Where, } \\
NextValidInstruction_N(i_{=programCounter}, w_{=currentOperation}) \equiv \\
\begin{cases}
&\\
programCounter + NumberOfBytes(currentOperation + Data_{currentOperation}) - NumberOfBytes(Operation_{PUSH1}) + 2 \\
\qquad  \text{if } currentOperation \in [PUSH1,PUSH32] \\
&\\
programCounter + 1 \space \text{otherwise}
\end{cases}
$$

* Here if the Operation is $JUMP$, the $J_{JUMP}$ function will set the program counter to the value at the top of the stack.
*   For $JUMP1$ operations, the $J_{JUMP1}$ function sets the program counter to the value at the top of the stack only if the adjacent value in the stack is not 0. Otherwise, it increases the program counter by 1. If the current operation is neither $JUMP$ nor $JUMP1$, the program counter will be incremented by the NextValidInstruction function.

The NextValidInstruction function determines that if the current operation is within the range of all PUSH operations, we increment the program counter to the byte immediately following the current operation byte, accounting for the data associated with the operation. This data can range from 1 to 32 bytes, depending on the specific PUSH operation. If the operation is not a PUSH operation, we simply increment the program counter by 1, advancing to the next byte of the code. This process highlights that PUSH instructions are responsible for loading data onto the stack from the code.

When the program counter executes a jump operation, it must target a valid jump destination. The $ValidJumpDestinations_{D}$ function specifies the set of all valid jump destinations.

$$
ValidJumpDestinations_{D}(byteCode) \equiv \\
ValidJumpDestinations_{D_J}(byteCode,index) \equiv \\
\begin{cases}
\{\}  \quad \text{  if } index \geq Length(byteCode) \\
&\\
\{i\} \cup ValidJumpDestinations_{D_J}(byteCode,NextValidInstruction(index, byteCode[index])) \\
\space \qquad \text{if }  byteCode[index] = JUMPDEST \\
&\\
ValidJumpDestinations_{D_J}(byteCode,NextValidInstruction(index, byteCode[index])) \space \text{otherwise}
\end{cases}
$$

This indicates that we include the index in the set if the bytecode at that index corresponds to a JUMPDEST operation. We continue adding these indices by recursively calling the $ValidValidJumpDestinations_{D_J}(byteCode, index)$ function with the index determined by the $NextValidInstruction$ function.

Client Code :

| function | EELS(cancun) | Geth | Reth | Erigon | Nethermind | Besu |
|----------|------|------|--------|------------|------|-----|
| $ValidJumpDestinations_{D}(byteCode)$ |  [get_valid_jump_destinations](https://github.com/ethereum/execution-specs/blob/804a529b4b493a61e586329b440abdaaddef9034/src/ethereum/cancun/vm/runtime.py#L21)  | Geth has a [jumpTable](https://github.com/ethereum/go-ethereum/blob/7bb3fb1481acbffd91afe19f802c29b1ae6ea60c/core/vm/interpreter.go#L98) with all fork ops and [validJumpDest](https://github.com/ethereum/go-ethereum/blob/7bb3fb1481acbffd91afe19f802c29b1ae6ea60c/core/vm/contract.go#L84)   |      |        |            |      |

#### Resultant Gas Consumption in a Single Execution Cycle

$$
\mu'_{gas} \equiv \mu_{gas} - C_{gasCost}(\sigma, \mu, AccruedSubState, Environment_I)
$$

The gas cost function, while not overly complex, encompasses various cases for different operations. It is succinctly defined in Appendix H of the Yellow Paper. In essence, it calculates the total cost of the current cycle by adding the cost of the current operation to the difference between the cost of active words in memory before and after the cycle (memory expansion cost).

Different clients handle gas costs differently. In PySpec, various types of cost processing are integrated into the operations, while in Geth, gas costs are handled before the operation executes. Moreover, Geth distinguishes between [dynamic](https://github.com/ethereum/go-ethereum/blob/7bb3fb1481acbffd91afe19f802c29b1ae6ea60c/core/vm/interpreter.go#L257) costs used for memory expansion  and [constant](https://github.com/ethereum/go-ethereum/blob/7bb3fb1481acbffd91afe19f802c29b1ae6ea60c/core/vm/interpreter.go#L224) gas  associated with the base cost of the operation. Both types of costs are deducted using the  [UseGas](https://github.com/ethereum/go-ethereum/blob/7bb3fb1481acbffd91afe19f802c29b1ae6ea60c/core/vm/contract.go#L161) function

### Program Execution $\Xi$ :
$$(\sigma^{'}_{resultantState}, gas_{remaining}, A^{resultantAccruedSubState}, \omicron^{Output})$$ $$ \equiv \Xi(\sigma,gas,A^{accruedSubState}, Environment_I)$$

The Program Execution function is defined formally by the function X, the only difference is $\Xi$ calls X and returns the output of X removing the $Environment_I$ from the output tuple.  

#### Recursive Execution Function X

X orchestrates the execution of the entire code. This is typically implemented by clients as a main loop iterating over the code. However, its definition is recursive:

$$
X((\sigma,\mu,AccruedSubState,Environment_I)) \equiv  \nonumber \\
\begin{cases}
&\\
(\empty, \mu, AccruedSubState, Environment_I) \\ \qquad \text{if } Z_{exceptionalHalting}(\sigma, \mu, AccruedSubState, Environment_I) \\
&\\
(\empty, \mu', AccruedSubState, Environment_I, output ) \\ \qquad \text{if }  currentOperation_w = REVERT \\
&\\
O(\sigma, \mu', AccruedSubState, Environment_I) . output  \\ \qquad \text{if }  output  \neq \empty \\
&\\
X(O(\sigma, \mu', AccruedSubState, Environment_I)) \\ \qquad \text{otherwise}
&\\
\end{cases}
$$

$$
\text{Where}, \\
\mu'_{returnData} \equiv \mu'_{outputFromNormalHalting} \equiv output \equiv H_{normalHaltingFunction}(\mu,Environment_I) 
$$

$$
O(\sigma,\mu,A,I).output \equiv O(\sigma,\mu,A,I,output)
$$

$$
\mu' \equiv \mu \text{ except:} \\
\mu'_{gas} \equiv \mu_{gas} - C_{gasCostFunction}(\sigma,\mu,A,I) \\ 
\mu'_{activeWordsInMemory} \equiv 32 * M_{memoryExpansionForRangeFunction}(\mu_{activeWordsInMemory}, \mu_{stackContents}[0], \mu_{stackContents}[1])
$$
1. If the conditions for Exceptional Halting are met, return a tuple consisting of an empty state, the machine state, accrued sub state, environment, and an empty output.
2. If the current Operation is $REVERT$, return a tuple consisting of an empty state, the machine state after deducting gas, accrued sub state, environment, and the machine output.
3. If the machine output is not empty, the execution iterator function $O$ consumes the output.
  - For instance, if the current operation is a system operation such as CALL, CALLCODE, [DELEGATECALL](https://github.com/ethereum/execution-specs/blob/9c24cd78e49ce6cb9637d1dabb679a5099a58169/src/ethereum/cancun/vm/instructions/system.py#L542), or STATICCALL, these calls invoke the [generic call function](https://github.com/ethereum/execution-specs/blob/9c24cd78e49ce6cb9637d1dabb679a5099a58169/src/ethereum/cancun/vm/instructions/system.py#L267), setting up a new message and a child EVM process. The output of this process is then [written back into the memory](https://github.com/ethereum/execution-specs/blob/9c24cd78e49ce6cb9637d1dabb679a5099a58169/src/ethereum/cancun/vm/instructions/system.py#L325) of the parent EVM process, effectively consuming the output in one iteration of $O$, which may be utilized in the next iteration.
4. In all other scenarios, we simply continue  recursively calling the iterator function. In simpler terms, this means we proceed with the main interpreter loop

| function | EELS(cancun) | Geth | Reth | Erigon | Nethermind | Besu |
|----------|--------------|------|--------|------------|------|-----|
| X        |   starts from [try](https://github.com/ethereum/execution-specs/blob/804a529b4b493a61e586329b440abdaaddef9034/src/ethereum/cancun/vm/interpreter.py#L289) in execute_code          | [interpreter main loop]( https://github.com/ethereum/go-ethereum/blob/7bb3fb1481acbffd91afe19f802c29b1ae6ea60c/core/vm/interpreter.go#L215)     |      |        |            |      |

#### Normal Halting H

The $H_{normalHaltingFunction}$ defines the halting behavior of the EVM under normal circumstances:

$$
H_{normalHaltingFunction}(\mu, Environment_I) \equiv 
$$

$$
\begin{cases}
H_{RETURN}(\mu) & \text{if } \text{currentOperation} \in \{ \text{RETURN}, \text{REVERT} \} \\ 
() & \text{if } \text{currentOperation} \in \{ \text{STOP}, \text{SELFDESTRUCT} \} \\
\empty & \text{otherwise}
\end{cases}
$$

Where:
- $H_{RETURN}(\mu) \equiv \mu'$

- $\Delta_{expansion}$ is calculated as:
  - $\Delta_{expansion} \equiv 32 \times M_{memoryExpansionForRangeFunction}(length(\mu_{memoryContents}), startPos, memorySize)$
  - $\Delta_{expansion} \in \mathbb{N}$

- $\mu'$ is defined as:
  - $\mu' \equiv \mu$ except:
    - $\mu'_{memoryContents} \equiv \mu_{memoryContents} + [0_{\text{word}_{256\text{bit}}} ... 0_{\text{word}_{256\text{bit}}}]_{\text{length}=\Delta_{expansion}}$
    - $\mu'_{output} \equiv \mu'_{memoryContents}[startPos : startPos + memorySize]$
    - $\mu'_{gas} \equiv \mu_{gas} - \text{memoryExpansionCost}$
    - $\mu'_{running} \equiv false$

Where:
- $startPos \equiv  \mu_{stackContents}[0]$
- $memorySize \equiv  \mu_{stackContents}[1]$

The function $M_{memoryExpansionForRangeFunction}(s,f,l)$ determines the memory expansion required to accommodate the range specified:

$$
M_{memoryExpansionForRangeFunction}(s,f,l) \equiv
$$

$$
\begin{cases}
S & \text{if } l = 0 \\
\text{max}(s, \lceil (f + l) / 32 \rceil) & \text{otherwise}
\end{cases}
$$

In essence, the $H_{normalHaltingFunction}$ first sets the start index and length of the output based on the top two stack items. If memory expansion is needed to accommodate the output, it expands the memory accordingly, incurring memory expansion costs if necessary. Finally, it sets the EVM's output to the specified memory range.

| function | EELS(cancun) | Geth | Reth | Erigon | Nethermind | Besu |
|----------|--------------|------|--------|------------|------|-----|
|  $H_{normalHaltingFunction}$ | [RETURN](https://github.com/ethereum/execution-specs/blob/9c24cd78e49ce6cb9637d1dabb679a5099a58169/src/ethereum/cancun/vm/instructions/system.py#L235), [REVERT](https://github.com/ethereum/execution-specs/blob/9c24cd78e49ce6cb9637d1dabb679a5099a58169/src/ethereum/cancun/vm/instructions/system.py#L662) | |

#### Exception Halting Z

## $T$ Execution stage 4 : Provisional State  $\sigma_p$
TODO

## $T$ Execution  stage 5 : Pre-Final State  $\sigma^*$
TODO

## $T$ Execution stage 6 : Final State  $\sigma'$
TODO

# Block holistic Validity
TODO

# Appendix
## Code A

```R
#imports

library(plotly)
library(dplyr)

# values for xi and rho
# this is how '<-' assignment works in R

ELASTICITY_MULTIPLIER <- 2
BASE_FEE_MAX_CHANGE_DENOMINATOR <- 8

# Slightly modified function from the spec

calculate_base_fee_per_gas <- function(parent_gas_limit, parent_gas_used, parent_base_fee_per_gas, max_change_denom = BASE_FEE_MAX_CHANGE_DENOMINATOR , elasticity_multiplier = ELASTICITY_MULTIPLIER) {

  #  %/% == // (in python) == floor

  parent_gas_target <- parent_gas_limit %/% elasticity_multiplier
  if (parent_gas_used == parent_gas_target) {
    expected_base_fee_per_gas <- parent_base_fee_per_gas
  } else if (parent_gas_used > parent_gas_target) {
    gas_used_delta <- parent_gas_used - parent_gas_target
    parent_fee_gas_delta <- parent_base_fee_per_gas * gas_used_delta
    target_fee_gas_delta <- parent_fee_gas_delta %/% parent_gas_target
    base_fee_per_gas_delta <- max(target_fee_gas_delta %/% max_change_denom, 1)
    expected_base_fee_per_gas <- parent_base_fee_per_gas + base_fee_per_gas_delta
  } else {
    gas_used_delta <- parent_gas_target - parent_gas_used
    parent_fee_gas_delta <- parent_base_fee_per_gas * gas_used_delta
    target_fee_gas_delta <- parent_fee_gas_delta %/% parent_gas_target
    base_fee_per_gas_delta <- target_fee_gas_delta %/% BASE_FEE_MAX_CHANGE_DENOMINATOR
    expected_base_fee_per_gas <- parent_base_fee_per_gas - base_fee_per_gas_delta
  }
  return(expected_base_fee_per_gas)
}
```
After defining the model in R, we proceed by simulating the function across a range of gasused scenarios:

```R
parent_gas_limit <- 30000  # Fixed for simplification

# lets see the effect on 100 to see the percentage effect this function has on fee
parent_base_fee_per_gas <- 100

# note gas used can not go below the minimum limit of 5k ,
# therefore we can just count from 5k to 30k by ones for complete precision 

seq_parent_gas_used <- seq(5000, parent_gas_limit, by = 1) # creates a vector / column

# add the vector / column to the data frame 

data <- expand.grid(parent_gas_used = seq_parent_gas_used)

# apply the function we created above and collect it in a new column

data$expected_base_fee <- mapply(calculate_base_fee_per_gas, parent_gas_limit, data$parent_gas_used, parent_base_fee_per_gas)
```

That's all for  prep , now let's plot and observe  by doing a scatter plot which will reveal any shape this function produces over a range; given the constraints.

```R 
fig <- plot_ly(data, x = ~parent_gas_used, y = ~expected_base_fee, type = 'scatter', mode = 'markers')  # scatter plot

# %>% is a pipe operater from dplyr , used extensively in R codebases it's like the pipe | operator used in shell

fig <- fig %>% layout(xaxis = list(title = "Parent Gas Used"),
                      yaxis = list(title = "Expected Base Fee "))

# display the plot
fig
```
## Code B

```r

library(forcats)
library(ggplot2)
library(scales)
library(viridis)

# Initial parameters
initial_gas_limit <- 30000000
initial_base_fee <- 100
num_blocks <- 100000

# Sequence of blocks
blocks <- 1:num_blocks

max_natural_number <- 2^256  

# Calculate gas limit for each block
gas_limits <- numeric(length = num_blocks)
expected_base_fee <- numeric(length = num_blocks)
gas_limits[1] <- initial_gas_limit
expected_base_fee[1] <- initial_base_fee

for (i in 2:num_blocks) {
  
   # apply max change to gas_limit at each block
    gas_limits[i] <- gas_limits[i-1] + gas_limits[i-1] %/% 1024
  

  # Check if the previous expected_base_fee has already reached the threshold
  if (expected_base_fee[i-1] >= max_natural_number) {
    # Once max_natural_number is reached or exceeded, stop increasing expected_base_fee
    expected_base_fee[i] <- expected_base_fee[i-1]
  } else {
    # Calculate expected_base_fee normally until the threshold is reached
    expected_base_fee[i] <- calculate_base_fee_per_gas(gas_limits[i-1], gas_limits[i], expected_base_fee[i-1])
  }
}

# Create data frame for plotting
data <- data.frame(Block = blocks, GasLimit = gas_limits, BaseFee = expected_base_fee)

# Saner labels
label_custom <- function(labels) {
  sapply(labels, function(label) {
    if (is.na(label)) {
      return(NA)
    }
    if (label >= 1e46) {
      paste(format(round(label / 1e46, 2), nsmall = 2), "× 10^46", sep = "")
    } else if (label >= 1e12) {
      paste(format(round(label / 1e12, 2), nsmall = 2), "T", sep = "")  # Trillions
    } else if (label >= 1e9) {
      paste(format(round(label / 1e9, 1), nsmall = 1), "Billion", sep = "")  # Million
    } else if (label >= 1e6) {
      paste(format(round(label / 1e6, 1), nsmall = 1), "Mil", sep = "")  # Million
    } else if (label >= 1e3) {
      paste(format(round(label / 1e3, 1), nsmall = 1), "k", sep = "")  # Thousand
    } else {
      as.character(label)
    }
  })
}

# Bin the ranges we want to observe
data_ranges <- data %>%
  mutate(Range = case_when(
    Block <= 1000 ~ "1-1000",
    Block <= 10000 ~ "1001-10000",
    Block <= 100000 ~ "10001-100000"
  ))

# Rearrange the bins to control where the plots are displayed
data_ranges$Range <- fct_relevel(data_ranges$Range, "1-1000", "1001-10000", "10001-100000")

# Grammar of graphics we can just + the features we want in the plot
plot <- ggplot(data_ranges, aes(x = Block, y = GasLimit, color = BaseFee)) +
  geom_line() +
  facet_wrap(~Range, scales = "free") +  # Using free to allow each facet to have its own x-axis scale
  labs(title = "Gas Limit Over Different Block Ranges",
       x = "Block Number",
       y = "Gas Limit") +
  scale_x_continuous(labels = label_custom) +  # Use custom label function for x-axis
  scale_y_continuous(labels = label_custom) +  # Use custom label function for y-axis
  scale_color_gradientn(colors = viridis(8), trans = "log10",
                        breaks = c(1e3, 1e10, 1e20, 1e40, 1e60, 1e76),
                        labels = c("100", "10^10", "10^20", "10^40", "10^60", "10^76")) +
  theme_bw() 

# To view
plot

# Save to file
ggsave("plot_gas_limit.png", plot, width = 7, height = 5)
  
```
## Code C

```r 
# we are observing the effects of this parameter
# it's set at 8 but lets see its effect in the range of [2,4, .. ,8, .. ,12]
seq_max_change_denom <- seq(2, 12, by = 2)

parent_gas_limit <- 3 * 10^6  
seq_parent_gas_used <- seq(5000, parent_gas_limit, by = 100)

parent_base_fee_per_gas <- 100

data <- expand.grid( parent_gas_used = seq_parent_gas_used, base_fee_max_change_denominator = seq_max_change_denom)

data$expected_base_fee <- mapply(calculate_base_fee_per_gas, parent_gas_limit, data$parent_gas_used, parent_base_fee_per_gas, data$base_fee_max_change_denominator)
```

Thats all for data prep , now lets plot:

```r 
plot <- ggplot(data, aes(x = parent_gas_used, y = expected_base_fee, color = as.factor(base_fee_max_change_denominator))) +
    geom_point() +
    scale_color_brewer(palette = "Spectral") +
    theme_minimal() +
    labs(color = "Base Fee Max Change Denominator") +
    theme_bw()

plot
```
## Code D

```r
seq_elasticity_multiplier <- seq(1, 6, by = 1)
seq_max_change_denom <- seq(2, 12, by = 2)

parent_gas_limit <- 3 * 10^6  
seq_parent_gas_used <- seq(5000, parent_gas_limit, by = 500)

parent_base_fee_per_gas <- 100

data <- expand.grid( parent_gas_used = seq_parent_gas_used, base_fee_max_change_denominator = seq_max_change_denom, elasticity_multiplier = seq_elasticity_multiplier)

data$expected_base_fee <- mapply(calculate_base_fee_per_gas, parent_gas_limit, data$parent_gas_used, parent_base_fee_per_gas, data$base_fee_max_change_denominator, data$elasticity_multiplier)

plot <- ggplot(data, aes(x = parent_gas_used, y = expected_base_fee, color = as.factor(base_fee_max_change_denominator))) +
    geom_point() +
    facet_wrap(~elasticity_multiplier) +  #  we break the plots out by the this facet
    scale_color_brewer(palette = "Spectral") +
    theme_minimal() +
    labs(color = "Base Fee Max Change Denominator") +
    theme_bw()

ggsave("rho-xi.png", plot, width = 14, height = 10)

```
## Code E
```r
library(ggplot2)
library(tidyr)

# fake exponential or taylor series expansion function  
fake_exponential <- function(factor, numerator, denominator) {
    i <- 1
    output <- 0
    numerator_accum <- factor * denominator
    while(numerator_accum > 0){
      output <- output + numerator_accum
      numerator_accum <- (numerator_accum * numerator) %/% (denominator * i)
      i <- i + 1
    }
    output %/% denominator
}

# Blob Gas Target
target_blob_gas_per_block <- 393216

# Blob Gas Max Limit
max_blob_gas_per_block <- 786432

 # Used in header Verificaton
 calc_excess_blob_gas <- function(parent_excess_blob_gas, parent_gas_used) {
   if (parent_gas_used  + parent_excess_blob_gas < target_blob_gas_per_block) {
     return(0)
   } else {
     return(parent_excess_blob_gas + parent_gas_used - target_blob_gas_per_block)
   }
 }

# This is how EL determines the Blob Gas Price
cancun_blob_gas_price <- function(excess_blob_gas) {
  fake_exponential(1, excess_blob_gas, 3338477)
}

# we got from zero to Max each step increasing by 1000
parent_gas_used <- seq(0, max_blob_gas_per_block, by = 1000)
# A column of the same Length
excess_blob_gas <- numeric(length = length(parent_gas_used))
excess_blob_gas[1] <- 0

# We get the T+1(time + 1) excess gas by using values from before
for (i in 2:length(parent_gas_used)) {
  excess_blob_gas[i] <- calc_excess_blob_gas(excess_blob_gas[i - 1],
                                             parent_gas_used[i - 1])
}

data_blob_price <- expand.grid(parent_gas_used = parent_gas_used)
data_blob_price$excess_blob_gas <- excess_blob_gas

# Apply the EL gas price function 
data_blob_price$blob_gas_price <- mapply(cancun_blob_gas_price,
                                         data_blob_price$excess_blob_gas)

# Each row represents a block
data_blob_price$BlockNumber <- seq_along(data_blob_price$parent_gas_used)

# we collapse the 3 columns into 1 Parameter Column
data_long <- pivot_longer(data_blob_price,
                          cols = c(parent_gas_used,
                                   excess_blob_gas,
                                   blob_gas_price),
                          names_to = "Parameter",
                          values_to = "Value")

ggplot(data_long, aes(x = BlockNumber, y = Value)) +
  geom_line() +
  facet_wrap(~ Parameter, scales = "free_y") +   # We break the charts out based on the Parameter Column
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number()) +
  labs(title = "Dynamic Trends in Blob Gas Consumption & Price Over Time",
       x = "Block Number",
       y = "Parameter Value") +
  geom_text(data = subset(data_long, Parameter == "blob_gas_price" &
                            BlockNumber == min(BlockNumber)),
            aes(label = "blobGasPrice = 1", y = 0),
            vjust = -1, hjust = -0.1, size = 3)

```
## Code F
```r
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

data_blob_price$parent_gas_used_normalized <- normalize(data_blob_price$parent_gas_used)
data_blob_price$excess_blob_gas_normalized <- normalize(data_blob_price$excess_blob_gas)
data_blob_price$blob_gas_price_normalized <- normalize(data_blob_price$blob_gas_price)

ggplot(data_blob_price, aes(x = BlockNumber)) +
  geom_line(aes(y = parent_gas_used_normalized, color = "Parent Gas Used")) +
  geom_line(aes(y = excess_blob_gas_normalized, color = "Excess Blob Gas")) +
  geom_line(aes(y = blob_gas_price_normalized, color = "Blob Gas Price")) +
  theme_minimal() +
  labs(title = "Normalized Trends Over Blocks", x = "Block Number", y = "Normalized Value", color = "Parameter")
```

[¹]: https://archive.devcon.org/archive/watch/6/eels-the-future-of-execution-layer-specifications/?tab=YouTube

> [!NOTE]
> All the topics in this PR are open for collaboration on a separate branch
$$
