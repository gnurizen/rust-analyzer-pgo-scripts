# Rust Analyzer Performance Comparison

![Rust Analyzer Performance Comparison](./results.svg)

## Key Findings

- **Best performer**: ipgothin (baseline) with mean execution time of 33.96s
- **Worst performer**: spgothin at 40.26s (19% slower than baseline)
- **Interesting pattern**: "thin" variants are generally slower than "fat" variants, except for ipgo
- **Error margins**: ipgofat and spgothin have the largest error margins (±1.77s and ±1.75s)

## Raw Data

| Command | Mean [s] | Min [s] | Max [s] | Relative |
|:---|---:|---:|---:|---:|
| `./pgobuilds/ipgofat/release/rust-analyzer analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap` | 36.058 ± 1.768 | 34.070 | 37.454 | 1.06 ± 0.05 |
| `./pgobuilds/ipgothin/release/rust-analyzer analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap` | 33.962 ± 0.387 | 33.640 | 34.391 | 1.00 |
| `./pgobuilds/lbrpgofat/release/rust-analyzer analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap` | 37.526 ± 0.880 | 36.659 | 38.417 | 1.10 ± 0.03 |
| `./pgobuilds/lbrpgothin/release/rust-analyzer analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap` | 38.546 ± 0.256 | 38.287 | 38.798 | 1.13 ± 0.01 |
| `./pgobuilds/spgofat/release/rust-analyzer analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap` | 37.998 ± 1.287 | 36.862 | 39.396 | 1.12 ± 0.04 |
| `./pgobuilds/spgothin/release/rust-analyzer analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap` | 40.261 ± 1.746 | 38.245 | 41.279 | 1.19 ± 0.05 |
| `./pgobuilds/stockfat/release/rust-analyzer analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap` | 37.961 ± 0.332 | 37.587 | 38.220 | 1.12 ± 0.02 |
| `./pgobuilds/stockthin/release/rust-analyzer analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap` | 39.264 ± 1.198 | 38.458 | 40.640 | 1.16 ± 0.04 |