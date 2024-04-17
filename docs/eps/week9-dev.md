# Study Group Week 9 | Local testing and prototyping 

This development talk is dedicated to testing and prototyping forks locally, it discusses the current state and ideas being worked on. 

Watch the presentation by [Parithosh](https://twitter.com/parithosh_j) on StreamETH channel or Youtube. Slides are [available here](https://github.com/eth-protocol-fellows/protocol-studies/blob/main/docs/eps/presentations/week9-dev.pdf). 

<iframe width="560" height="315" src="https://www.youtube.com/embed/Enf8006zKLI?si=hJe4xFqiY81C0DwQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Pre-reading

Before starting with the week 9 development content, make yourself familiar with resources in previous weeks, especially week 4 presentation on testing and the node workshop. It's important to understand the current architecture of the protocol and its basic tooling. 

Additionally, you can get ready by studying the following resources:
- [Quest for the Best Tests, a Retrospective on #TestingTheMerge by Pari](https://archive.devcon.org/archive/watch/6/quest-for-the-best-tests-a-retrospective-on-testingthemerge/?tab=YouTube)
- [Dencun testing](https://www.youtube.com/watch?v=88tZticGbTo)

## Preparation
- [Install kurtosis and docker on your system](https://docs.kurtosis.com/quickstart/)

## Outline

- What do we test and why?
- Importance of Local testing
- How can I prototype a tool or change?
- What are devnets? How do we spin them up?
- Shadow forks 
- Handy devops tools
  - Kurtosis
  - Template-devnets
  - Assertoor
  - Forky
  - Tracoor
  - Dora
  - Goomy-blob
  - Xatu
- Run your own local devnet and shadowfork!

## Additional reading and exercises
- [Attacknet: Chaos engineering on Ethereum](https://ethpandaops.io/posts/attacknet-introduction/)
- [Verkle devnets](https://github.com/ethpandaops/verkle-devnets)
- [Kurtosis](https://github.com/kurtosis-tech/kurtosis)
- Follow excercises proposed by Pari in the talk
   - Modify a client with a custom log message and run it using Kurtosis
   - Deploy some of the tolling, connect to your own node on any network 