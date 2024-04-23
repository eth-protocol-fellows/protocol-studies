# Ethereum Protocol Roadmap
---
## The Infinite Garden

*Ethereum is NOT a zero sum game, but rather a game that we want to play continuously. For that to be a reality, the Infinite Garden needs to upgrade regularly, on topics like its security, scalability or sustainability, until it reaches ossification. After that point there will probably be, just some trims - here and there.*

## Ethereum evolution 

The philosophy of Ethereum is open to certain risk aversion and the protocol design keeps evolving. As our knowledge and experience of Ethereum grows, researchers and developers are crafting ideas on how to tackle challenges and limitations of the network. There has been [many changes](/wiki/protocol/history.md) to the core protocol over many years of its existence. Most of these changes are part of some common goals we could call a roadmap. 

Even though there is no official roadmap and no authority which could dictate it, there are wide community discussions steering the protocol development in certain ways. By agreeing on some goals and reaching consensus about current state of the development, the community, dev and research teams work together to progress in this abstract roadmap. 

## Core R&D

The discussion, resources and all research and development on the core protocol is fully open, free and public. Anyone can learn about it (as you are probably doing in this wiki) and further more, anyone can participate. There is no set of individuals which could push core protocol changes, the Ethereum community can raise the voice to help steer the discussion. To learn more about the core R&D shaping the protocol, read the [wiki page about it](/wiki/dev/core-development.md).

## Roadmap overview 

While there is not a single roadmap that Ethereum development follows, we can track the current R&D efforts to map what changes are happening and might happen in the future. 
A great overview mapping many domains of the core development is Vitalik's view on how the roadmap looks like at December 2023 level:

![Ethereum roadmap updated by V.B. Dec2023](/docs/wiki/research/img/full_roadmap2024_1600x1596.webp)

In this overview, different domains are coupled to related categories forming various 'urges'. Here is what those mean: 

### the Merge

Upgrades relating to the switch from proof-of-work to proof-of-stake. The Merge was successfully achieved at Thu Sep 15 06:42:42 2022 UTC, reducing the network's annualized electricity consumption by more than 99.988%. However, this category also tracks subsequent upgrades which can be done to improve the consensus mechanism and smooth issues we encounter after The Merge. 

**IMPLEMENTED**
| Upgrade                              |                                             Description                                             |                                                                                         Effect                                                                                          | State of the art           |
| :----------------------------------- | :-------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :------------------------- |
| Launch the Beacon Chain              |             A crucial step in Ethereum's shift to a proof of stake consensus mechanism              | Beacon Chain becomes the engine of block production, replacing mining. Validators have the role and responsibility for processing the validity of all transactions and proposing blocks | shipped </br> EIP-2982[^1] |
| Merge Execution and Consensus Layers |              Ethereum's execution layer merged with the Beacon chain (consensus layer)              |                                             Proof of work activities ceased and the network's consensus mechanism shifted to proof of stake                                             | shipped                    |
| Enable Withdrawals                   | The last of the three-part process of Ethereum's transition to a proof of stake consensus mechanism |                                        Validators can push withdrawals from the Beacon chain to the EVM via a new "system-level" operation type                                         | shipped </br>EIP-4895[^2]  |

**TODO** 
| Upgrade                              |                                                                 Description                                                                  |                                                                                                                                          Expected effect                                                                                                                                          | State of the art                                                                                                  |
| :----------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------- |
| Single slot finality (SSF)           |                                           Blocks could be proposed and finalized in the same slot                                           | (i) more convenient for apps (transactions finalization time improved by an order of magnitude, i.e. 12 seconds instead of 12 minutes means better UX for all), (ii) much more difficult to attack (multi block MEV re-orgs can be eliminated and the complexity in consensus mechanism, reduced) | in research </br>(i) VB's SSF notes[^4] </br>(ii) 8192 signatures post-SSF[^5] </br>(iii) simple SSF protocol[^6] |
| Single Secret Leader Election (SSLE) |                        Allow elected block proposers to remain private until block publishing, to prevent DoS attacks                        |                                                                                                            Only the selected validator knows it has been selected to propose a block.                                                                                                             | in research </br>EIP-7441[^7]                                                                                     |
| Enable more Validators               | The technical challenge of efficiently coordinating an ever increasing number of validators to achieve SSF with the best trade-offs possible |                                                                                          Greater redundancy, a broader range of proposers, a wider array of attesters, and overall increased resilience                                                                                           | in research </br> (i) EIP-7514[^8] </br>(ii) EIP-7251[^9] </br> (iii) 8192 signatures[^5]                         |
| Quantum-safe signatures              |                               Proactive research and integration of quantum-resistant cryptographic algorithms                               |                                                                                               Quantum-safe, aggregation-friendly signatures will enhance protocol security against quantum attacks                                                                                                | in research </br> (i) lattice-based[^10] </br>(ii) STARK-based [^11] systems                                      |
### the Surge
Upgrades related to scalability by Roll-ups and Data Sharding. 

