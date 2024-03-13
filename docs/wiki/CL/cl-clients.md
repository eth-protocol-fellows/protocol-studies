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

### Sample Run

The following is a sample run of the Prysm client on the Ethereum mainnet with Geth Node as an execution client:

```bash
TERMS AND CONDITIONS: https://github.com/prysmaticlabs/prysm/blob/develop/TERMS_OF_SERVICE.md


Type "accept" to accept this terms and conditions [accept/decline]: (default: decline):
accept
[2024-03-10 23:42:11]  INFO Finished reading JWT secret from /home/userDemo/code/jwt.hex
[2024-03-10 23:42:11]  WARN flags: Running on Ethereum Mainnet
[2024-03-10 23:42:11]  WARN node: In order to receive transaction fees from proposing blocks, you must provide flag --suggested-fee-recipient with a valid ethereum address when starting your beacon node. Please see our documentation for more information on this requirement (https://docs.prylabs.network/docs/execution-node/fee-recipient).
[2024-03-10 23:42:11]  INFO node: Checking DB database-path=/home/userDemo/.eth2/beaconchaindata
[2024-03-10 23:42:11]  INFO db: Opening Bolt DB at /home/userDemo/.eth2/beaconchaindata/beaconchain.db
[2024-03-10 23:42:12]  WARN genesis: database contains genesis with htr=0x7e76880eb67bbdc86250aa578958e9d0675e64e714337855204fb5abaaf82c2b, ignoring remote genesis state parameter
[2024-03-10 23:42:21]  INFO detected supported config in remote finalized state, name=mainnet, fork=capella
[2024-03-10 23:42:22]  INFO Downloaded checkpoint sync state and block. block_root=0xe6c065b28ef4826da69ba234394f1e293473a5fb56fa3e053bd73d650dd6061a block_slot=8607136 state_root=0x42ef0d1f525b019097e0b30904215703cb784474ad7a186087fd7bdf3ba9c25d state_slot=8607136
[2024-03-10 23:42:22]  INFO db: detected supported config for state & block version, config name=mainnet, fork name=capella
[2024-03-10 23:42:23]  INFO db: saving checkpoint block to db, w/ root=0xe6c065b28ef4826da69ba234394f1e293473a5fb56fa3e053bd73d650dd6061a
[2024-03-10 23:42:23]  INFO db: calling SaveState w/ blockRoot=e6c065b28ef4826da69ba234394f1e293473a5fb56fa3e053bd73d650dd6061a
[2024-03-10 23:42:23]  INFO node: Deposit contract: 0x00000000219ab540356cbb839cbe05303d7705fa
[2024-03-10 23:42:23]  INFO p2p: Running node with peer id of 16Uiu2HAmPa9EyCpvNwFizaRY7PXdedPgnUPYAuXwdiVcQ83h1uoQ
[2024-03-10 23:42:24]  INFO rpc: gRPC server listening on port address=127.0.0.1:4000
[2024-03-10 23:42:24]  WARN rpc: You are using an insecure gRPC server. If you are running your beacon node and validator on the same machines, you can ignore this message. If you want to know how to enable secure connections, see: https://docs.prylabs.network/docs/prysm-usage/secure-grpc
[2024-03-10 23:42:24]  INFO node: Starting beacon node version=Prysm/v5.0.1/a1a81d1720a0a3b850992d4825d0a023baa8e65a. Built at: 2024-03-08 20:31:40+00:00
[2024-03-10 23:42:24]  INFO initial-sync: Waiting for state to be initialized
[2024-03-10 23:42:24]  INFO blockchain: Blockchain data already exists in DB, initializing...
[2024-03-10 23:42:24]  INFO Backfill service not enabled.
[2024-03-10 23:42:24]  INFO gateway: Starting gRPC gateway address=127.0.0.1:3500
[2024-03-10 23:42:24]  INFO initial-sync: Received state initialized event
[2024-03-10 23:42:24]  INFO initial-sync: Starting initial chain sync...
[2024-03-10 23:42:24]  INFO initial-sync: Waiting for enough suitable peers before syncing required=3 suitable=0
[2024-03-10 23:42:24]  INFO p2p: Started discovery v5 ENR=enr:-MK4QLql3XgYbbOfu3gcaUijzcz2RwBE9utUVhR1YhcvqgErfjfjs88JqJIr7FzwpyoclMP8pBXWcUKCWtKKpKnoio-GAY4qiBRfh2F0dG5ldHOIAAAAAAAAAACEZXRoMpC7pNqWBAAAAAAdBAAAAAAAgmlkgnY0gmlwhMCoAZqJc2VjcDI1NmsxoQOiMrSMfZgcZfphI6hjf84nwmq7wMne1wML_H_EQdtn04hzeW5jbmV0cwCDdGNwgjLIg3VkcIIu4A
[2024-03-10 23:42:24]  INFO p2p: Node started p2p server multiAddr=/ip4/192.168.1.154/tcp/13000/p2p/16Uiu2HAmPa9EyCpvNwFizaRY7PXdedPgnUPYAuXwdiVcQ83h1uoQ
[2024-03-10 23:42:34]  INFO blockchain: Called new payload with optimistic block payloadBlockHash=0x492df9344dbd slot=8607137
[2024-03-10 23:42:38]  WARN blockchain: Could not update head error=head at slot 8607136 with weight 97641 is not eligible, finalizedEpoch, justified Epoch 268971, 268972 != 268973, 268973
[2024-03-10 23:42:38]  WARN blockchain: could not determine node weight root=0x0000000000000000000000000000000000000000000000000000000000000000
[2024-03-10 23:42:38]  INFO blockchain: Synced new block block=0xc74dfd56... epoch=268973 finalizedEpoch=268973 finalizedRoot=0xe6c065b2... slot=8607137
[2024-03-10 23:42:38]  INFO blockchain: Finished applying state transition attestations=111 payloadHash=0x492df9344dbd slot=8607137 syncBitsCount=400 txCount=153
```

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
