# Study Group Week 8 | Consensus client architecture

The Week 8 development track provides a look into Ethereum consensus layer client codebase, explaining its architecture and functions. 

Watch the presentation recording by [Paul Harris](https://twitter.com/rolfyone) on StreamEth or Youtube. Slides are [available here](https://github.com/eth-protocol-fellows/protocol-studies/blob/main/docs/eps/presentations/week8-dev.pdf). 

<iframe width="560" height="315" src="https://www.youtube.com/embed/cZ33bfGXzOc?si=qnZ8xJF74oRlkHqF" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Pre-reading

Before starting with the week 8 development content, make yourself familiar with resources in previous weeks, especially week 3 resources on consensus layer. 

Paul dives into Teku, consensus client implementation in Java and explains an example on how an EIP gets implemented. You should have at least basic knowledge of the language syntax to follow properly. 

[Consensus-specs](https://github.com/ethereum/consensus-specs/) is executable, and a passing knowledge of python may be beneficial, but it's a fairly easy language to reason about at the level the specs are written.

Additionally, you can get ready by studying the following resources:

- [Post-Merge Ethereum Client Architecture by Adrian Sutton](https://www.youtube.com/watch?v=6d4pkhL37Ao)
- [Teku Architecture, 2020](https://www.youtube.com/watch?v=1PHZHpVPLk4)
- [Teku docs](https://docs.teku.consensys.io/)

## Outline

- Teku CL client
- Brief introduction into our rest api's, declarative framework
- A look at development process EIP -> spec -> code
    - Examples of EIP-7251 (maxEB)

## Additional reading and exercises 

- [Teku code conventions for contributors](https://wiki.hyperledger.org/display/BESU/Coding+Conventions) 
- [Teku and the Merge, PEEPanEIP#83](https://www.youtube.com/watch?v=YTWaZ-NBpbM)
- [EIP 7251 - Max EB](https://github.com/ethereum/consensus-specs/tree/dev/specs/_features/eip7251)
- [Beacon-api](https://github.com/ethereum/beacon-APIs)
