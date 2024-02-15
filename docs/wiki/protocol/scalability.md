# Scalability
In computer systems, scalability refers to the ability of a system to perform well under increased or expanding workloads. The primary purpose of blockchain is to handle users' transactions and manage network's ledger state. An increase in workload may result from either a higher demand for transactions by existing users or an increase in the volume of users.
> **we can define the scalability of a specific blockchain as its capacity to perform well under an increase in user transaction demands or/and in the volume of users**.

## Blockchain Scalability Limits
Consensus mechanics require most of validator nodes in the network to publicly agree on the next valid block. This directly affects the block latency, which is the time it takes for a new block to be created and validated. The block latency and block size directly determine the transactional throughput of the blockchain, which is measured by the **TPS** (transactions per second) metric.  Block latency can be influenced by a variety of factors, such as the computational power of the network nodes, the complexity of the consensus mechanism, the network traffic and the block size. Hence, a network made up of a few high-performance nodes tightly connected to each other and using large block sizes can result in an exceptional blockchain with high TPS and remarkably low block latency. However, such a network would likely be highly centralized and require users to make significant trust assumptions.

Note the tight relationship between the design and tuning of a blockchain (consensus mechanics, node requirements, state structure and size… ) and its capabilities of decentralization. High hardware or network bandwidth requirements to run a node result in harsh and expensive conditions that make it difficult to do so, directly impacting the number of nodes a blockchain will have. **To ensure decentralization, it is essential to make running a node affordable and feasible for everyone and incentivize users to do it.** Therefore, a game-theory sustainable incentive mechanism must be included by design.

As part of the game-theory mechanism, to maintain the network sustainability, users must pay a fee to include their transactions. The price of fees is determined by market demand, and those who pay higher fees are prioritized. Due to limited TPS, including a transaction in a high decentralized blockchain has become a valuable service. An increase transaction demand for a limited and fixed TPS raises fees to the network usability threshold and requires sacrificing decentralization and/or security in order to scale.

Another obstacle to decentralization is the size of the blockchain state. **The property of data being accessible when it is needed is known as data availability**. Availability of state data must be guaranteed, including availability of enough data to allow any new node in the network to reconstruct the latest version of the blockchain without any trust assumptions. Have to hold all the data to guarantee data availability can result in high storage requirements for nodes and a lengthy synchronization process for new ones, which can hinder decentralization.


> **Recalling the definition of scalability, classical blockchain systems are not scalable for mass adoption**. 

This problem is widely known as the **Blockchain Trilemma**, which states that blockchain networks must sacrifice either security, decentralization, or scalability, and maximizing all three at once is difficult. The holy grail of blockchain technology is to create a secure and decentralized transactional network that can achieve a high TPS rate.


<img src="wiki/protocol/img/scalability/trilemma.png" alt="Blockchain trilemma - Bankless.com" width="500"/>

##  Blockchain Modularity
Modern blockchain designs propose a "divide et impera" approach dividing the system into different specific functional components to independently maximize each vertex of the trilemma. This approach encapsulates the complexity in each part of the system and reduces the systemic complexity through the definition of simpler interaction interfaces for system components. 
Functional components of a blockchain:

- Consensus: Agreement mechanics among nodes of block building and transaction ordering.
- Execution: Transaction execution mechanics that define the state evolution.
- Data availability: Data availability mechanics that ensures that the data is available to be queried when it is required.
- Settlement: Mechanics that guarantee the finality and immutability of transactions.

Modular blockchain approach suggests the separation of a blockchain system into different logical layers which are designed to perform well as a few specific functional components. The result is a scalable blockchain architecture with simpler and more efficient modular components, rather than a large and complex monolithic blockchain that cannot scale effectively.

## Scaling Ethereum
The core Ethereum protocol (Layer 1) is continuously developed by the community through EIPs, which open up the possibility of introducing changes to the base protocol to enhance network scalability.  Furthermore, Ethereum's high level of programmability makes it possible to create scalable solutions on top of the platform (Layers 2).

