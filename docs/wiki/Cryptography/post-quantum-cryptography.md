# Post-Quantum Cryptography

Classical cryptography safeguards information by leveraging the inherent difficulty of certain mathematical problems. These problems fall under the area of mathematical research called the ["Hidden Subgroup Problem (HSP)"](https://en.wikipedia.org/wiki/Hidden_subgroup_problem). Imagine a large group with a secret subgroup known only to insiders, these problems makes determining the structure of the secret subgroup (size, elements) computationally intractable for an outsider. Whereas, someone with the "secret" (the private key) can easily identify the subgroup.

Public-key cryptography leverages this concept. Algorithms like RSA, DSA, and [ECDSA](/wiki/Cryptography/ecdsa.md) rely on hidden subgroup problems like prime factorization of large integers or discrete logarithm calculations to secure private keys. The difficulty of solving these problems increases exponentially with key size, making brute-force attacks impractical for classical computers. This inherent difficulty safeguards encrypted data.

However, the landscape is shifting.

Quantum computers, harnessing the principles of quantum mechanics, offer novel computational approaches. Certain quantum algorithms can solve these classical cryptographic problems with exponential efficiency compared to their classical counterparts. This newfound capability poses a significant threat to the security of data encrypted with classical cryptography.

[Shor's algorithm](https://ieeexplore.ieee.org/document/365700) for integer factorization is the most celebrated application of quantum computing. It factors n-digit integers in a time complexity less than $O(n^3)$, a significant improvement over the best classical algorithms.

This is where the field of post-quantum cryptography comes in. It aims to develop new algorithms that remain secure even in the presence of powerful quantum computers.

Post-quantum cryptography is an active area of research. Currently, NIST is evaluating submissions to standardize quantum-resistant algorithms.

## Selected Algorithms 2022

### Public-key Encryption and Key-establishment Algorithms

- [CRYSTALS-KYBER](https://pq-crystals.org/) by Peter Schwabe et al.

### Digital Signature Algorithm

- [CRYSTALS-DILITHIUM](https://pq-crystals.org/) by Vadim Lyubashevsky et al.
- [FALCON](https://falcon-sign.info/) by Thomas Prest et al.
- [SPHINCS+](https://falcon-sign.info/) by Andreas Hulsing et al.

 NIST's ["status report"](https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=934458) documents the standardization process, evaluation criteria, and security models.

## Resources

- 📝 Daniel J. Bernstein and et al, ["Introduction to post-quantum cryptography"](https://pqcrypto.org/www.springer.com/cda/content/document/cda_downloaddocument/9783540887010-c1.pdf)
- 📝 Wikipedia, ["Quantum algorithm."](https://en.wikipedia.org/wiki/Quantum_algorithm)
- 📝 P.W. Shor, ["Algorithms for quantum computation: discrete logarithms and factoring."](https://ieeexplore.ieee.org/document/365700)
- 📝 NIST, ["Post-Quantum Cryptography."](https://csrc.nist.gov/projects/post-quantum-cryptography)
