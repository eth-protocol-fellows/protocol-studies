<!-- @format -->

# Proposer Builder Separation (PBS) in Ethereum

[comment]: <> (Feel Free to propose changes)
[comment]: <> (Introduction)

In Ethereum's current system, validators both create and broadcast blocks. They bundle together transactions that they have discovered through the gossip network and package them into a block which is then sent out to peers on the Ethereum network. **Proposer-builder separation (PBS)** splits these tasks across multiple validators. Block builders become responsible for creating blocks and offering them to the block proposer in each slot. The block proposer cannot see the contents of the block, they simply choose the most profitable one, paying a fee to the block builder before sending the block to its peers.

Consensus Layer

[comment]: <> (The consensus layer underpins Ethereum's network security and integrity. PBS interacts with this layer by segregating the duties of proposing and building blocks, thereby streamlining the transaction validation process.)

<!-- Roles Defined
Builder: Responsible for compiling transactions into a block. Builders optimize for transaction inclusion efficiency and profitability.
Proposer: Validates and broadcasts the block to the network. Their role ensures the integrity and fairness of the blockchain.
Current Implementation
PBS introduces a modular approach where builders propose blocks to validators (proposers), who then choose the most suitable block for addition to the blockchain. This mechanism is designed to mitigate centralization risks and improve network throughput. -->

<!-- ### MEV-Boost

MEV-Boost is a solution aimed at reducing the negative impacts of Maximal Extractable Value (MEV) by enabling a fairer and more decentralized selection of blocks, thereby enhancing network security and user fairness. -->

### Challenges and Solutions

PBS presents several challenges, including potential security vulnerabilities and the risk of centralization. Ongoing research focuses on addressing these concerns through innovations such as enhanced PBS (ePBS), inclusion lists, and the Proposal Eligibility Proposals Committee (PEPC).

#### Further Reading and Resources
