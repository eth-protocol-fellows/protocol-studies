# Protocol history and evolution

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

This page highlights important technical changes in the history of Ethereum protocol. 

Useful links: [Overview from Ethereum.org](https://ethereum.org/en/history) and [Meta EIPs from Ethereum.org](https://eips.ethereum.org/meta)

## Homestead

The first version of Ethereum, called the Frontier release, was essentially a beta release that allowed developers to learn, experiment, and begin building Ethereum decentralized apps and tools.
Homestead was the second major version of the Ethereum platform, officially released on March 14, 2016, marking Ethereum’s transition from a beta phase to a more mature and stable platform.
Here are some of the notable features and changes introduced during the Homestead phase:

- [EIP-2](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-2.md): Homestead Hard-fork Changes

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

Additional Resources:
- [Ethereum Homestead Documentation](https://readthedocs.org/projects/ethereum-homestead/downloads/pdf/latest/)


## The Merge

On September 15, 2022, Ethereum activated [EIP-3675](https://eips.ethereum.org/EIPS/eip-3675) and upgraded the consensus mechanism to proof-of-stake through an event known as The Merge. The Merge has resulted in the deprecation of the proof-of-work consensus, which was previously implemented in the same logic layer as execution. Instead, it has been replaced by a more complex and sophisticated proof-of-stake consensus that eliminates the need for energy-intensive mining. New proof-of-stake consensus has been implemented in its own layer with a separate p2p network and logic, also know as Beacon Chain. The Beacon Chain has been running and achieving consensus since December 1st, 2020. After a prolonged period of consistent performance without any failures, it was deemed ready to become Ethereum's consensus provider. The Merge gets its name from the union of the two networks.

Learn more about The Merge in following resources and reading on Consensus layer. 

 - [EIP-3675: Upgrade consensus to Proof-of-Stake](https://eips.ethereum.org/EIPS/eip-3675), [archived](https://web.archive.org/web/20240213102133/https://eips.ethereum.org/EIPS/eip-3675)
- [Gasper](https://ethereum.org/developers/docs/consensus-mechanisms/pos/gasper), [archived](https://web.archive.org/web/20240214225630/https://ethereum.org/developers/docs/consensus-mechanisms/pos/gasper)
- [Mega Merge Resources List](https://notes.ethereum.org/@MarioHavel/merge-resources), [archived](https://web.archive.org/web/20240302082121/https://notes.ethereum.org/@MarioHavel/merge-resources)
