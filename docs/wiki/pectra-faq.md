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
#### **Q:** What do i need to know about EIP-7702 as a smart contract dev?
#### **Q:** What do i need to know as a security engineer/auditor?
#### **Q:** What does the BLS opcodes add in pectra?
#### **Q:** How can i use the `BLOCKHASH` OPCODE?
#### **Q:** What are system contracts?
## Stakers
---
**FAQ**:
#### **Q:** What changes about deposits?
#### **Q:** How long do I have to wait for deposits now?
#### **Q:** What are `0x02` withdrawal credentials?
Withdrawal credentials with `0x02` prefix means it is a compounding credential. Its associated validator will have its max effective balance increased from 32ETH to 2048ETH and immune to partial withdrawal sweep unless the balance goes over 2048ETH. The word compounding comes from the idea the validator is earning compound interest (up to 2048ETH) since the reward one earns depends on its effective balance. Validators in Deneb are earning simple interest as any amount over 32ETH will be automatically withdrawan.
#### **Q:** How do I switch to `0x02` withdrawal credentials? How does it help me?
Only `0x01` validators can switch to `0x02`. There are two ways:
1) Send a transaction to consolidation request address (pending address to be finalized when Electra goes live on mainnet) with `source_pubkey == target_pubkey`.
2) Send a transaction to consolidation request address with `source_pubkey != target_pubkey`. If target validator has `0x01` credential, it will automatically switch to `0x02`.
#### **Q:** Can I deposit a validator with `0x02` credentials directly?
Yes, just make sure `withdrawal_credentials` in the deposit request have `0x02` prefix.
#### **Q:** I have a validator with `0x00` credentials, how do i move to `0x02`?
You will need to convert to `0x01` first using the existed mechanism (no new mechanism introduced in Electra on this regard) then switch to `0x02` from there.
#### **Q:** I have a validator with `0x01` credentials, how do i move to `0x02`?
#### **Q:** What is MaxEB?
MaxEB or the [EIP-7251](https://eips.ethereum.org/EIPS/eip-7251) increases the `MAX_EFFECTIVE_BALANCE` to 2048 ETH while keeping the minimum staking balance at 32 ETH. Before MaxEB, any entity that wanted to contribute a large amount of ETH to consenus had to spin up multiple validators because each was capped at a maximum of 32 ETH. EIP-7251 will allow large stake operators to consolidate their ETH into fewer validators, using the same stake with up to 64 times less individual validators. It also allows solo stakers' ETH to be compounded into their existing validator and contribute to their rewards without having to use the exact validator amount. For example, 35 ETH will be considered the validator's effective balance by the protocol, instead of leaving out 3 ETH ineffective and waiting till 64 ETH for 2 validators. Overall, consolidating validators will allow for fewer attestations in the consensus network and easing the bandwidth usage by nodes.
#### **Q:** How do I consolidate my validator?
Send a transaction to consolidation request address with `source_pubkey != target_pubkey`. Note that both source and target validator must not have `0x00` credential and their exits have not been initiated. 
#### **Q:** What happens to my original, individual validators?
The source validator after consolidation is processed will have its balance decreased to zero. Afterwards it will be ejected from the network since its balance drops below 16ETH.
#### **Q:** When does the balance appear on my consolidated validator?
#### **Q:** When happens if I consolidate one validator with`0x01` and another with `0x00` credentials?
The consolidation request will be deemed invalid and will not be processed. 
#### **Q:** What happens if I consolidate validators that are exited?
The consolidation request will be deemed invalid and will not be processed. 
#### **Q:** How can I partially withdraw some ETH from my `0x02` validator?
Send a transaction to partial withdrawal request address (pending address to be finalized when Electra goes live on mainnet) with `amount` being a positive non-zero Gwei amount.
#### **Q:** How much ETH can i withdraw from my validator?
For partial withdrawals on a `0x02` validator, only the portion over 32ETH can be withdrawan. For example, if you currently have 34ETH, and you request a partial withdrawal of 10ETH, only 2ETH will be withdrawn.
#### **Q:** What happens to the ETH balance if my validator has `0x02` credentials and goes below 32 ETH?
A normally behaved validator will not have its balance dropped below 32ETH even if you initiate a partial withdrawal request. This can only be achieved if you receive penalty. Nothing will happen except you will receive reduced rewards. If balance drops below 16ETH you will be ejected from the network.
#### **Q:** What happens to the ETH balance if my validator has `0x02` credentials and goes above 2048 ETH?
You will be subject to partial withdrawal sweep. Any portion over 2048ETH will be automatically withdrawan. Similar to how partial withdrawal sweep sweeps anything over 32ETH in Deneb.
#### **Q:** Can I top up ETH in my `0x02` validator?
Yes.
#### **Q:** How can I top up ETH in my `0x02` validator?
There is no difference topping up a `0x01` vs `0x02` validator. Send a deposit transaction to deposit contract.
#### **Q:** What happens to the ETH balance if I consolidate and my validator has `0x02` credentials and the total balance goes above 2048 ETH?
The balance will briefly goes over 2048ETH. The portion over 2048ETH will be withdrawn when partial withdrawal sweep comes.