**IMPLEMENTED**
| Upgrade            |                                                                            Description                                                                             |      Expected effect      | State of the art           |
| :----------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------: | :------------------------- |
| Proto-danksharding | We can stop storing Rollup data permanently on Ethereum and move the data into a temporary 'blob' storage that gets deleted from Ethereum once is no longer needed | Reduced transaction costs | shipped </br>EIP-4844[^12] |

**TODO** 
| Upgrade                                         |                                                                Description                                                                 |                                                                                                                                                                                                                                                   Expected effect                                                                                                                                                                                                                                                    | State of the art                                                                                                               |
| :---------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------- |
| Danksharding                                    |                       Danksharding is the full realization of the rollup scaling that began with Proto-Danksharding                        |                                                                                                                                                                                                              Massive amounts of space on Ethereum for rollups to dump their compressed transaction data                                                                                                                                                                                                              | in research </br>                                                                                                              |
| Data Availability Sampling (DAS)                | Data Availability Sampling is a way for the network to check that data is available without putting too much strain on any individual node |                                                                                (i) ensure rollup operators make their transaction data available after EIP-4844 (ii) ensure block producers are making all their data available to secure light clients (iii) under proposer-builder separation, only the block builder would be required to process an entire block, other validators would verify using data availability sampling                                                                                 | in research </br> EIP-7594[^13]                                                                                                |
| Removing Rollup Training Wheels                 |                        (i) Optimistic Rollup Fault Provers </br> (ii) ZK-EVMs  </br> (iii) Rollup interoperability                         | (i) Optimistic rollups having live proof systems will address the L2's censorship risk </br>(ii)  Massive improvements to Ethereum's scalability and privacy without sacrificing the security and decentralization aspects of the chain via zkEVMs (EVM-compatible virtual machines that supports zero-knowledge proof computation) </br > (iii) L1 Sequencers, or Ethereum L1 proposers with given rollup sequencing rights will bring better credible-neutrality and security, and offer roll-ups L1 compatibility | in research </br> (i)Arbitrum BoLD[^14] </br> Optimism Cannon[^15] </br> (ii) ZK-EVMs [^16] [^17] [^18] </br> (iii)[^19] [^20] |
| Quantum-safe and Trusted-Setup-Free Commitments |                      replace KZG commitments with commitments that don't require a trusted setup and are quantum safe                      |                                                                                                                                                                                                                                               Quantum-safe Commitments                                                                                                                                                                                                                                               | in research </br>                                                                                                              |


### the Scourge
Upgrades related to censorship resistance, decentralization and mitigating protocol risks from MEV. 

### the Verge
Upgrades related to verifying blocks more easily

### the Purge
Upgrades related to reducing the computational costs of running nodes and simplifying the protocol

### the Splurge
Other upgrades that don't fit well into the previous categories.

## Resources:

[^1]: EIP-2982: Serenity Phase 0 https://eips.ethereum.org/EIPS/eip-2982, [[archived]](https://web.archive.org/web/20230928204358/https://eips.ethereum.org/EIPS/eip-2982)

[^2]: EIP-4895: Beacon chain push withdrawals https://eips.ethereum.org/EIPS/eip-4895, [[archived]](https://web.archive.org/web/20240415201815/https://eips.ethereum.org/EIPS/eip-4895)


[^4]: VB's SSF notes https://notes.ethereum.org/@vbuterin/single_slot_finality, [[archived]](https://web.archive.org/web/20240330010706/https://notes.ethereum.org/@vbuterin/single_slot_finality)

