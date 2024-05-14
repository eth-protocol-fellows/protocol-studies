# A brief introduction to formal verification

## Overview

Formal methods are techniques used for mathematical analysis of software and hardware systems. The philosophical roots of formal methods reach back to ancient Greece with Plato's exploration of theory of forms in his book "Sophist"; throughout 17th the century, mathematicians further developed the concept through abstract algebra. German polymath, Gottfried Leibniz's vision laid the groundwork for what we now call formal reasoning. In the 19th century, pioneering work by [George Boole](https://en.wikipedia.org/wiki/George_Boole) on analysis and [Gottlob Frege](https://en.wikipedia.org/wiki/Gottlob_Frege) on propositional logic provided the foundation for formal methods.

Under formal methods, formal verification is a _verification technique_ that helps find the answer to a simple question: "Does a system correctly meet its required specifications?". It does that by [abstracting a system](https://in.mathworks.com/discovery/abstract-interpretation.html) as a mathematical model and proving or disproving its correctness.

A "system" is defined as a mechanism that is able to execute all of the functions given by its external interface. For a system, an "invariant" is a property that remains unchanged, regardless of its current state. For example, an invariant of a vending machine is: Nobody should be able to dispense a product for free. Formal verification tests the correctness of a system by checking if all its invariants holds true.

This rigorous method for scrutiny of systems scores the highest ranking on the [EAL scale](https://en.wikipedia.org/wiki/Evaluation_Assurance_Level#EAL7:_Formally_Verified_Design_and_Tested), signifying its profound impact on security.

Types of formal verification:

- **Model checking / assertion-based checking**: Models a system as a finite state machine and verifies its correctness and liveness using propositional logic.
- **Temporal logic**: Models a system whose propositions varies with time.
- **Equivalence checking**: Verifies if two models of the same specification but varying implementations produce the same result.

## Popular tools

### Coq

[Coq](https://coq.inria.fr/) is a widely adopted, open source proof management system. It was used to specify and formally verify the CompCert compiler for the C programming language. The compiler is used to [develop safety-critical programs](https://www.inria.fr/en/compcert-software-program-receives-prestigious-award) for aircraft, cars, and nuclear power plants.

### TLA+

[TLA+](https://lamport.azurewebsites.net/tla/tla.html) is a formal specification language developed by the Turing award-winner Leslie Lamport. It is mostly used for modeling concurrent and distributed systems. Amazon web services [uses TLA+](https://www.amazon.science/publications/how-amazon-web-services-uses-formal-methods) for verifying robustness of their distributed systems.

### Alloy

[Alloy](https://alloytools.org/) is an open source language and analyzer for software modeling. Notably, the flash file system design was [analyzed against the POSIX standard](https://eskang.github.io/assets/papers/ijsi09_kang_jackson.pdf) using Alloy.

### Z3

[Z3](https://www.microsoft.com/en-us/research/project/z3-3/) is a symbolic logic solver developed by Microsoft research. It is used in a wide range of software engineering applications, ranging from [program verification](https://www.aon.com/cyber-solutions/aon_cyber_labs/exploring-soliditys-model-checker/), compiler validation, testing, fuzzing, and optimization.

## Example

Formal verification of a system begins by selectively abstracting the system to create a focused model for correctness testing.

[Dijkstra](https://en.wikipedia.org/wiki/Edsger_W._Dijkstra) elegantly describes this process:

> I have grown to regard a program as an ordered set of pearls, a “necklace”. The top pearl describes the program in its
> most abstract form, in all lower pearls one or more concepts used above are explained (refined) in terms of concepts
> to be explained (refined) in pearls below it, while the bottom pearl eventually explains what still has to be explained
> in terms of a standard interface (=machine). The family becomes a given collection of pearls that can be strung
> into a fitting necklace.

The TLA+ spec to models a traffic controller:

```bash
-------------- MODULE TrafficController --------------

CONSTANTS MaxCars
VARIABLES carsWaiting, greenSignal

Init == /\ carsWaiting = 0
        /\ greenSignal = FALSE

Arrive(car) == IF carsWaiting < MaxCars THEN carsWaiting' = carsWaiting + 1 ELSE UNCHANGED carsWaiting

Depart == IF carsWaiting > 0 THEN carsWaiting' = carsWaiting - 1 ELSE UNCHANGED carsWaiting

ChangeSignal == /\ carsWaiting > 0
                /\ greenSignal' = TRUE

Next == \/
         \E car \in {0, 1}: Arrive(car)
         \/ Depart
         \/ ChangeSignal

Invariant == carsWaiting <= MaxCars

Spec == Init /\ [][Next]_<<carsWaiting, greenSignal>> /\ []Invariant

=======================================================

```

Understanding the TLA+ semantics are not important for this discussion. Here is a brief of what it does:

`Init` initializes the system with no cars waiting. The `Arrive` models the arrival of cars, increasing the count of waiting cars if the maximum capacity has not been reached. Conversely, the `Depart` simulates cars departing from the controller, decrementing the count of waiting cars if there are any. Lastly ,`ChangeSignal` dictates that if cars are waiting, the traffic signal switches to green.

The invariant `Invariant == carsWaiting <= MaxCars` ensures the number of cars waiting never exceeds `MaxCars`, a defined constant.

Note how this abstraction conveniently ignores all the irrelevant interactions at a traffic signal (honking, anyone?).

**Efficient abstraction is an art.**

## Ethereum and formal verification

Safety and liveliness assurance is central to Ethereum's decentralized infrastructure. Formal verification plays a critical role in verifying correctness of:

- The protocol's [execution](/wiki/EL/el-specs.md) and [consensus](/wiki/CL/cl-specs.md) specifications.
- [Client](/wiki/EL/el-clients.md) implementations.
- On-chain smart contract applications end users interact with.

### Protocol verification

Formal verification is used by the [Runtime Verification team](https://github.com/runtimeverification) to verify [bacon chain specification](https://runtimeverification.com/blog/a-formal-model-in-k-of-the-beacon-chain-ethereum-2-0s-primary-proof-of-stake-blockchain), and the [Gasper finality mechanism](https://runtimeverification.com/blog/formally-verifying-finality-in-gasper-the-core-of-the-beacon-chain).

[KEVM](https://github.com/runtimeverification/evm-semantics) builds upon [K framework](https://kframework.org/) for crafting formal semantics and conducting verification of the [Ethereum Virtual Machine (EVM)](/wiki/EL/evm.md) specification for correctness.

Formal verification is an essential tool in the test suite and was used to discover a subtle [array-out-of-bound runtime error](https://consensys.io/blog/formal-verification-of-ethereum-2-0-part-1-fixing-the-array-out-of-bound-runtime-error) within the state transition component.

![Formal verification as part of testing suite](./img/fv-and-testing.jpg)
> Formal verification a slice of a Swiss cheese model in a test suite – [Source: Codasip](https://codasip.com/2023/09/19/formal-verification-best-practices-to-reach-your-targets/).

### Verifying optimizations

Equivalence checking is extensively used for software optimization. For example, an optimized smart contract can be tested for correctness against its previous version to confirm that the optimization hasn't introduced any unintended behavior.

### Smart contract verification

Bugs or vulnerabilities in smart contracts can have devastating consequences, leading to financial losses and undermining user trust. Formal verification tools like tools [Certora Prover](https://docs.certora.com/en/latest/docs/prover/index.html) and [halmos](https://github.com/a16z/halmos) helps identify these issues.

For example, Runtime Verification formally verified a [deposit smart contract application](https://runtimeverification.com/blog/formal-verification-of-ethereum-2-0-deposit-contract-part-1) and found a [subtle bug](https://github.com/ethereum/deposit_contract/issues/26).

Formal verification has always been an integral part of the [Solidity](https://soliditylang.org/) language. Here Christian from the Solidity team from an early workshop:

<iframe width="560" height="315" src="https://www.youtube.com/embed/rx0NPckEWGI?si=GYGPPGGA7aY2k4Ci" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

---

Solidity compiler also implements a [formal verification approach based on SMT (Satisfiability Modulo Theories) and Horn solving](https://docs.soliditylang.org/en/latest/smtchecker.html).

Leo from EF Formal Verification team explains how to use this feature:

<iframe width="560" height="315" src="https://www.youtube.com/embed/QQbWpN76HEg?si=CI0cPCVgAkfAM_V2" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

---

## Challenges with formal verification

Formal verification is hard. The process itself can be [complex and time-consuming,](https://www.hillelwayne.com/post/why-dont-people-use-formal-methods) requiring specialized skills and tools. Additionally, formal verification can only guarantee the correctness of the model, not necessarily the underlying implementation itself. Errors in the translation process between model and code can still introduce vulnerabilities.

Formal verification relies on efficient abstraction of a system. And abstraction is hard. If you leave an important detail out of the abstraction it can introduce safety issues. For this reason, often times [engineers use a complementary simulation method like fuzzing](https://blog.trailofbits.com/2024/03/22/why-fuzzing-over-formal-verification/) to test a system using random input.

Despite these challenges, formal verification is a powerful technique that can help design safe and efficient systems. We'll close on this insightful quote from Dijkstra:

> “Program testing can be used to show the presence of bugs, but never to show their absence!”

## Resources

### 🗣️ Talks

- Grigore R., [Formal Verification of Smart Contracts and Protocols: What, Why, How](https://www.youtube.com/watch?v=xggtkB7w3es)
- Roberto S.,[Formal Specification and Verification of the Distributed Validator Technology protocol](https://www.youtube.com/watch?v=xdEo5Tc6TiY)
- Grant P., [Towards Imandra Contracts: Formal verification for Ethereum](https://www.youtube.com/watch?v=xeg_Q5uN73Q)
- Rikard H., [Formal Methods for the Working DeFi Dev](https://www.youtube.com/watch?v=ETlNhV9jYJw)
- Dimitar D. et al., [Formal Verification of Smart Contracts Made Easy](https://www.youtube.com/watch?v=tq5XH3JedqM)
- Yoichi H., [Formal Verification of Smart Contracts](https://www.youtube.com/watch?v=cCUGMAnCh7o)
- Yan M., [Ethereum Bugs Through the Lens of Formal Verification](https://www.youtube.com/watch?v=Ru6X043Q63U)
- Pawel S., [Formal verification applied (with TLA+)](https://www.youtube.com/watch?v=l9XZYI3jta0)

### 📄 Publications

- NASA, [What is formal methods](https://shemesh.larc.nasa.gov/fm/fm-what.html)
- Andrew H., [Formal Verification, Casually Explained](https://ahelwer.ca/post/2018-02-12-formal-verification/)
- Bernie C., [A Brief History of Formal Methods](https://www.researchgate.net/publication/233960390_A_Brief_History_of_Formal_Methods)
- Martin D., [Martin Davis on Computability, Computational Logic, and Mathematical Foundations](https://link.springer.com/book/10.1007/978-3-319-41842-1)
- Ashish D., [A Brief History of Formal Verification](http://homepages.cs.ncl.ac.uk/brian.randell/NATO/nato1969.PDF)
- Serokell, [Formal Verification: History and Methods](https://serokell.io/blog/formal-verification-history)
- Amazon, [How Amazon Web Services Uses Formal Methods](https://cacm.acm.org/research/how-amazon-web-services-uses-formal-methods/)
- Codasip, [Formal verification best practices to reach your targets](https://codasip.com/2023/09/19/formal-verification-best-practices-to-reach-your-targets/)
- Siemens, [How Can You Say That Formal Verification Is Exhaustive?](https://blogs.sw.siemens.com/verificationhorizons/2021/09/16/how-can-you-say-that-formal-verification-is-exhaustive/)
- Siemens, [3 Notable Formal Verification Conference Papers of 2020](https://blogs.sw.siemens.com/verificationhorizons/2021/02/09/3-notable-formal-verification-conference-papers-of-2020/)
- Siemens, [Formal Verification Methods](https://verificationacademy.com/topics/formal-verification/)
- Stanford, [Introduction to First Order Logic](https://plato.stanford.edu/entries/logic-classical/)
- NYU, [Introduction to Satisfiability Modulo Theories](https://cs.nyu.edu/~barrett/pubs/BT14.pdf)
- Sebastian U, [A Formal Verification of Rust's Binary Search Implementation](https://kha.github.io/2016/07/22/formally-verifying-rusts-binary-search.html)
- Jack V., [Primer on TLA+](https://jack-vanlightly.com/blog/2023/10/10/a-primer-on-formal-verification-and-tla)
- Martin L., [Symbolic execution for hevm](https://fv.ethereum.org/2020/07/28/symbolic-hevm-release)
- The Royal Society, [Formal verification: will the seedling ever flower?](https://royalsocietypublishing.org/doi/10.1098/rsta.2015.0402)
