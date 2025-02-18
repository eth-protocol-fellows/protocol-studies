# Consensus layer specification 

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

The Ethereum network began its journey as a proof-of-work (PoW) blockchain, designed to transition to a proof-of-stake (PoS) consensus mechanism after its initial bootstrap phase. This transition is pivotal for enhancing scalability, security, and sustainability within the Ethereum ecosystem. The research that facilitated this shift culminated in a consensus mechanism that combines the principles of Casper and GHOST, as articulated in the [Gasper paper](https://arxiv.org/abs/2003.03052).

Consensus Mechanism
Casper: This is a family of PoS protocols that ensures validators are incentivized to act honestly. It introduces slashing conditions, where malicious or negligent behavior can lead to a loss of staked assets, thereby promoting a secure and reliable network.

GHOST (Greedy Heaviest Observed Subtree): This protocol enhances the efficiency of block propagation and finality by allowing nodes to consider not just the longest chain but also the heaviest subtree of blocks. This approach helps in reducing the impact of stale blocks and improves the overall throughput of the network.

Pyspec: The Executable Specification
To formalize the consensus mechanism, a specification was developed in Python, known as [Pyspec](https://github.com/ethereum/consensus-specs). This specification serves several critical functions:

Executable Reference: Pyspec is an executable specification that provides a clear and practical reference for developers working on the consensus layer. It allows developers to run the specification directly, ensuring that they can test and validate their implementations against the defined consensus rules.

Client Implementation: Pyspec serves as a foundational reference for client implementations. Various Ethereum clients (like Geth, Lighthouse, Prysm, etc.) can refer to Pyspec to ensure they adhere to the same consensus rules and logic, promoting interoperability among different clients.

Test Case Generation: One of the key features of Pyspec is its ability to generate test case vectors for clients. These test vectors are essential for rigorous testing and validation of client implementations, ensuring that they behave correctly under various scenarios and edge cases.

## Resource

[How to use Executable Consensus Pyspec by Hsiao-Wei Wang | Devcon Bogotá](https://www.youtube.com/watch?v=ZDUfYJkTeYw)
