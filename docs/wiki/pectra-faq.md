# Pectra FAQ

**What is Pectra?**
Pectra, (Prague - Electra), is the next network upgrade scheduled for Ethereum. The full list of EIPs as well as an introduction to the features can be found [here](https://notes.ethereum.org/@ethpandaops/mekong#What-is-in-the-Mekong-testnet).

**Who is this guide for?**
For App developers, Stakers and Node operators who are interested in the upcoming Pectra upgrade.

[toc]

Overall
---
**FAQ**:
#### **Q:** What is Prague/Electra?
**A:** Prague and Electra are the names of the upcoming Ethereum hard fork. The included EIPs can be found [here](https://eips.ethereum.org/EIPS/eip-7600). Prague is the name of the fork on the execution client side, and Electra is the upgrade name on the consensus layer client side. 

## Users/Devs
---
**FAQ**:
#### **Q:** What is EIP-7702/Account abstraction?
While EIP-7702 isn’t quite account abstraction, it does provide execution abstraction. This allows your EOA to do things like send transaction batches and delegate to other cryptographic key schemes, like passkeys. It does this by setting the code associated with the EOA to a protocol-level proxy designation. A full specification can be found [here](https://eips.ethereum.org/EIPS/eip-7702).

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

#### **Q:** How can I use the `BLOCKHASH` OPCODE?

#### **Q:** What are system contracts?
## Stakers
---
**FAQ**:
#### **Q:** What changes about deposits?
The process of making and submitting deposits will not change. You can continue to use the same tools as earlier. However, the mechanism for processing deposits on Ethereum will undergo an improvement. This improvement is described by [EIP-6110](https://eips.ethereum.org/EIPS/eip-6110) and will allow almost immediate processing of deposits. 

#### **Q:** How long do I have to wait for my deposits to be included?
After the changes included in [EIP-6110](https://eips.ethereum.org/EIPS/eip-6110), the deposits should show up in <20mins during regular finalizing periods of the chain. However, there is still a deposit queue for your validator to be activated, the EIP merely ensures that the deposit is seen faster and more securely by the chain and does not influence how quickly a validator is activated. 

#### **Q:** What are `0x02` withdrawal credentials?
#### **Q:** How do I switch to `0x02` withdrawal credentials? How does it help me?
#### **Q:** Can I deposit a validator with `0x02` credentials directly?
#### **Q:** I have a validator with `0x00` credentials, how do i move to `0x02`?
#### **Q:** I have a validator with `0x01` credentials, how do i move to `0x02`?
#### **Q:** What is MaxEB?
MaxEB or the [EIP-7251](https://eips.ethereum.org/EIPS/eip-7251) increases the `MAX_EFFECTIVE_BALANCE` to 2048 ETH while keeping the minimum staking balance at 32 ETH. Before MaxEB, any entity that wanted to contribute a large amount of ETH to consenus had to spin up multiple validators because each was capped at a maximum of 32 ETH. EIP-7251 will allow large stake operators to consolidate their ETH into fewer validators, using the same stake with up to 64 times less individual validators. It also allows solo stakers' ETH to be compounded into their existing validator and contribute to their rewards without having to use the exact validator amount. For example, 35 ETH will be considered the validator's effective balance by the protocol, instead of leaving out 3 ETH ineffective and waiting till 64 ETH for 2 validators. Overall, consolidating validators will allow for fewer attestations in the consensus network and easing the bandwidth usage by nodes.
#### **Q:** How do I consolidate my validator?
#### **Q:** What happens to my original, individual validators?
#### **Q:** When does the balance appear on my consolidated validator?
#### **Q:** When happens if I consolidate one validator with`0x01` and another with `0x00` credentials?
#### **Q:** What happens if I consolidate validators that are exited?
#### **Q:** How can I partially withdraw some ETH from my `0x02` validator?
#### **Q:** How much ETH can I withdraw from my validator?
#### **Q:** What happens to the ETH balance if my validator has `0x02` credentials and goes below 32 ETH?
#### **Q:** What happens to the ETH balance if my validator has `0x02` credentials and goes above 2048 ETH?
#### **Q:** What balances between 32ETH and 2048ETH can I earn on?
The effective balance increments 1ETH at a time. This means the accrued balance needs to meet a threshold before the effective balance changes. e.g, If your balance is 33.74 effective balance will be 33. If you effective balance is 33.75 then your effective balance will be 34.
#### **Q:** Can I top up ETH in my `0x02` validator?
#### **Q:** How can I top up ETH in my `0x02` validator?
#### **Q:** What happens to the ETH balance if I consolidate and my validator has `0x02` credentials and the total balance goes above 2048 ETH?
