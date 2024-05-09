# [Protocol Design Philosophy](#protocol-design-philosophy)

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.


These are the core tenets that sparked the work on Ethereum's architeture and imlementation.

- **Simplicity**:
Since its inception, the Ethereum protocol was designed in a way that reduced complexity and made it simpler, even at the cost of data storage inefficiency and time inefficiency. This stemmed from the idea that any average programmer should ideally be able to understand and implement the entire specification -- this was primarily to minimize the influence on the protocol by an individual or an elite group of developers. While this narrative has transmuted largely due to major changes that have been made to the protocol. Further 

- **Universality**:
One of the fundamental doctrine of Ethereum's design philosophy is that Ethereum has no ***features***.
Instead, Ethereum provides an internal Turing-complete scripting language [**solidity**](https://docs.soliditylang.org/en/v0.8.25/), which you can use to construct any smart contract or transaction type that can be mathematically defined. Ethereum tries to become a platform where new age developers can build decentralised and truly trustless applications without being prudent about the underlying complexity. 

- **Modularity**:
Making the Ethereum protocol modular is crucial to it being **future-proof**. While Ethereum is far from being perfect, there is a continuous and rigourous research and engineering effort that runs parallel to the existence of the protocol. Over the course of development, it should be easy to make a small protocol modification in one place and have the application stack continue to function without any further modification. Innovations such as Dagger, Patricia trees and RLP should be implemented as separate libraries and made to be feature-complete even if Ethereum does not require certain features so as to make them usable in other protocols as well. Ethereum development should be maximally done so as to benefit the entire cryptocurrency ecosystem, not just itself.

- **Non-discriminant**:
Ethereum was born out of the pillars set by various movements like [**FOSS**]() and [**Cypherpunk**](). And non-discrimination is foundational to fabric of Ethereum's design philosophy. The protocol should not attempt to actively restrict or prevent specific categories of usage, and all regulatory mechanisms in the protocol should be designed to directly regulate the harm, not attempt to oppose specific undesirable applications. You can even run an infinite loop script on top of Ethereum for as long as you are willing to keep paying the per-computational-step transaction fee for it.

- **Agility**:
Details of the Ethereum protocol are not set in stone. It's crucial to be extremely judicious about making modifications to high-level contructs such as solidity and the address system, computational tests later on in the development process may lead to dicovery that certain modifications to the algorithm or scripting language will substantially improve scalability or security. If any such opportunities are found, they will be utilized.


# [Principles](#principles)

The Ethereum protocol evolves and changes over time but it always follow certain principles. These principles reflect values of the whole community and are reflected in some of the main design decisions of Ethereum.

- **Managing Complexity**:
There has been a continuous ongoing research on the tradeoffs between systemic complexity and encapsulated complexity
    - **Sandwich model complexity**:
    - **Encapsulated complexity**:

- **encapsulated complexity**: 

- **Freedom**:

- **Generalization**:

- **We have no features**:

- **Non-risk-aversion**:



# [Blockchain level protocol](#blockchain-level-protocol)

### Accounts over UTXOs

### Merkle patricia trie

### Introduction to verkle

### Recursive Length Prefix (RLP)

### Simple serialize (SSZ)

### Compression Algorithm

### Trie trinity 

### Gasper 

### Gas and Fee

### Virtual Machine 
 
# References

- https://web.archive.org/web/20211121044757/https://ethereumbuilders.gitbooks.io/guide/content/en/design_rationale.html

- https://vitalik.eth.limo/general/2022/02/28/complexity.html