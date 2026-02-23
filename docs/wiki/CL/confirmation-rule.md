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
#### 2.3.1 High-level view
In the research paper [^1], the Confirmation Rule is based on two safety indicators:
* $Q_b^n$ : quantifies the support ratio for a specific block b relative to the total committee weight from the slot of b
to slot n. This indicator **is** directly observable by users.

and

* $P_n^b$ : measures the honest proportion of support for block b; This indicator **is not** directly observable by users.

With a suitable value of $P_n^b$, a user can reliably confirm block b. 

Conversely, under certain adversarial conditions, reaching a specific threshold of $Q_n^b$, allows for the inference of 
$P_n^b$, thereby enabling the confirmation of block b.

#### 2.3.2 System model
**Validators**
-  $W$ a possibly infinite set of validators
- $J$ the set of all honest validators (unknown composition), $J \subseteq W$
- $A$ the set of all Byzantine validators, $A : = W \setminus J$
- $signer(m)$ the signer of a given message $m$

**Confirmation Rule Executors** 

Validators and confirmation rule executors are different entities. 
The latter are those executing the Confirmation Rule by having read-only access to the internal state of an honest
validator of their choice.

**Network Model**

Honest validators have synchronised time
 - $t$ is the time when (any) message is being sent
 - $max(t, GST) + \triangle $ is the time (any) message is being received by

    where
   - $GST = Global Stabilization Time$ - known to all confirmation rule executors
   - $\triangle$ is the maximum message latency after $GST$

**Gossiping** 

It's assumed that any honest validator immediately broadcasts any message that they receive.

**View** 

The view of a validator corresponds to the set of all the messages that the validator has received.
- $V^{v,t}$ represents the set of all messages received by validator $v$ at time $t$.

#### 2.3.3 Algorythm main properties - Safety

#### 2.3.4 Algorythm main properties - Monotonicity

### 2.4. Specification

#### 2.5. Incorporating the rule in to FFG-Casper’s effects. 
This means adding conditions that ensure that once a block is confirmed, the FFG-Casper protocol will 
never remove (filter out) this block from the set of blocks to give as input to the LMD-GHOST protocol.

Confirmation Rule PR [^2]

# [Resources]
[^1]: https://arxiv.org/pdf/2405.00549
[^2]: https://github.com/ethereum/consensus-specs/pull/3339
[^3]: https://arxiv.org/pdf/2003.03052
