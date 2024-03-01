# Changes to Ethereum core to accomplish scalability

## Introduction

L2 Rollups need to enable the permissionless reconstruction of the L2 state. To achieve this, they must ensure Data Availability, which refers to the global ordering of inputs for transactions that have altered the state.
Until EIP-4844 goes live on the Mainnet (expected in March 2024), Rollups have been storing Data Availability within a section of the transaction known as "calldata". Currently, this "calldata" represents the primary bottleneck for scaling Ethereum, as storing data in calldata is expensive.

To accomplish scalability, the idea was initially to decrease transaction calldata gas cost with EIP-4488. However, this EIP is now irrelevant because EIP-4844 has been implemented instead, which as we will see in the following section, introduces a new data section inside the transactions called Blob.

But before talking about the changes introduced by the EIP-4844, let's first understand the structure of an Ethereum transaction.

## EIP-2718

[EIP-2718](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-2718.md) introduced an envelope transaction type. The envelope makes possible to incapsulate transaction in a common header structure, allowing to change the transaction fields without breaking backwards compatibility.

The envelope transaction type is defined as follows:

`TransactionType || TransactionPayload`

Where `TransactionType` is a 1 byte field identyfing the format of the transaction, and `TransactionPayload` is a variable length field which contains the actual transaction content.

Same concept apply to receipts:

`TransactionType || ReceiptPayload`

Please note that the `||` is the byte/byte-array concatenation operator.

This way, when defining new standards for a new type of transaction, the only concern is to ensure there are not duplicated `TransactionType` numbers.

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
