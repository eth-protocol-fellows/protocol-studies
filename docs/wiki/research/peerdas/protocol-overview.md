# Protocol Overview of PeerDAS

PeerDAS changes Ethereum blob propagation from full-blob distribution to column-based data availability sampling. This allows nodes to verify that blob data is available without requiring every node to download every full blob.

## Before Fulu

After EIP-4844, each slot can include a beacon block and blob sidecars.

<img src="https://hackmd.io/_uploads/SkdJBCmffl.png" alt="Beacon block and blob sidecars" width="640" />

`BlobSidecar`s carry blob data used by L2s to publish data to Ethereum. Blob data is referenced by the beacon block but is not processed by the execution layer state transition. This L2-published data can include:

- blocks and transactions
- state transition proofs
- other rollup data needed for reconstruction or verification

The beacon block contains:

- `execution_payload`: the execution block payload visible through normal execution-layer tooling
- `blob_kzg_commitments`: commitments used to verify that each blob belongs to the block
- other consensus-layer fields such as attestations and slashings

Before Fulu, nodes verify each full blob against the corresponding KZG commitment and store full blobs for the blob availability window. This is simple, but it limits scaling because increasing blob capacity directly increases the amount of data every node must download and store.

## After Fulu

Fulu replaces full blob sidecar propagation with column-based propagation.

<img src="https://hackmd.io/_uploads/HJ_Ac0XfGx.png" alt="Data column sidecars" width="640" />

A `DataColumnSidecar` contains a column of cells from multiple blobs, together with KZG commitments, KZG proofs, the signed block header, and an inclusion proof.

Instead of broadcasting full blob data for every blob:

- before Fulu, a `BlobSidecar` contains one full blob
- from Fulu, a `DataColumnSidecar` contains one column of data across blobs

Each node stores and serves specific columns based on its custody groups. If enough columns are available, the full blob data can be reconstructed.

## Encoding

Blob data is encoded to create redundancy.

<img src="https://hackmd.io/_uploads/S16iiRQzGg.png" alt="Encoding blob data" width="640" />

Because blob data does not go through the execution layer state transition, a proposer or Byzantine peer could try to modify or withhold some data. Modified data is detected by verifying KZG commitments and proofs. Withheld data is addressed by redundancy: if enough encoded data is available, the original blob data can still be recovered.

## Columns and Subnets

The encoded blob data is divided into 128 columns. These columns are broadcast through gossipsub topics:

```text
data_column_sidecar_{subnet_id}
```

where:

```text
subnet_id = column_index % DATA_COLUMN_SIDECAR_SUBNET_COUNT
DATA_COLUMN_SIDECAR_SUBNET_COUNT = 128
```

<img src="https://hackmd.io/_uploads/BJMI6A7GGe.png" alt="Column subnets" width="640" />

When a node receives a `DataColumnSidecar`, it verifies that the column is correct.

<img src="https://hackmd.io/_uploads/ryHAxJNMfe.png" alt="Data column verification" width="640" />

This is why each sidecar carries the KZG commitments and proofs needed to verify the cells in that column.

## Sampling

Each node samples specific columns to check data availability. If many nodes can successfully sample and verify their assigned columns, the network gains high confidence that the blob data is available.

If some columns are missing from gossip, nodes can request them from peers through request/response protocols.

<img src="https://hackmd.io/_uploads/HyLMfJ4ffg.png" alt="Sampling columns" width="640" />

The sampling goal is to make sure no row is withheld by more than the reconstruction threshold. Before a node accepts a beacon block as data-available, its sampling process must succeed.

## Slot Timing

PeerDAS data availability checks happen alongside normal beacon block processing in a 12 second slot.

<img src="https://hackmd.io/_uploads/ByVc7yNfGg.png" alt="Slot timing" width="640" />

During the first part of the slot, a node processes the beacon block and data column sidecars in parallel:

```text
0s - 4s:
  receive beacon block
    - verify block
    - start state transition validation
    - execute state transition

  receive or sample data column sidecars
    - verify columns through KZG commitments and proofs
    - request missing columns from peers if needed
    - execute sampling

  final check
    - import the block into fork choice if block validation and sampling succeed
    - produce attestation using the updated fork-choice head

4s - 8s:
  - attestations propagate
  - aggregators collect attestations

8s - 12s:
  - aggregators broadcast aggregate attestations
  - aggregate attestations propagate
  - next proposer prepares
```

The practical constraint is that block propagation, column propagation, and sampling must complete quickly enough for validators to make timely fork-choice and attestation decisions.

## References

- [EIP-7594: PeerDAS](https://eips.ethereum.org/EIPS/eip-7594)
- [Fulu consensus specifications](https://github.com/ethereum/consensus-specs/tree/master/specs/fulu)
- [Original notes: Overview of PeerDAS by <name>Daniel Pham</name>](https://hackmd.io/d5KkrGRMROq7-hLW3m7Org)
