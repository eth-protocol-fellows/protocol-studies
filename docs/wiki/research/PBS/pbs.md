<!-- @format -->

# Proposer Builder Separation (PBS) in Ethereum

[comment]: <> (Feel Free to propose changes)
[comment]: <> (Introduction)

In Ethereum's current system, validators both create and broadcast blocks. They bundle together transactions that they have discovered through the gossip network and package them into a block which is then sent out to peers on the Ethereum network. 
**Proposer-builder separation (PBS)** splits these tasks across multiple validators. Block builders become responsible for creating blocks and offering them to the block proposer in each slot. The block proposer cannot see the contents of the block, they simply choose the most profitable one, paying a fee to the block builder before sending the block to its peers.


In a broader sense, PBS is a design philosophy[^1] and mechanism in blockchain networks, particularly within the context of Ethereum, that aims to decouple the roles of proposing blocks (proposers) and constructing the content of those blocks (builders). This separation addresses various challenges and inefficiencies associated with block production, especially in proof-of-stake (PoS) systems and in the context of maximizing extractable value (MEV).


This page will be covering details about PBS, roles of block proposers and block builders, current state - mev boost, relays, challenges and security issues, proposed solutions and further collection of resources related to the topic.

## Why is PBS important?

PBS is important to the decentralization of Ethereum because it minimizes the compute overhead that is required to become a validator. By doing this, the network lowers the barrier to entry for becoming a validator and incentives a more diverse group of participants. PBS also reflects an overall goal of The Merge to move Ethereum’s network towards a more modular future. Specifically, the transition to PoS is an aggressive move towards decentralization through modularity.

When you break apart the different pieces of block construction, you can decentralize them individually. This allows different actors with different specialties to focus on their particular strengths. The net result is a more capable network with fewer external dependencies and a lower threshold for participation.

## Understanding PBS and the Consensus layer

As explained in this [article](https://ethos.dev/beacon-chain), slots are the time frames allowed in the consensus layer for a block to be added to the chain, they last 12 seconds and there are 32 of them per epoch. Epochs are significant for the consensus mechanism, serving as checkpoints where the network can finalize blocks, update validator committees, etc. For each slot, a validator is chosen through [RANDAO](https://inevitableeth.com/home/ethereum/network/consensus/randao) to propose a block. Once proposed and added to the canonical chain, the validators chosen for that slot's committees attest to the validity of the block, which shall eventually reach finality. The consensus layer supports Ethereum's network security and integrity. PBS interacts with this layer by dividing/isolating the duties of proposing and building blocks, thereby streamlining the transaction validation process.

### The Role of the builder

**Block builders** gather, validate, and assemble transactions into a block body. They review the mempool, validate the transactions by ensuring that they meet requirements like gas limits and nonce, and create a data structure containing the transaction data. Block builders are also responsible for ordering the transactions to optimize block space and gas usage. They then make the block body available to block proposers.

### The Role of the proposer

**Block proposers** take the block bodies provided by the block builders and create a complete block by adding necessary metadata, such as the block header. The header includes details such as the parent block's hash, timestamp, and other data. They also ensure the validity of the blocks by checking the correctness of the block body provided by the builders.

### Separation Benefits
- **Decentralization and Security**: By allowing proposers to remain unsophisticated entities, PBS aids in maintaining a more decentralized network. It lowers the barrier to entry for becoming a proposer, as they no longer need the infrastructure or knowledge to optimize transaction ordering for MEV.
- **Efficiency and Specialization**: Separating the roles allows each actor to specialize in their respective tasks, leading to more efficient block construction and potentially higher network throughput.
- **Fairness and MEV Distribution**: PBS can help in creating a more competitive and fair environment for MEV extraction, as multiple builders compete to have their blocks chosen by proposers.

### PBS in historical context

- **Pre-MEV-Geth Era:** Before MEV-Geth, there was a form of PBS in the division of labor between a mining pool operator and the workers. The mining pool operator would construct the block body, and the workers would hash the block further. This division of labor also involved a commit-reveal scheme 
 
- **Before the Merge (Proof of Work Era):** The concept of PBS was more explicit in the MEV-Geth world, where a few large mining pools controlled a significant portion of the hash rate. MEV-Geth allowed searchers to send bundles to miners without worrying about the miners stealing them, as the miners' reputation was worth more than the potential gain from stealing the contents of the bundle. This interaction was simpler due to the fewer number of block producers. 

- **Approaching the Merge:** As the merge approached, there was significant discussion about PBS as a general approach. The idea was considered for inclusion in the merge hard fork, but it was eventually discarded due to the complexity it would add to the software and specification, which could slow down the merge process.

- **Introduction of MEV-Boost:**
 - **April 2022:** Stefan from Flashbots posted the original MEV-Boost specification, outlining how proposers could interact with an external block-building network. Work began in the background at the Devconnect meeting on MEV-Day in Amsterdam in '22, finalizing all necessary APIs.
 - **Summer 2022:** Efforts were made to deliver a permissionless relay on open-source software, allowing other relay operators to run it. This was completed just in time for the merge, which included permissionless builder access.

- **MEV-Boost as a Software Solution:** MEV-Boost facilitates the auction between the proposer and the builder, ensuring that the block produced by the builder is valid and accurately pays the proposer. This is achieved through a relay that sits between the proposer and the builder, facilitating the auction process.

- **Current Status Post-Merge:** Immediately after the merge, there were about three or four relays running. Now, there are around 8-10 relays that facilitate most of the MEV-Boost blocks. About 95% of validators are connected to one of these relays and use their connection to source their block production.


## Current State and Solutions

See the [Next Section](/wiki/research/PBS/current-state.md).

Proposer-builder separation may also reduce the likelihood of frontrunning and other harmful practices, even though it may not eliminate MEV-related issues entirely. -->

### Further Reading and Resources

https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710
https://notes.ethereum.org/@vbuterin/pbs_censorship_resistance
https://ethresear.ch/t/proposer-block-builder-separation-friendly-fee-market-designs/9725
https://ethresear.ch/t/two-slot-proposer-builder-separation/10980
[Payload timliness committee design for ePBS](https://ethresear.ch/t/payload-timeliness-committee-ptc-an-epbs-design/16054)
https://notes.ethereum.org/@fradamt/forward-inclusion-lists
https://notes.ethereum.org/@fradamt/H1TsYRfJc#Secondary-auctions

## References
[^1]: https://barnabe.substack.com/p/pbs
