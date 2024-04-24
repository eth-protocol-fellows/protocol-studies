# Single slot finality (SSF)

## Roadmap tracker

| Upgrade |   URGE    | Track |          Topic           |                                               Cross-references                                               |
| :-----: | :-------: | :---: | :----------------------: | :----------------------------------------------------------------------------------------------------------: |
|   SSF   | the Merge |   -   | Increase Validator count | intersection with: [MAX_EB](/docs/wiki/research/cl-upgrades.md), [ePBS](/docs/wiki/research/PBS/ePBS.md), ET |

## What is SSF?
[Single Slot Finality](/docs/eps/week10-research.md) is a concept within Ethereum, in the context of consensus mechanism, that addresses the inefficiencies associated with the time it takes to finalize blocks, proposing a significant raise in blocks validation efficiency and a drastic reduction of time-to-finality. 
Instead of waiting for 2 epochs, blocks could get proposed and finalized in the same slot.

## Context and Motivation
Ethereum finalizes every 2 epochs, or every 64 slots. With each slot being 12 seconds long, finalization takes around 12.8 minutes, at the moment of writing.
This current time to finality has turned out to be too long for most users, and is inconvenient for apps and exchanges that might not want to wait that long to be certain their transactions are permanent. 
The delay between a block's proposal and finalization also creates an opportunity for short reorgs that an attacker could use to censor certain blocks or extract MEV.

## Benefits of SSF
* more convenient for apps - transactions finalization time improved by an order of magnitude, i.e. 12 seconds instead of 12 minutes means better UX for all Ethereum users
* much more difficult to attack - multi block MEV re-orgs can be eliminated as it would only take 1 block for the chain to finalize instead of 64 blocks
* the future consensus mechanism (in SSF scenario) would have a reduced complexity compared to current LMD-GHOST & Casper-FFG combination, which can lead to attacks (balancing attacks, withholding and savings attacks)

## The fork-choice rule in SSF
Today's consensus mechanism relies on the coupling[^1] between Casper-FFG (the algorithm that determines whether 2/3 of validators have attested to a certain chain) and the fork choice rule (LMD-GHOST is the algorithm that decides which chain is the correct one when there are multiple options). 
The fork choice algorithm only considers blocks since the last finalized block. Under SSF there will not be any blocks for the fork choice rule to consider, because finality occurs in the same slot as the block is proposed. This means that under SSF **either** the fork choice algorithm **or** the finality gadget would be active at any time. 
The finality gadget will finalize blocks where $2/3$ of validators were online and attesting honestly. If a block is not able to exceed the $2/3$ threshold, the fork choice rule would kick in to determine which chain to follow. This also creates an opportunity to maintain the inactivity leak mechanism that recovers a chain where $>1/3$ validators go offline. If a block is not able to exceed the $2/3$ threshold, the fork choice rule would kick in to determine which chain to follow.

Some interaction issues between the fork choice and the consensus do remain in any such design, and it’s still important to work through them. 
Short-term improvements to the existing fork choice (eg. view-merge) may also feed into work on the SSF fork choice.[^2]

## What are the key questions we need to solve to implement single slot finality?
Vitalik starts out with three open questions[^4]: 

* What will be the exact consensus algorithm?

* What will be the aggregation strategy (for signatures)?

* What will be the design for validator economics?

## MAX_EB and Zipfian ETH distribution

## References

[^1]: Combining GHOST and Casper https://arxiv.org/pdf/2003.03052.pdf, [[archived]](https://arxiv.org/pdf/2003.03052.pdf)

[^2]: SSF page on Ethereum.org https://ethereum.org/en/roadmap/single-slot-finality/#role-of-the-fork-choice-rule, [[archived]](https://web.archive.org/web/20240309234119/https://ethereum.org/en/roadmap/single-slot-finality/#role-of-the-fork-choice-rule)

[^3]: EIP-7251: Increase the MAX_EFFECTIVE_BALANCE https://eips.ethereum.org/EIPS/eip-7251, [[archived]](https://web.archive.org/web/20240324072459/https://eips.ethereum.org/EIPS/eip-7251)

[^4]: VB's SSF notes https://notes.ethereum.org/@vbuterin/single_slot_finality, [[archived]](https://web.archive.org/web/20240330010706/https://notes.ethereum.org/@vbuterin/single_slot_finality)

[^5]: Sticking to 8192 signatures per slot post-SSF https://ethresear.ch/t/sticking-to-8192-signatures-per-slot-post-ssf-how-and-why/17989. [[archived]](https://web.archive.org/web/20240105131126/https://ethresear.ch/t/sticking-to-8192-signatures-per-slot-post-ssf-how-and-why/17989)

[^6]: A simple Single Slot Finality protocol https://ethresear.ch/t/a-simple-single-slot-finality-protocol/14920, [[archived]](https://web.archive.org/web/20231214080806/https://ethresear.ch/t/a-simple-single-slot-finality-protocol/14920)

[^7]: Notes on SSF Lincoln Murr https://publish.obsidian.md/single-slot-finality/Welcome+to+My+Research!,
[[archived]](https://web.archive.org/save/https://publish.obsidian.md/single-slot-finality/Welcome+to+My+Research!)