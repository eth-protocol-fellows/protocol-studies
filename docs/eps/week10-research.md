# Study Group Lecture 15 | The Ethereum fork-choice

Last talk of the original study group covers a variety of topics related to the fork-choice of Ethereum, its evolution and its role in future upgrades.

Watch the presentation by [Francesco](https://twitter.com/fradamt) on [StreamEth](https://streameth.org/65cf97e702e803dbd57d823f/epf_study_group) or [Youtube](https://www.youtube.com/watch?v=x-_2gAVFlw8). Presentation is [available here](https://github.com/eth-protocol-fellows/protocol-studies/blob/main/docs/eps/presentations/week10-research.pdf).

<iframe width="560" height="315" src="https://www.youtube.com/embed/x-_2gAVFlw8?si=xqMDpqrBabgiDYPb" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Pre-reading

Before starting with the Day 15 content, make yourself familiar with resources in previous weeks, especially day 2 on CL and day 5 on roadmap. You should have understanding of Beacon Chain and current consensus research topics.

Additionally, you can get ready by studying the following resources.

- All in one resource: [PoS evolution](https://github.com/ethereum/pos-evolution/blob/master/pos-evolution.md)
- Gasper: [Combining GHOST and Casper (Gasper paper)](https://arxiv.org/abs/2003.03052)
- Problems with Gasper:
  - [Three attacks on PoS Ethereum](https://eprint.iacr.org/2021/1413)
  - [View-merge](https://ethresear.ch/t/view-merge-as-a-replacement-for-proposer-boost/13739)
- Improving Gasper with Single Slot Finality:
  - [Path towards Single Slot Finality](https://notes.ethereum.org/@vbuterin/single_slot_finality)
  - [A simple single slot finality](https://ethresear.ch/t/a-simple-single-slot-finality-protocol/14920)

## Outline

- Gasper recap
- Problems with Gasper and fixes
- Single Slot Finality (SSF)
- How fork-choice affects other Ethereum upgrades: PeerDAS and ePBS case studies

## Additional reading and exercises

- [Notes on SSF, Lincoln Murr](https://publish.obsidian.md/single-slot-finality/Welcome+to+My+Research!)
- [Increase the MAX_EFFECTIVE_BALANCE – a modest proposal](https://ethresear.ch/t/increase-the-max-effective-balance-a-modest-proposal/15801)
- [Reorg resilience and security in post-SSF LMD-GHOST](https://ethresear.ch/t/reorg-resilience-and-security-in-post-ssf-lmd-ghost/14164/3)
