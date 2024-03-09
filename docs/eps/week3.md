# Study Group Week 3 | Consensus Layer

The third week will dive into the Consensus layer of Ethereum. 

Join the presentation by [Alex Stokes](https://twitter.com/ralexstokes) on [Monday, March 4, 4PM UTC](https://savvytime.com/converter/utc-to-germany-berlin-united-kingdom-london-ny-new-york-city-ca-san-francisco-china-shanghai-japan-tokyo-australia-sydney/mar-04-2024/4pm). 

The link to stream will be provided here and announced in [Discord group](https://discord.gg/epfsg). 

## Pre-reading

Before starting with the week 3 content, make yourself familiar with resources in [week 2](/eps/week2.md). 

Additionally, you can read get ready by reading following resources:
- [Ethereum.org docs on Proof-of-stake](https://ethereum.org/developers/docs/consensus-mechanisms/pos) and its subtopics
- [Beacon Chain explainer](https://ethos.dev/beacon-chain)
- [PoS and Solar Punk Future, Dany Ryan 2022](https://www.youtube.com/watch?v=8N10a1EBhBc), a talk before the Merge, great insight into the Merge and Beacon Chain development and testing

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
- [Beacon Chain design mistakes by Justin Drake](https://www.youtube.com/watch?v=10Ym34y3Eoo)
- [Casper and Consensus from Devcon 3](https://archive.devcon.org/archive/watch/3/casper-and-consensus/?tab=YouTube)

After learning about both EL and CL, run a client pair. Spin a pair of one execution and consensus client, read their logs to learn how they operate. 
