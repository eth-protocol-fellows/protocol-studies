# Weekly Update #1

> Discover more about [Steven's EPF journey](https://hackmd.io/@qz8qnEAKSzCXkPyX1NRrAg)

## Objectives

This week's focus revolves around laying a foundational understanding of Ethereum's architecture, particularly emphasizing the Execution Layer and Consensus Layer. To achieve this, I plan to engage with a curated selection of educational resources. Additionally, I aim to delve into the intricacies of the Engine API and explore the Ethereum development roadmap to identify areas that pique my interest the most. Detailed objectives include:

- **Understanding the Execution and Consensus Layers**: 
  - Review and comprehend the basic concepts of the Execution Layer and Consensus Layer through selected learning materials. 

- **Exploring the Engine API**:
  - Document the functionality and workflow of the Engine API, highlighting the code flow and key operations. This exploration aims to clarify how the Engine API facilitates interaction between the Execution and Consensus Layers.

- **Researching Ethereum's Roadmap**
  - Investigate the current roadmap for Ethereum's development, with the objective of understanding the strategic goals and upcoming enhancements. This research will focus on identifying the initiatives that significantly contribute to Ethereum's improvement and selecting the ones that align with my areas of interest for deeper exploration.

By accomplishing these objectives, I hope to build a solid foundation of knowledge that will support my journey towards becoming a core contributor to the Ethereum ecosystem.

## Output
**Understanding the Execution and Consensus Layers**

The primary resource I utilized this week was the [Eth2 Book on Consensus Preliminaries](https://eth2book.info/capella/part2/consensus/preliminaries/). Having previously read it, I skimmed through it again, paying special attention to several new sections that have been added. This book provides a solid foundation in understanding the intricate details of the Ethereum 2.0 consensus mechanism, and I highly recommend it to all developers interested in Ethereum's technical underpinnings.

**Exploring the Engine API**:

A particularly helpful resource was the blog [Engine API: A Visual Guide](https://hackmd.io/@danielrachi/engine_api#Block-Building). I explore the Prysm codebase with this blog and below are some annotated insights into the source code:

- **prycm client initialization flow:  prysm/cmd/beacon-chain/main.go**
    1. app.New()  // cli application/instance
    2. parseFlags
    3. app.before(ctx)
    4. app.Action(ctx)
        - node.New() // register every required services
        - startNode(ctx, cancel)
            - beacon, err := node.New(...) // beacon node handles the lifecycle of entire system
            - beacon.Start()
                - beacon.services.StartAll() // initialized each service in order of registration
                    - p2p
                    - initialsync
                    - backfill
                    - attestations
                    - blockchain
                    - ...
    5. app.After(ctx)

- **engine api interface: /prysm/beacon-chain/execution/engine_client.go**
```
type EngineCaller interface {
	NewPayload(ctx context.Context, payload interfaces.ExecutionData, versionedHashes []common.Hash, parentBlockRoot *common.Hash) ([]byte, error)
	ForkchoiceUpdated(
		ctx context.Context, state *pb.ForkchoiceState, attrs payloadattribute.Attributer,
	) (*pb.PayloadIDBytes, []byte, error)
	GetPayload(ctx context.Context, payloadId [8]byte, slot primitives.Slot) (interfaces.ExecutionData, *pb.BlobsBundle, bool, error)
	ExecutionBlockByHash(ctx context.Context, hash common.Hash, withTxs bool) (*pb.ExecutionBlock, error)
	GetTerminalBlockHash(ctx context.Context, transitionTime uint64) ([]byte, bool, error)
}
```

- **validator lifetime**
    1. receive block from other validators: **/prysm/beacon-chain/blockcain/receive_block.go**
        1. extract excution payload
        2. **s.validateExecutionOnBlock**: call engine_newPayload
        3. **s.postBlockProcess**: call engine_engine_forkchoiceUpdated
    2. propose block: **/prysm/beacon-chain/rpc/prysm/v1alpha1/validator/proposer.go**
        1. **vs.ExecutionEngineCaller.ForkchoiceUpdate**: call engine_forkchoiceUpdated
        2. **vs.ExecutionEngineCaller.GetPayload** : call engine_getPayload
        3. compute root and propagate block


**RoadMap**
For reference: [Ethereum Roadmap](https://ethereum.org/en/roadmap/)

The roadmap aims at bringing four benifits for users:
- Cheaper transactions(Done partially)
    - Proto-Danksharding (Done recently in EIP-4844)
    - Danksharding
    - Dencentralizing rollups
- Extra security (need to finalize a specification and start building prototypes)
    - Single slot finality 
    - DVT 
    - Proposer-builder sepration 
    - Secret leader election
- Better user experience
    - Account abstraction(EIP-4337)
    - Nodes for everyone
        - Verkle tree
        - Statelessness(weak statelessness preferred but rely on Verkle tree and Proposer-builder sepration)
        - Data expiry(portal network is an option)
- Future proofing (still in the research phase)
    - Quantum resistance

**I'm currently more interested in PBS and Portal network and more research is needed before final decision.**