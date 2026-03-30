# JSON-RPC

The JSON-RPC specification is a remote procedure call protocol encoded in JSON based on [OpenRPC](https://www.open-rpc.org/docs/getting-started). It allows calling functions on a remote server, and for the return of the results.
It is part of the Execution API specification which provides a set of methods to interact with the Ethereum blockchain.
It is better known to be the way of how the users interact with the network using a client, even how the consensus layer (CL) and the execution layer (EL) interact through the Engine API.
This section provides a description of the JSON-RPC methods.

## API Specification

The JSON-RPC methods are grouped by namespaces specified as a method prefix. Even though they all have different purposes, all of them share a common structure and must behave the same across all implementations:

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

### Namespaces

Every method is composed of a namespace prefix and the method name, separated by an underscore.

Ethereum clients must implement the basic minimum set of RPC methods required by spec to interact with the network. On top of that, there are also client specific methods for controlling the node or implementing extra unique features. Always refer to client documentation listing available methods and namespace, for example notice different namespaces in [Geth](https://geth.ethereum.org/docs/interacting-with-geth/rpc) and [Reth](https://reth.rs/jsonrpc/intro/) docs. 

Here are examples of most common namespaces: 

| **Namespace** | **Description**                                                                                      | **Sensitive** |
| ------------- | ---------------------------------------------------------------------------------------------------- | ------------- |
| eth           | The eth API allows you to interact with Ethereum.                                                    | Maybe         |
| web3          | The web3 API provides utility functions for the web3 client.                                         | No            |
| net           | The net API provides access to network information of the node.                                      | No            |
| txpool        | The txpool API allows you to inspect the transaction pool.                                           | No            |
| debug         | The debug API provides several methods to inspect the Ethereum state, including Geth-style traces.   | No            |
| trace         | The trace API provides several methods to inspect the Ethereum state, including Parity-style traces. | No            |
| admin         | The admin API allows you to configure your node.                                                     | Yes           |
| rpc           | The rpc API provides information about the RPC server and its modules                                | No            |

Sensitive means they could be used to set up the node, such as *admin*, or access account data stored in the node, just like *eth*.

Now, let's take a look at some methods to understand how they are built and what they do:

#### Eth

Eth is probably the most used namespace providing basic access to Ethereum network, e.g. it's necessary for wallets to read balance and create transactions. 
Just a brief list of the methods is provided here, but the full list can be found in the [Ethereum JSON-RPC specification](https://ethereum.github.io/execution-apis/api-documentation/).

| **Method**                           |           **Params**            | **Description**                                                                                                                             |
| ------------------------------------ |:-------------------------------:| ------------------------------------------------------------------------------------------------------------------------------------------- |
| eth_blockNumber                      |       no mandatory params       | returns the number of the most recent block                                                                                                 |
| eth_call                             |       transaction object        | executes a new message call immediately without creating a transaction on the block chain                                                   |
| eth_chainId                          |       no mandatory params       | returns the current chain id                                                                                                                |
| eth_estimateGas                      |       transaction object        | makes a call or transaction, which won't be added to the blockchain and returns the used gas, which can be used for estimating the used gas |
| eth_gasPrice                         |       no mandatory params       | returns the current price per gas in wei                                                                                                    |
| eth_getBalance                       |      address, block number      | returns the balance of the account of the given address                                                                                     |
| eth_getBlockByHash                   |      block hash, full txs       | returns information about a block by hash                                                                                                   |
| eth_getBlockByNumber                 |     block number, full txs      | returns information about a block by block number                                                                                           |
| eth_getBlockTransactionCountByHash   |           block hash            | returns the number of transactions in a block from a block matching the given block hash                                                    |
| eth_getBlockTransactionCountByNumber |          block number           | returns the number of transactions in a block from a block matching the given block number                                                  |
| eth_getCode                          |      address, block number      | returns code at a given address in the blockchain                                                                                           |
| eth_getLogs                          |          filter object          | returns an array of all logs matching a given filter object                                                                                 |
| eth_getStorageAt                     | address, position, block number | returns the value from a storage position at a given address                                                                                |

#### Debug

The *debug* namespace provides methods to inspect the Ethereum state. It's direct access to raw data which might be necessary for certain use cases like block explorers or research purposes. Some of these methods might require a lot of computation to be done on the node and requests for historical states on non-archival node are mostly not feasible. Therefore, providers of public RPCs often restrict this namespace or allow only safe methods. 
Here are basic examples of debug methods: 

| **Method**               |      **Params**       | **Description**                                                 |
|--------------------------|:---------------------:|-----------------------------------------------------------------|
| debug_getBadBlocks       |  no mandatory params  | returns and array of recent bad blocks that the client has seen |
| debug_getRawBlock        |     block_number      | returns an RLP-encoded block                                    |
| debug_getRawHeader       |     block_number      | returns an RLP-encoded header                                   |
| debug_getRawReceipts     |     block_number      | returns an array of EIP-2718 binary-encoded receipts            |
| debug_getRawTransactions |        tx_hash        | returns an array of EIP-2718 binary-encoded transactions        |

#### Engine

[Engine API](https://hackmd.io/@danielrachi/engine_api) is different from the aforementioned general Ethereum JSON‑RPC methods. Execution clients serve the Engine API on a separate, authenticated endpoint rather than on the normal HTTP JSON‑RPC port because it is not a user-facing API. Its sole purpose is to facilitate inter-client communication exchanging information about consensus, fork choice, and block validation between the consensus and execution clients.

Inter-client communication operates over a JSON‑RPC interface over HTTP and is secured using a JSON Web Token (JWT). The JWT authenticates the sender as a valid consensus layer client, although it does not provide traffic encryption. Furthermore, the Engine JSON‑RPC endpoint is only accessible by the consensus layer, ensuring that malicious external parties cannot interact with it.

The following table lists core Engine API methods and provides a brief description of their purpose and the parameters they accept:
| **Method**                               |               **Params**               | **Description**                                                           |
|------------------------------------------|:--------------------------------------:|---------------------------------------------------------------------------|
| engine_exchangeTransitionConfigurationV1 |        Consensus client config         | Exchanges configuration details between CL and EL                                            |
| engine_forkchoiceUpdatedV1*              |  forkchoice_state, payload attributes  | Updates the forkchoice state and optionally initiates payload building                                            |
| engine_getPayloadBodiesByHashV1*         |           block_hash (array)           | Given block hashes, returns the corresponding execution payload bodies |
| engine_getPayloadV1*                     |  forkchoice_state, payload attributes  | Obtains an execution payload that has been built by the EL                      |
| debug_newPayloadV1*                      |                tx_hash                 | Returns execution payload validation details for debugging purposes                                      |

Those methods marked with an asterisk (*) have more than one version to support network upgrades and evolving protocol features. The [Ethereum JSON-RPC specification](https://ethereum.github.io/execution-apis/api-documentation/) provides detailed documentation on these methods.

## Encoding

There is a convention for encoding the parameters of the JSON-RPC methods, which is the hex encoding.
* Quantities are represented as hexadecimal values using a "0x" prefix.
  * For example, the number 65 is represented as "0x41".
  * The number 0 is represented as "0x0".
  * Some invalid usages are "0x" and "ff". Since the first case does not have a following digit and the second one is not prefixed with "0x". 
* Unformatted data, such as hashes, account addresses or byte arrays, are hex encoded using a "0x" prefix as well.
  * For example: 0x400 (1014 in decimal)
  * An invalid case is 0x0400 because leading zeroes are not allowed

## Transport agnostic

Worth to mention here the JSON-RPC is transport agnostic, meaning it can be used over any transport protocol, such as HTTP, WebSockets (WSS), or even Inter-Process Communication (IPC).
Their differences can be summarized as it follows:
* **HTTP** transport provides an unidirectional response-request model, which gets the connection closed after the response is sent.
* **WSS** is a bidirectional protocol, which means the connection is kept open until either the node or the user explicitly closes it. It allows subscriptions-based model communication such as event-driven interactions.
* **IPC** transport protocol is used for communication between processes running on the same machine. It is faster than HTTP and WSS, but it is not suitable for remote communication, e.g. it can be used via local JS console.
  
## Tooling

There are several ways of how to use the JSON-RPC methods. One of them is using the `curl` command. For example, to get the latest block number, you can use the following command:

```bash
curl <node-endpoint> \
-X POST \
-H "Content-Type: application/json" \
-d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```
Please note how the *params* field is empty, as the method passes "latest" as its default value.

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

Either way, the most common use to interact with the Ethereum network is using web3 libraries, such as web3py for python or web3.js/ethers.js for JS/TS:

#### web3py

```python
from web3 import Web3

# Set up HTTPProvider
w3 = Web3(Web3.HTTPProvider('http://localhost:8545'))

# API
w3.eth.get_balance('0xaddress')
```

#### ethers.js

```typescript
import { ethers } from "ethers";

const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

await provider.getBlockNumber();
```

Usually, all the web3 libraries wrap the JSON-RPC methods providing a more friendly way to interact with the execution layer. Please, look forward in your preferred programming language as the syntax may vary.

### Further Reading
* [Ethereum JSON-RPC Specification](https://ethereum.github.io/execution-apis/api-documentation/)
* [Execution API Specification](https://github.com/ethereum/execution-apis/tree/main)
* [JSON-RPC | Infura docs](https://docs.metamask.io/services/reference/ethereum/json-rpc-methods/)
* [reth book | JSON-RPC](https://reth.rs/jsonrpc/intro/)
* [OpenRPC](https://www.open-rpc.org/docs/getting-started)
* [Engine API | Mikhail | Lecture 21](https://youtu.be/fR7LBXAMH7g)
