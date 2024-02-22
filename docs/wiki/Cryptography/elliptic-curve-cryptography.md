# A Brief Introduction to Elliptic Curve Cryptography

Cryptography can often seem like an abstract and theoretical field, but its applications are deeply woven into the fabric of our everyday lives. Let's consider a real-world scenario to understand how cryptography, specifically Elliptic Curve Cryptography (ECC), can be used to safeguard critical interactions.

Alice, a diligent businesswoman, has been abducted and held captive on a remote island. Her captors demand a hefty ransom of $1 million for her release. With limited options for communication, they provide a single postcard for her to instruct her associate, Bob, to transfer the funds.

Alice considers writing the ransom amount and signing the postcard like a check. However, this method poses a significant risk: the kidnappers could easily forge the postcard, inflate the amount, and deceive Bob into sending them more money.

Alice needs a robust mechanism that allows:

1. Bob to verify that the transfer has be authorized by her, and
2. ensure that postcard's message has not been tampered with.

Mathematics, as always, comes to the rescue. With a little help of **Elliptic Curves** Alice could cryptographically sign the contents of the message addressing both requirements.

# Elliptic Curves

An elliptic curve is a curve **described by the equation**:

$$
y^2 = x^3 + ax+b
$$

Here is what an elliptic curve looks like for the equation $y^2 = x^3 +2x +3$ (i.e $a=2$ and $b=3$):

<iframe src="https://www.desmos.com/calculator/rlm2bda0dz?embed" width="500" height="500" style="border: 1px solid #ccc" frameborder=0></iframe>

Ethereum uses a standard curve known as [secp256k1](http://www.secg.org/sec2-v2.pdf) with parameters $a=0$, and $b=7$; which is the curve:
$$y^2=x^3+7$$

<iframe src="https://www.desmos.com/calculator/4yfo6djcyb?embed" width="500" height="500" style="border: 1px solid #ccc" frameborder=0></iframe>
