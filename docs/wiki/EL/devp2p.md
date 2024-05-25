# DevP2P

This section will cover the networking protocol used by the Execution Layer (EL).
First, we will provide some background on computer networks and then we will dive into the
specifics of the EL's networking protocol.

## Computer networks background
This section covers a brief overview of the differences and similarities between the OSI (Open Systems Interconnection) and TCP/IP (Transmission Control Protocol/Internet Protocol) models,
as well as the protocols involved in the transport layer used in DevP2P: TCP and UDP.

In terms of networking, both models refer to the same process of communication between layers.
Just as Kurose and Ross explain (2020), the computer networks are divided into different layers, and each one of them has a specific responsibility. The OSI model has seven layers, while the TCP/IP model has four layers. The OSI model is more theoretical and the TCP/IP model is more practical. The OSI model is a reference model created by the International Organization for Standardization (ISO) to provide a framework for understanding networks. The TCP/IP model was created by the Department of Defense (DoD) to ensure that messages could be transmitted between computers regardless of the types of computers involved. The TCP/IP model is a concise version of the OSI model:

![alt text](../../images/el-architecture/osi-tcpip-models.png)

In summary, the OSI model layers are:
1. Physical layer: responsible for the transmission and reception of raw data between devices.
2. Data link layer: responsible for the node-to-node delivery of the message.
3. Network layer: responsible for the delivery of packets from the source to the destination.
4. Transport layer: responsible for the delivery of data between the source and the destination.
5. Session layer: responsible for the establishment, management, and termination of connections between applications.
6. Presentation layer: responsible for the translation, compression, and encryption of data.
7. Application layer: responsible for providing network services directly to the end-user.

Assuming the communication schema proposed by Claude Shannon (1948), every communication implies both a sender and a receiver, a message to be exchanged between them, a transmission medium, and a protocol to be followed.
This is important to mention because regardless of the computer architecture, it could be part of a network if it follows the communication and protocol specifications of the models mentioned above.

Focusing on the transport layer, the two protocols used by DevP2P are TCP (Transmission Control Protocol) and UDP (User Datagram Protocol).
Both protocols are used to send data over the internet, but they have different characteristics. Just as Tanenbaum points it out (2021),TCP is a connection-oriented protocol, which means that it establishes a connection between the sender and the receiver before sending data. It is reliable because it ensures that the data is delivered in the correct order and without errors. UDP is a connectionless protocol, which means that it does not establish a connection before sending data. It is faster than TCP because it does not have to establish a connection before sending data, but it is less reliable because it does not ensure that the data is delivered in the correct order or without errors.

![img.png](../../images/el-architecture/tcpudp.png)

## EL's networking specs
* peer-to-peer networking protocol
* gossiping data (1:N) and request/response (1:1) communication
* Client software divided into Execution and Consensus (each one have its own p2p network)
* Execution network propagates transactions
* Two network stacks:
  * UDP-based transport layer (discovery and finding peers)
  * TCP-based transport layer (devp2p, exchange information) 
* Discovery protocol

How nodes find each other
  * bootstrap nodes
  * Kademlia
  * Hash tables
  * PING/PONG hashed messages
  * Find neighbours: list of peers

start client --> connect to bootnode --> bond to bootnode --> find neighbours --> bond to neighbours

## ENR: Ethereum Node Records
* Standard format for connectivity for nodes
* Node's identity
* Object
  * signature (hash)
  * sequence number
  * arbitrary key-value pairs

## DevP2P specs
* RLPx: encrypted and authenticated transport protocol (TCP based transport system for nodes communication)
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
* Andrew S. Tanenbaum, Nick Feamster, David J. Wetherall (2021). *Computer Networks*. 6th edition. Pearson. London.
* Jim Kurose and Keith Ross (2020). *Computer Networking: A Top-Down Approach*. 8th edition. Pearson.
* Clause E. Shannon (1948). "A Mathematical Theory of Communication". *Bell System Technical Journal*. Vol. 27.
