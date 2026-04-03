# EVM Object Format (EOF)

The EVM Object Format (EOF) is an extensible and versioned container format for EVM bytecode with a once-off validation at deploy time.

Currently, [EVM Bytecode](/wiki/EL/evm.md#evm-bytecode) is an unstructured sequence of instructions. EOF introduces the concept of a container, which brings structure to bytecode, making it easier to parse by the EVM and analyze. Its primary goal is to enable major upgrades to the EVM by allowing once-off code validation at deploy time and by strictly separating code from data.

For example, EOF1 bytecode begins with a 2-byte magic `0xEF00` and version, followed by a list of section headers and a `0x00` terminator. This structure allows EVM implementations to verify an entire contract's correctness at deploy time, including stack depth and structural validity, before any execution begins.
```
// Example layout of an EOF container (bytecode):
Magic (0xEF00) | Version | (section_kind, section_size_or_sizes)+ | 0x00
[types section] [code section 0] [code section 1] … [data section]
```

---

## Purpose and Benefits

EOF was designed to address several limitations of the original EVM bytecode format:

- **Better Validation:** Enables thorough static analysis and validation of smart contracts before execution. It rejects truncated PUSH data or undefined opcodes, making every EOF contract provably valid on-chain.

- **Improved Execution Efficiency:** Facilitates optimization of EVM execution through better-defined code sections and the removal of runtime JUMPDEST scans.

- **Enhanced Security:** Reduces attack vectors by enforcing stricter code structure rules and eliminating legacy quirks (like SELFDESTRUCT or DELEGATECALL issues) through validation.

- **Code/Data Separation:** By keeping data (e.g., compiler metadata) in a separate section, tools like verifiers and L2s can easily distinguish executable code from arbitrary data, improving both security and gas efficiency.

---

## Related EIPs and Implementations

EOF is specified in several EIPs covering different features, changes to various opcodes, and introducing new ones. All these EIPs are tracked by a single meta EIP: [EIP-7692](https://eips.ethereum.org/EIPS/eip-7692).

### Core Container & Validation

- [**EIP-3540**](https://eips.ethereum.org/EIPS/eip-3540): The base EOF V1 spec. Defines the container, header, and the "tangible benefit" of code/data separation.

- [**EIP-3670**](https://eips.ethereum.org/EIPS/eip-3670): Mandates code validation at creation time, ensuring no invalid opcodes are deployed.

- [**EIP-5450**](https://eips.ethereum.org/EIPS/eip-5450): Introduces Stack Validation to prevent runtime stack errors.

### Control Flow and Subroutines

- [**EIP-4200**](https://eips.ethereum.org/EIPS/eip-4200): Static Relative Jumps. Adds `RJUMP`, `RJUMPI`, and `RJUMPV` using signed immediate offsets, removing the need for dynamic `JUMP` and `JUMPDEST`.

- [**EIP-4750**](https://eips.ethereum.org/EIPS/eip-4750): EOF Functions. Supports multiple code sections and introduces `CALLF`/`RETF` for intra-contract function calls. It also adds a type section listing inputs/outputs for each function.

- [**EIP-6206**](https://eips.ethereum.org/EIPS/eip-6206): Adds `JUMPF` (opcode `0xE5`) for tail-call jumps and allows marking functions as non-returning (output `0x80`) for optimizations.

### Modernized Instructions

- [**EIP-7480**](https://eips.ethereum.org/EIPS/eip-7480): Data Section Access. Defines `DATALOAD`, `DATALOADN`, `DATASIZE`, and `DATACOPY` to safely access data. Legacy `CODECOPY` is deprecated in EOF.

- [**EIP-663**](https://eips.ethereum.org/EIPS/eip-663): Unlimited Stack Access. Adds `SWAPN`, `DUPN`, and `EXCHANGE`, allowing compilers to access up to 256+ items on the 1024-item stack.

- [**EIP-7069**](https://eips.ethereum.org/EIPS/eip-7069): Revamped CALLs. Replaces legacy `CALL`/`DELEGATECALL` with `EXTCALL`, `EXTDELEGATECALL`, and `EXTSTATICCALL` (removing the gas argument and using the 63/64 rule).

- [**EIP-5920**](https://eips.ethereum.org/EIPS/eip-5920): Introduces the `PAY` opcode (`0xFC`), allowing ETH transfers without invoking the recipient's code, mitigating reentrancy risks.

- [**EIP-7761**](https://eips.ethereum.org/EIPS/eip-7761) & [**EIP-7880**](https://eips.ethereum.org/EIPS/eip-7880): Adds `EXTCODETYPE` to check account types (EOA vs. EOF) and `EXTCODEADDRESS` to resolve EIP-7702 delegations.

### Contract Creation & Metadata

- [**EIP-7620**](https://eips.ethereum.org/EIPS/eip-7620): Replaces `CREATE`/`CREATE2` with `EOFCREATE` and `RETURNCODE`.

- [**EIP-7873**](https://eips.ethereum.org/EIPS/eip-7873): Replaces the former EIP-7698. Defines the `TXCREATE` opcode and InitcodeTransaction for direct EOF deployment from EOAs.

- [**EIP-7834**](https://eips.ethereum.org/EIPS/eip-7834): Adds a separate Metadata Section (kind `0x05`) that is unreachable by code, perfect for CBOR metadata or IPFS hashes without shifting code offsets.

---

## Differences from Legacy EVM Bytecode

| Feature | Legacy EVM | EOF |
|---|---|---|
| Container Structure | Unstructured bytecode | Clearly defined sections (Types, Code, Data) |
| Code Validation | Limited, runtime | Comprehensive, pre-execution (Deploy-time) |
| Jump Mechanics | Dynamic: `JUMP` / `JUMPI` | Static Relative Jumps: `RJUMP` / `RJUMPI` |
| Stack Validation | Runtime checks only | Static validation (No underflow/overflow) |
| Typing | None | Function signatures and typing |
| Data Handling | Mixed with code | Separate data section (`DATALOAD`) |
| Introspection | `CODECOPY`, `EXTCODESIZE` | Deprecated; replaced by safer alternatives |

---

## Current Status

EOF was formally removed from the Fusaka hard fork on April 28, 2025, during the [Interop Testing #34 call](https://ethereum-magicians.org/t/interop-testing-34-april-28-2025/23822/2). The decision was confirmed by Tim Beiko in a [GitHub PR updating EIP-7607](https://github.com/ethereum/EIPs/pull/9703).

The main reasons cited for removal were:

- **Complexity:** Critics, including developer Pascal Caversaccio in a [March 2025 Ethereum Magicians post](https://ethereum-magicians.org/t/evm-object-format-eof/5727), argued EOF introduces too many simultaneous changes , new semantics, over a dozen opcode additions and removals and that its benefits could be achieved through smaller, more targeted updates instead.
- **Maintenance burden:** Shipping EOF would require maintaining both legacy EVM and EOF contracts indefinitely, increasing long-term complexity for client teams.
- **Process failures:** Beiko acknowledged in the removal PR that the ACD process failed to adequately resolve community objections across multiple upgrade cycles, despite core devs repeatedly agreeing to ship it.
- **Timeline risk:** With PeerDAS being the primary Fusaka priority, the ongoing spec debate around EOF variants was seen as a risk to the overall upgrade schedule.

EOF's champions were left open to present a case for inclusion in the subsequent **Glamsterdam** hard fork, but no inclusion has been scheduled as of now. The specification and its constituent EIPs remain available as a historical reference.

---

## Resources

- [**EVM | Pawel Bylica | Lecture 17**](https://www.youtube.com/watch?v=gYnx_YQS8cM) — Detailed technical deep dive into EOF internals and design decisions.

- [**Ethereum Magicians: EVM Object Format (EOF)**](https://ethereum-magicians.org/t/evm-object-format-eof/5727) — The original EIP discussion thread where EOF was proposed and debated by core developers.

- [**Ethereum Notes: EOF**](https://notes.ethereum.org/t-1tLFnLSKCtLZpb-Rw0IA) — Community notes and working documents on the EOF specification and open design questions.
