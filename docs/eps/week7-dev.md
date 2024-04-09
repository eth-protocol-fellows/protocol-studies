# Study Group Week 7 | Execution client architecture

Week 7 development track is an insight into Ethereum execution layer client codebase, explaining its architecture and highlighting novel approaches. 

Watch the presentation recording by [Dragan](https://twitter.com/rakitadragan) on StreamEth or Youtube. Slides are [available here](https://github.com/eth-protocol-fellows/protocol-studies/blob/main/docs/eps/presentations/week7-dev.pdf). 

<iframe width="560" height="315" src="https://www.youtube.com/embed/ibcsc5cv-vc?si=mTR7ReFUZo3vFtJD" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Pre-reading

Before starting with the week 7 development content, make yourself familiar with resources in previous weeks, especially 2. The execution client intro provided an important knowledge about execution client and its main features with examples from geth codebase. This talk will be diving into reth client design which is written in rust and developed with a modern design approach to EL clients. 

Additionally, you can read and get ready by studying the following resources:

- Reth docs https://paradigmxyz.github.io/reth/
- Intro to Reth by Georgios https://www.youtube.com/watch?v=zntRpCKHyDc
- Deeper insight by Dragan https://www.youtube.com/watch?v=pxhq7YrySRM

## Outline

- Reth client 
- Design and architecture
- Codebase overview, examples 
- Features and highlights 

## Additional reading and exercises 

- Erigon is a fork of geth which pioneered the design approached implemented by reth. Kind of a middle ground between geth and reth, it's a great source of resources about novel execution client designs
- As an exercise, run reth and set different `DEBUG` options to explore how various client components operate on lower level