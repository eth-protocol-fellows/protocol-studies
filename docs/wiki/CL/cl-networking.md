# Networking

The Consensus clients use [libp2p][libp2p] as the peer-to-peer protocol, [libp2p-noise][libp2p-noise] for encryption, [discv5][discv5] for peer discovery, [SSZ][ssz] for encoding, and, optionally, [Snappy][snappy] for compression.

For those looking to deepen their understanding of libp2p, Study Group Session Week-5, [Lecture 19]("https://epf.wiki/#/eps/day19") by Dapplion is a great resource.

## Specs

The [Phase 0 -- Networking][consensus-networking] page specifies the network fundamentals, protocols, and rationale/design choices. The subsequent forks also specify the changes done in that respective fork.

## libp2p - P2P protocol

[libp2p][libp2p-docs] is the protocol used for peer to peer communication. It was orginially developed for IPFS. [libp2p and Ethereum][libp2p-and-eth] is a great article for a deep-dive on the history of libp2p, and its adoption in the Consensus clients. It allows comunication over multiple transport protocols like TCP, QUIC, WebRTC, etc.

<figure class="diagram" style="text-align:center">

![libp2p_protocols](../../images/cl/cl-networking/libp2p_protocols.png)

<figcaption>

_The various protocols which are a part of libp2p._

</figcaption>
</figure>

libp2p protocol is a multi-transport stack.

1. **Transport** : It must support TCP (Transmission Control Protocol), may support [QUIC][quic] (Quick UDP Internet Connections) which must both allow incoming and outgoing connections. TCP and QUIC both support IPv4 and IPv6, but due for better compatibility IPv4 support is required.
2. **Encryption and Identification** : [libp2p-noise][libp2p-noise] secure channel is used for encryption
3. **Multiplexing** : Multiplexing allows multiple independent communications streams to run concurrently over a single network connection. Two multiplexers are commonplace in libp2p implementations: [mplex][mplex] and [yamux][yamux]. Their protocol IDs are, respectively: `/mplex/6.7.0` and `/yamux/1.0.0`. Clients must support mplex and may support yamux with precedence given to the latter.
4. **Message Passing** : To pass messages over the network libp2p implements [Gossipsub][gossipsub] (PubSub) and [Req/Resp][req-resp] (Request/Response). Gossipsub uses topics and Req/Resp uses messages for communication.

<figure class="diagram" style="text-align:center">

![gossibsub_optimization](../../images/cl/cl-networking/gossipsub_optimization.png)

<figcaption>

_Gossipsub Optimization_

</figcaption>
</figure>

#### What optimization does Gossibhub provide?
**Approach 1:** Maintain a fully connected mesh (all peers connected to each other 1:1), which scales poorly (O(n^2)). Why this scales poorly? Each node may recieve the same message from other (n-1) nodes , hence wasting a lot of bandiwidth. If a the message is a block data, then the wasted bandwith is exponentially large.

**Approach 2:** Pubsub (Publish-Subscribe Model) messaging pattern is used where senders (publishers) don’t send messages directly to receivers (subscribers). Instead, messages are published to a common channel (or topic), and subscribers receive messages from that channel without direct interaction with the publisher. The nodes mesh with a particular number of other nodes for a topic, and those with other nodes. Hence, allowing more efficient message passing.

###### **Gossipsub : TODO**
###### **Req/Resp : TODO**

## libp2p-noise - Encryption

The [Noise framework][noise-framework] is not a protocol itself, but a framework for designing key exchange protocols. The [specification][noise-specification] is a great place to start.

There are many [patterns][noise-patterns] which describe the key exchange process. The pattern used in the consensus clients is [`XX`][noise-xx] (transmit-transmit), meaning that both the initiator, and responder transmit their public key in the initial stages of the key exchange.

## ENR (Ethereum Node Records)

[Ethereum Node Records][ENR] provide a structured, flexible way to store and share node identity and connectivity details in Ethereum’s peer-to-peer network. It is a future-proof format that allows easier exchange of identifying information between new peers and is the preferred [network address format][network-add-format] for Ethereum nodes.

Its core components are:

