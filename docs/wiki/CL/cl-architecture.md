# Consensus Layer (CL) architecture

**tldr;**

> - Many blockchain consensus protocols are "forkful".
> - Forkful chains use a fork choice rule, and sometimes undergo reorganisations.
> - Ethereum's consensus protocol combines two separate consensus protocols.
> - "LMD GHOST" essentially provides liveness.
> - "Casper FFG" provides finality.
> - Together they are sometimes known as "Gasper".
> - In a "live" protocol, something good always happens.
> - In a "safe" protocol, nothing bad ever happens.
> - No practical protocol can be always safe and always live.

## Fork-choice Mechanism

As described in [previous section](/wiki/CL/overview.md), for various reasons - like network delays, outages, out-of-order messages, or malicious behavior — nodes in the network can have different views of the network's state. Eventually, we want every honest node to agree on an identical, linear history and a common view of the system's state. The protocol's fork choice rule is what helps achieve this agreement.

#### Block Tree
Given a block tree and decision criteria based on a node's local view of the network, the fork choice rule is designed to select the branch that is most likely to become the final, linear, canonical chain. It chooses the branch least likely to be pruned out as nodes converge on a common view.

<a id="img_blocktree"></a>

<figure class="diagram" style="text-align:center; width:95%">

![Diagram for Block Tree](../../images/cl/blocktree.svg)

<figcaption>

_The fork choice rule picks a head block from the candidates. The head block identifies a unique linear blockchain back to the Genesis block._

</figcaption>
</figure>

#### Fork choice rules

The fork choice rule implicitly selects a branch by choosing a block at the branch's tip, called the head block. For any correct node, the first rule of any fork choice is that the chosen block must be valid according to protocol rules, and all its ancestors must also be valid. Any invalid block is ignored, and blocks built on an invalid block are also invalid.

There are several examples of different fork choice rules:

- **Proof of Work**: In Ethereum and Bitcoin, the "heaviest chain rule" (sometimes called "longest chain", though not strictly accurate) is used. The head block is the tip of the chain with the most cumulative "work" done.
> Note that contrary to popular belief, Ethereum's proof of work protocol [did not use](https://ethereum.stackexchange.com/questions/38121/why-did-ethereum-abandon-the-ghost-protocol/50693#50693) any form of GHOST in its fork choice. This misconception is very persistent, probably due to the [Ethereum Whitepaper](https://ethereum.org/en/whitepaper/#modified-ghost-implementation). Eventually when Vitalik was asked about it, he confirmed that although GHOST had been planned under PoW it was never implemented due to concerns about some unspecified attacks. The heaviest chain rule was simpler and well tested. It worked fine.
- **Casper FFG (Proof of Stake)**: In Ethereum's PoS Casper FFG protocol, the fork-choice rule is to "follow the chain containing the justified checkpoint of the greatest height" and never revert a finalized block.
- **LMD GHOST (Proof of Stake)**: In Ethereum's PoS LMD GHOST protocol, the fork-choice rule is to take the "Greediest Heaviest Observed SubTree". It involves counting accumulated votes from validators for blocks and their descendent blocks. It also applies the same rule as Casper FFG.

Each of these fork choice rules assigns a numeric score to a block. The winning block, or head block, has the highest score. The goal is that all correct nodes, when they see a certain block, will agree that it is the head and follow its branch. This way, all correct nodes will eventually agree on a single canonical chain that goes back to Genesis.

#### Reorgs and Reversion

As a node receives new votes (and new votes for blocks in proof of stake), it re-evaluates the fork choice rule with this new information. Usually, a new block will be a child of the current head block, and it will become the new head block.

Sometimes, however, the new block might be a descendant of a different block in the block tree. If the node doesn't have the parent block of the new block, it will ask its peers for it and any other missing blocks.

Running the fork choice rule on the updated block tree might show that the new head block is on a different branch than the previous head block. When this happens, the node must perform a reorg (reorganisation). This means it will remove (revert) blocks it previously included and adopt the blocks on the new head's branch.

For example, if a node has blocks $A, B, D, E,$ and $F$ in its chain, and it views $F$ as the head block, it knows about block $$ but it does not appear in its view of the chain; it is on a side branch.

<a id="img_reorg0"></a>

<figure class="diagram" style="text-align:center">

![Diagram for Reorg-0](../../images/cl/reorg-0.svg)

<figcaption>

