# Maximal Extractable Value (previously Miner Extractable Value)

Maximal Extractable Value (MEV) refers to the the maximum value that can be extracted from block production beyond the standard block reward and gas fees by strategically ordering, including, or excluding transactions in a block.

In Ethereum, MEV has gained greater attention as validators extract increasingly more value, especially in DeFi (Decentralized Finance) applications. Arbitrage opportunities facilitated by strategies like front-running, sandwiching or back-running are possible by ordering transactions in the block. This can also lead to negative consequences, such as unfair advantages for large-scale pools, censorship or increased slippage for DeFi users.

[Proposer-builder separation (PBS)](/wiki/research/PBS/pbs.md) can change the dynamics of MEV extraction in that there could be a redistribution of MEV between the two roles, potentially changing the incentives and rewards associated with each. Since block builders are responsible for transaction ordering and inclusion, they may develop new strategies or promote increased competition that could result in more efficiency and fairer distribution of MEV across the network.

## Evolution of MEV

Maximal Extractable Value (MEV) originated during the proof-of-work era, where it was known as "Miner Extractable Value." This terminology reflected the miners' ability to influence transaction order in the block, including their inclusion, exclusion, and sequencing. Following Ethereum's transition to proof-of-stake with The Merge, validators have taken over the consensus, rendering mining obsolete within the protocol. Despite these changes, the mechanisms for value extraction remain in place, leading to the adoption of the term "Maximal Extractable Value" to address these activities.

Although MEV has been possible since the inception of Ethereum, it gained significant attention with the rise of DeFi and more accessible tooling. In the early days, MEV opportunities were primarily seized by outbidding rivals in the public mempool, marking the era known as Priority Gas Auction or PGA. Details about this chaotic era is captured in [Flashboys 2.0](https://arxiv.org/abs/1904.05234). During that time, [Flashbots](https://www.flashbots.net/) came out as open R&D initiative to improve public knowledge and access to MEV tools. 

In the Post-Merge world, the concept of miners ceased to exist but their builder and proposer role is facilitated by validators, responsible to add blocks to the chain in the same way. Anticipating the changes after The Merge, Flashbots, along with the client teams and the Ethereum Foundation commenced the development of [mev-boost](/wiki/research/PBS/mev-boost.md). MEV-boost is an out-of-protocol implementation of Proposer-builder Separation. See the [section on PBS](/wiki/research/PBS/pbs.md).

## Resources

- [A study of the transaction supply chain from CryptoKitties to MEV-Boost to PBS - Barnabé Monnot](https://www.youtube.com/watch?v=jQjBNbEv9Mg)
- [MEV Day playlist](https://www.youtube.com/playlist?list=PLRHMe0bxkuel3w3C7P_WVvp9ShLi3HKRI)
- [How to light up dark forest - Flashbots](https://collective.flashbots.net/t/how-to-light-up-the-dark-forest-a-walkthrough-of-building-a-cryptopunk-mev-inspector/881)