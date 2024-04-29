# Testing

Ethereum client implementations undergo constant testing on different levels which ensures security and stability of the network. For a decentralized network, ensuring all clients communicate correctly, behave the same way and therefore agree on transaction outcomes as defined by the protocol is indispensable. A difference in a single state transition would cause a network split resulting in finalization failure and many problems for users. To achieve stability, Ethereum clients must undergo rigorous testing against a standardized suite of test cases. 

These tests verify adherence to [execution](/wiki/EL/el-specs.md) and [consensus](/wiki/CL/cl-specs.md) specifications, guaranteeing all clients interpret and execute transactions identically. This rigorous testing also functions as a proactive bug-detection tool that safeguards against network forks (disagreements on the canonical blockchain state).

## Resources

### Walkthrough
- [Testing & Security Overview](https://www.youtube.com/watch?v=PQVW5dJ8J0c)

### Common test suite
- [pytest: Python test framework](https://docs.pytest.org/en/8.0.x/)
- [Ethereum Tests: Common tests for all implementations](https://github.com/ethereum/tests)
- [Hive: Ethereum end-to-end test harness](https://github.com/ethereum/hive)

### Execution layer tests
- [Execution Spec Tests: Test cases for execution clients](https://github.com/ethereum/execution-spec-tests)
- [FuzzyVM: Differential fuzzer for EVM](https://github.com/MariusVanDerWijden/FuzzyVM).
- [retesteth: Test generation tool](https://github.com/ethereum/retesteth)
- [EVM lab utilities](https://github.com/ethereum/evmlab)
- [Go evmlab: Evm laboratory inspired by EVMLAB](https://github.com/holiman/goevmlab)
- [Collection of execution APIs](https://github.com/ethereum/execution-apis)

### Consensus layer test
- [Consensus Spec Tests](https://github.com/ethereum/consensus-specs/tree/dev/tests)

### Tools for testing chains
- [Assertoor: Ethereum Testnet Testing Tool](https://github.com/ethpandaops/assertoor)
- [Ethereum package: Testnet deployer](https://github.com/kurtosis-tech/ethereum-package) (Recommended for beginners)

### Dashboards
- [Hive test results](https://hivetests.ethdevops.io/)