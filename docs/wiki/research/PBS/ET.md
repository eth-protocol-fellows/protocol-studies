# Execution Tickets (ET)
> [!WARNING]
> This document covers an active area of research, may be outdated at time of reading and subjected to future updates, as the design space around ePBS, ET and Inclusion lists (IL) evolves.

## Roadmap tracker

| Upgrade |    URGE     |   Track   |               Topic               |                                                          Cross-references                                                          |
| :-----: | :---------: | :-------: | :-------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------: |
|   ET    | the Scourge | MEV track | Endgame block production pipeline | intersection with: [IL](/docs/wiki/research/inclusion-lists.md), [ePBS](/docs/wiki/research/PBS/ePBS.md), [PEPC](/docs/wiki/research/PBS/PEPC.md) |



## Relevant context
Recent proposals and development towards enshrining Proposer-Builder Separation ([PBS](/docs/wiki/research/PBS/pbs.md)) seek to diminish execution block construction reliance on a few centralized, off-chain entities (relays), that in the context of current MEV, act as intermediaries between Validators as payload proposers and specialized, more sophisticated block builders. Today, with [MEV-boost](/docs/wiki/research/PBS/mev-boost.md), validators-as-proposers forfeit their rights to build execution payloads, in an open-bids permissionless auction, Builders offering Proposers a well-sequenced payload against payment.

![MEV-boost](/docs/wiki/research/img/MEV-boost.webp)

## Attester-Proposer Separation (APS) a.k.a. Validator-Proposer Separation

MEV-boost is an out-of-protocol side-car, outside of the protocol's reach and control. This limitation is addressed within the context of PBS, by the [APS](#attester-proposer-separation-aps-aka-validator-proposer-separation-design-rationale) (Attester-Proposer Separation) design philosophy with the aim of getting some of this infrastructure back into the the protocol's fold. 

APS design rationale is closely related to **ePBS - enshrined Proposer-Builder Separation** design space.

