<!-- @format -->

# Current State

Currently, PBS (Proposer Builder Separation) exists outside of the protocol by builders helping in block building through entities like relays. This design relies on small set of trusted relays and even builders which introduces centralisation risks and makes Ethereum more vulnerable to censorship.
PBS is not yet implemented in the Ethereum mainnet which means validators act as both proposers and builders. So each validator is responsible for:

1. **Selecting transactions:** Validators choose which transactions to include in a block based on factors like gas fees and transaction priority.
2. **Building the block:** Validators assemble the chosen transactions into a block and perform necessary computations like verifying signatures and updating the state.
3. **Proposing the block:** Validators propose the constructed block to the network for validation and inclusion in the blockchain.

However, some clients are actively developing and testing PBS implementations. These implementations aim to separate the builder and proposer roles, allowing validators to outsource block construction to specialized builders. This can lead to several potential benefits:

- **Increased validator rewards:** Builders can compete to create the most profitable block for the proposer, potentially leading to higher rewards for validators.
- **Improved network efficiency:** Specialized builders can optimize block construction, leading to more efficient block propagation and processing.
- **Reduced centralization:** By decoupling the roles, PBS can potentially reduce the influence of large mining pools or staking providers that currently dominate both block building and proposing.

## PBS and the Relationship Between Relays, Builders, and Validators

Proposer-Builder Separation (PBS) also introduces a more intricate relationship between different actors in the Ethereum network:

1. **Builders:**
   - Builders are specialized entities that focus on constructing blocks with optimal transaction ordering and inclusion. They compete with each other to create the most profitable block for the proposer, taking into account factors like gas fees, transaction priority, and potential MEV (Maximal Extractable Value).
   - Builders do not directly interact with the blockchain. Instead, they submit their constructed blocks to relays.
   - This submission includes the block's data (transactions, execution payload, etc.) and a bid that they are willing to pay to have their block proposed.
2. **Relays:**
   - Relays receive blocks from multiple builders, confirm their validity and submit the valid block with the highest bid to the escrow for the validator to sign.
   - Relays act as intermediaries between builders and proposers. They receive blocks from builders and forward them to proposers.
   - Relays can perform additional functions like block validation and filtering to ensure that only valid and high-quality blocks are sent to proposers.
   - Some relays may specialize in specific types of blocks, such as those with high MEV potential.
3. **Validators (Proposers):**
   - Under PBS, validators take on the role of proposers. They receive blocks from relays and choose the best one based on predefined criteria, typically the block that offers the highest reward.
   - Once the proposer selects a block, they propose it to the network for validation and inclusion in the blockchain.
   - Validators are still responsible for securing the network and ensuring consensus on the blockchain's state.

This whole process is illustrated in the figure below. See [Flashbots' docs](https://docs.flashbots.net/) for further explanations.

<figure style="text-align: center;">
  <img src="../../images/mev-boost-architecture.png" alt="MEV-Boost architecture">
  <figcaption style="text-align: center;">Outline of the communication between the MEV-Boost PBS participants. Source: <a href="https://ethresear.ch/t/mev-boost-merge-ready-flashbots-architecture/11177">ethresear.ch</a></figcaption>
</figure>

This separation of roles creates a more dynamic and specialized block-building process. Builders can focus on optimizing block construction and extracting MEV, while proposers can focus on selecting the best block and maintaining network security.

However, this new relationship also introduces new challenges.

### Relay Concerns

A case can be made that relays oppose the following Ethereum's core tenets:

- Decentralization: The fact that [six relays](https://www.relayscan.io/overview?t=7d) handle 99% of MEV-Boost blocks (that being nigh on 90% of Ethereum's blocks) gives rise to justified centralization concerns.
- Censorship resistance: Relays _can_ censor blocks and, being centralized, can be coerced by regulators to do so. This happened, for instance, when they were pressured to censor transactions interacting with addresses on the [OFAC sanction list](https://home.treasury.gov/news/press-releases/jy0916).
- Trustlessness: Validators trust relays to provide a valid block header and to publish the full block once signed; builders trust relays not to steal MEV. Although betrayal of either would be detectable, dishonesty can be profitable even through a one-time attack.

### Third party dependency

On a similar note, the fact that PBS entails outsourcing the building of the blocks to entities that do not directly participate in Ethereum consensus could potentially lead to unexpected or unwanted consequences stemming from relying on third parties, such as trust issues, operational dependency and the introduction of single points of failure. Particularly the fact that the use of MEV-Boost is so widespread could be viewed as a dangerous third party dependency, since such a huge portion of Ethereum's new blocks are created using Flashbot's software.

### Security Concerns

As seen in this entry, PBS involves many different entities taking part in the process of adding new blocks to the chain, which inevitably increases the number of potential attack vectors that could be exploited.

As opposed to vanilla block creation in which the validator builds the block and adds it to the chain, PBS brings to the table many possible points of failure, such as the relays or escrows, which could potentially act maliciously or fail in their mission to provide data availability, disrupting the block proposal process, favoring certain builders, etc. Also, the commit-reveal scheme in escrows, if exploited, could give rise to MEV opportunities being stolen from the rightful block builders, undermining their performance.

Of course, validators are still in charge of verifying the data in the blocks to make sure that builders adhere to the rigorous standards that make the Ethereum protocol robust. Thus, the aforementioned concerns are not likely to cause critical issues like the network halting. Nonetheless, the potential for these possible vulnerabilities to impact the fairness and security of block production suggests that they should not be overlooked and further research should be done to have them prevented.

It's important to note that the specific roles and responsibilities of relays and builders may vary depending on the specific PBS implementation.
