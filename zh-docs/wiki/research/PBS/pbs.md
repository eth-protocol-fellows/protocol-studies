# Proposer Builder Separation (PBS)

In Ethereum's current system, validators both create and broadcast blocks. They bundle together transactions that they have discovered through the gossip network and package them into a block which is then sent out to peers on the Ethereum network. **Proposer-builder separation (PBS)** splits these tasks across multiple validators. Block builders become responsible for creating blocks and offering them to the block proposer in each slot. The block proposer cannot see the contents of the block, they simply choose the most profitable one, paying a fee to the block builder before sending the block to its peers.

This section will be covering details about PBS, roles of block proposers and block builders, current state - mev boost, relays, challenges and security issues, proposed solutions and further collection of resources related to the topic.

## Why is PBS important?

PBS is important to the decentralization of Ethereum because it minimizes the compute overhead that is required to become a validator. By doing this, the network lowers the barrier to entry for becoming a validator and incentives a more diverse group of participants. PBS also reflects an overall goal of The Merge to move Ethereum’s network towards a more modular future. Specifically, the transition to PoS is an aggressive move towards decentralization through modularity.

When you break apart the different pieces of block construction, you can decentralize them individually. This allows different actors with different specialties to focus on their particular strengths. The net result is a more capable network with fewer external dependencies and a lower threshold for participation.

## Understanding PBS and the Consensus layer

