# Simple Serialize (SSZ)

## Overview

Simple Serialize (SSZ) is a serialization and Merkleization scheme designed specifically for Ethereum's Beacon Chain. SSZ replaces the [RLP serialization](/docs/wiki/EL/RLP.md) used on the execution layer (EL) everywhere across the consensus layer (CL) except the [peer discovery protocol](https://github.com/ethereum/devp2p). Its development and adoption are aimed at enhancing the efficiency, security, and scalability of Ethereum's CL.


## Resources
- [Simple serialize](https://ethereum.org/en/developers/docs/data-structures-and-encoding/ssz/)
- [SSZ specs](https://github.com/ethereum/consensus-specs/blob/dev/ssz/simple-serialize.md)
- [eth2book - SSZ](https://eth2book.info/capella/part2/building_blocks/ssz/#ssz-simple-serialize)
- [Go Lessons from Writing a Serialization Library for Ethereum](https://rauljordan.com/go-lessons-from-writing-a-serialization-library-for-ethereum/)