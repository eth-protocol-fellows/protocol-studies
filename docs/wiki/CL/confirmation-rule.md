# Fast Confirmation Rule

## 1. Abstract
A Confirmation Rule, within blockchain networks, refers to an algorithm implemented by network
nodes that determines (either probabilistically or deterministically) the permanence of certain blocks on
the blockchain. 

## 2. Fast Confirmation Rule for Ethereum’s consensus protocol.
### 2.1. Intro
Regarding the Ethereum protocol, a confirmation rule is an algorithm run by nodes, enabling them to identify 
a _confirmed chain_ by determining whether a certain block is confirmed. 
When that is the case, the block is guaranteed to never be reorged under certain assumptions, 
primarily about network synchrony and about the percentage of honest stake.

In the context of LMD-GHOST, there is not yet a standardized rule for confirming blocks. The only Confirmation Rule 
currently available for the Ethereum protocol is the FFG Finalization Rule.

The Confirmation Rule is not a replacement for the FFG Finalization Rule, but it is rather complementary to it, since
FFG ensures Finality in asynchronous conditions, and LMD-GHOST is a synchronous protocol.

### 2.1 Use cases for the Fast Confirmation Rule
Scenarios where there is a need for fast confirmation time, and relying on network synchrony is acceptable, 
are possible, e.g. low-value cryptocurrency transactions. 
Implementing the Fast Confirmation Rule in Ethereum, would provide a best-case confirmation time of only 
one block, i.e., 12 seconds.

### 2.2 Confirmation Rule for LMD-GHOST
The Confirmation Rule for LMD-GHOST, would be treated as an independent protocol, and subsequently incorporate it 
into FFG-Casper’s effects. This Confirmation Rule aims for fast block confirmations by adopting a heuristic that 
balances speed against reduced safety guarantees, potentially confirming blocks immediately after their creation 
under optimal conditions.

### 2.3 Algorythm

#### 2.3.3 Algorythm main properties - Safety

#### 2.3.4 Algorythm main properties - Monotonicity

### 2.4. Specification

#### 2.5. Incorporating the rule in to FFG-Casper’s effects. 
This means adding conditions that ensure that once a block is confirmed, the FFG-Casper protocol will 
never remove (filter out) this block from the set of blocks to give as input to the LMD-GHOST protocol.

This is the Confirmation Rule pull request featuring the proposed changes to protocol consensus-specs [^2]

# [Resources]
[^1]: https://arxiv.org/pdf/2405.00549
[^2]: https://github.com/ethereum/consensus-specs/pull/3339
[^3]: https://arxiv.org/pdf/2003.03052
