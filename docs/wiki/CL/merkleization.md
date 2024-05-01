# Merkleization and Hash Tree Roots 

In Ethereum consensus mechanism, it's critical for all participating nodes to agree on the state of the system consistently and efficiently. The [Simple Serialize (SSZ)](/docs/wiki/CL/SSZ.md) framework facilitates this through Merkleization, a process that transforms serialized data into a Merkle tree structure. This wiki page delves into the intricacies of Merkleization and its importance in ensuring a shared state across nodes in a scalable and secure manner.

## Terminology and Methods

- **Merkleization:** Refers to constructing a Merkle tree and deriving its root.
- **Hash Tree Root:** A specific application of Merkleization, used to compute the root hash of complex SSZ container.

## The Need for Merkleization

Cryptographic hash functions provide a solution by generating a compact, unique representation of a data set for a Beacon state. By hashing the serialized state of a Beacon chain, nodes can quickly and efficiently compare states by exchanging these small hash outputs.

## Process of Merkleization

Merkleization involves breaking down the serialized data into 32-byte chunks, which serve as the leaves of a Merkle tree. These chunks are then combined pair-wise, hashed together, and the process is repeated up the tree until a single hash—the Merkle root—is derived. This root hash acts as a unique fingerprint for the entire dataset. The key steps are as below:

- **Chunking:** Divide the serialized data into 32-byte chunks.
- **Tree Construction:** Pair up the chunks and hash each pair to form the next level of the tree. Repeat this step until only one hash remains: the Merkle root.
- **Padding:** If the number of chunks isn't a power of two, additional zero-value chunks are added to round out the tree, ensuring that the tree is balanced.

## Benefits of Merkleization

- **Performance Efficiency:** While the tree requires hashing approximately twice the original data amount, caching mechanisms can store the roots of subtrees that don't change often. This significantly reduces the computational overhead as only altered parts of the data need re-hashing.
- **Light Client Support:** The Merkle tree structure supports the creation of Merkle proofs—small pieces of data that prove the inclusion and integrity of specific parts of the state without needing the entire dataset. This feature is crucial for light clients, which operate with limited resources and rely on these proofs to interact with  Ethereum securely.

## Merkle Tree Structure and Hashing

The Merkle tree structure is organized such that every two adjacent leaf nodes are hashed together to produce a parent node, and this pairing and hashing continue upwards until a single hash is obtained at the top:

```mermaid
graph TD;
    HTR[Hash Tree Root]
    HL12[Hash of Leaves 1 and 2]
    HL34[Hash of Leaves 3 and 4]
    L1[Leaf1]
    L2[Leaf2]
    L3[Leaf3]
    L4[Leaf4]

    HTR --> HL12
    HTR --> HL34
    HL12 --> L1
    HL12 --> L2
    HL34 --> L3
    HL34 --> L4
```

_Figure: Merkle Tree Structure._

In some instances, the distribution of the leaves might require a more complex tree with varying depths per branch, especially when certain nodes (like containers with multiple elements) need additional depth.

## Generalized Indices

To facilitate direct referencing and verification within the tree, each node (both leaves and internals) is assigned a generalized index. This index is derived from the node’s position within the tree:

```mermaid
graph TD;
    1((1 / Depth 0))
    2((2 / Depth 1))
    3((3 / Depth 1))
    4((4 / Depth 2))
    5((5 / Depth 2))
    6((6 / Depth 2))
    7((7 / Depth 2))

    1 --> 2
    1 --> 3
    2 --> 4
    2 --> 5
    3 --> 6
    3 --> 7
```

_Figure: Merkle Tree Generalized Indices and Depth Levels._

- **Root Index:** 1 (depth = 0)
- **Subsequent Levels:** $2^{depth} + index$ where index is the node's zero-indexed position at that depth.

## Multiproofs Using Generalized Indices

Multiproofs using generalized indices provide an efficient way to verify specific elements within a Merkle tree without needing to know the entire tree structure. This concept is crucial in Ethereum and cryptographic applications where data integrity and verification speed are paramount. Let's break down the process using an example to understand how multiproofs work:

**Understanding the Structure**
- A Merkle tree is structured in layers, where each node is either a leaf node (containing actual data) or an internal node (containing hashes of its child nodes).
- Generalized indices numerically represent the position of each node in the tree, calculated as $2^{depth} + index$, starting from the root (index 1).

**Tree Layout for the Example**
- The tree is structured as follows, with `*` indicating the nodes required to generate the proof for the element at index 9:

