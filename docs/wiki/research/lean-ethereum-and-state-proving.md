# Lean Ethereum & State Proving

## Overview

**Lean Ethereum** is a long-term technical roadmap for the Ethereum base layer proposed by Ethereum Foundation researcher Justin Drake and published on the EF blog on July 31, 2025. It reframes Ethereum's development priorities around two strategic imperatives:

- **Fort Mode** — Hardening security to survive nation-state threats and quantum computing advances.
- **Beast Mode** — Achieving extreme performance (targeting 10,000 TPS on L1, 1M+ TPS on L2) without sacrificing decentralization.

The roadmap restructures all three protocol sublayers — **Consensus**, **Data**, and **Execution** — around a unified cryptographic primitive: **hash-based SNARKs**.

> Note: Lean Ethereum evolved from the "Beam Chain" proposal that Justin Drake introduced at Devcon 7 in Bangkok (November 2024). Beam Chain specifically referred to a redesign of the consensus layer, now called **Lean Consensus**. The "Lean Ethereum" umbrella was introduced in mid-2025 to encompass all three layers.

---

## The Three Pillars

### 1. Lean Consensus

A complete redesign of Ethereum's consensus (Beacon Chain) layer. Key goals:

- **Post-Quantum Cryptography**: Replace BLS signatures (based on elliptic curves, vulnerable to quantum attacks) with hash-based signature schemes that can be efficiently aggregated using SNARKs.
- **3-Slot Finality (3SF)**: Reduce finality from ~15 minutes to seconds. 3SF is a practical alternative to single-slot finality (SSF) that balances speed, security, and implementation complexity.
- **Reduced Validator Requirements**: Lower the minimum stake from 32 ETH to 1 ETH to increase decentralization.
- **Attester-Proposer Separation (APS)**: Decouple block proposer and attester roles to reduce centralization pressure from MEV.
- **Rainbow Staking**: A novel staking mechanism designed to further enhance decentralization.