As explained in this [article](https://ethos.dev/beacon-chain), slots are the time frames allowed in the consensus layer for a block to be added to the chain, they last 12 seconds and there are 32 of them per epoch. Epochs are significant for the consensus mechanism, serving as checkpoints where the network can finalize blocks, update validator committees, etc. For each slot, a validator is chosen through [RANDAO](https://inevitableeth.com/home/ethereum/network/consensus/randao) to propose a block. Once proposed and added to the canonical chain, the validators chosen for that slot's committees attest to the validity of the block, which shall eventually reach finality. The consensus layer supports Ethereum's network security and integrity. PBS interacts with this layer by dividing/isolating the duties of proposing and building blocks, thereby streamlining the transaction validation process.

### The Role of the builder

**Block builders** gather, validate, and assemble transactions into a block body. They review the mempool, validate the transactions by ensuring that they meet requirements like gas limits and nonce, and create a data structure containing the transaction data. Block builders are also responsible for ordering the transactions to optimize block space and gas usage. They then make the block body available to block proposers.

### The Role of the proposer

**Block proposers** take the block bodies provided by the block builders and create a complete block by adding necessary metadata, such as the block header. The header includes details such as the parent block's hash, timestamp, and other data. They also ensure the validity of the blocks by checking the correctness of the block body provided by the builders.

## Current State

Currently, PBS (Proposer Builder Separation) exists outside of the protocol by builders helping in block building through entities like relays. Please refer [mev-boost](/wiki/research/PBS/mev-boost.md) for more details on one of the widely used Out-of-protocol solution. This design relies on small set of trusted relays and even builders which introduces centralization risks and makes Ethereum more vulnerable to censorship.
PBS is not yet implemented in the Ethereum mainnet which means validators act as both proposers and builders. So each validator is responsible for:

1. **Selecting transactions:** Validators choose which transactions to include in a block based on factors like gas fees and transaction priority.
2. **Building the block:** Validators assemble the chosen transactions into a block and perform necessary computations like verifying signatures and updating the state.
3. **Proposing the block:** Validators propose the constructed block to the network for validation and inclusion in the blockchain.

However, some clients are actively developing and testing PBS implementations. These implementations aim to separate the builder and proposer roles, allowing validators to outsource block construction to specialized builders. This can lead to several potential benefits:

- **Increased validator rewards:** Builders can compete to create the most profitable block for the proposer, potentially leading to higher rewards for validators.
- **Improved network efficiency:** Specialized builders can optimize block construction, leading to more efficient block propagation and processing.
- **Reduced centralization:** By decoupling the roles, PBS can potentially reduce the influence of large mining pools or staking providers that currently dominate both block building and proposing.

### PBS and the Relationship Between Relays, Builders, and Validators

Proposer-Builder Separation (PBS) also introduces a more intricate relationship between different actors in the Ethereum network:

1. **Builders:**
   - Builders are specialized entities that focus on constructing blocks with optimal transaction ordering and inclusion. They compete with each other to create the most profitable block for the proposer, taking into account factors like gas fees, transaction priority, and potential MEV (Maximal Extractable Value).
   - Builders do not directly interact with the blockchain. Instead, they submit their constructed blocks to relays.
   - This submission includes the block's data (transactions, execution payload, etc.) and a bid that they are willing to pay to have their block proposed.
2. **Relays:**
   - Relays receive blocks from multiple builders, confirm their validity and submit the valid block with the highest bid to the escrow for the validator to sign.
   - Relays act as intermediaries between builders and proposers. They receive blocks from builders and forward them to proposers.
   - Relays can perform additional functions like block validation and filtering to ensure that only valid and high-quality blocks are sent to proposers.
   - Some relays may specialize in specific types of blocks, such as those with high MEV potential.
3. **Validators (Proposers):**
   - Under PBS, validators take on the role of proposers. They receive blocks from relays and choose the best one based on predefined criteria, typically the block that offers the highest reward.
   - Once the proposer selects a block, they propose it to the network for validation and inclusion in the blockchain.
   - Validators are still responsible for securing the network and ensuring consensus on the blockchain's state.

This whole process is illustrated in the figure below. See [Flashbots' docs](https://docs.flashbots.net/) for further explanations.

<figure style="text-align: center;">
  <img src="../../images/mev-boost-architecture.png" alt="MEV-Boost architecture">
  <figcaption style="text-align: center;">Outline of the communication between the MEV-Boost PBS participants. Source: <a href="https://ethresear.ch/t/mev-boost-merge-ready-flashbots-architecture/11177">ethresear.ch</a></figcaption>
</figure>

This separation of roles creates a more dynamic and specialized block-building process. Builders can focus on optimizing block construction and extracting MEV, while proposers can focus on selecting the best block and maintaining network security.

However, this new relationship also introduces new challenges.

### Relay Concerns

A case can be made that relays oppose the following Ethereum's core tenets:

- Decentralization: The fact that [six relays](https://www.relayscan.io/overview?t=7d) handle 99% of MEV-Boost blocks (that being nigh on 90% of Ethereum's blocks) gives rise to justified centralization concerns.
- Censorship resistance: Relays _can_ censor blocks and, being centralized, can be coerced by regulators to do so. This happened, for instance, when they were pressured to censor transactions interacting with addresses on the [OFAC sanction list](https://home.treasury.gov/news/press-releases/jy0916).
- Trustlessness: Validators trust relays to provide a valid block header and to publish the full block once signed; builders trust relays not to steal MEV. Although betrayal of either would be detectable, dishonesty can be profitable even through a one-time attack.

### Third party dependency

The fact that PBS entails outsourcing the building of the blocks to entities that do not directly participate in Ethereum consensus could potentially lead to unexpected or unwanted consequences stemming from relying on third parties, such as trust issues, operational dependency and the introduction of single points of failure. Particularly the fact that the use of MEV-Boost is so widespread could be viewed as a dangerous third party dependency, since such a huge portion of Ethereum's new blocks are created using Flashbot's software.

On a very recent note, On March 27-28, Ethereum experienced a spike in missed slots due to slow blob propagation from bloXroute-relayed blocks. The issue stemmed from the Lighthouse client expecting blobs and blocks from the same source, a mismatch with bloXroute's BDN(Blockchain Distributed Network), which only transmits blocks. This discrepancy led nodes to ignore blocks without accompanying blobs, especially after a BDN update accelerated block propagation without blobs. Attempts to integrate blobs with these blocks were unsuccessful, often resulting in a 202 response where data was acknowledged but not used due to prior block reception.

The core of the problem was identified in Lighthouse's HTTP API handling for blob distribution, separate from the P2P network. This incident underscores the potential pitfalls of relying on external services like bloXroute for critical blockchain operations, highlighting the importance of meticulous component management within blockchain networks to maintain operational integrity and avoid vulnerabilities. More details can be found [here](https://gist.github.com/benhenryhunter/687299bcfe064674537dc9348d771e83).

### Security Concerns

As seen in this entry, PBS involves many different entities taking part in the process of adding new blocks to the chain, which inevitably increases the number of potential attack vectors that could be exploited.

PBS-related vulnerabilities, like faulty relays or escrows, risk causing missed blocks without endangering Ethereum's integrity. These missed blocks can affect users and validators. Despite this, Ethereum clients can revert to conventional block building if external builders fail, ensuring network stability.

### Undermined Censorship Resistance

Another issue builder centralization might bring is putting at risk Ethereum's censorship resistance and integrity, as these dominant builders could, in theory, collude or be coerced into manipulating transaction flows or excluding specific transactions from being included in blocks, undermining the open and permissionless nature of the Ethereum network. Although in current situation, even majority of parties choose to censor, still cannot prevent from submitting these transactions, but only delay their inclusion.

To increase censorship resistance, mechanisms like anonymous block proposals, which would protect participants from being singled out for the transactions they handle, are being considered. Additionally, making commitments to include specific transactions mandatory in block proposals is also being explored to ensure essential transactions cannot be censored. A brief overview can found [here](https://censorship.pics).

For a detailed discussion on these anti-censorship measures within PBS, see [Vitalik Buterin's comprehensive analysis](https://notes.ethereum.org/@vbuterin/pbs_censorship_resistance).

## Research and Proposed Solutions

PBS is one of the active research areas in the Ethereum ecosystem. It presents several challenges, including potential security vulnerabilities and the risk of centralization. Ongoing research focuses on addressing these concerns through innovations such as enshrined PBS (ePBS), inclusion lists, the Protocol-Enforced Proposer Commitments (PEPC).

Enshrined Proposer-Builder Separation (ePBS) is supposed to address some of the limitations and centralization concerns associated with MEV-Boost, which currently facilitates PBS for about 90% of Ethereum blocks.

<figure style="text-align: center;">
  <img src="../../images/MEV-Boost blocks.png" alt="Evolution of MEV-Boost slot share since The Merge">
  <figcaption style="text-align: center;">Evolution of the portion of blocks built through MEV-Boost since The Merge. Source: <a href="https://mevboost.pics/">mevboost.pics</a></figcaption>
</figure>

### Enshrined Proposer-Builder Separation (ePBS)

Enshrined PBS involves embedding PBS mechanisms directly into Ethereum's consensus layer, which would have two main potential advantages:

- Reduction in centralization risks: Moving PBS into the protocol layer could potentially reduce reliance on third parties with a tendency for centralization, aligning with Ethereum’s core values of decentralization and censorship resistance.
- Security and stability: External dependencies and out-of-protocol software, such as relays, have shown vulnerabilities (e.g., "Low-Carb Crusader" attack). Integrating PBS into the Ethereum protocol can mitigate these risks and reduce the coordination costs associated with maintaining compatibility between various components.

Referring to this [eth research discussion](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710), ePBS, particularly through Two-Block HeadLock (TBHL) and optimistic relaying, presents a pathway towards addressing current challenges and enhancing the efficiency, security, and decentralization of block production and MEV extraction processes.

For more detailed on ePBS check out this [ePBS wiki entry](/wiki/research/PBS/ePBS.md).

### Protocol-Enforced Proposer Commitments (PEPC)

PEPC is another proposed solution for the shortcomings of PBS and MEV-Boost which advocates for a more open-ended and flexible design than traditional PBS. As explained on this [Mirror post](https://mirror.xyz/ohotties.eth/lBEXiiU7yK91OuSn8QyJPM9Db8GuyDFzCEUAj60BWyI), PEPC aims to provide a generalized infrastructure for proposers to make credible commitments to any outsourced block-building task, which could potentially better accommodate the evolving needs of the Ethereum network, especially with the anticipated expansion of data sharding and rollup adoption.

The goal is to allow proposers to register arbitrary commitments, expressed via EVM execution, that external parties can rely on. This way, anyone can provide services to proposers as long as they satisfy the registered commitments, fostering permissionless innovation. Also, unlike externals solutions such as MEV-Boost, PEPC would integrate commitment satisfaction into the core protocol, blocks being considered valid only if they fulfill the proposer's registered commitments, enhancing security and trustworthiness.

Regarding the need for a flexible approach to proposer duties PEPC aims to provide, it is worth noting that a wide range of outsourcing smart contracts is supported, from full block construction to specific valid transaction inclusions and validity proofs for rollup blocks.

All of this would also be complementary to existing out-of-protocol mechanisms like Eigenlayer, enhancing the credibility of proposer commitments by moving from an optimistic model to a pessimistic enforcement model where violating commitments inherently invalidates blocks.

For more detailed explanation check out [PEPC](/wiki/research/PBS/ePBS?id=protocol-enforced-proposer-commitments-pepc).

### EIP-7547: Inclusion Lists

As explained in this [ethereum-magicians.org post](https://ethereum-magicians.org/t/eip-7547-inclusion-lists/17474), inclusion lists aim to provide a mechanism to improve the censorship resistance of Ethereum by allowing proposers to specify a set of transactions that must be promptly included for subsequent blocks to be considered valid.

This way proposers retain some authority over block building without sacrificing MEV rewards, through a mechanism by which transactions can be forcibly included. The simplest approach would be for the proposer to specify a list of transactions they found themselves in the mempool that must be included by the block builder if they want their block to be proposed for the next slot. Although some issues stem from this, such as incentive incompatibilities and exposure of free-data availability, solutions like forward and multiple inclusion lists have been proposed and are being developed to address these challenges, demonstrating the Ethereum community's commitment to refining and advancing the protocol to uphold its core values of decentralization, fairness, and censorship resistance.

### Further Reading and Resources

Below are some further readings regarding PBS and related topics:

- [Notes on Proposer-Builder Separation (PBS)](https://barnabe.substack.com/p/pbs)
- [Timing Games and Implications on MEV extraction](https://chorus.one/articles/timing-games-and-implications-on-mev-extraction)
- [Why ePBS?](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710)
- [Vitalik on pbs censorship](https://notes.ethereum.org/@vbuterin/pbs_censorship_resistance)
- [Payload timeliness committee(PTC) design for ePBS](https://ethresear.ch/t/payload-timeliness-committee-ptc-an-epbs-design/16054)
- [2-slot PBS](https://ethresear.ch/t/two-slot-proposer-builder-separation/10980)
- [Forward Inclusion Lists](https://notes.ethereum.org/@fradamt/forward-inclusion-lists)
