# DevP2P

This section will cover the networking protocol used by the Execution Layer (EL).
First, we will provide some background on computer networks and then we will dive into the
specifics of the EL's networking protocol.

## Computer networks background
* Distributed network of nodes
* OSI vs TCP/IP model
## EL's networking specs
* peer-to-peer networking protocol
* gossiping data (1:N) and request/response (1:1) communication
* Client software divided into Execution and Consensus (each one have its own p2p network)
* Execution network propagates transactions
* Two network stacks:
  * UDP-based transport layer (discovery and finding peers)
  * TCP-based transport layer (devp2p, exchange information) 
* Discovery protocol
  * bootstrap nodes
  * Kademlia
  * Hash tables
  * PING/PONG hashed messages
  * Find neighbours: list of peers

start client --> connect to bootnode --> bond to bootnode --> find neighbours --> bond to neighbours

## ENR: Ethereum Node Records
* Node's identity
* Object
  * signature (hash)
  * sequence number
  * arbitrary key-value pairs

## DevP2P specs
* RLPx: encrypted and authenticated transport protocol
  * Handshake messaging
  * Encryption
  * Authentication
* RLP: Recursive Length Prefix encoding
* Multiplexing: multiple subprotocols
* Subprotocols
  * LES: Light Ethereum Subprotocol
  * Witness Subprotocol
  * Wire Subprotocol
  * SHH: Whisper Subprotocol


### Further Reading
* [Geth devp2p docs](https://geth.ethereum.org/docs/tools/devp2p)
* [Ethereum devp2p GitHub](https://github.com/ethereum/devp2p)
