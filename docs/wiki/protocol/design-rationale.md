# [Protocol Design Philosophy](#protocol-design-philosophy)

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.


These are the core tenets that sparked the work on Ethereum's architeture and imlementation.

- **Simplicity**:
Since its inception, the Ethereum protocol was designed in a way that reduced complexity and made it simpler, even at the cost of data storage inefficiency and time inefficiency. This stemmed from the idea that any average programmer should ideally be able to understand and implement the entire specification -- primarily to minimize the influence on the protocol by an individual or an elite group of developers. While this narrative has transmuted largely due to major changes that have been made to the protocol. Further 

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

- **Managing Complexity**: One of the main goals of Ethereum protocol design is to minimize complexity: make the protocol as simple as possible, while still making a blockchain that can do what an effective blockchain needs to do. The Ethereum protocol is far from perfect at this, especially since much of it was designed in 2014-16 when we understood much less, but we nevertheless make an active effort to reduce complexity whenever possible.
One of the challenges of this goal, however, is that complexity is difficult to define, and sometimes, you have to trade off between two choices that introduce different kinds of complexity and have different cost
    1. **Sandwich model complexity**:  The sandwich model focused simplifying the bottom layer of the architecture of Ethereum and the interface to Ethereum should be as easy to understand as possible. Where complexity is inevitable, it should be pushed into the "middle layers" of the protocol, that are not part of the core consensus but are also not seen by end users - high-level-language compilers, argument serialization and deserialization scripts, storage data structure models, the leveldb storage interface and the wire protocol, etc.
    2. **Encapsulated complexity**: This occurs when there is a system with sub-systems that are internally complex, but that present a simple "interface" to the outside. Systemic complexity occurs when the different parts of a system can't even be cleanly separated, and have complex interactions with each other. Often, the choice with less encapsulated complexity is also the choice with less systemic complexity, and so there is one choice that is obviously simpler. But at other times, you have to make a hard choice between one type of complexity and the other. What should be clear at this point is that complexity is less dangerous if it is encapsulated. The risks from complexity of a system are not a simple function of how long the specification is; a small 10-line piece of the specification that interacts with every other piece adds more complexity than a 100-line function that is otherwise treated as a black box. Here are few [examples](https://vitalik.eth.limo/general/2022/02/28/complexity.html)
The preference order for where the complexity goes in: layer 2 > client implementation > protocol spec

- **Freedom**: Users should not be restricted in what they use the Ethereum protocol for, and we should not attempt to preferentially favor or disfavor certain kinds of Ethereum contracts or transactions based on the nature of their purpose. This is similar to the guiding principle behind the concept of "net neutrality". One example of this principle not being followed is the situation in the Bitcoin transaction protocol where use of the blockchain for "off-label" purposes (eg. data storage, meta-protocols) is discouraged, and in some cases explicit quasi-protocol changes (eg. OP_RETURN restriction to 40 bytes) are made to attempt to attack applications using the blockchain in "unauthorized" ways. In Ethereum, instead strongly favor the approach of setting up transaction fees in such a way as to be roughly incentive-compatible, such that users that use the blockchain in bloat-producing ways internalize the cost of their activities (ie.[Pigovian taxation](https://en.wikipedia.org/wiki/Pigouvian_tax)).  

- **Generalization**: Protocol features and opcodes in Ethereum should embody maximally low-level concepts, so that they can be combined in arbitrary ways including ways that may not seem useful today but which may become useful later, and so that a bundle of low-level concepts can be made more efficient by stripping out some of its functionality when it is not necessary. An example of this principle being followed is our choice of a LOG opcode as a way of feeding information to (particularly light client) dapps, as opposed to simply logging all transactions and messages as was internally suggested earlier - the concept of "message" is really the agglomeration of multiple concepts, including "function call" and "event interesting to outside watchers", and it is worth separating the two.

- **We have no features**:  As a corollary to generalization, we often refuse to build in even very common high-level use cases as intrinsic parts of the protocol, with the understanding that if people really want to do it they can always create a sub-protocol (eg. ether-backed subcurrency, bitcoin/litecoin/dogecoin sidechain, etc) inside of a contract. An example of this is the lack of a Bitcoin-like "locktime" feature in Ethereum, as such a feature can be simulated via a protocol where users send "signed data packets" and those data packets can be fed into a specialized contract that processes them and performs some corresponding function if the data packet is in some contract-specific sense valid.




# [Blockchain level protocol](#blockchain-level-protocol)

### Accounts over UTXOs


### Merkle patricia trie

### Introduction to verkle

### Recursive Length Prefix (RLP)

### Simple serialize (SSZ)


### Gasper 

### Gas and Fee

### Virtual Machine 
 
# References

- https://web.archive.org/web/20211121044757/https://ethereumbuilders.gitbooks.io/guide/content/en/design_rationale.html

- https://vitalik.eth.limo/general/2022/02/28/complexity.html
