<!-- markdownlint-disable MD013 -->

# Pectra FAQ

**What is Pectra?**
ectra, (Prague - Electra), is an Ethereum network upgrade that activated on Ethereum mainnet at epoch `364032`, on **07-May-2025 at 10:05 (UTC)**.. The full list of EIPs as well as an introduction to the features can be found [here](https://notes.ethereum.org/@ethpandaops/mekong#What-is-in-the-Mekong-testnet).

**Who is this guide for?**
For App developers, Stakers and Node operators who are interested in the upcoming Pectra upgrade.

## Overall

**FAQ**:

### **Q:** What is Prague/Electra?

**A:** Prague and Electra are the names of the upcoming Ethereum hard fork. The included EIPs can be found [here](https://eips.ethereum.org/EIPS/eip-7600). Prague is the name of the fork on the execution client side, and Electra is the upgrade name on the consensus layer client side.

There are 3 main features along with some smaller EIPs included in Pectra. They are: [EIP-7251](https://eips.ethereum.org/EIPS/eip-7251) also known as Max effective balance (MaxEB), [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702), and [EIP-7002](https://eips.ethereum.org/EIPS/eip-7002) also known as Execution Layer triggered exits.

The [MaxEB](https://eips.ethereum.org/EIPS/eip-7251) feature will allow the user to have a > 32ETH effective balance. This would allow users to consolidate many validators (or deposit new ones) into one up to 2048ETH. The requirement to use this feature is the setting of the `0x02` withdrawal credentials. A user can either make a deposit directly with `0x02` credentials or the user can move from `0x01` to `0x02`.

With [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702), the user wallet would be able to delegate control to a smart contract. This pattern allows a new wallet and app interaction design space, leading the path for future full account abstraction solutions.

The [Execution Layer (EL) triggered exits](https://eips.ethereum.org/EIPS/eip-7002) is a new feature that allows the withdrawal address set in the `0x01` or `0x02` withdrawal credential to perform exits directly in EL, without relying on pre-signed BLS keys. This feature is mainly targeted at staking pools, enabling them to use smart contracts to fully control the validator lifecycle.

## Users/Devs

More resources and data on Pectra can be found at [https://pectra.wtf/](https://pectra.wtf/).

**FAQ**:

### **Q:** What is EIP-7702 and how does it relate to Account abstraction?

While [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702) isn’t quite account abstraction, it does provide execution abstraction, i.e adds additional functionality to externally owned accounts (EOAs. This allows your EOA to do things like send transaction batches and delegate to other cryptographic key schemes, like passkeys. It does this by setting the code associated with the EOA to a protocol-level proxy designation. A full specification can be found [here](https://eips.ethereum.org/EIPS/eip-7702). It introduces a new transaction type that temporarily authorizes specific contract code for an EOA during a single transaction, allowing EOAs to function as smart contract accounts. This enables several use cases for users, including transaction batching, gas sponsorship, and privilege de-escalation.

#### **Q:** Where can I find the specification for EIP-7702? How can I use it as a wallet dev?

The specification for [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702) can be found [here](https://eips.ethereum.org/EIPS/eip-7702). To get started as a wallet developer, you'll need to determine a smart contract wallet core to use with the EOA. Pay close attention to how the wallets [should be initialized](https://eips.ethereum.org/EIPS/eip-7702#front-running-initialization). Once you have determined the core wallet to use, you'll need to expose behavior like `eth_sendTransaction` and other custom methods for [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702) specific functionality like batch transactions.

#### **Q:** As a user, how can I use EIP-7702?

To get the [benefits](https://ethereum.org/en/roadmap/account-abstraction/) of EIP-7702, which is an early attempt at account abstraction, you need to use a wallet that supports it. Once your wallet of choice supports account abstraction, you will be able to make use of it.

#### **Q:** Do I have to wait for my wallet to support EIP-7702?

Unfortunately yes, until your wallet integrates [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702) it will not be possible to make use of the new functionalities it provides.

#### **Q:** What do I need to know about EIP-7702 as a smart contract dev?

As a smart contract developer, you should know that after Prague the majority of users on Ethereum will now be able to interact with the chain in more complex ways than were feasible before. Many standards have been developed to work around the limitations of EOAs, such as [ERC-2612 Permit](https://eips.ethereum.org/EIPS/eip-2612).

#### **Q:** What do I need to know about EIP-7702 as a security engineer/auditor?

As a security engineer / auditor, you must be aware that the previous assumption that a frame cannot be reentered when `msg.sender == tx.origin` no longer holds. This means the check is no longer suitable for reentrancy guards or flash loan protection.

#### **Q:** What does the EIP-2537 BLS precompile add in pectra?

[EIP-2537](https://eips.ethereum.org/EIPS/eip-2537) introduces operations on the BLS12-381 curve as precompiles to Ethereum. BLS12-381 precompiles enables efficient BLS signature verification. This is useful for applications where multiple signatures need to be verified, such as proof-checking systems.

#### **Q:** How can I use the `BLOCKHASH` OPCODE?

The last 8192 blockhash are now stored and available for access in the `BLOCKHASH` system contract. The `BLOCKHASH` opcode semantics remains the same as before, just that the block number can now be specified in big-endian encoding. The blockhash system contract can also be called via the ethCall RPC method, with the block number in question being passed as calldata.

#### **Q:** What are system contracts?

System contracts are interfaces defined as contracts, which are essential for certain Ethereum functions to occur. The contract approach is used instead of each client implementing the logic in order to simplify maintenance as well as allow for upgrades in the future with minimal overhead.

## Stakers

**FAQ**:

### **Q:** What changes about deposits?

The process of making and submitting deposits will not change. You can continue to use the same tools as earlier. However, the mechanism for processing deposits on Ethereum will undergo an improvement. This improvement is described by [EIP-6110](https://eips.ethereum.org/EIPS/eip-6110) and will allow almost immediate processing of deposits.

#### **Q:** How long do I have to wait for my deposits to be included?

After the changes included in [EIP-6110](https://eips.ethereum.org/EIPS/eip-6110), the deposits should show up in <20 minutes during regular finalizing periods of the chain. However, there is still a deposit queue for your validator to be activated, the EIP merely ensures that the deposit is seen faster and more securely by the chain and does not influence how quickly a validator is activated.

#### **Q:** What are `0x02` withdrawal credentials?

Up until the Pectra fork, Ethereum accepted two types of withdrawal credentials: `0x00` and `0x01`. The main change is that `0x01` contain an execution layer address that receives partial and full withdrawals. The `0x02` withdrawal credentials are a new type of withdrawal credentials that will be introduced in the Pectra upgrade. The `0x02` withdrawal credentials will allow for maximum effective balances of >32 ETH and <2048ETH either via larger deposits or via consolidations of existing validators. The `0x02` withdrawal credentials also enable the ability to exit validators with the execution layer withdrawal address, enabling complete control of the validator via the execution layer.

#### **Q:** How do I switch to `0x02` withdrawal credentials? How does it help me?

There are 2 ways in which a validator can have `0x02` withdrawal credentials:

1. When you deposit a new validator with `0x02` withdrawal credentials
2. When you consolidate existing validators to `0x02` withdrawal credentials by sending a transaction to consolidation request address

While both the `0x01` and `0x02` withdrawal credential enables you to control the validator exit from your execution layer address, only `0x02` allows the validator to possess a maximum effective balances of >32 ETH and <2048ETH. This means you can run one validator and have a single validator with a balance of up to 2048 ETH.

#### **Q:** Can I deposit a validator with `0x02` credentials directly?

Yes, you can deposit a validator with `0x02` credentials directly. This will allow you to have a single validator with a balance of up to 2048 ETH.

To try out deposits right now, you can use the [`staking-cli`](https://github.com/eth-educators/ethstaker-deposit-cli) from ethstaker, which already supports `0x02` credentials via the `--compounding` flag. You may also specify deposit amounts higher or lower than 32 ETH via the `--amount` flag.
The official [`staking-deposit-cli`](https://github.com/ethereum/staking-deposit-cli) will support the `0x02` withdrawal credentials in the coming months before the Pectra mainnet Ethereum fork.

The generated deposit data files can then be sent to the networks launchpad to do the deposit transactions as usual.
For the testnets, you can use the [`Submit Deposits`](https://dora.mekong.ethpandaops.io/validators/deposits/submit) page in Dora to submit the generated deposits. Support for the official launchpad is coming in the next months too.

#### **Q:** I have a validator with `0x00` credentials, how do I move to `0x02`?

There is no direct way to move from `0x00` to `0x02`. You will need to first move your validator from `0x00` to `0x01` withdrawal credentials with a BLS change operation, then consolidate your validators to `0x02` withdrawal credentials. You can alternatively exit the validator and make a new deposit with `0x02` withdrawal credentials during the deposit.

#### **Q:** I have a validator with `0x01` credentials, how do i move to `0x02`?

You can consolidate your validator to `0x02` withdrawal credentials via a self consolidation with both, the source and target pointing to your validator. This will change your withdrawal credentials to `0x02` and allows you to have a single validator with a balance of up to 2048 ETH. For new deposits, the `staking-cli` will support the `0x02` withdrawal credentials in the coming months before the Pectra mainnet Ethereum fork.

#### **Q:** What is MaxEB?

[EIP-7251](https://eips.ethereum.org/EIPS/eip-7251) or MaxEB increases the `MAX_EFFECTIVE_BALANCE` to 2048 ETH while keeping the minimum staking balance at 32 ETH. Before MaxEB, any entity that wanted to contribute a large amount of ETH to consensus had to spin up multiple validators because each was capped at a maximum of 32 ETH. [EIP-7251](https://eips.ethereum.org/EIPS/eip-7251) will allow large stake operators to consolidate their ETH into fewer validators, using the same stake with up to 64 times less individual validators. It also allows solo stakers' ETH to be compounded into their existing validator and contribute to their rewards without having to use the exact validator amount. For example, 35 ETH will be considered the validator's effective balance by the protocol, instead of leaving out 3 ETH ineffective and waiting till 64 ETH for 2 validators. Overall, consolidating validators will allow for fewer attestations in the consensus network and easing the bandwidth usage by nodes.

#### **Q:** How do I consolidate my validators?

To consolidate your validators, you first need to ensure that both the source and target validators have either `0x01` or `0x02` credentials assigned.
Validators with withdrawal credentials using the `0x00` prefix or pointing to different execution layer addresses cannot be consolidated.

To consolidate two validators, send a transaction from your withdrawal address to the consolidation system contract, including the public keys of the source and target validators you wish to consolidate.

We expect this functionality to be added to various tools in the coming months.
For testing right now, you can use the [Submit Consolidations](https://dora.mekong.ethpandaops.io/validators/submit_consolidations) page in Dora. Connect with the wallet used as the withdrawal address for your validators, and you should be able to select your validators and craft an appropriate consolidation transaction.

A consolidation where the source and target point to the same validator is called a self-consolidation.
In this situation, the validator will not be exited, and no funds will be moved. It will simply be assigned 0x02 credentials.

#### **Q:** What are the validator requirements for consolidation?

The validators must be active on the Beacon Chain at the time of consolidation execution. This means they cannot be exiting, pending activation, or in any state other than active.
The source address must authorize the consolidation transaction and the target must be a validator with `0x02` credentials. Validators with different withdrawal credentials can be also consolidated.

#### **Q:** What happens to my original, individual validators?

During a consolidation, there is a source and a target validator. The source validator is completely exited and the balance is then transferred to the target validator. The target validator will have the sum of the balances of the source validator and the target validator and will continue to perform its beacon chain duties without any change.

#### **Q:** When does the balance appear on my consolidated validator?

Once the source validator has completely exited and ceased performing all duties, the balance will be credited to the target validator.

#### **Q:** What happens if I consolidate one validator with `0x01` and another with `0x00` credentials?

The consolidation request will be deemed invalid and will not be processed. It will fail if both validators don't contain a `0x01` withdrawal credential with the exact same execution layer address.

#### **Q:** What happens if I consolidate validators that are exited?

The consolidation will fail as the validators must be active on the beacon chain at the time of consolidation execution.

#### **Q:** Whats the ABI of the consolidation system contract?

The EIP-7251 consolidations contract is deployed here `0x0000BBdDc7CE488642fb579F8B00f3a590007251`, source here: [ethereum/sys-asm/src/consolidations/main.eas](https://github.com/ethereum/sys-asm/blob/main/src/consolidations/main.eas).
The consolidations are put in a queue and dequeued at a rate of 2 per block.
The contract is not written in solidity, nor do they have a typical solidity ABI in order to not enshrine the API.

The functionality in pseudo code:

```pseudo
function(bytes input) {
    if input.length == 0 {
        return required_fee
    }
    if input.length == 96 {
        if msg.value < required_fee {
            return error
        }
        source := input[0:48]
        target := input[48:96]
        store_consolidation(msg.sender, source, target)
        emit event(msg.sender, source, target)
        return
     }
     return error
}
```

The input consists of 96 bytes containing both the BLS public key of the source and the target of the consolidation.
Both source and target must have 0x01 or 0x02 withdrawal credentials set.
The contract can be queried again with no input data to compute the required consolidation fee.
The funds will be consolidated from source to target.
The 7251 EIP contains an example on how to interact with the [contract from solidity](https://eips.ethereum.org/EIPS/eip-7251#fee-overpayment).

#### **Q:** How can I partially withdraw some ETH from my `0x02` validator?

You can issue a EL triggered partial withdrawal to withdraw some ETH from the `0x02` validator.
Send a transaction to the withdrawal system contract (pending address to be finalized when Electra goes live on mainnet) with your validator `pubkey` and the `amount` (a positive non-zero Gwei amount).
As with consolidations, this transaction must be sent from the withdrawal address set in your validator's withdrawal credentials.

We expect this functionality to be added to various tools in the coming months.
For testing right now, you can use the [Submit Withdrawals](https://dora.mekong.ethpandaops.io/validators/submit_withdrawals) page in Dora. Connect with the wallet that is used as the withdrawal address for your validators, and you should be able to select between your validators and craft an appropriate withdrawal transaction.

#### **Q:** How much ETH can I withdraw from my validator?

You can partially withdraw the portion above the full validator amount, as long as the validator contains >32 ETH at the time of withdrawal completion. For example, if you currently have 34 ETH and request a partial withdrawal, a maximum of 2 ETH can be withdrawn.
You may also decide to request a full withdrawal by specifying an amount of `0` in the request. When sending such a full withdrawal request, your validator will be exited, and the full balance withdrawn.

#### **Q:** Whats the ABI of the withdrawal system contract?

The EIP-7002 contract is deployed here `0x00000961Ef480Eb55e80D19ad83579A64c00700` source here: [ethereum/sys-asm/src/withdrawals/main.eas](https://github.com/ethereum/sys-asm/blob/main/src/withdrawals/main.eas).
The withdrawals are put in a queue and at maximum 16 are dequeued per block.
The contract is not written in solidity, nor do they have a typical solidity ABI in order to not enshrine the API.
The functionality of the withdrawal contract in pseudo code:

```pseudo
function(bytes input) {
    if input.length == 0 {
        return required_fee
    }
    if input.length == 56 {
        if msg.value < required_fee {
            return error
        }
        pk := input[0:48]
        amount := input[48:56]
        store_withdrawal(msg.sender, pk, amount)
        emit event(msg.sender, pk, amount)
        return
    }
    return error
}
```

As you can see the input consists of 56 bytes containing the BLS public key that we want to withdraw from as well as the amount we would like to withdraw.
You can call the contract with no input data to query the fee required to withdraw.
An example of how to interact with it from solidity can be found [here](https://eips.ethereum.org/EIPS/eip-7002#fee-overpayment).

#### **Q:** What happens to the ETH balance if my validator has `0x02` credentials and goes below 32 ETH?

A normally behaved validator will not have its balance dropped below 32ETH even if you initiate a partial withdrawal request. This can only be achieved if validator receives penalty. Nothing will happen except reduced rewards. However if balance drops below 16ETH, the validator will be exited and the balance will be transferred to the execution layer withdrawal address.

#### **Q:** What happens to the ETH balance if my validator has `0x02` credentials and goes above 2048 ETH?

The balance will continue to collect at the validator until the next partial withdrawal is triggered. The validator will however contain a maximum effective balance of 2048 ETH, the remaining balance will be considered ineffective in the beacon chain.

#### **Q:** What balances between 32ETH and 2048ETH can I earn on?

The effective balance increments 1 ETH at a time. This means the accrued balance needs to meet a threshold before the effective balance changes. E.g, if the accrued balance is 33.74 ETH, the effective balance will be 33 ETH. If the accrued balance increases to 33.75 ETH, then the effective balance will also be 33 ETH. Consequently, an accrued balance of 34.25 ETH would correspond to an effective balance of 34 ETH.

#### **Q:** Can I top up ETH in my `0x02` validator?

You can either consolidate a validator into the `0x02` validator to increase its balance or make a fresh deposit.

#### **Q:** What happens to the ETH balance if I consolidate and my validator has `0x02` credentials and the total balance goes above 2048 ETH?

The balance will continue to collect at the validator until the next partial withdrawal is triggered. The validator will however contain a maximum effective balance of 2048 ETH, the remaining balance will be considered ineffective in the beacon chain. The portion over 2048ETH will be withdrawn when partial withdrawal sweep comes.
