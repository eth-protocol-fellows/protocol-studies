<!-- @format -->

# Proposer Builder Separation (PBS) in Ethereum

[comment]: <> (Feel Free to propose changes)
[comment]: <> (Introduction)

In Ethereum's current system, validators both create and broadcast blocks. They bundle together transactions that they have discovered through the gossip network and package them into a block which is then sent out to peers on the Ethereum network. **Proposer-builder separation (PBS)** splits these tasks across multiple validators. Block builders become responsible for creating blocks and offering them to the block proposer in each slot. The block proposer cannot see the contents of the block, they simply choose the most profitable one, paying a fee to the block builder before sending the block to its peers.

This page will be covering details about PBS, roles of block proposers and block builders, current state - mev boost, relays, challenges and security issues, proposed solutions and further collection of resources related to the topic.

## Why is PBS important?

PBS is important to the decentralization of Ethereum because it minimizes the compute overhead that is required to become a validator. By doing this, the network lowers the barrier to entry for becoming a validator and incentives a more diverse group of participants. PBS also reflects an overall goal of The Merge to move Ethereum’s network towards a more modular future. Specifically, the transition to PoS is an aggressive move towards decentralization through modularity.

When you break apart the different pieces of block construction, you can decentralize them individually. This allows different actors with different specialties to focus on their particular strengths. The net result is a more capable network with fewer external dependencies and a lower threshold for participation.

## Understanding the Consensus layer

The consensus layer supports Ethereum's network security and integrity. PBS interacts with this layer by dividing/isolating the duties of proposing and building blocks, thereby streamlining the transaction validation process.

#### The Role of the builder

**Block builders** gather, validate, and assemble transactions into a block body. They review the mempool, validate the transactions by ensuring that they meet requirements like gas limits and nonce, and create a data structure containing the transaction data. Block builders are also responsible for ordering the transactions to optimize block space and gas usage. They then make the block body available to block proposers.

#### The Role of the proposer

**Block proposers** take the block bodies provided by the block builders and create a complete block by adding necessary metadata, such as the block header. The header includes details such as the parent block's hash, timestamp, and other data. They also ensure the validity of the blocks by checking the correctness of the block body provided by the builders.

## Current State

Currently, PBS is not yet implemented in the Ethereum mainnet which means right now validators act as both proposers and builders. So each validator is responsible for:

1. **Selecting transactions:** Validators choose which transactions to include in a block based on factors like gas fees and transaction priority.
2. **Building the block:** Validators assemble the chosen transactions into a block and perform necessary computations like verifying signatures and updating the state.
3. **Proposing the block:** Validators propose the constructed block to the network for validation and inclusion in the blockchain.

However, some clients are actively developing and testing PBS implementations. These implementations aim to separate the builder and proposer roles, allowing validators to outsource block construction to specialized builders. This can lead to several potential benefits:

- **Increased validator rewards:** Builders can compete to create the most profitable block for the proposer, potentially leading to higher rewards for validators.
- **Improved network efficiency:** Specialized builders can optimize block construction, leading to more efficient block propagation and processing.
- **Reduced centralization:** By decoupling the roles, PBS can potentially reduce the influence of large mining pools or staking providers that currently dominate both block building and proposing.

## PBS and the Relationship Between Relays, Builders, and Validators

Proposer-Builder Separation (PBS) also introduces a more intricate relationship between different actors in the Ethereum network:

1. **Builders:**
   - Builders are specialized entities that focus on constructing blocks with optimal transaction ordering and inclusion. They compete with each other to create the most profitable block for the proposer, taking into account factors like gas fees, transaction priority, and potential MEV (Maximal Extractable Value).
   - Builders do not directly interact with the blockchain. Instead, they submit their constructed blocks to relays.
2. **Relays:**
   - Relays act as intermediaries between builders and proposers. They receive blocks from builders and forward them to proposers.
   - Relays can perform additional functions like block validation and filtering to ensure that only valid and high-quality blocks are sent to proposers.
   - Some relays may specialize in specific types of blocks, such as those with high MEV potential.
3. **Validators (Proposers):**
   - Under PBS, validators take on the role of proposers. They receive blocks from relays and choose the best one based on predefined criteria, typically the block that offers the highest reward.
   - Once the proposer selects a block, they propose it to the network for validation and inclusion in the blockchain.
   - Validators are still responsible for securing the network and ensuring consensus on the blockchain's state.

This separation of roles creates a more dynamic and specialized block-building process. Builders can focus on optimizing block construction and extracting MEV, while proposers can focus on selecting the best block and maintaining network security.

It's important to note that the specific roles and responsibilities of relays and builders may vary depending on the specific PBS implementation.

   <!-- Maximal Extractable Value (MEV) refers to the profit miners or validators can earn by strategically ordering, including, or excluding transactions in a block. In Ethereum, MEV has gained greater attention as validators extract increasingly more value, especially in DeFi (Decentralized Finance) applications. This can lead to negative consequences, such as frontrunning, increased transaction fees, and unfair advantages for large-scale miners or validators.
   Proposer-builder separation can change the dynamics of MEV extraction in that there could be a redistribution of MEV between the two roles, potentially changing the incentives and rewards associated with each. Since block builders are responsible for transaction ordering and inclusion, they may develop new strategies or promote increased competition that could result in more efficiency and fairer distribution of MEV across the network.

Proposer-builder separation may also reduce the likelihood of frontrunning and other harmful practices, even though it may not eliminate MEV-related issues entirely. -->

<--------------------------->

Current Implementation
PBS introduces a modular approach where builders propose blocks to validators (proposers), who then choose the most suitable block for addition to the blockchain. This mechanism is designed to mitigate centralization risks and improve network throughput.

<!-- ### MEV-Boost

MEV-Boost is a solution aimed at reducing the negative impacts of Maximal Extractable Value (MEV) by enabling a fairer and more decentralized selection of blocks, thereby enhancing network security and user fairness. -->

### Challenges and Solutions

PBS presents several challenges, including potential security vulnerabilities and the risk of centralization. Ongoing research focuses on addressing these concerns through innovations such as enhanced PBS (ePBS), inclusion lists, and the Proposal Eligibility Proposals Committee (PEPC).

#### Further Reading and Resources
