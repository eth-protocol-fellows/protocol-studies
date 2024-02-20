# Keccak256

Keccak256 is a cryptographic hash function prominently used in the Ethereum blockchain. 

## Brief History

Keccak256 originated as a submission to the [NIST cryptographic hash algorithm competition](https://csrc.nist.gov/projects/hash-functions/nist-hash-function-competition). This competition aimed to identify a new secure hash algorithm to replace SHA-1. The KECCAK algorithm was designed by a team comprising Guido Bertoni, Joan Daemen, Michaël Peeters, and Gilles Van Assche. Their design was notable for its ability to absorb a phrase of arbitrary length and produce a fixed-size output. 

## EVM Implementation
While SHA-3 is the official version of the algorithm, Ethereum utilizes a modified variant known as Keccak256. This version is tailored for a maximum input of 256 bits. The [Ethereum Virtual Machine (EVM)](https://ethereum.org/en/developers/docs/evm/), a Turing-complete virtual machine, employs Keccak256 for data hashing. The EVM is a crucial component of the Ethereum network, facilitating the execution of arbitrary code and smart contracts.
