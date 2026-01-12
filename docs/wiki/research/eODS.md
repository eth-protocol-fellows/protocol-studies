# Enshrined Operator-delegator separation (eODS)

> [!WARNING]
> This document covers an active area of research, may be outdated at time of reading and subject to future updates, as the design space around Validator roles unbundling evolves.

## Roadmap tracker

| Upgrade |    URGE     |       Track       |                          Item                           |                                                                Cross-references                                                                 |
|:-------:|:-----------:|:-----------------:|:-------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------:|
|  eODS   | the Scourge | Staking economics | Censorship resistances, liquid staking decentralization | [SSF](/docs/wiki/research/SSF.md), [IL](/docs/wiki/research/cl-upgrades.md), [ePBS](/docs/wiki/research/PBS/ePBS.md), [ET](/docs/wiki/research/PBS/ET.md) |

## Relevant context 

Principal–Agent problem of liquid staking, in which the interests of the Agent are not aligned with the interests of the Principal, is part of any capital delegation, and even more so present in today's staking ecosystem[^1].

Since the early days of Beacon Chain, market structures enabling to provide liquidity for staking pools without running an actual validator software have emerged in Ethereum.
Thus, staking has split naturally in two classes of participants, outside protocol level[^2]:

|    Tier    |                                                        Current natural separation                                                        | Slashing risk |
|:----------:|:----------------------------------------------------------------------------------------------------------------------------------------:|:-------------:|
| Delegators |   ETH stakers with no minimum commitment and no strict requirement to participate in any other way beyond bringing in their principal    |   Slashable   |
| Operators  | Node operators, home staking or providing validator services, with their reputation or some fixed amount of capital of their own at risk |   Slashable   |

The two tiers are closely interlinked, as liquid staking protocols are not credible if their liquid staking token (LST) holders do not believe that the operators holding their principal are *good agents*. 

The risk of slashing, coupled with the high amount of revenue paid out in aggregate to Gasper service providers via issuance, results in intermediate chains of **principal-agent relationships**[^3]. Delegators provide capital (Principal) to operators who participate in Gasper on their behalf, in order to earn staking rewards for the Principal and themselves. 
However, if the validator misbehaves, the funds of the delegator are also slashed, as the actions of the validator (the Agent) affect the capital of the delegator (the Principal).

In order to be considered good agents, honest operators must commit to the Principal's interests:
- perform validation duties properly (i.e. run and maintain good staking infrastructure, be diligent so that its online reputation is upheld by showing high participation rate, and running the prescribed protocol, hence never equivocate by signing conflicting blocks) 
- agents must not be adversarial (malicious), deviating from the protocol arbitrarily, e.g. equivocating and getting slashed in the attempt to obtain under-evaluated stake for the purpose of attacking the network.

## What is eODS?

eODS is an actively discussed design space[^4] within Ethereum, proposing an even further separation of the role of **Validator** (unbundling), to be implemented at protocol level, closing the loop in the Staking economics track of the Scourge, between ePBS and Execution tickets.

### Unbundling the Validator role

| Upgrade | Separation type    |
| ------- | ------------------ |
| ePBS    | proposer-builder   |
| ET      | validator-proposer |
| eODS    | operator-delegator |

This separation addresses various inefficiencies associated with the limits of what the protocol sees[^5], and its capacity to react with automated defense systems, in the context of ETH staking.

## The two-tier staking approach to SSF

In the [SSF](/docs/wiki/research/SSF.md) research discourse, technical limitations associated with per slot BLS signatures aggregation generates the following paradigm:
> We need to move away from the concept that every participant signs in every slot - Vitalik Buterin

In the above context, there's value in the proposal to **split staking** in two tiers of participants:[^23]
  * **A high-complexity tier** called in to act every slot but has only ~ 10,000 participants, providing **Heavy node services**, and
  * **A lower-complexity tier** only called up to participate occasionally, providing **Small(light) node services** with low computational overhead, hardware or technical know-how requirements.

The providers of heavy node services would be subject to slashing, but also highly rewarded for participating in the protocol's Finality gadget, while the providers of small node services would be entitled to lower rewards, but could be entirely exempt from slashing (do not actively participate in each slot), or could opt in to temporarily (i.e. for a few slots) become subject to slashing.

