# Consensus Layer (CL) architecture

A consensus algorithm is a mechanism that enables users or machines to coordinate in a distributed setting, ensuring all agents agree on a single source of truth even if some agents fail. 

The Consensus Layer (CL) is a fundamental component that ensures the network's security, reliability, and efficiency. Originally, Ethereum utilized Proof-of-Work (PoW) as its consensus mechanism, similar to Bitcoin. PoW, while effective in maintaining decentralization and security, has significant drawbacks, including high energy consumption and limited scalability. To address these issues, Ethereum has transitioned to Proof of Stake (PoS), a more sustainable and scalable consensus mechanism.

#### Why Consensus Matters

In any distributed system, consensus is crucial to ensure that all participants agree on a single version of the truth. This is especially important in blockchain networks like Ethereum, where maintaining a consistent ledger of transactions is paramount. Consensus algorithms are designed to achieve this agreement even in the presence of faulty or malicious nodes, making the system fault-tolerant. This fault-tolerant (also called [BFT](https://academy.binance.com/en/articles/byzantine-fault-tolerance-explained)) system, essential in decentralized systems, is opposite of what centralized setups use, where a single entity governs decisions.

## Byzantine Fault Tolerance (BFT) and Byzantine Generals' Problem

Byzantine Fault Tolerance (BFT) is a property of distributed systems that allows them to function correctly even when some components fail or act maliciously. BFT is crucial in decentralized networks, where trust among nodes cannot be assumed. In other words, a system exhibiting BFT can tolerate Byzantine faults, which are arbitrary failures that include malicious behavior. For a system to be Byzantine fault-tolerant, it must reach consensus despite these faults.

#### Practical Byzantine Fault Tolerance (pBFT)

pBFT is an algorithm designed to improve the efficiency of achieving BFT in practical applications. It works by having nodes communicate with each other to agree on the system's state. The algorithm operates in several rounds of voting, where nodes exchange messages to confirm the validity of transactions. pBFT ensures that as long as less than one-third of the nodes are faulty, consensus can be achieved.

#### Byzantine Generals' Problem

The Byzantine Generals’ Problem was [conceived](https://www.microsoft.com/en-us/research/uploads/prod/2016/12/The-Byzantine-Generals-Problem.pdf) in 1982 as a logical dilemma that illustrates how a group of Byzantine generals may have communication problems when trying to agree on their next move. It illustrates the difficulty of achieving consensus in a distributed system with potentially faulty nodes. It is framed as a scenario where several Byzantine generals must agree on a coordinated attack plan, but some of them may be traitors trying to prevent consensus.

The dilemma assumes that each general has its own army and that each group is situated in different locations around the city they intend to attack. The generals need to agree on either attacking or retreating. It does not matter whether they attack or retreat, as long as all generals reach consensus, i.e., agree on a common decision in order to execute it in coordination.

- **Requirements**:
    - Each general must decide on whether to attack or retreat.
    - Once the decision is made, it cannot be changed.
    - Communication is only possible via messengers.
    - All generals have to agree on the same decision and execute it in a synchronized manner.

The central challenge of the Byzantine Generals’ Problem is that the messages can get somehow delayed, destroyed or lost. In addition, even if a message is successfully delivered, one or more generals may choose (for whatever reason) to act maliciously and send a fraudulent message to confuse the other generals, leading to a total failure. If we apply the dilemma to the context of blockchains, each general represents a network node, and the nodes need to reach consensus on the current state of the system. Putting in another way, the majority of participants within a distributed network have to agree and execute the same action in order to avoid complete failure. 

Therefore, the only way to achieve consensus in these types of distributed system is by having at least ⅔ or more reliable and honest network nodes. This means that if the majority of the network decides to act maliciously, the system is susceptible to failures and attacks (such as the 51% attack).

In blockchain and distributed ledger systems, the Byzantine Generals' Problem is analogous to nodes (validators or miners) needing to agree on the state of the ledger despite some nodes potentially acting maliciously.



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
