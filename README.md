# Performance Report

## Benchmark: Perf Analysis

This benchmark evaluates the performance impact of checking for C++20 module usage on a small C++ example file, both with and without a GPLv3 license preamble.  

#### Test Files:  

- `perf-code-samples/example1_with_GPLv3.cpp` (~675 lines of license preamble)  
- `perf-code-samples/example1_without_GPLv3.cpp`  

#### Results:

The module usage check accounted for only ~0.5% of total compilation time, even on a file which already is fast to compile.  
Adding ~675 lines of license preamble increased this overhead by only ~0.1%.

**WITHOUT GPLv3**
![without_gplv3_top_down_v4](https://github.com/user-attachments/assets/5e73916a-9d6f-4087-a56e-cd1e514d5fbc)

**WITH GPLv3**
![with_gplv3_top_down_v5](https://github.com/user-attachments/assets/2b0d7cd9-1ca9-414d-af59-83af5575dfac)

## Benchmark: Building Clang While Always Checking For C++20 Module Usage

This benchmark evaluates the performance impact of enabling constant checks for C++20 module usage during the Clang build process, compared to an otherwise equivalent build.  

To reproduce this benchmark:

- Run `./setup-benchmark.sh` to disable address space randomization and set the CPU scaling governor to performance (Linux only).

- Use `./run-benchmark.sh` to clone my fork of the LLVM project, compile both Clang versions (with and without C++20 module checking), and execute the benchmark N times.
  The results are output as `csv`. You can configure `./run-benchmark.sh` for the output location and number of runs.

- Use `main.py` to calculate the averages for both groups and the difference between them.
  The results are output as a markdown table, like the one above.

The benchmark was performed multiple times and does generally not seem to have a noticable impact on build-times.
In some cases, the Clang build with checks for C++ module use even performed slightly better. This could potentially be 
attributed to statistical noise overshadowing the performance overhead.

##### Benchmark 1 with 3 runs for each Clang:
| Benchmark type    | User time | System time | Wall clock time | CPU usage | Major page faults | Minor page faults | Swaps |
|-------------------|-----------|-------------|-----------------|-----------|-------------------|-------------------|-------|
| C++ Modules Check | 24457.05  | 904.403333  | 1602.85         | 15.816667 | 780.333333        | 1.6441e8          | 0.0   |
| Default           | 24413.77  | 900.273333  | 1598.443333     | 15.83     | 724.0             | 1.64440975e8      | 0.0   |
| Difference        | -43.28    | -4.13       | -4.406667       | 0.013333  | -56.333333        | 29988.333333      | 0.0   |  

➡️ **Elapsed real time**: ↑0.25%, **User time**: ↑0.18%, **System time**: ↑0.46% 

##### Benchmark 2 with 10 runs for each Clang:
| Benchmark type    | User time |  System time | Wall clock time | CPU usage | Major page faults | Minor page faults | Swaps  |
|-------------------|-----------|--------------|-----------------|-----------|-------------------|-------------------|--------|
| C++ Modules Check | 17158.833 | 642.367      | 1125.817        | 15.806    | 777.3             | 1.64306193e8      | 0.0    |
| Default           | 17303.975 | 647.976      | 1136.841        | 15.787    | 809.6             | 1.6430e8          | 0.0    |
| Difference        | 145.142   | 5.609        | 11.024          | -0.019    | 32.3              | -7197.3           | 0.0    |

➡️ **Elapsed real time**: ↓0.96%, **User time**: ↓0.83%, **System time**: ↓0.86% 

##### Benchmark 3 with 12 runs for each Clang:
| Benchmark type    | User time    | System time | Wall clock time | CPU usage | Major page faults | Minor page faults | Swaps |
|-------------------|--------------|-------------|-----------------|-----------|-------------------|-------------------|-------|
| C++ Modules Check | 16864.321667 | 633.996667  | 1106.9075       | 15.803333 | 737.916667        | 1.6437e8          | 0.0   |
| Default           | 16974.99     | 637.189167  | 1113.116667     | 15.819167 | 721.75            | 1.6443e8          | 0.0   |
| Difference        | 110.668333   | 3.1925      | 6.209167        | 0.015833  | -16.166667        | 61695.166667      | 0.0   |

➡️ **Elapsed real time**: ↓0.56%, **User time**: ↓0.65%, **System time**: ↓0.5% 

