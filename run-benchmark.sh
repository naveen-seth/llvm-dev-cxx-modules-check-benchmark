#!/usr/bin/env bash

# --- Configuration ---
TOTAL_RUNS=15
BENCHMARK_CSV_FILE="benchmark_results.csv"

# Source and build dir of the program to build as benchmark
BENCHMARK_SOURCE_DIR="$PWD/naveens-llvm-fork"
BENCHMARK_BUILD_DIR="$BENCHMARK_SOURCE_DIR/build-benchmark"

# Build dirs of the Clang versions to benchmark
DEFAULT_TOOLCHAIN_BUILD_DIR="$BENCHMARK_SOURCE_DIR/build-default-release"
MODULES_CHECK_TOOLCHAIN_BUILD_DIR="$BENCHMARK_SOURCE_DIR/build-modules-release"


# --- Build Clang versions to benchmark --
git clone git@github.com:naveen-seth/llvm-project.git "$BENCHMARK_SOURCE_DIR"

git -C "$BENCHMARK_SOURCE_DIR" switch dev-modules-driver-benchmark
cmake -S "$BENCHMARK_SOURCE_DIR/llvm" -B "$MODULES_CHECK_TOOLCHAIN_BUILD_DIR" -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_ENABLE_PROJECTS=clang \
      -DLLVM_PARALLEL_LINK_JOBS=1 \
      -DLLVM_TARGETS_TO_BUILD=X86 \
      -DLLVM_USE_LINKER=lld
cmake --build "$MODULES_CHECK_TOOLCHAIN_BUILD_DIR"

git -C "$BENCHMARK_SOURCE_DIR" switch main
git -C "$BENCHMARK_SOURCE_DIR" checkout df7db44
cmake -S "$BENCHMARK_SOURCE_DIR/llvm" -B "$DEFAULT_TOOLCHAIN_BUILD_DIR" -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_ENABLE_PROJECTS=clang \
      -DLLVM_PARALLEL_LINK_JOBS=1 \
      -DLLVM_TARGETS_TO_BUILD=X86 \
      -DLLVM_USE_LINKER=lld
cmake --build "$DEFAULT_TOOLCHAIN_BUILD_DIR"


# --- Run benchmark ---
echo "Run,Benchmark type,User time,System time,Wall clock time,CPU usage,Major page faults,Minor page faults,Swaps" > "$BENCHMARK_CSV_FILE"

run_benchmark() {
  local benchmark_type="$1"
  local clang_build_dir="$2"
  local run_number="$3"

  echo "Benchmark [$benchmark_type] - Starting run $i"

  rm -rf "$BENCHMARK_BUILD_DIR"
  cmake -S "$BENCHMARK_SOURCE_DIR/llvm" -B "$BENCHMARK_BUILD_DIR" -GNinja \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER="${clang_build_dir}/bin/clang" \
	-DCMAKE_CXX_COMPILER="${clang_build_dir}/bin/clang++" \
	-DLLVM_ENABLE_PROJECTS=clang \
	-DLLVM_PARALLEL_LINK_JOBS=1 \
	-DLLVM_TARGETS_TO_BUILD=X86 \
	-DLLVM_USE_LINKER=lld
  /usr/bin/env time -f "$run_number,$benchmark_type,%U,%S,%E,%P,%F,%R,%W" cmake --build "$BENCHMARK_BUILD_DIR" 2>>"$BENCHMARK_CSV_FILE"

  echo "Benchmark [$benchmark_type] - Run $i completed"
}

for ((i = 1; i <= TOTAL_RUNS; i++)); do
  run_benchmark "C++ Modules Check" "$MODULES_CHECK_TOOLCHAIN_BUILD_DIR" "$i"
  run_benchmark "Default" "$DEFAULT_TOOLCHAIN_BUILD_DIR" "$i"
done
