#  EVM Object Format (EOF)
> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

The EVM Object Format (EOF) is an extensible and versioned container format for EVM bytecode with a once-off validation at deploy time.

Currently, [EVM Bytecode](/wiki/EL/evm.md#evm-bytecode) is an unstructured sequence of instructions. EOF introduces the concept of a container, which brings structure to byte code. The container consists of a header and then several sections.