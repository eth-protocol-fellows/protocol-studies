# Study Group Lecture 23 | EL Data Structures

This lecture dives into data structures of the Execution layer, the Merkle Patricia Tree and how different clients implement it. The lecture is given by [Gary](https://github.com/garyschulte) and [<name>Karim</name>](https://github.com/matkt) from Besu team.

Watch the lecture on [Youtube](https://youtu.be/EY_pVZTXS1w). [Slides are available here](https://docs.google.com/presentation/d/1YJbrZpgxjTHy7QlgXFRG5OjSK-G5uPrExBPu3Hiefvk/edit?usp=sharing).

<iframe width="560" height="315" src="https://www.youtube.com/embed/EY_pVZTXS1w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
## Pre-reading

Before starting with the Day 23 content, make yourself familiar with resources in previous weeks, especially day 3 on EL and day 7 on EL client architecture.

Additionally, you can get ready by studying the following resources.

- [<name>Merkling</name> in Ethereum](https://blog.ethereum.org/2015/11/15/merkling-in-ethereum)
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

## Additional reading and exercises

- [Bonsai Trees guide](https://consensys.io/blog/bonsai-tries-guide)
- [Nethermind half-path](https://github.com/NethermindEth/nethermind/pull/6331)
- [Nethermind paprika](https://github.com/NethermindEth/Paprika/blob/main/docs/design.md)
- [Erigon schema](https://github.com/erigontech/erigon/blob/main/erigon-lib/kv/tables.go)
- [Implementing MPT](https://medium.com/coinmonks/implementing-merkle-tree-and-patricia-trie-b8badd6d9591)
- [Ethereum Data Structures paper](https://www.researchgate.net/publication/353863430_Ethereum_Data_Structures)
