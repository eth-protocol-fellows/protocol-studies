<!-- @format -->

<<<<<<< HEAD

<!-- @format -->

# Proposer Builder Separation (PBS) in Ethereum

[comment]: <> (Feel Free to propose changes)
[comment]: <> (Introduction)

In Ethereum's current system, validators both create and broadcast blocks. They bundle together transactions that they have discovered through the gossip network and package them into a block which is then sent out to peers on the Ethereum network. **Proposer-builder separation (PBS)** splits these tasks across multiple validators. Block builders become responsible for creating blocks and offering them to the block proposer in each slot. The block proposer cannot see the contents of the block, they simply choose the most profitable one, paying a fee to the block builder before sending the block to its peers.

This page will be covering details about PBS, roles of block proposers and block builders, current state - mev boost, relays, challenges and security issues, proposed solutions and further collection of resources related to the topic.

## Why is PBS important?

PBS is important to the decentralization of Ethereum because it minimizes the compute overhead that is required to become a validator. By doing this, the network lowers the barrier to entry for becoming a validator and incentives a more diverse group of participants. PBS also reflects an overall goal of The Merge to move Ethereum’s network towards a more modular future. Specifically, the transition to PoS is an aggressive move towards decentralization through modularity.

When you break apart the different pieces of block construction, you can decentralize them individually. This allows different actors with different specialties to focus on their particular strengths. The net result is a more capable network with fewer external dependencies and a lower threshold for participation.

## Understanding PBS and the Consensus layer

