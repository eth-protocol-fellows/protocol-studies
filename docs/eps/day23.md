# Study Group Lecture 23 | EL Data Structures

This lecture dives into data structures of the Execution layer, the Merkle Patricia Tree and how different clients implement it. The lecture is given by [Gary](https://github.com/garyschulte) and [Karim](https://github.com/matkt) from Besu team.

> Join the live talk on [Monday, 7.4. at 3PM UTC](https://www.timeanddate.com/worldclock/converter.html?iso=20250407T150000&p1=1440&p2=37&p3=136&p4=237&p5=923&p6=204&p7=671&p8=16&p9=41&p10=107&p11=28) to watch the lecture and ask questions directly. [Use this link to connect](https://meet.ethereum.org/eps-office-hours) 

## Pre-reading

Before starting with the Day 23 content, make yourself familiar with resources in previous weeks, especially day 3 on EL and day 7 on EL client architecture. 

Additionally, you can get ready by studying the following resources.

- [Merkling in Ethereum](https://blog.ethereum.org/2015/11/15/merkling-in-ethereum)
- [MPT on ethereum.org ](https://ethereum.org/en/developers/docs/data-structures-and-encoding/patricia-merkle-trie/)
- https://en.wikipedia.org/wiki/Trie#Patricia_trees

## Outline

1. Overview of Ethereum State
2. Merkle Patricia Trie (MPT)
   - The structure and the concept of a trie-within-a-trie account storage
   - What is the state root and what purpose does it serve
   - Challenges with the state size and performance over time
3. Evolution of State Solutions: From Hash Based to Path Based
   - Describe the forest model
   - The size and performance constraints
   - Bonsai
   - path based trie
   - flat database
   - Other storage models
   - half-path, nethermind
   - erigon/reth flat db model
   - bonsai archive
4. Challenges and Solutions in State Management
   - Continuous evolution and historical accuracy across different hardforks
   - self destruct as a case study
   - snap sync as a method of skipping history
   - state growth
   - size and rate of growth across time
   - state expiry proposal
   - statelessness
   - proposing vs validating: state vs state witness
   - proof size of MPT
   - vector commitment like Verkle/starkle trees

## Additional reading and exercises
- [Bonsai Trees guide](https://consensys.io/blog/bonsai-tries-guide)
- [Nethermind half-path](https://github.com/NethermindEth/nethermind/pull/6331)
- [Nethermind paprika](https://github.com/NethermindEth/Paprika/blob/main/docs/design.md)
- [Erigon schema]( https://github.com/erigontech/erigon/blob/main/erigon-lib/kv/tables.go)
- [Implementing MPT](https://medium.com/coinmonks/implementing-merkle-tree-and-patricia-trie-b8badd6d9591)
- [Ethereum Data Structures paper](https://www.researchgate.net/publication/353863430_Ethereum_Data_Structures)
