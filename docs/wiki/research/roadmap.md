# Ethereum Protocol Roadmap
---
## The Infinite Garden

*Ethereum is NOT a zero sum game, but rather a game that we want to play continuously. For that to be a reality, the Infinite Garden needs to upgrade regulary, on topics like its security, scalability or sustainability, untill it will reach ossification. After that point there will probably be, just some trims - here and there.*

## Ethereum evolution 

The philosophy of Ethereum is opened to certain risk aversion and the protocol design keeps evolving. As our knowledge and experience of Ethereum grows, researchers and developers are crafting ideas how to tackle challenges and limitations of the network. There has been [many changes](/wiki/protocol/history.md) to the core protocol over many years of its existence. Most of these changes are part of some common goals we could call a roadmap. 

Even though there is no official roadmap and no authority which could dictate it, there are wide community dicsussions steering the protocol development in certain ways. By agreeing on some goals and reaching consensus about current of the development, the community, dev and research team work together to progress in this abstract roadmap. 

## Core R&D

The discussion, resources and all research and development on the core protocol is fully open, free and public. Anyone can learn about it (as you are probably doing in this wiki) and further more, anyone can participate. There is no set of individuals which could push core protocol changes, the Ethereum community can raise the voice to help steer the discussion. To learn more about the core R&D shaping the protocol, read the [wiki page about it](/wiki/dev/core-development.md).

## Roadmap overview 

While there is not a single roadmap that Ethereum development follows, we can track the current R&D efforts to map what changes are happening and might happen in the future. 
A great overview mapping many domains of the core development is Vitalik's view on how the roadmap looks like at December 2023:

![Ethereum roadmap updated by V.B. Dec2023](/docs/images/roadmap_2024/full_roadmap2024.jpeg)

In this overview, different domains are coupled to related categories forming various 'urges'. Here is what those mean: 

### The Merge

Upgrades relating to the switch from proof-of-work to proof-of-stake. The Merge was succesfully achieved at Thu Sep 15 06:42:42 2022 UTC but this category tracks subsequent upgrades which can be done to improve the consensus mechanism and smooth issues we encounter after The Merge. 

- SSLE
- SSF 
..TODO elaborate on each

### Surge

Upgrades related to scalability by rollups and data sharding. 

**the Scourge** - upgrades related to censorship resistance, decentralization and protocol risks from MEV. 

**the Verge** - upgrades related to verifying blocks more easily

**the Purge** - upgrades related to reducing the computational costs of running nodes and simplifying the protocol

**the Splurge** - other upgrades that don't fit well into the previous categories

## Current research

| Upgrade | Part of | Description | Expected effect | State of the art |
| :-----| :-----: | :----: | :-------: | :------- |
| Sigle slot finality (SSF)| the Merge | Blocks could get proposed and finalized in the same slot | More convenient for apps and much more difficult to attack| in research |
| Proto-danksharding | the Surge | We can move the data into a temporary 'blob' storage that gets deleted from Ethereum once is no longer needed. | Reduced transaction costs | [EIP-4844](https://eips.ethereum.org/EIPS/eip-4844) |

## Resources:

[Ethresearch](https://ethresear.ch/)

[Ethereum-Magicians](https://ethereum-magicians.org/)

[ethereum/EIPs github repository](https://github.com/ethereum/EIPs/tree/master#ethereum-improvement-proposals-eips)

[Roadmap on Ethereum.org](https://ethereum.org/en/roadmap/)

https://ethroadmap.com/
