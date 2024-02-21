# Keccak256

Keccak256 is a cryptographic hash function prominently used in the Ethereum blockchain. 

## Brief History

Keccak256 originated as a submission to the [NIST cryptographic hash algorithm competition](https://csrc.nist.gov/projects/hash-functions/nist-hash-function-competition). This competition aimed to identify a new secure hash algorithm to replace SHA-1. The KECCAK algorithm was designed by a team comprising Guido Bertoni, Joan Daemen, Michaël Peeters, and Gilles Van Assche. Their design was notable for its ability to absorb a phrase of arbitrary length and produce a fixed-size output. 

## EVM Implementation
While SHA-3 is the official version of the algorithm, Ethereum utilizes a modified variant known as Keccak256. This version is tailored for a maximum input of 256 bits. The [Ethereum Virtual Machine (EVM)](https://ethereum.org/en/developers/docs/evm/), a Turing-complete virtual machine, employs Keccak256 for data hashing. 

## Usage in Block Creation and Root Data Structure
Keccak256 plays a vital role in Ethereum's block creation and in its root data structures. According to the [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf), the function is used in several key ways:

- **Block Header Fields**: Various fields in the block header, such as `parentHash` and `stateRoot`, use the Keccak 256-bit hash. This includes hashing the entire header of the parent block, the root node of the state trie, and the root nodes of the trie structures for transactions and receipts.
- **Merkle Patricia Tree**: Ethereum employs a Merkle Patricia Tree to encode its state, where each node in the tree is identified through the Keccak 256-bit hash of its content. This structure underpins the stateRoot field in the block header.
- **Storage Contents Encoding**: The hash is used to encode the storage contents of accounts, mapping the Keccak 256-bit hash of integer keys to the RLP-encoded integer values.

In all these instances, Keccak256's role is critical for ensuring data integrity, facilitating efficient data retrieval, and supporting the blockchain's underlying security mechanisms.

## References
- [NIST SHA-3 Competition](https://csrc.nist.gov/projects/hash-functions/nist-hash-function-competition)
- [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)
