#  EVM Object Format (EOF)

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

The EVM Object Format (EOF) is an extensible and versioned container format for EVM bytecode with a once-off validation at deploy time.

Currently, [EVM Bytecode](/wiki/EL/evm.md#evm-bytecode) is an unstructured sequence of instructions. EOF introduces the concept of a container, which brings structure to byte code. The container consists of a header and then several sections.


## Purpose and Benefits
EOF was designed to address several limitations of the original EVM bytecode format:

- Better Validation: Enables more thorough static analysis and validation of smart contracts before execution
- Improved Execution Efficiency: Facilitates optimization of EVM execution through better-defined code sections
- Enhanced Security: Reduces attack vectors by enforcing stricter code structure rules
- Future-Proofing: Provides a foundation for future EVM improvements and features through versioned containers

## Related EIPs and Implementations
Several EIPs complementing EOF’s implementation in the coming Ethereum Pectra upgrade are included in the [EIP-7692](https://eips.ethereum.org/EIPS/eip-7692) such as:

- EIP-3540: Introduces EOF Version 1, establishing the initial structure for structured bytecode.
- EIP-3670, EIP-4200, EIP-4750, EIP-5450, EIP-6206, EIP-7480, EIP-663, EIP-7069, EIP-7620, EIP-7698: Enhance EOF functionalities, improving security, efficiency, and usability across Ethereum’s ecosystem.


## Differences from Legacy EVM Bytecode
| Feature|	 Legacy EVM |	 EOF|
|:-------|:--------------|:-------|
|Container Structure|	Unstructured bytecode|	Clearly defined sections|
|Code Validation|	Limited, runtime|	Comprehensive, pre-execution|
|Jump Mechanics|	Dynamic: JUMP/JUMPI|	Includes static jumps|
|Typing|	None|	Function signatures and typing|
|Data Handling|	Mixed with code|	Separate data section|


## Resources
- [EOF Parser and Visualizer](https://eof.wtf/)
- [EVM | Pawel Bylica | Lecture 17](https://www.youtube.com/watch?v=gYnx_YQS8cM)
- [Mega EOF Endgame](https://github.com/ipsilon/eof/blob/main/spec/eof.md)
