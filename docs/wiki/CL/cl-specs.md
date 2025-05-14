# Consensus layer specification

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

Ethereum network started as a proof-of-work blockchain with the intention of switching to proof-of-stake after its bootstrap. The research produced a consensus mechanism combining Casper and GHOST, released in [Gasper paper](https://arxiv.org/abs/2003.03052). The Consesus Layer(CL) is the core component responsible for coordinating Ethereums consensus mechanism. It manages validators, processes attestations and facilitate block finalization. Since multiple [consensus clients](https://ethereum.org/en/developers/docs/nodes-and-clients/#consensus-clients) implemented in different languages exists for validator and participants to validate and participate in the Ethereum network, a formal and consistent blueprint is necessary to ensure that all clients behave identically. The Consensus Specs defines the formal rules for how Ethereum's Proof-of-Stake consensus operates, serving as reference that all implementations mjst follow to maintain compatibility across the network.

Based on its design, a specification was written in python. [Pyspec](https://github.com/ethereum/consensus-specs) is an executable specification that serves as a reference for consensus layer developers. It is also used as reference for client implementations and for creating the test case vectors for clients.

This page provides an overview of the CL specification and its components

## Custom Types, Constants, Presets and Configuration

### Custom Types

The CL Specs defines Python custom types "for type hinting and readability" Each custom maps to a [SSZ (Simple Serialize)](https://epf.wiki/#/wiki/CL/SSZ) equivalent and includes a brief description.

| Name             | SSZ equivalent | Description                       |
| ---------------- | -------------- | --------------------------------- |
| `Slot`           | `uint64`       | a slot number                     |
| `Epoch`          | `uint64`       | an epoch number                   |
| `CommitteeIndex` | `uint64`       | a committee index at a slot       |
| `ValidatorIndex` | `uint64`       | a validator registry index        |
| `Gwei`           | `uint64`       | an amount in Gwei                 |
| `Root`           | `Bytes32`      | a Merkle root                     |
| `Hash32`         | `Bytes32`      | a 256-bit hash                    |
| `Version`        | `Bytes4`       | a fork version number             |
| `DomainType`     | `Bytes4`       | a domain type                     |
| `ForkDigest`     | `Bytes4`       | a digest of the current fork data |
| `Domain`         | `Bytes32`      | a signature domain                |
| `BLSPubkey`      | `Bytes48`      | a BLS12-381 public key            |
| `BLSSignature`   | `Bytes96`      | a BLS12-381 signature             |

### Constants

Constants are values that are expected to remain the same on the beacon chain regardless of the fork or test network it is running. These provide foundational constraints and parameters across the consensus protocol.

#### Misc Constants

| Name                          | Value                 |
| ----------------------------- | --------------------- |
| `UINT64_MAX`                  | `uint64(2**64 - 1)`   |
| `UINT64_MAX_SQRT`             | `uint64(4294967295)`  |
| `GENESIS_SLOT`                | `Slot(0)`             |
| `GENESIS_EPOCH`               | `Epoch(0)`            |
| `FAR_FUTURE_EPOCH`            | `Epoch(2**64 - 1)`    |
| `BASE_REWARDS_PER_EPOCH`      | `uint64(4)`           |
| `DEPOSIT_CONTRACT_TREE_DEPTH` | `uint64(2**5)` (= 32) |
| `JUSTIFICATION_BITS_LENGTH`   | `uint64(4)`           |
| `ENDIANNESS`                  | `'little'`            |

#### Withdrawal prefixes

Withdrawal prefixes relate to the withdrawal credentials provided when deposits are made for validators

| Name                             | Value            |
| -------------------------------- | ---------------- |
| `BLS_WITHDRAWAL_PREFIX`          | `Bytes1('0x00')` |
| `ETH1_ADDRESS_WITHDRAWAL_PREFIX` | `Bytes1('0x01')` |

#### Domain types

Domain types are used for domain separation in signature schemes, ensuring signatures are context-specific.

| Name                         | Value                      |
| ---------------------------- | -------------------------- |
| `DOMAIN_BEACON_PROPOSER`     | `DomainType('0x00000000')` |
| `DOMAIN_BEACON_ATTESTER`     | `DomainType('0x01000000')` |
| `DOMAIN_RANDAO`              | `DomainType('0x02000000')` |
| `DOMAIN_DEPOSIT`             | `DomainType('0x03000000')` |
| `DOMAIN_VOLUNTARY_EXIT`      | `DomainType('0x04000000')` |
| `DOMAIN_SELECTION_PROOF`     | `DomainType('0x05000000')` |
| `DOMAIN_AGGREGATE_AND_PROOF` | `DomainType('0x06000000')` |
| `DOMAIN_APPLICATION_MASK`    | `DomainType('0x00000001')` |

### Presets

Presets are colllections of configuration variables bundled together for different mode of operations such as minimal testnets or mainnet deployments. Presets are expected to differ for various operations based on performance or testing needs.

#### Misc

| Name                             | Value                     |
| -------------------------------- | ------------------------- |
| `MAX_COMMITTEES_PER_SLOT`        | `uint64(2**6)` (= 64)     |
| `TARGET_COMMITTEE_SIZE`          | `uint64(2**7)` (= 128)    |
| `MAX_VALIDATORS_PER_COMMITTEE`   | `uint64(2**11)` (= 2,048) |
| `SHUFFLE_ROUND_COUNT`            | `uint64(90)`              |
| `HYSTERESIS_QUOTIENT`            | `uint64(4)`               |
| `HYSTERESIS_DOWNWARD_MULTIPLIER` | `uint64(1)`               |
| `HYSTERESIS_UPWARD_MULTIPLIER`   | `uint64(5)`               |

#### Gwei values

| Name                          | Value                                   |
| ----------------------------- | --------------------------------------- |
| `MIN_DEPOSIT_AMOUNT`          | `Gwei(2**0 * 10**9)` (= 1,000,000,000)  |
| `MAX_EFFECTIVE_BALANCE`       | `Gwei(2**5 * 10**9)` (= 32,000,000,000) |
| `EFFECTIVE_BALANCE_INCREMENT` | `Gwei(2**0 * 10**9)` (= 1,000,000,000)  |

#### Time parameters

| Name                               | Value                     |  Unit  |   Duration   |
| ---------------------------------- | ------------------------- | :----: | :----------: |
| `MIN_ATTESTATION_INCLUSION_DELAY`  | `uint64(2**0)` (= 1)      | slots  |  12 seconds  |
| `SLOTS_PER_EPOCH`                  | `uint64(2**5)` (= 32)     | slots  | 6.4 minutes  |
| `MIN_SEED_LOOKAHEAD`               | `uint64(2**0)` (= 1)      | epochs | 6.4 minutes  |
| `MAX_SEED_LOOKAHEAD`               | `uint64(2**2)` (= 4)      | epochs | 25.6 minutes |
| `MIN_EPOCHS_TO_INACTIVITY_PENALTY` | `uint64(2**2)` (= 4)      | epochs | 25.6 minutes |
| `EPOCHS_PER_ETH1_VOTING_PERIOD`    | `uint64(2**6)` (= 64)     | epochs |  ~6.8 hours  |
| `SLOTS_PER_HISTORICAL_ROOT`        | `uint64(2**13)` (= 8,192) | slots  |  ~27 hours   |

#### State list lengths

| Name                           | Value                                 |       Unit       |   Duration    |
| ------------------------------ | ------------------------------------- | :--------------: | :-----------: |
| `EPOCHS_PER_HISTORICAL_VECTOR` | `uint64(2**16)` (= 65,536)            |      epochs      |  ~0.8 years   |
| `EPOCHS_PER_SLASHINGS_VECTOR`  | `uint64(2**13)` (= 8,192)             |      epochs      |   ~36 days    |
| `HISTORICAL_ROOTS_LIMIT`       | `uint64(2**24)` (= 16,777,216)        | historical roots | ~52,262 years |
| `VALIDATOR_REGISTRY_LIMIT`     | `uint64(2**40)` (= 1,099,511,627,776) |    validators    |               |

#### Rewards and penalties

| Name                               | Value                          |
| ---------------------------------- | ------------------------------ |
| `BASE_REWARD_FACTOR`               | `uint64(2**6)` (= 64)          |
| `WHISTLEBLOWER_REWARD_QUOTIENT`    | `uint64(2**9)` (= 512)         |
| `PROPOSER_REWARD_QUOTIENT`         | `uint64(2**3)` (= 8)           |
| `INACTIVITY_PENALTY_QUOTIENT`      | `uint64(2**26)` (= 67,108,864) |
| `MIN_SLASHING_PENALTY_QUOTIENT`    | `uint64(2**7)` (= 128)         |
| `PROPORTIONAL_SLASHING_MULTIPLIER` | `uint64(1)`                    |

#### Max operations per block

| Name                     | Value          |
| ------------------------ | -------------- |
| `MAX_PROPOSER_SLASHINGS` | `2**4` (= 16)  |
| `MAX_ATTESTER_SLASHINGS` | `2**1` (= 2)   |
| `MAX_ATTESTATIONS`       | `2**7` (= 128) |
| `MAX_DEPOSITS`           | `2**4` (= 16)  |
| `MAX_VOLUNTARY_EXITS`    | `2**4` (= 16)  |

### Configuration

Configuration refers to a fork-specific set of values that override or complement the preset values depending on the testnet or mainnet environment. For example, parameters like genesis time, initial active validator count, and fork version numbers are set in the configuration files. These values are not hardcoded into the specification but provided dynamically when initializing or testing a specific chain instance.

### Genesis settings

| Name                                 | Value                                        |
| ------------------------------------ | -------------------------------------------- |
| `MIN_GENESIS_ACTIVE_VALIDATOR_COUNT` | `uint64(2**14)` (= 16,384)                   |
| `MIN_GENESIS_TIME`                   | `uint64(1606824000)` (Dec 1, 2020, 12pm UTC) |
| `GENESIS_FORK_VERSION`               | `Version('0x00000000')`                      |
| `GENESIS_DELAY`                      | `uint64(604800)` (7 days)                    |

### Time parameters

| Name                                  | Value                     |    Unit     |  Duration  |
| ------------------------------------- | ------------------------- | :---------: | :--------: |
| `SECONDS_PER_SLOT`                    | `uint64(12)`              |   seconds   | 12 seconds |
| `SECONDS_PER_ETH1_BLOCK`              | `uint64(14)`              |   seconds   | 14 seconds |
| `MIN_VALIDATOR_WITHDRAWABILITY_DELAY` | `uint64(2**8)` (= 256)    |   epochs    | ~27 hours  |
| `SHARD_COMMITTEE_PERIOD`              | `uint64(2**8)` (= 256)    |   epochs    | ~27 hours  |
| `ETH1_FOLLOW_DISTANCE`                | `uint64(2**11)` (= 2,048) | Eth1 blocks |  ~8 hours  |

### Validator cycle

| Name                        | Value                                   |
| --------------------------- | --------------------------------------- |
| `EJECTION_BALANCE`          | `Gwei(2**4 * 10**9)` (= 16,000,000,000) |
| `MIN_PER_EPOCH_CHURN_LIMIT` | `uint64(2**2)` (= 4)                    |
| `CHURN_LIMIT_QUOTIENT`      | `uint64(2**16)` (= 65,536)              |

## Containers

Containers are complex data structures that group related fields together. They are defined using the [Simple Serialization (SSZ)](https://epf.wiki/#/wiki/CL/SSZ) schema and are essential for organizing data within the CL. For specification purposes, these Container data structures are just Python data classes that inherit the base SSZ Container class. Fields missing in container instantiations default to their zero value.

### Misc dependencies

#### Fork

```python
class Fork(Container):
    previous_version: Version
    current_version: Version
    epoch: Epoch  # Epoch of latest fork
```

#### ForkData

```python
class ForkData(Container):
    current_version: Version
    genesis_validators_root: Root
```

#### Checkpoint

```python
class Checkpoint(Container):
    epoch: Epoch
    root: Root
```

#### Validator

```python
class Validator(Container):
    pubkey: BLSPubkey
    withdrawal_credentials: Bytes32  # Commitment to pubkey for withdrawals
    effective_balance: Gwei  # Balance at stake
    slashed: boolean
    # Status epochs
    activation_eligibility_epoch: Epoch  # When criteria for activation were met
    activation_epoch: Epoch
    exit_epoch: Epoch
    withdrawable_epoch: Epoch  # When validator can withdraw funds
```

#### AttestationData

```python
class AttestationData(Container):
    slot: Slot
    index: CommitteeIndex
    # LMD GHOST vote
    beacon_block_root: Root
    # FFG vote
    source: Checkpoint
    target: Checkpoint
```

#### IndexedAttestation

```python
class IndexedAttestation(Container):
    attesting_indices: List[ValidatorIndex, MAX_VALIDATORS_PER_COMMITTEE]
    data: AttestationData
    signature: BLSSignature
```

#### PendingAttestation

```python
class PendingAttestation(Container):
    aggregation_bits: Bitlist[MAX_VALIDATORS_PER_COMMITTEE]
    data: AttestationData
    inclusion_delay: Slot
    proposer_index: ValidatorIndex
```

#### Eth1Data

```python
class Eth1Data(Container):
    deposit_root: Root
    deposit_count: uint64
    block_hash: Hash32
```

#### HistoricalBatch

```python
class HistoricalBatch(Container):
    block_roots: Vector[Root, SLOTS_PER_HISTORICAL_ROOT]
    state_roots: Vector[Root, SLOTS_PER_HISTORICAL_ROOT]
```

#### DepositMessage

```python
class DepositMessage(Container):
    pubkey: BLSPubkey
    withdrawal_credentials: Bytes32
    amount: Gwei
```

#### DepositData

```python
class DepositData(Container):
    pubkey: BLSPubkey
    withdrawal_credentials: Bytes32
    amount: Gwei
    signature: BLSSignature  # Signing over DepositMessage
```

#### BeaconBlockHeader

```python
class BeaconBlockHeader(Container):
    slot: Slot
    proposer_index: ValidatorIndex
    parent_root: Root
    state_root: Root
    body_root: Root
```

#### SigningData

```python
class SigningData(Container):
    object_root: Root
    domain: Domain
```

### Beacon operations

#### ProposerSlashing

```python
class ProposerSlashing(Container):
    signed_header_1: SignedBeaconBlockHeader
    signed_header_2: SignedBeaconBlockHeader
```

#### AttesterSlashing

```python
class AttesterSlashing(Container):
    attestation_1: IndexedAttestation
    attestation_2: IndexedAttestation
```

#### Attestation

```python
class Attestation(Container):
    aggregation_bits: Bitlist[MAX_VALIDATORS_PER_COMMITTEE]
    data: AttestationData
    signature: BLSSignature
```

#### Deposit

```python
class Deposit(Container):
    proof: Vector[Bytes32, DEPOSIT_CONTRACT_TREE_DEPTH + 1]  # Merkle path to deposit root
    data: DepositData
```

#### VoluntaryExit

```python
class VoluntaryExit(Container):
    epoch: Epoch  # Earliest epoch when voluntary exit can be processed
    validator_index: ValidatorIndex
```

### Beacon blocks

#### BeaconBlockBody

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
```

#### BeaconBlock

```python
class BeaconBlock(Container):
    slot: Slot
    proposer_index: ValidatorIndex
    parent_root: Root
    state_root: Root
    body: BeaconBlockBody
```

### Beacon state

#### BeaconState

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
    eth1_data_votes: List[Eth1Data, EPOCHS_PER_ETH1_VOTING_PERIOD * SLOTS_PER_EPOCH]
    eth1_deposit_index: uint64
    # Registry
    validators: List[Validator, VALIDATOR_REGISTRY_LIMIT]
    balances: List[Gwei, VALIDATOR_REGISTRY_LIMIT]
    # Randomness
    randao_mixes: Vector[Bytes32, EPOCHS_PER_HISTORICAL_VECTOR]
    # Slashings
    slashings: Vector[Gwei, EPOCHS_PER_SLASHINGS_VECTOR]  # Per-epoch sums of slashed effective balances
    # Attestations
    previous_epoch_attestations: List[PendingAttestation, MAX_ATTESTATIONS * SLOTS_PER_EPOCH]
    current_epoch_attestations: List[PendingAttestation, MAX_ATTESTATIONS * SLOTS_PER_EPOCH]
    # Finality
    justification_bits: Bitvector[JUSTIFICATION_BITS_LENGTH]  # Bit set for every recent justified epoch
    previous_justified_checkpoint: Checkpoint  # Previous epoch snapshot
    current_justified_checkpoint: Checkpoint
    finalized_checkpoint: Checkpoint
```

### Signed envelopes

#### SignedVoluntaryExit

```python
class SignedVoluntaryExit(Container):
    message: VoluntaryExit
    signature: BLSSignature
```

#### SignedBeaconBlock

```python
class SignedBeaconBlock(Container):
    message: BeaconBlock
    signature: BLSSignature
```

#### SignedBeaconBlockHeader

```python
class SignedBeaconBlockHeader(Container):
    message: BeaconBlockHeader
    signature: BLSSignature
```

## Resource

[How to use Executable Consensus Pyspec by Hsiao-Wei Wang | Devcon Bogotá](https://www.youtube.com/watch?v=ZDUfYJkTeYw)

[Ethereum Consensus Specs GitHub Repository](https://github.com/ethereum/consensus-specs)
