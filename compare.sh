#!/bin/bash

ARGS="analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap"
#ARGS="analysis-stats -q --run-all-ide-things ../anyhow"
commands=()
for bin in ./pgobuilds/*/release/rust-analyzer; do
    commands+=("$bin $ARGS")
done

# Run each binary with hyperfine
hyperfine --export-markdown results.md -r 3 -- "${commands[@]}"
cat results.md
# Run each one with perf stat
for c in "${commands[@]}"; do
	perf stat -- $c
done
