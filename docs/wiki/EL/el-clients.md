# Execution Client

> **Execution clients**, formerly known as *eth1 clients*, are implementing Ethereum [execution layer](https://github.com/ethereum/execution-specs) tasked with processing and broadcasting transactions and managing the state.
They receive transactions via p2p, run the computations for each transaction using the [Ethereum Virtual Machine](https://ethereum.org/en/developers/docs/evm/) to update the state and ensure that the rules of the protocol are followed. 
Execution clients can be configured as full nodes which holds the state, historical blockchain including receipts, or as an archive node which retains also all historical states. 

## Overview Table

Current execution clients used in production are:

| Client      | Language | Developer          | Status     |
|-------------|----------|-------------------|------------|
| [Besu](https://github.com/hyperledger/besu) | Java | Hyperledger | Production |
| [Erigon](https://github.com/ledgerwatch/erigon) | Go | Ledgerwatch | Production |
| [Geth](https://github.com/ethereum/go-ethereum) | Go | Ethereum Foundation | Production |
| [Nethermind](https://github.com/NethermindEth/nethermind) | C# | Nethermind | Production |
| [Reth](https://github.com/paradigmxyz/reth) | Rust | Paradigm | Production |

There are more execution clients that are in active development and haven't reached maturity yet or has been used in the past:

| Client                                                          | Language   | Developer           | Status      |
| --------------------------------------------------------------- | ---------- | ------------------- | ----------- |
| [Nimbus](https://github.com/status-im/nimbus-eth1)              | Nim        | Nimbus              | Development |
| [Silkworm](https://github.com/erigontech/silkworm)              | C++        | Erigon              | Development |
| [JS Client](https://github.com/ethereumjs/ethereumjs-monorepo)  | Typescript | Ethereum Foundation            | Development |
| [ethrex](https://github.com/lambdaclass/ethrex)                 | Rust       | LambdaClass         | Development |
| [Akula](https://github.com/akula-bft/akula)                     | Rust       | Akula Developers    | Deprecated  |
| [Aleth](https://github.com/ethereum/aleth)                      | C++        | Aleth Developers    | Deprecated  |
| [Mana](https://github.com/mana-ethereum/mana)                   | Elixir     | Mana Developers     | Deprecated  |
| [OpenEthereum](https://github.com/openethereum/parity-ethereum) | Rust       | Parity              | Deprecated  |
| [Trinity](https://github.com/ethereum/trinity)                  | Python     | OpenEthereum        | Deprecated  |


## Distribution

The overwhelming majority of node operators are currently using Geth as an Execution Client. 
In the interest of supporting the health of the Execution Layer, [it is recommended to use different clients](https://clientdiversity.org/#why) when running nodes. 

## Individual clients

Although clients implement the same specification, each client offers different set of features and benefits. They come in different programming languages enabling developers of different backgrounds to contribute. 

### Besu

Developed by the Consensys/Hyperledger Foundation in Java, Besu (Hyperledger Besu) is distinguished for its enterprise-grade features and compatibility with various Hyperledger projects.
It supports both public and private networks, offering robust command-line tools and a JSON-RPC API.

Noteworthy Features:
- [Private Networks](https://besu.hyperledger.org/private-networks/)
- [Pruning](https://besu.hyperledger.org/public-networks/how-to/bonsai-limit-trie-logs#prune-command-for-mainnet)
- [Parallel Transaction Execution](https://besu.hyperledger.org/public-networks/concepts/parallel-transaction-execution)

### Erigon

Initially a fork of Geth introduced as turbo-geth, Erigon focuses on optimizing performance, fast synchronization capabilities, and reducing disk space usage. Erigon introduced a new way of managing MPT database resulting in roughly a 5-times reduction in the archive node disk size.
Erigon's architecture allows it to complete a full archive node sync in under three days with less than 3 TB of data storage, making it ideal for running this kind of node. It also includes its own embedded CL client, enabling it to run independently. 

Noteworthy Features:
- [Supported Networks](https://erigon.gitbook.io/erigon/basic-usage/supported-networks)
- [Pruning](https://erigon.gitbook.io/erigon/basic-usage/usage/type-of-node#full-node-or-pruned-node)
- [Caplin CL client](https://erigon.gitbook.io/erigon/advanced-usage/consensus-layer/caplin)

### Geth

As the original Go implementation of Ethereum, the oldest actively maintained client, Geth (Go-Ethereum) enjoys widespread adoption among developers and users alike.
It supports various node types (full, light, archive) and is renowned for its extensive toolset, stability and community support.
Geth's flexibility in deployment—through package managers, Docker containers, or manual setup—ensures its versatility in diverse blockchain environments.

Noteworthy Features:
- [Pruning](https://geth.ethereum.org/docs/fundamentals/pruning)
- [Custom EVM Tracer](https://geth.ethereum.org/docs/developers/evm-tracing/custom-tracer)
- [Monitoring Dashboards](https://geth.ethereum.org/docs/monitoring/dashboards)

### Nethermind
Written in C# .NET, Nethermind is designed for stability and integration with existing tech infrastructures.
It offers optimized virtual machine performance, comprehensive analytics support and plugin system.
Nethermind is suitable for both private Ethereum networks and decentralized application (dApp) development, emphasizing data integrity and performance scalability.

Noteworthy Features:
- [Private Networks](https://docs.nethermind.io/fundamentals/private-networks)
- [Performance tuning](https://docs.nethermind.io/fundamentals/performance-tuning)
- [Prometheus and Grafana](https://docs.nethermind.io/monitoring/metrics/grafana-and-prometheus)

### Reth

Reth (Rust Ethereum) is a modular and efficient Ethereum client designed for user-friendliness and high performance. Inspired by Erigon design, it's built around novel archive node approach that enables fast sync with small disk footprint.
It emphasizes community-driven development and is suitable for robust production environments.

Noteworthy Features:
- [Revm](https://bluealloy.github.io/revm/)
- [Monitoring](https://reth.rs/run/observability.html)

### Nimbus

Nimbus focuses on efficiency and security as an ultra-lightweight Ethereum execution layer client. Originally working on Nimbus CL client, a new team spin out to develop an execution client in Nim. 
It minimizes resource consumption while supporting Ethereum's execution layer functionalities and integrating with Fluffy (a Portal Network light client).
Nimbus offers enhanced memory savings and state synchronization mechanisms, ideal for resource-constrained environments.

### Silkworm
Silkworm is a C++ implementation of the Ethereum Execution Layer protocol, aiming to be the fastest Ethereum client.
It integrates the libmdbx database engine and emphasizes scalability, modularity and performance optimizations within the Erigon project (known as Erigon++).

### JS Client
The JavaScript client is developed by EF JS team as a part of the [EthereumJS monorepo](https://github.com/ethereumjs/ethereumjs-monorepo). It's experimental and serves mostly for testing but as it's designed to be JavaScript-centric, it's suitable for web and Node.js environments.

## Additional resources

- [ETH Docker](https://eth-docker.net/)
- [Ethernodes](https://ethernodes.org/)
- [Client Diversity](https://clientdiversity.org/)
- [Run the majority client at your own peril!](https://dankradfeist.de/ethereum/2022/03/24/)
=======
- [Client Diversity](https://clientdiversity.org/)
- [Run the majority client at your own peril!](https://dankradfeist.de/ethereum/2022/03/24/

>>>>>>> main
