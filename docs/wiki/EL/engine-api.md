# Engine API

> [!WARNING]
> The Glamsterdam section of this page covers active areas of research (EIP-7732 ePBS and EIP-7928 BALs). Those sections may be outdated at time of reading and are subject to future updates as the design space evolves.

**Prerequisite reading:** [EL Architecture](/wiki/EL/el-architecture.md)

The Engine API is the authenticated communication interface between the Consensus Layer (CL) and the Execution Layer (EL), introduced at The Merge. The CL drives the EL's block building, validation, and fork choice through this interface. It tells the EL which chain is canonical, asks it to build new blocks, and sends received blocks for validation.

## Architecture

### Network Isolation

The Engine API is served on a **dedicated port (default: 8551)**, strictly separate from the public-facing JSON-RPC API (default: 8545). This isolation is a security requirement. Shared ports would allow public traffic or deliberate DoS floods to starve the consensus dialogue, causing missed proposals and attestations.

### Communication Protocols

| Protocol | Authentication | Notes |
|----------|---------------|-------|
| HTTP | JWT on every request | Standard; stateless |
| WebSocket | JWT on initial handshake only | Persistent connection; no per-frame auth |
| IPC | None | Same-machine only; filesystem permissions provide isolation |

### Ancillary eth_ Methods

The spec requires the EL to expose all nine of the following `eth_` methods on the authenticated Engine API port, enabling the CL to query chain state without a separate connection:

`eth_blockNumber`, `eth_call`, `eth_chainId`, `eth_getCode`, `eth_getBlockByHash`, `eth_getBlockByNumber`, `eth_getLogs`, `eth_sendRawTransaction`, `eth_syncing`

`eth_getLogs` is critical for CL monitoring of the deposit contract (pre-Electra). `eth_call` enables the CL to verify EIP-7002 withdrawal credentials without broadcasting transactions.

## Authentication

The CL and EL share a 256-bit (32-byte) hex-encoded JWT secret, configured via a `--jwt-secret` CLI flag pointing to a `jwt.hex` file. If omitted, the EL auto-generates a random secret for that session and writes it to `jwt.hex` in its data directory.

**Algorithm**: The EL must enforce **HS256** (HMAC-SHA256). Any JWT specifying `alg: none` must be immediately rejected to prevent authentication bypass.

**Replay protection**: Every JWT must include an `iat` (issued-at) claim. The EL must reject any request where the token's `iat` deviates by more than **±60 seconds** from the EL's local clock. This prevents captured tokens from being replayed to induce chain reorganizations.

Optional claims (`id`, `clv`) may be included for telemetry but are not validated for access control.

## Capability Negotiation

### engine_exchangeCapabilities

`engine_exchangeCapabilities` has no version suffix. It is the only Engine API method without one. It lets clients discover each other's supported method versions.

- The EL **must** support this method; the CL may call it optionally
- Each party sends an array of their supported method names with version suffixes (e.g. `["engine_newPayloadV3", "engine_newPayloadV4"]`)
- The EL responds with its own list. `engine_exchangeCapabilities` itself **must not** appear in the response.
- The EL must not log errors if this method is never called (backward compatibility)

### engine_getClientVersionV1

An optional method allowing the CL and EL to identify each other's software. Each side returns a `ClientVersionV1` structure with a two-letter client code, human-readable name, version string, and 4-byte commit hash. The compact identifiers are designed to fit in the 32-byte beacon block graffiti field for network diversity tracking.

| Code | EL Client | Code | CL Client |
|------|-----------|------|-----------|
| `BU` | Besu | `GR` | Grandine |
| `EG` | Erigon | `LH` | Lighthouse |
| `EJ` | EthereumJS | `LS` | Lodestar |
| `EX` | Ethrex | `NB` | Nimbus |
| `GE` | Geth | `PM` | Prysm |
| `NM` | Nethermind | `TK` | Teku |
| `RH` | Reth | | |
| `TE` | Trin-Execution | | |

The EL must not log errors if this method is never called.

## Core Methods

### engine_forkchoiceUpdatedV3

Updates the EL's canonical chain view and optionally initiates block building.

**Parameters:**
- `forkchoiceState`: `{headBlockHash, safeBlockHash, finalizedBlockHash}`
- `payloadAttributes` (optional): `{timestamp, prevRandao, suggestedFeeRecipient, withdrawals, parentBeaconBlockRoot}`. If provided, the EL starts building a payload and returns a `payloadId`.

