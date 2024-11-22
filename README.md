# Mayo2-Jasmin
Jasmin Implementation of the Mayo Signature scheme

# Compiling and Executing

NIST api is available in the **test_NIST_signverif.c** file and a sample output can be found in **out.txt**.
To compile the code, run:

```bash
make sign
./sign

```

# Benchmarking of Mayo2 implementation

Benchmarked based on the average of 100,000 runs of the implementation on a **2.25GHz x86_64 processor** with **256 GB RAM**.

| Scheme   | Public Key Size | Signature Size |
|----------|-----------------|----------------|
| Mayo 2   | 5488 bytes      | 180 bytes      |

| Primitive | Jasmin Implementation | 'C' Reference Implementation |
|-----------|------------------------|-----------------------------|
| Keygen    | 930 μsecs              | 1629 μsecs                  |
| Sign      | 3206 μsecs             | 2749 μsecs                  |
| Verify    | 480 μsecs              | 665 μsecs                   |

# References
The details of the implementation can be found at [eprint archive 2024/1893](https://eprint.iacr.org/2024/1893).

