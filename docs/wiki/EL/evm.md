# The Ethereum Virtual Machine (EVM)

You have likely observed that Ethereum transactions take some time to finalise, around 13 seconds at the time of writing. A series of crucial steps occur during this timeframe. The transaction is first queued in a pool. Then, it is selected by a node and executed by a special program - **the Ethereum Virtual Machine (EVM)**, the result of which is stored on the blockchain.

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

## Virtual machine paradigm

## Stack

## Memory

## Storage

## Transaction

## Wrapping up

## Resources
