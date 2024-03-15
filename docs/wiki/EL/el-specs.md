# Execution Layer Specifications

> **Where is it specified?**
>
> - [Yellow Paper paris version 705168a – 2024-03-04](https://ethereum.github.io/yellowpaper/paper.pdf) (note: This is outdated does not take into account post merge updates)
> - [Python Execution Layer specification](https://ethereum.github.io/execution-specs/)
> - EIPs [Look at Readme of the repo](https://github.com/ethereum/execution-specs)


The core of the Ethereum Execution Layer is tasked with executing three types of transactions: legacy, Type 1, and Type 2. These transactions are processed by the quasi-Turing complete Ethereum Virtual Machine (EVM), which allows for virtually any computation, bounded only by gas constraints. This capability positions the EVM as a decentralized world computer, enabling decentralized applications (DApps) to run and transactions to be securely recorded on an immutable ledger. Beyond transaction processing, the EL is instrumental in storing data structures within the State DB. This not only facilitates the observation of current and historical states but also supports the Consensus Layer in block creation and validation. In this analogy, the Execution Layer acts as the CPU, with the Consensus Layer serving as the hard drive. Additionally, the EL defines the parameters of Ethereum's economic model, laying the foundation for blockchain operations.



Beyond its fundamental role, the Execution Layer client undertakes several critical responsibilities. These include synchronizing its blockchain copy, facilitating network communication through gossip protocols with other Execution Layer clients, minting a transaction pool, and fulfilling the Consensus Layer's requirements that drive its functionality. This multifaceted operation ensures the robustness and integrity of the Ethereum network.

The client's architecture is grounded in a series of detailed specifications, each playing a unique role in its comprehensive functionality. This document aims to provide a concise overview of the core specification. For a deeper understanding of how all the specifications seamlessly work together within the Execution Layer Client, please consult the [Execution Layer Architecture](/wiki/EL/el-architecture.md).


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


### Block Header Validation

The process of block header validation, rigorously defined within the Yellow Paper + Spec, encompasses extensive checks, including gas usage, timestamp accuracy, among others. This meticulous validation process ensures every block strictly complies with Ethereum's stringent standards, thereby upholding the network's security and operational stability. Furthermore, it delineates the boundaries of Ethereum's economic model, integrating essential safeguards against inefficiencies and vulnerabilities. Through this process, the Ethereum network achieves a delicate balance between flexibility, allowing for evolution and upgrades, and rigidity, ensuring adherence to core principles and safety measures.

 
The Ethereum economic model, as outlined in [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559), introduces a series of mechanisms aimed at enhancing network efficiency and stability:

*    **Targeted Gas Limit for Reduced Volatility**: By setting the gas target at half the maximum gas limit, Ethereum aims to diminish the volatility that full blocks can cause, ensuring a more predictable transaction processing environment.
*    **Prevention of Unnecessary Delays**: This model seeks to eliminate undue delays for users by optimizing transaction processing times, thus improving the overall user experience on the network.
*    **Stabilizing Block Reward Issuance**: The issuance of block rewards contributes to the system's enhanced stability, providing a more predictable economic landscape for participants.
*    **Predictable Base Fee Adjustments**: EIP-1559 introduces a mechanism for predictable base fee changes, a feature particularly beneficial for wallets. This predictability aids in accurately estimating transaction costs ahead of time, streamlining the transaction creation process.
*    **Base Fee Burn and Priority Fee**: Under this model, miners are entitled to keep the priority fee as an incentive, while the base fee is burned, effectively removing it from circulation. This approach serves as a countermeasure to Ethereum's inflation, promoting a healthier economic environment by reducing the overall supply over time.


The [validity](https://github.com/ethereum/execution-specs/blob/0f9e4345b60d36c23fffaa69f70cf9cdb975f4ba/src/ethereum/shanghai/fork.py#L269) of a block header, as specified in the Yellow Paper, employs a series of criteria to ensure each block adheres to Ethereum's protocol requirements. The parent block, denoted as $P(H)$, plays a crucial role in validating the current block header $H$ . The key conditions for validity include:

$$
V(H) \equiv H_{gasUsed} \leq H_{gasLimit} \tag{57a}$$ $$\land$$ $$ H_{gasLimit} < P(H)_{H_{gasLimit'}} + floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) \tag{57b}$$
$$\land $$ $$ H_{gasLimit} > P(H)_{H_{gasLimit'}} - floor(\frac{P(H)_{H_{gasLimit'}}}{1024} ) \tag{57c}$$ $$\land$$ $$ H_{gasLimit} > 5000\tag{57d}$$ $$ \land  $$  $$H_{timeStamp} > P(H)_{H_{timeStamp'}} \tag{57e}$$ $$\land$$ $$ H_{numberOfAncestors} = P(H)_{H_{numberOfAncestors'}} + 1 \tag{57f}$$ $$\land$$ $$ size(H_{extraData}) \leq 32_{bytes} \tag{57g}$$ $$\land$$ $$ H_{baseFeePerGas} = F(H) \tag{57h}$$ $$\land$$ $$ H_{ommersHash} = KEC(RLP(())) \tag{57j}$$ $$\land$$ $$ H_{difficulty} = 0\tag{57k}$$ $$\land $$ $$H_{nonce} = 0x0000000000000000 \tag{57l}$$ $$\land$$ $$ H_{prevRandao} = PREVRANDAO() \tag{57m}$$


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

Consider the simplicity of incrementing: each natural number can be thought of as a sum of (0 + 1 + 1 + ... + 1), providing a clear path for incrementation or decrementation within smart contracts or transaction processing. This atomic nature of natural numbers, with 0 and 1 as foundational building blocks, enables the construction of robust and provable logic within the Ethereum blockchain, in other words  natural numbers lead to easier proofs.

* Contrasting with Real Numbers (decimals)

In contrast to the infinite divisibility of real numbers, the discrete nature of natural numbers within Ethereum's economic model ensures that operations remain within computable bounds. This distinction is crucial for maintaining network efficiency and security, avoiding the computational complexity and potential vulnerabilities associated with handling real numbers.


**Transaction Parameters and Bounded Natural Numbers**

Furthermore, Ethereum specifies transaction parameters, such as the maximum priority fee per gas  and maximum fee per gas , within a bounded subset of natural numbers $\mathbb{N}_{256}$. This bounding, capped at $2^{256}$ or approximately $10^{77}$, strikes a balance between allowing a vast range of values for transaction processing and ensuring that these values remain within secure, manageable limits.




#### Dynamics of Gas Price Block to Block
Let's delve into the dynamics of the gas price calculation function by exploring its impact across a spectrum of gas usage scenarios, ranging from the minimum possible (5,000 units) to the set gas limit.Our focus is to understand how this function performs within the scope of a single block.

For those interested in a hands-on approach, this analysis can be replicated in R (download R studio and follow along). The procedure outlined below is straightforward and broadly applicable, allowing for adaptation into Python using the actual execution specs.

We aim to analyze the 'calculate base fee per gas' function, which is integral to understanding Ethereum's gas pricing mechanism. The following R code snippet illustrates the implementation of this function:

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

<img src="images/el-architecture/gasused-basefee.png" width="800"/>

Observations from the plot:

-    The function exhibits a step-like linear progression, with the widest variance at the midpoint. This reflects the gas target, set at half the gas limit (15,000 units in this case).
-    The maximum upward change in the base fee is approximately 12.5%, observed at the extreme right of the plot. This represents the maximum possible change when the base fee starts at a hundred.
-    A precise hit on the gas target results in a 1% increase in the base fee. Exceeding the target slightly (e.g., between 15,000 and 17,000 units of gas used) still results in only a 1% increase, illustrating the function's designed elasticity around the target.



#### Extended Simulation: Long-term Effects on Gas Limit and Fee

Having visualized the immediate impact of the gas price calculation function over a range of gas usage scenarios, it's intriguing to consider its effect over an extended period. Specifically, how does this dynamic influence the Ethereum network over tens of thousands of blocks, especially under conditions of maximum demand where each block reaches its gas limit?


The following R code simulates this scenario over 100,000 blocks, assuming a constant maximum demand, to project the evolution of the gas limit and base fee:

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

max_natural_number <- 2^256  # Example cap at 1,000,000

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

<img src="images/el-architecture/gas-limit-max.png" width="800"/>

Observations from the simulation reveal several critical insights:

*    Base Fee Sensitivity: The base fee, measured in wei, escalates rapidly, potentially reaching one ether within a mere 200 blocks under continuous maximum demand.
*    Potential to Hit Upper Limits: Under sustained high demand, the base fee could approach its theoretical maximum in under 2,000 blocks.
*    Unbounded Gas Limit Growth: Unlike the base fee, the gas limit itself is not capped, allowing for continuous growth to accommodate increasing network demand.
*    Market Dynamics and Equilibrium: Real-world demand increases, initially reflected in blocks exceeding their gas targets, lead to rising base fees. However, as the gas limit gradually increases, the gas target (half the gas limit) also rises, eventually stabilizing demand against the higher base fee, reaching a new equilibrium.


With a more nuanced understanding of Ethereum's economic model now in hand, we aim to future-proof our analysis by examining the model's underpinnings at a more granular level. Specifically, we focus on the effects of altering the constants central to the model, notably the elasticity multiplier ($\rho$) and the base fee max change denominator ($\xi$). These constants are not expected to change within a fork but can be re-specified in future protocol upgrades:


let's start with $\xi$ :

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

<img src="images/el-architecture/xi.png" width="800"/>


This is a snapshot between blocks, like our first plot, it represents smallest slice of the potential of the  economic model additionally parameterized by $\xi$ across protocol upgrades

Impact of $\xi$ on base fee:

-    Inflection Point Identification: Analogous to the initial broad observation, this detailed examination reveals the nuanced shifts and inflections attributable to variations in $\xi$. The "kink" or point of inflection in the adjustment trajectory becomes particularly pronounced from this perspective.
-    Adjustment Sensitivity: The slope of the base fee adjustment curve changes significantly beyond the inflection point. As $\xi$ values decrease, we observe a sharp increase in the rate of fee adjustments, indicating heightened sensitivity.
-    Step Width Variability: Increasing $\xi$ results in broader step widths, indicating more gradual fee adjustments. Conversely, decreasing $\xi$ leads to narrower steps and more volatile fee changes.
-    Linear Trend within Target Range: The central portion of the curve, particularly highlighted by the light green line for the current $\xi$ value, showcases a mostly linear trend in fee adjustments as transactions approach or slightly exceed the gas target.


Next, we turn our attention to the elasticity multiplier ($\rho$), another pivotal constant in Ethereum's economic model that directly influences the flexibility and responsiveness of gas limit adjustments. To comprehensively understand its impact, we explore a range of values for $\rho$ from 1 to 6 in conjunction with variations in the base fee max change denominator ($\xi$).

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

<img src="images/el-architecture/rho-xi.png" width="800"/>

Impact of $\rho$ and $\xi$ on Base Fee :


-    Moment-to-Moment Analysis: Similar to our initial observations, this plot offers a granular view into how adjustments in $\rho$ and $\xi$ shape the economic model's behavior on a per-block basis, especially in the context of protocol upgrades.
-    Distinct Influence of $\rho$: Each subplot represents the nuanced effects of varying $\rho$ values. As the elasticity multiplier, $\rho$ notably shifts the inflection point in the base fee adjustment curve, highlighting its critical role in tuning the network's responsiveness to transaction volume fluctuations.
-    Interplay Between $\rho$ and $\xi$: The elasticity multiplier ($\rho$) not only moves the inflection point but also modulates the sensitivity of adjustments attributable to changes in the base fee max change denominator ($\xi$). This interaction underscores the delicate balance Ethereum maintains to ensure network efficiency and stability amidst varying demands.


<img src="images/el-architecture/gas-header.png" width="800"/>

TODO

### Block Execution

TODO

### Block holistic Validity

TODO

[¹]: https://archive.devcon.org/archive/watch/6/eels-the-future-of-execution-layer-specifications/?tab=YouTube

> [!NOTE]
> All the topics in this PR are open for collaboration on a separate branch
$$
