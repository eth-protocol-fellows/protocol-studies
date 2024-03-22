# Proposer-Builder Separation 

Ever since the Beacon Chain Merge in September 15th, 2022, Ethereum has been a proof-of-stake network. On that day, miners were replaced by validators who, instead of solving the proof of work, stake their ether for a chance to add the next block to the chain, thus earning the corresponding reward. Initially, just as in PoW Ethereum, both bundling the validated transactions into a block and proposing said block for the next slot were done by the same node. However, separating these tasks has been gaining popularity and is likely to become standard practice for the Ethereum consensus mechanism.

This practice is known as Proposer-Builder Separation, often referred to as PBS, which consists of having two different entities involved in the process of new block generation. Instead of the validator pseudo-randomly selected for block proposal adding a block it created itself, in PBS we have:
- Builder: The entity that aggregates transactions creating a block.
- Proposer: The entity (validator) that proposes the block built by the builder for the next slot of the chain.
- Relay: The entity responsible for escrowing blocks from builders to proposers.

In this entry we will examine different aspects of PBS, including how it works, why it is relevant or how it may impact the future of Ethereum.

## PBS and Consensus

PBS being an emergent approach to consensus on Ethereum, it is important to examine in detail how the process integrates into the Beacon Chain, Ethereum's consensus layer. 

