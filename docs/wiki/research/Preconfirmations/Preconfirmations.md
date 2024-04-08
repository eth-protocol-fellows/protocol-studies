
# Ethereum Based Preconfirmations

## [Overview](#overview)

Based preconfirmations (preconfs) represent a significant advancement in Ethereum transaction processing, offering users swift and reliable execution. Through a combination of on-chain infrastructure, proposer accountability mechanisms, and flexible promise acquisition processes, preconfs stand to significantly enhance the user experience in Ethereum interactions. This technology not only reduces transaction latency but also introduces a layer of security and efficiency previously unseen in the ecosystem[^1].


## [Construction of Preconf Promises](#construction-of-preconf-promises)

Preconfirmation promises, or "preconfs," reply on two foundational on-chain infrastructure components:

- **Proposer Slashing:** Proposers can opt into additional slashing conditions to ensure reliability and accountability. This approach draws inspiration from EigenLayer's model, which employs restaking as a means of enforcing these slashing mechanisms.

- **Proposer Forced Inclusions:** To ensure the seamless execution of transactions, proposers have the authority to mandate the inclusion of specific transactions on-chain. This capability is necessary in situations where the separation between proposers and builders (PBS) renders self-building impractical. The implementation of this mechanism typically involves the use of inclusion lists.


When a L1 proposer decides to become a "preconfer," they are essentially agreeing to adhere to two distinct slashing conditions related to preconf promises. In return for their service, preconfers issue signed promises to users and are compensated with tips for successfully fulfilling these promises. The hierarchy among preconfers is determined based on their position in the slot order, with precedence given to those with earlier slot assignments.

A transaction that secures a preconf promise gains the eligibility for immediate inclusion and execution on-chain by any proposer positioned before the issuer of the promise (preconfer). The primary obligation of the preconfer is to honor all such promises during their designated slot, utilizing the inclusion list to facilitate this process.

There are two main types of promise-related faults, each carrying the potential for slashing:

1. **Liveness Faults:** These faults occur when a preconfer fails to include a promised transaction on the chain because their designated slot was missed.

2. **Safety Faults:** These arise when the preconfer includes transactions on-chain that directly contradict the promises made, despite not missing their slot.


To ensure that transactions with preconf promises are given priority, a specific execution queue is established for transactions lacking such promises. This arrangement guarantees that preconfed transactions are executed ahead of others.

Preconfers are not limited to a single type of preconfirmation promise. They can offer a spectrum of promises, ranging from strict execution guarantees based on specific state roots to simpler promises of transaction inclusion. This flexibility allows preconfers to cater to a wide array of user needs and preferences.


## [Key Elements of Preconfs](#key-elements-of-preconfs)


## [Preconfs Acquisition Process Flow](#preconfs-acquisition-process-flow)


## References
[^1]: https://ethresear.ch/t/based-preconfirmations/17353 
