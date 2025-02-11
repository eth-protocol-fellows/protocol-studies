# Introduction to Ethereum PeerDAS

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.
> :warning: This document covers an active area of research. It may be outdated at the time of reading and is subject to future updates as the design space evolves.

**PeerDAS** (Peer-to-Peer Data Availability Sampling) is a networking protocol introduced in [EIP-7594](https://eips.ethereum.org/EIPS/eip-7594). It is designed to optimize data distribution and verification across Ethereum's network. PeerDAS ensures that data from Layer 2 (L2) solutions—such as rollups—remains reliably accessible without overwhelming nodes.

## PeerDAS in the Ethereum Roadmap

Scaling is essential for Ethereum. The network must increase its capacity to process transactions and store data, making transactions cheaper and more accessible to users. As demand for blockchain applications grows, Ethereum must support higher throughput without compromising decentralization or security.

PeerDAS is a critical component of [Danksharding](https://ethereum.org/en/roadmap/danksharding/) and plays a key role in Ethereum's rollup-centric roadmap. It is part of the [Surge](https://vitalik.eth.limo/general/2024/10/17/futures2.html) phase, which focuses on scaling transaction throughput and reducing costs.

Layer 2 (L2) solutions, such as rollups, rely on Ethereum for data availability and security. Initially, rollups posted their transaction data directly to Ethereum as calldata, a method that was both expensive and inefficient. [EIP-4844 (Proto-Danksharding)](https://eips.ethereum.org/EIPS/eip-4844) introduced **blobs**—a new data structure that allows rollups to post data at a significantly lower cost. While EIP-4844 was an important improvement, it is only a stepping stone toward Danksharding. In Danksharding, blobs will be transformed into **data columns** and distributed across the network using PeerDAS. This transformation will further reduce costs and improve scalability.

Ethereum researchers have outlined a gradual, multi-stage roadmap for PeerDAS that balances increased throughput with network robustness:

- **Stage 0 (EIP-4844):** Introduces subnets for blob distribution without Data Availability Sampling (DAS), requiring nodes to download all data.
- **Stage 1:** Implements 1D PeerDAS by horizontally extending blobs and introducing column subnets, enabling peer sampling for improved efficiency.
- **Stage 2:** Completes Danksharding with 2D PeerDAS by adding vertical blob extensions and lightweight, cell-based peer sampling, supporting robust distributed reconstruction and maximizing scalability.

## Understanding PeerDAS

### Data Partitioning and Custody Assignment

PeerDAS divides data blobs into smaller units called *columns*, which serve as the atomic components for data sampling. The network assigns nodes to custody groups responsible for specific sets of columns. A deterministic function, using publicly verifiable inputs such as node IDs, governs this assignment to ensure transparent and reproducible distribution. Nodes must maintain a minimum custody threshold to guarantee baseline data availability. Those that store additional columns become **super-nodes**, holding all columns and increasing system redundancy to enhance fault tolerance.

### Data Encoding and Distribution

Data blobs are encoded using Reed-Solomon erasure codes. This process divides the data into multiple columns and adds parity columns, enabling the reconstruction of the original dataset even if some columns are missing. Once encoded, each column is disseminated across the network using a gossip protocol. Proposers initially distribute columns to a subset of nodes, which then relay the data to their peers. Nodes subscribe to subnets aligned with their custody groups, optimizing data flow and minimizing network congestion. If a node does not receive a column via gossip, it can retrieve the missing data using a request/response protocol with other nodes.

### Data Availability Sampling (DAS)

PeerDAS employs Data Availability Sampling to verify data without requiring a full download. Nodes request random samples of columns from their peers. By using probabilistic methods, a node infers the availability of the complete dataset when it obtains a sufficient number of samples. If missing columns are detected, the node can initiate direct requests to recover the data.

### Cryptographic Verification with KZG Commitments

To ensure data integrity and authenticity, PeerDAS uses KZG (Kate-Zaverucha-Goldberg) commitments. These cryptographic commitments enable nodes to verify that the sampled columns match the original dataset without needing to download the full data. This efficient verification process prevents tampering and data corruption.

### Data Reconstruction and Redundancy Management

Nodes continuously sample the columns under their custody. When a node accumulates more than 50% of the total columns for a data blob, it can fully reconstruct the original dataset using Reed-Solomon decoding. Once reconstructed, the node redistributes the recovered columns back into the network. This redistribution enhances overall data availability and resilience against subnet failures or temporary data unavailability.

### Validator Protocols and Fork-Choice Rules

Validators follow modified fork-choice rules to enforce data availability during the consensus process. For newly proposed blocks, validators assess data availability based on columns received via gossip subnets. For older blocks, they rely on peer sampling results to verify ongoing data availability. This dual approach mitigates risks associated with temporary data withholding, ensuring that validators vote only for blocks with verifiable data and thereby maintaining the blockchain's integrity and security.

Overall, PeerDAS integrates deterministic custody allocation, probabilistic data availability sampling, robust erasure coding, and cryptographic commitments to provide a scalable, fault-tolerant, and secure framework for data availability in decentralized networks. Its design ensures that data remains verifiable and recoverable even under adversarial conditions, making it a resilient architecture for distributed data management.

## References

- [EIP-7594: PeerDAS](https://eips.ethereum.org/EIPS/eip-7594)
- [Fulu specifications including PeerDAS](https://github.com/ethereum/consensus-specs/tree/dev/specs/fulu)
- [PeerDAS Book by Manu Nalepa](https://hackmd.io/@manunalepa/peerDAS/https%3A%2F%2Fhackmd.io%2F%40manunalepa%2FB1idHCOfke)
- [Possible futures of the Ethereum protocol, part 2: The Surge by Vitalik Buterin](https://vitalik.eth.limo/general/2024/10/17/futures2.html)
- [From 4844 to Danksharding: a path to scaling Ethereum DA (ethresear.ch)](https://ethresear.ch/t/from-4844-to-danksharding-a-path-to-scaling-ethereum-da/18046)
- [PeerDAS – a simpler DAS approach using battle-tested p2p components (ethresear.ch)](https://ethresear.ch/t/peerdas-a-simpler-das-approach-using-battle-tested-p2p-components/16541)
- [DevCon Sea: Scaling Ethereum with DAS by Francesco](https://www.youtube.com/watch?v=toR2UKzE_zA)
- [DevCon Sea: From PeerDAS to FullDAS](https://www.youtube.com/watch?v=Y8VKmyJMAUk&t=9s)
- [EthPrague: PeerDAS by Dapplion](https://www.youtube.com/watch?v=fCIPNxGXmmE&t=43s)
- [PeerDAS in Pectra and beyond by Francesco](https://www.youtube.com/watch?v=WOdpO1tH_Us&t=334s)
