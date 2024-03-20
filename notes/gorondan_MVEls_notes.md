# MINIMUM VIABLE ENSHRINEMENT OF LIQUID STAKING (MVE-LS)

## What is MVE-LS?
MVE-LS is the minimum set of measures that could be implemented at protocol level in a short period of time (preferably in parallel with other congruent upgrades being developed and evaluated for inclusion in Pectra hard fork). 
It is the quasi-equivalent of Level 1/3 as per the [Rainbow Staking POC](https://ethresear.ch/t/unbundling-staking-towards-rainbow-staking/18683/8) - Enshrined Operator-Delegator separation:

```
[...]enshrining some separation between operator and delegator[...] might be ok with some level of complexity. We could call a basic operator/delegator separation Level 1 [...]
```
[[1]](#resources)

## Feasibility 
* Necessity 
    - There are risks in relying too much on the social layer and morality to protect the protocol against centralization in the staking scene and countering the emergence of a dominant LST with its afferent perils
    -  We need an interface to integrate further “protocol services” in a plug-and-play manner
    - Limitations of current staking-design to ensure future competitive participation of solo stakers in different categories of protocol services (i.e. economic value and/or agency)
    - Ethereum needs good trade-offs to SSF
* Opportunity 
    - enshrining a variant of the already established staking model with two classes of participants: delegators (stakers) and node operators
    - enshrining some measure of operator–delegator separation concomitant with other EIPs that are debated and developed right now, could leverage a lot of the work currently done towards specifying these EIPs:
        - EIP-6110 [[5]](#resources) allows for an in-protocol mechanism of deposit processing on the Consensus Layer. Also it will add in-protocol mechanism by which large node operators can combine validators without cycling through the exit and activation queues.
        - EIP-7251 [[4]](#resources) will allow a single message to carry more stake; enshrining the operator delegator separation would provide a way for the protocol to functionally distinguish “operator stake” from “delegator stake” on such a message.

## Feature set

| **FEATURE** | **title** | **description** | 
| :----------: | :-----------: | :-----------: |
|Feature 1|enshrine Quick Staking Key (Q key)|Allow validators to provide two staking keys: the persistent key (P key) and the quick staking key (Q key) - a smart contract that, when called, outputs a secondary staking key during each slot

```
The protocol would give powers to these two keys, but the mechanism for choosing the second key in each slot could be left to staking pool protocols.
```
[[2]](#resources)
## Implementation POC
MVE-LS POC can be done on top of EIP-6110 specification for future validator deposits and of EIP-7251 for backward compatibility (hard fork) 

## Resources
[[1] Unbundling staking](https://ethresear.ch/t/unbundling-staking-towards-rainbow-staking/18683)

[[2] Protocol and staking pool changes that could improve decentralization and reduce consensus overhead](https://notes.ethereum.org/@vbuterin/staking_2023_10)

[[3] Should Ethereum be okay with enshrining more things in the protocol?](https://vitalik.eth.limo/general/2023/09/30/enshrinement.html#what-do-we-learn-from-all-this)

[[4] EIP-7215](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-7251.md)

[[5] EIP- 6110](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-6110.md)

