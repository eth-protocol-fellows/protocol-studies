# Envisioning Ethereum's Future: The Path to Enshrined Proposer-Builder Separation (ePBS)

## [DRAFT MODE - This is work in progress.]

## [ELI5](#eli5)

Imagine Ethereum as a busy city where builders create buildings (blocks) on plots of land given by city planners (proposers). Right now, a few big companies have most of the control over building, which isn’t ideal for our city's future. The document talks about making this process part of the city’s rules, so everyone has a fair chance to build. It’s like making sure the city grows in a way that’s best for everyone, not just the big players.

## [TLDR](#tldr)

Enshrined Proposer-Builder Separation (ePBS) refers to integrating the PBS mechanism directly into the Ethereum blockchain protocol itself, rather than having it operate through external services or add-ons. This integration aims to formalize and standardize the separation between the roles of block proposers and block builders within the core protocol rules, enhancing the system's efficiency, security, and decentralization.

## [Key References](#key-references)
- [Why enshrine Proposer-Builder Separation](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710)
- 


## [Introduction - What is PBS](#introduction---what-is-pbs)

Proposer-Builder Separation (PBS) is a design philosophy[quote Barnable here] and mechanism in blockchain networks, particularly within the context of Ethereum, that aims to decouple the roles of proposing blocks (proposers) and constructing the content of those blocks (builders). This separation addresses various challenges and inefficiencies associated with block production, especially in proof-of-stake (PoS) systems and in the context of maximizing extractable value (MEV).

Here’s a breakdown of the roles and the rationale behind PBS:

### Proposers
- **Role**: Validators chosen by the protocol to propose a new block to the blockchain.
- **Traditional Challenge**: In a system without PBS, the proposer must both select which transactions to include in a block and order them. This task becomes increasingly complex and specialized as the proposer needs to understand the current state of the blockchain deeply and identify the most profitable transactions to include, often related to MEV.

### Builders
- **Role**: Specialized actors responsible for constructing blocks. They listen to the network for transactions, order them in a way that maximizes the value extracted from the block (MEV), and bid for their block to be chosen by the proposer.
- **Rationale**: Builders are specialized and equipped with sophisticated strategies and algorithms to efficiently order transactions to maximize MEV. Their specialization allows for more efficient and profitable block construction than a generalist proposer could achieve.

### Separation Benefits
- **Decentralization and Security**: By allowing proposers to remain unsophisticated entities, PBS aids in maintaining a more decentralized network. It lowers the barrier to entry for becoming a proposer, as they no longer need the infrastructure or knowledge to optimize transaction ordering for MEV.
- **Efficiency and Specialization**: Separating the roles allows each actor to specialize in their respective tasks, leading to more efficient block construction and potentially higher network throughput.
- **Fairness and MEV Distribution**: PBS can help in creating a more competitive and fair environment for MEV extraction, as multiple builders compete to have their blocks chosen by proposers.

PBS is fundamentally a recognition that different roles in the blockchain ecosystem can have distinct capabilities and incentives, and that separating these roles can lead to improved efficiency, security, and fairness (division of labor). This concept has been explored and implemented in various ways, including through external services like MEV-Boost in Ethereum, which facilitates the interaction between proposers and builders outside the core protocol.

## [Brief overview of ePBS](#brief-overview-of-epbs)

Enshrined Proposer-Builder Separation (ePBS) is a protocol-level enhancement for Ethereum that institutionalizes the division of labor between block proposers and block builders. Unlike the existing off-chain solutions like MEV-Boost, which operate on a trust-based model with relays, ePBS integrates this separation directly into Ethereum's core protocol, aiming to streamline and secure the process.

The key difference between ePBS and current mechanisms like MEV-Boost lies in the protocol's direct support for the separation, eliminating the need for external relays to mediate the transaction. This enshrinement is designed to reduce trust requirements, enhance transparency, and improve overall network efficiency by formally defining the roles and interactions within the protocol itself.

