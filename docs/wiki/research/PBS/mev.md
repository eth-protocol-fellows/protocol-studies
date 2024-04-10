<!-- @format -->

# Maximal Extractable Value (previously Miner Extractable Value)

Maximal Extractable Value (MEV) refers to the the maximum value that can be extracted from block production beyond the standard block reward and gas fees by strategically ordering, including, or excluding transactions in a block.

In Ethereum, MEV has gained greater attention as validators extract increasingly more value, especially in DeFi (Decentralized Finance) applications. This can lead to negative consequences, such as front-running, increased transaction fees, and unfair advantages for large-scale miners or validators.

[Proposer-builder separation (PBS)](/wiki/research/PBS/pbs.md) can change the dynamics of MEV extraction in that there could be a redistribution of MEV between the two roles, potentially changing the incentives and rewards associated with each. Since block builders are responsible for transaction ordering and inclusion, they may develop new strategies or promote increased competition that could result in more efficiency and fairer distribution of MEV across the network.

## Evolution of MEV

Maximal Extractable Value (MEV) originated during the proof-of-work Era, where it was known as "Miner Extractable Value." This terminology reflected the miners' ability to influence transaction processes, including their inclusion, exclusion, and sequencing. Following Ethereum's transition to proof-of-stake with The Merge, validators have taken over these critical functions, rendering mining obsolete within the protocol. Despite these changes, the mechanisms for value extraction remain in place, leading to the adoption of the term "Maximal Extractable Value" to address these activities.

Although MEV has been possible since the inception of Ethereum, it gained significant attention with the rise of DeFi and arbitrage tooling like Flashloans. In the early days, MEV opportunities were primarily seized by outbidding rivals in the public mempool, marking the era known as Priority Gas Auction or PGA. Details about this chaotic era is captured in [Flashboys 2.0](https://arxiv.org/abs/1904.05234).

In the Post-Merge world, the concept of Miners ceased to exist. Validators were now the entities responsible to add blocks to the chain. Anticipating the changes after The Merge, Flashbots, along with the client teams and the Ethereum Foundation commenced the development of [mev-boost](/wiki/research/PBS/mev-boost.md). mev-boost is an out-of-protocol implementation of Proposer-builder Separation.

See the [Next Section](/wiki/research/PBS/pbs.md).