### Ethereum Layer 1 scaling
#### Split consensus from execution (The Merge).
On September 15, 2022, Ethereum implemented EIP-3675 (Upgrade consensus to Proof-of-Stake) through an event known as The Merge. The Merge has resulted in the deprecation of the Proof-of-Work consensus, which was previously implemented in the same logic layer as execution. Instead, it has been replaced by a much more complex and sophisticated Proof-of-Stake consensus that eliminates the need for energy-intensive mining. This new consensus mechanism enables the network to be secured through  staking ETH. New Proof-of-Stake consensus named [Gasper](https://eips.ethereum.org/assets/eip-2982/arxiv-2003.03052-Combining-GHOST-and-Casper.pdf) runs on its own tech stack and p2p network, this new abstraction layer is known as Beacon Chain. The Beacon Chain has been running and achieving consensus since December 1st, 2020. After a prolonged period of consistent performance without any failures, it was deemed ready to become Ethereum's consensus provider, The Merge gets its name from the union of the two networks.

- Consensus Layer (Beacon Chain): Specifically designed to be really good to reaching consensus. In Ethereum, time is divided up into twelve second units called **slots**, the consensus is reached when a valid block has been proposed in a specific slot. However, occasionally validators might be offline when called to propose a block, meaning slots can sometimes go empty. 

- Execution Layer (State and Transactional Ledger): Driven by the consensus layer, it specializes in managing the transactions mempool, the Ethereum state, and Ethereum block construction and execution.

As result, an Ethereum node requires running two different software components: an execution client (or execution engine) driven by a consensus client through an internal communication protocol (Engine API). Note, that no additional trust assumptions need to be made for the execution Layer to follow and execute consensus decisions since each execution client receives information from the consensus Layer through its corresponding twin consensus client, and both clients operate within the same node’s trust domain.

<img src="wiki/protocol/img/scalability/ethereum-nodes.png" alt="Ethereum Nodes" width="500"/>

Open source and public specifications for each client enhance client diversity. This is because a node can be set up with different combinations of client implementations from various software companies and developer communities. The goal is to achieve a client diversity in which the network is not dominated by a specific combination of execution client + consensus client implementation. This enhances the resilience of the network in case of bugs in the client implementations.

Open source and public specifications for each client enhance client diversity. This is because a node can be set up with different combinations of client implementations from various software companies and developer communities. The goal is to achieve a client diversity in which the network is not dominated by a specific combination of execution client + consensus client implementation. This enhances the resilience of the network in case of bugs in the client implementations.

#### EIP-4844: Shard Blob Transactions (Proto-DankSharding)
TODO

#### Full Data Sharding (Danksharding)
TODO

### Ethereum Layer 2 scaling
## ZK Rollups
TODO

## Optimistic Rollups
TODO

Resources:

[Vitalik The Limits to Blockchain Scalability](https://vitalik.eth.limo/general/2021/05/23/scaling.html), [archived](https://web.archive.org/web/20240205202358/https://vitalik.eth.limo/general/2021/05/23/scaling.html)

[Ethereum Scaling](https://ethereum.org/en/developers/docs/scaling), [archived](https://web.archive.org/web/20240209083702/https://ethereum.org/en/developers/docs/scaling)

[Gemini Cryptopedia The Blockchain Trilemma: Fast, Secure, and Scalable Networks](https://www.gemini.com/cryptopedia/blockchain-trilemma-decentralization-scalability-definition), [archived](https://web.archive.org/web/20240209073156/https://www.gemini.com/cryptopedia/blockchain-trilemma-decentralization-scalability-definition)

[Combining GHOST and Casper](https://eips.ethereum.org/assets/eip-2982/arxiv-2003.03052-Combining-GHOST-and-Casper.pdf), [archived](https://web.archive.org/web/20230907004049/https://eips.ethereum.org/assets/eip-2982/arxiv-2003.03052-Combining-GHOST-and-Casper.pdf)

[EIP-3675: Upgrade consensus to Proof-of-Stake](https://eips.ethereum.org/EIPS/eip-3675), [archived](https://web.archive.org/web/20240213102133/https://eips.ethereum.org/EIPS/eip-3675)

[Ethereum Blocks](https://ethereum.org/developers/docs/blocks), [archived](https://web.archive.org/web/20240214052915/https://ethereum.org/developers/docs/blocks)