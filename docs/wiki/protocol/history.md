# History

## The DAO Hack and Ethereum Classic(ETC) fork
TODO

## The Merge.
On September 15, 2022, Ethereum implemented [EIP-3675](https://eips.ethereum.org/EIPS/eip-3675) (Upgrade consensus to Proof-of-Stake) through an event known as The Merge. The Merge has resulted in the deprecation of the Proof-of-Work consensus, which was previously implemented in the same logic layer as execution. Instead, it has been replaced by a much more complex and sophisticated Proof-of-Stake consensus that eliminates the need for energy-intensive mining. New Proof-of-Stake consensus Gasper runs on its own tech stack and p2p network, this new abstraction layer is known as Beacon Chain. The Beacon Chain has been running and achieving consensus since December 1st, 2020. After a prolonged period of consistent performance without any failures, it was deemed ready to become Ethereum's consensus provider, The Merge gets its name from the union of the two networks.

- Consensus Layer (Beacon Chain): Specifically designed to be really good to reaching consensus. In Ethereum, time is divided up into twelve second units called **slots**, the consensus is reached when a valid block has been proposed in a specific slot. However, occasionally validators might be offline when called to propose a block, meaning slots can sometimes go empty; this situation is disincentivized by the Consensus Mechanism design.

- Execution Layer (State and Transactional Ledger): Driven by the consensus layer, it specializes in managing the transactions mempool, the Ethereum state, and Ethereum block construction and execution.

As result, an Ethereum node requires running two different software components: an execution client (or execution engine) driven by a consensus client through an internal communication protocol ([Engine API](https://web.archive.org/web/20230413232358/http://github.com/ethereum/execution-apis/tree/main/src/engine)). Note, that no additional trust assumptions need to be made for the execution Layer to follow and execute consensus decisions since each execution client receives information from the consensus Layer through its corresponding twin consensus client, and both clients operate within the same node’s trust domain.

!["Ethereum Nodes"](./img/history/ethereum-nodes.png "Ethereum Nodes")

Open source and public specifications for each client enhance client diversity. This is because a node can be set up with different combinations of client implementations from various software companies and developer communities. The goal is to achieve a client diversity in which the network is not dominated by a specific combination of execution client + consensus client implementation. This enhances the resilience of the network in case of bugs in the client implementations.

After the merge, the block generation process follows these high-level steps:
1. A validator is randomly selected using `randao` randomness.
2. This validator asks its execution layer client , via the Engine API, to send him an `ExecutionPayload`, that is the old transactional payload used with PoW based consensus.
3. The execution layer client  returns the payload which contains a set of valid transactions to the consensus layer client.
4. The consensus layer client proposes a block which includes this payload and propagates it on the Beacon Chain p2p network.
5. Other validators attest to the block and, if valid, propagate it on the Beacon Chain p2p network.

[EIP-3675: Upgrade consensus to Proof-of-Stake](https://eips.ethereum.org/EIPS/eip-3675), [archived](https://web.archive.org/web/20240213102133/https://eips.ethereum.org/EIPS/eip-3675)

[Gasper](https://ethereum.org/developers/docs/consensus-mechanisms/pos/gasper), [archived](https://web.archive.org/web/20240214225630/https://ethereum.org/developers/docs/consensus-mechanisms/pos/gasper)

[Mega Merge Resources List](https://notes.ethereum.org/@MarioHavel/merge-resources), [archived](https://web.archive.org/web/20240302082121/https://notes.ethereum.org/@MarioHavel/merge-resources)