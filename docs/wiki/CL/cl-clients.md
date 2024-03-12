# Consensus Layer Implementations

Resources covering all consensus client implementations, in production or development. Overview of client unique features of each client, architecture, guides and resources.

There are multiple Consensus Layer clients developed to participate in the Ethereum Proof-of-Stake (PoS) mechanism. The most popular ones are [Prysm](https://prysmaticlabs.com/), [Lighthouse](https://lighthouse-book.sigmaprime.io/), [Teku](https://consensys.io/teku), [Nimbus](https://nimbus.team/index.html), and [Lodestar](https://lodestar.chainsafe.io/). These clients are developed in different programming languages and have unique features. One of the most known clients is Prysm, which is developed in Go, Lighthouse in Rust, Teku in Java, Nimbus in Nim, and Lodestar in JavaScript. In this document, we will talk briefly about each client.

## Prysm

[Prysm](https://docs.prylabs.network/docs/getting-started) is a client developed in the Go programming language. It is one of the most popular clients and has a large community. Using this client, validators can participate in the Ethereum PoS mechanism. Prysm can be used as a beacon node or a validator client. It can assist execution layer clients in processing transactions and blocks. When an execution client is integrated with Prysm, it first syncs the block headers with it since, as a beacon node, it has a full view of the chain. It gossips the latest block headers to the EL client. Then, the EL client can request the block bodies from its p2p network. This is mostly common in the case of all Consensus Layer clients.

Apart from Ethereum mainnet, Prysm can also be run on testnets such as Goerli, Holesky, and Pyrmont. Prysm can be integrated with [Geth](https://geth.ethereum.org/), [Nethermind](https://www.nethermind.io/nethermind-client), and [Besu](https://besu.hyperledger.org/) clients. It has a web interface to monitor the beacon chain and validator performance. It also has a RESTful API to interact with the beacon chain and validator client.

### Installing the client

Client installation is considered as one of the first barriers to entry for new validators or node operators. The installation process can be done either using an automated process using docker or a manual process building using the source. Both of these methods have flexibility to run clients on different operating systems, hardware, and roles (beacon node and/or validator client).

#### Using Docker

The easiest and faster way to install the client is [using docker](https://docs.prylabs.network/docs/install/install-with-docker). Most of the client related activities in this way comes using the [configuration files](https://docs.prylabs.network/docs/install/install-with-docker#configure-ports-optional).

#### Building from Source

One learns slihtly more about the client by building it [from source](https://docs.prylabs.network/docs/install/install-with-bazel). One also needs to be careful about the hardware specs and [requirements](https://docs.prylabs.network/docs/install/install-with-bazel#review-system-requirements) for the client to run smoothly.

#### No Light client support

Currently there is no light client support with Prysm.

### Security considerations and best practices

Consensus client security is somewhat more essential than the Execution Layer client security since Consensus client are not only responsible for the security of the network but also for the security of the validators. Responsibilities such as valid block execution, choosing the correct chain to managing the staking related financials. Prysm has outlined a few [best practices](https://docs.prylabs.network/docs/security-best-practicespractices) to follow to ensure the security of the client and the network. Out of which the following holds the utmost importance:

#### Slashing Avoidance

Validators are hold accountable for their on-chain actions towards the safety and liveness of the protocol using possible slashing conditions. Guidelines to avoid slashing are outlined in the [documentation](https://docs.prylabs.network/docs/security-best-practices#slash-avoidance).

#### Wallet and key management

Although there is a separation between the credentials used to stake and withdrawal, it is important to keep the keys secure. The [documentation](https://docs.prylabs.network/docs/security-best-practices#slash-avoidance) outlines the best practices to keep the keys secure.

### Most Frequently Asked Questions

For more frequently asked question about the client, refer to the [FAQ](https://docs.prylabs.network/docs/faq).

## LightHouse

[Lighthouse](https://lighthouse-book.sigmaprime.io/) is a client developed in the Rust programming language. It is a full-featured Ethereum 2.0 client that can be used as a beacon node or a validator client. It is developed by [Sigma Prime](https://sigmaprime.io/). It can work with execution client such as Nethermind, Geth, Erigon, and Besu. It can work on Ethereum mainnet and testnets such as Goeril, Sepolia, Chiado, and Gnosis. It has a web interface [Siren](https://lighthouse-book.sigmaprime.io/lighthouse-ui.html) to monitor the beacon chain and validator performance.

### Installing the client

Lighthouse client can be installed using 3 main ways - using docker, building from source, and using pre-built binaries. They also provide [Raspberry client](https://lighthouse-book.sigmaprime.io/pi.html) and [cross-compiling](https://lighthouse-book.sigmaprime.io/cross-compiling.html) guide. Using additional simple commands, one can supplement the beacon client with [validator](https://lighthouse-book.sigmaprime.io/mainnet-validator.html) role.

#### Using Docker

Lighthouse provides a more illustrative guide to install the client using docker. They have options of [Docker Hub](https://lighthouse-book.sigmaprime.io/docker.html#docker-hub) and building docker hub [from source](https://lighthouse-book.sigmaprime.io/docker.html#building-the-docker-image).

#### Building from Source

Just like Prysm, it also has multiple hardware and OS support to built the client from source. The [documentation](https://lighthouse-book.sigmaprime.io/installation-source.html). Make sure you have correct dependencies installed before building the client.

#### Pre-built Binaries

Pre-built binaries are also available for the Lighthouse client. It enables portability and ease of installation without bothering much about the platform level dependencies. The [documentation](https://lighthouse-book.sigmaprime.io/installation-binaries.html) provides the steps to install the client using pre-built binaries.

### Additional features and security considerations

Lighthouse client is quite advanced that it proves the following additional features:

- [Slashing Protection](https://lighthouse-book.sigmaprime.io/faq.html#what-is-slashing-protection)
- [Doppelganger Protection](https://lighthouse-book.sigmaprime.io/validator-doppelganger.html#doppelganger-protection)
- [Running a Slasher](https://lighthouse-book.sigmaprime.io/slasher.html)
- [Builder API for MEV](https://lighthouse-book.sigmaprime.io/builders.html#maximal-extractable-value-mev)

### Most Frequently Asked Questions

For more frequently asked question about the client, refer to the [FAQ](https://lighthouse-book.sigmaprime.io/faq.html).

## Teku

[Teku](https://consensys.io/teku) is a client developed in the Java programming language. It is developed by [ConsenSys](https://consensys.net/). It is a full-featured Ethereum 2.0 client that can be used as a beacon node or a validator client. It can work with execution client such as Besu. It can work on Ethereum mainnet and testnets such as Goeril, Sepolia, and Holesky. It has a web interface to monitor the beacon chain and validator performance. Teku provides both beacon client and validator client to also run as docker containers.
