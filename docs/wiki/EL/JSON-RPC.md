# JSON-RPC

---

The JSON-RPC specification is a remote procedure call protocol encoded in JSON based on [OpenRPC](https://open-rpc.org/getting-started). It allows calling functions on a remote server, and for the return of the results.
It is part of the Execution API specification which provides a set of methods to interact with the Ethereum blockchain.
It is better known to be the way of how the clients interact with the network, even how the consensus layer (CL) and the execution layer (EL) interact.
This section provides a description of the JSON-RPC methods.

## JSON-RPC Methods

There are a lot of JSON-RPC methods, but for summarizing purposes here are divided into the following prefix categories: *debug*, *engine* and *eth*, and all of them share a common structure:

```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "method": "<prefix_methodName>",
  "params": [...]
}
```

Where:
- `id`: A unique identifier for the request.
- `jsonrpc`: The version of the JSON-RPC protocol.
- `method`: The method to be called.
- `params`: The parameters for the method. It can be an empty array if the method does not require any parameters. Other ones may have default values if not provided.

Here is a few list of the JSON-RPC methods:

### Debug

| **Method**               |      **Params**       | **Description**                                                 |
|--------------------------|:---------------------:|-----------------------------------------------------------------|
| debug_getBadBlocks       |  no mandatory params  | returns and array of recent bad blocks that the client has seen |
| debug_getRawBlock        |     block_number      | returns an RLP-encoded block                                    |
| debug_getRawHeader       |     block_number      | returns an RLP-encoded header                                   |
| debug_getRawReceipts     |     block_number      | returns an array of EIP-2718 binary-encoded receipts            |
| debug_getRawTransactions |        tx_hash        | returns an array of EIP-2718 binary-encoded transactions        |

### Engine
This one is particularly important due to the fact that it is the way of how the EL interacts with the CL after The Merge happened.

| **Method**                               |               **Params**               | **Description**                                                           |
|------------------------------------------|:--------------------------------------:|---------------------------------------------------------------------------|
| engine_exchangeTransitionConfigurationV1 |        Consensus client config         | exchanges client configuration                                            |
| engine_forkchoiceUpdatedV1*              |  forkchoice_state, payload attributes  | updates the forkchoice state                                              |
| engine_getPayloadBodiesByHashV1*         |           block_hash (array)           | given block hashes returns bodies of the corresponding execution payloads |
| engine_getPayloadV1*                     |  forkchoice_state, payload attributes  | obtains execution payload from payload build process                      |
| debug_newPayloadV1*                      |                tx_hash                 | returns execution payload validation                                      |

Those methods marked with an asterisk (*) have more than one version. The [Ethereum JSON-RPC specification](https://ethereum.github.io/execution-apis/api-documentation/) provides a detailed description.

### Eth

This one is a particularly one of the most used. Just a brief list of the methods is provided here, but the full list can be found in the [Ethereum JSON-RPC specification](https://ethereum.github.io/execution-apis/api-documentation/).

| **Method**               |      **Params**       | **Description**                                                 |
|--------------------------|:---------------------:|-----------------------------------------------------------------|
| eth_blockNumber          |  no mandatory params  | returns the number of the most recent block                     |
| eth_call                 |  transaction object   | executes a new message call immediately without creating a transaction on the block chain |
| eth_chainId              |  no mandatory params  | returns the current chain id                                     |
| eth_estimateGas          |  transaction object   | makes a call or transaction, which won't be added to the blockchain and returns the used gas, which can be used for estimating the used gas |
| eth_gasPrice             |  no mandatory params  | returns the current price per gas in wei                         |
| eth_getBalance           |  address, block number | returns the balance of the account of the given address          |
| eth_getBlockByHash       |  block hash, full txs  | returns information about a block by hash                        |
| eth_getBlockByNumber     |  block number, full txs | returns information about a block by block number                |
| eth_getBlockTransactionCountByHash | block hash | returns the number of transactions in a block from a block matching the given block hash |
| eth_getBlockTransactionCountByNumber | block number | returns the number of transactions in a block from a block matching the given block number |
| eth_getCode              |  address, block number | returns code at a given address in the blockchain                 |
| eth_getLogs              |  filter object         | returns an array of all logs matching a given filter object       |
| eth_getStorageAt         |  address, position, block number | returns the value from a storage position at a given address |

## Tooling

There are several ways of how to use the JSON-RPC methods. One of them is using the `curl` command. For example, to get the latest block number, you can use the following command:

```bash
curl <node-endpoint> \
-X POST \
-H "Content-Type: application/json" \
-d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```
Please note how the *params* field is empty, as the method pass "latest" as default value.

Another way is to use the `axios` library in Javascript/TypeScript. For example, to get the address balance, you can use the following code:

```typescript
import axios from 'axios';

const node = '<node-endpoint>';
const address = '<address>';

const response = await axios.post(node, {
  jsonrpc: '2.0',
  method: 'eth_getBalance',
  params: [address, 'latest'],
  id: 1,
  headers: {
    'Content-Type': 'application/json',
  },
});
```
As you may notice, the JSON-RPC methods are wrapped in a POST request, and the parameters are passed in the body of the request.
This is a different way to exchange data between the client and the server using the OSI's application layer: the HTTP protocol.

Usually, all the web3 libraries wrap the JSON-RPC methods providing a more friendly way to interact with the execution layer. Please, look forward in your preferred programming language as the syntax may vary.

### Further Reading
* [Ethereum JSON-RPC Specification](https://ethereum.github.io/execution-apis/api-documentation/)
* [Execution API Specification](https://github.com/ethereum/execution-apis/tree/main)
* [JSON-RPC | Infura docs](https://docs.infura.io/api/networks/ethereum/json-rpc-methods)
* [OpenRPC](https://open-rpc.org/getting-started)