**Returns:** `{payloadStatus, payloadId}`

`engine_forkchoiceUpdatedV3` returns only `VALID`, `INVALID`, or `SYNCING`. It never returns `ACCEPTED`. A fork choice update is an authoritative command to reorganize or extend the canonical chain, so the EL must fully resolve the head block's state before executing the update. `ACCEPTED` is exclusive to `engine_newPayload`.

### Payload Status Values

| Status | Returned by | Meaning |
|--------|-------------|---------|
| `VALID` | both | Block and all ancestors fully downloaded and EVM-verified |
| `INVALID` | both | Violates consensus rules; `latestValidHash` identifies the highest valid ancestor for fork recovery |
| `SYNCING` | both | Required ancestor data is missing locally; EL has begun fetching from p2p |
| `ACCEPTED` | newPayload only | Block hash valid, all transactions non-zero length, payload does **not** extend the canonical chain (it is on a side branch), ancestors are locally available. EVM execution is deliberately deferred until fork choice may pivot to this branch. |

**ACCEPTED vs SYNCING**: `SYNCING` means the EL cannot accept the block because its chain history is missing. `ACCEPTED` means the ancestry is intact. The EL chose not to run full EVM validation because this is currently a non-canonical side branch. If LMD-GHOST later pivots to this branch, the EL executes the deferred state transitions.

### engine_newPayloadV4

Delivers an execution payload from a received beacon block to the EL for validation.

**Parameters:**
- `executionPayload`: the full block
- `expectedBlobVersionedHashes`: ordered list of blob versioned hashes
- `parentBeaconBlockRoot`: parent beacon block root (EIP-4788)
- `executionRequests`: EL-generated requests for the CL (Electra+)

**Validation:**
- Executes all transactions and verifies the resulting state root
- **Blob hash validation**: extracts `blob_versioned_hashes` from every blob-carrying transaction in the payload, preserving inclusion order, concatenates them, and compares against `expectedBlobVersionedHashes`. Any mismatch or ordering difference returns `INVALID`.

**Returns:** `VALID`, `INVALID`, `SYNCING`, or `ACCEPTED`

### engine_getPayloadV4

Retrieves a payload the EL built after a `forkchoiceUpdated` call with `payloadAttributes`.

**Parameters:** `payloadId` is the 8-byte ID returned by `engine_forkchoiceUpdatedV3`.

**Returns:**
- `executionPayload`: the assembled block
- `blockValue`: total wei in priority fees accruing to `feeRecipient` (256-bit quantity)
- `blobsBundle`: `{commitments, proofs, blobs}`. Contains 48-byte KZG commitments, 48-byte KZG proofs, and 131,072-byte blob data for the CL to build blob sidecars.
- `shouldOverrideBuilder`: a boolean **suggestion** from the EL that the locally built payload should be used instead of an external MEV-Boost bid. The CL may or may not act on this. It is one input into the CL's decision, not a command. The EL sets it using implementation-defined heuristics (e.g. a high-value transaction has been persistently excluded from builder bids). If the EL implements no heuristic, it must default to `false`.
- `executionRequests`: EL-generated requests (Electra+)

## Execution Requests (EIP-7685)

Introduced in V4 (Prague/Electra), execution requests allow EVM smart contracts to trigger consensus-layer state changes. Each request is `request_type ++ request_data` where `request_type` is a 1-byte prefix.

**Supported types in Electra:**

| Type | EIP | Description |
|------|-----|-------------|
| `0x00` | EIP-6110 | **Deposit requests**: EL pushes deposit events to the CL directly, replacing CL log polling. Reduces validator activation time from ~12 hours to ~13 minutes. Max per payload: `MAX_DEPOSIT_REQUESTS_PER_PAYLOAD = 8,192`. |
| `0x01` | EIP-7002 | **Withdrawal requests**: Smart contracts holding `0x01` withdrawal credentials can trigger partial or full validator exits from the EVM. Processed via predeploy at `0x00000961Ef480Eb55e80D19ad83579A64c007002`. Target: 2/block; max: 16/block. Fee: `fake_exponential(1_wei, excess, 17)`, near 1 wei under normal load and exponentially expensive under sustained demand. System call gas: 30,000,000 (excluded from block gas accounting). |
| `0x02` | EIP-7251 | **Consolidation requests**: Merge multiple 32 ETH validators into a single compounding validator (up to 2048 ETH effective balance). Target: 1/block; max: 2/block. Pending queue hard limit: `PENDING_CONSOLIDATIONS_LIMIT = 262,144` (2^18). |

