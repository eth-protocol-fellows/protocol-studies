# Enshrined Proposer-Builder Separation (ePBS)

## Roadmap tracker

| Upgrade |    URGE     |   Track   |               Topic               |                                                                                          Cross-references                                                                                          |
|:-------:|:-----------:|:---------:|:---------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|  ePBS   | the Scourge | MEV track | Endgame block production pipeline | intersection with: [ET](https://ethresear.ch/t/execution-tickets/17944), [PEPC](https://efdn.notion.site/PEPC-FAQ-0787ba2f77e14efba771ff2d903d67e4), [IL](https://eips.ethereum.org/EIPS/eip-7547) |

## TLDR;

Enshrined Proposer-Builder Separation (ePBS) refers to integrating the PBS mechanism directly into the Ethereum blockchain protocol itself, rather than having it operate through external services or addons. This integration aims to formalize and standardize the separation between the roles of block proposers and block builders within the core protocol rules, enhancing the system's efficiency, security, and decentralization.

## What is PBS

Proposer-Builder Separation (PBS) is a design philosophy[^1] and mechanism within the context of Ethereum, that aims to decouple the roles of proposing blocks (proposers) and constructing the content of those blocks (builders). This separation addresses various challenges and inefficiencies associated with block production, and in the context of maximizing extractable value (MEV). This entry assumes reader has some knowledge of [MEV](/wiki/research/PBS/mev.md), [PBS](/wiki/research/PBS/pbs.md), and [MEV-Boost](/wiki/research/PBS/mev-boost.md)

## Overview of ePBS

ePBS is a protocol-level enhancement for Ethereum that institutionalizes the division of labor between block proposers and block builders. Unlike the existing out-of-the-protocol solutions implementing [builder API](https://github.com/ethereum/builder-specs) in external software, like [MEV-Boost](/wiki/research/PBS/mev-boost.md), ePBS integrates this features directly into Ethereum clients, aiming to streamline and secure the process.

The key difference between ePBS and current mechanisms like MEV-Boost lies in the protocol's direct support for the separation, eliminating the need for external relays to mediate the transaction. This enshrinement is designed to reduce trust requirements, enhance transparency, and improve overall network efficiency by formally defining the roles and interactions within the protocol itself[^2][^3].

In the ePBS framework:

- **Proposers** are validators responsible for proposing new blocks to the network. Their role is limited to choosing which block to propose, without the need to construct the block themselves. All the communication via builder API is done within the client without an external tool.

- **Builders** are entities or algorithms that assemble blocks, optimizing the transaction order for profitability (e.g., maximizing MEV extraction) and offering these blocks to proposers through a transparent auction mechanism.

- **Relays**, in the traditional MEV-Boost context, serve as intermediaries that facilitate the communication between proposers and builders. Under ePBS, the reliance on external relays is diminished or redefined, as the protocol itself facilitates the direct interaction between proposers and builders. The role of Relays will be significantly different from today's notion.

### Transition from mev-boost to ePBS

The transition from MEV-Boost to ePBS represents a pivotal evolution in Ethereum's approach to handling MEV and improving the network's efficiency and fairness. Dependency on an external, third party software can be dangerous and lead to network incidents even if clients themselves behave correctly. In the next section, we will cover the details on why ePBS is needed and what will the ecosystem gain from this in-protocol approach to PBS.

## The Case for ePBS

The transition to ePBS from the current MEV-Boost system is motivated by several key reasons that align with Ethereum's core values of decentralization, security, and efficiency. Proponents of ePBS highlight the importance of integrating PBS directly into the Ethereum protocol to address several concerns arising from the reliance on relays and out-of-protocol mechanisms for block construction. Here's a detailed explanation of these aspects[^4]:

### Main Reasons for Transition to ePBS

1. **Decentralization**: ePBS aims to reduce the reliance on a few centralized relays by embedding the PBS mechanism directly within the Ethereum protocol. This move seeks to distribute the responsibility for block construction across a broader set of participants, enhancing the network's resilience and reducing central points of failure.

2. **Security**: By integrating PBS into the Ethereum protocol, ePBS ensures that the entire block construction process is governed by the same consensus rules and security guarantees that protect other aspects of the network. This contrasts with the current system, where off-chain relays operate without the direct oversight of Ethereum's consensus mechanisms.

3. **Efficiency and Fairness**: ePBS proposes to create a more transparent and competitive marketplace for block space, potentially reducing the inefficiencies and inequities associated with MEV extraction. It aims to ensure that validators have more control and visibility over the blocks they propose, contributing to a fairer distribution of MEV rewards.

### Contradiction of Core Values by Reliance on Relays

- **Centralization Risks**: The current reliance on a limited number of relays introduces centralization into a network that prizes decentralization as a core principle. Centralized relays can become single points of failure or control, undermining the network's distributed nature.

- **Security Vulnerabilities**: External relays, operating outside of Ethereum's consensus rules, could potentially be manipulated or attacked, posing security risks to the network. This external dependency contradicts Ethereum's goal of achieving robust, protocol-enshrined security.

### Perceived Risks and Inefficiencies with Out-of-Protocol PBS

- **MEV-Related Manipulations**: The current PBS mechanism, reliant on external relays, may not adequately protect against manipulative practices associated with MEV extraction, leading to unfair advantages and potential network instability.

- **Opaque Operations**: The operation of relays outside the Ethereum protocol can lead to a lack of transparency and accountability, making it difficult to monitor and regulate block construction practices effectively.

### Sustainability Concerns of Relays

- **Operational Sustainability**: The long-term operational viability of relays is uncertain, as they depend on continuous participation and support from the community. Any disruption in relay services could significantly impact the network's ability to process transactions efficiently.

- **Financial Model**: The financial sustainability of relays is also a concern. If the costs of running relays exceed the revenue generated from their operation, it could lead to a reduction in the number of relays, increasing centralization risks and affecting the competitive marketplace for block space.

The transition towards ePBS involves critical economic and security considerations, especially in the context of MEV and proposals like MEV burn. These considerations shape the debate around ePBS, highlighting its potential impact on the Ethereum ecosystem. Here's an exploration of these aspects:

### Economic Considerations

- **MEV Distribution**: One of the primary economic concerns revolves around how MEV is distributed among validators, builders, and users. ePBS aims to create a more transparent and equitable MEV market by ensuring that validators are fairly compensated for the blocks they propose. This could potentially alter the current dynamics, where certain participants may disproportionately benefit from MEV.

- **Market Efficiency**: By integrating PBS directly into the Ethereum protocol, ePBS is expected to foster a more competitive and efficient marketplace for block space. This could lead to better pricing mechanisms for transaction inclusion, benefiting users with fairer transaction costs and potentially reducing the prevalence of gas price auctions that lead to network congestion.

- **Sustainability of Relays**: ePBS addresses the operational and financial sustainability concerns of relays by potentially reducing their role in the MEV extraction process. A protocol-level solution could offer a more stable and predictable framework for handling MEV, alleviating the need for external relays and their associated costs.

### Security Considerations

- **Centralization Risks**: The current reliance on a limited set of MEV-Boost relays introduces centralization or cartelization risks, making the network more vulnerable to attacks or manipulations. ePBS seeks to mitigate these risks by decentralizing the process of block proposal and construction, aligning with Ethereum's security ethos.

- **Manipulative Practices**: External relays and opaque MEV extraction mechanisms can lead to manipulative practices, such as transaction reordering or sandwich attacks, that undermine network integrity. ePBS aims to provide a more regulated and transparent environment for handling MEV, enhancing overall network security.

- **Protocol-Enshrined Security**: Incorporating PBS directly into the Ethereum protocol ensures that block construction adheres to the same rigorous consensus and security standards that govern other aspects of the network. This unified approach to security is seen as a significant improvement over the current system, where external components like relays operate without direct protocol oversight.

### MEV Burn

The concept of MEV burn involves redirecting a portion of MEV profits towards burning Ether, reducing the overall supply and potentially increasing the value of the remaining Ether. This mechanism has been proposed as a way to align the interests of validators, builders, and the wider Ethereum community by ensuring that excessive MEV extraction does not lead to inflationary pressures or disproportionate benefits for certain network participants.

- **Inflationary Pressure Mitigation**: By burning a part of the MEV, Ethereum could potentially control inflationary pressures arising from new Ether issuance for block rewards.

- **Economic Stability**: MEV burn could contribute to the economic stability of Ethereum by ensuring that the benefits of MEV extraction are more evenly distributed across the ecosystem, including Ether holders who are not directly involved in MEV strategies.

- **Alignment of Incentives**: Implementing an MEV burn mechanism could help align the incentives of various network participants, ensuring that the pursuit of MEV does not compromise network security or efficiency.

The transition to ePBS from the current MEV-Boost system is driven by a combination of economic and security considerations, including concerns about MEV distribution, market efficiency, centralization risks, and the operational sustainability of relays. The potential implementation of an MEV burn mechanism further reflects Ethereum's commitment to aligning economic incentives with its core values of decentralization, security, and efficiency. This transition marks a pivotal moment in Ethereum's evolution, potentially reshaping the landscape of transaction ordering and MEV extraction in favor of a more secure, efficient, and equitable ecosystem.

## Counterarguments to ePBS

The discussion around the enshrinement of PBS (ePBS) within Ethereum's protocol has stirred significant debate, with various counterarguments presented by its critics. Proponents of ePBS, however, offer robust responses to these concerns, advocating for its necessity and integration into Ethereum's roadmap. Additionally, the discourse explores alternative methods for addressing MEV, weighing their sufficiency against the proposed ePBS system[^3].

### Primary Counterarguments Against ePBS

- **Complexity and Technical Risk**: Critics argue that incorporating ePBS into Ethereum's core protocol significantly increases its complexity and introduces new technical risks, potentially jeopardizing network stability and security.

- **Network Performance Concerns**: There is apprehension that ePBS could impact Ethereum's network performance, specifically relating to latency and block propagation times, which could, in turn, affect transaction processing efficiency.

- **Reduced Flexibility for Validators**: Some contend that ePBS might limit validators' flexibility in choosing block proposals, potentially centralizing decision-making power among a few large builders.

- **Premature Optimization**: Skeptics suggest that focusing on ePBS might be a case of premature optimization, diverting attention and resources from more pressing issues on Ethereum's roadmap.

- **Bypassability**: Bypassability refers to the ability of participants within the Ethereum ecosystem—be it validators, proposers, builders, or others—to sidestep or bypass the rules and mechanisms established by ePBS. This could occur through off-protocol agreements, alternative transaction ordering systems, or other means that effectively operate outside the constraints set by ePBS. The protocol will have no easy way to enforce ePBS rules on them[^8].

### If it ain't broke, don't fix it - counterarguments

The "If it ain't broke, don't fix it" perspective emerges as a significant counterargument against the ePBS within Ethereum's protocol. This viewpoint is grounded in caution and a preference for maintaining the status quo unless there's an unequivocal necessity for change. Here’s how this perspective shapes the counterarguments against ePBS:

**Reliance on Existing Systems**

Critics holding this perspective argue that the current mechanisms for handling MEV, including MEV-Boost and the relay system, have proven functional and effective in their operational context. They suggest that these systems have not only stabilized but also facilitated a certain equilibrium within Ethereum's ecosystem, balancing efficiency, security, and validator autonomy without necessitating a profound protocol overhaul.

**Risk of Unintended Consequences**

A fundamental concern is the potential for unintended consequences that a significant alteration like ePBS might introduce to the network. This viewpoint highlights the complexity and interdependence within Ethereum's system, where modifications at the protocol level could precipitate unforeseen vulnerabilities, security risks, or compromises in network performance. The argument posits that the benefits of ePBS might not justify the risks associated with disrupting a functioning system.

**Development Focus and Resource Allocation**

From the "If it ain't broke, don't fix it" standpoint, the emphasis on developing and implementing ePBS might divert valuable resources and attention from other critical areas within Ethereum's ecosystem that require immediate attention or offer clearer benefits. Critics suggest that Ethereum's development focus should prioritize scalability solutions, Layer 2 enhancements, and other upgrades that directly contribute to user experience and network capacity without introducing the complexities associated with ePBS.

**The Challenge of Proving Necessity**

This perspective demands a higher standard of proof for the necessity of ePBS. Critics argue that for a change of this magnitude to be justified, it must be clear that existing systems are not merely suboptimal but fundamentally broken in a way that directly impedes Ethereum's operation or principles. The call for ePBS is seen as a solution seeking a problem, rather than a response to a critical need.

**Emphasizing Evolution Over Revolution**

Finally, the "If it ain't broke, don't fix it" argument is rooted in a preference for evolutionary rather than revolutionary changes within the Ethereum protocol. Proponents of this view prefer incremental improvements and optimizations to existing systems over wholesale architectural changes, advocating for a cautious approach that values stability and predictability.

### Proponents' Responses and Advocacy for ePBS

- **Mitigating Complexity and Technical Risk**: ePBS advocates argue that while the proposal introduces new elements to the protocol, these are manageable and outweighed by the benefits of enhanced fairness, security, and MEV distribution efficiency. Rigorous testing and phased implementation are proposed to mitigate risks.

- **Addressing Network Performance**: Proponents maintain that ePBS can be designed with network efficiency in mind, leveraging advancements in technology and protocol engineering to minimize any adverse effects on latency or block propagation.

- **Enhancing Validator Decision-Making**: ePBS supporters argue that by structuring the builder market more transparently and competitively, validators will actually have more informed choices, not less, promoting healthier decentralization.

- **Strategic Importance on the Roadmap**: ePBS is considered by its advocates as not merely an optimization but a foundational improvement to Ethereum's economic and security models. It addresses pressing concerns related to MEV extraction practices and aligns with Ethereum's long-term goals of decentralization and scalability.

**Alternatives to ePBS and Their Evaluation**

- **Improved MEV-Boost and Relays**: Some suggest that refining the existing MEV-Boost system and enhancing relay operations could address many of the concerns ePBS aims to solve, without necessitating protocol-level changes.

- **MEV Burn Mechanisms**: Another alternative is the implementation of MEV burn mechanisms, where a portion of MEV profits is burned, potentially reducing the incentive for manipulative practices.

- **Layer 2 Solutions and Decentralized Relays**: Exploring layer 2 solutions for transaction ordering or developing decentralized relay networks are also proposed as ways to mitigate MEV issues without altering the core protocol.

ePBS proponents argue that while these alternatives offer partial solutions, they do not comprehensively address the root issues of fairness, security, and decentralization that ePBS aims to solve. Moreover, they maintain that ePBS is a strategic enhancement that supports Ethereum's long-term vision, arguing for its prioritization amidst other developments.

The debate over ePBS encapsulates a broader discussion about Ethereum's future direction, balancing innovation with caution. While counterarguments emphasize risks and alternatives, ePBS advocates underline its alignment with Ethereum's core principles and its necessity for ensuring a fair, secure, and efficient blockchain ecosystem[^5].

## Designing ePBS

### Desirable properties of ePBS mechanisms

The debate on the optimal ePBS mechanism and the concept of a minimum viable ePBS (MVePBS) revolves around identifying the core features and properties that such a system must possess to effectively address the challenges it aims to solve within the Ethereum ecosystem. This involves balancing the goals of decentralization, efficiency, security, and fairness, while also considering the practical implications of implementation and adoption. Here's a look at the central aspects of this debate and the properties considered essential for a minimum viable ePBS[^6].

**Core Properties of MVePBS**

- **Decentralization and Fair Access:** MVePBS must ensure that the process of proposing and building blocks remains decentralized, preventing any single entity from gaining disproportionate control or influence. This includes fair access to MEV opportunities and block space for all participants, maintaining Ethereum's ethos of decentralization.

- **Security and Integrity:** The design should not compromise the security of the Ethereum network. This includes safeguarding against attacks that could arise from the separation of proposing and building roles, such as censorship, double-spending, or reordering attacks that could undermine the integrity of transactions.

- **Efficiency and Scalability:** MVePBS should enhance, or at least not significantly detract from, the network's efficiency and scalability. This involves minimizing the added computational and communication overhead, ensuring that the system can scale with Ethereum's growth and increasing demand.

- **Transparency and Predictability:** The mechanism should provide transparency in transaction ordering and block production, allowing participants to understand how decisions are made within the ePBS framework. This predictability helps in managing MEV in a way that is consistent and fair to all network users.

- **Reduced Trust Requirements:** By enshrining PBS into the protocol, the system aims to reduce reliance on trust between different parties (e.g., between proposers and builders, or between users and relays). The design should minimize opportunities for off-protocol agreements that could bypass the intended fairness of the system.

- **Fairness in MEV Distribution:** ePBS should aim to level the playing field regarding access to MEV, ensuring that opportunities for value extraction are fairly distributed among participants. This involves creating mechanisms that prevent monopolistic control over MEV opportunities by a few large players.

- **Minimal Trust Assumptions:** The design should minimize the need for trust between proposers, builders, and validators. By enshrining PBS into the Ethereum protocol, ePBS mechanisms should leverage cryptographic and game-theoretic principles to ensure that participants can operate in a trust-minimized environment.

- **Economic Viability:** ePBS mechanisms must be economically viable for all participants, including proposers, builders, and validators. This involves ensuring that the costs associated with participating in the ePBS ecosystem (e.g., staking requirements, transaction fees) do not outweigh the potential benefits, thus encouraging broad participation.

- **Flexibility and Compatibility:** The ePBS framework should be flexible enough to accommodate future innovations and changes within the Ethereum ecosystem, including upgrades and new layer-2 solutions. It should also be compatible with existing infrastructure to facilitate a smooth transition.

- **Reduced Complexity for Users:** While ePBS introduces additional complexity at the protocol level, it should strive to minimize the impact of this complexity on end-users and developers. The system should be designed so that interacting with Ethereum remains as intuitive and straightforward as possible.

- **Incentive Alignment:** The incentives within the ePBS mechanism should be carefully designed to align the interests of all network participants, including users, proposers, builders, and validators. This alignment is crucial for ensuring the long-term health and stability of the network.

**Minimal trustless system for ePBS**

Integrating these below constraints provides a comprehensive view of the minimal trustless system envisioned for ePBS[^6]. It underscores the need for robust protections for both builders and proposers, ensuring fairness, reducing reliance on trust, and maintaining Ethereum's decentralized principles. This refined approach addresses the complex interplay between economic incentives, security considerations, and the overarching goal of enhancing Ethereum's protocol efficiency and integrity.

- **Honest Builder Publication Safety**: This constraint ensures that builders who follow protocol rules and publish their blocks in a timely manner are guaranteed that their blocks will be considered for inclusion in the blockchain, safeguarding against censorship and ensuring their efforts are recognized.

- **Builder Reveal Safety**: Protects builders when they reveal their bids and blocks. This means that even after revealing their proposed block content, they are protected against proposer equivocation or other actions that might compromise their position.

- **Mandatory Honest Reorgs**: Enforces that any reorganizations of the blockchain adhere to predefined rules that favor honesty, deterring malicious reorgs designed to censor or usurp valid transactions for MEV extraction.

- **Builder Withholding Safety**: Guarantees that builders cannot be unfairly penalized for withholding a block as a strategic response to network conditions or potential censorship, provided they act within the protocol's guidelines.

- **Unconditional Payment**: Ensures that builders receive payment for their work regardless of external factors, such as whether their block was ultimately included in the chain, provided they followed the protocol. This minimizes trust by making compensation mechanisms transparent and automatic.

- **Proposer Safety**: Protects proposers by ensuring that they can safely commit to including a block without the risk of losing out on transaction fees or other forms of compensation. This encourages active participation in the block proposal process.

- **Honest Builder Payment Safety**: This aspect guarantees compensation for builders who are selected and fulfill their block production duties according to the protocol's expectations.

- **Permissionlessness**: Maintains the Ethereum ethos of open participation by allowing any entity to act as a builder or proposer without needing authorization from a central authority, fostering a competitive and decentralized environment.

- **Censorship Resistance**: Essential for upholding Ethereum's decentralized nature by ensuring that blocks and transactions cannot be censored by a few powerful nodes, maintaining network integrity and openness.

- **Roadmap Compatibility**: Ensures that any ePBS mechanism aligns with Ethereum's technical development path, supporting seamless integration with future upgrades and changes to the ecosystem.

Additionally, in such a minimal trustless system for ePBS, there should be no inherent advantage for proposers, to sell their blocks to builders off-protocol.

**Debating the Optimal Mechanism**

The debate on the optimal ePBS mechanism involves weighing various design choices against these core properties, often requiring trade-offs[^9][^3].

- **Auction Mechanisms:** There's significant discussion around the best way to conduct auctions for block space and MEV opportunities—whether through second-price auctions, or more complex mechanisms like frequent batch auctions. Each has implications for fairness, efficiency, and vulnerability to manipulation.

- **Builder Selection and Staking:** Deciding how builders are selected for proposing blocks—whether through staking, reputation systems, or randomized selection—impacts decentralization and security. Staking, for example, could provide economic security but might also centralize opportunities among wealthier participants.

- **Inclusion and Censorship Resistance:** Ensuring the system resists censorship and includes transactions equitably is crucial. This may involve mechanisms for anonymous transaction submission or commitments to include certain transactions (e.g. Inclusion Lists), balancing against the potential for spam or malicious transactions.

- **Compatibility and Adaptability:** The ePBS must be compatible with existing Ethereum infrastructure and adaptable to future changes to meet the roadmap, including upgrades like sharding or new layer-2 solutions.

Determining the minimum viable ePBS involves a delicate balance of these properties, necessitating a mechanism that promotes decentralization, ensures security and efficiency, maintains transparency and fairness, and reduces reliance on trust. Ongoing discussions and research within the Ethereum community are crucial for refining these concepts and moving towards a consensus on the optimal ePBS mechanism.

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

There are some interesting and challenging open questions highlighted by Mike in enshrining PBS (ePBS) in Ethereum Protocol[^5].

### What does bypassability imply?

Bypassability highlights a crucial challenge in the transition to ePBS: the possibility that validators and builders might continue relying on external relays or solutions instead of the enshrined protocol. The concern here is twofold: first, it questions the efficacy of ePBS if a significant portion of network participants opts out; second, it probes the feasibility of designing a system that cannot be bypassed without imposing unreasonable constraints on validators' autonomy or Ethereum's decentralized ethos.

### What does enshrining aim to achieve?

Enshrining PBS aims to introduce a neutral, trustless relay within the Ethereum protocol to standardize and secure the proposer-builder relationship. This initiative seeks to mitigate centralization risks inherent in out-of-protocol solutions like MEV-Boost, enhance censorship resistance, and potentially serve as a foundational step towards addressing MEV-related issues more systematically. Enshrining PBS, despite bypassability, could provide a reliable fallback mechanism, encourage more validators to engage directly with the protocol, and align with long-term goals such as MEV redistribution mechanisms (e.g., MEV-burn).

### What are the exact implications of not enshrining?

Choosing not to enshrine PBS essentially yields significant control over block construction and MEV distribution to external systems, potentially exacerbating centralization and security vulnerabilities. This concession may necessitate prioritizing funding and support for neutral relays as critical infrastructure to maintain a level playing field and safeguard against monopolistic practices in the MEV market.

### What is the real demand for ePBS?

The real demand for ePBS within the Ethereum ecosystem is driven by multiple factors that address current limitations and future-proof the network for scalability, security, and decentralization. These demands stem from the evolving landscape of Ethereum's block production and the growing complexity of MEV opportunities. Quantifying the real demand for ePBS is big challenge but it is a reflection of the broader needs of the Ethereum community to address current challenges and anticipate future demands.

### How much can we rely on altruism and the social layer?

The social layer, Ethereum community norms and values, plays a pivotal role in guiding behavior that protocol mechanics alone cannot enforce. While altruism or long-term self-interest might motivate some large ETH holders to support the enshrined solution, relying solely on these motivations is unreliable. The integrity and decentralization of Ethereum should ideally be underpinned by robust, enforceable mechanisms rather than voluntary adherence to ideals.

### How important is L1 ePBS in a future with L2s and OFAs?

As Ethereum's roadmap evolves, with increasing activity on L2 solutions and the development of OFAs, the direct impact of L1 MEV might diminish. However, the principles and infrastructure laid out by ePBS could still play a critical role in shaping secure and decentralized mechanisms for managing MEV across layers, maintaining the relevance of ePBS in a multilayered ecosystem.

### What priority should ePBS have in light of other protocol upgrades?

Given the complex landscape and the potential for significant shifts in Ethereum's MEV dynamics, the prioritization of ePBS relative to other upgrades (e.g., censorship resistance enhancements, single-slot finality) necessitates a strategic approach. The community might consider focusing on upgrades with clearer immediate benefits and lower implementation risks, while continuing to research and develop ePBS frameworks that could be rapidly deployed if and when the need becomes more pressing.

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