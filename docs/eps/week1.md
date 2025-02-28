# Study Group Lecture 1 | Protocol Intro

The first day of the study group is dedicated to a general introduction to the protocol and R&D ecosystem.

## Recording

Watch _Ethereum Protocol 101_ talk by Mario Havel [on StreamEth](https://streameth.org/watch?event=&session=65d77e4f437a5c85775fef9d). [Slides](https://github.com/eth-protocol-fellows/protocol-studies/tree/main/docs/eps/presentations/week1_protocol_intro.pdf)

[recording](https://streameth.org/embed/?playbackId=9bc1ekw2jk5sz6c7&vod=true&streamId=&playerName=Intro+to+Ethereum+%7C+Mario+Havel+%7C+Week+1 ':include :type=iframe width=100% height=520 frameborder="0" allow="fullscreen" allowfullscreen')

For archive of the discussion during the talk, check the corresponding thread in `#study-group` channel of [Discord server](https://discord.gg/epfsg).

## Pre-reading

This is an introductory talk which doesn't assume a lot of prior knowledge. Check some general requirements in [week 0](/eps/week0.md). Here are few more introductory materials to get you started:

- [Inevitable Ethereum - World Computer](https://inevitableeth.com/home/ethereum/world-computer)
- [Ethereum in 30 minutes](https://www.youtube.com/watch?v=UihMqcj-cqc)
- [Ethereum.org docs](https://ethereum.org/what-is-ethereum)

Check out resources within the following text and additional reading. All resources will be explained in the week 1 presentation.

## Prehistory and Philosophy

To understand Ethereum design, we need to learn about predecessors and the culture it builds upon. The modern cryptocurrency ecosystem stands on decades of work by computer scientists, cryptographers and activists.

Starting all the way back in the 1960s, UNIX is an operating system and philosophy that redefined the entire paradigm of computation. This is the paradigm we have been using for over 50 years and has never really changed. Its fundamental concept of modularity is important to Ethereum design and open collaborative environment of Bell Labs is similar to Ethereum core development today.

> Check this documentary with Dennis Ritchie and Ken Thompson, which perfectly captures spirit and ideas behind UNIX: https://www.youtube.com/watch?v=tc4ROCJYbm0

The Free Software movement is fundamental to Ethereum and all cryptocurrencies. The open, independent and collaborative development culture of Ethereum is strongly rooted in FOSS (Free and Open Source Software). Ethereum needs to be transparently implemented in software that gives full freedom to its users. Using any FOSS can empower every user and developer, but it's necessary for security, neutrality and trustless nature of Ethereum.

> To understand its importance, watch this talk by Richard Stallman, the founder of Free Software and GNU project:
>
> - https://www.youtube.com/watch?v=Ag1AKIl_2GM
> - More reading: https://www.gnu.org/philosophy/free-sw.html, _The Cathedral and the Bazaar_ book: http://www.catb.org/~esr/writings/cathedral-bazaar/

The invention of [asymmetric cryptography](https://www-ee.stanford.edu/~hellman/publications/24.pdf) marks the birth of a new paradigm for cryptography applications. Later, the rise of cryptography in computation for general public enabled everyone to utilize tools for digital privacy, secure communication and fundamentally transformed cybersecurity. While nation states did not have a framework for these new concepts, [Crypto Wars](https://en.wikipedia.org/wiki/Crypto_Wars) resulted in activist movements advocating and building cryptography tools. Ultimately, these were people inventing tools and ideas which became fundamental building blocks of modern cryptocurrencies.

> Get inspiration from early Cypherpunks who envisioned an independent digital realm built on trustless and borderless technologies:
>
> - https://activism.net/cypherpunk/manifesto.html
> - https://activism.net/cypherpunk/crypto-anarchy.html
> - https://www.eff.org/cyberspace-independence

[Read more in the EPF wiki page on Prehistory of Ethereum.](https://epf.wiki/#/wiki/protocol/prehistory)

## Ethereum Protocol Design

The actual prehistory of the protocol, early ideas and inspiration for technical decisions in Ethereum are well documented in [V's blog](https://vitalik.eth.limo/general/2017/09/14/prehistory.html).

Originally outlined in its [Whitepaper](https://ethereum.org/whitepaper#ethereum-whitepaper), Ethereum draws inspiration from Bitcoin and its background (explained above) to create a general blockchain based computation platform. The design was technically specified in [Yellowpaper](https://ethereum.github.io/yellowpaper/paper.pdf) and evolved over time. Changes are tracked in the community process of [EIPs](https://eips.ethereum.org) and current specification is implemented in Python as:

- [Execution specs](https://github.com/ethereum/execution-specs)
- [Consensus specs](https://github.com/ethereum/consensus-specs)

The specification is purely technical and doesn't provide any context or explanation for the reader. For learning about the consensus, check the annotated version [by Ben](https://eth2book.info/capella/annotated-spec/) and [by V](https://github.com/ethereum/annotated-spec).

The protocol changes over time, with each network upgrade bringing new improvements. Despite its constant changes, the architecture evolution reflects certain fundamental principles. These can be summarized as follows:

- Simplicity, Universality, Modularity, Non-discrimination, Agility

These core tenets have always led the Ethereum development and should be considered with every decision on design change. In addition to this, it manages growing complexity by encapsulating it and/or sandwiching it. The current network architecture is the result of many iterations of [network upgrade history](https://ethereum.org/history).

> Read more about Ethereum design principles in [the archive](https://web.archive.org/web/20220815014507mp_/https://ethereumbuilders.gitbooks.io/guide/content/en/design_philosophy.html) and also in [this wiki](/wiki/protocol/design-rationale.md)

The Ethereum network leverages decentralization to become permissionless, credibly neutral, and censorship resistant. It continues evolving to address the latest research, news, and always-present challenges. To maintain security and decentralization, blockchain technology has certain limits, mainly its scalability. Because Ethereum needs to always adhere to its principles, it motivates us to find clever solutions for these problems rather than accepting trade-offs.

The current research and development is summarized by the [roadmap](https://twitter.com/VitalikButerin/status/1741190491578810445/photo/1) overview, however cannot be fully accurate. There is no single path for Ethereum R&D, the [roadmap](https://ethroadmap.com/) only sums up its current landscape. The core ecosystem is an always growing [infinite garden](https://ethereum.foundation/infinitegarden). However, with more and more progress, Ethereum might slowly approach its ossification.

> Simplified overview of the current Ethereum design can be found documentation on [node architecture](https://ethereum.org/developers/docs/nodes-and-clients/node-architecture) and in the week 1 presentation

As hinted above, the main high level components of Ethereum are execution and consensus layer. These are 2 networks which are connected and dependent on each other. Execution layer provides the execution engine, handles user transaction and all state (address, contract data) while consensus implements the proof-of-stake mechanism ensuring security and [fault tolerance](https://inevitableeth.com/home/concepts/bft).

## Implementations and Development

Everything mentioned above - the ideas, design and specifications comes down to the actual application here, in its implementation. An implementation of the execution layer (EL) or consensus layer (CL) is called a _client_. A computer running this client and connecting to the network is called a _node_. A node is therefore a pair of EL and CL clients actively participating in the network.

Since Ethereum is formally specified, it can be implemented in different ways in any language. This results in a variety of implementations throughout the years with some already deprecated and some just being developed. The current list of production ready implementations can be found in the [docs on Nodes and clients](https://ethereum.org/en/developers/docs/nodes-and-clients#execution-clients) and week 1 presentation.

> This strategy is called [client diversity](https://ethereum.org/developers/docs/nodes-and-clients/client-diversity). Ethereum does not rely on a single 'official' implementation but users can choose any client and be sure it does the job. If an issue occurs within a single client implementation, it doesn't affect the rest of the network.

### Testing

With regular changes and multiple client implementations, testing is fundamental to the network security. There are a variety of testing tools and scenarios which are all heavily utilized before any network upgrade.

Tests are generated based on specifications and create various scenarios. Some are testing clients individually, some are simulating a testnet with all client pairs. There are different testing tools used for different parts of development cycles and parts of clients. This includes state transition testing, fuzzing, shadow forks, RPC tests, client unit tests and CI/CD, etc.

> Here is a short list of repositories dedicated to testing:
>
> - https://github.com/ethereum/tests
> - https://github.com/ethereum/retesteth
> - https://github.com/ethereum/execution-spec-tests
> - https://github.com/ethereum/hive
> - https://github.com/kurtosis-tech/kurtosis
> - https://github.com/MariusVanDerWijden/FuzzyVM
> - https://github.com/lightclient/rpctestgen

### Coordination

The Ethereum development is very different to a traditional, corporate kind of, projects. First of all, it's all open and public, anybody can review it or contribute. And second, there are many different teams working on different parts. All together, there are around 20 different teams from various organizations working on Ethereum.

Unlike in proprietary tech, Ethereum developers are not competing but rather working together. With the complexity always growing, there are basically no people who would be experts in all of Ethereum. Instead, people develop expertise in specific domains and collaborate with others. This is possible thanks to the modularity of Ethereum and allows developers to focus on challenges they personally prefer.

> The traditional development cycle for new features or changes is `Idea - Research - Development - Testing - Adoption`. However, problems might arise at any moment of this cycle resulting in iterating again from the beginning.

To be able to ship network upgrades and agree on the current development focus, there needs to be a certain coordination. All of it is also public and can be followed by anyone interested in learning about the core protocol. The coordination mainly happens via regular calls which are scheduled in the [PM repo](https://github.com/ethereum/pm). There are different kinds of developer calls with the biggest one being All Core Devs (ACD). This is where representatives of all involved teams come to discuss the current development of the consensus or execution layer.

The ideas and proposed changes from the community are coordinated using [EIP process](https://eips.ethereum.org/EIPS/eip-1). Additionally, there are a few discussion forums. The biggest one discussing core upgrades is https://ethresear.ch. Another forum which is connected to the EIP process and serves for discussion about specific proposals is [Ethereum Magicians](https://ethereum-magicians.org/).
Lots of important discussion is also happening on the R&D Discord server (ping us in EPFsg discord to get an invite) and in client team groups. There are also offsites or workshops where many core developers meet in person to speed up the process face to face.

## Additional reading and exercises

To test your knowledge about the very basics of Ethereum, try a quiz:
https://ethereum.org/quizzes

Learn more about the roadmap:
https://ethereum.org/roadmap

To explore various parts of the Ethereum protocol, check out what people have been working on within EPF:
https://github.com/eth-protocol-fellows/cohort-three/tree/master/projects
https://github.com/eth-protocol-fellows/cohort-four/tree/master/projects

[Devcon archive](https://archive.devcon.org/archive/) is full of incredible talks diving into various technical and non-technical aspects of Ethereum.

A [retrospective document](https://notes.ethereum.org/@mikeneuder/rcr2vmsvftv) on recent roadmap by Alex and Mike comes with great insights into Ethereum development, values and goals.

Read more about history of Unix and Bell Labs:
https://www.theregister.com/2024/02/16/what_is_unix/
https://www.deusinmachina.net/p/history-of-unix

Few more books I recommend:

If you are interested in early days of Ethereum, the story of its founders and creation, check out book [The Infinite Machine](https://www.camirusso.com/book). Another similar one is [Out of the Ether](https://www.goodreads.com/book/show/55360267-out-of-the-ether). (ping me for epubs)

A very recent publication providing a comprehensive insight is [Absolute Essentials of Ethereum](https://www.routledge.com/Absolute-Essentials-of-Ethereum/Dylan-Ennis/p/book/9781032334189). It covers a [variety of topics](https://www.coindesk.com/consensus-magazine/2024/02/07/absolute-essentials-of-ethereum-by-paul-dylan-ennis-an-excerpt/) and I can strongly recommend it.

[Mastering Ethereum](https://github.com/ethereumbook/ethereumbook) is one of the great blockchain books by aantop covering everything from basics to technical details. It's few years old and already outdated but still can be a good inspiration.