**Ordering and validation rules**: The `executionRequests` array must be:
- Sorted in **strictly ascending order** by `request_type`
- Each `request_type` byte appears **at most once** (no duplicates)
- No element with empty `request_data` (elements of length <= 1 byte must be excluded)

Any violation returns `-32602: Invalid params`. The EL also computes a `requests_hash` (SHA-256 over the sorted list) and validates it against the block header; a mismatch returns `INVALID`. For a block with no requests, the hash defaults to `sha256("") = 0xe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`.

## Version History

| Version | EL Fork | CL Fork | Key Changes |
|---------|---------|---------|-------------|
| V1 | Paris | Bellatrix | Initial post-Merge: `forkchoiceUpdated`, `newPayload`, `getPayload` |
| V2 | Shanghai | Capella | Added `withdrawals` to payload attributes and execution payload |
| V3 | Cancun | Deneb | Added `blobVersionedHashes`, `parentBeaconBlockRoot`; `executionPayload` gains `blobGasUsed`, `excessBlobGas`; `getPayload` returns `BlobsBundleV1` |
| V4 | Prague | Electra | Added `executionRequests` (EIP-7685) |

## Slot Lifecycle

The Engine API operates within a strict 12-second slot heartbeat. For a proposer node:

| Time | Action |
|------|--------|
| **t = 0s** | Slot begins. CL calls `engine_forkchoiceUpdatedV3` with `payloadAttributes`. EL returns `payloadId`. |
| **t = 1-3s** | EL builds the payload: selects mempool transactions, executes them, computes state root. CL optionally queries external MEV relays. |
| **t = 3s** | CL calls `engine_getPayloadV4`, wraps payload into a `BeaconBlock`, signs it, broadcasts. |
| **t = 4s** | **Attestation deadline.** Other validators must have received the block, called `engine_newPayloadV4`, and received `VALID` by this point. Late blocks are not attested to and earn no inclusion revenue. |
| **t = 4-12s** | CL calls `engine_forkchoiceUpdatedV3` (without `payloadAttributes`) to set the new block as head. |

Non-proposer nodes skip the first three steps and only perform `engine_newPayloadV4` followed by `engine_forkchoiceUpdatedV3`.

### Optimistic Sync

During heavy load, the CL may import a beacon block optimistically without waiting for full EVM execution. If the EL later returns `INVALID`, the CL reorgs back to `latestValidHash`. The maximum optimistic import depth is bounded by `SAFE_SLOTS_TO_IMPORT_OPTIMISTICALLY` (default: **128 slots**, ~25.6 minutes), configurable via `--safe-slots-to-import-optimistically`. This prevents "fork choice poisoning" attacks where a malicious peer feeds structurally valid but computationally invalid blocks at the chain tip.

## Error Handling

### JSON-RPC Error Codes

| Code | Name | Trigger |
|------|------|---------|
| `-32700` to `-32603` | Standard JSON-RPC | Parse errors, invalid requests, method not found, invalid params, internal errors |
| `-32000` | Server error | Generic EL failure; response **must** include a `data.err` string with diagnostic context (e.g. `"LevelDB read failure"`) |
| `-38001` | Unknown payload | `engine_getPayload` called with a `payloadId` that has no active build process or has timed out |
| `-38002` | Invalid forkchoice state | `forkchoiceState` hashes are logically inconsistent (e.g. `safeBlockHash` is not an ancestor of `headBlockHash`) |
| `-38003` | Invalid payload attributes | `payloadAttributes` fields are structurally invalid or missing fork-required fields |
| `-38004` | Too large request | An array parameter exceeds hardcoded memory constraints |
| `-38005` | Unsupported fork | Payload timestamp does not align with the EL's active fork (e.g. a Deneb-format payload submitted before Deneb activation) |

### Failure Modes

**`SYNCING`**: CL retries `engine_forkchoiceUpdatedV3` until the EL catches up. Do not attest to or build on that block.

