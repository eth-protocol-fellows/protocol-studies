# Ethereum Protocol Studies

[Ethereum Protocol Studies group (EPS)](https://blog.ethereum.org/2025/02/05/ethereum-protocol-studies) is a community formed to gather knowledge, learn, and educate the public about the Ethereum protocol. 

The protocol evolves and grows quickly, it's an always-changing infinite garden. To sustain its credible neutrality, this pace should be reflected in growing and educating the core community. Everyone using, building or living on Ethereum should be able to learn and become involved in the core protocol. The complexity of the architecture, codebases and dynamic development paired with scattered resources can discourage many talented people from participating.

Originally started in 2024, the study group is a participatory educational program that aims to improve core protocol education by introducing a curriculum focused on all parts of the Ethereum stack, building a wiki knowledge base and creating a community focused on learning about the protocol.

> The study group in 2025 is 8 week long program starting in February 17. If you'd like to participate, join our [Discord server](https://discord.gg/8RPnPGEQtJ), attend the [town hall](https://bordel.wtf/epstownhall25.ics) on Feb 12 at 1500 UTC and fill out [the participant survey](https://forms.gle/G5V95qyGV8uMjKGcA).

![Ethereum Protocol Studies](https://raw.githubusercontent.com/eth-protocol-fellows/protocol-studies/376d1fca6907d2796da0a7876703b525ef528727/docs/images/EPS2-1080.jpg)

## Program Structure

The study group content is structured in 2 stages - an intense introduction and deep dive. The first 2 weeks consist of studying existing curriculum from [previous study group](https://blog.ethereum.org/2024/02/07/epf-study-group). The following 6 weeks will provide new live lectures from core developers and researchers with materials covering parts of the execution and consensus layers of Ethereum. 

### Schedule

Each session is created by a core developer or researcher, comes with reading materials to get you familiar with the topic context and some also include exercises to strengthen and practice your understanding. More resources on each topic can be found in the wiki section and if they are any missing, contribute to add them. 

> Study Group events like Office Hours are published in the Discord server or you can subscribe to [this calendar](https://calendar.google.com/calendar/u/0?cid=Y18xY2RhMjMxNzc5NmI4NDgzZTliMjBhMGVjZTFkMDFhZWFkN2U1ZTY3N2IxNjVhOGUzZTJlMjQ3ZTQ0M2UwODhkQGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20) to follow all sessions

During the first 2 weeks, participants watch previous videos and study existing materials for the given day in their own time. Every day at _3PM UTC we will hold a daily office hours running for 2 hours_ where everyone can discuss their learnings, ask questions, exchange knowledge, etc. Join at the [Office Hours call link](https://meet.ethereum.org/eps-office-hours).

> We recommend watching videos from the study group using faster playback speed, 1.25 or 1.5x to save some time

#### Week 1

The first week will cover the first five weeks of previous Study Group content. The first day provides an introduction to the Study Group and the protocol itself. Then, we will dive into each part of the protocol. On Wednesday, the node workshop will also be held live during office hours.

| Day           | Topic                                               | Speaker                                         |
| ------------- | --------------------------------------------------- | ----------------------------------------------- |
| Day 1, Feb 17 | [Intro to EPS and Ethereum protocol](/eps/week1.md) | [Mario Havel](https://github.com/taxmeifyoucan) |
| Day 2, Feb 18 | [Consensus layer](/eps/week3.md)                    | [Alex Stokes](https://github.com/ralexstokes)   |
| Day 3, Feb 19 | [Execution Layer](/eps/week2.md)                    | [Lightclient](https://github.com/lightclient)   |
| Day 3, Feb 19 | [Using clients, nodes](/eps/nodes_workshop.md)      | [Mario](https://github.com/taxmeifyoucan)       |
| Day 4, Feb 20 | [Testing and security](/eps/week4.md)               | [Mario Vega](https://github.com/marioevz)       |
| Day 5, Feb 21 | [Roadmap and research](/eps/week5.md)               | [Domothy](https://github.com/domothyb)          |

#### Week 2

The second week of the study group provides an overview of developer experience in Ethereum protocol. It covers the development track of the previous study group and provides an insight into various parts of the development process - from specification, CL/EL client architecture to hands on devops and testing. 

| Day, Date      | Topic                                              | Speaker                                                                                |
| -------------- | -------------------------------------------------- | -------------------------------------------------------------------------------------- |
| Day 6, Feb 24  | [Consensus and Execution specs](/eps/week6-dev.md) | [Hsiao-Wei Wang](https://github.com/hwwhww), [Sam Wilson](https://github.com/SamWilsn) |
| Day 7, Feb 25  | [Execution client architecture](/eps/week7-dev.md) | [Dragan Pilipovic](https://github.com/dragan2234)                                      |
| Day 8, Feb 26  | [Consensus client architecture](/eps/week8-dev.md) | [Paul Harris](https://github.com/rolfyone)                                             |
| Day 9, Feb 27  | [Devops and testing](/eps/week9-dev.md)            | [Parithosh](https://github.com/parithosh)                                              |
| Day 10, Feb 28 | [EL precompiles](/eps/week10-dev.md)               | [Danno Ferrin](https://github.com/shemnon)                                             |

Third week covers the research track and it's the last week using the original study group materials. Each lecture provides a technical explanation of an active area of research, covering major important items from most [Ethereum roadmap](https://epf.wiki/#/wiki/research/roadmap) tracks. 

### Week 3

| Day, Date     | Topic                                              | Speaker                                            |
| ------------- | -------------------------------------------------- | -------------------------------------------------- |
| Day 11, Mar 3 | [Sharding and DAS](/eps/week6-research.md)         | [Dankrad Feist](https://github.com/dankrad)        |
| Day 12, Mar 4 | [Verkle trees](/eps/week7-research.md)             | [Josh Rudolf](https://github.com/jrudolf)          |
| Day 13, Mar 5 | [MEV and censorship](/eps/week8-research.md)       | [Barnabe Monnot](https://github.com/barnabemonnot) |
| Day 14, Mar 6 | [Purge and Portal Network](/eps/week9-research.md) | [Piper Merriam](https://github.com/pipermerriam)   |
| Day 15, Mar 7 | [SSF and PoS Upgrades](/eps/week10-research.md)    | [Francesco D'Amato](https://github.com/fradamt)    |     

### Week 4

Starting week 4, we are entering the main part of the study group that dives deeper into each part of the protocol. This week starts with talks diving into the core function of each layer.

| Day, Date     | Topic                            | Speaker                                            |
| ------------- | -------------------------------- | -------------------------------------------------- |
| Day 16, Mar 10 | [Gasper](/eps/day16.md)         | [Ben Edgington](https://github.com/benjaminion)    |
| Day 17, Mar 12 | [EVM](/eps/day17.md)            | [Pawel Bylica](https://github.com/chfast)          |

### Week 5

Week 5 continues deeper dive to each part of the protocol with lectures on networking.

| Day, Date     | Topic                            | Speaker                                            |
| ------------- | -------------------------------- | -------------------------------------------------- |
| Day 18, Mar 17 | [devp2p](/eps/day18.md)         | [Felix Lange](https://github.com/fjl)              |
| Day 19, Mar 19 | [libp2p](/eps/day19.md)         | [DappLion](https://github.com/dapplion)            |


### Week 6

| Day, Date     | Topic                            | Speaker                                            |
| ------------- | -------------------------------- | -------------------------------------------------- |
| Day 20, Mar 24 | [Validator Client](/eps/day20.md)   | [James](https://github.com/james-prysm)        |


### Week 7 

| Day, Date      | Topic                            | Speaker                                            |
| -------------  | -------------------------------- | -------------------------------------------------- |
| Day 21, Mar 31 | [Engine API](/eps/day21.md)      | [Mikhail](https://github.com/mkalinin)             |
| Day 22, Apr 3  | [CL Data](/eps/day22.md)         | [Michael](https://github.com/michaelsproul/)       |


### Week 8

| Day, Date     | Topic                            | Speaker                                                                      |
| ------------- | -------------------------------- | --------------------------------------------------                           |
| Day 23, Apr 7 | [EL Data](/eps/day23.md)         | [Gary](https://github.com/garyschulte), [Karim](https://github.com/matkt) |
| Day 24, Apr 9 | [Next Upgrades](/eps/day24.md)   | [Marius](https://github.com/MariusVanDerWijden)                              |          


### Streams and recordings

Talks and calls are announced week in advance based on the schedule above. Recordings of all talks can be found on [Youtube](https://www.youtube.com/@ethprotocolfellows) or [StreamEth](https://streameth.org/archive?organization=ethereum_protocol_fellowship) archive. 

Apart from weekly lectures, there are less regular, ad-hoc hangout calls for informal chats and calls for wiki contributors working the content. Join the Discord group to get notified about all of these events.

## Participate

The study group is an open and permissionless, and it is up to each participant as to how they want to approach it. Whether you want to learn as much as possible, focus only on certain topics or share your knowledge with others, you are welcomed. 

> Join our community in [Discord server](https://discord.gg/8RPnPGEQtJ). We use it for the easiest community engagement but we are aware that Discord is proprietary and doesn't respect user privacy. Consider using alternative FOSS clients like [Dissent](https://github.com/diamondburned/dissent) or [WebCord](https://github.com/SpacingBat3/WebCord). For enhancing the regular client, check [BetterDiscord](https://github.com/BetterDiscord/BetterDiscord/) project.

Study group participants collaboratively develop the [Protocol wiki](/wiki/wiki-intro.md), serving as an evolving knowledge base for current and future core developers. This can provide students with practical experience in contributing to open source resources, while gaining invaluable experience in documentation and community-driven development.

While this program is designed to act as a precursor to the Ethereum Protocol Fellowship, the study group is for anyone that is interested in learning more about the inner workings of the Ethereum Protocol. Those that have some general knowledge or use of Ethereum and/or blockchains as well as those that have some computer science, technical, or developer experience will get the most from this program.

## Important links

- [Office Hours call link](https://meet.ethereum.org/eps-office-hours)
- [Discord server](https://discord.gg/8RPnPGEQtJ)
- [Weekly talks on StreamEth](https://streameth.org/65cf97e702e803dbd57d823f/epf_study_group)
- [Youtube](https://www.youtube.com/@ethprotocolfellows)
- [Sessions calendar](https://calendar.google.com/calendar/u/0?cid=Y18xY2RhMjMxNzc5NmI4NDgzZTliMjBhMGVjZTFkMDFhZWFkN2U1ZTY3N2IxNjVhOGUzZTJlMjQ3ZTQ0M2UwODhkQGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20) 
- [EPF mailing list](https://groups.google.com/a/ethereum.org/g/protocol-fellowship-group)
- [EF Blog](https://blog.ethereum.org)

## Calls troubleshooting

For our weekly meetings, we are using a self-hosted FOSS platform Jitsi. Even though we are doing our best, some people might experience problems during these calls, here are a few tips on troubleshooting:

- Restart your browser and rejoin
- Try a different browser (especially if you are using a Chromium based, try Firefox and vice versa)
- Use the [mobile Jitsi app](https://jitsi.org/downloads/) instead of desktop (you just need to point it to our domain meet.ethereum.org)
- Check your network and firewall settings, make sure your browser allows WebRTC
- Visit Jitsi [community forum](https://community.jitsi.org/) to search for specific issue or report your problem

## FAQ

- **Will I learn to develop applications on the Ethereum blockchain?**
    - No. This program is not focused on Solidity or development of decentralized applications. 
- **When does it start and is the duration?**
    - The program runs from February 17 and continues for 8 weeks, concluding in April.
- **Am I automatically accepted to EPF after attending EPFsg**
    - No. The study group is a great way to prepare for EPF, but it doesn't guarantee anything. However, EPF is a permissionless program, so you can always participate. 
- **Where is the study group located?**
    - As all core Ethereum teams, EPFsg is distributed around the globe. We will do our best to accommodate call times for the program participants.
- **Do I need to apply and be accepted?**
    - The program is fully open, anyone can participate. We only ask you to submit a [form](https://forms.gle/G5V95qyGV8uMjKGcA) survey to let us know about your preferences, but it doesn't have any effect on your participation. 
