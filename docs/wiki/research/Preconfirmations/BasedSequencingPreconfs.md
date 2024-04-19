# Ethereum Based Sequencing with Preconfirmations

## [Overview](#overview)

Ethereum's evolving ecosystem is set to introduce new paradigms for rollups and chain interactions, emphasizing seamless transitions and enhanced user experiences. This wiki article introduces a framework for Ethereum sequencing and pre-onfirmations, originally proposed by Justin Drake[^1][^4], a step toward realizing this vision, offering a unified platform for all Ethereum chains and rollups. 


## [Motivation](Motivation)

### [United Chains of Ethereum](#united-chains-of-ethereum)

The vision for Ethereum is not just a network of isolated chains but a cohesive ecosystem where all rollups and chains coexist without friction, termed the "United Chains of Ethereum." This concept envisions a scenario where users can move between different states (rollups) with ease, akin to crossing state lines without the need for passports or the imposition of tariffs. Such an environment would not only enhance user experience but also foster a more integrated and efficient blockchain ecosystem.

![United Chains of Ethereum](/docs/wiki/research/img/preconfs/united-chains-of-ethereum.jpg)

_Figure: United Chains of Ethereum, Credit Justin Drake_

### [Ethereum's Services for Rollups](#ethereums-services-for-rollups)

- **Current Services:** Ethereum currently provides two critical services to rollups: settlement and data availability. These services lay the foundation for rollups to operate effectively on Ethereum's decentralized platform.

- **Introduction of Ethereum Sequencing:** Ethereum sequencing, is proposed to complement the existing ones, offering a new resource that rollups can leverage to further optimize their operations. Although sequencing has always been inherent to Ethereum, its potential as a dedicated service for rollups represents an innovative application, akin to the adaptive use of core data for new functionalities.

### [Current Sequencing Options](#current-sequencing-options)

![Sequencing Types](/docs/wiki/research/img/preconfs/based-sequencing-problems-space.png)

_Figure: Different Sequencing Options and their Problem Space, Credit Justin Drake_


#### [Decentralized Sequencing](#decentralized-sequencing)

**Overview:** Decentralized sequencing distributes the responsibility of transaction ordering among multiple nodes rather than a single central authority. This method enhances security and resistance to censorship, as no single node can dictate the transaction order by itself.

**Problems and Challenges:**
- **Complexity in Coordination:** Since multiple nodes are involved in transaction ordering, achieving consensus can be challenging and complex, particularly when the nodes have varying incentives.
- **Network Integrity Maintenance:** Ensuring that all participating nodes follow the protocol without any malicious behavior can be difficult to enforce.
- **Front-Running and MEV:** Miners or validators might exploit their ability to order transactions to extract maximal extractable value (MEV), which can lead to unfair transaction processing and a negative user experience.
- **Resilience to Censorship:** Although decentralized sequencing makes censorship more difficult, it doesn't eliminate the possibility, especially if a collusion of nodes occurs.

#### [Shared Sequencing](#shared-sequencing)

**Concept:** Shared sequencing is a form of decentralized sequencing where the task of ordering transactions is shared among several entities, typically across different layers or platforms. This approach is designed to further decentralize the process and reduce the influence any single participant might have over the sequence of transactions.

**Application:** In Ethereum, shared sequencing could involve various rollups solutions that coordinate to manage transaction order. This coordination can help ensure that transactions are processed efficiently and fairly, reducing the potential for bottlenecks or biased sequencing practices.

**Benefits:** Shared sequencing aims to promote scalability by distributing the load of transaction processing and enhancing the network’s throughput. It also strives for neutrality and fairness in transaction handling, critical for maintaining trust in a decentralized ecosystem.

**Problems and Challenges:**
- **MEV Sharing:** Coordinating MEV sharing, like the approach Espresso is investigating, requires sophisticated mechanisms to fairly distribute MEV across participating rollups and chains[^5].
- **Deposits Sharing:** Solutions like zkSync's deposit sharing are innovative but require widespread adoption and trust among different rollups to function effectively, potentially leading to centralization of trust[^6].
- **Execution Sharing:** Implementation of execution sharing strategies, such as Polygon's aggregation layer, requires standardization and integration across different rollups to ensure compatibility and trustless atomicity[^7].

**Based Sequencing:**

**Concept:** A specialized form of decentralized sequencing that uses the base layer of a Ethereum, Beacon chain, to manage transaction ordering. This method leverages the security and consensus mechanisms of the Beacon chain to ensure that transactions are sequenced in a trustless manner.

**Focus:** Based sequencing aims to integrate the robust security features of the Beacon chain into transaction sequencing, reducing dependency on external sequencers or centralized systems. It aligns with Ethereum's decentralized principles by using the existing Ethereum infrastructure to secure transaction order.

**Integration with Shared Sequencing:** Based sequencing can be a pivotal part of a larger shared sequencing strategy, providing a reliable, secure foundation that other layers or rollups can build upon. It ensures that at least one layer of the transaction ordering process is closely tied to the highly secure, well-tested consensus mechanisms of the Ethereum blockchain.

**Problems and Challenges:**
- **Proposer Responsibility:** Proposers must opt into based sequencing by posting collateral, adding financial risk and responsibility to their role.
- **Inclusion List Management:** The concept of inclusion lists must be maintained and managed carefully to ensure fair transaction inclusion.
- **Consensus Mechanism Dependence:** Based sequencing is inherently tied to the underlying consensus mechanism, which means any issues with the consensus could directly affect transaction sequencing.
- **Preconfirm Complexity:** Implementing preconfirm mechanisms, where users get assurance of transaction execution from proposers, adds complexity to transaction processing and requires a new level of trust and interaction between users and proposers.


## Resources
- [Ethereum Sequencing](https://docs.google.com/presentation/d/1v429N4jdikMIWWkcVwfjMlV2LlOXSawFCMKoBnZVDNU/)
- [Based preconfirmations](https://ethresear.ch/t/based-preconfirmations/17353)
- [Preconfirmations](/docs/wiki/research/Preconfirmations/Preconfirmations.md)
- [Ethereum Sequencing and Preconfirmations Call #1](https://youtu.be/2IK136vz-PM)
- [Espresso Shared Sequencing](https://hackmd.io/@EspressoSystems/SharedSequencing)
- [Zksync Deposit Sharing](https://docs.zksync.io/zk-stack/components/shared-bridges.html)
- [Polygon Aggregate Layer](https://polygon.technology/blog/aggregated-blockchains-a-new-thesis)


## References
[^1]: https://docs.google.com/presentation/d/1v429N4jdikMIWWkcVwfjMlV2LlOXSawFCMKoBnZVDNU/edit#slide=id.g1f1d94ef56e_0_655
[^2]: https://ethresear.ch/t/based-preconfirmations/17353 
[^3]: https://thogiti.github.io/2024/04/07/Based-Preconfirmations.html
[^4]: https://youtu.be/2IK136vz-PM
[^5]: https://hackmd.io/@EspressoSystems/SharedSequencing
[^6]: https://docs.zksync.io/zk-stack/components/shared-bridges.html
[^7]: https://polygon.technology/blog/aggregated-blockchains-a-new-thesis
