# Execution Tickets - ET
This document is WIP and may be subjected to future updates, as the design space around ePBS, ET and Inclusion lists (IL) evolves.

## Roadmap tracker

|Upgrade|URGE|Track|Cross-references|
|:---:|:---:|:---:|:---:|
|**Execution Tickets** - aliases: **Validator-Proposer** separation; **Attester-Proposer** separation|the Scourge|MEV track|ePBS, IL, PEPC, SSF|

## Relevant context
Recent proposals and development towards enshrining Proposer-Builder Separation (PBS) seek to diminish execution block construction reliance on a few centralized, off-chain entities (relays), that in the context of current MEV, act as intermediaries between Validators as payload proposers and specialized, more sophisticated block builders. Today, with MEV-boost, validators-as-proposers forfeit their rights to build execution payloads, in an open-bids permissionless auction.

**PBS structure**

According to the EPFsg wiki page on ePBS [[1]](#resources) and Barnabe's notes on PBS [[2]](#resources), we can identify two main components of PBS:
1. the market structure - the parties engaged in the market and their engaging conditions. 
2. the allocation mechanism - the space of contracts the engaged parties may enter into.

## Validator-Proposer separation (Execution tickets) design rationale
**ePBS - enshrined Proposer-Builder Separation**, as proposed today, enshrines both a specific market structure and an allocation mechanism mostly inherited from MEV-Boost:

Validators-as-proposers auction their payload production rights to builders. 
This would be an improvement compared to current MEV-boost, as this would unbundle the Validator role between proposer and builder, level the playing field for builders and there would be a trustless, protocol defined market structure to ensure a *fair exchange* between market parties. 

However, this setup would still need the complex mechanics of the fair exchange within MEV-boost, except that the complexity is being moved in-protocol. 
Barnabe argues [[3]](#resources) that ePBS in its current proposed version does not answer some fundamental questions:
- is it the market structure *or* the allocation mechanism that we consider too centralized under MEV-boost?
- if the answer is the former, is it worth to enshrine the same mechanism that we consider both a technical debt (a bug) and a flawed design philosophy, that only exists now outside of protocol?
 - wouldn't it be better **for the protocol** to not be split between two worlds and just be concerned about allocating *proposing rights* and not worrying about allocating *building rights*?

![](/docs/wiki/research/img/ET_2worlds.webp)

This is the gist of execution tickets (ETs):

A permissionless market allowing buyers to purchase the right to propose execution payloads. 
These rights confer the ticket holder (that can be a different party than the Validator) with a random allocation, to propose an execution payload.

## Relationship to PBS/ePBS
Execution tickets are orthogonal to ePBS, in the sense that a new paradigm is being proposed: 
a validator–proposer separation, where the proposer is recruited by the protocol and could once again delegate the role of construction to another entity, the builder.
The delivery of the beacon block, however, would remain the validator's prerogative.

![](/docs/wiki/research/img/ETvsPBS.webp)

## ET high-level view
The execution ticket mechanism can be succinctly described as [[4]](#resources) :

* An in-protocol market for buying and selling tickets.
Tickets entitle the owner to future block proposal rights. Tickets would be one-time use and only valid in a randomly assigned slot.

* A lottery for selecting the beacon block proposer and attesters. This is the existing Proof-of-Stake lottery, where validators are randomly selected to propose beacon blocks. Under execution tickets, the beacon block will no longer contain the execution payload (the final list of executed transactions for a block), but instead has an inclusion list that specifies a set of transactions that must be present in the execution block.

* A lottery for selecting the execution block proposer and attesters: a second lottery to determine the winning ticket. The ticket owner has permission to propose the execution block for the slot and include the transactions  onchain. The state is then updated. The execution block proposer posts a collateral per ticket they own as an assurance that they will produce a single execution block during the execution round of the slot that their ticket is assigned. If they equivocate or are offline, the bond is slashed retroactively. 

## ET flow:
Execution tickets flow for one slot is [[4]](#resources):

1. During the beacon round, the randomly selected beacon proposer has the right to propose a beacon block.
2. This proposer proposes the beacon block that contains the inclusion list.
3. The beacon attesters vote on the validity and timeliness of the beacon block.
4. During the execution round, a randomly selected execution ticket has the right to propose an execution block.
5. The owner of the ticket is the execution proposer and proposes an execution block.
6. The execution attesters vote for on the timeliness and validity of the execution block.

![](/docs/wiki/research/img/ETflow.jpeg)

## In depth analysis of ET effects
WIP
* Validating & staking
* Roadmap compatibility
* Secondary market

## Counterarguments to ET
1. From a censorship-resistance point of view, we may want to keep validators active in the construction of execution payloads. 

2. ET would no longer guarantee that Validators get the option to build execution payloads as they seem fair. 

3. Separating Validator and Proposer roles creates a market structure where the ticket holder could become an *active monopolist*, imposing [monopoly pricing](https://arxiv.org/abs/2311.12731) and possibly front-running time sensitive flow. The above is in contrast with the status quo under MEV-Boost featuring the Validator as a *passive monopolist* [[5]](#resources) in the proposer role.

However, analyzing pro ET discourse, we can find pertinent answers to such counterarguments:

1. Validators forego this ability entirely today when they use MEV-Boost, and could very well forego it entirely  when they would use ePBS. Improvement proposals as Inclusion lists  [[6]](#resources) and Multiplicity gadgets [[7]](#resources) could remedy this by imposing on whomever owns the execution ticket with binding but non-efficiency-decreasing constraints on payload construction.

2. The definition of fairness could be very different between Validators, and the market has revealed in practice the preference of most validators to not exercise this building right themselves, delegating the construction to other parties. 

3. In their work *When to Sell Your Blocks* [[5]](#resources), Quintus and Conor note that if validators tend towards rationality in the long run, the difference between validators-as-proposers and ticket-holders-as-proposers may tend to diminish a lot, meaning that the improvement of Validator-Proposer role separation could come from the benefits the separation itself can bring to ET and subsequently for the protocol, and that such a separation of roles would most likely not create perverse incentives.

## Open issues
WIP

Execution Tickets are in active research, some of the known open issues are:

* What would be the exact mechanics of the ticket pricing mechanism?*

* What are the fork-choice implications of execution ticketing?
    * there might be multiple valid entries in fork-choice within the same slot
    * payload equivocation causes a head split view

* How do execution tickets alter the designs of preconfirmations

* How do we construct the “second” staking mechanism for execution ticket holders

## Resources

[[1] Wiki page on ePBS](/docs/wiki/research/PBS/ePBS.md)

[[2] Barnabe's notes on PBS](https://barnabe.substack.com/p/pbs)

[[3] reconsidering the market structure of PBS by Barnabe](https://mirror.xyz/barnabe.eth/LJUb_TpANS0VWi3TOwGx_fgomBvqPaQ39anVj3mnCOg#heading-the-pains-of-being-proposer-as-validator)

[[4] ethresearch post on Execution tickets](https://ethresear.ch/t/execution-tickets/17944)

[[5] When to Sell Your Blocks flashbots post](https://collective.flashbots.net/t/when-to-sell-your-blocks/2814)

[[6] EIP-7547 Inclusion lists](https://eips.ethereum.org/EIPS/eip-7547)

[[7] ROP-9: Multiplicity gadgets](https://efdn.notion.site/ROP-9-Multiplicity-gadgets-for-censorship-resistance-7def9d354f8a4ed5a0722f4eb04ca73b)