1. **Signature**: Each record is signed using an identity scheme (e.g., secp256k1) to ensure authenticity.
2. **Sequence Number** (seq): A 64-bit unsigned integer that increments whenever the record is updated, allowing peers to determine the latest version.
3. **Key/Value Pairs**: The record holds various connectivity details as key-value pairs.

## discv5

Discovery Version 5 [(discv5)][discv5] (Protocol version v5.1) runs on UDP and meant for peer discovery only. It enables nodes to exchange and update ENRs dynamically, ensuring up-to-date peer discovery. It runs in parallel with libp2p.

<figure class="diagram" style="text-align:center">

![discv5](../../images/cl/cl-networking/discv5.png)

<figcaption>

_discv5_

</figcaption>
</figure>

## SSZ - Encoding

[Simple serialize (SSZ)][ssz] replaces the [RLP][rlp] serialization used on the execution layer everywhere across the consensus layer except the peer discovery protocol. SSZ is designed to be deterministic and also to Merkleize efficiently. SSZ can be thought of as having two components: a serialization scheme and a Merkleization scheme that is designed to work efficiently with the serialized data structure.

## Snappy - Compression

[Snappy][snappy] is a compression scheme created by engineers at Google in 2011. Its main design considerations prioritize compression/decompression speed, while still having a reasonable compression ratio.

## Related R&D

- [EIP-7594][peerdas-eip] - Peer Data Availability Sampling (PeerDAS)

  A networking protocol that allows beacon nodes to perform data availability
  sampling (DAS) to ensure that blob data has been made available while
  downloading only a subset of the data.

  - [Consensus Specs][peerdas-specs]
  - [ETH Research][peerdas-ethresearch]

## Resources

- [ENR rust docs][enr-rust-docs]
- [Eth1+Eth2 client relationship][eth1+2-client]
- Libp2p, ["docs"][libp2p-docs] and ["specs"][libp2p-specs]
- Technical Report, ["Gossipsub-v1.1 Evaluation Report"][gossipsub-report]

[consensus-networking]: https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/p2p-interface.md
[libp2p-and-eth]: https://blog.libp2p.io/libp2p-and-ethereum/
[libp2p-noise]: https://github.com/libp2p/specs/tree/master/noise
[libp2p-docs]: https://docs.libp2p.io/
[libp2p-specs]: https://github.com/libp2p/specs
[noise-framework]: https://noiseprotocol.org/
[noise-patterns]: https://noiseexplorer.com/patterns/
[noise-specification]: https://noiseprotocol.org/noise.html
[noise-xx]: https://noiseexplorer.com/patterns/XX/
[discv5]: https://github.com/ethereum/devp2p/blob/master/discv5/discv5.md
[peerdas-eip]: https://github.com/ethereum/EIPs/pull/8105
[peerdas-ethresearch]: https://ethresear.ch/t/peerdas-a-simpler-das-approach-using-battle-tested-p2p-components/16541
[peerdas-specs]: https://github.com/ethereum/consensus-specs/pull/3574
[rlp]: https://ethereum.org/developers/docs/data-structures-and-encoding/rlp
[snappy]: https://en.wikipedia.org/wiki/Snappy_(compression)
[ssz]: https://ethereum.org/developers/docs/data-structures-and-encoding/ssz
[blog]: https://medium.com/coinmonks/dissecting-the-ethereum-networking-stack-node-discovery-4b3f7895f83f
[enr-rust-docs]: https://docs.rs/enr/latest/enr
[eth1+2-client]: https://ethresear.ch/t/eth1-eth2-client-relationship/7248
[gossipsub-report]: https://research.protocol.ai/publications/gossipsub-v1.1-evaluation-report/vyzovitis2020.pdf
[ENR]: https://eips.ethereum.org/EIPS/eip-778
[network-add-format]: https://dean.eigenmann.me/blog/2020/01/21/network-addresses-in-ethereum/
[quic]: https://datatracker.ietf.org/doc/rfc9000/
[yamux]: https://github.com/libp2p/specs/blob/master/yamux/README.md
[mplex]: https://github.com/libp2p/specs/tree/master/mplex
[gossipsub]: https://github.com/libp2p/specs/tree/master/pubsub/gossipsub
[req-resp]: https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/p2p-interface.md#the-reqresp-domain
