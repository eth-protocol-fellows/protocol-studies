# Block building, processing, and applying transaction to state:

 1. Firstly when a validator is chosen as a block builder it calls `engine_forkchoiceUpdatedV2`  function via engine api on the EL. Here EL initiates the block building process.  
https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/eth/catalyst/api.go#L398 
 2. If you look through the miner folder of GETH. Its mostly where the core logic of block building, and transaction execution resides. In the `buildPayload`  function initially and empty block is created so that the we don't miss the slot and have something to propose. In the function implementation it also starts a go routine process who's job is to potentially fill the block which we left empty and then later update it with filled transactions concurrently.  
https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/miner/payload_building.go#L180                                                                                                   https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/miner/payload_building.go#L204
 3. In the `buildPayload`  function the go routine is waiting on multiple communication operations "cases"  and in the first case it calls `getSealingBlock`  with params which explicitly specifies that the block should not be empty. Look at the `fullParams` variable i.e `noTxs:False` .
 4. If you then open the definition for `getSealingBlock`  you'll see that the req is then being sent on `getWorkCh`  channel. Which means this channel is also being listened on somewhere in order to retrieve data from it. [https://github.com/ethereum/goethereum/blob/master/miner/worker.go#L1222](https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/miner/worker.go#L1222)
 5. This `getWorkCh` channel is being listened on inside `mainLoop`  function in the same file. The data which comes from the  `getWorkCh` channel is then sent to `w.generateWork`.  
https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L537
 6. `generateWork`  function is where transactions get filled inside the block.  
https://github.com/ethereum/go-ethereum/blob/0a2f33946b95989e8ce36e72a88138adceab6a23/miner/worker.go#L1094
 7. `w.fillTransactions` function retrieves all the pending transactions from the mempool and fills the block. These contains L1 and L2(Blob) transactions.  
https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L1024
 8. this function after filling the transactions with respect to ordering them on transaction fee basis then later calls `commitTransactions`  function.  
https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L1072
 9. `commitTransactions`  function checks that for each transaction we have enough gas left for both L1 and L2 transactions and then commits that particular transaction. Also there is a certain number of blobs allowed per block so for that please check eip 4844.  
https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L888 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-4844.md
 10. If you look into the `commitTransaction`  function it in return calls `w.applyTransaction` function.                                                                                    https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L760C18-L760C36 
 11. `applyTransaction`  function then goes onto call the core package and calls `core.ApplyTransaction`  which executes all the transactions against the local EL state.  
https://github.com/ethereum/go-ethereum/blob/master/miner/worker.go#L794.
 12. `ApplyTransaction`  function runs the transaction against the local EL state and carries out all the state changes. It creates you EVM contexts and environments to execute the transactions against the EVM. The contract calls also all happen here. If all goes well the state is transitioned successfully.     
https://github.com/ethereum/go-ethereum/blob/master/core/state_processor.go#L161
13. Also transaction can fail. That transaction is not applied then. Can be some failed contract calls or some ether transfer failures etc.  
14. From this point on after all transactions are executed one by one. The transactions are then bundled inside a block.  
15. CL then requests EL via engine for getting this transaction filled payload `getPayload`. EL then returns this payload to the CL which puts this payload on the beacon block and propagates it.
 