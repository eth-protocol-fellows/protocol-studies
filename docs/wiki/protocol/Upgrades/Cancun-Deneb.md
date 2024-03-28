---
eip: 7569
title: Hardfork Meta - Dencun
description: EIPs included in the Deneb/Cancun Ethereum network upgrade.
author: Tim Beiko (@timbeiko)
discussions-to: https://ethereum-magicians.org/t/dencun-hardfork-meta/16924
status: Last Call
last-call-deadline: 2024-03-01
type: Meta
created: 2023-12-01
requires: 1153, 4788, 4844, 5656, 6780, 7044, 7045, 7514, 7516, 7568
---

## Abstract

This Meta EIP lists the EIPs included in the Dencun network upgrade across both Ethereum's execution and consensus layers. 

[link to EIP-7569](https://raw.githubusercontent.com/ethereum/EIPs/master/EIPS/eip-7569.md)

[link to local wiki roadmap](https://github.com/eth-protocol-fellows/protocol-studies/blob/7afd6915cc3c1dab35853a7bb3cf940436283b8a/docs/wiki/research/roadmap.md)

[link to ethroadmap.com](https://ethroadmap.com/#pectra%20sticky)

### Included EIPs 

* [EIP-1153](./eip-1153.md): Transient storage opcodes
* [EIP-4788](./eip-4788.md): Beacon block root in the EVM
* [EIP-4844](./eip-4844.md): Shard Blob Transactions 
* [EIP-5656](./eip-5656.md): MCOPY - Memory copying instruction
* [EIP-6780](./eip-6780.md): SELFDESTRUCT only in same transaction
* [EIP-7044](./eip-7044.md): Perpetually Valid Signed Voluntary Exits
* [EIP-7045](./eip-7045.md): Increase Max Attestation Inclusion Slot
* [EIP-7514](./eip-7514.md): Add Max Epoch Churn Limit
* [EIP-7516](./eip-7516.md): BLOBBASEFEE opcode

### Activation 

| Network Name     | Activation Epoch | Activation Timestamp |
|------------------|------------------|----------------------|
| Goerli           |    `231680`      |    `1705473120`      |
| Sepolia          |    `132608`      |    `1706655072`      |
| Holešky          |    `29696`       |    `1707305664`      |
| Mainnet          |    `269568`      |    `1710338135`      |

**Note**: rows in the table above will be filled as activation times are decided by client teams. 