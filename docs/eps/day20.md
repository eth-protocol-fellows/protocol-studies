# Study Group Lecture 20 | Validator client

The introductory part of the study group is now over and we are now starting the deeper dive with live sessions from core developers. 

This lecture is focused on the validator client implementation in the consensus layer. The talk is given by [James](https://github.com/james-prysm), developer from Prysm, go implementation of Beacon Chain. 

[Slides](https://github.com/eth-protocol-fellows/protocol-studies/blob/main/docs/eps/presentations/day20_validator.pdf).

Watch the lecture on [Youtube](https://www.youtube.com/watch?v=rgrNMbYrOmM) and follow the [slides](https://github.com/eth-protocol-fellows/protocol-studies/blob/main/docs/eps/presentations/day20_validator.pdf) and code examples from Prysm.

<iframe width="560" height="315" src="https://www.youtube.com/embed/rgrNMbYrOmM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Pre-reading

Before starting with the Day 20 content, make yourself familiar with resources in previous weeks, especially day 2 on CL, day 6 on specs (at least the CL part) and day 16 on the consensus mechanism. You should have general understanding of Beacon Chain, different mechanism in Ethereum consensus layer and validator duties. 

Additionally, you can get ready by studying the following resources.

- [Annotated spec on validator incentives](https://eth2book.info/capella/part2/incentives/)
- [The evolution of Prysm with Preston Van Loon](https://www.youtube.com/watch?v=Lvlit-nIRfM)
- [Keymanager APIs](https://ethereum.github.io/keymanager-APIs/)
- [Remote Signer API](https://github.com/ethereum/remote-signing-api)
- [Validator Lifecycle](https://docs.prylabs.network/docs/how-prysm-works/validator-lifecycle)

## Outline

- Validator Client
- Validator Service Initialization
- Keystore Management
- Performing Validator Duties

## Additional reading and exercises

- Run a node with a validator client on Hoodi or Ephemery, follow logs to see its behaviour and functions
    - [Spin up your own Ethereum validator on testnet | Devcon Bogotá](https://www.youtube.com/watch?v=dWCck2IniNc)
- Test your validator client out on local devnet through https://github.com/ethpandaops/ethereum-package