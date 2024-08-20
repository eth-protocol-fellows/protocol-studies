# Consensus Client

> **Consensus clients**, formerly known as *eth2 clients*, run Ethereum's proof-of-stake consensus algorithm allowing the network to reach agreement about the head of the Beacon Chain. Consensus clients do not participate in validating/broadcasting transactions or executing state transitions: that is done by execution clients. Consensus clients do not attest to, or propose new blocks: that is done by the validator client which is an optional add-on to the consensus client.


## Overview Table

| Client                                                                  | Language   | Developer           | Status      |
| ----------------------------------------------------------------------- | ---------- | ------------------- | ----------- |
| [Lighthouse](https://github.com/sigp/lighthouse)                        | Rust       | Sigma Prime         | Production  |
| [Lodestar](https://github.com/ChainSafe/lodestar)                       | TypeScript | ChainSafe           | Production  |
| [Nimbus](https://github.com/status-im/nimbus-eth2)                      | Nim        | Status              | Production  |
| [Prysm](https://github.com/prysmaticlabs/prysm)                         | Go         | Prysmatic Labs      | Production  |
| [Teku](https://github.com/ConsenSys/teku)                               | Java       | ConsenSys           | Production  |
| [Grandine](https://github.com/grandinetech/grandine)                    | Rust       | Grandine Developers | Production  |
| [Caplin](https://github.com/ledgerwatch/erigon)                         | N/A        | Erigon              | Development |
| [LambdaClass](https://github.com/lambdaclass/lambda_ethereum_consensus) | Elixir     | LambdaClass         | Development |


### Lighthouse
Lighthouse, written in Rust by Sigma Prime, emphasizes security and performance. It's widely adopted but caution is advised as a supermajority could potentially lead to chain splits.
Lighthouse is licensed under Apache 2.0 and known for its robustness in production environments.

Noteworthy Features:
- [Become a staked Validator](https://lighthouse-book.sigmaprime.io/mainnet-validator.html)
- [Slashing Protection](https://lighthouse-book.sigmaprime.io/slashing-protection.html)
- [Dopperganger Protection](https://lighthouse-book.sigmaprime.io/validator-doppelganger.html)
- [Running a Slasher](https://lighthouse-book.sigmaprime.io/slasher.html)
- [Builder API for MEV](https://lighthouse-book.sigmaprime.io/builders.html)
- [Block Proposer-only](https://lighthouse-book.sigmaprime.io/advanced-proposer-only.html)
- [Prometheus and Grafana](https://lighthouse-book.sigmaprime.io/advanced_metrics.html)

### Lodestar
Lodestar is a TypeScript-based Ethereum consensus client by ChainSafe, tailored for rapid prototyping and browser compatibility.
It supports beacon node and validator client functionalities, offering essential libraries like BLS and SSZ for Ethereum protocol development.
Lodestar is double-licensed under the Apache License 2.0 and the GNU Lesser General Public License (LGPL), allowing users to choose between a permissive and a copyleft licensing model.

Noteworthy Features:
- [Validator Client](https://chainsafe.github.io/lodestar/run/validator-management/vc-configuration)
- [MEV and Builder Integration](https://chainsafe.github.io/lodestar/run/beacon-management/mev-and-builder-integration)
- [Light Client](https://chainsafe.github.io/lodestar/libraries/lightclient-prover/lightclient)
- [Prover](https://chainsafe.github.io/lodestar/libraries/lightclient-prover/prover)
- [Prometheus and Grafana](https://chainsafe.github.io/lodestar/run/logging-and-metrics/prometheus-grafana)
- [Remote Monitoring](https://chainsafe.github.io/lodestar/run/logging-and-metrics/client-monitoring)

### Prysm
Prysmatic Labs' Prysm client, written in Go, focuses on usability and reliability. It includes a full beacon node implementation and validator client, leveraging gRPC for interprocess communication, BoltDB for storage, and libp2p for networking. Prysm is designed for secure participation in Ethereum's proof-of-stake consensus.

Noteworthy Features:
- [Validator Client](https://docs.prylabs.network/docs/wallet/nondeterministic)
- [Configuring MEV Builder](https://docs.prylabs.network/docs/advanced/builder)
- [Running a Slasher](https://docs.prylabs.network/docs/prysm-usage/slasher)
- [Prometheus and Grafana](https://docs.prylabs.network/docs/prysm-usage/monitoring/grafana-dashboard)
- [Detailed Best Security Practices](https://docs.prylabs.network/docs/security-best-practices)

### Nimbus
Nimbus, developed in Nim by Status, is optimized for resource efficiency. It supports lightweight devices like smartphones and Raspberry Pi's, conserving resources for other tasks when run on powerful servers. Nimbus features integrated validator client support, remote signing, performance analysis tools, and robust validator monitoring capabilities.

Noteworthy Features:
- [Run an Execution Client](https://nimbus.guide/eth1.html)
- [Validator Client](https://nimbus.guide/validator-client.html)
- [MEV and Builder Integration](https://nimbus.guide/external-block-builder.html)
- [Prometheus and Grafana](https://nimbus.guide/metrics-pretty-pictures.html)

### Teku
ConsenSys' Teku is a Java-based Ethereum consensus client offering comprehensive enterprise-grade features. It includes a full beacon node implementation, validator client, REST APIs for node management, Prometheus metrics for monitoring, and external key management for validator signing keys. Teku is suited for enterprise-level Ethereum deployments requiring scalability and operational control.

Noteworthy Features:
- [Validator Client](https://docs.teku.consensys.io/concepts/proof-of-stake)
- [Slashing Protection](https://docs.teku.consensys.io/how-to/prevent-slashing/use-a-slashing-protection-file)
- [Builder and MEV-boost](https://docs.teku.consensys.io/concepts/builder-network)
- [Detect Doppelganger](https://docs.teku.consensys.io/how-to/prevent-slashing/detect-doppelgangers)
- [Prometheus and Grafana](https://docs.teku.consensys.io/how-to/monitor/use-metrics)

### Grandine
Grandine is a fast and lightweight Ethereum consensus client designed with a focus on high performance and simplicity.
Developed with parallelization and efficient resource utilization at its core, Grandine aims to push the boundaries of Ethereum's consensus layer by offering a streamlined alternative to existing clients.
Its architecture is optimized to minimize latency and maximize throughput, making it well-suited for environments where performance is critical.

Noteworthy Features:
- [Validator Client](https://docs.grandine.io/validator_client.html)
- [Slashing Protection](https://docs.grandine.io/slashing_protection.html)
- [Builer and MEV](https://docs.grandine.io/builder_api_and_mev.html)
- [Running a Slasher](https://github.com/grandinetech/grandine/tree/develop/slasher)
- [Prometheus](https://docs.grandine.io/metrics.html) and [Grafana](https://github.com/grandinetech/grandine/tree/develop/metrics)

### Caplin and LambdaClass
These clients are currently in development, aiming to contribute unique features to the Ethereum consensus landscape. Caplin by Erigon, Grandine, and LambdaClass are respectively focusing on enhancing performance, security, and scalability, though specific details are forthcoming as these projects evolve.
