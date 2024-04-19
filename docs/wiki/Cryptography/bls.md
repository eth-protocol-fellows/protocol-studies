<!-- @format -->

# Boneh-Lynn-Shacham (BLS) signature

BLS is a digital signature scheme with aggregation properties. Given set of signatures (_signature_1_, ..., _signature_n_) anyone can produce an aggregated signature. Aggregation can also be done on secret keys and public keys. Furthermore, the BLS signature scheme is deterministic, non-malleable, and efficient. Its simplicity and cryptographic properties allows it to be useful in a variety of use-cases, specifically when minimal storage space or bandwidth are required. This page will cover general idea of BLS signatures with Ethereum in mind for essential examples.

With respect to Blockchain, digital signatures typically leverage elliptic curve groups. Ethereum primarily employs [ECDSA](/wiki/Cryptography/ecdsa.md) signatures using the [secp256k1](https://en.bitcoin.it/wiki/Secp256k1) curve, while the beacon chain protocol adopts BLS signatures based on the [BLS12-381](https://hackmd.io/@benjaminion/bls12-381) curve. Unlike ECDSA, BLS signatures utilize a unique feature of certain elliptic curves known as "[pairing](https://medium.com/@VitalikButerin/exploring-elliptic-curve-pairings-c73c1864e627)." This allows for the aggregation of multiple signatures, enhancing the efficiency of the consensus protocol. While ECDSA signatures are [much quicker](https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-bls-signature-04#section-1.1) to process, the aggregative capability of BLS signatures offers significant advantages for blockchain scalability and consensus efficiency.

The process to create and verify a BLS signature is straightforward, involving a series of steps that can be explained through diagrams, descriptions, and mathematical principles, although understanding the mathematical detail is not essential for practical application.

## Components

There are **4** component pieces of data within the BLS digital signature process.

- **The secret key:** Every participant in the protocol, specifically a validator, possesses a secret key, also referred to as a private key. This key is crucial for signing messages and maintaining the confidentiality of the validator's actions within the network.
- **The public key:** Derived directly from the secret key using cryptographic methods, the public key, while linked to the secret key, cannot be reverse-engineered from it without extreme computational effort. It serves as the public identity of the validator within the protocol and is accessible to all participants.
- **The message:** In Ethereum, messages consist of byte strings whose structure and purpose will be explored in further detail later in the context. Initially, understand these messages as basic data units processed within the blockchain protocol.
- **The signature:** The signature is the result of the cryptographic process where the message is combined with the secret key. This signature uniquely identifies that a message was authored by the holder of the secret key. By verifying the signature with the corresponding public key, one can confirm that the message originated from a specific validator and has not been altered post-signing.

In Mathematical terms, We use 2 subgroups of BLS12-381 elliptic curve: $G_1$ defined over a base field $F_q$, and $G_2$ defined over the field extension $F_{q^2}$. The order of both the subgroups is $r$, a 77 digit prime number. The (arbitrarily chosen) generator of $G_1$ is $g_1$, and of $G_2$ is $g_2$.

1. The secret key, $sk$, is a number between $1$ and $r$ (technically the range includes $1$, but not $r$. However, very small values of $sk$ would be hopelessly insecure).
2. The public key, $pk$, is $[sk]g_1$ where the square brackets represent scalar multiplication of the elliptic curve group point. The public key is therefore a member of the $G_1$ group.
3. The message, $m$ is a sequence of bytes. During the signing process this will be mapped to some point $H(m)$ that is a member of the $G_2$ group.
4. The signature, $\sigma$, is also a member of the $G_2$ group, namely $[sk]H(m)$.

<figure class="diagram" style="margin-left:5%; width:80%">

![Diagram showing how we will depict the various components in the diagrams below.](../../images/elliptic-curves/bls-key.svg)

<figcaption>

_The key to the keys. This is how we will depict the various components in the diagrams below. Variants of the same object are hatched differently. The secret key is mathematically a scalar; public keys are $G_1$ group members; message roots are mapped to $G_2$ group members; and signatures are $G_2$ group members._

</figcaption>
</figure>

##### Key pairs

A key pair is a secret key along with its public key. Together these irrefutably link each validator with its actions.

Every validator on the beacon chain has at least one key pair, the "signing key" that is used in daily operations (making attestations, producing blocks, etc.). Depending on which version of [withdrawal credentials](/part3/config/constants/#withdrawal-prefixes) the validator is using, it may also have a second BLS key pair, the "withdrawal key", that is kept offline.

The secret key is supposed to be uniformly randomly generated in the range $[1,r)$. [EIP-2333](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-2333.md) defines a standard way to do this based on the [`KeyGen`](https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-bls-signature-04#section-2.3) method of the draft IRTF BLS signatures standard. It's not compulsory to use this method &ndash; no-one will ever know if you don't &ndash; but you'd be ill-advised not to. In practice, many stakers generate their keys with the [`eth2.0-deposit-cli`](https://github.com/ethereum/eth2.0-deposit-cli) tool created by the Ethereum Foundation. Operationally, key pairs are often stored in password-protected [EIP-2335](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-2335.md) keystore files.

The secret key, $sk$ is a 32 byte unsigned integer. The public key, $pk$, is a point on the $G_1$ curve, which is represented in-protocol in its [compressed](https://hackmd.io/@benjaminion/bls12-381#Point-compression) serialised form as a string of 48 bytes.

<a id="img_bls_setup"></a>

<figure class="diagram" style="width:50%">

![Diagram of the generation of the public key.](images/diagrams/bls-setup.svg)

<figcaption>

A validator randomly generates its secret key. Its public key is then derived from that.

</figcaption>
</figure>

##### Signing

In the beacon chain protocol the only messages that get signed are [hash tree roots](/part2/building_blocks/merkleization/) of objects: their so-called signing roots, which are 32 byte strings. The [`compute_signing_root()`](/part3/helper/misc/#compute_signing_root) function always combines the hash tree root of an object with a "domain" as described [below](#domain-separation-and-forks).

Once we have the signing root it needs to be mapped onto an elliptic curve point in the $G_2$ group. If the message's signing root is $m$, then the point is $H(m)$ where $H()$ is a function that maps bytes to $G_2$. This mapping is hard to do well, and an entire [draft standard](https://datatracker.ietf.org/doc/draft-irtf-cfrg-hash-to-curve/) exists to define the process. Thankfully, we can ignore the details completely and leave them to our cryptographic libraries[^fn-implement-h2g2].

[^fn-implement-h2g2]: Unless you have to implement the thing, as I [ended up doing](https://github.com/ConsenSys/teku/commit/e927d9be89b64fe8297b74405f37aa0e6378024) in Java.

Now that we have $H(m)$, the signing process itself is simple, being just a scalar multiplication of the $G_2$ point by the secret key:

$$
\sigma = [sk]H(m)
$$

Evidently the signature $\sigma$ is also a member of the $G_2$ group, and it serialises to a 96 byte string in compressed form.

<a id="img_bls_signing"></a>

<figure class="diagram" style="width:65%">

![Diagram of signing a message.](images/diagrams/bls-signing.svg)

<figcaption>

A validator applies its secret key to a message to generate a unique digital signature.

</figcaption>
</figure>

##### Verifying

To verify a signature we need to know the public key of the validator that signed it. Every validator's public key is stored in the beacon state and can be simply looked up via the validator's index which, by design, is always available by some means whenever it's required.

Signature verification can be treated as a black-box: we send the message, the public key, and the signature to the verifier; if after some cryptographic magic the signature matches the public key and the message then we declare it valid. Otherwise, either the signature is corrupt, the incorrect secret key was used, or the message is not what was signed.

More formally, signatures are verified using elliptic curve pairings.

With respect to the curve BLS12-381, a pairing simply takes a point $P\in G_1$, and a point $Q\in G_2$ and outputs a point from a group $G_T\subset F_{q^{12}}$. That is, for a pairing $e$, $e:G_1\times G_2\rightarrow G_T$.[^fn-pairing-multiplication]

[^fn-pairing-multiplication]: If it helps, you can loosely think of a pairing as being a way to "multiply" a point in $G_1$ by a point in $G_2$. If we were to write all the groups additively then the arithmetic would work out very nicely. However, we conventionally write $G_T$ multiplicatively, so the notation isn't quite right.

Pairings are usually denoted $e(P,Q)$ and have special properties. In particular, with $P$ and $S$ in $G_1$ and $Q$ and $R$ in $G_2$,

- $e(P, Q + R) = e(P, Q) \cdot e(P, R)$, and
- $e(P + S, R) = e(P, R) \cdot e(S, R)$.

(Conventionally $G_1$ and $G_2$ are written as additive groups, and $G_T$ as multiplicative, so the $\cdot$ operator is point multiplication in $G_T$.)

From this, we can deduce that all the following identities hold:

$$
e([a]P,[b]Q)={e(P,[b]Q)}^a={e(P,Q)}^{ab}={e(P,[a]Q)}^b=e([b]P,[a]Q)
$$

Armed with our pairing, verifying a signature is straightforward. The signature is valid if and only if

$$
e(g_1,\sigma)=e(pk,H(m))
$$

That is, given the message $m$, the public key $pk$, the signature $\sigma$, and the fixed public value $g_1$ (the generator of the $G_1$ group), we can verify that the message was signed by the secret key $sk$.

This identity comes directly from the properties of pairings described above.

$$
e(pk,H(m)) = e([sk]g_1,H(m)) = {e(g_1,H(m))}^{(sk)} = e(g_1,[sk]H(m)) = e(g_1,\sigma)
$$

Note that elliptic curves supporting such a pairing function are very rare. Such curves can be constructed, as [BLS12-381 was](https://hackmd.io/@benjaminion/bls12-381#History), but general elliptic curves such as the more commonly used secp256k1 curve do not support pairings and cannot be used for BLS signatures.

<a id="img_bls_verifying"></a>

<figure class="diagram" style="width:80%">

![Diagram of verifying a signature.](images/diagrams/bls-verifying.svg)

<figcaption>

To verify that a particular validator signed a particular message we use the validator's public key, the original message, and the signature. The verification operation outputs true if the signature is correct and false otherwise.

</figcaption>
</figure>

The verification will return `True` if and only if the signature corresponds both to the public key (that is, the signature and the public key were both generated from the same secret key) and to the message (that is, the message is identical to the one that was signed originally). Otherwise, it will return `False`.

- Proof of stake protocols use digital signatures to identify their participants and hold them accountable.
- BLS signatures can be aggregated together, making them efficient to verify at large scale.
- Signature aggregation allows the beacon chain to scale to hundreds of thousands of validators.
- Ethereum transaction signatures on the execution (Eth1) layer remain as-is.
