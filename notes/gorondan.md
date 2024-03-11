# Goron Dan Notes

## Objectives

The purpose to joining this program is to get a deeper understanding of the infrastructure that makes everything possible in the application layer, and the directions further, while expanding my protocol knowledge. Also, I have a high interest in understanding how the current work carried on protocol level will impact the application layer in the short to medium term.
Reading the material in the previous EPF programs, I realise that after finalizing EPS and moving into EPF, we will have to become much more technical/practical. To my understanding, that means identifying areas of interest where we can bring our own additions and setting a clear project goal, leading to working on an actual project, with well defined deliverables expectation (improvement/applied research/analyzing tool).

## Areas of Interest

* staking design - I feel that this topic transcends on-going and future protocol development and it will have a palpalbe impact on the application layer in the short to medium term. Also long term, but that is most likely to be subjected to the [time factor](../docs/wiki/research/roadmap.md#roadmap-overview).

## Potential project
My goal is to partake in a project that would propose minimal viable enshrinement of liquid staking. 

The fundamentals were set by Vitalik in this document[ [1]](#resources) and there's one Ethresearch proposal here[ [2]](#resources).

An example could be: "Author an EIP and corresponding POC implementation for *Enshrined Operator-Delegator separation*, or *Increasing trustless liquid staking viability"*.

### Possible proposed work:
* add in-protocol validator **quick staking key** (Q key) alongside the currently required **persistent staking key** (P key)
* adapt protocol to take into account the P+Q public validator key format (possible directions):
    - adapt slashing design and/or
    - adapt [inclusion lists](../docs/wiki/research/inclusion-lists.md) design

### Challenges
* the project should not affect validator economics, but propose simple protocol tweaks that would work towards minimal viable enshrinement of liquid staking.
* enshrining has it's limitations [[3]](#resources)
* questions to be asked and answered durring project:
    - would the implementation of the project's proposed spec changes actually improve the staking scene? 
    - large numbers of delegators part of big staking pools could create annomalies in the network(late block production, missed attestations). A tool for testing that is part of a prior EPF work in cohort three [[4]](#resources).
    - how would the proposed changes interact with other ongoing developments like increasing the MAX_EFFECTIVE_BALLANCE(EIP-7215)[ [5]](#resources), [light-clients](../docs/wiki/research/light-clients.md), SSF, etc? would it have an overall positive impact and mix well with current/prevised protocol improovements?

### Possible expected effects
* short-medium term: 
    - improve protocol and staking pools decentraliation
    - allow staking delegators to participate in consensus in a meaningfull way; 
* medium-long term: 
    - paving the way to de-risking staked ETH
    - paving the way for SSF

I'm looking forward to hearing from interested fellow students and willing mentors, in order to explore the best project track 🤝

## Resources
[[1] Protocol and staking pool changes that could improve decentralization and reduce consensus overhead](https://notes.ethereum.org/@vbuterin/staking_2023_10)

[[2] Unbundling staking](https://ethresear.ch/t/unbundling-staking-towards-rainbow-staking/18683)

[[3] Should Ethereum be okay with enshrining more things in the protocol?](https://vitalik.eth.limo/general/2023/09/30/enshrinement.html#what-do-we-learn-from-all-this)

[[4] On-chain analysis of staking pools attestations](https://github.com/eth-protocol-fellows/cohort-three/blob/master/projects/On-chain-analysis-of-staking-pools.md)

[[5] EIP-7215 current research](../docs/wiki/research/roadmap.md#current-research)