# Simple Serialize (SSZ)

## Overview

Simple Serialize (SSZ) is a serialization and Merkleization scheme designed specifically for Ethereum's Beacon Chain. SSZ replaces the [RLP serialization](/docs/wiki/EL/RLP.md) used on the execution layer (EL) everywhere across the consensus layer (CL) except the [peer discovery protocol](https://github.com/ethereum/devp2p). Its development and adoption are aimed at enhancing the efficiency, security, and scalability of Ethereum's CL.

## How SSZ Works - Basic Types

Here’s how SSZ handles the serialization and deserialization of the basic types:

```mermaid
flowchart TD
    A[Start Serialization] --> B[Choose Data Type]
    B --> C[Unsigned Integer]
    B --> D[Boolean]
    
    C --> E[Convert Integer to \nLittle-Endian Byte Array]
    E --> F[Serialized Output for Integer]
    
    D --> G["Convert Boolean to Byte \n(True to 0x01, False to 0x00)"]
    G --> H[Serialized Output for Boolean]
    
    classDef startEnd fill:#f9f,stroke:#333,stroke-width:4px;
    class A startEnd;
    classDef process fill:#ccf,stroke:#f66,stroke-width:2px;
    class B,C,D,E,G process;
    classDef output fill:#cfc,stroke:#393,stroke-width:2px;
    class F,H output;
```

_Figure: Serialization Process for Basic Types._


```mermaid
flowchart TD
    A[Start Deserialization] --> B[Determine Data Type]
    B --> C[Unsigned Integer]
    B --> D[Boolean]
    
    C --> E[Read Little-Endian Byte Array]
    E --> F[Reconstruct Original Integer Value]
    F --> G[Deserialized Integer Output]
    
    D --> H[Read Byte]
    H --> I["Translate Byte to Boolean \n(0x01 to True, 0x00 to False)"]
    I --> J[Deserialized Boolean Output]
    
    classDef startEnd fill:#f9f,stroke:#333,stroke-width:4px;
    class A startEnd;
    classDef process fill:#ccf,stroke:#f66,stroke-width:2px;
    class B,C,D,E,H,I process;
    classDef output fill:#cfc,stroke:#393,stroke-width:2px;
    class G,J output;
```

_Figure: Deserialization Process for Basic Types._

### Unsigned Integers

Unsigned integers (`uintN`) in SSZ are denoted where `N` can be any of 8, 16, 32, 64, 128, or 256 bits. These integers are serialized directly to their little-endian byte representation, which is a form well-suited for most modern computer architectures and facilitates easier manipulation at the byte level.

**Serialization Process for Unsigned Integers:**

1. **Input**: Take an unsigned integer of type `uintN`.
2. **Convert to Bytes**: Convert the integer into a byte array of length `N/8`. For instance, `uint16` represents 2 bytes.
3. **Apply Little-Endian Format**: Arrange the bytes in little-endian order, where the least significant byte is stored first.
4. **Output**: The resulting byte array is the serialized form of the integer.

**Example:**
- Integer `1025` as `uint16` would be serialized to `01 04` in hexadecimal. First, convert `1025` to hex which gives `0x0401`. In little-endian format, the least significant byte (LSB) comes first. So, `0x0401` in little-endian is `01 04`. The byte array `[01, 04]` is the serialized output.

**Deserialization Process for Unsigned Integers:**

1. **Input**: Read the byte array representing a serialized `uintN`.
2. **Read Little-Endian Bytes**: Interpret the bytes in little-endian order to reconstruct the integer value.
3. **Output**: Convert the byte array back into the integer.

**Example:**
- Byte array `01 04` (in hex) is deserialized to the integer `1025`. Read the first byte `01` as the lower part and `04` as the higher part of the integer. It translates back to `0401` in hex when reassembled in big-endian format for human readability, which equals 1025 in decimal.

### Booleans

Booleans in SSZ are quite straightforward, with each boolean represented as a single byte.

**Serialization Process for Booleans:**

1. **Input**: Take a boolean value (`True` or `False`).
2. **Convert to Byte**: 
   - If the boolean is `True`, serialize it as `01` (in hex).
   - If the boolean is `False`, serialize it as `00`.
3. **Output**: The resulting single byte is the serialized form of the boolean.

**Example:**
- `True` becomes `01`.
- `False` becomes `00`.

**Deserialization Process for Booleans:**

1. **Input**: Read a single byte.
2. **Interpret the Byte**: 
   - A byte of `01` indicates `True`.
   - A byte of `00` indicates `False`.
3. **Output**: The boolean value corresponding to the byte.

**Example:**
- Byte `01` is deserialized to `True`.
- Byte `00` is deserialized to `False`.

