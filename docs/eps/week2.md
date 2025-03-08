# Study Group Lecture 3 | Execution Layer

During the third day, we will dive into the Execution layer of Ethereum.

Watch the presentation diving into EL internals with Lightclient on [StreamEth](https://streameth.org/watch?event=&session=65dcdef0a6d370a1ab326de1) or [Youtube](https://www.youtube.com/watch?v=pniTkWo70OY).

The overview document created in the presentation is [available here](https://github.com/eth-protocol-fellows/protocol-studies/blob/main/docs/eps/presentations/week2_notes.md?plain=1).

[recording](https://streameth.org/embed/?playbackId=70f6rq6un48dy74q&vod=true&streamId=&playerName=Execution+Layer+Overview+%7C+lightclient+%7C+Week+2 ':include :type=iframe width=100% height=520 frameborder="0" allow="fullscreen" allowfullscreen')

For written summary of week 2 presentation, check the [notes](https://ab9jvcjkej.feishu.cn/docx/BRDdd8kP9o00a2x6F4scRo0fnJh)

For archive of the discussion during the talk, check [this thread](https://discord.com/channels/1205546645496795137/1210292746817110027/1210292751158222848) in our [Discord server](https://discord.gg/epfsg).

## Pre-reading

Before starting with week 2 content, make yourself familiar with resources in [week 1](/eps/week1.md).

Additionally, you should read through the following documents to prepare for the presentation:

- [Nodes and clients](https://ethereum.org/developers/docs/nodes-and-clients)
- [Ethereum: mechanics](https://cs251.stanford.edu/lectures/lecture7.pdf) (a lecture based on these slides is also available on YouTube: [An Overview of the Ethereum Execution Layer - Dan Boneh](https://www.youtube.com/watch?v=7sxBjSfmROc))

## Outline

### Overview of the execution layer node

- Block validation
  - In overly simplistic terms, ELs process the state transition
  - Each transaction is validated by the client, executed, and its result accumulated into the state trie
  - There are additional mechanisms which also must be updated each block, such as the EIP-1559 base fee, the EIP-4844 excess blob gas, the EIP-4844 beacon root ring buffer, beacon chain withdrawals, etc.
  - New nodes must also be able to join the network without too much friction, so ELs provide efficient syncing mechanism to bootstrap others
- Block building
  - ELs also build blocks based on transactions they see around the network
  - This requires a tx pool system over p2p

### State transition function

- Header validation
  - Verify merkle roots
  - Verify gas limit
  - Verify timestamp
- Block validation
  - Walkthrough [`Process(..)`](https://github.com/ethereum/go-ethereum/blob/master/core/state_processor.go#L60) in `state_processor.go`

### EVM high-level

- Stack machine intro
- Look at simple programs
- Review different classes of opcodes: stack/mem manipulators, env getters, ethereum system operations, etc.

### p2p high-level

- p2p serves three main things
  - Historical data
  - Pending txs
  - State
- Discuss snap sync
  - Phase 1: downloading snap tiles
  - Phase 2: healing

### JSON-RPC

- The "interface" to ethereum
  - The vision is that all clients provide the exact same API and users can run any client they choose and have perfect integration with all tooling
  - Not quite there, but we are fairly close
- review main RPC methods

## Additional reading and exercises

- https://www.evm.codes/
- https://ethervm.io/
- https://github.com/ethereum/go-ethereum
- https://github.com/ethereum/consensus-specs
- https://github.com/ethereum/execution-specs
- https://github.com/ethereum/devp2p
- https://github.com/ethereum/execution-apis
- https://blog.ethereum.org/2022/01/24/the-great-eth2-renaming
- https://blog.ethereum.org/2021/11/29/how-the-merge-impacts-app-layer
- [Engine API: A Visual Guide](https://hackmd.io/@danielrachi/engine_api) by [Daniel Ramirez](https://hackmd.io/@danielrachi)
- [Understanding Ethereum by studying its source code](https://gisli.hamstur.is/2020/08/understanding-ethereum-by-studying-the-source-code/)

Lightclient's vim and shell setup https://github.com/lightclient/dotfiles
