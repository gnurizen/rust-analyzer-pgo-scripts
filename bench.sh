#!/bin/sh

for i in $(seq 1 $1); do
    time $2 analysis-stats -q --run-all-ide-things ./rust-analyzer-pgo/clap-rs-clap
done
