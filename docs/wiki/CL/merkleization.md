# Merkleization and Hash Tree Roots 

In Ethereum consensus mechanism, it's critical for all participating nodes to agree on the state of the system consistently and efficiently. The [Simple Serialize (SSZ)](/docs/wiki/CL/SSZ.md) framework facilitates this through Merkleization, a process that transforms serialized data into a Merkle tree structure. This wiki page delves into the intricacies of Merkleization and its importance in ensuring a shared state across nodes in a scalable and secure manner.

## Terminology and Methods

- **Merkleization:** Refers to constructing a Merkle tree and deriving its root.
- **Hash Tree Root:** A specific application of Merkleization, used to compute the root hash of complex SSZ container.

## The Need for Merkleization

Cryptographic hash functions provide a solution by generating a compact, unique representation of a data set for a Beacon state. By hashing the serialized state of a Beacon chain, nodes can quickly and efficiently compare states by exchanging these small hash outputs.

## Process of Merkleization


## Benefits of Merkleization


## Calculating Hash Tree Roots


### Packing and Chunking


### Mixing in the Length


## Summaries and Expansions


## Merkleization for Basic Types


## Merkleization for Composite Types





## Resources
- [Hash Tree Roots and Merkleization](https://eth2book.info/capella/part2/building_blocks/merkleization/)
- [SSZ](https://ethereum.org/en/developers/docs/data-structures-and-encoding/ssz/)
- [Protolambda on Merkleization](https://github.com/protolambda/eth2-docs?tab=readme-ov-file#ssz-hash-tree-root-and-merkleization)