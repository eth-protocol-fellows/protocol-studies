# KZG Polynomial Commitment Scheme

## [TLDR]
The KZG commitment scheme is like a cryptographic vault for securely locking away polynomials (mathematical equations) so that you can later prove you have them without giving away their secrets. It's like making a sealed promise that you can validate without ever having to open it up and show the contents. Using advanced math based on elliptic curves, it enables efficient, verifiable commitments that are a key part of making blockchain transactions more private and scalable. This scheme is especially important for Ethereum's upgrades, where it helps to verify transactions quickly and securely without compromising on privacy.

## [Motivation]

### [ZKSNARKs]
Learning about Polynomial Commitment Schemes (PCS) is important because they play a key role in creating Zero-Knowledge Succinct Non-Interactive Arguments of Knowledge (ZKSNARKs). ZKSNARKs are special cryptographic methods that allow someone (the prover) to show to someone else (the verifier) that they know a specific piece of information (like a number) without revealing that information. This is done by using PCS and Interactive Oracle Proofs (IOP) together.

*Modern ZKSNARK = Functional Commitment Scheme + Compatible Interactive Oracle Proof (IOP)*

PCS is a way to prove that you know a secret function (represented by a polynomial) without showing the function itself. It's like promising to show a secret recipe to someone, but you only show them the final dish without revealing the recipe. This is crucial for ZKSNARKs because it allows the prover to prove they know a secret function without revealing it.

IOP is another method that helps in proving that you know a secret value without revealing it. It's used along with PCS to make a ZKSNARK. The IOP helps in proving the knowledge, while PCS makes the proof short and easy to check. This combination allows for creating efficient ZKSNARKs that can be used in many areas, like blockchain and privacy-preserving computations.

To make ZKSNARKs, you need to choose a PCS and IOP that work well together. The PCS is used to commit to a polynomial and prove the evaluation of the polynomial at a certain point without revealing the polynomial. The IOP is used to create a proof of knowledge, which is then turned into a non-interactive proof using a method called the Fiat-Shamir heuristic. This makes it possible to generate and verify the proof without needing to communicate in real-time, making ZKSNARKs useful for blockchain and distributed systems.

### [Ethereum Danksharding]
KZG commitment scheme has emerged as a pivotal technology in the Ethereum ecosystem, particularly in the context of Proto-Danksharding and its anticipated evolution into Danksharding. This commitment scheme is a cornerstone of many Zero-Knowledge (ZK) related applications within Ethereum, enabling efficient and secure verification of data without revealing the underlying information.

The adoption of KZG commitments in Proto-Danksharding and its future application in Danksharding represents a significant step towards Ethereum's full sharding implementation. Sharding is a long-term scaling solution for Ethereum, aiming to improve the network's scalability and capacity by dividing the network into smaller, more manageable pieces. The KZG commitment scheme plays a vital role in this process by facilitating the efficient verification of data across shards, thereby enhancing the overall security and performance of the Ethereum network.

Moreover, the KZG commitment scheme is not only limited to Ethereum but has broader applications in the blockchain and cryptographic communities. Its ability to commit to a polynomial and verify evaluations of the polynomial without revealing the polynomial itself makes it a versatile tool for various cryptographic protocols and applications. 


## [Goal]
Now that we are motivated to learn PCS, let us get started with defining what is our goal i.e. what is the exact problem we want to solve with KZG scheme. 

Say we have a function or polynomial $f(x)$ defined as $f(x) = f_0 + f_1x + f_2x^2 + \ldots + f_dx^t$.

Our main goal with KZG scheme is that we want to prove to someone that we know this polynomial without revealing the polynomial. What do we mean by without revealing by polynomial? We meant that without revealing the coefficients of the polynomial. 

In practice what we exactly do is that we prove that we know a specific evaluation of this polynomial at a point $x=a$. 

We write this, $f(a)$, for some $x=a$. 

## [What we need to know before we discuss KZG]

