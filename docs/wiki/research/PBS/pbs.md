<!-- @format -->

# Proposer Builder Separation (PBS)

In Ethereum's current system, validators both create and broadcast blocks. They bundle together transactions that they have discovered through the gossip network and package them into a block which is then sent out to peers on the Ethereum network. **Proposer-builder separation (PBS)** splits these tasks across multiple validators. Block builders become responsible for creating blocks and offering them to the block proposer in each slot. The block proposer cannot see the contents of the block, they simply choose the most profitable one, paying a fee to the block builder before sending the block to its peers.

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

### Further Reading and Resources

Below are some further readings regarding PBS and related topics:

- [Notes on Proposer-Builder Separation (PBS)](https://barnabe.substack.com/p/pbs)
- [Timing Games and Implications on MEV extraction](https://chorus.one/articles/timing-games-and-implications-on-mev-extraction)
- [Why ePBS](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710)
- [Vitalik on pbs censorship](https://notes.ethereum.org/@vbuterin/pbs_censorship_resistance)
- [Payload timliness committee design for ePBS](https://ethresear.ch/t/payload-timeliness-committee-ptc-an-epbs-design/16054)
- [2-slot PBS](https://ethresear.ch/t/two-slot-proposer-builder-separation/10980)
- [Foward Inclusion Lists](https://notes.ethereum.org/@fradamt/forward-inclusion-lists)
