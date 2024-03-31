<!-- @format -->

# Research and Proposed Solutions

## Enshrined Proposer-Builder Separation (ePBS)

As explained in this very insightful [ethresear.ch post](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710), Enshrined Proposer-Builder Separation addresses some of the limitations and centralization concerns associated with MEV-Boost, which currently facilitates PBS for about 90% of Ethereum blocks.

<figure style="text-align: center;">
  <img src="../../images/MEV-Boost blocks.png" alt="Evolution of MEV-Boost slot share since The Merge">
  <figcaption style="text-align: center;">Evolution of the portion of blocks built through MEV-Boost since The Merge. Source: <a href="https://mevboost.pics/">mevboost.pics</a></figcaption>
</figure>

Enshrined PBS involves embedding PBS mechanisms directly into Ethereum's consensus layer, which would have two main potential advantages:

- Reduction in centralization risks: Moving PBS into the protocol layer could potentially reduce reliance on third parties with a tendency for centralization, aligning with Ethereum’s core values of decentralization and censorship resistance.
- Security and stability: External dependencies and out-of-protocol software, such as relays, have shown vulnerabilities (e.g., "Low-Carb Crusader" attack). Integrating PBS into the Ethereum protocol can mitigate these risks and reduce the coordination costs associated with maintaining compatibility between various components.

According to the article, ePBS, particularly through Two-Block HeadLock (TBHL) and optimistic relaying, presents a pathway towards addressing current challenges and enhancing the efficiency, security, and decentralization of block production and MEV extraction processes. For a more detailed explanation on ePBS check out the [EPF wiki entry](/wiki/research/PBS/ePBS.md) on the topic.

## Protocol-Enforced Propose Commitments (PEPC)

PEPC is another proposed solution for the shortcomings of PBS and MEV-Boost which advocates for a more open-ended and flexible design than traditional PBS. As explained on this [Mirror post](https://mirror.xyz/ohotties.eth/lBEXiiU7yK91OuSn8QyJPM9Db8GuyDFzCEUAj60BWyI), PEPC aims to provide a generalized infrastructure for proposers to make credible commitments to any outsourced block-building task, which could potentially better accommodate the evolving needs of the Ethereum network, especially with the anticipated expansion of data sharding and rollup adoption.

The goal is to allow proposers to register arbitrary commitments, expressed via EVM execution, that external parties can rely on. This way, anyone can provide services to proposers as long as they satisfy the registered commitments, fostering permissionless innovation. Also, unlike externals solutions such as MEV-Boost, PEPC would integrate commitment satisfaction into the core protocol, blocks being considered valid only if they fulfill the proposer's registered commitments, enhancing security and trustworthiness.

Regarding the need for a flexible approach to proposer duties PEPC aims to provide, it is worth noting that a wide range of outsourcing smart contracts is supported, from full block construction to specific valid transaction inclusions and validity proofs for rollup blocks.

All of this would also be complementary to existing out-of-protocol mechanisms like Eigenlayer, enhancing the credibility of proposer commitments by moving from an optimistic model to a pessimistic enforcement model where violating commitments inherently invalidates blocks.

## EIP-7547: Inclusion Lists

As explained in this [ethereum-magicians.org post](https://ethereum-magicians.org/t/eip-7547-inclusion-lists/17474), inclusion lists aim to provide a mechanism to improve the censorship resistance of Ethereum by allowing proposers to specify a set of transactions that must be promptly included for subsequent blocks to be considered valid.

This way proposers retain some authority over block building without sacrificing MEV rewards, through a mechanism by which transactions can be forcibly included. The simplest approach would be for the proposer to specify a list of transactions they found themselves in the mempool that must be included by the block builder if they want their block to be proposed for the next slot. Although some issues stem from this, such as incentive incompatibilities and exposure of free-data availability, solutions like forward and multiple inclusion lists have been proposed and are being developed to address these challenges, demonstrating the Ethereum community's commitment to refining and advancing the protocol to uphold its core values of decentralization, fairness, and censorship resistance.

## Optimistic Relay (oop)

## Further Reading and Resources

Below are some further readings regarding PBS and related topics:

- [Notes on Proposer-Builder Separation (PBS)](https://barnabe.substack.com/p/pbs)
- [Timing Games and Implications on MEV extraction](https://chorus.one/articles/timing-games-and-implications-on-mev-extraction)
- [Why ePBS](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710)
- [Vitalik on pbs censorship](https://notes.ethereum.org/@vbuterin/pbs_censorship_resistance)
- [Payload timliness committee design for ePBS](https://ethresear.ch/t/payload-timeliness-committee-ptc-an-epbs-design/16054)
- [2-slot PBS](https://ethresear.ch/t/two-slot-proposer-builder-separation/10980)
- [Foward Inclusion Lists](https://notes.ethereum.org/@fradamt/forward-inclusion-lists)
