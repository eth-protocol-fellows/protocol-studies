# Pectra FAQ

**What is Pectra?**
Pectra, (Prague - Electra), is the next network upgrade scheduled for Ethereum. The full list of EIPs as well as an introduction to the features can be found [here](https://notes.ethereum.org/@ethpandaops/mekong#What-is-in-the-Mekong-testnet).

**Who is this guide for?**
For App developers, Stakers and Node operators who are interested in the upcoming Pectra upgrade.

Overall
---
**FAQ**:
#### **Q:** What is Prague/Electra?
**A:** Prague and Electra are the names of the upcoming Ethereum hard fork. The included EIPs can be found [here](https://eips.ethereum.org/EIPS/eip-7600). Prague is the name of the fork on the execution client side, and Electra is the upgrade name on the consensus layer client side. 

There are 3 main features along with some smaller EIPs included in Pectra. They are: Max effective balance, Account abstraction and Execution Layer triggered exits.

The MaxEB feature will allow the user to have a > 32ETH effective balance. This would allow users to consolidate many validators (or deposit new ones) into one up to 2048ETH. The requirement to use this feature is the setting of the `0x02` withdrawal credentials. A user can either make a deposit directly with `0x02` credentials or the user can move from `0x01` to `0x02`.

With EIP-7702, The user wallet would be able to delegate control to a smart contract. This pattern allows a new wallet and app interaction design space, leading the path for future full account abstraction solutions.

The Execution layer triggered exits feature allows the withdrawal address set in the `0x02` withdrawal credential is able to perform exits directly in the execution layer without any reliance on pre-signed BLS keys. This feature is mainly targetted at staking pools, who would be able to use smart contracts to fully control the validator lifecycle.

Users/Devs
---
**FAQ**:
#### **Q:** What is EIP-7702/Account abstraction?
While EIP-7702 isn’t quite account abstraction, it does provide execution abstraction, i.e adds additional functionality to externally owned accounts (EOAs. This allows your EOA to do things like send transaction batches and delegate to other cryptographic key schemes, like passkeys. It does this by setting the code associated with the EOA to a protocol-level proxy designation. A full specification can be found [here](https://eips.ethereum.org/EIPS/eip-7702). It introduces a new transaction type that temporarily authorizes specific contract code for an EOA during a single transaction, allowing EOAs to function as smart contract accounts. This enables several use cases for users, including transaction batching, gas sponsorship, and privilege de-escalation.

#### **Q:** Where can I find the specification for EIP-7702? How can I use it as a wallet dev?
The specification for EIP-7702 is can be found [here](https://eips.ethereum.org/EIPS/eip-7702). To get started as a wallet developer, you'll need to determine a smart contract wallet core to use with the EOA. Pay close attention to how the wallets [should be initialized](https://eips.ethereum.org/EIPS/eip-7702#front-running-initialization). Once you have determined the core wallet to use, you'll need to expose behavior like `eth_sendTransaction` and other custom methods for EIP-7702 specific functionality like batch transactions.

#### **Q:** As a user, how can I use account abstraction?
To get the [benefits](https://ethereum.org/en/roadmap/account-abstraction/) of account abstraction, you need to use a wallet that supports it. Once your wallet of choice supports account abstraction, you will be able to make use of it. 

#### **Q:** Do I have to wait for my wallet to support EIP-7702?
Unfortunately yes, until your wallet integrates EIP-7702 it will not be possible to make use of the new functionalities it provides.

#### **Q:** What do I need to know about EIP-7702 as a smart contract dev?
As a smart contract developer, you should know that after Prague the majority of users on Ethereum will now be able to interact with the chain in more complex ways than were feasible before. Many standards have been developed to work around the limitations of EOAs, such as [ERC-2612 Permit](https://eips.ethereum.org/EIPS/eip-2612).

#### **Q:** What do I need to know as a security engineer/auditor?
As a security engineer / auditor, you must be aware that the previous assumption that a frame cannot be reentered when `msg.sender == tx.origin` no longer holds. This means the check is no longer suitable for reentrancy guards or flash loan protection.

#### **Q:** What does the EIP-2537 BLS precompile add in pectra?
EIP-2537 Adds operation on BLS12-381 curve as a precompile to Ethereum. BLS12-381 precompile enables efficient BLS signature verification. This is useful for applications where multiple signatures need to be verified, such as proof checking systems. 

#### **Q:** How can I use the `BLOCKHASH` OPCODE?
The last 8192 blockhash are now stored and available for access in the `BLOCKHASH` system contract. The `BLOCKHASH` opcode semantics remains the same as before, just that the block number can now be specified in big-endian encoding. The blockhash system contract can also be called via the ethCall RPC method, with the block number in question being passed as calldata. 

#### **Q:** What are system contracts?
System contracts are interfaces defined as contracts, which are essential for certain Ethereum functions to occur. The contract approach is used instead of each client implementing the logic in order to simplify maintenance as well as allow for upgrades in the future with minimal overhead.

Stakers
---
**FAQ**:
#### **Q:** What changes about deposits?
The process of making and submitting deposits will not change. You can continue to use the same tools as earlier. However, the mechanism for processing deposits on Ethereum will undergo an improvement. This improvement is described by [EIP-6110](https://eips.ethereum.org/EIPS/eip-6110) and will allow almost immediate processing of deposits. 

#### **Q:** How long do I have to wait for my deposits to be included?
After the changes included in [EIP-6110](https://eips.ethereum.org/EIPS/eip-6110), the deposits should show up in <20 minutes during regular finalizing periods of the chain. However, there is still a deposit queue for your validator to be activated, the EIP merely ensures that the deposit is seen faster and more securely by the chain and does not influence how quickly a validator is activated. 

#### **Q:** What are `0x02` withdrawal credentials?
Up until the Pectra fork, Ethereum accepted two types of withdrawal credentials: `0x00` and `0x01`. The main change is that `0x01`  contain an execution layer address that receives partial and full withdrawals. The `0x02` withdrawal credentials are a new type of withdrawal credentials that will be introduced in the Pectra upgrade. The `0x02` withdrawal credentials will allow for maximum effective balances of >32 ETH and <2048ETH either via larger deposits or via consolidations of existing validators. The `0x02` withdrawal credentials also enable the ability to exit validators with the execution layer withdrawal address, enabling complete control of the validator via the execution layer. 

#### **Q:** How do I switch to `0x02` withdrawal credentials? How does it help me?
There are 2 ways in which a validator can have `0x02` withdrawal credentials:
1. When you deposit a new validator with `0x02` withdrawal credentials
2. When you consolidate existing validators to `0x02` withdrawal credentials by sending a transaction to consolidation request address

The `0x02` withdrawal credential enables you to control the validator exit from your execution layer address as well as allows you to possess maximum effective balances of >32 ETH and <2048ETH. This means you can run one validator and have a single validator with a balance of up to 2048 ETH.

#### **Q:** Can I deposit a validator with `0x02` credentials directly?
Yes, you can deposit a validator with `0x02` credentials directly. This will allow you to have a single validator with a balance of up to 2048 ETH. The `staking-cli` will support the `0x02` withdrawal credentials in the coming months before the Pectra mainnet Ethereum fork. 

#### **Q:** I have a validator with `0x00` credentials, how do I move to `0x02`?
There is no direct way to move from `0x00` to `0x02`. You will need to first move your validator from `0x00` to `0x01` withdrawal credentials with a BLS change operation, then consolidate your validators to `0x02` withdrawal credentials. You can alternatively exit the validator and make a new deposit with `0x02` withdrawal credentials during the deposit.

#### **Q:** I have a validator with `0x01` credentials, how do i move to `0x02`?
You can consolidate your validators to `0x02` withdrawal credentials. This will allow you to have a single validator with a balance of up to 2048 ETH. The `staking-cli` will support the `0x02` withdrawal credentials in the coming months before the Pectra mainnet Ethereum fork.

#### **Q:** What is MaxEB?
MaxEB or the [EIP-7251](https://eips.ethereum.org/EIPS/eip-7251) increases the `MAX_EFFECTIVE_BALANCE` to 2048 ETH while keeping the minimum staking balance at 32 ETH. Before MaxEB, any entity that wanted to contribute a large amount of ETH to consensus had to spin up multiple validators because each was capped at a maximum of 32 ETH. EIP-7251 will allow large stake operators to consolidate their ETH into fewer validators, using the same stake with up to 64 times less individual validators. It also allows solo stakers' ETH to be compounded into their existing validator and contribute to their rewards without having to use the exact validator amount. For example, 35 ETH will be considered the validator's effective balance by the protocol, instead of leaving out 3 ETH ineffective and waiting till 64 ETH for 2 validators. Overall, consolidating validators will allow for fewer attestations in the consensus network and easing the bandwidth usage by nodes.

#### **Q:** How do I consolidate my validator?
Send a transaction to consolidation request address with `source_pubkey != target_pubkey`. Note that both source and target validator must not have `0x00` credential and their exits have not been initiated. 

#### **Q:** What are the validator requirements for consolidation?
The validators must be active on the beacon chain at the time of consolidation execution. This means they cannot be exiting or pending activation or any other state besides active. Both the source and the target validators must have the same `0x01` withdrawal credentials. If these two conditions are met, then the validator may be consolidated. 

#### **Q:** What happens to my original, individual validators?
During a consolidation, there is a source and a target validator. The source validator is completely exited and the balance is then transferred to the target validator. The target validator will have the sum of the balances of the source validator and the target validator and will continue to perform its beacon chain duties without any change. 

#### **Q:** When does the balance appear on my consolidated validator?
Once the source validator has completely exited and ceased performing all duties, the balance will be credited to the target validator. 

#### **Q:** When happens if I consolidate one validator with`0x01` and another with `0x00` credentials?
The consolidation request will be deemed invalid and will not be processed. It will fail if both validators don't contain a `0x01` withdrawal credential with the exact same execution layer address. 

#### **Q:** What happens if I consolidate validators that are exited?
The consolidation will fail as the validators must be active on the beacon chain at the time of consolidation execution.

#### **Q:** How can I partially withdraw some ETH from my `0x02` validator?
You can issue a EL triggered exit to partially withdraw some ETH from the `0x02` validator. Send a transaction to partial withdrawal request address (pending address to be finalized when Electra goes live on mainnet) with `amount` being a positive non-zero Gwei amount.

#### **Q:** How much ETH can I withdraw from my validator?
You can withdraw the portion above full validator amount, as long as the validator contains >32ETH at the time of completion of the withdrawal. For example, if you currently have 34ETH, and you request a partial withdrawal, 2ETH will be withdrawn.

#### **Q:** What happens to the ETH balance if my validator has `0x02` credentials and goes below 32 ETH?
A normally behaved validator will not have its balance dropped below 32ETH even if you initiate a partial withdrawal request. This can only be achieved if validator receives penalty. Nothing will happen except reduced rewards. However if balance drops below 16ETH, the validator will be exited and the balance will be transferred to the execution layer withdrawal address.

#### **Q:** What happens to the ETH balance if my validator has `0x02` credentials and goes above 2048 ETH?
The balance will continue to collect at the validator until the next partial withdrawal is triggered. The validator will however contain a maximum effective balance of 2048 ETH, the remaining balance will be considered ineffective in the beacon chain.

#### **Q:** What balances between 32ETH and 2048ETH can I earn on?
The effective balance increments 1ETH at a time. This means the accrued balance needs to meet a threshold before the effective balance changes. e.g, If your balance is 33.74 effective balance will be 33. If you effective balance is 33.75 then your effective balance will be 34.

#### **Q:** Can I top up ETH in my `0x02` validator?
You can either consolidate a validator into the `0x02` validator to increase its balance or make a fresh deposit.

#### **Q:** What happens to the ETH balance if I consolidate and my validator has `0x02` credentials and the total balance goes above 2048 ETH?
The balance will continue to collect at the validator until the next partial withdrawal is triggered. The validator will however contain a maximum effective balance of 2048 ETH, the remaining balance will be considered ineffective in the beacon chain. The portion over 2048ETH will be withdrawn when partial withdrawal sweep comes.