[^5]: Sticking to 8192 signatures per slot post-SSF https://ethresear.ch/t/sticking-to-8192-signatures-per-slot-post-ssf-how-and-why/17989. [[archived]](https://web.archive.org/web/20240105131126/https://ethresear.ch/t/sticking-to-8192-signatures-per-slot-post-ssf-how-and-why/17989)

[^6]: A simple Single Slot Finality protocol https://ethresear.ch/t/a-simple-single-slot-finality-protocol/14920, [[archived]](https://web.archive.org/web/20231214080806/https://ethresear.ch/t/a-simple-single-slot-finality-protocol/14920)

[^7]: EIP-7441: Upgrade BPE to Whisk https://eips.ethereum.org/EIPS/eip-7441, [[archived]](https://web.archive.org/web/20231001031437/https://eips.ethereum.org/EIPS/eip-7441)

[^8]: EIP-7514: Add Max Epoch Churn Limit https://eips.ethereum.org/EIPS/eip-7514, [[archived]](https://web.archive.org/web/20240309191714/https://eips.ethereum.org/EIPS/eip-7514)

[^9]: EIP-7251:Increase the MAX_EFFECTIVE_BALANCE https://eips.ethereum.org/EIPS/eip-7251, [[archived]](https://web.archive.org/web/20240324072459/https://eips.ethereum.org/EIPS/eip-7251)

[^10]: Medium post on lattice encryption https://medium.com/asecuritysite-when-bob-met-alice/so-what-is-lattice-encryption-326ac66e3175, [[archived]](https://web.archive.org/web/20230623222155/https://medium.com/asecuritysite-when-bob-met-alice/so-what-is-lattice-encryption-326ac66e3175)

[^11] VB's hackmd post on STARK signature aggregation https://hackmd.io/@vbuterin/stark_aggregation, [[archived]](https://web.archive.org/web/20240313124147/https://hackmd.io/@vbuterin/stark_aggregation)

[^12]: EIP-4844: Shard Blob Transactions https://eips.ethereum.org/EIPS/eip-4844, [[archived]](https://web.archive.org/web/20240326205709/https://eips.ethereum.org/EIPS/eip-4844)

[^13]: EIP-7594: PeerDAS https://github.com/ethereum/EIPs/pull/8105 

[^14]: BoLd: dispute resolution protocol https://github.com/OffchainLabs/bold/blob/e00b1c86124c3ca8c70a2cc50d9296e7a8e818ce/docs/research-specs/BOLDChallengeProtocol.pdf

[^15]: Fault proofs bring permissionless validation to the OP Sepolia testnet https://blog.oplabs.co/open-source-and-feature-complete-fault-proofs-bring-permissionless-validation-to-the-op-sepolia-testnet/

[^16]: Parallel Zero-knowledge Virtual Machine https://eprint.iacr.org/2024/387, [[archived]](https://web.archive.org/web/20240415180222/https://eprint.iacr.org/2024/387)

[^17]: What is zkEVM https://www.alchemy.com/overviews/zkevm, [[archived]](https://web.archive.org/web/20240129204732/https://www.alchemy.com/overviews/zkevm)

[^18]: Types of ZK-EVMs https://vitalik.eth.limo/general/2022/08/04/zkevm.html, [[archived]](https://web.archive.org/web/20240329112600/https://vitalik.eth.limo/general/2022/08/04/zkevm.html)

[^19]: Based preconfirmations https://ethresear.ch/t/based-preconfirmations/17353, [[archived]](https://ethresear.ch/t/based-preconfirmations/17353)

[^20]: Execution Tickets research page https://ethresear.ch/t/execution-tickets/17944, [[archived]](https://web.archive.org/web/20240401205945/https://ethresear.ch/t/execution-tickets/17944)

[^21]: Inclusion lists https://eips.ethereum.org/EIPS/eip-7547, [[archived]](https://web.archive.org/web/20240309191147/https://eips.ethereum.org/EIPS/eip-7547)

[ethereum/EIPs github repository](https://github.com/ethereum/EIPs/tree/master#ethereum-improvement-proposals-eips)

[Roadmap on Ethereum.org](https://ethereum.org/en/roadmap/)

[ethroadmap.com](https://ethroadmap.com/)