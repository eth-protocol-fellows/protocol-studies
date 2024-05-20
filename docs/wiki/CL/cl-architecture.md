# Consensus Layer (CL) architecture

**tldr;**

> - Proof of work and proof of stake are not consensus protocols, but enable consensus protocols.
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

- Block Trees
- Fork Choice Rule
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
