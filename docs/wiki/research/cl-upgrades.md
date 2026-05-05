# Beacon Chain upgrades

> [!WARNING]
> This document covers active areas of Ethereum protocol research and may be outdated at time of reading. Draft EIPs and research proposals described here should not be treated as finalized mainnet behavior unless explicitly noted.

This page summarizes proposed and recent consensus-layer upgrade areas that are relevant for protocol contributors. It is intended as a roadmap hub for the consensus-layer upgrade surface, not as a replacement for the more detailed pages on PBS, MEV-Boost, ePBS, or preconfirmations.

For deeper background, see [PBS](/wiki/research/PBS/pbs.md), [MEV-Boost](/wiki/research/PBS/mev-boost.md), [ePBS](/wiki/research/PBS/ePBS.md), [ePBS design specs](/wiki/research/PBS/ePBS-Specs.md), [Preconfirmations](/wiki/research/Preconfirmations/Preconfirmations.md), and the [Pectra FAQ](/wiki/pectra-faq.md).

## Proposer-Builder Separation

Proposer-builder separation (PBS) separates execution block construction from beacon block proposal: builders construct execution payloads, while proposers choose a payload to include in the beacon block. In today's out-of-protocol PBS design, validators commonly use MEV-Boost to outsource block construction to builders through relays. This lets specialized builders compete to construct high-value execution payloads while validators continue to perform consensus duties.

PBS is important to consensus-layer upgrade design because block production affects validator timing, censorship resistance, fork-choice safety, and validator operational complexity. Separating proposers and builders can reduce the need for every validator to run sophisticated block-building infrastructure, but it also introduces additional trust and centralization concerns around builders and relays.

## Enshrined PBS

Enshrined PBS (ePBS) is a proposed direction for moving parts of proposer-builder separation into the Ethereum protocol itself. EIP-7732 is a draft proposal that introduces consensus-layer mechanisms for separating consensus block proposal from execution payload construction and for decoupling execution validation from consensus validation in time.

The motivation for ePBS is to reduce reliance on trusted relays and make the proposer-builder interaction more protocol-native. It also aims to improve timing constraints on validators: proposers should be able to make consensus-layer progress without having to fully validate a large execution payload before proposing their beacon block.

Open questions include:

- how builder bids and payload availability should be represented in the consensus layer
- how to preserve validator decentralization while supporting specialized builders
- how to reduce relay trust without creating new centralization points
- how ePBS should interact with censorship-resistance mechanisms such as inclusion lists

## Inclusion Lists

Inclusion lists are a family of proposals that let validators require certain transactions to be included in blocks. They are motivated by censorship resistance: if a block builder or proposer excludes valid transactions, other validators may be able to force those transactions into future blocks through protocol rules.

EIP-7547 proposed an inclusion list mechanism, but that EIP is currently marked as Stagnant. More recent work has explored committee-based designs where a set of validators contributes to the inclusion list rather than relying on a single proposer.

Design challenges include:

- limiting inclusion list size to avoid denial-of-service risks
- handling transactions that are valid for one validator but unavailable to another
- dealing with transactions that become invalid before inclusion
- accounting for different mempool views across the validator set
- defining how inclusion-list enforcement interacts with fork choice

## FOCIL

Fork-choice enforced Inclusion Lists (FOCIL), described in draft EIP-7805, is a committee-based inclusion-list proposal. Instead of depending on a single validator to create the list, FOCIL uses an inclusion-list committee. Committee members can observe pending transactions and contribute lists that the fork-choice rule can enforce.

At a high level, FOCIL aims to make censorship more difficult: valid transactions seen by committee members become harder to ignore under the fork-choice enforcement rules, subject to the proposal's validity, gas, timing, and availability constraints. This is especially relevant in a PBS or ePBS world, where execution payload construction may be concentrated among specialized builders.

FOCIL is still draft research and should not be treated as activated protocol behavior. Its main value for protocol contributors is that it connects censorship resistance, validator committees, fork choice, and block production into one design area.

## Preconfirmations

Preconfirmations are an active research direction for improving user experience by giving users earlier confidence that their transactions will be included. They are often discussed alongside proposer commitments, based sequencing, and PBS-style block production.

From the consensus-layer perspective, preconfirmations raise questions about:

- who is allowed to make credible commitments before a block is finalized
- what happens if a preconfirmation is not honored
- how commitments interact with proposer duties and builder markets
- whether preconfirmation systems can remain decentralized and censorship-resistant

## Raise MAX_EFFECTIVE_BALANCE

EIP-7251 increased the maximum effective balance of validators as part of the Electra consensus-layer changes in Pectra.

Ethereum historically capped validator effective balance at 32 ETH while retaining 32 ETH as the minimum activation balance. This design created a large number of validator entries when stake was distributed across many 32 ETH validators. Increasing the maximum effective balance allows larger effective balances per validator and enables validator consolidation.

Potential benefits include:

- fewer validator indices for the same amount of stake
- reduced validator set growth pressure
- lower consensus-layer networking load
- easier operations for large stakers
- support for compounding validator rewards

This change is also relevant to the consensus layer because validator set size affects attestation aggregation, committee sizes, networking, and client performance.

## Staking pool solutions

Liquid staking and staking-pool designs are related to validator set size and validator decentralization. If a large amount of stake is controlled by a small number of operators, Ethereum may gain operational efficiency but lose decentralization. If stake is split across a very large number of validator indices, the consensus layer must handle more attestations, aggregation work, and networking overhead.

Protocol contributors should evaluate staking-pool proposals by considering:

- whether they improve solo-staker or small-operator participation
- whether they increase or reduce operator centralization
- how they affect validator consolidation after EIP-7251
- whether they introduce new governance, slashing, or liquidity risks

## References

- [Proposer-builder separation - ethereum.org](https://ethereum.org/roadmap/pbs/)
- [EIP-7251: Increase the MAX_EFFECTIVE_BALANCE](https://eips.ethereum.org/EIPS/eip-7251)
- [EIP-7732: Enshrined Proposer-Builder Separation](https://eips.ethereum.org/EIPS/eip-7732)
- [EIP-7547: Inclusion lists](https://eips.ethereum.org/EIPS/eip-7547)
- [EIP-7805: Fork-choice enforced Inclusion Lists](https://eips.ethereum.org/EIPS/eip-7805)
- [FOCIL research thread](https://ethresear.ch/t/fork-choice-enforced-inclusion-lists-focil-a-simple-committee-based-inclusion-list-proposal/19870)
- [Why enshrine proposer-builder separation?](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710)
- [Minimal viable enshrinement of liquid staking](https://gist.github.com/gorondan/671062f279542bcaca80f0faec53c0a4)
- [Ethereum Research](https://ethresear.ch/)
