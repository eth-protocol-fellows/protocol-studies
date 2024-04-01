# Study Group Week 7 | Execution client architecture

Week 7 development track is an insight into Ethereum execution layer client codebase, explaining its architecture and highlighting novel approaches. 

The presentation will be given by [Dragan](https://twitter.com/rakitadragan) who will dive into reth client codebase. Join the talk on [Monday, April 1, 4PM UTC](https://savvytime.com/converter/utc-to-germany-berlin-united-kingdom-london-ny-new-york-city-ca-san-francisco-china-shanghai-japan-tokyo-australia-sydney/april-01-2024/4pm).

The talk will be streamed live on [StreamEth](https://streameth.org/65cf97e702e803dbd57d823f/epf_study_group) and [Youtube](https://www.youtube.com/@ethprotocolfellows/streams), links will be provided before the call in the [Discord server](https://discord.gg/addwpQbhpq). Discord also serves for the discussion and questions during the stream. 

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

- Erigon is a fork of geth which pioneered the design approached implemented by reth. Kind of a middle ground between geth and reth, tt's a great source of resources about novel execution client designs
- As an excercise, run reth and set different `DEBUG` options to explore how various client componantes operate on lower level