## The role of Delegators

In his October 2023 paper, called "Protocol and staking pool changes that could improve decentralization and reduce consensus overhead", Vitalik poses a key question: **from the protocol’s perspective, what is the point of having delegators at all?**[^6]

Vitalik takes a thought experiment, hypothesizing a world where bounding the maximum slashing penalty to 2 ETH is a reality.[^7].

Two scenarios are run and compared under the above premises:
1. because the slashing and leaking penalties are capped, Rocket Pool reduces operator bond accordingly, to 2 ETH,  all ETH is staked and Rocket Pool as a LSP (liquid staking protocol) absorbs 100% of the market  share (not just among stakers, but also among ETH holders. As rETH becomes risk-free, almost all ETH holders become rETH holders or node operators).
2. in the second scenario, Rocket Pool does not exist as an LSP. Minimum deposit amount is reduced to 2 ETH, and total staked ETH is capped at 6.25M. Also, the node operator’s return is decreased to 1%.

The two scenarios were run from both a staking economics perspective, and a cost-of-attack perspective.
After performing the calculations, the final outcome in both cases was exactly the same, so, theoretically, the protocol would be better off cutting out the middleman, and drastically reduce staking rewards and cap total ETH staked to 6.25M.

The scope of the argument above was not to advocate for reducing staking rewards, nor for capping total staked ETH, but to point out a key property that a well-functioning staking system should have: 
 
>**Delegators should be doing something that actually matters** - *Vitalik Buterin*

### Delegators role under eODS

If Delegators were to have a **meaningful role**, what would that be, and how can the protocol **incentivize** that role selection?

Two possible solutions[^8] arise, under Operator-Delegator separation:
1. **The curation of operator set**: Opinionated delegators may decide to choose between different operators based on e.g., fees or reliability.
2. **The provision of light services**: The delegators may be called upon to provide non-slashable, yet critical services, like:
   - input their view into censorship-resistance gadgets such as inclusion lists or multiplicity gadgets.
   - sign off on their view of the current head of the chain, as alternative signal to that of the bonded Gasper operators. 

**Incentivizing the Delegator role**: 

Delegators under this model do not contribute to the economic security of FFG, i.e. Delegators do not partake in Finality (non-slashable stake), but they are able to surface discrepancies in the gadget’s functioning. Their services can be compensated by re-allocated aggregated issuance.

## The layers of Operator-Delegator Separation
eODS taken in isolation, enshrines the separation, but brings no improvement to the existing market structure:
| 1D-eODS   |           |
| --------- | --------- |
| OPERATOR  | DELEGATOR |
| slashable | slashable |

In order for eODS to be relevant, it must be considered holistically, together with other relevant, proposed, protocol changes:

* Capping penalties:
    | 1D-eODS + capping penalties |               |
    | --------------------------- | ------------- |
    | OPERATOR                    | DELEGATOR     |
    | slashable                   | non-slashable |

    In this model, by capping the slashing and leaking penalties to only the operator’s stake, assets of delegators are no longer at risk. However, Barnabé argues[^4] that the role of Delegator is not very clear under 1D-eODS, because of the following reasons:
    * Delegators in the two-tiered staking model are unlike delegators of current LSPs, who bear the slashing risk.
    * Some agents would wish to delegate their assets to “two-tier operators” and subject themselves to the slashing conditions, in search for yield.
    * Some agents would wish to not operate small node services themselves, yet participate in their provision by delegating operations instead.

    More, in the context of MVI, implementing penalties slashing in the way presented above, would be economically equivalent to reducing staking yield to 1% and just making staking an explicitly altruistic activity.[^9]

