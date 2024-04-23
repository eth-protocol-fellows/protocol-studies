# Precompiled contracts

Precompiled contracts are a set of special accounts, each containing a built-in function with a determined gas cost, often related to complex cryptographic computations. Currently, they are defined at addresses ranging from `0x01` to `0x0a`.

Unlike contract accounts, precompiles are part of the Ethereum protocol and implemented by [execution clients](/wiki/EL/el-clients.md). This presents an interesting caveat - their `EXTCODESIZE` within EVM is 0. Nonetheless, they function like contract accounts with code when executed.

Precompiles are included in the initial `"accessed_addresses"` of a transaction as defined by [EIP-2929](https://eips.ethereum.org/EIPS/eip-2929) to save gas costs.

## Precompiles vs. opcodes

Both precompiles and opcodes have the same goal of performing arbitrary computations. Following considerations are made when choosing between them:

- **Limited opcode space**: The EVM opcode space of 1-byte is inherently constrained (256 opcodes, `0x00`-`0xFF`). This necessitates judicious allocation for essential operations.
- **Efficiency**: Precompiled contracts are natively executed outside the EVM, enabling efficient implementations for complex cryptographic computations that power many cross-chain interactions.

Quoting ["A Prehistory of the Ethereum Protocol"](https://vitalik.eth.limo/general/2017/09/14/prehistory.html) by Vitalik:

> The second was the idea of "precompiles", solving the problem of allowing complex cryptographic computations to be usable in the EVM without having to deal with EVM overhead. We had also gone through many more ambitious ideas about "native contracts", where if miners have an optimized implementation of some contracts they could "vote" the gasprice of those contracts down, so contracts that most miners could execute much more quickly would naturally have a lower gas price; however, all of these ideas were rejected because we could not come up with a cryptoeconomically safe way to implement such a thing. An attacker could always create a contract which executes some trapdoored cryptographic operation, distribute the trapdoor to themselves and their friends to allow them to execute this contract much faster, then vote the gasprice down and use this to DoS the network. Instead we opted for the much less ambitious approach of having a smaller number of precompiles that are simply specified in the protocol, for common operations such as hashes and signature schemes.

## List of precompiles

| Address | Name                 | Description                                | Since                                                         |
| ------- | -------------------- | ------------------------------------------ | ------------------------------------------------------------- |
| 0x01    | ECRECOVER            | Elliptic curve public key recover          | Frontier                                                      |
| 0x02    | SHA2-256             | SHA2 256-bit hash scheme                   | Frontier                                                      |
| 0x03    | RIPEMD-160           | RIPEMD 160-bit hash scheme                 | Frontier                                                      |
| 0x04    | IDENTITY             | Identity function                          | Frontier                                                      |
| 0x05    | MODEXP               | Arbitrary precision modular exponentiation | Byzantium ([EIP-198](https://eips.ethereum.org/EIPS/eip-198)) |
| 0x06    | ECADD                | Elliptic curve addition                    | Byzantium ([EIP-196](https://eips.ethereum.org/EIPS/eip-196)) |
| 0x07    | ECMUL                | Elliptic curve scalar multiplication       | Byzantium ([EIP-196](https://eips.ethereum.org/EIPS/eip-196)) |
| 0x08    | ECPAIRING            | Elliptic curve pairing check               | Byzantium ([EIP-197](https://eips.ethereum.org/EIPS/eip-197)) |
| 0x09    | BLAKE2               | BLAKE2 compression function                | Istanbul ([EIP-152](https://eips.ethereum.org/EIPS/eip-152))  |
| 0x0a    | KZG POINT EVALUATION | Verifies a KZG proof                       | Cancun ([EIP-4844](https://eips.ethereum.org/EIPS/eip-4844))  |

## How it works

The beauty of precompiles lies in design of its interface, which is identical to external smart contract calls, allowing for a familiar interaction - from a developer's perspective, usage of precompile no different than an external call.

Gas costs for precompiles are directly tied to the input data – fixed inputs translate to fixed costs. To determine these costs, developers rely on a combination of reference implementations and benchmarks. Benchmarks typically measure execution time on specific hardware, while some, like `MODEXP`, [define consumption directly in terms of gas usage per second](https://eips.ethereum.org/EIPS/eip-2565#1-modify-computational-complexity-formula-to-better-reflect-the-computational-complexity). This meticulous approach aims to prevent denial-of-service attacks by ensuring predictable resource allocation.

Under the hood, client implementations leverage optimized libraries to execute precompiles. While this approach enhances efficiency, it introduces a potential security risk. If a bug is found within these libraries, it could disrupt the entire protocol layer. To mitigate this risk, rigorous [testing](/wiki/testing/overview.md) is crucial (e.g. [MODEXP test specs](https://github.com/ethereum/execution-spec-tests/tree/main/tests/byzantium/eip198_modexp_precompile)).

To prevent security vulnerabilities, precompiles are designed to avoid nested calls.

## Calling precompiles

Like contract account, precompiles can be called using `*CALL` family of opcodes. The following assembly code example shows usage of `SHA-256` precompile to hash the string "Hello":

```js
// First place the parameters in memory
PUSH5 0x48656C6C6F // Hello in UTF-8
PUSH1 0
MSTORE

// Call SHA-256 precompile (0x02)
PUSH1 0x20 // retSize
PUSH1 0x20 // retOffset
PUSH1 5 // argsSize
PUSH1 0x1B // argsOffset
PUSH1 2 // address
PUSH4 0xFFFFFFFF // gas
STATICCALL

POP // Pop the result of the STATICCALL

// LOAD the result from memory to stack
PUSH1 0x20
MLOAD
```

which yields the hash:

```
185f8db32271fe25f561a6fc938b2e264306ec304eda518007d1764826381969
```

> ▶️ [Try it in the EVM playground!](https://www.evm.codes/playground?fork=cancun&unit=Wei&codeType=Mnemonic&code='~FirsKplaceqparameters%20inYZ5948656C6C6FjHello%20in%20UTF-8w0vMSTOREvv~Call%20SHA-256%20precompilJ%7BV02%7DNSizeNW5QSizewV1BQW2jaddressZ49FFFFFFFFjgasvbPOPjPop_ofqb~LOAD_fromYGo%20stackXvMLOAD'~%2F%2F%20wZ1%20v%5CnqGhJj%20~bSTATICCALLvv_qresulKZvPUSHY%20memoryXwV20WOffsetwV0xQjargsNXjretKt%20Je%20G%20t9%20V%019GJKNQVWXYZ_bjqvw~_)

Refer the wiki on [EVM](/wiki/EL/evm.md) to understand how assembly code works.

## Proposed precompiles

[EIPs](https://eips.ethereum.org/) can introduce new precompiles as part of hard forks. There is general resistance in adding new precompiles as the testing surface and maintenance cost is high. To address this, a proposed approach involves prototyping precompiles on Layer 2 solutions first, and then integrating them into the mainnet only after they demonstrate stability and widespread adoption.

 Following precompiles are currently proposed:

- [EIP-2537: Precompile for BLS12-381 curve operations](https://eips.ethereum.org/EIPS/eip-2537)
- [EIP-7212: Precompile for secp256r1 Curve Support](https://eips.ethereum.org/EIPS/eip-7212)
- [EIP-7545: Verkle proof verification precompile](https://eips.ethereum.org/EIPS/eip-7545)
- [EIP-5988: Add Poseidon hash function precompile](https://eips.ethereum.org/EIPS/eip-5988)

The introduction of new precompiles requires careful consideration of their network effects. A precompile with miscalculated gas cost could potentially cause denial of service by consuming more resources than anticipated. Additionally, a growing number of precompiles can lead to code bloat within the EVM clients, increasing the burden on validators.

The selection of cryptographic functions and their corresponding parameters for precompiles requires a thorough analysis to balance security and efficiency. These parameters are generally preset within the precompile logic as parametrizing these from user input could be a security concern. Moreover, optimizing security functions with a wide range of parameters is difficult for fast execution, which is the fundamental requirement of precompiles.

## Removing precompiles

Discussions are ongoing regarding potential removal of precompiles that are outdated, underutilized, or hinder client software efficiency. The identity precompile (replaced by the `MCOPY` opcode), `RIPEMD-160`, and BLAKE functions are prime candidates for retirement.

However, instead of complete removal,these precompiles could be migrated to efficient smart contract implementations. This approach would ensure continued functionality but with a corresponding increase in gas costs.

## Implementations

- [Besu - `org.hyperledger.besu.evm.precompile` package](https://github.com/hyperledger/besu/tree/3d5f45c35ffce4b5173b2ce5972827f9634317d6/evm/src/main/java/org/hyperledger/besu/evm/precompile)
- [Geth - `core/vm/contracts.go`](https://github.com/ethereum/go-ethereum/blob/b2b0e1da8cac279bf0466885d1abdc5d93402f41/core/vm/contracts.go)
- [Nethermind - `Nethermind.EVM.Precompiles` namespace](https://github.com/NethermindEth/nethermind/tree/f3edf2503d2637a37f8b509924e10f88491ddd6e/src/Nethermind/Nethermind.Evm/Precompiles)
- [Reth - REVM Precompiles crates](https://github.com/bluealloy/revm/tree/1ca3d39f6a9e9778f8eb0fcb74fe529345a531b4/crates/precompile/src)

## Research

A proposed approach called ["progressive precompiles"](https://ethereum-magicians.org/t/eip-proposal-create2-contract-factory-precompile-for-deployment-at-consistent-addresses-across-networks/6083/26) aims to improve the deployment process. These precompiles would reside at deterministic CREATE2 addresses, allowing user contracts to interact with the same address regardless of whether the precompile is live on the mainnet or a specific L2. This approach ensures a smoother transition when native client precompiles become available.

## Resources

- [Appendix E: Ethereum Yellow Paper.](https://ethereum.github.io/yellowpaper/paper.pdf)
- [Week 10: Precompiles overview by Danno Ferrin](/eps/week10-dev.md)
- [Catalog of EVM Precompile](https://github.com/shemnon/precompiles/)
- [Go Ethereum Precompile Implementation.](https://github.com/ethereum/go-ethereum/blob/master/core/vm/contracts.go)
- [A Prehistory of the Ethereum Protocol](https://vitalik.eth.limo/general/2017/09/14/prehistory.html)
- [Stack Exchange: What's a precompiled contract and how are they different from native opcodes?](https://ethereum.stackexchange.com/questions/440/whats-a-precompiled-contract-and-how-are-they-different-from-native-opcodes)
- [Stack Exchange: Why aren't more common algorithms done as precompiles?](https://ethereum.stackexchange.com/questions/155787/why-arent-more-common-algorithms-done-as-precompiles)
- [A call, a precompile and a compiler walk into a bar](https://blog.theredguild.org/a-call-a-precompile-and-a-compiler-walk-into-a-bar/)
