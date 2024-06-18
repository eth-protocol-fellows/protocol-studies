# Protocol history and evolution

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

This page highlights important technical changes in the history of Ethereum protocol. 

Useful links: [Overview from Ethereum.org](https://ethereum.org/en/history) and [Meta EIPs from Ethereum.org](https://eips.ethereum.org/meta)

## Frontier

The Frontier release marked the launch of the Ethereum Protocol. It was launched on July 30, 2015, at 3:26:13 AM UTC, which is the timestamp of the [Ethereum genesis block](https://etherscan.io/block/0). Frontier launched with a gas limit of 5000. This gas limit was hard coded into the protocol to ensure that miners and users could get up and running by installing clients during the initial launch of the protocol. The gas limit would later be increased to 3 million with the Frontier thawing fork (exactly 3,141,592). The canary contracts were contracts that gave a binary signal of either 0 or 1. These canary contracts were an initial launch mechanism used only during the Frontier release of Ethereum. If clients detected that multiple contracts had switched to a signal of 1, they would stop mining and urge the user to update their client. This prevented prolonged outages by ensuring that miners did not prevent a chain upgrade.

Learn more about Frontier in the following resources:

- https://blog.ethereum.org/2015/07/22/frontier-is-coming-what-to-expect-and-how-to-prepare
- https://blog.ethereum.org/2015/08/04/the-thawing-frontier
- https://web.archive.org/web/20150802035735/https://www.ethereum.org/
- https://blog.ethereum.org/2015/08/04/ethereum-protocol-update-1

## Homestead

Homestead was the second major release of Ethereum. It introduced [EIP-2](https://eips.ethereum.org/EIPS/eip-2), [EIP-7](https://eips.ethereum.org/EIPS/eip-7), and [EIP-8](https://eips.ethereum.org/EIPS/eip-8). EIP-8 ensures that clients on Ethereum support future network upgrades by introducing devp2p forward compatibility requirements. EIP-7 introduced the DELEGATECALL opcode. EIP-2 contained numerous fixes, such as increasing the gas cost for contract creation via transactions, ensuring that contract creation either succeeded or failed (preventing empty contracts from being created), and modifications to the difficulty adjustment algorithm.

Learn more about Homestead in the following resources:

- https://blog.ethereum.org/2016/02/29/homestead-release
- https://eips.ethereum.org/EIPS/eip-2
- https://eips.ethereum.org/EIPS/eip-7
- https://eips.ethereum.org/EIPS/eip-8

## The Merge

On September 15, 2022, Ethereum activated [EIP-3675](https://eips.ethereum.org/EIPS/eip-3675) and upgraded the consensus mechanism to proof-of-stake through an event known as The Merge. The Merge has resulted in the deprecation of the proof-of-work consensus, which was previously implemented in the same logic layer as execution. Instead, it has been replaced by a more complex and sophisticated proof-of-stake consensus that eliminates the need for energy-intensive mining. New proof-of-stake consensus has been implemented in its own layer with a separate p2p network and logic, also know as Beacon Chain. The Beacon Chain has been running and achieving consensus since December 1st, 2020. After a prolonged period of consistent performance without any failures, it was deemed ready to become Ethereum's consensus provider. The Merge gets its name from the union of the two networks.

Learn more about The Merge in following resources and reading on Consensus layer. 

 - [EIP-3675: Upgrade consensus to Proof-of-Stake](https://eips.ethereum.org/EIPS/eip-3675), [archived](https://web.archive.org/web/20240213102133/https://eips.ethereum.org/EIPS/eip-3675)
- [Gasper](https://ethereum.org/developers/docs/consensus-mechanisms/pos/gasper), [archived](https://web.archive.org/web/20240214225630/https://ethereum.org/developers/docs/consensus-mechanisms/pos/gasper)
- [Mega Merge Resources List](https://notes.ethereum.org/@MarioHavel/merge-resources), [archived](https://web.archive.org/web/20240302082121/https://notes.ethereum.org/@MarioHavel/merge-resources)
