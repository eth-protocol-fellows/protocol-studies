# Study Group Lecture 2 | Consensus Layer

The second day of EPFsg dives into the Consensus layer of Ethereum. 

Watch the presentation on overview of the CL with Alex Stokes on [StreamEth](https://streameth.org/watch?event=&session=65e9f54579935301489a01eb) or [Youtube](https://www.youtube.com/watch?v=FqKjWYt6yWk). Presentations slides are [available here](https://github.com/eth-protocol-fellows/protocol-studies/tree/main/docs/eps/presentations/week3_presentation.pdf). 

[recording](https://streameth.org/embed/?playbackId=66a30awapcuiok0z&vod=true&streamId=&playerName=Consensus+Layer+Overview+%7C+Alex+Stokes+%7C+Week+3 ':include :type=iframe width=100% height=520 frameborder="0" allow="fullscreen" allowfullscreen')

For written summary of week 3 presentation, check the [notes](https://github.com/eth-protocol-fellows/protocol-studies/files/14850973/Week.3.EPFsg.Consensus.Layer.Overview.pdf)

For archive of the discussion during the talk, check [this thread](https://discord.com/channels/1205546645496795137/1214219045205835776/1214219052969492541) in our Discord server.

## Pre-reading

Before starting with the week 3 content, make yourself familiar with resources in [week 2](/eps/week2.md). 

Additionally, you can read and get ready by studying the following resources:
- [Ethereum.org docs on Proof-of-stake](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos) and its subtopics
- [Beacon Chain explainer](https://ethos.dev/beacon-chain)
- [PoS and Solar Punk Future, Danny Ryan 2022](https://www.youtube.com/watch?v=8N10a1EBhBc), a talk before the Merge, great insight into the Merge and Beacon Chain development and testing

## Outline

- Blockchain enables creating a digital scarcity but it needs security which ensures its integrity
- Distributed networks deal with Byzantine fault tolerance (BFT)
- Bitcoin first solved the BFT with PoW
- Ethereum moves to proof-of-stake, switching from exogenous signal for Sybil protection to endogenous in the system
- Uses BFT majority to determine the state of the chain 
    - Byzantine faults can be observed by the protocol and stake can be `slashed`
    - The fork choice rule summarized in LMD-GHOST
    - It ensures liveness thanks to Casper
- Provides more cryptoeconomic security

## Additional reading and exercises 
 
- [Gasper paper](https://arxiv.org/pdf/2003.03052.pdf)
- [Bitwise LMD GHOST: An efficient CBC Casper fork choice rule](https://medium.com/@aditya.asgaonkar/bitwise-lmd-ghost-an-efficient-cbc-casper-fork-choice-rule-6db924e57d1f)
- [Eth2book, annotated spec](https://eth2book.info/)
- [Stuff you should know about PoS by Domothy](https://domothy.com/proof-of-stake/)
- [Slashing scenario explanation by Dankrad Feist](https://dankradfeist.de/ethereum/2022/03/24/run-the-majority-client-at-your-own-peril.html)
- [Beacon Chain design mistakes by Justin Drake](https://www.youtube.com/watch?v=10Ym34y3Eoo)
- [Casper and Consensus from Devcon 3](https://archive.devcon.org/archive/watch/3/casper-and-consensus/?tab=YouTube)
- [Anatomy of a slot](https://www.youtube.com/watch?v=EswDO0kL_O0)

After learning about both EL and CL, run a client pair. Spin a pair of one execution and consensus client, read their logs to learn how they operate. 
