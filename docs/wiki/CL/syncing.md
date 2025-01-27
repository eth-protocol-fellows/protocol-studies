> [Subjective](https://dictionary.cambridge.org/dictionary/english/subjective): influenced by or based on personal beliefs or feelings, rather than based on facts  
> [Objective](https://dictionary.cambridge.org/dictionary/english/objective): based on real facts and not influenced by personal beliefs or feelings (scroll down on the link)

## Background

Let's make a distinction between "objectivity" and "subjectivity" in the context of information theory and blockchains. If a piece of information is *completely verifiable* for its *correctness* it is *objective*. If its correctness is not *fully verifiable* (some degree of belief goes into it) then it is "subjective". In reality, most pieces of information lie in the spectrum in between objectivity and subjectivity. 

For example, prior to the merge, if a client started with a genesis block then it could *objectively* verify every block that came after it. To do this a client would ask for the latest "final"(will come to this later) head of the blockchain from its peers and then backtrack all the way to genesis by querying for parent blocks (a.k.a the history). Since the parent hash is encoded into a block it is easy to verify all the queried parent blocks. When the client reaches genesis it can deem the entire history as *correct* and itself as ***synced***. 

> different syncing mechanisms exist today. What is described above is the general overview of a "full" sync

Altering the history of the chain required an ungodly amount of computational power(Proof-of-Work) making the verified history(pre-merge) *objective*. But there is still some amount of trust put into the genesis block being correct. But it can be argued that it is *weakly objective* rather than *subjective* because most clients come packaged with the genesis block and its checksum.  

> A "final" block was considered to be the 7th block from the current head of the blockchain, since reversing 6 blocks worth of PoW was considered difficult.

With the merge, Ethereum brought in membership(validators) and voting for its new consensus mechanism. Moreover, the consensus mechanism was logically isolated from the history and execution mechanism, referred to as the consensus layer(CL) and the execution layer(EL). While the history mechanism mostly remains the same, the latest final block required for syncing is obtained from the consensus layer. In return, the EL verifies the correctness of a block's execution (smart contracts etc.) for the CL to take a vote on the block and gather *consensus*. However, the change in the consensus mechanism made genesis syncing ["unsafe"](https://docs.teku.consensys.io/concepts/weak-subjectivity#sync-outside-the-weak-subjectivity-period). * *Enter weak-subjectivity* *

> The new consensus mechanism also brought in several non-trivial nuances with it. Understanding these nuances is critical for understanding weak subjectivity(next section). This is a great starter: https://ethos.dev/beacon-chain

## Syncing in Weak Subjectivity

When a validator exits the chain, its right to participate in the consensus process is revoked. The validator can no longer vote/attest for any future blocks. However, *the validator can re-vote/re-attest for any of the **past** blocks*. If enough exited validators re-attest a past block (a past fork block), they create an alternate history of the chain. A sync-**ed** node that is at the canonical head wouldn't care about the equivocation (alternate history) since it has already processed the validator exit. However, a node that is sync-**ing** does not have any way of knowing the future state of the validator and might follow the wrong chain. To avoid this, the direction of syncing is reversed for the beacon chain. This is the first major difference between beacon block syncing and execution block syncing.

The second difference lies in the anchor of trust in information. Since the history of the chain can be changed under certain conditions the sync target cannot be objectively verified i.e. we can never concretely prove its existence in the canonical chain. Hence, there is a significant amount of trust placed in the sync target and it remains subjective. Because of the trust involved, sync targets (named weak subjectivity checkpoints) are shared out-of-band since random peer connections in the p2p layer of Ethereum cannot be trusted. It is important to note that, since the sync target is a "finalized" checkpoint it remains *weakly* subjective. In other words, its allows some degree of verification for its correctness (probably just not for its existence).

The third difference lies in the timing of the chain. A node that is out-of-sync for enough time can also be subject to the same attack. Theoretically, the amount of time should allow enough validators to exit and launch an attack. This time period is known as the ***weak subjectivity period***. This time period also applies to the sync target. If the backfilling process (beacon chain) or the execution layer takes too much time to sync, then the target becomes *stale*. Therefore, while the execution layer is syncing (backfilling is usually fast enough), new beacon blocks are continuously imported without checking their execution payload of the new heads. This is referred to as *optimistically* importing blocks.

Therefore a weak subjectivity sync follows the steps defined below:
1. *Obtain a weak subjectivity checkpoint out-of-band*
2. *Backfill blocks all the way back to genesis from the weak subjectivity checkpoint*
3. *Update the target header for the execution chain*
4. *Optimistically follow the head of the chain and continuously update the target header for the execution chain*
5. *Once the EL is synced, then mark the CL slots as verified post-verification. The node may now be considered fully synced*

## Useful Links

1. https://docs.prylabs.network/docs/how-prysm-works/optimistic-sync
2. https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/weak-subjectivity/
3. https://www.symphonious.net/2019/11/27/exploring-ethereum-2-weak-subjectivity-period/
4. https://blog.ethereum.org/2014/11/25/proof-stake-learned-love-weak-subjectivity
5. https://notes.ethereum.org/@adiasg/weak-subjectvity-eth2
6. https://blog.ethereum.org/2016/05/09/on-settlement-finality
