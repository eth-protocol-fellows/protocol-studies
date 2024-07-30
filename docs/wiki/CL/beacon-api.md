# Beacon Chain Spec and APIs

At the core of Ethereum Proof-of-Stake is a system chain called the "Beacon Chain". The beacon chain stores and manages the registry of validators. In the initial deployment phases of Proof-of-Stake, the only mechanism to become a validator is to make a one-way(withdrawable after Capella) ETH transaction to a deposit contract on the Ethereum proof-of-work chain. Activation as a validator happens when deposit receipts are processed by the Beacon Chain, the activation balance is reached, and a queuing process is completed. Exit is either voluntary or done forcibly as a penalty for misbehavior. The primary source of load on the beacon chain is "attestations". Attestations are simultaneously availability votes for a shard block (in a later upgrade) and proof-of-stake votes for a beacon block (Phase 0).

This section will cover some important parts of Beacon Chain Spec and APIs. Also checkout complete [Beacon Chain Spec](https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/beacon-chain.md) and [Beacon API reference](https://ethereum.github.io/beacon-APIs/#/). 

Beacon API is the REST endpoint provided by consensus layer clients (beacon nodes). It's the interface to read information about the consensus and used by validator clients. 

## Containers

`BeaconState`

```python
class BeaconState(Container):
    # Versioning
    genesis_time: uint64
    genesis_validators_root: Root
    slot: Slot
    fork: Fork
    # History
    latest_block_header: BeaconBlockHeader
    block_roots: Vector[Root, SLOTS_PER_HISTORICAL_ROOT]
    state_roots: Vector[Root, SLOTS_PER_HISTORICAL_ROOT]
    historical_roots: List[Root, HISTORICAL_ROOTS_LIMIT]
    # Eth1
    eth1_data: Eth1Data
    eth1_deposit_index: uint64
    application_state_root: Bytes32
    # Registry
    validators: List[Validator, VALIDATOR_REGISTRY_LIMIT]
    balances: List[Gwei, VALIDATOR_REGISTRY_LIMIT]
    # Randomness
    randao_mixes: Vector[Bytes32, EPOCHS_PER_HISTORICAL_VECTOR]
    # Slashings
    slashings: Vector[Gwei, EPOCHS_PER_SLASHINGS_VECTOR]
    # Attestations
    previous_epoch_attestations: List[PendingAttestation, MAX_ATTESTATIONS * SLOTS_PER_EPOCH]
    current_epoch_attestations: List[PendingAttestation, MAX_ATTESTATIONS * SLOTS_PER_EPOCH]
    # Finality
    justification_bits: Bitvector[JUSTIFICATION_BITS_LENGTH]  # Bit set for every recent justified epoch
    previous_justified_checkpoint: Checkpoint  # Previous epoch snapshot
    current_justified_checkpoint: Checkpoint
    finalized_checkpoint: Checkpoint
```

#### `BeaconBlockBody`

```python
class BeaconBlockBody(Container):
    randao_reveal: BLSSignature
    eth1_data: Eth1Data  # Eth1 data vote
    graffiti: Bytes32  # Arbitrary data
    # Operations
    proposer_slashings: List[ProposerSlashing, MAX_PROPOSER_SLASHINGS]
    attester_slashings: List[AttesterSlashing, MAX_ATTESTER_SLASHINGS]
    attestations: List[Attestation, MAX_ATTESTATIONS]
    deposits: List[Deposit, MAX_DEPOSITS]
    voluntary_exits: List[SignedVoluntaryExit, MAX_VOLUNTARY_EXITS]
    application_payload: ApplicationPayload
```
