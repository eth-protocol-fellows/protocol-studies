# Execution p2p

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

The execution layer implements [devp2p](https://github.com/ethereum/devp2p) as its communication protocol with nodes in the network. It includes various subprotocols and features: eth, snap, les, pip, wit. 

Because libp2p (used by CL) was not ready when Ethereum was created, devp2p was created as Ethereum's own p2p protocol stack. 