We can run SSZ serialization and deserialization commands using the python Eth2 spec as per the [instructions](https://eth2book.info/capella/appendices/running/) and verify the above byte arrays.

```python
>>> from eth2spec.utils.ssz.ssz_typing import uint64, boolean
# Serializing 
>>> uint64(1025).encode_bytes().hex()
'0104000000000000'
>>> boolean(True).encode_bytes().hex()
'01'
>>> boolean(False).encode_bytes().hex()
'00' 

# Deserializing 
>>> print(uint64.decode_bytes(bytes.fromhex('0104000000000000')))
1025
>>> print(boolean.decode_bytes(bytes.fromhex('01')))
1
>>> print(boolean.decode_bytes(bytes.fromhex('00')))
0
```

## How SSZ Works - Composite Types

### Vectors

Vectors in SSZ are used to handle fixed-length collections of homogeneous elements. Here’s a detailed breakdown of how SSZ handles the serialization and deserialization of vectors.

**SSZ Serialization for Vectors**

```mermaid
flowchart TD
    A[Start Serialization] --> B[Define Vector with Type and Length]
    B --> C[Serialize Each Element]
    C --> D["Convert Each Element to \nByte Array (Little-Endian)"]
    D --> E[Concatenate All Byte Arrays]
    E --> F[Output Serialized Vector]
    
    classDef startEnd fill:#f9f,stroke:#333,stroke-width:4px;
    class A startEnd;
    classDef process fill:#ccf,stroke:#f66,stroke-width:2px;
    class B,C,D,E process;
    classDef output fill:#cfc,stroke:#393,stroke-width:2px;
    class F output;
```

_Figure: SSZ Serialization for Vectors._


1. **Fixed-Length Definition**: Vectors are defined with a specific length and type of elements they can hold, such as `Vector[uint64, 4]` for a vector containing four 64-bit unsigned integers.

2. **Element Serialization**:
   - Each element in the vector is serialized independently according to its type. 
   - For basic types like integers or booleans, this means converting each element to its byte representation. 
   - If the elements are composite types, each element is serialized according to its specific serialization rules.

3. **Concatenation**:
   - The serialized outputs of each element are concatenated in the order they appear in the vector. 
   - Since the length of the vector and the size of each element are known and fixed, no additional metadata (like length prefixes) is needed in the serialized output.

**Example:**
For a `Vector[uint64, 3]` with the elements `[256, 512, 768]`, each element is 64 bits or 8 bytes long. The serialization would proceed as follows:

1. **Convert Each Integer to Little-Endian Byte Array**:
   - `256` as `uint64` becomes `00 01 00 00 00 00 00 00`.
   - `512` as `uint64` becomes `00 02 00 00 00 00 00 00`.
   - `768` as `uint64` becomes `00 03 00 00 00 00 00 00`.

2. **Concatenate These Byte Arrays**:
   - The resulting concatenated byte array will be `00 01 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00 00 00 00`.

**Serialized Output**:
   - `00 01 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00 00 00 00`.


**SSZ Deserialization for Vectors**

```mermaid
flowchart TD
    A[Start Deserialization] --> B[Receive Serialized Byte Stream]
    B --> C[Identify and Split Byte Stream \nBased on Element Size]
    C --> D[Deserialize Each Byte Segment\n to Its Original Type]
    D --> E[Reassemble Elements into Vector]
    E --> F[Output Deserialized Vector]
    
    classDef startEnd fill:#f9f,stroke:#333,stroke-width:4px;
    class A startEnd;
    classDef process fill:#ccf,stroke:#f66,stroke-width:2px;
    class B,C,D,E process;
    classDef output fill:#cfc,stroke:#393,stroke-width:2px;
    class F output;
```

_Figure: SSZ Deserialization for Vectors._


1. **Fixed-Length Utilization**:
   - The deserializer uses the predefined length and type of the vector to parse the serialized data.
   - It knows exactly how many bytes each element takes and how many elements are in the vector.

2. **Element Deserialization**:
   - The byte stream is split into segments corresponding to the size of each element.
   - Each segment is deserialized independently according to the type of elements in the vector.

3. **Reconstruction**:
   - The elements are reconstructed into their original form (e.g., converting byte arrays back into integers or other specified types).
   - These elements are then aggregated to reform the original vector.

**Example:**
Given the serialized data for a `Vector[uint64, 3]`:
- Serialized Byte Array: `00 01 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00 00 00 00`.

1. **Parse the Data into Segments**:
   - Each segment consists of 8 bytes.
   - First segment: `00 01 00 00 00 00 00 00` → Represents the integer 256.
   - Second segment: `00 02 00 00 00 00 00 00` → Represents the integer 512.
   - Third segment: `00 03 00 00 00 00 00 00` → Represents the integer 768.

2. **Convert Each Segment from a Little-Endian Byte Array Back to an Integer**:
   - Using little-endian format, each byte array is read and converted back into the respective `uint64` integer.

3. **Reconstruction**:
   - The reconstructed vector is `[256, 512, 768]`.

We can run and verify it in python like below:

```python
>>> from eth2spec.utils.ssz.ssz_typing import uint8, uint16, Vector
>>> Vector[uint16, 3](256, 512, 768).encode_bytes().hex()
'000100000000000000020000000000000003000000000000'
>>> print(Vector[uint64, 3].decode_bytes(bytes.fromhex('000100000000000000020000000000000003000000000000')))
Vector[uint64, 3]<<len=3>>(256, 512, 768)
>>> 

```


## Fixed VS Variable Length Types


## SSZ Tools

## Resources
- [Simple serialize](https://ethereum.org/en/developers/docs/data-structures-and-encoding/ssz/)
- [SSZ specs](https://github.com/ethereum/consensus-specs/blob/dev/ssz/simple-serialize.md)
- [eth2book - SSZ](https://eth2book.info/capella/part2/building_blocks/ssz/#ssz-simple-serialize)
- [Go Lessons from Writing a Serialization Library for Ethereum](https://rauljordan.com/go-lessons-from-writing-a-serialization-library-for-ethereum/)
- [Interactive SSZ serializer/deserializer](https://www.ssz.dev/)