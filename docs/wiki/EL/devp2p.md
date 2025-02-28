# Execution p2p

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.


[DevP2P](https://github.com/ethereum/devp2p) is a set of networking protocols that underpins Ethereum’s execution-layer peer-to-peer network. It was created before libp2p existed and designed specifically to serve Ethereum's early networking requirements.

## Core Components

### 1. Ethereum Node Records (ENR)

- ENRs allow nodes to advertise connectivity details and capabilities, enabling peers to determine if and how to connect.
- **Origin**: Originally proposed in [EIP-778](https://eips.ethereum.org/EIPS/eip-778)

#### Record Structure

A node record is composed of:

- **`signature`**: A cryptographic signature that ensures the record’s integrity.
- **`seq`**: A 64-bit unsigned integer (sequence number) that should be incremented with every update.
- **Key/Value Pairs**: Sorted, unique pairs that include metadata and connection information.

The pre-defined keys include:

| Key         | Description                                          |
|:------------|:-----------------------------------------------------|
| `id`        | Identity scheme name (e.g., "v4")                    |
| `secp256k1` | Compressed secp256k1 public key (33 bytes)           |
| `ip`        | IPv4 address (4 bytes)                               |
| `tcp`       | TCP port (big-endian integer)                        |
| `udp`       | UDP port (big-endian integer)                        |
| `ip6`       | IPv6 address (16 bytes)                              |
| `tcp6`      | IPv6 TCP port (big-endian integer)                   |
| `udp6`      | IPv6 UDP port (big-endian integer)                   |

*Note*: All keys except `id` are optional. 



#### "v4" Identity Scheme

The default identity scheme is `"v4"`, which is compatible with Node Discovery v4.

more info about [Ethereum Node Records](https://github.com/ethereum/devp2p/blob/master/enr.md)

### 2. Discovery Protocols (Discv4 & Discv5)

Ethereum uses a **Node Discovery Protocol** to enable decentralized peer-to-peer networking. The protocol helps nodes locate and connect with each other efficiently. 
Two versions exist:  

- **Discv4** 
- **Discv5**

#### Discv4
A structured, distributed system that allows Ethereum nodes to discover peers without central coordination.  

- **Node Identities**  
  - Each node is identified by a secp256k1 key pair.  
  - The public key serves as the node’s unique identifier (Node ID).  
  - Distance between nodes is computed using XOR of hashed public keys.  

- **Node Records (ENR)**  
  - Nodes store and share connection details using Ethereum Node Records (ENRs).  
  - The "v4" identity scheme is used to verify node authenticity.  
  - Peers can request a node’s latest ENR via an **ENRRequest** packet.  

- **Kademlia Table**  
  - Nodes maintain a **routing table** with 256 **k-buckets** (each holding up to 16 entries).  
  - A bucket stores nodes within a specific distance range (e.g., `[2^i, 2^(i+1))`).  
  - Nodes are sorted by last-seen time, ensuring stale nodes are replaced when the table is full.  

- **Endpoint Verification (Proof-of-Participation)**  
  - Prevents amplification attacks by verifying nodes before responding to queries.  
  - A node is considered verified if it has sent a valid **Pong** response to a recent **Ping** request.  

- **Recursive Lookup Algorithm**  
  - Finds the `k` (typically 16) closest nodes to a target.  
  - The search begins by querying a small, selected subset of the closest known nodes (`α`, often set to 3).  
  - The lookup is **iterative**, querying new nodes found in previous steps until no closer nodes are discovered.  

- **Wire Protocol & Message Types**  
  - Messages are sent over **UDP** .  
  - Each packet contains a header (`hash`, `signature`, `packet-type`) followed by encoded data.  
  - Core message types:  
    - **Ping (0x01):** Verify node availability.  
    - **Pong (0x02):** Response to a Ping, proving reachability.  
    - **FindNode (0x03):** Request nodes near a target ID.  
    - **Neighbors (0x04):** Reply to FindNode with closest known peers.  
    - **ENRRequest (0x05):** Request a node’s latest ENR.  
    - **ENRResponse (0x06):** Provide an ENR in response to a request.  


#### Discv5

discv5 enables nodes to find and connect with peers without relying on centralized directories.
Inspired by the Kademlia DHT, discv5 differs by storing only signed node records (ENR) instead of arbitrary key-value pairs. This ensures authenticity and integrity in peer discovery.

- **Ethereum Node Records (ENR)**
  - Each node maintains an **Ethereum Node Record (ENR)**, storing **connectivity details, cryptographic keys, and metadata**.
  - ENRs are signed, self-contained, and update dynamically.
  - Peers can request the latest ENR using an **ENRRequest packet**.

- **Encrypted Wire Protocol**
  - Uses **AES-GCM encryption** for confidentiality and authenticity.
  - Establishes **session keys via ECDH** (Elliptic Curve Diffie-Hellman).
  - Implements a **WHOAREYOU challenge-response mechanism** to prevent spoofing.

- **Kademlia-Based Routing & Node Table**
  - Nodes maintain a **routing table (k-buckets)** with peers sorted by XOR distance.
  - The lookup process recursively queries the closest known nodes.
  - The protocol supports **adaptive routing and self-healing**.

- **Recursive Node Lookup & Peer Discovery**
  - Nodes find peers through **iterative Kademlia-based lookups**.
  - Uses parallelized queries to **increase resilience against adversaries**.
  - Bootstrap nodes facilitate new node entry.

- **Topic Advertisement & Service Discovery**
  - Nodes advertise services via **topic advertisements**.
  - Searches for nodes providing a service use **Kademlia lookups within a topic radius**.
  - Adaptive **radius estimation** ensures efficient searches.

- **Wire Protocol & Message Types**
  | **Message**    | **Function** |
  |---------------|-------------|
  | **Ping** (0x01) | Checks if a node is alive. |
  | **Pong** (0x02) | Response to Ping, confirms reachability. |
  | **FindNode** (0x03) | Requests peers near a target ID. |
  | **Nodes** (0x04) | Responds to FindNode with known peers. |
  | **ENRRequest** (0x05) | Requests the latest ENR of a node. |
  | **ENRResponse** (0x06) | Provides the requested ENR. |
  | **WhoAreYou** (0x07) | Authentication challenge. |
  | **Handshake** (0x08) | Establishes encrypted sessions. |
  | **TalkReq / TalkResp** (0x09/0x0A) | Enables custom application protocols. |



#### Comparison: Discv4 vs. Discv5
| Feature                 | Discv4 | Discv5 |
|-------------------------|--------|--------|
| **Node Records**        | Basic ENR | Extensible ENR with metadata |
| **Security**            | Plaintext | AES-GCM encrypted |
| **Handshake**           | None | Secure session establishment |
| **Service Discovery**   | Limited | Topic-based lookup |
| **Extensibility**       | Static | Supports multiple identity schemes |
| **Clock Dependence**    | Required | Eliminated |
| **Scalability**         | Moderate | Optimized for large networks |

### 3.RLPx Transport Protocol

**RLPx** is a **TCP-based encrypted transport protocol** for peer-to-peer (p2p) communication in Ethereum.It facilitates **secure message exchange** and **capability negotiation** while supporting multiple protocols over a single connection.RLPx is named after the RLP serialization format.



#### ECIES Encryption

- RLPx uses **Elliptic Curve Integrated Encryption Scheme (ECIES)** for secure **handshaking and session establishment**.
- The cryptosystem consists of:
  - **Elliptic Curve**: secp256k1
  - **Key Derivation Function (KDF)**: NIST SP 800-56 Concatenation KDF
  - **Message Authentication Code (MAC)**: HMAC-SHA-256
  - **Encryption Algorithm**: AES-128-CTR

##### Encryption Process

1. **Initiator generates a random ephemeral keypair**.
2. Computes **shared secret** using **Elliptic Curve Diffie-Hellman (ECDH)**.
3. Derives encryption (`kE`) and MAC (`kM`) keys from the **shared secret**.
4. Encrypts the message using **AES-128-CTR**.
5. Computes a **MAC** over the encrypted message for integrity.
6. Sends the encrypted payload.

##### Decryption Process

1. **Recipient extracts the sender’s ephemeral public key**.
2. Computes the **shared secret** using **ECDH**.
3. Derives `kE` and `kM`, then verifies the **MAC**.
4. **Decrypts** the message using **AES-128-CTR**.


##### Node Identity

- **Ethereum nodes maintain a persistent secp256k1 keypair** for identity.
- The **public key** serves as the **Node ID**.
- The **private key is stored securely** and remains unchanged across sessions.


##### Initial Handshake

- RLPx connections are **established over TCP** and use an **encrypted handshake** to negotiate session keys.

##### Handshake Process

1. **Initiator sends an `auth` message**, encrypted using the recipient’s public key.
2. **Recipient decrypts and verifies** the `auth` message.
3. **Recipient responds with `auth-ack`**, containing an ephemeral public key.
4. **Both nodes derive shared session keys** from the exchanged ephemeral keys.
5. **The first encrypted frame** (containing the `Hello` message) is sent.
6. **Handshake is complete** once both nodes authenticate the first frame.

##### Generated Secrets

| Secret | Description |
|--------|------------|
| `static-shared-secret` | `ECDH(node-private-key, remote-node-pubkey)` |
| `ephemeral-key` | `ECDH(ephemeral-private-key, remote-ephemeral-pubkey)` |
| `shared-secret` | `keccak256(ephemeral-key || keccak256(nonce || initiator-nonce))` |
| `aes-secret` | `keccak256(ephemeral-key || shared-secret)` |
| `mac-secret` | `keccak256(ephemeral-key || aes-secret)` |



#### Message Framing

- **Frames encapsulate encrypted messages** for efficient and secure communication.
- **Multiplexing** allows multiple protocols to run over a single RLPx connection.

##### Frame Structure

| Field | Description |
|-------|------------|
| `header-ciphertext` | AES-encrypted **header** containing frame metadata. |
| `header-mac` | **MAC** over the header for integrity verification. |
| `frame-ciphertext` | AES-encrypted **message data**. |
| `frame-mac` | **MAC** over the encrypted message data. |

##### MAC Calculation

- Uses **two keccak256 MAC states** (one for **ingress**, one for **egress**).
- The MAC state is updated as frames are sent or received.
- Ensures **message integrity** and prevents **tampering**.


#### Capability Messaging

- **Capabilities** define the supported protocols on a given connection.
- **Multiplexing** enables concurrent usage of multiple capabilities.

##### Message Structure

| Field | Description |
|-------|------------|
| `msg-id` | Unique identifier for the message type. |
| `msg-data` | **RLP-encoded** message payload. |
| `frame-size` | **Compressed size** of `msg-data`. |


#### P2P Capability Messages

- The **"p2p" capability** is **mandatory** and used for initial negotiation.

#### Core Messages

| Message | ID | Function |
|---------|----|----------|
| `Hello` | `0x00` | Announces supported capabilities. |
| `Disconnect` | `0x01` | Initiates a graceful disconnection. |
| `Ping` | `0x02` | Checks if the peer is alive. |
| `Pong` | `0x03` | Responds to a `Ping`. |

#### Disconnect Reasons

| Code | Reason |
|------|--------|
| `0x00` | Requested disconnect. |
| `0x02` | Protocol violation. |
| `0x03` | Useless peer. |
| `0x05` | Already connected. |
| `0x06` | Incompatible protocol version. |
| `0x09` | Unexpected identity. |




### 4. Application-Level Subprotocols  

- **RLPx supports multiple application-level subprotocols** that enable specialized communication between Ethereum nodes.
- These subprotocols are **built on top of the RLPx transport layer** and are used for  data exchange, state synchronization, and light client support.

#### Common Ethereum Subprotocols  

| **Subprotocol** | **Purpose** |
|---------------|------------|
| **Ethereum Wire Protocol (`eth`)** | Handles **blockchain data exchange**, including block propagation and transaction relaying. |
| **Ethereum Snapshot Protocol (`snap`)** | Used for **state synchronization**, allowing nodes to download portions of the state trie. |
| **Light Ethereum Subprotocol (`les`)** | Supports **light clients**, enabling them to request data from full nodes without storing the full state. |
| **Portal Network (`portal`)** | A decentralized **state, block, and transaction retrieval network** for lightweight clients. |
