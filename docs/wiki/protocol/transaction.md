# How do transactions start, and how are they processed in Ethereum?
How exactly are transactions initiated, and how are they processed in Ethereum? I will explain this phenomenon with the help of Go Ethereum (Geth) code examples.

## Transaction Creation
The wallet software takes the user's input and constructs a **transaction object**. A user creates and signs a transaction with their private key. This is usually handled by a wallet or a library such as ether.js, web3js, web3py etc but under the hood the user is making a request to a node using the **Ethereum JSON-RPC API**. This object contains all the necessary fields: nonce, gasPrice, gasLimit, to, address, value and data. User sends this basic items to Ethereum.

## Ethereum Transaction Data
You can find out the ethereum transaction data structure the following link. [go-ethereum/core/types
/transaction.go] (https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/core/types/transaction.go#L75C1-L75C24)

## The Signing and Verification of Ethereum's Transactions
The code found in the [transaction_signing.go](https://github.com/ethereum/go-ethereum/blob/master/core/types/transaction_signing.go) file within the Ethereum Go client (Geth) repository is primarily focused on handling the signing and verification of Ethereum transactions. You can check the several transactions controls and signature verifications in the following link.[Transactions Control and Signature Verifications] (https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/core/types/transaction_signing.go#L129)

## The Test of Ethereum's Transactions
These test transactions are used within the test functions in transaction_test.go to verify that the Go Ethereum implementation correctly processes transactions, including their creation, signing, serialization, and execution according to the Ethereum protocol.[go-ethereum/core/types
/transaction_test.go] (https://github.com/ethereum/go-ethereum/blob/master/core/types/transaction_test.go) The following link shows the variable which is tested in this code page.(https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/core/types/transaction_test.go#L34C1-L72C2)
You can try to execute this test on your computer.
- Visit the official Go downloads page at https://golang.org/dl/ to find the macOS installer. You'll typically find an installer package (.pkg) file for macOS. Download this file to your computer.
- Clone the Go Ethereum repository to your local machine using Git
```git clone https://github.com/ethereum/go-ethereum.git    ```
- Navigate to the core/types directory within the cloned Geth repository.``` cd go-ethereum/core/types```
- To run all tests in the transaction_test.go file, you can use the go test command with the file name as an argument.```go test -v```

## Transaction Submission
After being formed and signed, a transaction is submitted to the Ethereum network.

## Transaction Pool
Submitted transactions are first received by the transaction pool (txpool)[go-ethereum/core/txpool
/txpool.go](https://github.com/ethereum/go-ethereum/blob/master/core/txpool/txpool.go), where they await to be picked up by miners or validators. The txpool.go file in the Go Ethereum (Geth) repository is a crucial component of the Ethereum client that manages the pool of transactions that have been broadcast to the network but not yet included in a block. This file contains the implementation of the transaction pool, detailing how transactions are added, stored, prioritized, and eventually promoted to be included in future blocks by miners or validators.

# Changing State

The [core/state_processor.go] (https://github.com/ethereum/go-ethereum/blob/master/core/state_processor.go) file in the Go Ethereum (Geth) repository is responsible for processing individual transactions and applying them to the current state of the Ethereum blockchain. This involves executing transactions according to the rules of the Ethereum protocol, updating the state accordingly, and handling any changes that result from those transactions.
