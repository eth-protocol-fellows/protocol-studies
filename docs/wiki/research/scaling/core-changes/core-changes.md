# Changes to Ethereum Core to Achieve Scalability

With the [Rollup-Centric Roadmap](https://ethereum-magicians.org/t/a-rollup-centric-ethereum-roadmap/4698) published by Vitalik Buterin in 2020, Ethereum has embarked on a path toward achieving scalability. The ultimate goals of Ethereum scalability can be summarized as follows:

- Transition the execution layer (dApps) entirely to Layer 2 (L2) rollups.
- Optimize Ethereum, the Layer 1 (L1), to serve primarily as the settlement and data availability layer.

Following the [Merge](https://github.com/ethereum/consensus-specs/tree/dev/specs/bellatrix), (see the [consensus spec](https://github.com/ethereum/consensus-specs), [annotated spec](https://github.com/ethereum/annotated-spec/blob/master/merge/beacon-chain.md), and [execution spec](https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/paris.md)), the Ethereum chain has been divided into two distinct chains: the [consensus layer (CL)](https://github.com/ethereum/consensus-specs) and the [execution layer (EL)](https://github.com/ethereum/execution-specs). The consensus layer is responsible for the security, decentralization, and censorship-resistant properties of Ethereum, while the execution layer is responsible for executing transactions within each new block proposed by the consensus layer. These transactions update the global state of the chain, which is securely stored on the CL.

While the EL can be used for direct L1 dApp transactions, the goal, as mentioned earlier, is for dApp transactions to move entirely to L2 rollups. The EL will primarily be used by rollups to update the L2 state or as a backup if for some reasons the L2 is [stopping working](https://docs.arbitrum.io/sequencer#unhappyuncommon-case-sequencer-isnt-doing-its-job).

The CL will be used by rollups for Data Availability (DA) and to store proofs of validity, especially for ZK rollups. To achieve scalability and reduce gas costs, storing data on the CL blocks must be affordable in the long term. To accomplish this ambitious roadmap, the development of the CL can be outlined in the following phases:

- Proto-danksharding ([EIP-4844](https://eips.ethereum.org/EIPS/eip-4844)), the upgrade introducing blobs (live on March 14, 2024).
- Increasing [blob count & gas modifications](https://ethresear.ch/t/on-increasing-the-block-gas-limit/18567) (planned for EOY 2024).
- Addition of [PeerDAS](https://ethresear.ch/t/peerdas-a-simpler-das-approach-using-battle-tested-p2p-components/16541).
- Full implementation of [Danksharding](https://ethresear.ch/t/from-4844-to-danksharding-a-path-to-scaling-ethereum-da/18046).

In the following section, we discuss how EIP-4844 will impact the EL and CL.
