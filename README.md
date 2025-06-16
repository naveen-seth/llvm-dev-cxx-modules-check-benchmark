# Performance Report

## Benchmark: Building Clang While Always Checking For C++20 Module Usage

This benchmark evaluates the performance impact of enabling constant checks for C++20 module usage during the Clang build process, compared to an otherwise equivalent build.

➡️ **Elapsed real time**: ↑0.25%, **User time**: ↑0.18%, **System time**: ↑0.46% 

| Benchmark type    | Run | User time | System time | Wall clock time | CPU usage | Major page faults | Minor page faults | Swaps |
|-------------------|-----|-----------|-------------|-----------------|-----------|-------------------|-------------------|-------|
| C++ Modules Check | 2.0 | 24457.05  | 904.403333  | 1602.85         | 15.816667 | 780.333333        | 1.6441e8          | 0.0   |
| Default           | 2.0 | 24413.77  | 900.273333  | 1598.443333     | 15.83     | 724.0             | 1.64440975e8      | 0.0   |
| Difference        | 0.0 | -43.28    | -4.13       | -4.406667       | 0.013333  | -56.333333        | 29988.333333      | 0.0   |  

- Run `./setup-benchmark.sh` to disable address space randomization and set the CPU scaling governor to performance (Linux only).

- Use `./run-benchmark.sh` to clone my fork of the LLVM project, compile both Clang versions (with and without C++20 module checking), and execute the benchmark N times.
  The results are output as `csv`. You can configure `./run-benchmark.sh` for the output location and number of runs.

- Use `main.py` to calculate the averages for both groups and the difference between them.
  The results are output as a markdown table, like the one above.

## Benchmark: Perf Analysis

This benchmark evaluates the performance of performing the check for C++20 modules on a code example (in folder `perf-code-samples/`) with and without the GPLv3 as preamble.

**WITHOUT GPLv3**
![top_down_without_gplv3](https://github.com/user-attachments/assets/5901fc46-8c64-429b-b0d8-acea291eea15)


**WITH GPLv3**
![top_down_with_full_gplv3](https://github.com/user-attachments/assets/d17c6021-fdc2-4fe8-ba39-b50e9af62594)


