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
2. **Relays:**
   - Relays act as intermediaries between builders and proposers. They receive blocks from builders and forward them to proposers.
   - Relays can perform additional functions like block validation and filtering to ensure that only valid and high-quality blocks are sent to proposers.
   - Some relays may specialize in specific types of blocks, such as those with high MEV potential.
3. **Validators (Proposers):**
   - Under PBS, validators take on the role of proposers. They receive blocks from relays and choose the best one based on predefined criteria, typically the block that offers the highest reward.
   - Once the proposer selects a block, they propose it to the network for validation and inclusion in the blockchain.
   - Validators are still responsible for securing the network and ensuring consensus on the blockchain's state.

This separation of roles creates a more dynamic and specialized block-building process. Builders can focus on optimizing block construction and extracting MEV, while proposers can focus on selecting the best block and maintaining network security.

However, this new relationship also introduces new challenges:

- Security: Introducing new actors and dependencies can create new attack vectors and vulnerabilities.
- Centralization: If only a few powerful builders or relays dominate the ecosystem, it could lead to centralization and censorship concerns.
- Coordination: Effective communication and coordination between builders, relays, and proposers are crucial for the smooth functioning of PBS.

It's important to note that the specific roles and responsibilities of relays and builders may vary depending on the specific PBS implementation.
