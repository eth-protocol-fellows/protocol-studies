# Consensus Layer Implementations

Resources covering all consensus client implementations, in production or development. Overview of client unique features of each client, architecture, guides and resources.

There are multiple Consensus Layer clients developed to participate in the Ethereum Proof-of-Stake (PoS) mechanism. The most popular ones are [Prysm](https://prysmaticlabs.com/), [Lighthouse](https://lighthouse-book.sigmaprime.io/), [Teku](https://consensys.io/teku), [Nimbus](https://nimbus.team/index.html), and [Lodestar](https://lodestar.chainsafe.io/). These clients are developed in different programming languages and have unique features. One of the most known clients is Prysm, which is developed in Go, Lighthouse in Rust, Teku in Java, Nimbus in Nim, and Lodestar in JavaScript. In this document, we will talk briefly about each client.

## Prysm

[Prysm](https://docs.prylabs.network/docs/getting-started) is a client developed in the Go programming language. It is one of the most popular clients and has a large community. Using this client, validators can participate in the Ethereum PoS mechanism. Prysm can be used as a beacon node or a validator client. It can assist execution layer clients in processing transactions and blocks. When an execution client is integrated with Prysm, it first syncs the block headers with it since, as a beacon node, it has a full view of the chain. It gossips the latest block headers to the EL client. Then, the EL client can request the block bodies from its p2p network.

Apart from Ethereum mainnet, Prysm can also be run on testnets such as Goerli, Holesky, and Pyrmont. Prysm can be integrated with [Geth](https://geth.ethereum.org/), [Nethermind](https://www.nethermind.io/nethermind-client), and [Besu](https://besu.hyperledger.org/) clients. It has a web interface to monitor the beacon chain and validator performance. It also has a RESTful API to interact with the beacon chain and validator client.
