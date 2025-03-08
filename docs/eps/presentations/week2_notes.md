# Week 2 Lecture

## Overview

### Block Validation

go
func stf(parent types.Block, block types.Block, state state.StateDB) (state.StateDB, error) {
    if err := core.VerifyHeaders(parent, block); err != nil {
            // header error detected
            return nil, err
    }
    for , tx := range block.Transactions() {
        res, err := vm.Run(block.Header(), tx, state)
        if err != nil {
                // transaction invalid, block is invalid
                return nil, err
        }
        state = res
    }
    return state, nil
}

func newPayload(execPayload engine.ExecutionPayload) bool {
    if , err := stf(..); err != nil {
        return false
    }
    return true
}

https://github.com/ethereum/go-ethereum/blob/63aaac81007ad46b208570c17cae78b7f60931d4/consensus/beacon/consensus.go#L229C23-L229C35

### Block Building

go
func build(env Environment, pool txpool.Pool, state state.StateDB) (types.Block, state.StateDB, error) {
    var (
        gasUsed = 0
        txs []types.Transactions
    )
    for ; gasUsed < env.GasLimit || !pool.Empty(); {
        tx := pool.Pop()
        res, gas, err := vm.Run(env, tx, state)
        if err != nil {
            // tx invalid
            continue
        }
        gasUsed += gas
        txs = append(txs, tx)
        state = res
    }
    return core.Finalize(env, txs, state)
}

### State Transition Function
* walkthrough go-ethereum

### EVM

* arithmetic
* bitwise
* environment
* control flow
* stack ops
    * push, pop, swap
* system
    * call, create, return, sstorage
* memory
    * mload, mstore, mstore8

### p2p

* execution layer operates on devp2p
* devp2p => sub-capability eth/68, eth/69, snap, whisper, les, wit
* eth/1 -> eth/2 -> eth/6.1 -> eth/6.2 

#### Responsibility

* historical data
    * GetBlockHeader
    * GetBlockBodies
    * GetReceipts
* pending transactions
    * Transactions
    * NewPooledTransactionHashes
    * GetPooledTransactions
* state
    snap

    R1      -> 
   / \
  x   x
 / \ / \ 
a  b c  d

    R200      -> 
   / \
  1   2
 / \ / \ 
r  a c  d

^^^ contiguous state retrieval

R200

a b c d


"healing phase"

* get R200 -> (1, 2)
* get 1 -> (r, a)

r a c d

* get 2 -> (c, d)

"healing done"


#### Start snap

* start weak subjectivity-checkpoint -> block hash
* get block associated with hash
* start snap against block's state
