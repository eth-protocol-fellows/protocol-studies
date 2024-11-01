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
#### **Q:** Where can I find the specification for EIP-7702? How can I use it as a wallet dev?
#### **Q:** How do I use account abstraction?
#### **Q:** Do I have to wait for my wallet to support EIP-7702?
#### **Q:** What do I need to know about EIP-7702 as a smart contract dev?
#### **Q:** What do I need to know as a security engineer/auditor?
#### **Q:** What does the BLS opcodes add in pectra?
#### **Q:** How can I use the `BLOCKHASH` OPCODE?
#### **Q:** What are system contracts?
## Stakers
---
**FAQ**:
#### **Q:** What changes about deposits?
#### **Q:** How long do I have to wait for deposits now?
#### **Q:** What balances between 32ETH and 2048ETH can I earn on?
Effective balances increase 1ETH at a time. If your balance is 33.74 effective balance will be 33. If you effective balance is 33.75 then your effective balance will be 34. 
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
#### **Q:** Can I top up ETH in my `0x02` validator?
#### **Q:** How can I top up ETH in my `0x02` validator?
#### **Q:** What happens to the ETH balance if I consolidate and my validator has `0x02` credentials and the total balance goes above 2048 ETH?
