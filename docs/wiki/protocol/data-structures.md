# Data Structures in Ethereum

<br />

## Primer on Merkle Tree

Merkle tree is a hash-based data structure which is very effecient at data integrity and verification. It is a tree based structure where the leaf nodes hold the data values and each non-leaf node is a hash of its child nodes.

![Merkle Tree](../../images/merkle-tree.jpg)
<br />

## Primer on Patricia Tree

Patricia Tries(also called Radix tree) are n-ary trees which unlike Merkel Trees,is used for storage of data instead of verification.

Simply put, Patricia Tries is a tree data structure where all the data is store in the leaf nodes, and each non-leaf nodes is a character of a unique string identifying the data. Using the unique string we navigate through the character nodes and finally reach the data.
Hence, it is very efficient at data retrieval.

##### **TODO: Patricia Tree Diagram**

<br />

# Ethereum

Ethereum's primary data structure is a **Merkle Patricia Trie** (pronounced "try"). It is named so, since it is a Merkle tree that uses features of PATRICIA (Practical Algorithm To Retrieve Information Coded in Alphanumeric), and because it is designed for efficient data retrieval of items that comprise the Ethereum state.

Ethereum state is stored in four different modified merkle patricia tries (MMPTs):

- Transaction Trie
- Receipt Trie
- World State Trie
- Storage Trie

The main parent node is called Root, hence the hash inside is Root Hash. There is no way to create two different states with the same root hash, and any attempt to modify state with different values will result in a different state root hash.

At each block there is one transaction, receipt, and state trie which are referenced by their root hashes in the block Header.
For every contract deployed on Ethereum there is a storage trie used to hold that contract's persistent variables, each storage trie is referenced by their root hash in the state account object stored in the state trie leaf node corresponding to that contract's address.

##### TODO: Explain Transaction Trie

##### TODO: Explain Receipt Trie

##### TODO: Explain World State Trie

##### TODO: Explain Storage Trie

<br />

## Future Implementations

<br />

##### TODO: Primer on Verkle Tree

<br />

## Resources

[More on Merkle Patricia Trie](https://ethereum.org/developers/docs/data-structures-and-encoding/patricia-merkle-trie)