There are some important concepts we need to know before we can move further to understand KZG scheme. Fortunately, we can get an Engineering level understanding of the KZG scheme from just enough high school mathematics. We will try to gain some intuition on advanced concepts and their important properties without knowing them intimately. This can help us see the KZG protocol flow without bogged down by the advanced mathematics.

We need to know:

### [Modular Arithmetic]
- Can you read a clock? Can you add/subtract two time values? In general can you do clock arithmetic? This is called Modular arithmetic. We know only need to know how to add, subtract, multiply or divide numbers and apply modulus operation (the clock scale). 
- We usually write this mod $p$ to mean modulo $p$, where $p$ is some number. 

### [Finite Field of order prime $p$, $\mathbb F_p$]

A finite field of order prime $p$, we denote it by $\mathbb F_p$, is a special set of numbers where you can do all the usual math operations (addition, subtraction, multiplication, and division, except by zero) and still follow the rules of arithmetic. 

The "order" of this set is the number of elements it contains, and for a finite field of order prime $p$, this number is a prime number. The most common way to create a $\mathbb F_p$ is by taking the set of all integers greathan or equal to $0$ and dividing them by $p$, keeping only the remainders. This gives us a set of numbers from $0$ to $p-1$ that can be used for arithmetic operations. For example, if $p = 5$, the set would be {0, 1, 2, 3, 4}, and you can add, subtract, multiply, and divide these numbers in a way that follows the rules of arithmetic. This set is a finite field of order 5, we denote this by $\mathbb F_5$, because it has exactly 5 elements, and it's a prime number.

When we do modular arithmetic operations in the finite field $\mathbb F_p$, we have a nice "wrap around" property i.e. the field behaves as if it "wraps around" after reaching $(p - 1)$. 

In genral, when we define a finite field, we define, the order $p$ of the field and an arithemetic operation like addition or multiplication. If it is addition, we denote the field by $(\mathbb F_p, +)$. If it is multiplication, we denote it by $(\mathbb F^*_p, +)$. The `*` is telling us to exclude the zero element from our field so that we can satisfy all the required properties of the finite field i.e. mainly we can divide the numbers and find inverse of all elements. If we include the zero element, we can't find the inverse of zero element.

### [Multiplicative Group ($\mathbb G^*, .)$]
The group is a similar to finite field with some small changes. In a Group, we only have arithmetic operation on the set, usually addition or multiplication as opposed to in a finite field we have addition and multiplication both. We denote a Group by ($\mathbb G, +)$ for a Group with addition as the group operation, ($\mathbb G^*, .)$ for Group with multiplication operation; the `*` is telling to exclude zero element to avoid division by zero.

### [Generator of a Group]


### [Why choosing a prime number for modulo operations in finite fields]

### [Cryptographic Assumptions needed for KZG Scheme]

**Discrete Logarithm**

**String Diffie-Hellman**

### [Pairing Function]

## [Important properties of Commitments]

Let $F(x) = f_0 + f_1x + f_2x^2 + \ldots + f_dx^d$

$F(a) = f_0 + f_1a + f_2a^2 + \ldots + f_da^d$

So $C_F = F(a) \cdot G = (f_0 + f_1a + f_2a^2 + \ldots + f_da^d) \cdot G$

$C_F = f_0 \cdot G + f_1a \cdot G + f_2a^2 \cdot G + \ldots + f_da^d \cdot G$

### [Binding Property]

### [Hiding Property]


## [KZG Protocol Flow]

### [Initial Configuration]

### [Trusted Setup]

### [Commitment of the polynomial]

### [Opening]

### [Verification]

## [KZG by Hands]

### KZG by Hands - [Initial Configuration]

### [KZG by Hands - Trusted Setup]

### [KZG by Hands - Commitment of the polynomial]

### [KZG by Hands - Opening]

### [KZG by Hands - Verification]

## [Security of KZG - Deleting the toxic waste]

## [Implementing KZG in Sagemath]

## [KZG using Assymetic Pairing Fuctions]

## [KZG Batch Mode Single Polynomial, multiple points]

## [KZG Batch Mode Multiple Polynomials, same point]

## [KZG Batch Mode Multiple Polynomials, multiple points]





