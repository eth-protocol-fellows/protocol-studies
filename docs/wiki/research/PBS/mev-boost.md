# Mev-boost: A popular PBS Implementation

[Mev-boost](https://github.com/flashbots/mev-boost) is a widely recognized, out-of-the-protocol, open-source implementation of Proposer-Builder Separation (PBS) for Ethereum. It allows validators to outsource block building to specialized builders, potentially leading to increased validator rewards and improved network efficiency.

Here's how mev-boost works:

<figure style="text-align: center;">
  <img src="images/pbs/block-building.png" alt="Block-building">
  <figcaption style="text-align: center;">Current Block building. Source: <a href="https://barnabe.substack.com/p/pbs">Barnabé's article</a></figcaption>
</figure>

On one side, mev-boost implements the [builder API](https://github.com/ethereum/builder-specs) used by an Ethereum node to outsource it block production. On the other, it connects to a network of relays and handles the communication between builders and proposers.

1. **Block Building:**
   Specialized builders compete to create the most profitable block for the proposer. They do this by optimizing transaction ordering and inclusion, taking into account factors like gas fees, transaction priority, and potential [MEV (Maximal Extractable Value)](/docs/wiki/research/PBS/mev.md).
   Builders submit their constructed blocks to relays.
2. **Relay Network:**
   Mev-boost operates a network of relays that act as intermediaries between builders and proposers.
   Relays receive blocks from builders and perform various functions like block validation, filtering, and propagation.
   Relays ensure that only valid and high-quality blocks are sent to proposers.
3. **Proposer Selection:**
   Validators run mev-boost software connected to their beacon node. When a validator is chosen to propose a block, they receive blocks from relays and choose the best one based on predefined criteria, typically the block that offers the highest reward.
   The validator then proposes the selected block to the network for validation and inclusion in the blockchain.

## PBS Block Creation

The process of block creation through PBS works as follows:

### Block Construction

- Builders continuously monitor the transaction pool (mempool) for new transactions. They assess these transactions based on potential MEV opportunities. They select the transactions that best align with their MEV optimization criteria. Also, block builders can take transaction bundles from private orderflows, or from MEV searchers, just as miners did in PoW Ethereum with the original Flashbots auctions. In the latter case, builders accept sealed-price bids from searchers and include their bundles in the block.
- Once the transactions are selected, builders assemble them into a block ensuring that the block adheres to the Ethereum protocol's rules, e. g., txs are valid, the gas limit is not surpassed.

### Block Auction

Instead of builders directly offering their assembled blocks to validators with a specified price, the standard practice is to use relays. Relays validate the transaction bundles before passing the Headers onto the proposer (validator). The proposer accepts and signs the Header with their key, and returns the SignedHeader to the Relay. Now, the Relay releases the Full Block to the Proposer. Also, implementations can introduce escrows responsible for providing data availability by storing blocks sent by builders and commitments sent by validators. 

### Benefits of mev-boost:

- **Increased validator rewards:** By outsourcing block building to specialized builders, validators can potentially earn higher rewards through optimized transaction ordering and MEV extraction.
- **Reduced centralization:** Mev-boost enables a more competitive block-building landscape, reducing the economy of scale of large mining pools and enabling home stakers achieve same kind of rewards.

### Challenges and Considerations:

While mev-boost offers certain benefits, it also raises some concerns:

- **Security:** Introducing new actors and dependencies can create new attack vectors and vulnerabilities. There have been multiple [incidents](https://collective.flashbots.net/t/post-mortem-april-3rd-2023-mev-boost-relay-incident-and-related-timing-issue/1540) of missed blocks on mainnet due to mev-boost issues. 
- **Censorship resistance:** If only a few powerful builders or relays dominate the ecosystem, it could lead to centralization and censorship concerns.
- **Coordination:** Effective communication and coordination between builders, relays, and proposers are crucial for the smooth functioning of mev-boost.

It's important to note that mev-boost is just one implementation of PBS. Other implementations with different designs and features are also being developed and explored, for example [mev-rs](https://github.com/ralexstokes/mev-rs) is under development.

Overall, mev-boost represents a significant step towards realizing the potential benefits of PBS in Ethereum. However, continuous research and development are crucial to address the challenges and ensure a secure, decentralized, and efficient implementation. One path towards more stable PBS model is [enshrining it in the protocol](/docs/wiki/research/PBS/ePBS.md), adding mev-boost like features directly to the Ethereum clients.  

## Resources

- [Flashbots docs on mev-boost](https://boost.flashbots.net/)
- [Overview of censoring entities](https://censorship.pics/) 
- https://www.mevwatch.info/
- [MEV-Boost: Merge ready Flashbots Architecture, 2021](https://ethresear.ch/t/mev-boost-merge-ready-flashbots-architecture/11177)
