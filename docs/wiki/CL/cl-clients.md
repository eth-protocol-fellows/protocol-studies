# Consensus Client

> **Consensus clients**, formerly known as *eth2 clients*, run Ethereum's proof-of-stake consensus algorithm allowing the network to reach agreement about the head of the Beacon Chain. Consensus clients do not participate in validating/broadcasting transactions or executing state transitions: that is done by execution clients. Consensus clients do not attest to, or propose new blocks: that is done by the validator client which is an optional add-on to the consensus client.


### Lighthouse
Lighthouse, written in Rust by Sigma Prime, emphasizes security and performance. It's widely adopted but caution is advised as a supermajority could potentially lead to chain splits.
Lighthouse is licensed under Apache 2.0 and known for its robustness in production environments.

### Lodestar
Lodestar is a TypeScript-based Ethereum consensus client by ChainSafe, tailored for rapid prototyping and browser compatibility.
It supports beacon node and validator client functionalities, offering essential libraries like BLS and SSZ for Ethereum protocol development.
Lodestar is double-licensed under the Apache License 2.0 and the GNU Lesser General Public License (LGPL), allowing users to choose between a permissive and a copyleft licensing model.

### Prysm
Prysmatic Labs' Prysm client, written in Go, focuses on usability and reliability. It includes a full beacon node implementation and validator client, leveraging gRPC for interprocess communication, BoltDB for storage, and libp2p for networking. Prysm is designed for secure participation in Ethereum's proof-of-stake consensus.

### Nimbus
Nimbus, developed in Nim by Status, is optimized for resource efficiency. It supports lightweight devices like smartphones and Raspberry Pi's, conserving resources for other tasks when run on powerful servers. Nimbus features integrated validator client support, remote signing, performance analysis tools, and robust validator monitoring capabilities.

### Teku
ConsenSys' Teku is a Java-based Ethereum consensus client offering comprehensive enterprise-grade features. It includes a full beacon node implementation, validator client, REST APIs for node management, Prometheus metrics for monitoring, and external key management for validator signing keys. Teku is suited for enterprise-level Ethereum deployments requiring scalability and operational control.

### Grandine
Grandine is a fast and lightweight Ethereum consensus client designed with a focus on high performance and simplicity.
Developed with parallelization and efficient resource utilization at its core, Grandine aims to push the boundaries of Ethereum's consensus layer by offering a streamlined alternative to existing clients.
Its architecture is optimized to minimize latency and maximize throughput, making it well-suited for environments where performance is critical.

### Caplin and LambdaClass
These clients are currently in development, aiming to contribute unique features to the Ethereum consensus landscape. Caplin by Erigon, Grandine, and LambdaClass are respectively focusing on enhancing performance, security, and scalability, though specific details are forthcoming as these projects evolve.
