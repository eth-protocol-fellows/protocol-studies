# Study Group Lecture 18 | EL Networking, Devp2p

The introductory part of the study group is now over and we are now starting the deeper dive with live sessions from core developers. The second week of the main phase of the study group is dedicated to networking. 

The first live session this week is dedicated to execution layer networking stack, diving into devp2p. [Felix Lange](https://github.com/fjl) is a long term core developer from go-ethereum team and the maintainer of devp2p specification. 

> Join the live talk by Felix on [Monday, 17.3. at 3PM UTC](https://www.timeanddate.com/worldclock/converter.html?iso=20250317T150000&p1=1440&p2=37&p3=136&p4=237&p5=923&p6=204&p7=671&p8=16&p9=41&p10=107&p11=28) to watch the lecture and ask questions directly. [Use this link to connect.](https://meet.ethereum.org/eps-office-hours) 


## Pre-reading

Before starting with the Day 16 content, make yourself familiar with resources in previous weeks, especially day 2 on CL and day 6 on specs (at least the CL part). You should have general understanding of Beacon Chain and different mechanism in Ethereum consensus layer. 

Additionally, you can get ready by studying the following resources.

- Vitalik's [Beacon Chain Fork Choice](https://github.com/ethereum/annotated-spec/blob/master/phase0/fork-choice.md) - outdated, but still excellent
- [Consensus chapter](https://eth2book.info/latest/part2/consensus/) in the Upgrading Ethereum book
- [Annotated spec on fork choice](https://eth2book.info/latest/part3/forkchoice/phase0/) 

## Outline

- Introduction to Fork Choice
- LMD GHOST
- Casper FFG
- Gasper
- Q&A

## Additional reading and exercises

- Original Casper FFG paper: [Casper the Friendly Finality Gadget](https://arxiv.org/abs/1710.09437)
- Gasper: [Combining GHOST and Casper (Gasper paper)](https://arxiv.org/abs/2003.03052)
- [The blue eyes puzzle](https://xkcd.com/blue_eyes.html) - think hard! Don't give in and look up the solution too soon.