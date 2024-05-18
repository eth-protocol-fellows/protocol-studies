# Enshrined Proposer-Builder Separation (ePBS)

## Roadmap tracker

| Upgrade |    URGE     |   Track   |               Topic               |                                                                                          Cross-references                                                                                          |
|:-------:|:-----------:|:---------:|:---------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|  ePBS   | the Scourge | MEV track | Endgame block production pipeline | intersection with: [ET](https://ethresear.ch/t/execution-tickets/17944), [PEPC](https://efdn.notion.site/PEPC-FAQ-0787ba2f77e14efba771ff2d903d67e4), [IL](https://eips.ethereum.org/EIPS/eip-7547) |

## TLDR;

Enshrined Proposer-Builder Separation (ePBS) is about integrating the Proposer-Builder Separation (PBS) mechanism directly into Ethereum’s protocol. This formalizes the separation between block proposers and block builders within the core protocol, aiming to improve efficiency, security, and decentralization.

## What is PBS

Proposer-Builder Separation (PBS) is a design philosophy[^1] which separates the roles of proposing blocks (proposers) and building blocks (builders). This separation helps address challenges and inefficiencies in block production, especially regarding Maximum Extractable Value (MEV). This article assumes reader has some knowledge of [MEV](/wiki/research/PBS/mev.md), [PBS](/wiki/research/PBS/pbs.md), and [MEV-Boost](/wiki/research/PBS/mev-boost.md).

## Overview of ePBS

ePBS integrates PBS directly into Ethereum’s protocol, unlike current external solutions like [MEV-Boost](/wiki/research/PBS/mev-boost.md). This integration aims to streamline the process and enhance security by eliminating the need for external relays.

### Key Differences

- **Proposers**: Validators proposing new blocks, focusing on choosing the block without building it.
- **Builders**: Entities or algorithms assembling blocks to optimize transaction order and offering blocks to proposers via a transparent auction[^2][^3].
- **Relays**: In traditional MEV-Boost, relays mediate communication between proposers and builders. Under ePBS, the protocol itself facilitates this interaction, reducing or redefining the need for external relays.

### Transition from mev-boost to ePBS

Transitioning to ePBS represents a significant shift, aiming to eliminate dependence on third-party software. The next section will delve into why ePBS is needed and the benefits of this in-protocol approach.

## The Case for ePBS

Transitioning to ePBS from MEV-Boost addresses several key issues aligned with Ethereum’s core values[^4]:

### Main Reasons

- **Decentralization**: Reduces reliance on centralized relays, distributing block construction responsibilities more broadly.
- **Security**: Ensures block construction follows the same security rules as the rest of the network, unlike the current off-chain relays.
- **Efficiency and Fairness**: Creates a more transparent and competitive marketplace for block space, reducing inefficiencies and inequities associated with MEV extraction.

### Challenges with Current System

- **Centralization Risks**: Reliance on a few relays can introduce centralization and single points of failure.
- **Security Vulnerabilities**: External relays operating outside Ethereum’s consensus rules pose security risks.
- **MEV-Related Manipulations**: Current systems may not adequately protect against MEV manipulations.
- **Operational Sustainability**: The long-term viability of relays is uncertain, raising concerns about their continued effectiveness and financial sustainability.

### Economic and Security Considerations

- **MEV Distribution**: ePBS aims to create a more transparent and equitable MEV market, altering current dynamics.
- **Market Efficiency**: By integrating PBS into the protocol, ePBS fosters a more competitive marketplace, potentially reducing gas price auctions and network congestion.
- **Centralization Risks**: Current reliance on a few relays introduces centralization risks, which ePBS seeks to mitigate.
- **Manipulative Practices**: External relays can lead to manipulative practices, which ePBS aims to regulate better.

### MEV Burn

MEV burn involves redirecting a portion of MEV profits towards burning Ether, reducing the supply and potentially increasing its value. This mechanism aims to align the interests of validators, builders, and the community.

## Counterarguments to ePBS

Critics of ePBS present several concerns, while proponents provide robust responses. The discussion also explores alternative methods for addressing MEV[^3].

### Primary Counterarguments

- **Complexity and Technical Risk**: ePBS introduces new elements to the protocol, potentially increasing complexity and technical risks.
- **Network Performance**: Concerns about ePBS affecting network performance, particularly latency and block propagation times.
- **Reduced Flexibility for Validators**: Fears that ePBS might limit validators' choices in block proposals.
- **Premature Optimization**: Suggests that ePBS might be diverting attention from more pressing issues.
- **Bypassability**: Validators and builders might continue relying on external solutions, bypassing ePBS mechanisms[^8].

### Proponents’ Responses

- **Mitigating Complexity**: Advocates argue the benefits of ePBS outweigh the complexities and risks.
- **Network Efficiency**: Proponents believe ePBS can be designed to maintain network efficiency.
- **Enhanced Decision-Making**: ePBS provides more transparent and competitive builder markets, promoting decentralization.
- **Strategic Importance**: ePBS addresses fundamental concerns about MEV extraction and aligns with Ethereum’s long-term goals.

The debate over ePBS encapsulates a broader discussion about Ethereum's future direction, balancing innovation with caution. While counterarguments emphasize risks and alternatives, ePBS advocates underline its alignment with Ethereum's core principles and its necessity for ensuring a fair, secure, and efficient blockchain ecosystem[^5].

## Designing ePBS

### Desirable properties of ePBS mechanisms

ePBS mechanisms should ensure decentralization, security, efficiency, transparency, reduced trust requirements, and fair MEV distribution[^6].

**Core Properties of Minimum Viable ePBS (MVePBS)**

- **Decentralization and Fair Access:** Ensure no single entity controls block proposing and building, keeping it fair for everyone.
- **Security and Integrity:** Maintain Ethereum’s security by protecting against attacks like censorship and double-spending.
- **Efficiency and Scalability:** Enhance the network’s efficiency and scalability without adding significant overhead.
- **Transparency and Predictability:** Make transaction ordering and block production clear and understandable for all users.
- **Reduced Trust Requirements:** Minimize the need for trust between different parties by embedding PBS in the protocol.
- **Fairness in MEV Distribution:** Ensure MEV opportunities are fairly distributed and prevent monopolistic control.
- **Minimal Trust Assumptions:** Reduce the need for trust by using cryptographic and game-theoretic principles.
- **Economic Viability:** Make sure participating in ePBS is financially beneficial for proposers, builders, and validators.
- **Flexibility and Compatibility:** Design ePBS to accommodate future innovations and work with existing infrastructure.
- **Reduced Complexity for Users:** Keep the system user-friendly and straightforward despite added protocol complexity.
- **Incentive Alignment:** Align the interests of all network participants to ensure long-term stability and health.

**Minimal trustless system for ePBS**

A minimal trustless ePBS system should include properties like honest builder publication safety, builder reveal safety, mandatory honest reorgs, builder withholding safety, unconditional payment, proposer safety, and censorship resistance[^6].

- **Honest Builder Publication Safety**: Ensures timely block publishing builders are included, preventing censorship and recognizing their work.
- **Builder Reveal Safety**: Protects builders from proposer equivocation when they reveal block content and bids.
- **Mandatory Honest Reorgs**: Enforces rules for reorgs to deter malicious ones that censor or exploit MEV.
- **Builder Withholding Safety**: Guarantees no unfair penalties for builders withholding blocks strategically within guidelines.
- **Unconditional Payment**: Assures builders get paid for their work, regardless of block inclusion, minimizing trust.
- **Proposer Safety**: Protects proposers from losing compensation, encouraging block proposal participation.
- **Honest Builder Payment Safety**: Guarantees payment for builders meeting protocol expectations in block production.
- **Permissionlessness**: Allows anyone to be a builder or proposer without central authorization, promoting competition and decentralization.
- **Censorship Resistance**: Prevents block and transaction censorship, maintaining Ethereum's decentralized integrity.
- **Roadmap Compatibility**: Aligns ePBS with Ethereum's development roadmap for smooth integration with future upgrades.

Additionally, there should be no advantage for proposers to sell blocks off-protocol in a minimal trustless ePBS system.

**Debating the Optimal Mechanism**

The discussion around the best ePBS mechanism requires careful consideration of design choices, often involving trade-offs[^9][^3].

- **Auction Mechanisms:** Deciding whether to use second-price auctions or more complex ones like frequent batch auctions impacts fairness, efficiency, and susceptibility to manipulation.
- **Builder Selection and Staking:** Choosing how to select builders—through staking, reputation systems, or random selection—affects decentralization and security, with staking possibly centralizing opportunities among the wealthy.
- **Inclusion and Censorship Resistance:** Ensuring the system resists censorship and fairly includes transactions might involve anonymous submissions or mandatory transaction lists, balancing against spam or malicious transactions.
- **Compatibility and Adaptability:** ePBS must work with current Ethereum infrastructure and be flexible for future updates like sharding or new layer-2 solutions.

Finding the minimum viable ePBS involves balancing these aspects to promote decentralization, ensure security and efficiency, maintain transparency and fairness, and minimize trust requirements. Continuous community discussions and research are essential for refining these concepts and achieving a consensus on the best ePBS mechanism.

## ePBS Solutions

### The Two-Block HeadLock (TBHL) proposal

The Two-Block HeadLock (TBHL) design represents an innovative approach to proposer-builder separation (PBS) within the Ethereum protocol, aiming to address both the operational and [strategic issues posed by MEV](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/). This design is a nuanced iteration of previous proposals, integrating elements of Vitalik Buterin's two-slot design and enhancing it with a headlock mechanism to safeguard builders from proposer equivocations. Here, we delve into the key components of TBHL and its operational mechanics, drawing on the detailed explanation provided[^4].

The [TBHL proposal](/docs/wiki/research/PBS/TBHL.md) has more details about the design and flow.

### Payload-Timeliness Committee (PTC) for ePBS

The Payload-Timeliness Committee (PTC) proposal is a design for enshrining PBS (ePBS) within the Ethereum protocol. It represents an evolution of the mechanism to determine block validity and includes a subset of validators who vote on the timeliness of a block's payload[^7][^12].

The [PTC proposal](/docs/wiki/research/PBS/PTC.md) has more details about the design and flow.

### ePBS PTC Specifications Overview

The [current ePBS specification](https://hackmd.io/@potuz/rJ9GCnT1C) and the [GitHub repo](https://github.com/potuz/consensus-specs/tree/epbs_stripped_out/specs/_features/epbs) are divided into separate components to build on top of the existing specifications of Ethereum components[^15][^16][^23]. 
- `Beacon-chain.md`: This document specifies the beacon chain specifications of the ePBS fork[^18].
- `Validator.md`: This document specifies the honest validator behavior specifications of the ePBS fork[^19].
- `Builder.md`: This document specifies the honest builder specifications of the ePBS fork[^20].
- `Engine.md`: This document specifies the Engine APi changes due ePBS fork[^21].
- `fork-choice.md`: This document specifies the changes to the fork-choice due to the ePBS fork[^22].

The [ePBS design specs](/docs/wiki/research/PBS/ePBS-Specs.md) has more details about the implementation specifications and flow.

### Protocol-Enforced Proposer Commitments (PEPC)

Protocol-Enforced Proposer Commitments (PEPC), a conceptual extension and generalization of PBS, introduces a more flexible and secure way for proposers (validators) to commit to the construction of blocks. Unlike the existing MEV-Boost mechanism, which relies on out-of-protocol agreements between proposers and builders/relays, PEPC aims to enshrine these commitments within the Ethereum protocol itself, offering a trustless and permissionless infrastructure for these interactions[^10][^11].

The [PEPC proposal](/docs/wiki/research/PBS/PEPC.md) has more details about the design and flow.

## Open Questions in ePBS

Mike Neuder has highlighted several intriguing and challenging questions about enshrining PBS (ePBS) in the Ethereum protocol[^5].

### What does bypassability imply?

Bypassability refers to validators and builders possibly continuing to use external relays or solutions instead of the enshrined protocol. This raises concerns about ePBS effectiveness if many participants opt out and the challenge of creating a system that cannot be bypassed without limiting validators' autonomy or Ethereum's decentralized nature.

### What does enshrining aim to achieve?

Enshrining PBS aims to create a neutral, trustless relay within the Ethereum protocol to secure the proposer-builder relationship. This effort seeks to reduce centralization risks of external solutions like MEV-Boost, improve censorship resistance, and address MEV-related issues more systematically. Even with bypassability, enshrining could offer a reliable fallback, encourage direct protocol engagement, and support long-term goals like MEV redistribution mechanisms (e.g., MEV-burn).

### What are the exact implications of not enshrining?

Not enshrining PBS leaves significant control over block construction and MEV distribution to external systems, potentially increasing centralization and security vulnerabilities. This choice might require prioritizing support for neutral relays as critical infrastructure to maintain fairness and prevent monopolistic practices in the MEV market.

### What is the real demand for ePBS?

The demand for ePBS within Ethereum is driven by factors addressing current limitations and preparing for future scalability, security, and decentralization needs. This demand stems from the evolving landscape of block production and the complexity of MEV opportunities. Quantifying this demand is challenging but reflects the Ethereum community's broader needs to tackle current issues and anticipate future requirements.

### How much can we rely on altruism and the social layer?

The social layer, consisting of Ethereum's community norms and values, plays a crucial role in behavior that protocol mechanics alone cannot enforce. While altruism or long-term self-interest might motivate some large ETH holders to support the enshrined solution, relying solely on these motivations is unreliable. Ethereum's integrity and decentralization should be supported by robust, enforceable mechanisms rather than voluntary adherence to ideals.

### How important is L1 ePBS in a future with L2s and OFAs?

As Ethereum's roadmap progresses, with more activity on L2 solutions and the development of OFAs, the direct impact of L1 MEV might decrease. However, the principles and infrastructure established by ePBS could still be vital for secure and decentralized MEV management across layers, maintaining ePBS relevance in a multi-layer ecosystem.

### What priority should ePBS have in light of other protocol upgrades?

Given the complex landscape and potential shifts in Ethereum's MEV dynamics, the priority of ePBS relative to other upgrades (e.g., censorship resistance, single-slot finality) requires a strategic approach. The community might focus on upgrades with immediate benefits and lower risks, while continuing to develop ePBS frameworks that can be quickly deployed if needed.

## Resources
- [Notes on Proposer-Builder Separation (PBS)](https://barnabe.substack.com/p/pbs)
- [Mike Neuder - Towards Enshrined Proposer-Builder Separation](https://www.youtube.com/watch?v=Ub8V7lILb_Q)
- [An Incomplete Guide to PBS - with Mike Neuder and Chris Hager](https://www.youtube.com/watch?v=mEbK9AX7X7o)
- [Why enshrine Proposer-Builder Separation? A viable path to ePBS](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710/1)
- [ePBS – the infinite buffet](https://notes.ethereum.org/@mikeneuder/infinite-buffet)
- [ePBS design constraints](https://hackmd.io/ZNPG7xPFRnmMOf0j95Hl3w)
- [Payload-timeliness committee (PTC) – an ePBS design ](https://ethresear.ch/t/payload-timeliness-committee-ptc-an-epbs-design/16054)
- [Consider the ePBS](https://notes.ethereum.org/@mikeneuder/consider-the-epbs)
- [ePBS Breakout Room](https://www.youtube.com/watch?v=63juNVzd1P4)
- [Unbundling PBS: Towards protocol-enforced proposer commitments (PEPC)](https://ethresear.ch/t/unbundling-pbs-towards-protocol-enforced-proposer-commitments-pepc/13879/1)
- [PEPC FAQ](https://efdn.notion.site/PEPC-FAQ-0787ba2f77e14efba771ff2d903d67e4)
- [Minimal ePBS without Max EB and 7002](https://github.com/potuz/consensus-specs/pull/2)
- [EigenLayer protocol](https://docs.eigenlayer.xyz/eigenlayer/overview/whitepaper)
- [ePBS specification notes](https://hackmd.io/@potuz/rJ9GCnT1C)
- [ePBS design specs PR](https://github.com/potuz/consensus-specs/pull/2)
- [ePBS design specs GitHub repo](https://github.com/potuz/consensus-specs/tree/epbs_stripped_out/specs/_features/epbs)
- [epbs - beacon-chain specs](https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/beacon-chain.md)
- [epbs - honest validator specs](https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/validator.md)
- [epbs - honest builder specs](https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/builder.md)
- [epbs - Engine API specs](https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/engine.md)
- [epbs - fork-choice specs](https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/fork-choice.md)
- [EIP-7547 Inclusion Lists](https://eips.ethereum.org/EIPS/eip-7547)

## References
[^1]: https://barnabe.substack.com/p/pbs
[^2]: https://www.youtube.com/watch?v=Ub8V7lILb_Q
[^3]: https://www.youtube.com/watch?v=mEbK9AX7X7o
[^4]: https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710/1
[^5]: https://notes.ethereum.org/@mikeneuder/infinite-buffet
[^6]: https://hackmd.io/ZNPG7xPFRnmMOf0j95Hl3w
[^7]: https://ethresear.ch/t/payload-timeliness-committee-ptc-an-epbs-design/16054
[^8]: https://notes.ethereum.org/@mikeneuder/consider-the-epbs
[^9]: https://www.youtube.com/watch?v=63juNVzd1P4
[^10]: https://ethresear.ch/t/unbundling-pbs-towards-protocol-enforced-proposer-commitments-pepc/13879/1
[^11]: https://efdn.notion.site/PEPC-FAQ-0787ba2f77e14efba771ff2d903d67e4
[^12]: https://hackmd.io/@potuz/rJ9GCnT1C
[^13]: https://github.com/potuz/consensus-specs/pull/2
[^14]: https://docs.eigenlayer.xyz/eigenlayer/overview/whitepaper
[^15]: https://hackmd.io/@potuz/rJ9GCnT1C
[^16]: https://github.com/potuz/consensus-specs/pull/2
[^17]: https://eips.ethereum.org/EIPS/eip-7547
[^18]: https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/beacon-chain.md
[^19]: https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/validator.md
[^20]: https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/builder.md
[^21]: https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/engine.md
[^22]: https://github.com/potuz/consensus-specs/blob/epbs_stripped_out/specs/_features/epbs/fork-choice.md 
[^23]: https://github.com/potuz/consensus-specs/tree/epbs_stripped_out/specs/_features/epbs