In the ePBS framework:
- **Proposers** are validators responsible for proposing new blocks to the network. Their role is limited to choosing which block to propose, without the need to construct the block themselves.
- **Builders** are entities or algorithms that assemble blocks, optimizing the transaction order for profitability (e.g., maximizing MEV extraction) and offering these blocks to proposers through a transparent auction mechanism.
- **Relays**, in the traditional MEV-Boost context, serve as intermediaries that facilitate the communication between proposers and builders. Under ePBS, the reliance on external relays is diminished or redefined, as the protocol itself facilitates the direct interaction between proposers and builders.

The need to enshrine PBS into Ethereum's protocol stems from the desire to mitigate risks associated with external, trust-dependent services, improve the decentralization and security of block production, and better manage the complexities around MEV extraction. By formalizing these roles within the Ethereum protocol, ePBS seeks to ensure a fair, efficient, and transparent process for transaction ordering and block construction, aligned with Ethereum's ethos of decentralization and open participation.


### [PBS in historical context]

- **Pre-MEV-Geth Era:** Before MEV-Geth, there was a form of proposer-builder separation in the division of labor between a mining pool operator and the workers. The mining pool operator would construct the block body, and the workers would hash the block further. This division of labor also involved a commit-reveal scheme 
 
- **Before the Merge (Proof of Work Era):** The concept of PBS was more explicit in the MEV-Geth world, where a few large mining pools controlled a significant portion of the hash rate. MEV-Geth allowed searchers to send bundles to miners without worrying about the miners stealing them, as the miners' reputation was worth more than the potential gain from stealing the contents of the bundle. This interaction was simpler due to the fewer number of block producers. 

- **Approaching the Merge:** As the merge approached, there was significant discussion about PBS as a general approach. The idea was considered for inclusion in the merge hard fork, but it was eventually discarded due to the complexity it would add to the software and specification, which could slow down the merge process.

- **Introduction of MEV-Boost:**
 - **April 2022:** Stefan from Flashbots posted the original MEV-Boost specification, outlining how proposers could interact with an external block-building network. Work began in the background at the Devconnect meeting on MEV-Day in Amsterdam in '22, finalizing all necessary APIs.
 - **Summer 2022:** Efforts were made to deliver a permissionless relay on open-source software, allowing other relay operators to run it. This was completed just in time for the merge, which included permissionless builder access.

- **MEV-Boost as a Software Solution:** MEV-Boost facilitates the auction between the proposer and the builder, ensuring that the block produced by the builder is valid and accurately pays the proposer. This is achieved through a relay that sits between the proposer and the builder, facilitating the auction process.

- **Current Status Post-Merge:** Immediately after the merge, there were about three or four relays running. Now, there are around 8-10 relays that facilitate most of the MEV-Boost blocks. About 95% of validators are connected to one of these relays and use their connection to source their block production.

 
### [Transition from mev-boost to ePBS]
The transition from MEV-Boost to enshrined proposer-builder separation (ePBS) represents a pivotal evolution in Ethereum's approach to handling Miner/Maximal Extractable Value (MEV) and improving the network's efficiency and fairness. Here's a detailed look into this transition:

**MEV-Boost: A Precursor to ePBS**
MEV-Boost, introduced as an interim solution, allows validators to outsource the construction of blocks to external builders, who bid for the right to propose block contents. This setup created a marketplace for block space, reducing the negative impacts of MEV by making the process more competitive and transparent. However, MEV-Boost operates off-chain and relies on centralized relays, introducing potential centralization and security risks.


**The Need for Transition**
While MEV-Boost marked a significant advancement in mitigating some aspects of MEV, it highlighted the need for a more robust, decentralized solution integrated directly into the Ethereum protocol. Key concerns with MEV-Boost include:
- **Relay Centralization**: Dependence on a few relays risks centralization and single points of failure.
- **Security Risks**: Off-chain operations could be susceptible to manipulation or attacks not covered by the protocol's security guarantees.
- **Limited Validator Control**: Validators have less control over block content, potentially affecting network censorship resistance and fairness.


