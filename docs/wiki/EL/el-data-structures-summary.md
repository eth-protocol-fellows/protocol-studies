# Ethereum Execution Layer Data Structures

<img src="images/el-data-structures-summary/overview.png" alt="overview" />

# Overview
At the highest level, the execution layer is composed of a linear series of blocks. Blocks are ordered by increasing number. Each block also contains the unique hash of its parent. By following this hash to the one from the parent block, we form a chain of blocks whose ordering cannot be tampered with, ie a blockchain.

The blocks making up the blockchain are themselves made of two parts: the header and the body. The header contains metadata such as the `parent_hash` and the block's `number` while the body contains the main data such as the list of transactions.

# Block Header
The block's header contains metadata related to the content of the block. Certain fields have shifted in usage between the pre-Merge era - when the consensus mechanism was Proof of Work (POW) - and the current post-Merge era with Proof of Stake (POS), which occurred with the Paris fork.

## Fields

| name | description|
|------- | ------- |
| parent_hash | The hash of the block's parent. The uniqueness of the hash is what makes the ordering of the blocks tamper-proof |
| ommers_hash | This is a POW-era field used to include information about ommers (also called uncles), which are blocks not included in the chain for being produced at the same time as the current block, but that we still wanted to reward for their work. In the current POS chain, this field is not used. |
| beneficiary | POW era: Address of the miner which would receive block rewards. POS era: Address of the validator who receives a `priority_fee` |
| state_root | Root hash of the world state trie after all txs are executed. See [state_root](#state_root) |
| transactions_root | Root hash of the transaction trie for this block. See [transactions_root](#transactions_root) |
| receipts_root | Root hash of the receipt trie for this block. See [receipts_root](#receipts_root) |
| logs_bloom | Bloom filter summarizing all logs from receipts in this block. See [logs_bloom](#logs_bloom) |
| difficulty | In the POW era, this fields indicated the mining difficulty of the block. In the POS era, this field is not used and set to 0 |
| number | This is the block number (height of the chain). |
| gas_limit | Maximum amount of gas allowed in this block. This value can change with each block as per [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559) since the London fork |
| gas_used | Total gas used by all the transactions in this block. Note that this doesn't include gas for storing blobs tallied in the field `blob_gas_used` |
| extra_data | Arbitrary 32-byte field for additional data (e.g. miner ID) |
| prev_randao | In POW, this field was called `mix_hash` and was used in nonce verification. In POS (Paris fork), renamed to `prev_randao` and provides a random seed for validators as per [EIP-4399](https://eips.ethereum.org/EIPS/eip-4399) |
| nonce | In POW: solution for the mining puzzle. In POS, not used and set to all zeroes. |
| base_fee_per_gas | Minimum base fee per gas. Introduced in the London fork with [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559) |
| withdrawals_root | Root of the withdrawal list tree. Introduced in the Shanghai fork to enable validator withdrawals. See [EIP-4895](https://eips.ethereum.org/EIPS/eip-4895) and [withdrawals_root](#withdrawals_root) |
| base_fee_per_blob_gas | Minimum blob gas fee. Introduced in the Dencun fork. See [EIP-4844](https://eips.ethereum.org/EIPS/eip-4844) |
| blob_gas_used | Total blob gas used in the block. Introduced in the Dencun fork. See [EIP-4844](https://eips.ethereum.org/EIPS/eip-4844) |
| excess_blob_gas | Running total of blob gas consumed above the target. Introduced in the Dencun fork. See [EIP-4844](https://eips.ethereum.org/EIPS/eip-4844) |
| parent_beacon_block_root | SSZ root of the parent beacon block. Introduced in the Dencun fork. See [EIP-4788](https://eips.ethereum.org/EIPS/eip-4788) |
| request_root | Root hash of EL-generated cross-layer requests. Introduced in the Pectra fork. See [EIP-7685](https://eips.ethereum.org/EIPS/eip-7685) | 

### state_root
The state of Ethereum is stored in a Merkle-Patricia trie. The trie contains every account and the data associated with it, such as the `balance`, the `storage_root`, `code_hash`, etc... The tree is a massive data structure and therefore we store only the root of the tree in the `state_root` field of the block header.

Each account is stored as the hash of its public address and the data is serialized with RLP.

Each account contains the following fields:

| name | description|
|------- | ------- |
| nonce | For Externally Owned Accounts (EOAs), the field contains the number of transactions sent and is incremented which each new transaction. It is meant to prevent replay attacks. For contracts, the nonce represents the amount of created contracts in the case the code acts as a factory. By incrementing the nonce, we prevent address collisions when generating new contracts |
| balance | Eth balance of the account in wei |
| storage_root | Root of the account's storage trie. Normally only used for contracts. Since the introduction of [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702), can now be utilized for EOAs. See [Storage Trie](https://epf.wiki/#/wiki/EL/data-structures?id=storage-trie) |
| code_hash | If an EOA, is either an empty hash or hash of delegation indicator described in [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702). If a contract, contains the keccak256 hash of the account's code. |

The data is arranged in a Merkle Patricia Tree and each account is located in a leaf identified with the keccak256 hash of the address. The content is further encoded using RLP as such: `RLP(nonce, balance, storage_root, code_hash)`.

See [World State Trie](https://epf.wiki/#/wiki/EL/data-structures?id=world-state-trie) for more information of the Merkle Patricia Tree data structure.

Due to the RLP encoding in addition to the use of keccak256 for hashing, the "tree of trees" design and the lack of inclusion of account code as part of the state, the current design is not friendly to validity proofs. [EIP-7864](https://eips.ethereum.org/EIPS/eip-7864) proposes to use a unified binary tree instead in order to address these problems.

### transactions_root
The `transactions_root` is the root of the Merkle Patricia Trie storing all the transactions to be included in the block.

Currently, each transaction is encoded with RLP and then hashed with keccak256. Since the totality of the data is required to produce this hash, inclusion proofs require the totality of the transaction data be sent, including potentially large calldata or access lists. Due to this reason, [EIP-6404](https://eips.ethereum.org/EIPS/eip-6404) aims to migrate from RLP to SSZ, the algorithm currently in use in the consensus layer.
 
For more information on the transaction trie and Merkle Patricia Tries see article on [Transaction Trie](/wiki/EL/data-structures?id=transaction-trie)

### receipts_root
Receipts are generated after each transaction and contain information related to the transaction such as the status, type and logs. For a given block, the logs are given an index and placed in a Merkle Patricia Trie, the root of which is stored as the `receipts_root`. Each receipt also, contains another data structure, a bloom filter, which probabilistically enables fast querying of inclusion of a log.

Each receipt contains the following fields:

| name | description|
|------- | ------- |
| type | Receipt type byte prefix. Included since the Berlin fork. See [EIP-2718](https://eips.ethereum.org/EIPS/eip-2718) |
| status | Indicates the transaction status. 1 = success, 0 = failure. Field introduced in the Byzantium fork, described in [EIP-658](https://eips.ethereum.org/EIPS/eip-658). Pre-Byzantium the field was called `state_root` and contained the world state root. |
| cumulative_gas_used | Total gas used up to and including this tx in the block |
| logs_bloom | 256-byte bloom filter summarizing all logs from this tx. The bloom filter enables determining if a logs is part of the block probabilistically. IE. We can know for sure that the log is not there, but if we get a positive hit, we only know that the log *might* be there. See article on [bloom filters](https://en.wikipedia.org/wiki/Bloom_filter) |
| logs[] | List of event logs emitted during execution |

Each item  in the `logs[]` field contains the following items:
| name | description|
|------- | ------- |
| address | Address of the contract that emitted the log |
| topics[] | Array of indexed topics (includes event signatures) |
| data | ABI-encoded non-indexed event data | 

Each node is identified by the RLP encoding of the receipt index. Each node is hashed with keccak256. This linear hashing makes it impossible to efficiently prove individual parts of the receipts, such as the logs, meaning the proofs require the full receipt data. [EIP-6466](https://eips.ethereum.org/EIPS/eip-6466) proposes to migrate from RLP encoding towards SSZ serialization to address the issue.

For more information about the Merkle Patricia Trie structure of the receipt trie see [Receipt Trie](https://epf.wiki/#/wiki/EL/data-structures?id=receipt-trie)


### withdrawals_root
This field provides a way for withdrawals made on the beacon chain (the consensus layer) to be pushed into the execution layer. It represents a commitment to the list of validators on the consensus layer making a withdrawal and the correspond amount of gwei received at a particular address.

The fields of withdrawal are:
| name | description|
|------- | ------- |
| index | a monotonically increasing index, starting from 0 and incrementing by 1 per withdrawal and uniquely identifying each withdrawal |
| validator_index | The index of the validator making the withdrawal |
| address | Address to receive the withdrawal |
| amount | Amount of gwei |

The data is arranged in a Merkle Patricia Trie similarly to how the `transactions_root` organizes it's transactions with the RLP encoded index as the identifier. This, however, causes a problem since the consensus layer stores its own `withdrawals_root` with SSZ encoding, unlike the execution layer which uses Merkle Patricia Tries. For the purpose of harmonizing these two values and reducing complexity and ambiguity, [EIP-6465](https://eips.ethereum.org/EIPS/eip-6465) proposes migrating from a MPT structure to SSZ serialization so that both the execution layer and the consensus layer use the same algorithm.

# Block Body
The body consists of the main data being executed by the network, including transactions.

## Fields
| transactions[] | The list of transactions executed in the block, in order. There can be different types of transactions. See [transaction types](#transaction-types) |
| ommers[] | List of ommers (uncles) whose hash is placed in the header. However, since POS this field is not used and kept as an empty list. | 
| withdrawals[] | List of ETH withdrawals for validators. Introduced in the Shanghai fork. See [EIP-4895](https://eips.ethereum.org/EIPS/eip-4895) |
| requests[] | List of cross-layer requests generated by execution. Introduced in the Pectra fork. See [EIP-7685](https://eips.ethereum.org/EIPS/eip-7685) |

### Transaction types
The Frontier hardfork introduced typed transactions as described in [EIP-2718](https://eips.ethereum.org/EIPS/eip-2718). Transaction types can be distinguish by looking at the first byte of the RLP-encoded transaction.

Since the first byte of an RLP-encoded Ethereum transaction always returns the sum of the identifier of an array (`0xc0`) + the length of the array, we can identify legacy transactions if the first byte is in the range `[0xc0-0xfe]`.

The range `[0x00, 0x7f]`, which does not collide with any potential RLP-encoded information, is reserved to identify transaction types (`0x00` is not used as Legacy transactions are considered type 0) and is concatenated at the start of the RLP-encoded transaction payload.

#### Legacy Transaction (type 0x00)
Legacy transactions were the only transaction format before [EIP-2718](https://eips.ethereum.org/EIPS/eip-2718) introduced the concept of transaction type. Such transactions are still compatible in Ethereum. Even with updates such as [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559), legacy transactions are translated into EIP-1559-compatibility by setting the `max_fee_per_gas` and the `max_priority_fee_per_gas` to the legacy transaction `gas_price`.

*Fields*

| name | description|
|------- | ------- |
| nonce | Number of txs sent by the sender prior to this. The increasing nonce value prevents replay attacks. |
| gas_price | Legacy pricing model: gas price per unit. Since [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559), the `max_fee_per_gas` and `max_priority_fee_per_gas` fields are set to this value. |
| gas_limit | Max gas this tx is allowed to consume, which represents roughly the amount of computational resources used (CPU, memory, storage). Due to the well-known halting problem in computer science, knowing when a computation ends is impossible without running the computation. Therefore, to prevent long-running programs (potentially infinite) that might stall client execution, Ethereum puts a cap on the amount of resources allowed. |
| to | Recipient address, or empty for contract creation | 
| value | Amount of Eth to transfer in wei |
| data | Calldata for contract interaction or init code for creation |
| chain_id | Field added in [EIP-155](https://eips.ethereum.org/EIPS/eip-155) in the Spurious Dragon fork to prevent cross-chain replay attacks. Replay attacks occur when an attacker takes a transaction from one chain and applies it to another chain, potentially stealing funds. The additional `chain_id` field means a transaction only works on the chain for which the transaction was signed for |
| v, r, s | Signature components (used to recover sender address) |

### Access List Transaction (type 0x01)
Access list transactions are similar to legacy transactions but they also include an optional `access_list` field listing all the addresses and storage slots required to run the transaction.

*Motivation*
In 2016, attackers targeted the network in an event called the Shanghai DoS attacks by - as the most successful strategy - sending malicious transactions accessing a large amount of addresses and storage slots. The attack forced the clients to search for the information on disk, resulting in IO-heavy transactions that took a long time to process. The attack was low cost for the attacker but high cost for the clients.

As a result, [EIP-2929](https://eips.ethereum.org/EIPS/eip-2929) was proposed to increase the gas cost of opcodes accessing storage "cold" (for the first time, before the data has been copied to RAM). This would have the effect of making further DoS attack economically prohibitive.

EIP-2929 introduced potential contract breakage due to increased gas cost for storage access. Therefore, [EIP-2930](https://eips.ethereum.org/EIPS/eip-2930) introduced an access list (the `access_list` field) specifying all the accounts and storage slots to be accessed in the transaction. As a result, clients could now pre-load the data, resulting in lower gas costs for transactions including an access list.

Access list transactions were introduced in the Berlin fork as the first new type of transaction.

*Fields*

The RLP-encoded transaction is produced as follows: `RLP(chain_id, nonce, gas_price, gas_limit, to, value, data, access_list, v, r, s)`

The field described below have been added on top of those already present in legacy transactions.

| name | description|
|------- | ------- |
| access_list | list of addresses/storage keys to be accessed. Described in [EIP-2930](https://eips.ethereum.org/EIPS/eip-2930) introduced in the Berlin fork |

### Dynamic-Fee Transaction (type 0x02) 
Type 2 transactions brought in a new fee market change described in [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559) and introduced in the London fork. The network would attempt to maintain a target gas usage per block of 50% of maximum capacity by adjusting the gas base fee. If the current gas usage is higher than the target, gas prices are raised, which lowers demand. If on the other hand, blocks aren't using enough gas, the gas base fee is lowered to compensate, which stimulates demand. The base fee is then burn, reducing the total supply of Eth.

A crucial aspect of this increase or decrease of base fee is that this change can only occur by maximum increments of 1/1024th of the parent's gas limit. This ensures that the gas price can react quickly to changes in demand while also preventing wild fluctuations.

Furthermore, the transaction can include an additional priority fee to incentivize a particular transaction for inclusion in the block over others. This priority fee is not burned but is paid to the validator.

*Motivation*
Why change the gas fee market in the first place?
Pre-EIP-1559, gas price fluctuated wildly with network demand. A common occurrence was sending a transaction with a particular gas price and having the transaction getting stuck in the mempool due an unexpected spike in gas price. This resulted in a poor user experience, fixed by the newly-added gradual increases of the base fee.

Why is the base fee burned?
In addition to providing an economic benefit to holders of Eth by providing a mechanism for reducing the supply and counterbalancing inflation, the base fee burn mitigates the risks of fee manipulation, preventing validators from flooding the block with "free" transactions and keeping gas prices artificially elevated.

*Fields*

The structure of the data for this transaction type is: `RLP(chain_id, nonce, max_priority_fee_per_gas, max_fee_per_gas, gas_limit, to, value, data, access_list, v, r, s)` which extends Type 1 transactions by replacing `gas_price` with the fields described in the table below.

| name | description|
|------- | ------- |
| max_priority_fee | Tip for the validator to incentivize inclusion above other transactions. Described in [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559), included in London |
| max_fee_per_gas | Maximum fee willing to pay per unit of gas. Described in [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559), included in London |

### Blob-Carrying Transaction (type 0x03) 
<img src="images/el-data-structures-summary/blob.png" alt="bloc" />

[EIP-4844](https://eips.ethereum.org/EIPS/eip-4844) introduced short-lived blob data storage which the network keeps available for a temporary period (currently at 4096 epochs, or about 18 days).

The blobs are not stored on the blockchain, neither on the header or the body. Rather the blob data is sent together with the block - like a sidecar - with the transaction data and made available by the nodes. The header will simply contain a KZG commitment for each blob of data.

Similarly to EIP-1559 transactions (though the math is different) blob transactions have their own gas price market which adjusts as a function of demand to attain a target usage of 50% of total capacity.

*Motivation*
In Ethereum, the long term vision for scalability includes both the layer 1 (the execution layer and consensus layer) and layer 2 chains worked together, with the layer 1 providing security guarantees for layer 2. As such, layer 2s are first class citizen in Ethereum. 

We care about blob data availability because maintaining temporarily available data is necessary for servicing layer 2s. For example, optimistic rollups like Optimism optimistically push a commitment of a transaction batch on chain. It's possible that a transaction was maliciously omitted (e.g. Bob has 10 eth, but the committed transactions says he has 0 eth). If that is the case, the user whose funds are compromised can publish a fraud proof to prove bad behavior and correct the situation. Creating this fraud proof requires access to transaction data, hence Ethereum makes this data available for a short period as blobs, giving users a reasonable time to react. Thus, data availability is necessary to ensure compliant state transition of layer 2s. 

*Fields*
The transaction data is encoded this: `RLP(chain_id, nonce, max_priority_fee_per_gas, max_fee_per_gas, gas_limit, to, value, data, access_list, max_fee_per_blob_gas, blob_versioned_hashes, v, r, s)`

The fields are the same as type 2 transactions, except the fields described below are added.

| name | description|
|------- | ------- |
| max_fee_per_blob_gas | Maximum fee willing to pay per blob gas unit. Described in [EIP-4844](https://eips.ethereum.org/EIPS/eip-4844), included in Dencun |
| blob_versioned_hashes | List of hashes for each blob. Described in [EIP-4844](https://eips.ethereum.org/EIPS/eip-4844), included in Dencun |

### Set Code Transaction for EOAs (type 0x04)
Type 4 transactions aims to attach smart contract code to an Externally-Owned Account. Let's recall that EOAs have an empty `code_hash` field, thus they normally have no programs themselves. [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702) changes that by setting the values to the value of `(0xef0100 || delegated_contract_address)` where `||` represents concatenation. Once the code is set, an EOA can delegate its code execution to that of the saved address. It's important to point out that an EOA doesn't hold code itself, but just a pointer towards code. This pointer can be removed or changed with another type 4 transaction. Because we can distinguish between an EOA and a contract, [EIP-3607](https://eips.ethereum.org/EIPS/eip-3607), preventing an attacker from producing an address colliding with an existing contract and stealing funds, can still be respected.

The value `0xef0100` which precedes the delegated contract address was chosen to provide a unique identifier for which no collision can occur.
In effect, `0xef` is a reserved byte according to [EIP-3541](https://eips.ethereum.org/EIPS/eip-3541). The `0100` added afterwards is an identifier to indicate an EIP-7702 delegated address. Thus, it is still possible to distinguish between smart contract and EOAs by looking at the code hash, since EOAs will either have nothing or a value starting with `0xef0100`.

*Motivation*
Pure EOA accounts without EIP-7702 suffered from several UX problems. For instance, sending ERC-20 tokens through a smart contract would be done through an `approve/transferFrom` pattern requiring two separate transactions. Account abstraction (smart contract wallets) described in [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337) aimed to fix this issue, in addition to providing additional functionality such as batching of transaction, gas sponsorship, etc...

With EIP-7702, the Ethereum ecosystem as a whole can now benefit from account abstraction by enabling EOAs to opt-in.

*Fields*
Type 4 transactions extend type 3 transactions with a new `authorization_list` field which is a list of tuples containing the fields described below.

| name | description|
|------- | ------- |
| chain_id | The chain id prevents cross-chain replay attacks.|
| nonce | nonce preventing replay attacks |
| address | Address of the smart contract we want to delegate execution to |
| y_parity, r, s | Cryptographic signature elements of the EOA whose account we want to set a code to. Note that if the `tx.origin` (the signer of the entire transaction) is the same signer of the field, the set code operation is permanent (unless later changed). If they differ, then the operation is only for the current transaction. This enables the ability to batch transactions. |

# Resources and References

- [EIP-7702: a technical deep dive by lightclient](https://www.youtube.com/watch?v=_k5fKlKBWV4)
- [EL Data structures | Gary and Karim](https://www.youtube.com/watch?v=EY_pVZTXS1w)
- [Merkle Patricia Tree Documentation](https://ethereum.org/developers/docs/data-structures-and-encoding/patricia-merkle-trie)
- [Recursive Length Prefix (RLP) Encoding/Decoding](https://medium.com/coinmonks/data-structure-in-ethereum-episode-1-recursive-length-prefix-rlp-encoding-decoding-d1016832f919)