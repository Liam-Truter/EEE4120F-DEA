# EEE4120F-DEA
Multiple implementations of an encryption algorithm including a golden measure in Python, an FPGA digital accelerator in Verilog, and a GPU digital accelerator in OpenCL and C++.

## [Golden Measure](Golden Measure)

## [Verilog](Verilog)
The Nexys FPGA implementation utilised verilog to implement simplified XOR encryption. 
## [OpenCL](OpenCL)
The OpenCL implementation utilises a combination of OpenCL and C++ to execute the XOR encryption algorithm on the GPU. This allows for a vast speedup due to the significant parallel processing capabilities of the GPU. The implementation consists of a [primitive XOR encryption program](OpenCL/primitive_xor_encryption.cpp) that has hard-coded inputs instead of user inputs. There is an [advanced XOR encryption program](OpenCL/xor_encryption.cpp). This allows complete user input to select input and output files as well as an encryption key. Both programs have profiling information that details their performance. Some of the input and output text files are also included. The key used for all encryptions was 128. The [kernel](OpenCL/OpenCL) used was the same between implementations.
