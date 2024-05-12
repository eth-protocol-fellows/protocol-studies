# Light Clients

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

Ethereum users are connecting to the network using an execution client RPC. This allows them to interact with the network, read balances, submit transactions, etc. Running the client and verifying the current state can be a demanding task requiring hundreds of GBs storage space, bandwidth and computation. Most wallets default to using a third party API to connect to the network without verifying the provided data. 

The idea of a light client is to enable trustless access to the network without overhead of running a full node. Light client is a general term for this concept but the actual approach is using different designs. There are multiple kinds of light clients, some in production, some still being researched and developed. 

- Verifying EL RPC data using Beacon root from a CL client
- Stateless clients
- LES protocol
- Portal network

## RPC proxy light client 

This sort of light clients connect to an RPC provider and improves the security by verifying responses using a proof from an independent Beacon Node. It's basically an RPC proxy or a middleware which ensures that data from the provider are valid. 
It improves the trust model of a wallet/service connected to a third party RPC but doesn't act as a node in the network. With this light client approach, users still need to connect to some RPC provider, a centralized entity.

Clients communicating in the network over p2p protocol don't have specific functions for specific pieces of data like with RPC. They can get current tip from the peer, request historical blocks, etc. And to verify them, they also need connection to a consensus client. There is no way to request balance of an address over p2p, only download blocks/state, verify and find it yourself. With this approach, we basically arrive at the behavior of a normal node in the network. 

The implementation of the RPC verifying 'light client' is for example [Helios](https://github.com/a16z/helios) or [Kevlar](https://github.com/lightclients/kevlar). User can run them as a proxy between an app/wallet and their rpc provider. They offer a default connection to a public beacon node so the chance that both of these providers lie in the same exact way is minimal. There was a [project trying to implement the CL p2p in Helios](ttps://github.com/eth-protocol-fellows/cohort-three/blob/master/projects/helios-cl-p2p.md) in order to use it directly with cl libp2p instead of relying on a third party Beacon API. 

## Stateless clients

Using witnesses gossiped over p2p network to verify the data without full state.

## Portal Network

Portal creates an overlay network which guarantees data integrity probabilistically. 

## LES

Light client mode pioneered by Geth enables to run a node in light config which subscribes to les p2p protocol. The node doesn't download the entire chain, only downloads the latest data from other nodes serving les. The full node needs to be configured to provide les data, it's not a default option. Therefore there are not enough les providers in the network to enable using geth in light mode reliable. 