# Consensus Layer (CL) architecture

Ethereum is a decentralized network of nodes that communicate via peer-to-peer connections. These connections are formed by computers running Ethereum's client software.

<a id="img_network"></a>

<figure class="diagram" style="text-align:center">

![Diagram for Network](../../images/cl/network.png)

<figcaption>

_Nodes aren't required to run a validator client (green ones) to be a part of the network, however to take part in consensus one needs to stake 32 ETH and run a validator client._

</figcaption>
</figure>

### Components of the Consensus Layer

- **Beacon Node**: Beacon nodes use client software to coordinate Ethereum's proof-of-stake consensus. Examples include Prysm, Teku, Lighthouse, and Nimbus. Beacon nodes communicate with other beacon nodes, a local execution node, and optionally, a local validator.

- **Validator**: Validator client is the software that allows people to stake 32 ETH in Ethereum's consensus layer. Validators propose blocks in the Proof-of-Stake system, which replaced Proof-of-work miners. Validators communicate only with a local beacon node, which instructs them and broadcasts their work to the network.

The main Ethereum network hosting real-world applications is called Ethereum Mainnet. Ethereum Mainnet is the live, production instance of Ethereum that mints and manages real Ethereum (ETH) and holds real monetary value.

There are also test networks that mint and manage test Ethereum for developers, node runners, and validators to test new functionality before using real ETH on Mainnet. Each Ethereum network has two layers: the execution layer (EL) and the consensus layer (CL). Every Ethereum node contains software for both layers: execution-layer client software (like Nethermind, Besu, Geth, and Erigon) and consensus-layer client software (like Prysm, Teku, Lighthouse, Nimbus, and Lodestar).

<a id="img_node-layers"></a>

<figure class="diagram" style="width: 80%;text-align:center">

![Diagram for CL](../../images/cl/cl.png)

</figure>

**Consensus Layer** is responsible for maintaining consensus chain (beacon chain) and processing the consensus blocks (beacon blocks) and attestations received from other peers. **Consensus clients** participate in a separate [peer-to-peer network](/wiki/CL/cl-networking.md) with a different specification from execution clients. They need to participate in block gossip to receive new blocks from peers and broadcast blocks when it's their turn to propose.

Both EL and CL clients run in parallel and need to be connected for communication. The consensus client provides instructions to the execution client, and the execution client passes transaction bundles to the consensus client to include in Beacon blocks. Communication is achieved using a local RPC connection via the **Engine-API**. They share an [ENR](/wiki/CL/cl-networking?id=enr-ethereum-node-records) with separate keys for each client (eth1 key and eth2 key).

### Control Flow

**When the consensus client is not the block producer:**
1. Receives a block via the block gossip protocol.
2. Pre-validates the block.
3. Sends transactions in the block to the execution layer as an execution payload.
4. Execution layer executes transactions and validates the block state.
5. Execution layer sends validation data back to the consensus layer.
6. Consensus layer adds the block to its blockchain and attests to it, broadcasting the attestation over the network.

**When the consensus client is the block producer:**
1. Receives notice of being the next block producer.
2. Calls the create block method in the execution client.
3. Execution layer accesses the transaction mempool.
4. Execution client bundles transactions into a block, executes them, and generates a block hash.
5. Consensus client adds transactions and block hash to the beacon block.
6. Consensus client broadcasts the block over the block gossip protocol.
7. Other clients validate the block and attest to it.
8. Once attested by sufficient validators, the block is added to the head of the chain, justified, and finalized.


### State Transitions

The state transition function is essential in blockchains. Each node maintains a state that reflects its view of the world.

Nodes update their state by applying blocks in order using a "state transition function". This function is "pure", meaning its output depends only on the input and has no side effects. Thus, if every node starts with the same state (Genesis state) and applies the same blocks, they all end up with the same state. If they don't, there's a consensus failure.

If $S$ is a beacon state and $B$ a beacon block, the state transition function $f$ is:

$$S' \equiv f(S, B)$$

Here, $S$ is the pre-state and $S'$ is the post-state. The function $f$ is iterated with each new block to update the state.

### Beacon Chain State Transitions

Unlike the block-driven Proof-of-work, the beacon chain is slot-driven. State updates depend on slot progress, regardless of block presence.

The beacon chain's state transition function includes:

1. **Per-slot transition**: $S' \equiv f_s(S)$
2. **Per-block transition**: $S' \equiv f_b(S, B)$
3. **Per-epoch transition**: $S' \equiv f_e(S)$

Each function updates the chain at specific times, as defined in the beacon chain specification.

### Validity Conditions

The post-state from a pre-state and a signed block is `state_transition(state, signed_block)`. Transitions causing unhandled exceptions (e.g., failed asserts or out-of-range accesses) or uint64 overflows/underflows are invalid.

### Beacon chain state transition function

The post-state corresponding to a pre-state `state` and a signed block `signed_block` is defined as `state_transition(state, signed_block)`. State transitions that trigger an unhandled exception (e.g. a failed `assert` or an out-of-range list access) are considered invalid. State transitions that cause a `uint64` overflow or underflow are also considered invalid.

```python
def state_transition(state: BeaconState, signed_block: SignedBeaconBlock, validate_result: bool=True) -> None:
    block = signed_block.message
    # Process slots (including those with no blocks) since block
    process_slots(state, block.slot)
    # Verify signature
    if validate_result:
        assert verify_block_signature(state, signed_block)
    # Process block
    process_block(state, block)
    # Verify state root
    if validate_result:
        assert block.state_root == hash_tree_root(state)
```

```python
def verify_block_signature(state: BeaconState, signed_block: SignedBeaconBlock) -> bool:
    proposer = state.validators[signed_block.message.proposer_index]
    signing_root = compute_signing_root(signed_block.message, get_domain(state, DOMAIN_BEACON_PROPOSER))
    return bls.Verify(proposer.pubkey, signing_root, signed_block.signature)
```

```python
def process_slots(state: BeaconState, slot: Slot) -> None:
    assert state.slot < slot
    while state.slot < slot:
        process_slot(state)
        # Process epoch on the start slot of the next epoch
        if (state.slot + 1) % SLOTS_PER_EPOCH == 0:
            process_epoch(state)
        state.slot = Slot(state.slot + 1)
```


## Resources

- Vitalik Buterin, ["Parametrizing Casper: the decentralization/finality time/overhead tradeoff"](https://medium.com/@VitalikButerin/parametrizing-casper-the-decentralization-finality-time-overhead-tradeoff-3f2011672735)
- [Engine API spec](https://hackmd.io/@n0ble/consensus_api_design_space)
- [Vitalik's Annotated Ethereum 2.0 Spec](https://notes.ethereum.org/@vbuterin/SkeyEI3xv)
- Ethereum, ["Eth2: Annotated Spec"](https://github.com/ethereum/annotated-spec)
- Martin Kleppmann, [Distributed Systems.](https://www.youtube.com/playlist?list=PLeKd45zvjcDFUEv_ohr_HdUFe97RItdiB)
- Leslie Lamport et al., [The Byzantine Generals Problem.](https://lamport.azurewebsites.net/pubs/byz.pdf)
- Austin Griffith, [Byzantine Generals - ETH.BUILD.](https://www.youtube.com/watch?v=c7yvOlwBPoQ)
- Michael Sproul, ["Inside Ethereum"](https://www.youtube.com/watch?v=LviEOQD9e8c) 
- [Eth2 Handbook by Ben Edgington](https://eth2book.info/capella/part2/consensus/)
- [Lighthouse Consensus Client architecture](https://www.youtube.com/watch?v=pLHhTh_vGZ0)
