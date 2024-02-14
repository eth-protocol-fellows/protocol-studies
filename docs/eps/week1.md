# Week 1

The first week of the study group is dedicated to general introduction to the protocol and R&D ecosystem. 

Come to see the presentation by Mário Havel on [Monday, February 19, 4PM UTC](https://savvytime.com/converter/utc-to-germany-berlin-united-kingdom-london-ny-new-york-city-ca-san-francisco-china-shanghai-japan-tokyo-australia-sydney/feb-12-2024/4pm). Recording will be shared here.

## Prehistory and Philosophy

To understand Ethereum design, we need to learn about predecessors and culture it builds upon. The modern cryptocurrency ecosystem stands on decades of work of computer scienticts, cryptographers and activists. 

Starting all the way back in 1960s, UNIX is an operating system and philosophy that redifined entire paradigm of computation. This is the paradigm we have been using over 50 years and never really changed. It's fundamental concept of modularity is important to Ethereum design and open collaborative enviroment of Bell Labs is similar to Ethereum core development today. 

> Check this documentary with Dennis Ritchie and Ken Thompson which perfectly catches spirit and ideas behind UNIX: https://yewtu.be/watch?v=tc4ROCJYbm0

Free Software movement is fundamental to Ethereum and all cryptocurrencies. The open, independent and collaborative development culture of Ethereum is strongly rooted in FOSS (Free and Open Source Software). Ethereum needs to be transparently implemented in software which gives full freedom to its users. Using any FOSS can empower every user and developer but it's necessary for security, neutrality and trustless nature of Ethereum. 

> Check this talk by Richard Stallman, the founder of Free Software and GNU project:
> - https://yewtu.be/watch?v=Ag1AKIl_2GM
> - More reading: https://www.gnu.org/philosophy/free-sw.html, *The Cathedral and the Bazaar* book: http://www.catb.org/~esr/writings/cathedral-bazaar/

The invention of [asymmetric cryptography](https://www-ee.stanford.edu/~hellman/publications/24.pdf) marks the birth of a new paradigm for cryptography applications. Later, the rise of cryptography in computation for general public enabled everyone to utilize tools for digital privacy, secure communication and fundamentaly transformed cybersecurity. While nation states did not have a framework for these new concepts, [Crypto Wars](https://en.wikipedia.org/wiki/Crypto_Wars) resulted in activist movements advocating and building cryptography tools. Ultimately, these were people inventing tools and ideas which became fundamental building blocks of modern cryptocurrencies. 

> Get inspiration from early Cypherpunks who envisioned an independent digital realm built on trustless and borderless technologies:
> - https://activism.net/cypherpunk/manifesto.html
> - https://activism.net/cypherpunk/crypto-anarchy.html
> - https://www.eff.org/cyberspace-independence

## Ethereum Protocol Design 

Originally outlined in its [Whitepaper](https://ethereum.org/whitepaper#ethereum-whitepaper), Ethereum draws inspiration from Bitcoin and its background (explained above) to create a general blockchain based computation platform. The design was technically specified in [Yellowpaper](https://ethereum.github.io/yellowpaper/paper.pdf) and evolved over time. Current specification and changes are tracked in community process of [EIPs](https://eips.ethereum.org) and implemented in Python as: 

- [Execution specs](https://github.com/ethereum/execution-specs)
- [Consensus specs](https://github.com/ethereum/execution-specs)

The protocol changes over time with each network upgrade bringing new improvements. Despite its constant changes, the architecture evolution reflects certain fundamental principles. These can be summarized as following: 

- Simplicity, Universality, Modularity, Non-discrimination, Agility

These core tenets always led the Ethereum development and should be considered with every decision on design change. In addition to this, it manages growing complexity but encapsulating it and/or sandwiching it. The current network architecture is result of many iterations of [network upgrade history](https://ethereum.org/history).

> Read more about Ethereum design principles in [the archive](https://web.archive.org/web/20220815014507mp_/https://ethereumbuilders.gitbooks.io/guide/content/en/design_philosophy.html) and consider rewriting it for [this wiki](/wiki/protocol/design-rationale.md)

Ethereum continues evolving to address the latest research, new and always present challenges. To maintain security and decentralization, blockchain technology has certain limits, mainly its scalability. Because Ethereum needs to always adhere to its principles, it motivates us to find clever for these problems rather than accepting trade-offs. 

The current research and development is summarizied by the [roadmap](https://twitter.com/VitalikButerin/status/1741190491578810445/photo/1) overview, however cannot be fully accurate. There is no single path for Ethereum R&D, the roadmap only sums up its current landscape. The core ecosystem is an always growing [infinite garden](https://ethereum.foundation/infinitegarden). However, with more and more progress, Ethereum might slowly approach an ossification. 

> Simplified overview of the current Ethereum design can be found documentation on [node architecture](https://ethereum.org/developers/docs/nodes-and-clients/node-architecture) and in week 1 presentation

## Implementations and Development

Everything mentioned above - the ideas, design and specifications comes down to actual application here, in its implementation. An implementation of the execution layer (EL) or consensus layer (CL) is called a *client*. A computer running this client and connecting to the network is called a *node*. A node is therefore an a pair of EL and CL client actively participating in the network. 

Since Ethereum is formally specified, it can be implemented in different ways in any language. This results in a variety of implementations throughout the years with some already deprecated and some just being developed. The current list of production ready implementations can be found in [docs on Nodes and clients](https://ethereum.org/en/developers/docs/nodes-and-clients#execution-clients) and week 1 presentation. 

> This strategy is called [client diversity](https://ethereum.org/developers/docs/nodes-and-clients/client-diversity). Ethereum does not rely on a single 'official' implementation but users can choose any client and be sure it does the job. If an issue occurs within a single client implementation, it doesn't affect rest of the network. 

### Testing

With regular changes and multiple client implementations, testing is fundamental for the network security. There is a variety of testing tools and scenarios which are all heavily utilized before any network upgrade. 

Tests are generated based on specifications and create various scenarios. Some are testing clients individualy, some are simulating a testnet with all client pairs. There are different testing tools used for different parts of develpment cycles and parts of clients. This includes state transition testing, fuzzing, shadow forks, RPC tests, client unit tests and CI/CD, etc. 

> Here is a short list of repositories dedicated to testing: 
> - https://github.com/ethereum/tests
> - https://github.com/ethereum/retesteth
> - https://github.cosm/ethereum/execution-spec-tests
> - https://github.com/ethereum/hive
> - https://github.com/kurtosis-tech/kurtosis
> - https://github.com/MariusVanDerWijden/FuzzyVM
> - https://github.com/lightclient/rpctestgen

### Coordination

The Ethereum development is very different to a traditional corporate kind of projects. First of all, it's all open and public, anybody can review it or contribute. And second, there are many different teams working on different parts. All together, are is around 20 different teams from various organizations working on Ethereum. 

Unlike in proprietary tech, Ethereum developers are not competing bur rather working together. With the complexity always growing, there are basically no people who would be experts in all of the Ethereum. Instead, people develop expertise in specific domains and collaborate with others. This is possible thanks to modularity of Ethereum and allows for developers to focus on challenges they personally prefer. 

> The traditional development cycle for new features or changes is `Idea - Research - Development - Testing - Adoption`. However, problems might ocur at any moment of this cycle resulting in iterating again from beginning. 

To be able to ship network upgrades and agree on current development focus, there needs to be a certain coordination. All of it is also public and can be followed by anyone interested in learning about the core protocol. The coordination mainly happens via regular calls which are scheduled in the [PM repo](https://github.com/ethereum/pm). There are different kinds of developer calls with the biggest one being All Core Devs (ACD). This is where representatives of all involved teams come to discuss current development of consensus or execution layer.

Lots of importantnt discussion is also happening in R&D Discord server (ping us in EPFsg discord to get an invite) and in other domain specific calls. There are also offsites or workshops where many core developers meet in person to speed up the process face to face. 

## Aditional reading 

To explore various domains in the Ethereum protocol, check out what people have been working on within EPF:
https://github.com/eth-protocol-fellows/cohort-three/tree/master/projects
https://github.com/eth-protocol-fellows/cohort-four/tree/master/projects