# Protocol history and evolution

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

This page highlights important technical changes in the history of Ethereum protocol. 

Useful links: [Overview from Ethereum.org](https://ethereum.org/en/history) and [Meta EIPs from Ethereum.org](https://eips.ethereum.org/meta)

## Frontier

The Frontier release marked the launch of the Ethereum Protocol. The release was essentially a beta release that allowed developers to learn, experiment, and begin building Ethereum decentralized apps and tools. It was launched on July 30, 2015, at 3:26:13 AM UTC, which is the timestamp of the [Ethereum genesis block](https://etherscan.io/block/0). Frontier launched with a gas limit of 5000. This gas limit was hard coded into the protocol to ensure that miners and users could get up and running by installing clients during the initial launch of the protocol. The gas limit would later be increased to 3 million with the Frontier thawing fork (exactly 3,141,592). The canary contracts were contracts that gave a binary signal of either 0 or 1. These canary contracts were an initial launch mechanism used only during the Frontier release of Ethereum. If clients detected that multiple contracts had switched to a signal of 1, they would stop mining and urge the user to update their client. This prevented prolonged outages by ensuring that miners did not prevent a chain upgrade.

Learn more about Frontier in the following resources:

- [Frontier is coming, whaat to expect and how to prepare](https://blog.ethereum.org/2015/07/22/frontier-is-coming-what-to-expect-and-how-to-prepare)
- [The thawing frontier](https://blog.ethereum.org/2015/08/04/the-thawing-frontier)
- [ethereum.org web archive](https://web.archive.org/web/20150802035735/https://www.ethereum.org/)
- [ethereum-protocol-update-1](https://blog.ethereum.org/2015/08/04/ethereum-protocol-update-1)

## Homestead

Homestead was the second major release of the Ethereum protocol, officially released on March 14, 2016, marking Ethereum’s transition from a beta phase to a more mature and stable platform.
Here are some of the notable features and changes introduced during the Homestead phase:

- [EIP-2](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-2.md): EIP-2 contained numerous fixes, such as increasing the gas cost for contract creation via transactions, ensuring that contract creation either succeeded or failed (preventing empty contracts from being created), and modifications to the difficulty adjustment algorithm. 

  1. **Increased gas cost for contract creation:**
  The gas cost for creating contracts via a transaction was increased from 21,000 to 53,000.
  This change was designed to reduce the excessive incentive to create contracts through transactions rather than through the `CREATE` opcode within contracts, which remained unaffected.
  2. **Invalidation of high s-value signatures:**
  Transaction signatures with an s-value greater than `secp256k1n/2` are now considered invalid.
  This measure addressed a transaction malleability issue, preventing the alteration of transaction hashes by flipping the s-value (`s` -> `secp256k1n - s`).
  This change improved the reliability and integrity of transaction tracking.
  3. **Contract creation out-of-gas handling:**
  If a contract creation did not have enough gas to pay for the final gas fee to add the contract code to the state, the contract creation will fail (i.e., go out-of-gas) rather than leaving an empty contract.
  4. **Change the difficulty adjustment algorithm:**
  The difficulty adjustment algorithm was modified to address issues observed in the Frontier phase.
  The new formula aimed to maintain the targeted block time and prevent excessive deviation by adjusting the difficulty based on the timestamp difference between blocks.

- [EIP-7](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-7.md): EIP-7 introduced the `DELEGATECALL` opcode.

  A new opcode, `DELEGATECALL`, was added at `0xf4`.
  It functions similarly to `CALLCODE`, but propagates the sender and value from the parent scope to the child scope.
  Propagating the sender and value makes it easier for contracts to store another address as a mutable source of code and "pass through" calls to it.
  Unlike the `CALL` opcode, there is no additional stipend of gas added, which makes gas management more predictable.

- [EIP-8](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-8.md): EIP-8 ensures that clients on Ethereum support future network upgrades by introducing devp2p forward compatibility requirements. 

  The **devp2p Wire Protocol**, **RLPx Discovery Protocol**, and **RLPx TCP Transport Protocol** specify that implementations should be liberal in accepting packets by ignoring version numbers and additional list elements in hello and ping packets, discarding unknown packet types silently, and accepting new encodings for encrypted key establishment handshake packets.
  This ensures all client software can cope with future protocol upgrades and will accept handshakes, allowing liberal acceptance of data from others (see [Postel's Law](https://en.wikipedia.org/wiki/Robustness_principle)).

- Learn more about Homestead in the following resources:

- [Ethereum Homestead Documentation](https://readthedocs.org/projects/ethereum-homestead/downloads/pdf/latest/)
- [The Robustness Principle Reconsidered](https://queue.acm.org/detail.cfm?id=1999945)
- [Homestead blog release post](https://blog.ethereum.org/2016/02/29/homestead-release)
- [The Homestead release](https://github.com/ethereum/homestead-guide/blob/master/source/introduction/the-homestead-release.rst)

## The Merge

On September 15, 2022, Ethereum activated [EIP-3675](https://eips.ethereum.org/EIPS/eip-3675) and upgraded the consensus mechanism to proof-of-stake through an event known as The Merge. The Merge has resulted in the deprecation of the proof-of-work consensus, which was previously implemented in the same logic layer as execution. Instead, it has been replaced by a more complex and sophisticated proof-of-stake consensus that eliminates the need for energy-intensive mining. New proof-of-stake consensus has been implemented in its own layer with a separate p2p network and logic, also know as Beacon Chain. The Beacon Chain has been running and achieving consensus since December 1st, 2020. After a prolonged period of consistent performance without any failures, it was deemed ready to become Ethereum's consensus provider. The Merge gets its name from the union of the two networks.

Learn more about The Merge in following resources and reading on Consensus layer. 

 - [EIP-3675: Upgrade consensus to Proof-of-Stake](https://eips.ethereum.org/EIPS/eip-3675), [archived](https://web.archive.org/web/20240213102133/https://eips.ethereum.org/EIPS/eip-3675)
- [Gasper](https://ethereum.org/developers/docs/consensus-mechanisms/pos/gasper), [archived](https://web.archive.org/web/20240214225630/https://ethereum.org/developers/docs/consensus-mechanisms/pos/gasper)
- [Mega Merge Resources List](https://notes.ethereum.org/@MarioHavel/merge-resources), [archived](https://web.archive.org/web/20240302082121/https://notes.ethereum.org/@MarioHavel/merge-resources)