**Envisioning ePBS**
ePBS aims to address these issues by formalizing the separation of proposers and builders within the Ethereum protocol itself. This entails:
- **Protocol-Level Integration**: By moving the auction and selection mechanism for block construction into the protocol, ePBS ensures all operations are subject to Ethereum's consensus rules and security guarantees.
- **Decentralization**: ePBS reduces reliance on centralized relays by allowing a decentralized network of builders to submit block proposals directly to validators.
- **Increased Security and Fairness**: With the process enshrined in the protocol, the potential for manipulation decreases, enhancing the overall security and fairness of block construction.


**Technical Changes for ePBS**
Transitioning to ePBS requires significant technical changes to the Ethereum protocol, including:
- **New Consensus Mechanisms**: Adjustments to the consensus layer to accommodate the separate roles of proposers and builders, ensuring they can interact securely and efficiently.
- **Smart Contract and Off-Chain Components**: Development of new smart contracts and off-chain infrastructure to manage the auction process, builder registration, and bid submissions.
- **Adjustments to Validator Operations**: Validators need to adapt their operations to participate in the ePBS framework, requiring updates to client software and operational practices.


**Challenges and Considerations**
The transition involves several challenges, such as ensuring the system's resilience to new forms of MEV exploitation, maintaining network performance amid the added complexity, and achieving broad consensus within the Ethereum community on the ePBS implementation details.

Moving from MEV-Boost to ePBS is a complex but necessary step towards a more decentralized, secure, and efficient Ethereum. It represents a move from a practical workaround to a foundational redesign of how Ethereum handles block proposal and construction, aiming to mitigate MEV's adverse effects while upholding the network's core principles. This transition is crucial for Ethereum's scalability and sustainability as it continues to evolve and accommodate growing demand.


## [The Case for ePBS](#the-case-for-epbs)

The transition to ePBS from the current MEV-Boost system is motivated by several key reasons that align with Ethereum's core values of decentralization, security, and efficiency. Proponents of ePBS highlight the importance of integrating PBS directly into the Ethereum protocol to address several concerns arising from the reliance on relays and out-of-protocol mechanisms for block construction. Here's a detailed explanation of these aspects:

### Main Reasons for Transition to ePBS
1. **Decentralization**: ePBS aims to reduce the reliance on a few centralized relays by embedding the proposer-builder separation mechanism directly within the Ethereum protocol. This move seeks to distribute the responsibility for block construction across a broader set of participants, enhancing the network's resilience and reducing central points of failure.
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

The transition towards enshrined proposer-builder separation (ePBS) involves critical economic and security considerations, especially in the context of Miner Extractable Value (MEV) and proposals like MEV burn. These considerations shape the debate around ePBS, highlighting its potential impact on the Ethereum ecosystem. Here's an exploration of these aspects:

### Economic Considerations
1. **MEV Distribution**: One of the primary economic concerns revolves around how MEV is distributed among validators, builders, and users. ePBS aims to create a more transparent and equitable MEV market by ensuring that validators are fairly compensated for the blocks they propose. This could potentially alter the current dynamics, where certain participants may disproportionately benefit from MEV.
2. **Market Efficiency**: By integrating PBS directly into the Ethereum protocol, ePBS is expected to foster a more competitive and efficient marketplace for block space. This could lead to better pricing mechanisms for transaction inclusion, benefiting users with fairer transaction costs and potentially reducing the prevalence of gas price auctions that lead to network congestion.
3. **Sustainability of Relays**: ePBS addresses the operational and financial sustainability concerns of relays by potentially reducing their role in the MEV extraction process. A protocol-level solution could offer a more stable and predictable framework for handling MEV, alleviating the need for external relays and their associated costs.