**Key resources:**
- Lean Consensus Roadmap: [leanroadmap.org](https://leanroadmap.org)
- 3-Slot Finality paper (Feb 2023)
- Post-Quantum signature aggregation research series (2025)

---

### 2. Lean Data

Upgrade Ethereum's data availability (DA) layer:

- **Blobs 2.0**: Expanding blob throughput initiated by EIP-4844 (Dencun upgrade).
- **PeerDAS**: Peer-to-peer data availability sampling to scale blob capacity without requiring all nodes to download all data.

---

### 3. Lean Execution (State Proving)

This is where **state proving** becomes central. The goal is to "snarkify" Ethereum's execution layer — replacing full re-execution by every validator with cryptographic proofs of correctness.

---

## State Proving: What It Is and Why It Matters

### The Problem with Re-Execution

Currently, every Ethereum validator independently re-executes every transaction in every block to verify the resulting state is correct. This:

- Requires significant CPU and memory resources.
- Sets a hard upper limit on how much computation (gas) can fit in a block, because validators must finish execution before the next slot.
- Creates high hardware requirements, threatening validator decentralization.

### The Solution: zkEVMs on L1

A **zkEVM (Zero-Knowledge Ethereum Virtual Machine)** allows a specialized actor (a **prover**) to execute a block and generate a short cryptographic proof that the execution was correct. All other validators then only need to verify this proof — which is orders of magnitude cheaper than re-execution.

```
Current flow:  Block → All validators re-execute → Agree on new state
Future flow:   Block → Prover executes + generates ZK proof → All validators verify proof
```

This enables:
- **Higher gas limits** (more transactions per block) without burdening validators.
- **Lighter validator hardware** (just proof verification).
- **Full validation on mobile devices** or in a browser tab.
- **Native rollups**: L2s whose state transitions can be verified directly by L1 validators.

### Type 1 vs Other zkEVM Types

Vitalik Buterin defined a spectrum of zkEVM types based on Ethereum-compatibility:

| Type | Compatibility | Proving Speed | Notes |
|------|--------------|---------------|-------|
| **Type 1** | Fully Ethereum-equivalent | Slowest | Zero modifications — works with all existing contracts and tooling |
| **Type 2** | Fully EVM-equivalent | Faster | Minor internal changes, almost all apps work |
| **Type 3** | Almost EVM-equivalent | Faster | Some contract modifications needed |
| **Type 4** | High-level language equivalent | Fastest | Compiles Solidity/Vyper directly to ZK-friendly format |

For L1 enshrinement, **Type 1** is the target — full equivalence with no changes to existing applications.

---

## Real-Time Proving

The central technical challenge for state proving is **real-time proving**: generating a ZK proof for an entire Ethereum block within the 12-second slot time.

### Why 12 Seconds Is Hard

Ethereum blocks can contain complex, varied computations. A zkVM must prove every EVM opcode executed across all transactions. The proof must be:
- Generated in under ~10 seconds (to leave time for propagation).
- Using less than 10 kW of power.
- With at least 128-bit security.
- From open-source code.

### 2025: The Breakthrough Year

Real-time proving was achieved in 2025 across multiple competing zkVM teams, with multiple projects independently reaching the milestone. As of late 2025:

- **Pico Prism** proved 99.6% of Ethereum blocks in real-time using 64 RTX 5090 GPUs with an average time of 6.9 seconds.
- **SP1 Hypercube** (Succinct) proved 93% of 10,000 mainnet blocks in real-time on a cluster of 200 GPUs.
- Teams including Risc0, OpenVM, Brevis, Snarkify, ZisK, ZKM, and ZKsync all achieved or approached the milestone.

**ethproofs.org** was launched by the EF to benchmark and compare zkVM performance on real Ethereum blocks.

### The Proving Pipeline

The EF blog post "Shipping an L1 zkEVM #1: Realtime Proving" (July 2025) laid out the phased approach:

1. **Phase 1 — Off-chain proof verification**: Validators optionally run clients that verify proofs generated by zkVMs instead of re-executing. This requires a "pipelining" mechanism (targeted for the Glamsterdam upgrade) to decouple block verification from immediate execution, giving provers more time within a slot.

2. **Phase 2 — Multi-proof diversity**: Instead of trusting a single prover, validators verify proofs from multiple zkVMs implementing different EVM clients. This extends Ethereum's existing client diversity model to the proving layer.

3. **Phase 3 — Protocol enshrinement**: zkEVM proofs become a first-class protocol primitive.

### The L1 zkEVM 2026 Roadmap

Published by the EF's zkEVM team (via Ethereum Magicians, early 2026), the concrete 2026 milestones include:

- Standardizing interfaces between execution and consensus layers for proof requests and verification.
- Researching prover markets, censorship resistance, and economic incentives for provers.
- Formal verification of zkEVM circuit correctness.

---

## Cryptographic Foundations

Lean Ethereum's design is unified around **hash-based cryptography** for both quantum resistance and SNARK efficiency.

### Why Move Away from Current Primitives

| Current Primitive | Vulnerability | Lean Replacement |
|------------------|---------------|-----------------|
| BLS signatures (elliptic curve) | Quantum-breakable (Shor's algorithm) | Hash-based signatures |
| KZG polynomial commitments | Elliptic curve, quantum-vulnerable | Hash-based commitments |
| Poseidon hash function | Under active cryptanalysis | Poseidon2 + ongoing bounty program |

### Key Proof Systems

- **SNARKs (Succinct Non-Interactive Arguments of Knowledge)**: Short proofs verifiable quickly. Used for both execution proving and consensus signature aggregation.
- **STARKs / FRI / WHIR**: Transparent (no trusted setup), post-quantum secure proof systems. WHIR is an improvement over FRI used in Plonky3 and similar frameworks.
- **Binius**: A SNARK system operating over binary fields, highly efficient for hash-based computations.
- **Formal Verification with Lean 4**: The mathematical proof assistant "Lean" (different from Lean Ethereum — coincidental naming!) is being used to formally verify the security of FRI, WHIR, and other proof systems used in the zkEVM.

---

## State Proving in Context: The Full Stack

```
┌─────────────────────────────────────────────┐
│            Lean Ethereum Stack               │
├─────────────────────────────────────────────┤
│  CONSENSUS (Lean Consensus)                  │
│  • Hash-based PQ signatures via SNARKs       │
│  • 3-Slot Finality (3SF)                    │
│  • Reduced stake (1 ETH), APS               │
├─────────────────────────────────────────────┤
│  DATA (Lean Data)                           │
│  • Blobs 2.0 / PeerDAS                      │
│  • Data Availability Sampling               │
├─────────────────────────────────────────────┤
│  EXECUTION (Lean Execution / State Proving)  │
│  • L1 zkEVM (Type 1)                        │
│  • Real-time block proving (<12s)            │
│  • Prover markets & incentives              │
│  • Native rollups (long-term)               │
└─────────────────────────────────────────────┘
```

---

## Key Links & Resources

### Primary Sources
- **Lean Ethereum EF Blog Post** (Jul 31, 2025): https://blog.ethereum.org/2025/07/31/lean-ethereum
- **Lean Consensus Roadmap**: https://leanroadmap.org
- **Shipping an L1 zkEVM #1: Realtime Proving** (Jul 10, 2025): https://blog.ethereum.org/2025/07/10/realtime-proving
- **EF zkEVM Portal**: https://zkevm.ethereum.foundation
- **L1-zkEVM Roadmap 2026** (Ethereum Magicians): https://ethereum-magicians.org/t/l1-zkevm-roadmap-2026-integrating-zkevm-proofs-into-ethereums-core-protocol/27595
- **ethproofs.org** (benchmark tracker): https://ethproofs.org

### Audio / Video
- **Episode 391 — Introduction to Lean Ethereum with Justin Drake** (Bankless / referenced podcast)
- **Beam Chain @ Devcon 7 Bangkok** (Nov 2024) — Justin Drake's original presentation

### Research Papers
- *A Simple Single Slot Finality Protocol for Ethereum* (Feb 2023)
- *3-Slot Finality: SSF Is Not About Single Slot* (Nov 2024)
- *Hash-Based Multi-Signatures for Post-Quantum Ethereum* (Jan 2025)
- *Integrating 3SF with ePBS, FOCIL, and PeerDAS* (Aug 2025)
- *WHIR* — Sep 2024 (fast polynomial commitment scheme)

---

## Open Research Questions

1. **Prover decentralization**: Who generates proofs and how to prevent centralization around large GPU clusters?
2. **Prover incentives**: What is the right economic model for prover markets?
3. **Handling unproable blocks**: What happens when a block cannot be proved in time (e.g., pathological input)?
4. **Security during transition**: How to safely migrate from re-execution to proof-based verification without introducing new attack surfaces?
5. **Poseidon security**: The EF has an active bounty program and ongoing cryptanalysis of the Poseidon hash function used inside SNARK circuits.
6. **Native rollups**: Long-term, how can L2 state transitions be verified natively by L1 validators?

---

