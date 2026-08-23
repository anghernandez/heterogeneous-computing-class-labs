# Lab 2 - Acceleration Through SIMD Vectorization with AVX2

### Objective

Compare the performance of matrix multiplication using a scalar implementation
and a vectorized implementation with SIMD and AVX2 instructions.

Matrices of size `1024 x 1024` were used. The scalar version processes the
elements individually, while the AVX2 version uses 256-bit vector registers
to operate on groups of 8 `float` values of 32 bits each.

## Results

| Implementation | Time (s) | Performance (GFLOP/s) |
| -------------- | -------: | --------------------: |
| Scalar         | 1.242651 |              1.728147 |
| AVX2           | 0.320768 |              6.694815 |

Both implementations produced the same results:

- **Checksum:** `10871481693.000000`
- **C[0][0]:** `13391.250000`
- **C[1023][1023]:** `13403.250000`

The obtained *speedup* was:

$$
S = \frac{T_{\text{scalar}}}{T_{\text{AVX2}}}
= \frac{1.242651}{0.320768}
\approx 3.87
$$

Therefore, for this execution, the vectorized implementation was approximately
**3.87 times faster** than the scalar implementation.

### Analysis

AVX2 allows the use of 256-bit vector registers. Since each `float` value
requires 32 bits, a register can contain 8 values:

$$
\frac{256}{32} = 8
$$

This allows the same operation to be performed on multiple elements
simultaneously using SIMD.

However, processing 8 values with a vector instruction does not imply a speedup
of 8x for the complete program. Matrix multiplication also requires other
operations, such as loading data from memory, reducing partial results,
transposing the matrix, and loop control. These operations also consume time
and limit the total acceleration obtained.

In this measurement, a speedup of approximately **3.87x** was obtained, showing a significant performance improvement through the use of SIMD instructions
with AVX2.