As eloquently explained in the [Beacon Chain Explainer](https://ethos.dev/beacon-chain), slots are the time frames allowed in the consensus layer for a block to be added to the chain, they last 12 seconds and there are 32 of them per epoch. Epochs are significant for the consensus mechanism, serving as checkpoints where the network can finalize blocks, update validator committees, etc., but such explanations are out of this entry's scope. 

For each slot, a validator is chosen through [RANDAO](https://inevitableeth.com/home/ethereum/network/consensus/randao) to propose a block. Once proposed and added to the canonical chain, the validators chosen for that slot's committees attest to the validity of the block, which shall eventually reach finality. This whole process, which is core to the Ethereum protocol, happens irrespectively of whether the node that proposed the block was also the one who built it. Thus, PBS is irrelevant for consensus, implementing it or not is up to each validator and they are free to do so in whichever way they see fit, as long as the blocks proposed are valid.

## Origins of PBS

As explained in this [BlockNative post](https://www.blocknative.com/blog/ethereum-block-building), before the merge miners were in charge of both building the new blocks and adding them to the chain. This allowed them to control the flow of transactions to profit from on-chain activities, prioritizing those with higher priority fees. This gave rise to the concept of Miner Extractable Value (MEV). As increasingly sophisticated activity ocurred on Ethereum, MEV searchers started to emerge, who specialized in monitoring the mempool looking for opportunities to profit by strategically ordering the contents of a block, to then sell that bundle of transactions to a miner (win-win). 

Since being a good searcher required highly specialized knowledge, it was rare for mining pool operators to have this know-how, and therefore collaboration between searchers and miners was required. For this, the necessary communication channel was provided by [Flashbots](https://docs.flashbots.net/), whose open MEV marketplace allowed searchers to submit transaction bundles to miners (with whom MEV profit was shared) for inclusion in blocks. Specialized clients such as [MEV-Geth](https://github.com/flashbots/mev-geth) made it possible for miners to build blocks with the transactions they picked from the mempool themselves or the bundles created by searchers.

This was very attractive to miners, who this way achieved higher incomes, due to the higher transaction fees accrued. Unsurprisingly, according to Flashbots, [over 90% of Ethereum miners outsourced some of their block construction](https://writings.flashbots.net/why-run-mevboost/) to them, as of June, 2022.

However, in post-merge Ethereum, the entry barrier for participating in consensus decreased significantly. Although still considerable, it became endogenous to the network (32 ETH, instead of mining rigs) and physically more convenient (removing the need for equipment powering, storage, maintenance, etc.), thus paving the way for hobbyist/solo validators and increasing Ethereum's decentralization. 

Another key difference between PoW and PoS Ethereum is that before the merge only miners could build the blocks (since they had to find the right nonce for the proof of work hash), so searchers could only suggest transaction bundles for them to include in a block. However, in PoS Ethereum anyone can build a complete block for a validator to propose for the next slot. This together with the increase in the number of validators, most of which lacked the skill to build maximally profitable blocks, gave rise to the role of block builders.

## PBS Block Creation (MEV-Boost)

In today's Ethereum, most validators use the [MEV-Boost](https://github.com/flashbots/mev-boost) client (MEV now meaning Maximal Extractable Value), which allows them to source high-MEV blocks from a competitive builder marketplace, in a similar fashion as MEV-Geth did with transaction bundles in PoW Ethereum. This Ethereum client makes it possible for validators to create such bundles taking transactions directly from the mempool, however, this is becoming less frequent, as specialized builders provide more profitable blocks to proposers.

The process works as outlined by the following image and explained below.

<figure style="text-align: center;">
  <img src="../../images/PBS-outline.png" alt="PBS outline">
  <figcaption style="text-align: center;">Outline of the PBS process using MEV-Boost. Source: <a href="https://github.com/flashbots/mev-boost">Flashbots</a></figcaption>
</figure>

### Block Construction

- Builders continuously monitor the transaction pool (mempool) for new transactions. They assess these transactions based on potential MEV opportunities. They select the transactions that best align with their MEV optimization criteria. Also, block builders can take transaction bundles from private orderflows, or from MEV searchers, just as miners did in PoW Ethereum with the original Flashbots auctions. In the latter case, builders accept sealed-price bids from searchers and include their bundles in the block.
- Once the transactions are selected, builders assemble them into a block ensuring that the block adheres to the Ethereum protocol's rules, e. g., the gas limit is not surpassed.

### Block Auction

Although builders can directly offer their assembled blocks to validators, specifying a price, the standard practice is to use relays. Relays validate the transaction bundles before passing them onto the proposer (validator). Also, MEV Boost introduces escrows responsible for providing data availability by storing blocks sent by builders and commitments sent by validators. The auction process works as follows:
- Builders submit their constructed blocks to relays. This submission includes the block's data (transactions, execution payload, etc.) and a bid that they are willing to pay to have their block proposed.
- Relays receive blocks from multiple builders, confirm their validity and submit the valid block with the highest bid to the escrow for the validator to sign.
- Proposers, who can connect to multiple relays, review the blocks submitted by each relay, and select the most profitable one. Once they have chosen a block, they sign its header by sending its hash back to the relay's escrow. This is the commitment that they will add that block to the chain: by sending the block's header's hash (signing it), they are committing to that specific block. 

This whole process is illustrated in the figure below. See [Flashbots' docs](https://docs.flashbots.net/) for further explanations.

<figure style="text-align: center;">
  <img src="../../images/mev-boost-architecture.png" alt="MEV-Boost architecture">
  <figcaption style="text-align: center;">Outline of the communication between the MEV-Boost PBS participants. Source: <a href="https://ethresear.ch/t/mev-boost-merge-ready-flashbots-architecture/11177">ethresear.ch</a></figcaption>
</figure>

### Block Proposal

- The proposer adds the selected block to the next slot of the Ethereum canonical chain, for it to be attested to by the corresponding committees of validators.

### Rewards Distribution

- Once the block is successfully added to the blockchain, the proposer receives the block rewards (ether new issuance) and the priority fees payed by the users who got their transactions included in that block. 
- Once received, the proposer shares with the builder the portion of these rewards agreed upon through the auction.

## PBS' Benefits 

Considering the process of adding a block to the chain explained above, the key takeaway regarding MEV is that its extraction is no longer performed by validators. Of course, they are not excluded completely from MEV-related income, since the higher the priority fees of the transactions included in a block, the higher the builders will bid to make sure the block gets proposed and they get their share of those fees. Nevertheless, since validators are no longer focused on optimizing MEV income, the threat of [time-bandit attacks](https://www.mev.wiki/attack-examples/time-bandit-attack) (chain reorgs) is reduced significantly.

Also, proposer-builder separation **reduces the risks of centralization** MEV entails (since validators extracting the most MEV would tend to grow, increasing their relative weight in consensus). Also, the fact that a commit-reveal scheme is used, in which blocks are sent to the relays by builders and committed to by validators, removes the need for the former to trust the latter not to steal a MEV opportunity. If this were not the case, builders would favor large validator pools with off-chain reputation, which would be a high entrance barrier for hobbyist validators.

Last but not least, PBS gives rise to an increase in validator rewards, since specialized block building optimizes profitability. This is also beneficial for Ethereum, since it makes staking ether more attractive, which may have a positive impact in terms of favoring an increase in the capital securing the network.

## PBS' Future

Although not directly ingrained in the Ethereum protocol, PBS is a very relevant topic, not only due to its many current benefits, but also because it stands to play a significant role in the future of Ethereum. As explained in the [ethereum.org](https://ethereum.org/en/roadmap/pbs/) entry for PBS, outsourcing block construction to specialized builders will probably become essential when full Danksharding is implemented. This is due to the fact that the computation of proofs of up to 64 MB in less than a second will be required, which will take up significant hardware resources, giving rise to centralization issues, were block building and proposal not separated. This being as an inevitable reality, PBS makes it possible to keep block validation decentralized, even if building decentralization is bound to decrease.

Thus, Danksharding being one of the key milestones in Ethereum's roadmap, and the way the network shall scale to over 100,000 TPS, PBS stands out as an indispensable practice to keep Ethereum decentralized.

## PBS' Challenges

Although as explained above, PBS has many benefits and stands to become essential for the Ethereum protocol, its increasing popularity shall also pose some challenges that will need to be addressed. 

### Builder Centralization

As explained in the previous section, builder centralization is a likely event in Ethereum's future. While this is, in principle, not a big concern, since proposers are the ones adding blocks to the chain, this centralization becoming too significant, there being only a handful of builders creating all the new blocks, could potentially lead to a scenario in which a few highly efficient and well-capitalized builders dominate the block construction market.

This could skew the network's transaction inclusion dynamics, creating a landscape where only certain transactions are consistently prioritized based on their profitability to these builders (or their associates), rather than the intended fair selection process based on supply and demand, incurring in dishonest practices such as financial mischief. 

Also, such centralization might put at risk Ethereum's censorship resistance and integrity, as these dominant builders could, in theory, collude or be coerced into manipulating transaction flows or excluding specific transactions from being included in blocks, undermining the open and permissionless nature of the Ethereum network.

### Relay Concerns

A case can be made that relays oppose the following Ethereum's core tenets:

- Decentralization: The fact that [six relays](https://www.relayscan.io/overview?t=7d) handle 99% of MEV-Boost blocks (that being nigh on 90% of Ethereum's blocks) gives rise to justified centralization concerns.
- Censorship resistance: Relays *can* censor blocks and, being centralized, can be coerced by regulators to do so. This happened, for instance, when they were pressured to censor transactions interacting with addresses on the [OFAC sanction list](https://home.treasury.gov/news/press-releases/jy0916).
- Trustlessness: Validators trust relays to provide a valid block header and to publish the full block once signed; builders trust relays not to steal MEV. Although betrayal of either would be detectable, dishonesty can be profitable even through a one-time attack.

<!-- ### Third party dependency

On a similar note, the fact that PBS entails outsourcing the building of the blocks to entities that do not directly participate in Ethereum consensus could potentially lead to unexpected or unwanted consequences stemming from relying on third parties, such as trust issues, operational dependency and the introduction of single points of failure. -->

### Security Concerns

As seen in this entry, PBS involves many different entities taking part in the process of adding new blocks to the chain, which inevitably increases the number of potential attack vectors that could be exploited. 

As opposed to *traditional* block creation in which the validator builds the block and adds it to the chain, PBS brings to the table many possible points of failure, such as the relays or escrows, which could potentially act maliciously or fail in their mission to provide data availability, disrupting the block proposal process, favoring certain builders, etc. Also, the commit-reveal scheme in escrows, if exploited, could give rise to MEV opportunities being stolen from the rightful block builders, undermining their performance.

Although these issues are in principle not a big concern (PBS and MEV-Boost have proved to be secure so far), it is of the utmost importance that they be prevented.

## Proposed Solutions

### Enshrined Proposer-Builder Separation (ePBS)

As explained in this very insightful [ethresear.ch post](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710), Enshrined Proposer-Builder Separation addresses some of the limitations and centralization concerns associated with MEV-Boost, which currently facilitates PBS for about 90% of Ethereum blocks.

<figure style="text-align: center;">
  <img src="../../images/MEV-Boost blocks.png" alt="Evolution of MEV-Boost slot share since The Merge">
  <figcaption style="text-align: center;">Evolution of the portion of blocks built through MEV-Boost since The Merge. Source: <a href="https://mevboost.pics/">mevboost.pics</a></figcaption>
</figure>

Enshrined PBS involves embedding PBS mechanisms directly into Ethereum's consensus layer, which would have two main potential advantages:

- Reduction in centralization risks: Moving PBS into the protocol layer could potentially reduce reliance on third parties with a tendency for centralization, aligning with Ethereum’s core values of decentralization and censorship resistance.
- Security and stability: External dependencies and out-of-protocol software, such as relays, have shown vulnerabilities (e.g., "Low-Carb Crusader" attack). Integrating PBS into the Ethereum protocol can mitigate these risks and reduce the coordination costs associated with maintaining compatibility between various components.

According to the article, ePBS, particularly through Two-Block HeadLock (TBHL) and optimistic relaying, presents a pathway towards addressing current challenges and enhancing the efficiency, security, and decentralization of block production and MEV extraction processes.

### Protocol-Enforced Propose Commitments (PEPC)

PEPC is another proposed solution for the shortcomings of PBS and MEV-Boost which advocates for a more open-ended and flexible design than traditional PBS. As explained on this [Mirror post](https://mirror.xyz/ohotties.eth/lBEXiiU7yK91OuSn8QyJPM9Db8GuyDFzCEUAj60BWyI), PEPC aims to provide a generalized infrastructure for proposers to make credible commitments to any outsourced block-building task, which could potentially better accommodate the evolving needs of the Ethereum network, especially with the anticipated expansion of data sharding and rollup adoption.

The goal is to allow proposers to register arbitrary commitments, expressed via EVM execution, that external parties can rely on. This way, anyone can provide services to proposers as long as they satisfy the registered commitments, fostering permissionless innovation. Also, unlike externals solutions such as MEV-Boost, PEPC would integrate commitment satisfaction into the core protocol, blocks being considered valid only if they fulfill the proposer's registered commitments, enhancing security and trustworthiness. 

Regarding the need for a flexible approach to proposer duties PEPC aims to provide, it is worth noting that a wide range of outsourcing smart contracts is supported, from full block construction to specific valid transaction inclusions and validity proofs for rollup blocks. 

All of this would also be complementary to existing out-of-protocol mechanisms like Eigenlayer, enhancing the credibility of proposer commitments by moving from an optimistic model to a pessimistic enforcement model where violating commitments inherently invalidates blocks.

### EIP-7547: Inclusion Lists

As explained in this [ethereum-magicians.org post](https://ethereum-magicians.org/t/eip-7547-inclusion-lists/17474), inclusion lists aim to provide a mechanism to improve the censorship resistance of Ethereum by allowing proposers to specify a set of transactions that must be promptly included for subsequent blocks to be considered valid.

This way proposers retain some authority over block building without sacrificing MEV rewards, through a mechanism by which transactions can be forcibly included. The simplest approach would be for the proposer to specify a list of transactions they found themselves in the mempool that must be included by the block builder if they want their block to be proposed for the next slot. Although some issues stem from this, such as incentive incompatibilities and exposure of free-data availability, solutions like forward and multiple inclusion lists have been proposed and are being developed to address these challenges, demonstrating the Ethereum community's commitment to refining and advancing the protocol to uphold its core values of decentralization, fairness, and censorship resistance.

## Resources

The resources consulted to write this entry have already been linked throughout the text, but here's the full list:

- https://ethos.dev/beacon-chain
- https://inevitableeth.com/home/ethereum/network/consensus/randao
- https://www.blocknative.com/blog/ethereum-block-building
- https://docs.flashbots.net/
- https://github.com/flashbots/mev-geth
- https://writings.flashbots.net/why-run-mevboost/
- https://github.com/flashbots/mev-boost
- https://docs.flashbots.net/
- https://ethresear.ch/t/mev-boost-merge-ready-flashbots-architecture/11177
- https://www.mev.wiki/attack-examples/time-bandit-attack
- https://ethereum.org/en/roadmap/pbs/
- https://www.relayscan.io/overview?t=7d
- https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710
- https://mevboost.pics/
- https://mirror.xyz/ohotties.eth/lBEXiiU7yK91OuSn8QyJPM9Db8GuyDFzCEUAj60BWyI
- https://ethereum-magicians.org/t/eip-7547-inclusion-lists/17474


## Further readings

Below are some further readings regarding PBS and related topics:

- [Notes on Proposer-Builder Separation (PBS)](https://barnabe.substack.com/p/pbs)
- [Timing Games and Implications on MEV extraction](https://chorus.one/articles/timing-games-and-implications-on-mev-extraction)
