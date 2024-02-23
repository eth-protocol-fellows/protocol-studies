# Keccak256

Keccak256 is a cryptographic hash function prominently used in the Ethereum blockchain. 

## Brief History

Keccak256 originated as a submission to the [NIST cryptographic hash algorithm competition](https://keccak.team/files/Keccak-submission-3.pdf). This competition aimed to identify a new secure hash algorithm to replace SHA-1. The KECCAK algorithm was designed by a team comprising Guido Bertoni, Joan Daemen, Michaël Peeters, and Gilles Van Assche. 

## Keccak design

Keccak stands out for its sponge construction, a unique feature that allows it to, "absorb," input data of any length and subsequently, "squeeze," out a hash of the desired length.

The sponge function, central to Keccak's design, operates in two distinct phases: absorption and squeezing. 

### Absorption Phase

- **Input Processing**: During this phase, the input data is divided into blocks and XORed with the sponge's state, known as the bitrate.
- **Bitrate (`r`)**: The bitrate is a parameter defining the number of bits in the state that interact directly with the input. It determines the efficiency and throughput of the data absorption process.
- **State Permutation**: After each XOR operation, a permutation function is applied to the entire state, ensuring thorough mixing of the input and state.

### Squeezing Phase

- **Output Generation**: Once the absorption is complete, the squeezing phase begins. Here, the output hash is generated from the bitrate portion of the state.
- **Arbitrary Output Length**: The squeezing phase can produce an output of any desired length.

For a deeper understanding of Keccak's internal workings, the [Keccak reference](https://keccak.team/files/CSF-0.1.pdf) provides detailed insights into its algorithms and security features.

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
