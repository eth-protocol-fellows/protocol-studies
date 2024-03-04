# Transaction anatomy
This page explains the how exactly are transactions initiated, and how are they processed in Ethereum. Transaction building and processing are explained with the help of Go Ethereum (Geth) code examples.

## Transaction Creation
The wallet software takes the user's input and constructs a **transaction object**. A user creates and signs a transaction with their private key. This is usually handled by a wallet or a library such as ether.js, web3js, web3py etc but under the hood the user is making a request to a node using the **Ethereum JSON-RPC API**. The Ethereum JSON-RPC API provides a standardized way for the wallet or library to communicate with an Ethereum node.  Ethereum. Before constructing a transaction, the wallet software might use JSON-RPC API calls to check the account's balance,the current nonce for the account, and to obtain the current recommended gas price. With this information, the wallet constructs a transaction object that includes fields like nonce, gasPrice, gasLimit, to (recipient address), value (amount of Ether to send), and data. The user signs the constructed transaction with their private key. Finally, the signed transaction is broadcast to the Ethereum network using the JSON-RPC API call.Here's a basic representation of an unsigned Ethereum transaction in JSON format:

```
{
  "nonce": "0x1",
  "gasPrice": "0x09184e72a000",
  "gasLimit": "0x2710",
  "to": "0x0000000000000000000000000000000000000000",
  "value": "0x0",
  "data": "0x"
}

```
After signing, the transaction is serialized into a raw format, typically a hexadecimal string. Here's an example of what a signed transaction might look like (illustration ):
``` 0xf86c018509184e72a00082710c94000000000000000000000000000000000000000000808401a0f38abf4b5c854...```

This hexadecimal string represents the entire transaction, including the signature. It can be directly submitted to the Ethereum network using the  JSON-RPC API call.



## Ethereum Transaction Data
You can find out the ethereum transaction data structure the following link. [go-ethereum/core/types
/transaction.go] (https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/core/types/transaction.go#L75C1-L75C24)
This interface represents the structure and behavior expected of transaction data within the Ethereum context. This interface defines the necessary components and operations that any Ethereum transaction data type must support to be compatible with the Ethereum blockchain's requirements.

##  Verification of Ethereum's Transactions
The code found in the [transaction_signing.go](https://github.com/ethereum/go-ethereum/blob/master/core/types/transaction_signing.go) file within the Ethereum Go client (Geth) repository is primarily focused on handling the verification of Ethereum transactions. **The Sender function** (https://github.com/ethereum/go-ethereum/blob/35cebc16877c4cfbf48b883ab3bfa02b9100a87a/core/types/transaction_signing.go#L129) is critical for identifying the transaction sender.It uses the signature (V, R, S) to recover the sender's public key and then derives the Ethereum address from this public key. **The recoverPlain function** (https://github.com/ethereum/go-ethereum/blob/35cebc16877c4cfbf48b883ab3bfa02b9100a87a/core/types/transaction_signing.go#L546)  performs the actual recovery of the public key from the signature. It takes the signature components (R, S, V) and the hash of the signed data (transaction), then uses the crypto.Ecrecover function to recover the public key.


## Transaction Pool
Submitted transactions are first received by the transaction pool (txpool)[go-ethereum/core/txpool
/txpool.go](https://github.com/ethereum/go-ethereum/blob/master/core/txpool/txpool.go), where they await to be picked up by miners or validators. The txpool.go file in the Go Ethereum (Geth) repository is a crucial component of the Ethereum client that manages the pool of transactions that have been broadcast to the network but not yet included in a block. This file contains the implementation of the transaction pool, detailing how transactions are added, stored, prioritized, and eventually promoted to be included in future blocks by miners or validators.

# Changing State

The [core/state_processor.go] (https://github.com/ethereum/go-ethereum/blob/master/core/state_processor.go) file in the Go Ethereum (Geth) repository is responsible for processing individual transactions and applying them to the current state of the Ethereum blockchain. This involves executing transactions according to the rules of the Ethereum protocol, updating the state accordingly, and handling any changes that result from those transactions.
