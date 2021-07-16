# SPEEDY
This repository constains source code related to the SPEEDY family of ultra low-latency block ciphers ("The SPEEDY Family of Block Ciphers - Engineering an Ultra Low-Latency Cipher from Gate Level for Secure Processor Architectures", TCHES Volume 2021, Issue 4)

## Short Description of SPEEDY
SPEEDY is a family of ultra low-latency block ciphers dedicated to semi-custom, i.e., standard-cell-based, integrated circuit design. It is designed to offer secure encryption with an extremely low latency in CMOS hardware. While SPEEDY can be instantiated with different block and key sizes, the default is 192 bit as it constitutes the least common multiple of 6 (the S-box's width) and 64 (the common data width in modern CPUs). This instance is called SPEEDY-r-192, where r is the number of rounds. According to our comparison of high-speed encryption primitives (including PRINCE, PRINCEv2, MANTIS, QARMA, Midori, Gimli (in Even Mansour scheme) and Orthros) SPEEDY-r-192 is faster than any other competitor for r <= 6 despite its 192-bit state. Attacks on SPEEDY-5-192 are expected to require at least a time complexity of 2^{128} when the data complexity is limited to 2^{64}, while SPEEDY-6-192 and SPEEDY-7-192 are expected to offer 128-bit and full 192-bit security respectively without any restrictions to the data complexity.

## Content of the Repository
In this repository we share software and hardware implementations of SPEEDY-r-192 as well as synthesized netlists in NanGate Open Cell Libraries (45nm and 15nm) together with the associated synthesis scripts for Synopsys Design Compiler (tested version O-2018.06-SP4).<br>
A reference implementation written in C is located at `Software/Reference Implementation/C Code/SPEEDY.c`. Another software implementation written in C using a different data representation is located at `Software/6 x 32 Bit Implementation/C Code/SPEEDY.c`. However, please note that SPEEDY is <b>not</b> designed to be efficient in software.<br>
In the `Hardware` directory there are two subfolders, `Behavioral` and `Structural`. While `Hardware/Behavioral` contains universal behavioral/dataflow hardware descriptions of SPEEDY-r-192 (+ synthesis scripts/results), the `Hardware/Structural` subfolder contains optimized structural descriptions of SPEEDY-r-192 (+ synthesis scripts/results) where standard cells of the NanGate libraries are directly instantiated in the HDL code. The structural descriptions achieve significantly improved latency results in NanGate libraries, however, in manufacturable foundry libraries the difference is typically less significant (cf. paper). For the decryption of SPEEDY-r-192 only behavioral descriptions/results are available.<br>
Please note that all latency, area and power consumption results presented in the paper are related to the fully-unrolled purely-combinatorial cipher circuits <b>without</b> considering the input/output registers.

## Contact and Support
Please contact Thorben Moos (thorben.moos@rub.de) if you have any questions, comments or if you found a bug that should be fixed.

## Licensing
Please see `LICENSE` for licensing instructions.
