# Consensus layer

The Ethereum consensus layer defines the mechanism for nodes to agree on the network's state. This layer currently employs Proof-of-Stake (PoS), a crypto-economic system. PoS encourages honest behavior by requiring validators to lock ETH. These validators are responsible for proposing new blocks, validating existing ones, and processing transactions. The protocol enforces rewards and penalties to ensure validator integrity and deter malicious activity.

Validator selection, block voting, and fork resolution are governed by [consensus specification](/wiki/CL/cl-specs.md). In case of competing blocks, the "heaviest" chain, determined by validator support weighted by staked ETH, prevails.

Ethereum consensus layer addresses the fundamental challenge of Byzantine fault tolerance in distributed computing. Similar to the Byzantine Generals Problem, geographically dispersed nodes in the blockchain network must agree on transaction validity despite potential communication issues or malicious actors.

Ethereum uses a consensus mechanism known as Gasper that combines [Casper proof-of-stake](https://arxiv.org/abs/1710.09437) with the [GHOST fork-choice](https://arxiv.org/abs/2003.03052).

## Resources

- Vitalik Buterin et al., [Gasper: Combining GHOST and Casper.](https://arxiv.org/pdf/2003.03052.pdf)
- Martin Kleppmann, [Distributed Systems.](https://www.youtube.com/playlist?list=PLeKd45zvjcDFUEv_ohr_HdUFe97RItdiB)
- Leslie Lamport et al., [The Byzantine Generals Problem.](https://lamport.azurewebsites.net/pubs/byz.pdf)
- Austin Griffith, [Byzantine Generals - ETH.BUILD.](https://www.youtube.com/watch?v=c7yvOlwBPoQ)
