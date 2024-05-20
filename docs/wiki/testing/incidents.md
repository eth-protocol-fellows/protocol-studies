# Notable mainnet incidents

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.
> Incidents are the disruptions, vulnerabilities and attacks faced by the network which has questioned it's stability and security. Below are some incidents that affected the network and their sources.

- [Post-Mortem Report: Ethereum Mainnet Missing Blocks (27/03/2024)](https://u.today/ethereum-developers-investigate-incident-that-triggered-missing-blocks-on-eth-mainnet) Earlier in March 2024, the beacon chain faced a disruption which characterized in some blocks get missing from the network, this incident went on for about a week before it was resolved by the core engineers, sources are yet to discover if this was triggered by the dencun upgrade.

- [Post-Mortem Report: Ethereum Mainnet DOS Incident (07/02/2024)](https://blog.ethereum.org/2024/03/21/sepolia-incident) It was discovered that there was a possibility for a Denial-of-service attack dating from when the merge happened to the dencun hard fork. An attacker could create a block exceeding the specified limit of 5mb and adding multiple transactions into the block each not up to 128kb while also making sure that the transactions within the block have a collective gas which is below 30 million. With this action most nodes will reject the blocks which will lead to minority nodes acceptance creating forked blocks and missed proposer rewards.

- [Post-Mortem Report: Ethereum Mainnet Finality (05/11/2023)](https://medium.com/offchainlabs/post-mortem-report-ethereum-mainnet-finality-05-11-2023-95e271dfd8b2) The Mainnet had some disruptions, which led to blocks not getting produced leading to a significant delay in transactions reaching finality, this continued for two days and resulted in an inactivity consequence, the network fully recovered without intervention.

- [Post-Mortem Report: Minority Split (2021-08-27)](https://github.com/ethereum/go-ethereum/blob/master/docs/postmortems/2021-08-22-split-postmortem.md) This happened when Geth tried to assign data back into memory after the `datacopy` operation. Instead of saving the data in a new location, it accidentally overwrote the original data, causing it to become corrupted.
