# A brief introduction to formal verification

## Mathematics and the art of abstraction

Imagine that you are in charge of organizing this year's office party. It has been decided that a group of 5 people will share a crate of beer. It is a generous party. There are 83 people at the office. How many crates should you order?

Scribbling some quick arithmetic: $\frac{83}/{5} = 16.6$ Rounding up we get 17 crates of beer.

Let's step back and absorb how got the answer.

We started with a question. "How many crates of beer should be ordered between a certain number of people given certain condition?"

The number `83` is an "abstraction" for the number of total people number at the office.

"Abstraction" is an interesting concept. It originates from the latin word `abstrahō`, meaning "[to] draw away" or "separate". Abstraction is the _art_ of selectively separating relevant pieces of information for a given purpose. We abstracted all the people to a simple number: 83. We ignored everything else about them, their designation, education, favorite sports team because it _just wasn't relevant_ in this case.

Similarly, the number `5` is an abstraction for a group; and the answer `16.6` abstractly represents the total crates of beer required, which we rounded up to `17` because we wanted to order whole crates. That we quickly do these abstractions and interpret the result effortlessly in our minds doesn't take away from the fact that abstraction is a powerful tool.

Our algorithm can be outlined as:

1. For a given problem, abstract away the input.
2. Use a mathematical model to find solution.
3. Interpret the solution back.

This is a fundamental theme in problem solving. Computers do this too. The words on your screen is abstractly [represented in binary on a computer](https://en.wikipedia.org/wiki/ASCII) for transmission and storage.

> Mathematics is the language of precision. Abstraction allows us to precisely define the input focused only on relevant information, for a given problem. The result of which can be mathematically solved and interpreted as required.

## Formal verification

Formal verification, like the previous example, helps find the answer to a simple question: "Does a system correctly meet its required specifications?"

> Formal verification is a verification technique that abstracts a system as a mathematical model and proves or disproves its correctness.

A "system" is defined as a mechanism that is able to execute all of the functions given by its external interface. "Invariants" are properties that remains unchanged for a system, regardless of its current state. For example, an invariant of a vending machine is: Nobody should be able to dispense a product for free.

Formal verification tests the correctness of a system by checking if all its invariants holds true.