```mermaid
graph TD;
    1(("1*"))---2(("2"));
    1---3(("3*"));
    2---4(("4"));
    2---5(("5*"));
    3---6(("6"));
    3---7(("7"));
    4---8(("8*"));
    4---9(("9*"));
    5---10(("10"));
    5---11(("11"));
    6---12(("12"));
    6---13(("13"));
    7---14(("14"));
    7---15(("15"));

    classDef root fill:#f96;
    classDef proof fill:#bbf;
    classDef leaf fill:#faa;

    class 1 root;
    class 2,5,8,9 proof;
```

_Figure: Merkle Tree Layout_

**Determining Required Nodes**
- **Identifying Required Hashes**: To validate the data at index 9, you need the hashes of the data at indices 8, 9, 5, 3, and 1.
- **Pairwise Hashing**: Combine the hashes of indices 8 and 9 to compute the hash corresponding to their parent node, which should be `hash(4)`.
- **Further Hash Combinations**:
  - `hash(4)` is then combined with the hash from index 5 to produce the hash of their parent node, `hash(2)`.
  - This result is combined with the hash from index 3 to work up to the next level.
- **Final Verification**: The combined result from the previous step is hashed with the root from the opposite branch (index 3) to produce the ultimate tree root (`hash 1`).
- **Integrity Check**: If the calculated root matches the known good root (`hash 1`), the data at index 9 is verified as accurate. If the data was incorrect, the resulting root would differ, indicating an error or tampering.

There are helper functions in the consensus specs to calculate the multiproofs and generalized indices. You can find [here.](https://github.com/ethereum/consensus-specs/blob/dev/ssz/merkle-proofs.md#merkle-multiproofs)

## Calculating Hash Tree Roots

The hash tree root of an SSZ object is computed recursively. For basic types and collections of basic types, the data is packed into chunks and directly Merkleized. For composite types like containers, the process involves hashing the tree roots of each component. In the below sections we will see the working examples to understand the process.

### Packing and Chunking

Packing and chunking are crucial concepts in the context of Merkleization, especially when dealing with the SSZ used in the Beacon chain. Here's how packing and chunking work:

**Serializing the Data**
- **Serialization** involves converting a data structure (basic types, lists, vectors, or bitlists/bitvectors) into a linear byte array using SSZ serialization rules.
- Each element is serialized based on its type. 

**Padding the Serialization**
- After serialization, the byte array might not perfectly align with the 32-byte chunk size used in Merkle trees.
- **Padding** is added to the serialized data to extend the last segment to a full 32-byte chunk. This padding consists of zero bytes (0x00).

**Dividing into Chunks**
- The padded serialized data is then split into multiple 32-byte segments or "chunks."
- These chunks are the basic units used in the Merkleization process.

**Padding to Full Binary Tree**
- The number of chunks from the previous step may not be a power of two, which is required to form a balanced binary tree (full binary tree).
- Additional zero chunks (chunks filled entirely with zero bytes) are added as necessary to bring the total count up to the nearest power of two.
- This ensures that the resulting Merkle tree is complete and balanced, facilitating efficient cryptographic operations.

**Applying the Merkleization Process**
- With the chunks prepared, they are arranged as the leaves of a binary Merkle tree.
- Merkleization proceeds by hashing pairs of chunks together, layer by layer, until a single hash remains. This final hash is known as the Merkle root.

**Practical Example:**
Suppose we have a list of integers that need to be packed and chunked:
- **Integers**: [10, 20, 30, 40] (Suppose each integer occupies 8 bytes).
- **Serialized Data**: A continuous byte array created from these integers.
- **Padding**: If the total serialized length is not a multiple of 32, padding bytes are added.
- **Chunks**: The data is divided into 32-byte chunks.
- **Zero Padding for Tree**: If the number of chunks is not a power of two, additional zero-filled chunks are appended.
- **Merkleization**: The chunks are then used as leaves in a Merkle tree to compute the root.

### Mixing in the Length


## Summaries and Expansions


## Merkleization for Basic Types


## Merkleization for Composite Types





## Resources
- [Hash Tree Roots and Merkleization](https://eth2book.info/capella/part2/building_blocks/merkleization/)
- [SSZ](https://ethereum.org/en/developers/docs/data-structures-and-encoding/ssz/)
- [Protolambda on Merkleization](https://github.com/protolambda/eth2-docs?tab=readme-ov-file#ssz-hash-tree-root-and-merkleization)