### Security Considerations
1. **Centralization Risks**: The current reliance on a limited set of MEV-Boost relays introduces centralization risks, making the network more vulnerable to attacks or manipulations. ePBS seeks to mitigate these risks by decentralizing the process of block proposal and construction, aligning with Ethereum's security ethos.
2. **Manipulative Practices**: External relays and opaque MEV extraction mechanisms can lead to manipulative practices, such as transaction reordering or sandwich attacks, that undermine network integrity. ePBS aims to provide a more regulated and transparent environment for handling MEV, enhancing overall network security.
3. **Protocol-Enshrined Security**: Incorporating PBS directly into the Ethereum protocol ensures that block construction adheres to the same rigorous consensus and security standards that govern other aspects of the network. This unified approach to security is seen as a significant improvement over the current system, where external components like relays operate without direct protocol oversight.

### MEV Burn
The concept of MEV burn involves redirecting a portion of MEV profits towards burning Ether, reducing the overall supply and potentially increasing the value of the remaining Ether. This mechanism has been proposed as a way to align the interests of validators, builders, and the wider Ethereum community by ensuring that excessive MEV extraction does not lead to inflationary pressures or disproportionate benefits for certain network participants.
1. **Inflationary Pressure Mitigation**: By burning a part of the MEV, Ethereum could potentially control inflationary pressures arising from new Ether issuance for block rewards.
2. **Economic Stability**: MEV burn could contribute to the economic stability of Ethereum by ensuring that the benefits of MEV extraction are more evenly distributed across the ecosystem, including Ether holders who are not directly involved in MEV strategies.
3. **Alignment of Incentives**: Implementing an MEV burn mechanism could help align the incentives of various network participants, ensuring that the pursuit of MEV does not compromise network security or efficiency.

In summary, the transition to ePBS from the current MEV-Boost system is driven by a combination of economic and security considerations, including concerns about MEV distribution, market efficiency, centralization risks, and the operational sustainability of relays. The potential implementation of an MEV burn mechanism further reflects Ethereum's commitment to aligning economic incentives with its core values of decentralization, security, and efficiency. This transition marks a pivotal moment in Ethereum's evolution, potentially reshaping the landscape of transaction ordering and MEV extraction in favor of a more secure, efficient, and equitable ecosystem.


## [Counterarguments to ePBS](#counterarguments-to-epbs)
### ["If it ain't broke, don't fix it" perspective](#if-it-aint-broke-dont-fix-it-perspective)
Because we have to plan for the future. It is not about today's situation. Example, EIP4844. 

### [Alternative solutions for addressing MEV]
### [Prioritization within Ethereum’s roadmap]
### [The debate on the optimal ePBS mechanism]


## [Designing ePBS](#designing-epbs)
### Desirable properties of ePBS mechanisms
### The Two-Block HeadLock (TBHL) proposal: An overview
### PTC 
### PEPC
### Addressing honest builder publication and payment safety
### Ensuring permissionlessness and censorship resistance
### Implementation details for PTC

## Out-of-protocol proposals
### [Optimistic Relaying: A Step Towards ePBS](#optimistic-relaying-a-step-towards-epbs)
#### Concept and benefits of optimistic relaying
#### The evolution from optimistic relaying v1 to the endgame
#### Potential impacts on the relay landscape and ePBS implementation
### PEPC-Boost
### PEPC-DVT
### MEV-Boost+
### MEV-BOOST++

## Open Questions
### What does bypassability imply?
### What does enshrining aim to achieve? 
### What are the exact implications of not enshrining? 
### WHat is the real demand for ePBS?
### How much can we rely on altruism and the social layer? 
### How important is L1 ePBS in a future with L2s and OFAs? 
### What priority should ePBS have in light of other protocol upgrades? 


## [Community Perspectives and Future Directions](#community-perspectives-and-future-directions)