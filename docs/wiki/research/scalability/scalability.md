# Changes to Ethereum core to accomplish scalability

## Introduction

L2 Rollups need to enable the permissionless reconstruction of the L2 state. To achieve this, they must ensure Data Availability, which refers to the global ordering of inputs for transactions that have altered the state.
Until EIP-4844 goes live on the Mainnet (expected in March 2023), Rollups have been storing Data Availability within a section of the transaction known as "calldata". Currently, this "calldata" represents the primary bottleneck for scaling Ethereum, as storing data in calldata is expensive.

To accomplish scalability, the idea was initially to decrease transaction calldata gas cost with EIP-4488. However, this EIP is now irrelevant because EIP-4844 has been implemented instead, which as we will see in the following section, introduces a new data section inside the transactions called Blob.

But before talking about the changes introduced by the EIP-4844, let's first understand the structure of an Ethereum transaction.

## Current transaction data structure

The following is the current transaction data structure of Ethereum as for the London upgrade (which included the latest update to the transaction format in EIP-1559).
The following python code can be found in the [ethereum-specs repository](https://github.com/ethereum/execution-specs).

```python
@slotted_freezable
@dataclass
class LegacyTransaction:
  nonce: U256
  gas_price: Uint
  gas: Uint
  to: Union[Bytes0, Address]
  value: U256
  data: Bytes
  v: U256
  r: U256
  s: U256

@slotted_freezable
@dataclass
class AccessListTransaction:
  chain_id: U64
  nonce: U256
  gas_price: Uint
  gas: Uint
  to: Union[Bytes0, Address]
  value: U256
  data: Bytes
  access_list: Tuple[Tuple[Address, Tuple[Bytes32, ...]], ...]
  y_parity: U256
  r: U256
  s: U256

@slotted_freezable
@dataclass
class FeeMarketTransaction:
  chain_id: U64
  nonce: U256
  max_priority_fee_per_gas: Uint
  max_fee_per_gas: Uint
  gas: Uint
  to: Union[Bytes0, Address]
  value: U256
  data: Bytes
  access_list: Tuple[Tuple[Address, Tuple[Bytes32, ...]], ...]
  y_parity: U256
  r: U256
  s: U256

Transaction = Union[
  LegacyTransaction, AccessListTransaction, FeeMarketTransaction
]
```

The "calldata" is encoded inside the `data` field of the Transaction class. The "calldata" is accessible by the EVM, and the format to encode and decode it is specified in the [Contract ABI](https://docs.soliditylang.org/en/latest/abi-spec.html).

## EIP-4844

[EIP-4844](https://eips.ethereum.org/EIPS/eip-4844) introduces Blobs, a new space to store data that will be much cheaper that calldata.
With the EIP-4844, the new Transaction data structure will be the following.

```python
@slotted_freezable
@dataclass
class BlobTransaction: # the class name may change
  chain_id: U64
  nonce: U256
  max_priority_fee_per_gas: Uint
  max_fee_per_gas: Uint
  gas: Uint
  to: Union[Bytes0, Address]
  value: U256
  data: Bytes
  access_list: Tuple[Tuple[Address, Tuple[Bytes32, ...]], ...]
  max_fee_per_blob_gas: U256
  blob_versioned_hashes: VersionedHash
  y_parity: U256
  r: U256
  s: U256
```

EIP-4844 will introduce two more fields in the Transaction class, which are `max_fee_per_blob_gas` and `blob_versioned_hashes`.

## EIP-4488

Initally [EIP-4488](https://eips.ethereum.org/EIPS/eip-4488) was proposed to decrease the gas cost of calldata, and to add a limit of how much total transaction calldata can be in a block. The goal was to make Rollups transactions cheaper.
Currently, the cost for a non zero byte of calldata costs 16 units of gas. With this EIP, the cost for a byte of calldata (regardless if is 0 or a non zero byte) would be 3 bytes.

This would have introduced the following parameters:

| Parameter                   | Value     |
| --------------------------- | --------- |
| NEW_CALLDATA_GAS_COST       | 3         |
| BASE_MAX_CALLDATA_PER_BLOCK | 1,048,576 |
| CALLDATA_PER_TX_STIPEND     | 300       |

However, this EIP is now irrelevant because EIP-4844 has been implemented instead. Contrary to the original idea, the approach will be the exact opposite with EIP-7623.

## EIP-7623

[EIP-7623](https://eips.ethereum.org/EIPS/eip-7623) is a very recent EIP created in February 2024, with the purpose of increasing calldata cost to decrease the maximum block size.
