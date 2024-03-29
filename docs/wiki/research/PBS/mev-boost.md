<!-- @format -->

# Mev-boost: A Popular PBS Implementation

[comment]: <> (This is still unrefined)

Mev-boost is a widely recognized open-source implementation of Proposer-Builder Separation (PBS) for Ethereum. It allows validators to outsource block building to specialized builders, potentially leading to increased validator rewards and improved network efficiency.
Here's how mev-boost works:

<figure style="text-align: center;">
  <img src="images/pbs/block-building.png" alt="PBS">
  <figcaption style="text-align: center;">Current Block building. Source: <a href="https://barnabe.substack.com/p/pbs">Baranabé's article</a></figcaption>
</figure>

1. **Block Building:**
   Specialized builders, known as "searchers" in mev-boost, compete to create the most profitable block for the proposer. They do this by optimizing transaction ordering and inclusion, taking into account factors like gas fees, transaction priority, and potential MEV (Maximal Extractable Value).
   Searchers submit their constructed blocks to relays.
2. **Relay Network:**
   Mev-boost operates a network of relays that act as intermediaries between searchers and proposers.
   Relays receive blocks from searchers and perform various functions like block validation, filtering, and propagation.
   Relays ensure that only valid and high-quality blocks are sent to proposers.
3. **Proposer Selection:**
   Validators running mev-boost software act as proposers. They receive blocks from relays and choose the best one based on predefined criteria, typically the block that offers the highest reward.
   The proposer then proposes the selected block to the network for validation and inclusion in the blockchain.

## PBS Block Creation

The process of block creation through PBS works as follows:

### Block Construction

- Builders continuously monitor the transaction pool (mempool) for new transactions. They assess these transactions based on potential MEV opportunities. They select the transactions that best align with their MEV optimization criteria. Also, block builders can take transaction bundles from private orderflows, or from MEV searchers, just as miners did in PoW Ethereum with the original Flashbots auctions. In the latter case, builders accept sealed-price bids from searchers and include their bundles in the block.
- Once the transactions are selected, builders assemble them into a block ensuring that the block adheres to the Ethereum protocol's rules, e. g., txs are valid, the gas limit is not surpassed.

### Block Auction

Instead of builders directly offering their assembled blocks to validators with a specified price, the standard practice is to use relays. Relays validate the transaction bundles before passing them onto the proposer (validator). Also, implementations can introduce escrows responsible for providing data availability by storing blocks sent by builders and commitments sent by validators. The auction process works as follows:

### Benefits of mev-boost:

- **Increased validator rewards:** By outsourcing block building to specialized searchers, validators can potentially earn higher rewards through optimized transaction ordering and MEV extraction.
- **Improved network efficiency:** Specialized searchers can optimize block construction, leading to more efficient block propagation and processing.
- **Reduced centralization:** Mev-boost promotes a more competitive block-building landscape, potentially reducing the influence of large mining pools or staking providers.

### Challenges and Considerations:

While mev-boost offers potential benefits, it also raises some concerns:

- **Security:** Introducing new actors and dependencies can create new attack vectors and vulnerabilities.
- **Centralization:** If only a few powerful searchers or relays dominate the ecosystem, it could lead to centralization and censorship concerns.
- **Coordination:** Effective communication and coordination between searchers, relays, and proposers are crucial for the smooth functioning of mev-boost.

Ongoing research and development are focused on addressing these challenges and ensuring that mev-boost can be implemented safely and effectively.

It's important to note that mev-boost is just one implementation of PBS. Other implementations with different designs and features are also being developed and explored.
Overall, mev-boost represents a significant step towards realizing the potential benefits of PBS in Ethereum. However, continuous research and development are crucial to address the challenges and ensure a secure, decentralized, and efficient implementation.

### Challenges and Solutions

PBS presents several challenges, including potential security vulnerabilities and the risk of centralization. Ongoing research focuses on addressing these concerns through innovations such as enhanced PBS (ePBS), inclusion lists, and the Proposal Eligibility Proposals Committee (PEPC).
