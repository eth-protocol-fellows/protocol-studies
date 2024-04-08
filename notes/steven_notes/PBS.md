# Proposer-builder separation(PBS)

## Introduction
Brief overview of PBS, emphasizing its importance for Ethereum's scalability and decentralization.


## Why PBS?
### Foundation for Danksharding
 PBS plays a crucial role in the Danksharding proposal, which aims to scale Ethereum's throughput to over 100,000 transactions per second. Achieving such a level of efficiency in block building necessitates more sophisticated hardware, potentially sidelining solo stakers due to increased costs. PBS addresses this by enabling a specialized, centralized block building process that handles high transaction volumes, while simultaneously allowing block proposers to operate with less hardware. This division of labor not only optimizes transaction processing but also lowers the entry barrier for validators, supporting a more decentralized and inclusive network.

 The idea "**centralized block builder and highly decentralized block proposer**" is mentioned by Vitalik: [Endgame](https://vitalik.eth.limo/general/2021/12/06/endgame.html).


### Enhancing Anti-Censorship Measures
- By separating the duties of block builders and proposers, PBS makes it significantly more challenging for builders to censor transactions, thus promoting a freer and more open transaction inclusion process.
- It also protects against external pressures from powerful organizations that may seek to influence transaction selection, as block proposers do not possess knowledge of the transaction contents within the blocks they broadcast. This ignorance ensures a higher degree of impartiality and resistance to censorship

### Economic Realignment of MEV
 PBS aims to democratize the benefits of Maximal Extractable Value (MEV) by dismantling the disproportionate advantages held by institutional operators over individual stakers. By updating the economic incentives associated with MEV, PBS seeks to level the playing field, ensuring that the rewards of network participation are more equitably distributed among all contributors, regardless of their scale.

## PBS Implementation Approaches
There are two main implementations of PBS: [MEV-Boost](https://github.com/flashbots/mev-boost/) and Enshrined PBS (ePBS).

The key difference between MEV-Boost and ePBS lies in their approach and integration level within the Ethereum ecosystem. MEV-Boost operates as an external service that validators can opt into, providing a bridge between validators and a competitive marketplace of block builders. It's a practical solution that can be implemented without altering Ethereum's core protocol.

On the other hand, ePBS represents a more integrated approach, aiming to incorporate the proposer-builder separation directly into Ethereum's protocol. This would require consensus and implementation at the Ethereum protocol level, offering a more unified and potentially more secure framework for managing the roles of block construction and proposal.

### MEV-Boost
Here's a diagram illustrate how MEV-Boost works as an sidecar software with Ethereum from [MEV-boost github repo](https://github.com/flashbots/mev-boost/), where more detailed information can be found.

![mev-boost architecture](https://raw.githubusercontent.com/flashbots/mev-boost/54567443e718b09f8034d677723476b679782fb7/docs/mev-boost-integration-overview.png)

### ePBS
There are [many proposed implementations](https://github.com/michaelneuder/mev-bibliography#specific-proposals) of ePBS, nevertheless there had not been a final conclusion or universally accepted design for ePBS within the Ethereum community. The process of developing such a foundational change involves careful consideration of numerous factors to ensure that the benefits of proposer-builder separation are realized without introducing new vulnerabilities or inefficiencies

[Why enshrine Proposer-Builder Separation](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710) present the arguments for and against ePBS, layout design goals of an ePBS mechanism, illustrate several ePBS designs such as Two-Block HeadLock and Optimistic Relaying.


## Progress
The evolution of Ethereum Proposer-Builder Separation (ePBS) has seen the development of two distinct methodologies towards its full realization:
1. Top-Down Approach: This standard procedure starts with community discussions, leading to a consensus and specification development, followed by client team implementations. It's a structured approach ensuring coordinated progress towards ePBS.

2. Bottom-Up Approach via MEV-Boost: Given MEV-Boost's adoption in about 90% of Ethereum blocks (source), this method suggests incremental ePBS integration by evolving MEV-Boost's relay infrastructure. It allows for a gradual shift towards ePBS without immediate, widespread changes to consensus software.

## Further Reading
[Further Reading](https://ethereum.org/en/roadmap/pbs/#further-reading)
