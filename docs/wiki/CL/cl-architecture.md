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

Given a block tree and decision criteria based on a node's local view of the network, the fork choice rule is designed to select the branch that is most likely to become the final, linear, canonical chain. It chooses the branch least likely to be pruned out as nodes converge on a common view.

<a id="img_blocktree"></a>

<figure class="diagram" style="text-align:center; width:95%">

![Diagram for Block Tree](../../images/cl/blocktree.svg)

<figcaption>

_The fork choice rule picks a head block from the candidates. The head block identifies a unique linear blockchain back to the Genesis block._

</figcaption>
</figure>

The fork choice rule implicitly selects a branch by choosing a block at the branch's tip, called the head block. For any correct node, the first rule of any fork choice is that the chosen block must be valid according to protocol rules, and all its ancestors must also be valid. Any invalid block is ignored, and blocks built on an invalid block are also invalid.

There are several examples of different fork choice rules:

- **Proof of Work**: In Ethereum and Bitcoin, the "heaviest chain rule" (sometimes called "longest chain", though not strictly accurate) is used. The head block is the tip of the chain with the most cumulative "work" done.
> Note that contrary to popular belief, Ethereum's proof of work protocol [did not use](https://ethereum.stackexchange.com/questions/38121/why-did-ethereum-abandon-the-ghost-protocol/50693#50693) any form of GHOST in its fork choice. This misconception is very persistent, probably due to the [Ethereum Whitepaper](https://ethereum.org/en/whitepaper/#modified-ghost-implementation). Eventually when Vitalik was asked about it, he confirmed that although GHOST had been planned under PoW it was never implemented due to concerns about some unspecified attacks. The heaviest chain rule was simpler and well tested. It worked fine.
- **Casper FFG (Proof of Stake)**: In Ethereum's PoS Casper FFG protocol, the fork-choice rule is to "follow the chain containing the justified checkpoint of the greatest height" and never revert a finalized block.
- **LMD GHOST (Proof of Stake)**: In Ethereum's PoS LMD GHOST protocol, the fork-choice rule is to take the "Greediest Heaviest Observed SubTree". It involves counting accumulated votes from validators for blocks and their descendent blocks. It also applies the same rule as Casper FFG.

Each of these fork choice rules assigns a numeric score to a block. The winning block, or head block, has the highest score. The goal is that all correct nodes, when they see a certain block, will agree that it is the head and follow its branch. This way, all correct nodes will eventually agree on a single canonical chain that goes back to Genesis.

- Block Trees (Done)
- Fork Choice Rule (Done)
- Reorgs, reversion
- Safety liveness CAP
- GHOSTs in the machine
- Casper FFG and LMD Ghost
- Casper FFG and LMD Ghost together gasper




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
