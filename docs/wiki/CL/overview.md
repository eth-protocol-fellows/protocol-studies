# Consensus layer

> The engine was changed mid-flight! September 15 2022 — the day Ethereum switched to Proof-of-Stake. That new engine is the Consensus Layer, formerly known as Ethereum 2.0’s Beacon Chain.

In Ethereum, reaching a consensus means that atleast 66% or two-thirds of the network's nodes agree on the global state of the blockchain. This formal agreement is crucial for maintaining the network’s integrity and security.

The Consensus Layer defines the mechanism for nodes to agree on the network's state. This layer currently employs Proof-of-Stake (PoS), a crypto-economic system. PoS encourages honest behavior by requiring validators to lock ETH. These validators are responsible for proposing new blocks, validating existing ones, and processing transactions. The protocol enforces rewards and penalties to ensure validator integrity and deter malicious activity.

#### History (Forks and ChainId)

Since Ethereum is a decentralized platform, any participant can attempt to add a new block to an existing chain of blocks. This creates a branching structure of blocks resembling a tree. To determine the main path from the root (the initial genesis block) to the leaf (the most recent block), a consensus mechanism is needed. If nodes disagree on which path represents the official blockchain, this disagreement results in a fork — a split where different nodes might follow different histories beyond a certain point, each considering their chosen history as the correct one. This divergence can lead to incompatible records of transactions, undermining trust in the system.

Since the Paris hard fork, Ethereum manages consensus through a protocol known as the Beacon Chain. This is part of Ethereum's consensus layer, which sets the rules for identifying the valid sequence of blocks.

Occasionally actors do not agree on a protocol change, and a permanent fork occurs. In order to distinguish between diverged blockchains, [EIP-155](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md) by Vitalik introduced the concept of chain ID, which is mathematically denoted by $\beta$. For the Ethereum main network $\beta$ is 1.

## Transition to Proof-of-stake

<!-- Should I add some more stuff on PoW like limitations etc-->

The Paris hard fork marked a significant transition for Ethereum, shifting its consensus mechanism from Proof of Work (PoW) to Proof of Stake (PoS). This change represents a fundamental shift in how blocks are validated and new transactions are added to the blockchain. The transition to Proof-of-Stake (PoS) in Ethereum aimed to address the limitations of Proof-of-Work (PoW), particularly its high energy consumption and scalability issues. PoS was designed to be more efficient and secure by relying on validators who stake ETH as collateral.

### Key Milestones in the Transition: 

- **Casper Research and Development**: Early research into PoS led to the development of the Casper protocol, a fundamental component of Ethereum’s PoS system.
- **Beacon Chain Launch**: In December 2020, the Beacon Chain was launched as a separate PoS blockchain running in parallel with the Ethereum mainnet. It's primary goal was to handle PoS consensus and coordinates validators.
- **The Merge**: A future upgrade that will unify the Beacon Chain with the Ethereum mainnet, completing the transition to PoS.

### Beacon Chain Introduction
The Beacon Chain plays a crucial role in managing the PoS system. It oversees validators who propose and attest to new blocks, ensuring the network’s integrity and security. Validators are selected based on number of criterias one of them being the amount of ETH they stake, which also acts as collateral against dishonest behavior. Some high level responsibilities of validators are:

- Proposing Blocks: Validators take turns proposing new blocks.
- Attesting Blocks: Validators attest to the validity of blocks proposed by others.
- Staking ETH: Validators must stake a minimum of 32 ETH to participate.
- Rewards and Penalties: Validators earn rewards for honest participation and face slashing penalties for malicious actions or inactivity.

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

### Actual Transition

Upon reaching the terminal block:
- **Beacon Chain Takes Over**: The Beacon Chain, already running in parallel to the Ethereum mainnet, assumes responsibility for processing new blocks. Under PoS, blocks are validated by validators who stake their ETH to participate in the consensus mechanism, rather than by miners solving cryptographic puzzles.

- **Security and Efficiency**: This transition not only aims to enhance the security of the Ethereum network by making it more decentralized but also significantly reduces its energy consumption, addressing one of the major criticisms of traditional PoW systems.

- **New Consensus Mechanism**: The consensus under PoS is achieved through a combination of staking, attestation by validators, and algorithms that randomly select block proposers and committees to ensure the network remains secure and transactions are processed efficiently.

The Paris hard fork was a pivotal event in Ethereum's history, setting the stage for more scalable, sustainable, and secure operations. It represents Ethereum's commitment to innovation and its responsiveness to the broader societal concerns about the environmental impact of cryptocurrency mining.

## Proof-of-stake

Proof-of-Stake (PoS) is Ethereum's new consensus mechanism designed to improve security, scalability, and energy efficiency. Unlike Proof-of-Work (PoW), PoS relies on validators who stake Ether (ETH) to participate in the network, rather than miners solving cryptographic puzzles. More details on the actual consensus methods is covered in [CL Architecture]().

### Validators

Validators are essentially the participants in the PoS Protocol. They propose and validate new blocks, ensuring the integrity and security of the blockchain. Validators must stake ETH as collateral, aligning their interests with the network’s health. Validators are chosen to propose blocks based on several factors:

- **Staked ETH**: Validators with more ETH staked have a higher likelihood of being selected. This ensures those with significant investment in the network are chosen.
- **Randomness**: The selection process incorporates cryptographic randomness to prevent predictability and manipulation. This is achieved through the [RANDAO]() and [VDF (Verifiable Delay Function)]() mechanisms.
- **Committees**: Validators are grouped into committees for block proposal and attestation. Each committee is responsible for validating and attesting to blocks, ensuring a decentralized and secure validation process.
- **Staking Requirements**: To become a validator, an individual must deposit a minimum of 32 ETH into the official deposit contract. This ETH acts as collateral to incentivize honest behavior. The validator's ETH is at risk if they fail to perform their duties or engage in malicious activities.

##### Validator Responsibilities:

- **Proposing Blocks**: Validators take turns proposing new blocks during their assigned slots. They must construct valid blocks and broadcast them to the network.
- **Attesting to Blocks**: Validators review and attest to the blocks proposed by others. Attestations are votes on the validity of the blocks, ensuring consensus.
- **Participating in Consensus**: Validators participate in consensus by voting on the state of the blockchain at regular intervals, helping to finalize the blockchain's state.