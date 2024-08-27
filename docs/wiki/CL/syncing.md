> [Subjective](https://dictionary.cambridge.org/dictionary/english/subjective): influenced by or based on personal beliefs or feelings, rather than based on facts  
> [Objective](https://dictionary.cambridge.org/dictionary/english/objective): based on real facts and not influenced by personal beliefs or feelings (scroll down on the link)

## Background

Before the merge, a new node synced (configured for a "full sync") with the blockchain as described below:
1. *Query for the latest "final" block from other nodes in the network.* In ETH1, there was no finality as such, but reversing the "work" (Proof-of-work) of 6 blocks was considered difficult enough to call the 7th block from the head "final."
2. *Follow the chain down to genesis using just block headers.* Nodes used the parent block hashes within the header to query for the next block header all the way down to genesis.
3. *Start "syncing" from genesis back to the latest "final" block.* In this step, nodes downloaded the block body (transactions and receipts) and verified it against the header.
4. *Every verified block was passed through the state transition function to update the state.* At genesis, the state is empty (mostly, leaving the exceptions out as they are not relevant). Reaching an up-to-date state makes a node "synced."

In the above process, some pieces of information, like the latest "final" block, are obtained *subjectively* because different nodes may have different views of the chain at any given instant. Other pieces of information, like parent block headers, are obtained objectively i.e. there is a deterministic and definitive method to obtain them. But once all block bodies are downloaded, verified, and applied to obtain an up-to-date state, the subjective pieces of information are also concretely (cryptographically) verified. Therefore, once fully synced and verified, there cannot be an alternate history of the blockchain (or at least it is very improbable according to PoW). In other words, it can be said that the trust in the truth does not depend on the subjective pieces of information. When we say that Ethereum under proof-of-work was objective, we mean the above.

With the Merge, execution blocks are wrapped inside beacon blocks (the beacon chain existed in parallel to the main chain, hence "The Merge") and clients are split into three: an execution layer client, a consensus layer client, and optionally a validator client. Due to this change, the CL node depends on the EL node to verify the execution payload within the beacon blocks. For syncing, however, the EL node depends on the CL node for a sync target. It then follows the same steps as an ETH1 client. To provide this target, the CL node needs to sync the beacon chain first and it ***CANNOT*** use the same approach as the EL node, i.e., to simply sync from genesis. In fact, if you have ever run a CL node, it would complain that syncing from genesis is [unsafe](https://docs.teku.consensys.io/concepts/weak-subjectivity#sync-outside-the-weak-subjectivity-period).

## Weak Subjectivity

*Note: The other major change of the merge is that it switched off PoW and enabled PoS. I'm assuming the reader has some idea about the workings of beacon chain consensus mechanisms. If not, read [this](https://ethos.dev/beacon-chain) first.*

When a validator exits the chain, the right to participate in the consensus process is revoked. The validator can no longer vote/attest for any future blocks. However, *the validator can re-vote/re-attest for any of the **past** blocks*. If enough exited validators re-attest a past block (a past fork block), they create an alternate history of the chain. A node that is at the canonical head wouldn't care about the equivocation (alternate history) since it has already processed the validator exit. However, a node that is syncing does not have any way of knowing the future state of the validator and might follow the wrong chain. To avoid this, the direction of syncing is reversed for the beacon chain. This is the first major difference between beacon block syncing and execution block syncing.

> ETH1 backfills headers but the verification of block bodies happens from genesis -> target. In ETH2, the verification itself happens from target -> genesis. The core of blockchain syncing is verification; without a verified syncing process, there is no point in syncing. Hence, the verification direction is usually considered the syncing direction.

The second difference lies in the anchor of trust in information. Since the history of the chain can be changed under certain conditions the sync target cannot be objectively verified i.e. we can never concretely prove its existence in the canonical chain. Hence, there is a significant amount of trust placed in the sync target and it remains subjective. Because of the trust involved, sync targets (named weak subjectivity checkpoints) are shared out-of-band since random peer connections in the p2p layer of Ethereum cannot be trusted. It is important to note that, only the sync target remains subjective, all other information obtained is objectively verified i.e. the chain is *weakly* subjective.

The third difference lies in the timing of the chain. A node that is out-of-sync for enough time can also be subject to the same attack. Theoretically, the amount of time should allow enough validators to exit and launch an attack. This time period is known as the ***weak subjectivity period***. This time period also applies to the sync target. If the backfilling process (beacon chain) or the execution layer takes too much time to sync, then the target becomes *stale*. Therefore, while the execution layer is syncing (backfilling is usually fast enough), new beacon blocks are continuously imported without checking their execution payload of the new heads. This is referred to as *optimistically* importing blocks.

Therefore, in the post-merge world, a node syncs as defined below:
1. *Obtain a weak subjectivity checkpoint out-of-band*
2. *Backfill blocks all the way back to genesis from the weak subjectivity checkpoint*
3. *Update the target header for the execution chain*
4. *Optimistically follow the head of the chain and continuously update the target header for the execution chain*
5. *Once the EL is synced, then mark the CL slots as verified post-verification. The node may now be considered fully synced*

### Summary

1. Socially sourcing a piece of information doesn't make the chain subjective. Ironically, because the checkpoints remain subjective they are shared socially. It is the trust put it in the information that makes the chain subjective. 
2. Optimistic Sync and Checkpoint Sync cannot be considered different modes of syncing. They solve the same problem but at different stages of the syncing process. Moreover, you need both the modes of syncing to reliably sync the chain. 
3. The paradigm shift in the syncing process eludes most: beacon goes future -> past(backfilling) and execution goes past -> future(genesis syncing). The direction is determined by the direction of verification.

## Useful Links

1. https://docs.prylabs.network/docs/how-prysm-works/optimistic-sync
2. https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/weak-subjectivity/
3. https://www.symphonious.net/2019/11/27/exploring-ethereum-2-weak-subjectivity-period/
