# Consensus layer

> The engine was changed mid-flight! September 15 2022 — the day Ethereum switched to Proof-of-Stake. That new engine is the Consensus Layer, formerly known as Ethereum 2.0’s Beacon Chain.

In Ethereum, reaching a consensus means that atleast 66% or two-thirds of the network's nodes agree on the global state of the blockchain. This formal agreement is crucial for maintaining the network’s integrity and security.

The Consensus Layer defines the mechanism for nodes to agree on the network's state. This layer currently employs Proof-of-Stake (PoS), a crypto-economic system. PoS encourages honest behavior by requiring validators to lock ETH. These validators are responsible for proposing new blocks, validating existing ones, and processing transactions. The protocol enforces rewards and penalties to ensure validator integrity and deter malicious activity.


### Forks and ChainId

Since Ethereum is a decentralized platform, any participant can attempt to add a new block to an existing chain of blocks. This creates a branching structure of blocks resembling a tree. To determine the main path from the root (the initial genesis block) to the leaf (the most recent block), a consensus mechanism is needed. If nodes disagree on which path represents the official blockchain, this disagreement results in a fork — a split where different nodes might follow different histories beyond a certain point, each considering their chosen history as the correct one. This divergence can lead to incompatible records of transactions, undermining trust in the system.

Since the Paris hard fork, Ethereum manages consensus through a protocol known as the Beacon Chain. This is part of Ethereum's consensus layer, which sets the rules for identifying the valid sequence of blocks.

Occasionally actors do not agree on a protocol change, and a permanent fork occurs. In order to distinguish between diverged blockchains, [EIP-155](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md) by Vitalik introduced the concept of chain ID, which is mathematically denoted by $\beta$. For the Ethereum main network $\beta$ is 1.

## History

The Paris hard fork marked a significant transition for Ethereum, shifting its consensus mechanism from Proof of Work (PoW) to Proof of Stake (PoS). This change represents a fundamental shift in how blocks are validated and new transactions are added to the blockchain.

### Transition Criteria and Terminal Block

Unlike previous hard forks in Ethereum, which typically occurred at a predetermined block height, the Paris hard fork was designed to activate based on a specific condition known as the "terminal total difficulty" (TTD). This approach was chosen to mitigate potential risks associated with the transition:

1. **Avoiding Malicious Forks**: By using total difficulty instead of block height, the transition avoids scenarios where a minority of hash power could potentially extend a competing PoW chain to reach a predefined block height first, thus creating a malicious fork. This method ensures that the transition to PoS would occur only when the cumulative difficulty of mined blocks reached a critical, predefined threshold, making it much harder for any minority group to influence or hijack the transition.

2. **Definition of Terminal Block**: The terminal block, which is the last block mined using PoW, was defined by the following criteria:
   - The total difficulty of the block ($B_t$) must exceed a predefined threshold (`58750000000000000000000` in this case).
   - The total difficulty of its parent block $P(B_H)_t$ must be less than this threshold.

### Formula for Total Difficulty

Total difficulty ($B_t$) of a block in the PoW system was calculated recursively as:
   - $B_t$ ≡ $P(B_H)_t$ + $H_d$
   - Where $H_d$ is the difficulty of the current block $B$.

This calculation accumulates the difficulty of each block, adding up to a total that reflects the overall computational effort expended to reach the current state of the blockchain.

### Transition to Proof of Stake

Upon reaching the terminal block:
- **Beacon Chain Takes Over**: The Beacon Chain, already running in parallel to the Ethereum mainnet, assumes responsibility for processing new blocks. Under PoS, blocks are validated by validators who stake their ETH to participate in the consensus mechanism, rather than by miners solving cryptographic puzzles.

- **Security and Efficiency**: This transition not only aims to enhance the security of the Ethereum network by making it more decentralized but also significantly reduces its energy consumption, addressing one of the major criticisms of traditional PoW systems.

- **New Consensus Mechanism**: The consensus under PoS is achieved through a combination of staking, attestation by validators, and algorithms that randomly select block proposers and committees to ensure the network remains secure and transactions are processed efficiently.

The Paris hard fork was a pivotal event in Ethereum's history, setting the stage for more scalable, sustainable, and secure operations. It represents Ethereum's commitment to innovation and its responsiveness to the broader societal concerns about the environmental impact of cryptocurrency mining.
