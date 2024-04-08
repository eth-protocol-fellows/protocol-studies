
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

The process towards securing a preconfirmation promise for transactions within the Ethereum network is initiated by establishing a connection with the next available preconfer. This process entails a series of critical steps and factors, including:

- **Endpoints:** Preconfers may offer direct API endpoints or utilize decentralized peer-to-peer (p2p) networks for the exchange of promises, striking a balance between quick response times and widespread availability.

- **Latency:** Utilizing direct communication channels, the process aims to achieve preconfirmation times as swift as 100 milliseconds, ensuring rapid transaction handling.

- **Bootstrapping:** A substantial participation rate among L1 validators as preconfers is crucial. This ensures that within the proposer lookahead window, there is always a significant chance of encountering a preconfer ready to issue promises.

- **Liveness Fallback:** Users can enhance their transaction's reliability by securing promises from several preconfers, thus safeguarding against the possibility of any single preconfer failing to fulfill their promise due to missed slots.

- **Parallelization:** The system accommodates various promise types, ranging from strict commitments on post-execution state to more flexible, intent-based promises.

- **Replay Protection:** Ensures transactions are protected from replay attacks, vital for maintaining the integrity and security of preconf transactions.

- **Single Secret Leader Election (SSLE):** This mechanism allows for the confidential identification of preconfers within the lookahead period, enabling them to validate their status without revealing their identity prematurely.

- **Delegated Preconf:** Offers a provision for proposers constrained by limited network bandwidth or processing capability, allowing them to delegate their preconfirmation duties to ensure efficient processing of promises.

- **Fair Exchange:** The system addresses the fair exchange dilemma between users and preconfers concerning promise requests and the collection of preconf tips. Solutions include public streaming of promises for transparency, intermediation by trusted relays, or the use of cryptographic fair exchange protocols to balance the interests of all parties involved.

- **Tip Pricing:** The negotiation of preconf tips considers the transaction's potential impact on a proposer’s ability to extract MEV. Through mutual agreement or the assistance of trusted relays, users and preconfers can determine fair compensation for preconfirmations.

- **Negative Tips:** Preconfers may accept negative tips for transactions that enhance their MEV opportunities, such as those affecting DEX prices and creating arbitrage prospects.


Each of these elements plays a crucial role in the functionality and efficiency of based preconfirmations, ensuring transactions are not only processed swiftly but also securely and fairly within the Ethereum ecosystem.


## [Preconfs Acquisition Process Flow](#preconfs-acquisition-process-flow)


## References
[^1]: https://ethresear.ch/t/based-preconfirmations/17353 
