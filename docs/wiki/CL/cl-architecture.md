# CL Client architecture

A consensus algorithm is a mechanism that enables users or machines to coordinate in a distributed setting, ensuring all agents agree on a single source of truth even if some agents fail. This fault-tolerant (also called [BFT](https://academy.binance.com/en/articles/byzantine-fault-tolerance-explained)) system, essential in decentralized systems, contrasts sharply with centralized setups where a single entity governs decisions.

In a decentralized setup, such as a distributed database, reaching agreement on new entries is complex, especially when participants may not trust each other. Overcoming this challenge was crucial for the development of blockchains. Consensus algorithms are vital for the functioning of cryptocurrencies and distributed ledgers.



Beacon Chain clients are implementing various fundamental features: 

- Forkchoice mechanism 
- Engine API for communication with the execution client
- Beacon APIs for validators and users
- libp2p protocol for communication with other CL clients

## Resources

- Vitalik Buterin, ["Parametrizing Casper: the decentralization/finality time/overhead tradeoff"](https://medium.com/@VitalikButerin/parametrizing-casper-the-decentralization-finality-time-overhead-tradeoff-3f2011672735)
- Ethereum, ["Eth2: Annotated Spec"](https://github.com/ethereum/annotated-spec)
- Martin Kleppmann, [Distributed Systems.](https://www.youtube.com/playlist?list=PLeKd45zvjcDFUEv_ohr_HdUFe97RItdiB)
- Leslie Lamport et al., [The Byzantine Generals Problem.](https://lamport.azurewebsites.net/pubs/byz.pdf)
- Austin Griffith, [Byzantine Generals - ETH.BUILD.](https://www.youtube.com/watch?v=c7yvOlwBPoQ)
- Michael Sproul, ["Inside Ethereum"](https://www.youtube.com/watch?v=LviEOQD9e8c) 
