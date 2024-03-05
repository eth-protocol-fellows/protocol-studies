# The Ethereum Virtual Machine (EVM)

You have likely observed that Ethereum transactions take some time to finalise, [around 12 seconds](https://web.archive.org/web/20240304145956/https://etherscan.io/chart/blocktime) at the time of writing. A series of crucial steps occur during this timeframe. The transaction is first queued in a pool. Then, it is selected by a node and executed by a special program - **the Ethereum Virtual Machine (EVM)**, the result of which is stored on the blockchain.

This article describes the role of EVM in ethereum ecosystem and how it works. As the EVM executes transactions, it modifies the overall state of ethereum. In that regard, ethereum can be modeled as a **state machine**.

## The Ethereum state machine

In computer science, **state machine** is an abstraction used to model the behavior of a system. It illustrates how a system can be represented by a set of distinct states and how inputs can drive changes in the state.

A familiar example of a state machine is the vending machine, an automated system dispensing products upon receiving payment.

We can model the vending machine existing in three distinct states: idle, awaiting user selection, and dispensing a product. Inputs such as coin insertion or product selection trigger transitions between these states, as depicted in the state diagram:

<img src="images/evm/vending-machine.gif" width="800" alt="Vending machine"/>

Let's formally define the components of a state machine:

1. **State ($S$)**: A State represents distinct conditions or configurations that a system can be in at a given point in time.
   For the vending machine, possible states are:

$$ S\in \set {Idle, Selection, Dispensing} $$

2. **Inputs ($I$)**: Inputs are actions, signals, or changes in the system's environment. Input triggers the **state transition function**.
   For the vending machine, possible inputs include:

$$ I\in \set {InsertCoin, SelectDrink, CollectDrink} $$

3. **State transition function ($\Upsilon$)**: State transition function defines how the system transitions from one state to another (or back to the same state) based on an input and its current state. Essentially, it determines how the system evolves in response to inputs.

$$\Upsilon (S,I) \Longrightarrow S'  $$

> Where S' = next state, S= current state and, I= input.

Example state transition for the vending machine:

$$\Upsilon (Idle,InsertCoin) \Longrightarrow Selection $$
$$\Upsilon (Selection,SelectDrink) \Longrightarrow Dispensing $$
$$\Upsilon (Idle,SelectDrink) \Longrightarrow Idle $$

Notice in the last case, the current state transitions back to itself.

### Ethereum as a state machine

Ethereum, as a whole, can be viewed as a **transaction-based state machine**. It receives transactions as inputs and transitions into a new state. The current state of Ethereum is referred to as the **world state**.

Let's consider a simple Ethereum application - an NFT marketplace.

In the current world state **S3** (green), Alice owns an NFT. The animation below shows a transaction transferring ownership to you (**S3** ➡️ **S4**). Similarly, selling the NFT back to Alice would transition the state to **S5**:

<img src="images/evm/ethereum-state-machine.gif" width="800" alt="Ethereum state machine"/>

Notice that the world state is animated _as a pulsating green bubble_.

In the model above, each transaction is committed to a new state. However, in reality, a group of transactions is bundled into a **block**, and the resulting state is added to the chain of previous states. It must be apparent now why this technology is called **blockchain**.

Considering the definition of the state transition function, we draw the following conclusion:

> **EVM is the state transition function of the Ethereum state machine. It determines how Ethereum transitions into a new (world) state based on input (transactions) and current state.**

## Virtual machine paradigm

Given our grasp of state machines, the next challenge is **implementation**.

Software needs conversion to the target processor's machine language (Instruction Set Architecture, ISA) for execution. This ISA varies across hardware (e.g., Intel vs. Apple silicon). Modern software also relies on the host operating system for memory management and other essentials.

Ensuring functionality within a fragmented ecosystem of diverse hardware and operating systems is a major hurdle. Traditionally, software had to be compiled into native binaries for each specific target platform:

<img src="images/evm/platform-dependent-execution.jpg" width="800" alt="Platform dependent execution" />

To address this challenge, a two-part solution is employed.

First, the implementation targets a **virtual machine**, an abstraction layer. Source code is compiled into **bytecode**, a sequence of bytes representing instructions. Each bytecode maps to a specific operation the virtual machine executes.

The second part involves a platform-specific virtual machine that translates the bytecode into native code for execution.

This offers two key benefits: portability (bytecode runs on different platforms without recompiling) and abstraction (separates hardware complexities from software). Developers can thus write code for a single, virtual machine:

<img src="images/evm/virtual-machine-paradigm.jpg" width="800" alt="Virtual machine paradigm" />

## EVM and the world state

This virtual machine concept serves as an abstraction. Ethereum Virtual Machine (EVM) is a specific software implementation of this abstraction:

<img src="images/evm/evm-anatomy.jpg" width="800" alt="EVM anatomy" />

For clarity, the figure above simplifies the Ethereum state. The actual state includes additional elements like Message Frames and Transient Storage.

## Stack

## Memory

## Storage

## Transaction

## Wrapping up

## Resources