As explained in this [article](https://ethos.dev/beacon-chain), slots are the time frames allowed in the consensus layer for a block to be added to the chain, they last 12 seconds and there are 32 of them per epoch. Epochs are significant for the consensus mechanism, serving as checkpoints where the network can finalize blocks, update validator committees, etc. For each slot, a validator is chosen through [RANDAO](https://inevitableeth.com/home/ethereum/network/consensus/randao) to propose a block. Once proposed and added to the canonical chain, the validators chosen for that slot's committees attest to the validity of the block, which shall eventually reach finality. The consensus layer supports Ethereum's network security and integrity. PBS interacts with this layer by dividing/isolating the duties of proposing and building blocks, thereby streamlining the transaction validation process.

### The Role of the builder

**Block builders** gather, validate, and assemble transactions into a block body. They review the mempool, validate the transactions by ensuring that they meet requirements like gas limits and nonce, and create a data structure containing the transaction data. Block builders are also responsible for ordering the transactions to optimize block space and gas usage. They then make the block body available to block proposers.

### The Role of the proposer

**Block proposers** take the block bodies provided by the block builders and create a complete block by adding necessary metadata, such as the block header. The header includes details such as the parent block's hash, timestamp, and other data. They also ensure the validity of the blocks by checking the correctness of the block body provided by the builders.

### Undermined Censorship Resistance

Another issue builder centralization might bring is putting at risk Ethereum's censorship resistance and integrity, as these dominant builders could, in theory, collude or be coerced into manipulating transaction flows or excluding specific transactions from being included in blocks, undermining the open and permissionless nature of the Ethereum network.

### Relay Concerns

A case can be made that relays oppose the following Ethereum's core tenets:

- Decentralization: The fact that [six relays](https://www.relayscan.io/overview?t=7d) handle 99% of MEV-Boost blocks (that being nigh on 90% of Ethereum's blocks) gives rise to justified centralization concerns.
- Censorship resistance: Relays _can_ censor blocks and, being centralized, can be coerced by regulators to do so. This happened, for instance, when they were pressured to censor transactions interacting with addresses on the [OFAC sanction list](https://home.treasury.gov/news/press-releases/jy0916).
- Trustlessness: Validators trust relays to provide a valid block header and to publish the full block once signed; builders trust relays not to steal MEV. Although betrayal of either would be detectable, dishonesty can be profitable even through a one-time attack.

### Third party dependency

On a similar note, the fact that PBS entails outsourcing the building of the blocks to entities that do not directly participate in Ethereum consensus could potentially lead to unexpected or unwanted consequences stemming from relying on third parties, such as trust issues, operational dependency and the introduction of single points of failure. Particularly the fact that the use of MEV-Boost is so widespread could be viewed as a dangerous third party dependency, since such a huge portion of Ethereum's new blocks are created using Flashbot's software.

### Security Concerns

As seen in this entry, PBS involves many different entities taking part in the process of adding new blocks to the chain, which inevitably increases the number of potential attack vectors that could be exploited.

As opposed to vanilla block creation in which the validator builds the block and adds it to the chain, PBS brings to the table many possible points of failure, such as the relays or escrows, which could potentially act maliciously or fail in their mission to provide data availability, disrupting the block proposal process, favoring certain builders, etc. Also, the commit-reveal scheme in escrows, if exploited, could give rise to MEV opportunities being stolen from the rightful block builders, undermining their performance.

Of course, validators are still in charge of verifying the data in the blocks to make sure that builders adhere to the rigorous standards that make the Ethereum protocol robust. Thus, the aforementioned concerns are not likely to cause critical issues like the network halting. Nonetheless, the potential for these possible vulnerabilities to impact the fairness and security of block production suggests that they should not be overlooked and further research should be done to have them prevented.

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

According to the article, ePBS, particularly through Two-Block HeadLock (TBHL) and optimistic relaying, presents a pathway towards addressing current challenges and enhancing the efficiency, security, and decentralization of block production and MEV extraction processes. For a more detailed explanation on ePBS check out the [EPF wiki entry](/wiki/research/PBS/ePBS.md) on the topic.

### Protocol-Enforced Propose Commitments (PEPC)

PEPC is another proposed solution for the shortcomings of PBS and MEV-Boost which advocates for a more open-ended and flexible design than traditional PBS. As explained on this [Mirror post](https://mirror.xyz/ohotties.eth/lBEXiiU7yK91OuSn8QyJPM9Db8GuyDFzCEUAj60BWyI), PEPC aims to provide a generalized infrastructure for proposers to make credible commitments to any outsourced block-building task, which could potentially better accommodate the evolving needs of the Ethereum network, especially with the anticipated expansion of data sharding and rollup adoption.

The goal is to allow proposers to register arbitrary commitments, expressed via EVM execution, that external parties can rely on. This way, anyone can provide services to proposers as long as they satisfy the registered commitments, fostering permissionless innovation. Also, unlike externals solutions such as MEV-Boost, PEPC would integrate commitment satisfaction into the core protocol, blocks being considered valid only if they fulfill the proposer's registered commitments, enhancing security and trustworthiness.

Regarding the need for a flexible approach to proposer duties PEPC aims to provide, it is worth noting that a wide range of outsourcing smart contracts is supported, from full block construction to specific valid transaction inclusions and validity proofs for rollup blocks.

All of this would also be complementary to existing out-of-protocol mechanisms like Eigenlayer, enhancing the credibility of proposer commitments by moving from an optimistic model to a pessimistic enforcement model where violating commitments inherently invalidates blocks.

### EIP-7547: Inclusion Lists

As explained in this [ethereum-magicians.org post](https://ethereum-magicians.org/t/eip-7547-inclusion-lists/17474), inclusion lists aim to provide a mechanism to improve the censorship resistance of Ethereum by allowing proposers to specify a set of transactions that must be promptly included for subsequent blocks to be considered valid.

This way proposers retain some authority over block building without sacrificing MEV rewards, through a mechanism by which transactions can be forcibly included. The simplest approach would be for the proposer to specify a list of transactions they found themselves in the mempool that must be included by the block builder if they want their block to be proposed for the next slot. Although some issues stem from this, such as incentive incompatibilities and exposure of free-data availability, solutions like forward and multiple inclusion lists have been proposed and are being developed to address these challenges, demonstrating the Ethereum community's commitment to refining and advancing the protocol to uphold its core values of decentralization, fairness, and censorship resistance.

## Resources

## Current State and Solutions

See the [Next Section](/wiki/research/PBS/current-state.md).

Proposer-builder separation may also reduce the likelihood of frontrunning and other harmful practices, even though it may not eliminate MEV-related issues entirely. -->

### Further Reading and Resources

https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710
https://notes.ethereum.org/@vbuterin/pbs_censorship_resistance
https://ethresear.ch/t/proposer-block-builder-separation-friendly-fee-market-designs/9725
https://ethresear.ch/t/two-slot-proposer-builder-separation/10980
[Payload timliness committee design for ePBS](https://ethresear.ch/t/payload-timeliness-committee-ptc-an-epbs-design/16054)
https://notes.ethereum.org/@fradamt/forward-inclusion-lists
https://notes.ethereum.org/@fradamt/H1TsYRfJc#Secondary-auctions
=======

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
  > > > > > > > 35bf31ff30cce94b1d2576a848c5cc123130744d