_At this point, the node believes that block $F$ is the best head, therefore its chain is blocks $[A \leftarrow B \leftarrow D \leftarrow E \leftarrow F]$_

</figcaption>
</figure>

When the node later receives block $G$, which is built on block $C$, not on its current head block $F$, it must decide if $G$ should be the new head. If the fork choice rule says $G$ is the better head block just for example here, the node will revert blocks $D, E,$ and $F$. It will remove them from its chain, as if they were never received, and go back to the state after block $B$.

Then, the node will add blocks $C$ and $G$ to its chain and process them. After this reorg, the node's chain will be $A, B, C,$ and $G$.

<a id="img_reorg1"></a>

<figure class="diagram" style="text-align:center">

![Diagram for Reorg-1](../../images/cl/reorg-1.svg)

<figcaption>

_Now the node believes that block $G$ is the best head, therefore its chain must change to the blocks $[A \leftarrow B \leftarrow C \leftarrow G]$_

</figcaption>
</figure>

Later, perhaps, a block $H$ might appear, that's built on $F$, and the fork choice rule says $H$ should be the new head, the node will reorg again, reverting to block $B$ and replaying blocks on $H$'s branch.

Short reorgs of one or two blocks are common due to network delays. Longer reorgs should be rare unless the chain is under attack or there is a bug in the fork choice rule or its implementation.

### Safety and Liveness

In consensus mechanisms, two key concepts are safety and liveness.

**Safety** means "nothing bad ever happens," such as preventing double-spending or finalizing conflicting checkpoints. It ensures consistency, meaning all honest nodes should always agree on the state of the blockchain.

**Liveness** means "something good eventually happens," ensuring the blockchain can always add new blocks and never gets stuck in a deadlock.

**CAP Theorem** states that no distributed system can provide consistency, availability, and partition tolerance simultaneously. This means we can't design a system that is both safe and live under all circumstances when communication is unreliable.

#### Ethereum Prioritizes Liveness

Ethereum’s consensus protocol aims to offer both safety and liveness in good network conditions. However, it prioritizes liveness during network issues. In a network partition, nodes on each side will continue to produce blocks but won't achieve finality (a safety property). If the partition persists, each side may finalize different histories, leading to two irreconcilable, independent chains.

Thus, while Ethereum strives for both safety and liveness, it leans towards ensuring the network remains live and continues to process transactions, even at the cost of potential safety issues during severe network disruptions.

## The Ghosts in the Machine

Ethereum's proof of stake consensus protocol combines two separate protocols: [LMD GHOST]() and [Casper FFG](). Together, they form the consensus protocol known as "Gasper". Detailed Information about both protocols and how they work in combination are covered in the next section [Gasper].

Gasper aims to combine the strengths of both LMD GHOST and Casper FFG. LMD GHOST provides liveness, ensuring the chain keeps running by producing new blocks regularly. However, it is prone to forks and not formally safe. Casper FFG, on the other hand, provides safety by periodically finalizing the chain, protecting it from long reversions.

In essence, LMD GHOST keeps the chain moving forward, while Casper FFG ensures stability by finalizing blocks. This combination allows Ethereum to prioritize liveness, meaning the chain continues to grow even if Casper FFG can't finalize blocks. Although this combined mechanism isn't always perfect and has some complexities, it is a practical engineering solution that works well in practice for Ethereum.

## Architecture




Beacon Chain clients are implementing various fundamental features: 

- Forkchoice mechanism 
- Engine API for communication with the execution client
- Beacon APIs for validators and users
- libp2p protocol for communication with other CL clients

## Resources

- Vitalik Buterin, ["Parametrizing Casper: the decentralization/finality time/overhead tradeoff"](https://medium.com/@VitalikButerin/parametrizing-casper-the-decentralization-finality-time-overhead-tradeoff-3f2011672735)
- Ethereum, ["Eth2: Annotated Spec"](https://github.com/ethereum/annotated-spec)
- Martin Kleppmann, [Distributed Systems.](https://www.youtube.com/playlist?list=PLeKd45zvjcDFUEv_ohr_HdUFe97RItdiB)
- Leslie Lamport et al., [The Byzantine Generals Problem.](https://lamport.azurewebsites.net/pubs/byz.pdf)
- Austin Griffith, [Byzantine Generals - ETH.BUILD.](https://www.youtube.com/watch?v=c7yvOlwBPoQ)
- Michael Sproul, ["Inside Ethereum"](https://www.youtube.com/watch?v=LviEOQD9e8c) 
