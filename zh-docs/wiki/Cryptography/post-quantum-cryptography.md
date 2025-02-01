# Post-Quantum Cryptography

Classical cryptography safeguards information by leveraging the inherent difficulty of certain mathematical problems. Such group of problems as prime factoring, discrete logarithm, graph isomorphism, and the shortest vector problem etc. fall under the area of mathematical research called the ["Hidden Subgroup Problem (HSP)"](https://en.wikipedia.org/wiki/Hidden_subgroup_problem).

In essence, these problems makes determining the structure of a secret subgroup (size, elements) within a large group computationally intractable without the knowledge of a "secret" (private) key. This one-way "trapdoor function" is employed by public-key cryptography algorithms for their security.

[RSA's](https://en.wikipedia.org/wiki/RSA_(cryptosystem)) security rests on the **factoring of large prime numbers**. In contrast, [ECDSA's](/wiki/Cryptography/ecdsa.md) security is based on the elliptic curve **discrete logarithm problem**. Solving either of these hidden subgroup problems becomes exponentially harder as the key size increases, making them computationally infeasible for classical computers to crack. This fundamental difficulty safeguards encrypted data.

However, the landscape is shifting.

Quantum computers, harnessing the principles of quantum mechanics, offer novel computational approaches. Certain quantum algorithms can solve these classical cryptographic problems with exponential efficiency compared to their classical counterparts. This newfound capability poses a significant threat to the security of data encrypted with classical cryptography. If large-scale quantum computers are ever built, they will be able to break many of the public-key cryptography currently in use.

[Shor's algorithm](https://ieeexplore.ieee.org/document/365700) for integer factorization is the most celebrated application of quantum computing. It factors n-digit integers in a time complexity less than $O(n^3)$, a significant improvement over the best classical algorithms.

This is where the field of post-quantum cryptography comes in. It aims to develop new algorithms that remain secure even in the presence of powerful quantum computers.

## Timeline

According to the survey done for ["Quantum Threat Timeline Report 2020"](https://globalriskinstitute.org/publication/quantum-threat-timeline-report-2020/) most experts believe that there is <5% threat to the public-key cryptography until 2030. However, it is predicted that the risk substantially increases to about 50% by 2050.

Currently, the most [advanced quantum computers](https://en.wikipedia.org/wiki/List_of_quantum_processors) have <2000 physical qubits. Breaking Bitcoin's encryption within an hour (ideal time window) [requires approximately 317 million physical qubits](https://pubs.aip.org/avs/aqs/article/4/1/013801/2835275/The-impact-of-hardware-specifications-on-reaching).

Steady progress is being made in quantum research; one survey respondent notes:

> It is not always the case [..] but I find that my predictions are often more pessimistic than what actually happens. I take this as a sign that the research is accelerating.

Note that these predictions are somewhat subjective and might not reflect real progress which is mostly not open to public. Advanced threat actor might have access to powerful quantum computing sooner than public and use strategies like [retrospective decryption](https://en.wikipedia.org/wiki/Harvest_now%2C_decrypt_later).

## Post-Quantum risk to Ethereum

Ethereum accounts are secured by a two-tier cryptosystem. A private key is used to generate a public key through [elliptic curve multiplication](/wiki/Cryptography/ecdsa.md). This public key is hashed using [keccak256](/wiki/Cryptography/keccak256.md) to derive the Ethereum address.

The immediate post-quantum threat is the ability to reverse elliptic curve multiplication securing ECDSA thus exposing the private key. This makes all externally owned accounts (EOA) vulnerable to a quantum attack. Assuming the hashing function that maps a public-key to an ethereum address is still safe, extracting its private key is still challenging but vulnerable nonetheless.

In practice, most users’ private keys are themselves the result of a bunch of hash calculations using [BIP-32](https://github.com/bitcoin/bips/blob/b3701faef2bdb98a0d7ace4eedbeefa2da4c89ed/bip-0032.mediawiki), which generates each address through a series of hashes starting from a master seed phrase. This makes revealing the private key even more computationally expensive.

EthResearch has an [ongoing proposal](https://ethresear.ch/t/how-to-hard-fork-to-save-most-users-funds-in-a-quantum-emergency/18901) for a hard-fork in the event of a post-quantum emergency, the key actions being:

1. Revert all blocks after the first block where it’s clear that large-scale theft is happening
2. Traditional EOA-based transactions are disabled
3. A new transaction type is added to allow transactions from smart contract wallets (eg. part of [RIP-7560](https://ethereum-magicians.org/t/rip-7560-native-account-abstraction/16664)), if this is not available already
4. A new transaction type or opcode is added by which you can provide a STARK proof which proves knowledge of (i) a private preimage x, (ii) a hash function ID `1 <= i < k` from a list of k approved hash functions, and (iii) a public address A, such that `keccak(priv_to_pub(hashes[i](x)))[12:] = A`. The STARK also accepts as a public input the hash of a new piece of validation code for that account. If the proof passes, your account’s code is switched over to the new validation code, and you will be able to use it as a smart contract wallet from that point forward.

The approach, however, is not perfect. Some users will still loose funds since not all blocks from the event of an attack will be reverted. This is because it is incredibly hard to reliably detect a quantum attack on the network as [domothy highlights](https://ethresear.ch/t/how-to-hard-fork-to-save-most-users-funds-in-a-quantum-emergency/18901/14):

> Picture a single large exchange wallet being drained by a quantum computer. Everyone would naturally assume it was a security failure of some kind on the exchange’s end. Or if a smart wallet relying on discrete log assumption gets drained, a smart contract bug/exploit would be the first thing that comes to mind. Or the quantum-enabled attacker avoids high profile targets altogether and slowly steals funds from various large EOAs, and we never even know a quantum attack took place.

Further, KZG commitment schemes powering [EIP-4844](/wiki/research/scaling/core-changes/eip-4844.md) would also need to be upgraded to prevent fraudulent commits.

## Research

Post-quantum cryptography is an active area of research. Several organizations are working on prototyping, development, and standardization of new post-quantum algorithms.

### NIST Post-Quantum Cryptography

The [NIST Post-Quantum Cryptography standardization](https://csrc.nist.gov/projects/post-quantum-cryptography) effort is a competition like process to solicit, evaluate, and standardize one or more quantum-resistant public-key cryptographic algorithms.

### Selected Algorithms by NIST as part of third round in 2022

#### I. Public-key Encryption and key-establishment algorithms

- [CRYSTALS-KYBER](https://pq-crystals.org/) by Peter Schwabe et al.

#### II. Digital signature algorithm

- [CRYSTALS-DILITHIUM](https://pq-crystals.org/) by Vadim Lyubashevsky et al.
- [FALCON](https://falcon-sign.info/) by Thomas Prest et al.
- [SPHINCS+](https://falcon-sign.info/) by Andreas Hulsing et al.

 NIST's ["2022 status report"](https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=934458) documents the standardization process, evaluation criteria, and security models.

### Post-Quantum Cryptography Alliance

[Post-Quantum Cryptography Alliance (PQCA)](https://pqca.org/), an open and collaborative initiative by [linux foundation](https://www.linuxfoundation.org/press/announcing-the-post-quantum-cryptography-alliance-pqca) to drive the advancement and adoption of post-quantum cryptography.

[The Open Quantum Safe (OQS)](https://openquantumsafe.org/) project under this initiative is an open-source project that aims to support the transition to quantum-resistant cryptography.

### The Crypto Forum Research Group

The [Crypto Forum Research Group](https://datatracker.ietf.org/rg/cfrg/about/) within the Internet Engineering Task Force has standardized the stateful hash-based signature scheme ["XMSS: eXtended Merkle Signature Scheme."](https://datatracker.ietf.org/doc/rfc8391/)

## Production usage

Following pilot projects and research initiatives are exploring PQC usage in production:

- [Anchor Vault](https://chromewebstore.google.com/detail/omifklijimcjhfiojhodcnfihkljeali) is a chrome plugin allows adding a quantum-resistant proof using Lamport's signature for securing ERC tokens.
- Signal has implemented ["Post-Quantum Extended Diffie-Hellman"](https://signal.org/docs/specifications/pqxdh/#introduction) in production for key agreement protocol.
- Chromium started supporting ["Hybrid Kyber KEM"](https://blog.chromium.org/2023/08/protecting-chrome-traffic-with-hybrid.html) to protect data in transit.
- Apple has implemented [PQ3](https://security.apple.com/blog/imessage-pq3/) to protect iMessage against key compromise from a quantum attack.

## Resources

- 📝 Daniel J. Bernstein and et al, ["Introduction to post-quantum cryptography"](https://pqcrypto.org/www.springer.com/cda/content/document/cda_downloaddocument/9783540887010-c1.pdf)
- 📝 Wikipedia, ["Quantum algorithm."](https://en.wikipedia.org/wiki/Quantum_algorithm)
- 📝 P.W. Shor, ["Algorithms for quantum computation: discrete logarithms and factoring."](https://ieeexplore.ieee.org/document/365700)
- 📝 NIST, ["Post-Quantum Cryptography."](https://csrc.nist.gov/projects/post-quantum-cryptography)
- 📝 ETHResearch, ["How to hard-fork to save most users’ funds in a quantum emergency."](https://ethresear.ch/t/how-to-hard-fork-to-save-most-users-funds-in-a-quantum-emergency/18901)
- 📝 ETHResearch, ["ETHResearch: Post-Quantum"](https://ethresear.ch/tag/post-quantum)
- 📝 Vitalik Buterin, ["STARKs, Part I: Proofs with Polynomials."](https://vitalik.eth.limo/general/2017/11/09/starks_part_1.html)
- 📝 Wikipedia, ["Lamport's Signature."](https://en.wikipedia.org/wiki/Lamport_signature)
