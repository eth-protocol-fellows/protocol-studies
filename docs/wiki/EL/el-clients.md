# Execution Client

> **Execution clients**, formerly known as *eth1 clients*, are tasked with processing and broadcasting transactions and managing Ethereum's state.
They run the computations for each transaction using the [Ethereum Virtual Machine](https://ethereum.org/en/developers/docs/evm/) to ensure that the rules of the protocol are followed.
Execution clients can be configured as archive nodes, which retain the entire history of the blockchain, or as full (pruned) nodes, which keep only the latest state and discard older data to save storage space.


## Overview Table

| Client                                                          | Language   | Developer           | Status      |
| --------------------------------------------------------------- | ---------- | ------------------- | ----------- |
| [Besu](https://github.com/hyperledger/besu)                     | Java       | Hyperledger         | Production  |
| [Erigon](https://github.com/ledgerwatch/erigon)                 | Go         | Ledgerwatch         | Production  |
| [Geth](https://github.com/ethereum/go-ethereum)                 | Go         | Ethereum Foundation | Production  |
| [Nethermind](https://github.com/NethermindEth/nethermind)       | C#         | Nethermind          | Production  |
| [Reth](https://github.com/paradigmxyz/reth)                     | Rust       | Paradigm            | Production  |
| [Nimbus](https://github.com/status-im/nimbus-eth1)              | Nim        | Nimbus              | Development |
| [Silkworm](https://github.com/erigontech/silkworm)              | C++        | Erigon              | Development |
| [JS Client](https://github.com/ethereumjs/ethereumjs-monorepo)  | Typescript | Paradigm            | Development |
| [Akula](https://github.com/akula-bft/akula)                     | Rust       | Akula Developers    | Deprecated  |
| [Aleth](https://github.com/ethereum/aleth)                      | C++        | Aleth Developers    | Deprecated  |
| [Mana](https://github.com/mana-ethereum/mana)                   | Elixir     | Mana Developers     | Deprecated  |
| [OpenEthereum](https://github.com/openethereum/parity-ethereum) | Rust       | Parity              | Deprecated  |
| [Trinity](https://github.com/ethereum/trinity)                  | Python     | OpenEthereum        | Deprecated  |


### Besu
Developed by the Hyperledger Foundation in Java, Besu (Hyperledger Besu) is distinguished for its enterprise-grade features and compatibility with various Hyperledger projects.
It supports both public and private networks such as Rinkeby, Ropsten, and Goerli, offering robust command-line tools and a JSON-RPC API.

Noteworthy Features:
- [Private Networks](https://besu.hyperledger.org/private-networks/)
- [Pruning](https://besu.hyperledger.org/public-networks/how-to/bonsai-limit-trie-logs#prune-command-for-mainnet)
- [Monitoring](https://besu.hyperledger.org/private-networks/how-to/monitor)
- [Parallel Transaction Execution](https://besu.hyperledger.org/public-networks/concepts/parallel-transaction-execution)

### Erigon
Initially a fork of Geth (Go Ethereum), Erigon focuses on optimizing performance, fast synchronization capabilities, and reducing disk space usage.
Erigon's architecture allows it to complete a full archive node sync in under three days with less than 2 TB of data storage, making it ideal for resource-efficient node deployments.

Noteworthy Features:
- [Supported Networks](https://erigon.gitbook.io/erigon/basic-usage/supported-networks)
- [Pruning](https://erigon.gitbook.io/erigon/basic-usage/usage/type-of-node#full-node-or-pruned-node)

### Geth
As the official Go implementation of Ethereum, Geth (Go Ethereum) enjoys widespread adoption among developers and users alike.
It supports various node types (full, light, archive) and is renowned for its extensive toolset and community support.
Geth's flexibility in deployment—through package managers, Docker containers, or manual setup—ensures its versatility in diverse blockchain environments.

Noteworthy Features:
- [Pruning](https://geth.ethereum.org/docs/fundamentals/pruning)
- [Custom EVM Tracer](https://geth.ethereum.org/docs/developers/evm-tracing/custom-tracer)
- [Monitoring Dashboards](https://geth.ethereum.org/docs/monitoring/dashboards)

### Nethermind
Written in C# .NET, Nethermind is designed for stability and integration with existing tech infrastructures.
It offers optimized virtual machine performance, comprehensive analytics support via Prometheus/Grafana dashboards, and robust security features. 
Nethermind is suitable for both private Ethereum networks and decentralized application (dApp) development, emphasizing data integrity and scalability.

Noteworthy Features:
- [Private Networks](https://docs.nethermind.io/fundamentals/private-networks)
- [Prometheus and Grafana](https://docs.nethermind.io/monitoring/metrics/grafana-and-prometheus)

### Reth
Reth (Rust Ethereum) is a modular and efficient Ethereum client designed for user-friendliness and high performance.
It emphasizes community-driven development and is suitable for robust production environments.

Noteworthy Features:
- [Revm](https://bluealloy.github.io/revm/)
- [Prometheus and Grafana](https://reth.rs/run/observability.html)

### Nimbus
Nimbus focuses on efficiency and security as an ultra-lightweight Ethereum execution layer client.
It minimizes resource consumption while supporting Ethereum's execution layer functionalities and integrating with Fluffy (a Portal Network light client).
Nimbus offers enhanced memory savings and state synchronization mechanisms, ideal for resource-constrained environments.

### Silkworm
Silkworm is a C++ implementation of the Ethereum Execution Layer protocol, aiming to be the fastest Ethereum client.
It integrates the libmdbx database engine and emphasizes scalability and performance optimizations within the Erigon project (known as Erigon++).

### JS Client
The TypeScript-based JavaScript client by Paradigm, part of the EthereumJS monorepo, offers flexibility and ease of integration for Ethereum's execution layer functionalities.
It's designed to be JavaScript-centric, suitable for web and Node.js environments.
