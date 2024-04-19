# Ethereum Protocol Roadmap
---
## The Infinite Garden

*Ethereum is NOT a zero sum game, but rather a game that we want to play continuously. For that to be a reality, the Infinite Garden needs to upgrade regularly, on topics like its security, scalability or sustainability, until it will reach ossification. After that point there will probably be, just some trims - here and there.*

## Ethereum evolution 

The philosophy of Ethereum is open to certain risk aversion and the protocol design keeps evolving. As our knowledge and experience of Ethereum grows, researchers and developers are crafting ideas how to tackle challenges and limitations of the network. There has been [many changes](/wiki/protocol/history.md) to the core protocol over many years of its existence. Most of these changes are part of some common goals we could call a roadmap. 

Even though there is no official roadmap and no authority which could dictate it, there are wide community discussions steering the protocol development in certain ways. By agreeing on some goals and reaching consensus about current state of the development, the community, dev and research teams work together to progress in this abstract roadmap. 

## Core R&D

The discussion, resources and all research and development on the core protocol is fully open, free and public. Anyone can learn about it (as you are probably doing in this wiki) and further more, anyone can participate. There is no set of individuals which could push core protocol changes, the Ethereum community can raise the voice to help steer the discussion. To learn more about the core R&D shaping the protocol, read the [wiki page about it](/wiki/dev/core-development.md).

## Roadmap overview 

While there is not a single roadmap that Ethereum development follows, we can track the current R&D efforts to map what changes are happening and might happen in the future. 
A great overview mapping many domains of the core development is Vitalik's view on how the roadmap looks like at December 2023:

![Ethereum roadmap updated by V.B. Dec2023](/docs/images/roadmap_2024/full_roadmap2024_1286x1282.png)

In this overview, different domains are coupled to related categories forming various 'urges'. Here is what those mean: 

### the Merge

Upgrades relating to the switch from proof-of-work to proof-of-stake. The Merge was successfully achieved at Thu Sep 15 06:42:42 2022 UTC, reducing the network's annualized electricity consumption by more than 99.988%. However, this category also tracks subsequent upgrades which can be done to improve the consensus mechanism and smooth issues we encounter after The Merge. 

**IMPLEMENTED**
| Upgrade                              |                                             Description                                              |                                                                                         Effect                                                                                          |                                                  State of the art                                                   |
| :----------------------------------- | :--------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: |
| Launch the Beacon Chain              |              A crucial step in Ethereum's shift to a proof of stake consensus mechanism              | Beacon Chain becomes the engine of block production, replacing mining. Validators have the role and responsibility for processing the validity of all transactions and proposing blocks | shipped [EIP-2982](https://github.com/ethereum/EIPs/blob/acc6d08e2122b2a9700c570c48d89feb0b613832/EIPS/eip-2982.md) |
| Merge Execution and Consensus Layers |              Ethereum's execution layer merged with the Beacon chain (consensus layer)               |                                             Proof of work activities ceased and the network's consensus mechanism shifted to proof of stake                                             |                                                       shipped                                                       |
| Enable Withdrawals                   | The last of the three part process of Ethereum's transition to a proof of stake consensus mechanism. |                                        Validators can push withdrawals from the Beacon chain to the EVM via a new "system-level" operation type                                         |                             shipped [EIP-4895](https://eips.ethereum.org/EIPS/eip-4895)                             |

**TODO** 
| Upgrade                              |                                          Description                                           |                              Expected effect                               |                                                               State of the art                                                                |
| :----------------------------------- | :--------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------: |
| Single slot finality (SSF)           |                    Blocks could get proposed and finalized in the same slot                    |         More convenient for apps and much more difficult to attack         |                                                                  in research                                                                  |
| Single Secret Leader Election (SSLE) | Allow elected block proposers to remain private until block publishing, to prevent DoS attacks | Only the selected validator knows it has been selected to propose a block. | in research [EIP-7441 -upgrade BPE to Whisk](https://github.com/ethereum/EIPs/blob/af04410a1c577bd57fab1f0763789d0081a8e847/EIPS/eip-7441.md) |

### the Surge
Upgrades related to scalability by Roll-ups and Data Availability (DA). 

**IMPLEMENTED**
| Upgrade            |                                                                            Description                                                                             |      Expected effect      |                     State of the art                      |
| :----------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------: | :-------------------------------------------------------: |
| Proto-danksharding | We can stop storing Rollup data permanently on Ethereum and move the data into a temporary 'blob' storage that gets deleted from Ethereum once is no longer needed | Reduced transaction costs | ready [EIP-4844](https://eips.ethereum.org/EIPS/eip-4844) |

**TODO** 
| Upgrade                          |                                                                Description                                                                 |                                                                                                                                                                    Expected effect                                                                                                                                                                    | State of the art |
| :------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :--------------: |
| Danksharding                     |                       Danksharding is the full realization of the rollup scaling that began with Proto-Danksharding                        |                                                                                                                              Massive amounts of space on Ethereum for rollups to dump their compressed transaction data                                                                                                                               |   in research    |
| Data Availability Sampling (DAS) | Data Availability Sampling is a way for the network to check that data is available without putting too much strain on any individual node | (i) ensure rollup operators make their transaction data available after EIP-4844 (ii) ensure block producers are making all their data available to secure light clients (iii) under proposer-builder separation, only the block builder would be required to process an entire block, other validators would verify using data availability sampling |   in research    |


### the Scourge
Upgrades related to censorship resistance, decentralization and mitigating protocol risks from MEV. 

**TODO** 
| Upgrade                |                                                                 Description                                                                  |                                                Expected effect                                                 |                                                    State of the art                                                     |
| :--------------------- | :------------------------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------: |
| Enable more Validators | The technical challenge of efficiently coordinating an ever increasing number of validators to achieve SSF with the best trade-offs possible | Greater redundancy, a broader range of proposers, a wider array of attesters, and overall increased resilience | in research [EIP-7514](https://github.com/ethereum/EIPs/blob/af04410a1c577bd57fab1f0763789d0081a8e847/EIPS/eip-7514.md) |

**the Verge** 
Upgrades related to verifying blocks more easily

**the Purge** 
Upgrades related to reducing the computational costs of running nodes and simplifying the protocol

**the Splurge** 
Other upgrades that don't fit well into the previous categories.

## Resources:

[Ethresearch](https://ethresear.ch/)

[Ethereum-Magicians](https://ethereum-magicians.org/)

[ethereum/EIPs github repository](https://github.com/ethereum/EIPs/tree/master#ethereum-improvement-proposals-eips)

[Roadmap on Ethereum.org](https://ethereum.org/en/roadmap/)

[ethroadmap.com](https://ethroadmap.com/)

[Serenity Phase 0](https://github.com/ethereum/EIPs/blob/acc6d08e2122b2a9700c570c48d89feb0b613832/EIPS/eip-2982.md)