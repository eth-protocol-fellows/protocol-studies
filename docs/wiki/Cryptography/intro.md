# Cryptography

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

Cryptography researchers craft the weapons or implements of change that developers use. They use advanced algebra to exploit the hard limits set by the universe on reality and craft cryptographic schemas that obey certain properties. They are in a sense reality-hackers. They hack reality to create systems that obey objective properties due to the underlying mathematics. 

## Cryptography in Ethereum: Core Primitives and Protocol Roles

Ethereum’s security model depends on carefully chosen cryptographic constructions, each addressing specific constraints—whether in transaction validation, consensus, or scalability. Below is a breakdown of the key schemes and their protocol-level functions at a high-level. Some of the schemes are discussed in a more detailed level in the Cryptography subsections.

1. ### ECDSA and Transaction Authentication**
**Usage:** Every Ethereum transaction must be signed using ECDSA over the secp256k1 curve.

#### Why It Matters:

Unlike account abstraction models (ERC-4337), EOAs require signatures for every operation.

The v, r, s signature format has historical quirks—legacy transactions use v ∈ {27, 28}, while EIP-1559 defines v ∈ {0, 1} to prevent replay attacks.

**Caveats:**

Signature malleability was a concern pre-EIP-155 (fixed via chainID inclusion).

Hardware wallets often implement custom signing logic (e.g., Ledger’s nonce derivation).

2. ### Keccak-256: Beyond "Just a Hash Function"

#### Protocol Roles:

Block hashing (including the mixHash in PoW).

State trie keys (Merkle-Patricia Trees rely on Keccak for node references).

#### Design Choice:

Ethereum adopted Keccak before NIST standardized SHA-3, leading to subtle differences (e.g., padding rules).

Alternatives like Blake2b were considered but rejected for compatibility reasons.

3. ### BLS Signatures in PoS: Tradeoffs and Optimizations
#### Why BLS?

Signature aggregation allows thousands of validator attestations to compress into a single 96-byte proof.

The BLS12-381 curve balances performance and security (pairing-friendly but slower than secp256k1).

Implementation Nuances:

Ethereum’s BLS spec (EIP-2335) enforces strict subgroup checks to avoid rogue-key attacks.

Tools like blst and herumi optimize for different environments (e.g., x86 vs. ARM).

4. ### Verkle Trees: A Shift in State Proofs
**Current Limitation:** Merkle proofs for storage are too large (~1 KB per proof).

**Verkle Solution:**

Replaces hashes with polynomial commitments (KZG), reducing witness sizes to ~200 bytes.

Requires a trusted setup (Ethereum’s KZG ceremony).

**Open Questions:**

How to handle historical proofs post-transition?

Will gas costs for proof verification change?

5. ### ZKPs in Practice: More Than Just Rollups
**zkEVM Challenges:**

Proving EVM execution requires handling variable opcode costs (e.g., SSTORE vs. ADD).

Some circuits (e.g., Keccak) are notoriously hard to optimize.

**Beyond Rollups:**

Light clients could use ZK proofs for sync committee verification (PBS proposals).

Privacy pools (e.g., ZK-based anonymous transactions) are under research.

6. ### Post-Quantum Readiness: Not Just Theoretical
**Immediate Risks:**

Quantum computers could forge ECDSA signatures, but breaking hash functions (Keccak) is harder.

**Migration Paths:**

Lattice-based schemes (e.g., Dilithium) are leading candidates, but key sizes are problematic (~2 KB per key).

Hybrid approaches (e.g., BLS + SPHINCS+) might bridge the transition.


- [BLS12-381 Keystore](https://eips.ethereum.org/EIPS/eip-2335)
- [Vitalik's ZK-SNARK Explainer](https://vitalik.eth.limo/general/2021/01/26/snarks.html)
- [Secp256k1 in Ethereum](https://ethereum.org/en/developers/docs/evm/)
- [Verkle Trees](https://verkle.info/)
- [The different types of ZK-EVMs](https://vitalik.eth.limo/general/2022/08/04/zkevm.html)
- [ZK-SNARKS vs STARKS](https://eprint.iacr.org/2018/046)

https://summerofprotocols.com/wp-content/uploads/2023/12/53-BEIKO-001-2023-12-13.pdf