**`INVALID`**: CL marks that block and all descendants as invalid, reverts fork choice to `latestValidHash`.

**EL unreachable** (port down, JWT mismatch, crash): CL cannot propose or validate. Validators miss all duties until the connection is restored.

## Future Upgrades

### Fusaka (Fulu/Osaka, December 3, 2025, epoch 411392)

The Fusaka upgrade spans 13 EIPs covering DA scaling, execution performance, and protocol cleanup. Key Engine API impacts:

**Data availability:**
- **EIP-7594 (PeerDAS)**: Nodes sample small column subsets instead of downloading full blobs, enabling safe blob throughput increases. `engine_getPayloadBodiesByHashV2` and `engine_getPayloadBodiesByRangeV2` are updated to support PeerDAS cell proof structures.
- **EIP-7918**: Blob base fee floor tied proportionally to the execution base fee, preventing blob fees from collapsing to 1 wei during low demand.
- **EIP-7892 (BPO forks)**: Blob Parameter Only forks allow blob counts to be scaled post-Fusaka via lightweight network adjustments without triggering full hard forks. BPO1 and BPO2 activated shortly after Fusaka, raising blob targets to 10/15 and 14/21 respectively.

**Execution performance:**
- **EIP-7935**: Default block gas limit raised to **60M** (coordinated among clients, not a consensus rule).
- **EIP-7825**: Transaction gas limit capped at **2^24 = 16,777,216 gas**. No single transaction can occupy an entire block.
- **EIP-7934**: RLP execution block size capped at **8 MiB** (`MAX_RLP_BLOCK_SIZE = 10 MiB - 2 MiB safety margin`). The CL gossip protocol already drops blocks over 10 MiB; the 2 MiB margin reserves headroom for the beacon block, making the effective EL payload limit 8 MiB.
- **EIP-7883**: MODEXP precompile repriced. Minimum gas raised from 200 to **500**, general cost formula **tripled**, and large-exponent multiplier raised from 8 to **16**.
- **EIP-7823**: MODEXP inputs bounded at **8192 bits (1024 bytes)** per input (base, exponent, modulus). All historical real-world usage was under this limit.
- **EIP-7917**: Deterministic proposer lookahead. The proposer schedule is known one full epoch in advance, improving MEV and PBS coordination.

### Glamsterdam (post-Fusaka)

**EIP-7732 (ePBS)** is the proposed Glamsterdam CL headliner. It moves PBS from the out-of-protocol MEV-Boost sidecar into the consensus layer, eliminating reliance on trusted relays. The Engine API slot lifecycle changes materially: the proposer receives only a signed **builder commitment** at t=3s and broadcasts it without the execution payload; the builder then reveals the full `ExecutionPayloadEnvelope` to the network after the t=4s attestation deadline. This prevents the proposer from stealing the builder's MEV while retaining the ability to attest. New Engine API methods handle commitment validation separately from full EVM execution.

**EIP-7928 (Block-Level Access Lists)** is the proposed Glamsterdam EL headliner. Every block would include an explicit map of all addresses and storage slots accessed during execution, enabling:
- Parallel pre-fetching of state before EVM execution
- Parallel execution of non-conflicting transactions across CPU cores
- Execution-less state verification for stateless and ZK clients

The Engine API would validate this by having the EL execute the payload, compute the access list internally, and verify it against the `blockAccessList` in the payload header. A mismatch returns `INVALID`. Both EIPs are draft proposals.

## Resources

- [Engine API specification (execution-apis)](https://github.com/ethereum/execution-apis/tree/main/src/engine)
- [EIP-3675: Upgrade to Proof-of-Stake](https://eips.ethereum.org/EIPS/eip-3675)
- [EIP-7685: General purpose EL requests](https://eips.ethereum.org/EIPS/eip-7685)
- [EIP-7002: Execution layer triggerable withdrawals](https://eips.ethereum.org/EIPS/eip-7002)
- [EIP-7607: Hardfork Meta - Fusaka](https://eips.ethereum.org/EIPS/eip-7607)
- [EIP-7732: Enshrined Proposer-Builder Separation](https://eips.ethereum.org/EIPS/eip-7732)
- [EIP-7928: Block-Level Access Lists](https://eips.ethereum.org/EIPS/eip-7928)
- [Engine API visual guide](https://hackmd.io/@danielrachi/engine_api)
