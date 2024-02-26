# Study Group Week 2 | Execution Layer

During the second week, we will dive into the Execution layer of Ethereum. 

Come to see the presentation by [lightclient](https://twitter.com/lightclients/) on [Monday, February 26, 4PM UTC](https://savvytime.com/converter/utc-to-germany-berlin-united-kingdom-london-ny-new-york-city-ca-san-francisco-china-shanghai-japan-tokyo-australia-sydney/feb-26-2024/4pm). 

The link to stream will be provided here and announced in [Discord group](https://discord.gg/epfsg). 

## Pre-reading

Before starting with week 2 content, make yourself familiar with resources in [week 1](/eps/week1.md). 

Additionally, you should read through the following documents to prepare for the presentation:
* [Nodes and clients](https://ethereum.org/developers/docs/nodes-and-clients)
* [Ethereum: mechanics](https://cs251.stanford.edu/lectures/lecture7.pdf) (a lecture based on these slides is also available on YouTube: [An Overview of the Ethereum Excecution Layer - Dan Boneh](https://www.youtube.com/watch?v=7sxBjSfmROc))

## Outline

###  Overview of the execution layer node
* Block validation
    * in overly simplistic terms, ELs process the state transition
    * each transaction is validated by the client, executed, and its result accumulated into the state trie
    * there are additional mechanisms which also must be updated each block, such as the EIP-1559 base fee, the EIP-4844 excess blob gas, the EIP-4844 beacon root ring buffer, beacon chain withdrawals, etc.
    * new nodes must also be able to join the network without too much friction, so ELs provide efficient syncing mechanism to bootstrap others
* Block building
    * ELs also build blocks based on transactions they see around the network
    * this requires a tx pool system over p2p

### State transition function
* header validation
    * verify merkle roots
    * verify gas limit
    * verify timestamp
* block validation
    * walkthrough [`Process(..)`](https://github.com/ethereum/go-ethereum/blob/master/core/state_processor.go#L60) in `state_processor.go`

### EVM high-level
* stack machine intro
* look at simple programs
* review different classes of opcodes: stack/mem manipulators, env getters, ethereum system operations, etc.

### p2p high-level
* p2p serves three main things
    * historical data
    * pending txs
    * state
* discuss snap sync
    * phase 1: downloading snap tiles
    * phase 2: healing

### JSON-RPC
* the "interface" to ethereum
    * the vision is that all clients provide the exact same API and users can run any client the choose and have perfect integration with all tooling
    * not quite there, but we are fairly close
* review main RPC methods

## Additional reading and exercises 

- https://blog.ethereum.org/2022/01/24/the-great-eth2-renaming
- https://blog.ethereum.org/2021/11/29/how-the-merge-impacts-app-layer