* The above issues can be resolved by the **Introduction of two distinct types of protocol services**, based on the [Two-tier staking approach](#the-two-tier-staking-approach-to-ssf):
    * ***Heavy Services***
    * ***Light Services***
  
    This *design philosophy* produces a separation of the role of Validator in 2 dimensions (2D Operator-Delegator Separation), each dimension inducing within itself a market structure of delegators and operators:

    | 2D-eODS (rainbow staking) |                 |               |
    | ------------------------- | --------------- | ------------- |
    | Light OPERATOR            | Light DELEGATOR | non-slashable |
    | Heavy OPERATOR            | Heavy DELEGATOR | slashable     |

     ### Economics of light services 
    Light services use stake as *sybil-control* mechanism and as *weight functions*.[^10]

    The protocol will offer an ecosystem of light services such as censorship resistance gadgets, which are provided using weak hardware and economic requirements. 
    Censorship-resistant, in protocol gadgets reward participants that help the protocol "see" censored inputs via some mechanism like inclusion lists. 
    
    These light services are compensated by re-allocating aggregate issuance towards their provision, a pattern already in use today for sync committees.[^11]

    Light holders (Delegators) can delegate their assets to light service operators, performing the service on behalf of the delegator for a fee, which aligns the incentives of the operator to maximize the reward for the delegator. In a competitive marketplace of light operators, along with re-delegation allowing for instant withdrawal from a badly performing operator, light operators would be expected to provide the service for marginal profitability and with cost efficiency.
    
    **Partially slashable light services**

    Some light services may require slashable stake. A variant of the penalties capping approach could be enforced, with only the operator stake is slashable. 

    | 2D-eODS (rainbow staking) | +   penalties capping         |
    | ------------------------- | ----------------------------- |
    | Light OPERATOR  slashable | Light DELEGATOR non-slashable |  |
    | Heavy OPERATOR slashable  | Heavy DELEGATOR  slashable    |

   ### Economics of heavy services
    Heavy services use stake as *economic security*[^12]
    
    Should their stake participate in an FFG safety fault (conflicting finalized checkpoints), all of their stake will be lost.

    The requirements of heavy services such as FFG, Ethereum’s Finality gadget, will be strengthened to achieve Single-Slot Finality (SSF). 
    
    Possible enshrined protocol gadgets that will help foster a safe staking environment:
    * liquid staking module (LSM)-style primitives to build liquid staking protocols on top of
    * enshrined partial pools or DVT networks
    
    All allowing for fast re-delegation among other features.

    ### Mechanism design (Heavy vs. Light)
    |                               | Heavy services                                                               | Light services                                                             |
    | ----------------------------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
    | Service archetype             | Gasper                                                                       | Censorship-resistance gadgets                                              |
    | Reward dynamics               | Correlation yields rewards usually, anti-correlation is good during faults   | Anti-correlation yields rewards (surface different signals)                |
    | Slashing risk                 | Operators and delegators                                                     | None or operators only                                                     |
    | Role of operators             | Run full node to provide Gasper validation services                          | Run small node to provide light services                                   |
    | Role of delegates             | Contribute economic security to Gasper                                       | Lend weight to light operators with good service quality                   |
    | Operator capital requirements | High capital efficiency (high stake-per-operator) + high capital investments | Not really a constraint (operators receive weight) + small node fixed cost |
    | Solo staker access            | Primarily as part of LSPs (e.g., as DVT nodes)                               | High access for all light services                                         |

## Unlocking re-staking? 

eODS (the 2D model) can be considered a partial enshrinement of re-staking, thanks to re-stakers being able to commit to this new class of protocol AVS (actively validated service)[^13] for which rewards are issued from the creation of newly-minted ETH(i.e. Gasper is an protocol AVS with a well known issuance schedule)[^14]. 
    
ETH holders are then allowed to enter into the provision of these AVS, either directly as operators, or indirectly as delegators.

## Where do Solo Stakers fit in this new world?
Gasper (and a variant of it in SSF scenario) is the heaviest AVS of the Ethereum protocol. It receives the highest share of aggregate issuance, so there are many parties interested in providing the required stake, in an delegated staking scheme[^3], with Delegators providing stake to Operators who participate in Gasper on their behalf.

Given the induced intermediation of stake, it is necessary to prevent the emergence of a single dominant liquid staking provider collateralized by the majority of the ETH supply. Minimum Viable Issuance (MVI)[^15] measures are critical in order to target sufficient security for the protocol, by creating sufficient pressure to keep the economic weight of Gasper in the right proportion. 

Due to the fact that solo stakers are unable to issue credible liquid staking tokens from their collateral and have thus low capital efficiency, MVI-imposed competitive pressures is not well-suited for them. In the context of eODS, this disadvantage can be greatly improved.

### The role of solo stakers, under eODS
In his "Unbundling staking: Towards rainbow staking" research post[^16], Barnabé offers two core value propositions which solo stakers embody ideally:

* **Bolster network resilience**: Solo stakers bolster the resilience of the network to failures of larger operators, e.g. by progressing the (dynamically available) chain while large operators go offline. It would not be their main line of operators due to capital and cost-efficiency limitations, but it could be a strong fallback in the worst case scenario.
  
* **Generators of preference entropy**: Solo stakers may contribute as censorship-resistance agents, allowing the protocol to see more and serve a wider spectrum of users. Performing such a light service is at hand for a wide class of low-powered participants. Multiplicity gadgets could reward the contributions of operators who increase preference entropy[^16]. 

Preference entropy denotes information surfaced by protocol agents to the protocol.Agents who censor have lower preference entropy, as they decide to restrict the expression of certain preferences, such as activities which may contravene their own jurisdictional preferences. 
The set of solo stakers who operate nodes to provide services is highly decentralized, and is thus able to express high preference entropy. This economic value translates into revenue for members of the set.

## Why separate?

### Social layer leverage
There are risks in relying too much on the social layer and morality to protect the protocol against centralization in the staking scene and countering the emergence of a dominant LST with its associated perils

### Already an established model
eODS would mean enshrining a variant of the already established staking model with two classes of participants: delegators (stakers) and node operators

### Enabling stronger forms of consensus participation for Delegators.
In order to improve delegate selection powers[^17], we can:

* improve voting tools within pools
  
  Under the current paradigm, voting within staking pools is limited to governance token-holders (not ETH holders). There are attempts of Optimistic governance, where ETH holders can veto LSP governance votes, but (paraphrasing Vitalik) token voting is not strong enough, and ultimately any form of unincentivized delegate selection is just a type of token voting.

* improve competition between pools
  
  The challenges of smaller liquid staking protocols that have small market capitalization are that they are less liquid, harder to trust, and less supported by applications. Capping penalties and 1D-eODS could theoretically help with these challenges, but the actual implementation of the bounding of penalties is not feasible, for the [reasons expressed above](#the-layers-of-operator-delegator-separation).

* enshrine delegation
  
  eODS offers stronger forms of consensus participation for Delegators, either 
  - as capital providers to Operators who participate in chain Finality on their behalf (heavy services, slashable), or
  - as participants in censorship resistance gadgets like Inclusion lists or Multiplicity gadgets (light services, not slashable), or
  - sign off as alternative signal to Finality participants (light services, not slashable).
  
### Reduce the number of BLS signatures (SSF scenario)
Ethereum is constantly improving and growing on its way to becoming the envisioned global-scale network.

In this scenario, single-slot finality is not only desirable but most likely mandatory, and good trade-offs are needed on the path towards SSF.

In the above context, we can assume a limit between $100k - 1.8 million$ BLS signatures that could be processed every slot. 
eODS proposes a smaller number of Validators, as heavy services providers ($<10,000$), reducing the number of BLS signatures that need to be processed every slot, even assuming single slot finality. 

### Synergies with active R&D space

**Execution tickets**

eODS fits well in a world where the role of the Validator [is disambiguated](#unbundling-the-validator-role). The essence of Execution Tickets[^18] is to separate execution from consensus, and that helps achieving MVI[^15] for Heavy Operators. If execution services are separated from consensus services under ET (or a similar attester-proposer separation), heavy operators would be less concerned with reward variability and playing Timing games[^19] when finalizing the output of the execution service (the payload)

**Inclusion lists & Multiplicity gadgets**

Light services act as a constraint to payload services, by including them in censorship-resistant gadgets such as IL or MG.

Inclusion lists[^20] prepared by honest validators function as censorship signals and defense against systematic censorship from identifiable validators. Attesters uphold the validity and the satisfaction of an inclusion list, via the fork choice.

Multiplicity gadgets[^21] are related to IL, but propose a mechanism of assigning the responsibility of constructing an inclusion set to a committee instead of a single leader (like IL), thus avoiding the reliance on the honesty or rationality of a single party. Obtaining consensus over the set of items to include could also increase accountability and allow for incentive schemes.

While the exact constraining mechanism of Light services (e,g, IL) over execution payload producers needs to be further researched and developed, separating *producers* from *enforcers* under eODS would bring an improvement to today's IL design, where Validators act as both producers and enforcers.

Separating services, the Light operators become producers of the list, but the validity of the execution payload with respect to Gasper is enforced by Heavy operators, who attest and finalize the valid history of the chain, ignoring invalid payloads. 

**MAX_EFFECTIVE_BALANCE**

EIP-7251[^22] will allow a single message to carry more stake. Enshrining the operator delegator separation would provide a way for the protocol to functionally distinguish “operator stake” from “delegator stake” on such a message, further separation of each tier in heavy services providers and light services providers.

### Future protocol services
eODS provides an interface to integrate further “protocol services” in a plug-and-play manner.

## The road ahead
From a high level view, the two dimensions of eODS could be implemented as follows:
-   the Vertical dimension of the separation, being the Light - Heavy services separation can be done in practice, by increasing MAX_EFFECTIVE_BALANCE[^22] and later implementing a balance threshold of e.g. 2048 ETH to determine which  validators enter which complexity tier.
-   the Horizontal dimension of the separation, being the Operator-Delegator separation can be done by the means presented in [this section](#the-layers-of-operator-delegator-separation).

Further R&D is required on the exact MVI to be targeted for each (heavy & light) type of protocol services, and the practical applications and implementation of eODS. 

Regarding the enshrinement of liquid staking, Vitalik states:
> It may still be better to enshrine some things outright, but it's valuable to note that this "enshrine some things, leave other things to users" design space exists.[^7]

## [References]

[^1]: https://eprint.iacr.org/2023/605

[^2]: https://notes.ethereum.org/@vbuterin/staking_2023_10#Protocol-and-staking-pool-changes-that-could-improve-decentralization-and-reduce-consensus-overhead

[^3]: https://mirror.xyz/barnabe.eth/v7W2CsSVYW6I_9bbHFDqvqShQ6gTX3weAtwkaVAzAL4

[^4]: https://ethresear.ch/t/unbundling-staking-towards-rainbow-staking/18683#operatordelegator-separation-2

[^5]: https://barnabe.substack.com/i/95811604/case-studies-in-upgrading-the-fence

[^6]: https://notes.ethereum.org/@vbuterin/staking_2023_10#The-role-of-delegators

[^7]: https://vitalik.eth.limo/general/2023/09/30/enshrinement.html#enshrining-liquid-staking

[^8]: https://notes.ethereum.org/@vbuterin/staking_2023_10#If-delegators-can-have-a-meaningful-role-what-might-that-role-be

[^9]: https://youtu.be/ZBvV88jEkiA?t=2561

[^10]: https://ethresear.ch/t/unbundling-staking-towards-rainbow-staking/18683#economics-of-light-services-5

[^11]: https://eth2book.info/capella/part2/incentives/rewards/#proposer-rewards-for-sync-committees

[^12]: https://ethresear.ch/t/unbundling-staking-towards-rainbow-staking/18683#economics-of-heavy-services-4

[^13]: https://docs.eigenlayer.xyz/eigenlayer/avs-guides/avs-developer-guide#what-is-an-avs

[^14]: https://eth2book.info/capella/part2/incentives/issuance/

[^15]: https://notes.ethereum.org/@anderselowsson/MinimumViableIssuance

[^16]: https://ethresear.ch/t/unbundling-staking-towards-rainbow-staking/18683#staking-economics-in-the-rainbow-world-6

[^17]: https://notes.ethereum.org/@vbuterin/staking_2023_10#Expanding-delegate-selection-powers

[^18]: https://ethresear.ch/t/execution-tickets/17944

[^19]: https://ethresear.ch/t/timing-games-implications-and-possible-mitigations/17612

[^20]: https://eips.ethereum.org/EIPS/eip-7547

[^21]: https://efdn.notion.site/ROP-9-Multiplicity-gadgets-for-censorship-resistance-7def9d354f8a4ed5a0722f4eb04ca73b

[^22]: https://eips.ethereum.org/EIPS/eip-7251

[^23]: https://ethresear.ch/t/sticking-to-8192-signatures-per-slot-post-ssf-how-and-why/17989#approach-2-two-tiered-staking-4
