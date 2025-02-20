# Notable mainnet incidents

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.
> Incidents are the disruptions, vulnerabilities and attacks faced by the network which has questioned it's stability and security. Below are some incidents that affected the network and their sources.

## Overview

The Ethereum network has faced various challenges and incidents throughout its history. These incidents have helped improve the network's resilience and security through careful analysis and implementation of preventive measures. This page documents notable incidents that have affected the Ethereum.

For a comprehensive list of Ethereum incidents and their detailed analysis, you can refer to the [EthStaker Incidents Page](https://ethstaker.org/incidents).

## Recent Incidents

- [Post-Mortem, Blob Propagation Issues (27/03/2024)](https://gist.github.com/benhenryhunter/687299bcfe064674537dc9348d771e83)
  In March 2024, after Dencun upgrade, blobs attached to blocks from certain builders propagated too slowly over p2p which caused a client implementation to miss few slots.

- [Post-Mortem Report: Ethereum Mainnet DOS Incident (07/02/2024)](https://blog.ethereum.org/2024/03/21/sepolia-incident)
  It was discovered that there was a possibility for a Denial-of-service attack dating from when the merge happened to the dencun hard fork. An attacker could create a block exceeding the specified limit of 5mb and adding multiple transactions into the block each not up to 128kb while also making sure that the transactions within the block have a collective gas which is below 30 million. With this action most nodes will reject the blocks which will lead to minority nodes acceptance creating forked blocks and missed proposer rewards.

- [Post-Mortem Report: Ethereum Mainnet Finality (05/11/2023)](https://medium.com/offchainlabs/post-mortem-report-ethereum-mainnet-finality-05-11-2023-95e271dfd8b2)
  The Mainnet had some disruptions, which led to blocks not getting produced leading to a significant delay in transactions reaching finality, this continued for two days and resulted in an inactivity consequence, the network fully recovered without intervention.

## Historical Incidents

- [Post-Mortem Report: Minority Split (2021-08-27)](https://github.com/ethereum/go-ethereum/blob/master/docs/postmortems/2021-08-22-split-postmortem.md)
  This happened when Geth tried to assign data back into memory after the `datacopy` operation. Instead of saving the data in a new location, it accidentally overwrote the original data, causing it to become corrupted.

- [The DAO Attack (2016)](https://www.coindesk.com/learn/understanding-the-dao-attack)
  One of the most significant incidents in Ethereum's history, where a vulnerability in The DAO smart contract was exploited, leading to the loss of approximately 3.6M ETH. This incident ultimately led to a hard fork of the Ethereum blockchain, creating Ethereum Classic (ETC) and the current Ethereum (ETH) chain.