According to the EPS wiki page on ePBS [[1]](#resources) and Barnabé's notes on PBS [[2]](#resources), we can identify two main components of ePBS:
1. the market structure - the parties engaged in the market and their engaging conditions. 
2. the allocation mechanism - the space of contracts the engaged parties may enter into.
   
ePBS as proposed today, enshrines both a specific market structure and an allocation mechanism mostly inherited from MEV-Boost:

Validators-as-proposers auction their payload production rights to builders. 
This would be an improvement compared to current MEV-boost, as this would unbundle the Validator role between proposer and builder, level the playing field for builders and there would be a trustless, protocol defined market structure to ensure a *fair exchange* between market parties. 

However, this setup would still need the complex mechanics of the fair exchange within MEV-boost, except that the complexity is being moved in-protocol. 
Barnabé argues [[3]](#resources) that ePBS in its current proposed version does not answer some fundamental questions:
- is it the market structure *or* the allocation mechanism that we consider too centralized under MEV-boost?
- if the answer is the former, is it worth to enshrine the same mechanism that we consider both a technical debt (a bug) and a flawed design philosophy, that only exists now outside of protocol?
 - wouldn't it be better **for the protocol** to not be split between two worlds and just be concerned about allocating *proposing rights* and not worrying about allocating *building rights*?

![](/docs/wiki/research/img/ET_2worlds.webp)

**Allocation mechanisms for APS market structure**:

A permissionless market allowing buyers to purchase the right to propose execution payloads. 
These rights confer the ticket holder (that can be a different party than the Validator) with a random allocation, to propose an execution payload.

![](/docs/wiki/research/img/ETvsPBS.webp)

**block-auction ePBS vs slot-auction ePBS**

![](/docs/wiki/research/img/ba-ePBS.webp)
![](/docs/wiki/research/img/sa-ePBS.webp)

The improvement sa-ePBS brings, comes however with the technical cost of dealing with equivocations and head split views, and that [is not a trivial problem to solve](#open-issues).

[ET](#execution-tickets-et-1) and [APS-Burn](/docs/wiki/research/APS/aps.md) are two of the possible allocation mechanisms for implementing in-protocol Attester-Proposer Separation. The Beacon proposers can commit to execution proposers only, so there would be no commitments to the contents of the execution payload, which solves the timing games issues that the block-auction ePBS version faces.

## Execution Tickets (ET)

Execution tickets are orthogonal to ePBS, in the sense that a new paradigm is being proposed: 
a validator/attester–proposer separation, where the proposer is recruited by the protocol and could once again delegate the role of construction to another entity, the builder.
The delivery of the beacon block, however, would remain the validator's prerogative.

ETs allow execution proposers to purchase “tickets” from a enshrined permissionless market, redeeming execution proposing rights at some indeterminate time into the future.

Execution proposers buy the rights to propose payloads from the ET Market, an abstract module at the moment of writing, [still in research and development](#open-issues). 

### How do ET contain Timing games?

Timing games occur when a proposer delays as much as possible the proposing of their block in order to maximize the value it could get for it. In block-auction ePBS, as the execution payloads are determined at the release of the beacon block, the timing games will be played by validators that could attempt to delay the delivery of the beacon block for as much time as possible, in order to commit to the highest bid possible.

ETs proposes, an even further consensus-execution separation to ePBS, with no commitments from validator-as-proposer to the execution payload, thus containing timing games to execution proposing phase, so that the consensus-critical functions are not subject to validators having the incentives to act rationally:

![](/docs/wiki/research/img/ET.webp)

## ET high-level view
The execution ticket mechanism can be succinctly described as [[4]](#resources) :

* An in-protocol market for buying and selling tickets.
Tickets entitle the owner to future block proposal rights. Tickets would be one-time use and only valid in a randomly assigned slot.

* A lottery for selecting the beacon block proposer and attesters. This is the existing Proof-of-Stake lottery, where validators are randomly selected to propose beacon blocks. Under execution tickets, the beacon block will no longer contain the execution payload (the final list of executed transactions for a block), but instead has an inclusion list that specifies a set of transactions that must be present in the execution block.

* A lottery for selecting the execution block proposer and attesters: a second lottery to determine the winning ticket. The ticket owner has permission to propose the execution block for the slot and include the transactions  onchain. The state is then updated. The execution block proposer posts a collateral per ticket they own as an assurance that they will produce a single execution block during the execution round of the slot that their ticket is assigned. If they equivocate or are offline, the bond will be slashed retroactively. 

## ET flow:
Execution tickets flow for one slot is [[4]](#resources):

1. During the beacon round, the randomly selected beacon proposer has the right to propose a beacon block.
2. This proposer proposes the beacon block that contains the inclusion list.
3. The beacon attesters vote on the validity and timeliness of the beacon block.
4. During the execution round, a randomly selected execution ticket has the right to propose an execution block.
5. The owner of the ticket is the execution proposer and proposes an execution block.
6. The execution attesters vote for on the timeliness and validity of the execution block.

![](/docs/wiki/research/img/ETflow.jpeg)

## Counterarguments to the APS market structure that ET embodies
- C1. From a censorship-resistance point of view, we may want to keep validators active in the construction of execution payloads. 

  - counter to counterargument C1:

    CC1. Validators forego this ability entirely today when they use MEV-Boost, and could very well forego it entirely  when they would use ePBS. Improvement proposals as Inclusion lists [[6]](#resources) and Multiplicity gadgets [[7]](#resources) could remedy this by imposing on whomever owns the execution ticket with binding but non-efficiency-decreasing constraints on payload construction.

- C2. ET would no longer guarantee that Validators get the option to build execution payloads as they seem fair. 

  - counter to counterargument C2:

    CC2. The definition of fairness could be very different between Validators, and the market has revealed in practice the preference of most validators to not exercise this building right themselves, delegating the construction to other parties. 

- C3. Separating Validator and Proposer roles creates a market structure where the ticket holder could become an *active monopolist*, imposing [monopoly pricing](https://arxiv.org/abs/2311.12731) and possibly front-running time sensitive flow. The above is in contrast with the status quo under MEV-Boost featuring the Validator as a *passive monopolist* [[5]](#resources) in the proposer role.

  - counter to counterargument C3:

    CC3. In their work *When to Sell Your Blocks* [[5]](#resources), Quintus and Conor note that if validators tend towards rationality in the long run, the difference between validators-as-proposers and ticket-holders-as-proposers may tend to diminish a lot, meaning that the improvement of Validator-Proposer role separation could come from the benefits the separation itself can bring to ET and subsequently for the protocol, and that such a separation of roles would most likely not create a worst situation than the status quo.

## Open issues

Execution Tickets are in active research, some of the known open issues are:

* What would be the exact design of the ET market and the mechanics behind the ticket pricing mechanism?

* What are the fork-choice implications of execution ticketing?
    * there might be multiple valid entries in fork-choice within the same slot
    * payload equivocation causes a head split view

* How do execution tickets alter the designs of preconfirmations

* How do we construct the “second” staking mechanism for execution ticket holders

## Resources

[[1] Wiki page on ePBS](/docs/wiki/research/PBS/ePBS.md)

[[2] Barnabé's notes on PBS](https://barnabe.substack.com/p/pbs)

[[3] reconsidering the market structure of PBS by Barnabé](https://mirror.xyz/barnabe.eth/LJUb_TpANS0VWi3TOwGx_fgomBvqPaQ39anVj3mnCOg#heading-the-pains-of-being-proposer-as-validator)

[[4] ethresearch post on Execution tickets](https://ethresear.ch/t/execution-tickets/17944)

[[5] When to Sell Your Blocks flashbots post](https://collective.flashbots.net/t/when-to-sell-your-blocks/2814)

[[6] EIP-7547 Inclusion lists](https://eips.ethereum.org/EIPS/eip-7547)

[[7] ROP-9: Multiplicity gadgets](https://efdn.notion.site/ROP-9-Multiplicity-gadgets-for-censorship-resistance-7def9d354f8a4ed5a0722f4eb04ca73b)

[[8] PEPC FAQ](https://efdn.notion.site/PEPC-FAQ-0787ba2f77e14efba771ff2d903d67e4#a2d2d17abe90414e88d667ad10d91afe)

[[9] Potuz's ePBS specification notes](https://hackmd.io/@potuz/rJ9GCnT1C)