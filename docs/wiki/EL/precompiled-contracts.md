# Precompiled contracts

Precompiled contracts are a set of special accounts, each containing a built-in function with a determined gas cost, often related to cryptography. Currently, they are defined at addresses ranging from `0x01` to `0x0a`. [EIPs](https://eips.ethereum.org/) can introduce new precompiles as part of hard forks.

Unlike contract accounts, precompiles are part of the Ethereum protocol and implemented by execution clients. This presents an intersting caveat - their `EXTCODESIZE` within EVM is 0. Nonetheless, they function like contract accounts with code when executed.

Precompiles are included in the initial `"accessed_addresses"` of a transaction as defined by [EIP-2929](https://eips.ethereum.org/EIPS/eip-2929) to save gas costs.

## List of precompiles
| Address | Name                 | Description                                | Since                                                         |
|---------|----------------------|--------------------------------------------|---------------------------------------------------------------|
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
> ▶️  [Try it in the EVM playground!](https://www.evm.codes/playground?fork=cancun&unit=Wei&codeType=Mnemonic&code='~FirsKplaceqparameters%20inYZ5948656C6C6FjHello%20in%20UTF-8w0vMSTOREvv~Call%20SHA-256%20precompilJ%7BV02%7DNSizeNW5QSizewV1BQW2jaddressZ49FFFFFFFFjgasvbPOPjPop_ofqb~LOAD_fromYGo%20stackXvMLOAD'~%2F%2F%20wZ1%20v%5CnqGhJj%20~bSTATICCALLvv_qresulKZvPUSHY%20memoryXwV20WOffsetwV0xQjargsNXjretKt%20Je%20G%20t9%20V%019GJKNQVWXYZ_bjqvw~_)

Refer the wiki on [EVM](/wiki/EL/evm.md) to understand how assembly code works.

## Resources
- [Appendix E: Ethereum Yellow Paper.](https://ethereum.github.io/yellowpaper/paper.pdf)
- [Go Ethereum Precompile Implementation.](https://github.com/ethereum/go-ethereum/blob/master/core/vm/contracts.go)
