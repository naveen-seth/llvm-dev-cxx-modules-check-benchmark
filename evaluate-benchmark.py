import polars as pl

benchmark_data = "benchmark_results.csv"
df = pl.read_csv(benchmark_data)

# Clean data
def parse_wall_clock_time(time_str: str) -> float:
    minutes, rest = time_str.split(":")
    seconds, centis = rest.split(".")
    total_seconds = int(minutes) * 60 + int(seconds)
    microseconds = int(centis) * 10_000
    return float(f"{total_seconds}.{microseconds:06d}")

def normalize_cpu_usage(cpu_str: str) -> float:
    return float(cpu_str.replace("%", "")) / 100

df = df.with_columns(
    pl.col("Wall clock time")
    .map_elements(parse_wall_clock_time, return_dtype=pl.Float64)
    .alias("Wall clock time"),
    pl.col("CPU usage")
    .map_elements(normalize_cpu_usage, return_dtype=pl.Float64)
    .alias("CPU usage"),
)

# Compute average of each group
df_means = df.group_by("Benchmark type").mean()

# Compute difference of averages
numeric_cols = [
    col for col, dtype in zip(df.columns, df.dtypes) if dtype in (pl.Float64, pl.Int64)
]

df_diff = pl.DataFrame(
    [
        {
            col: df_means[col][1] - df_means[col][0] if col in numeric_cols else None
            for col in df_means.columns
        }
    ]
)
df_diff = df_diff.with_columns(pl.lit("Difference").alias("Benchmark type"))

# Combine results
df_results = pl.concat([df_means, df_diff], how="vertical")

# Output
with pl.Config(
    tbl_formatting="MARKDOWN",
    tbl_rows=100,
    tbl_cols=100,
    tbl_hide_column_data_types=True,
    tbl_hide_dataframe_shape=True,
):
    print(df_results)
