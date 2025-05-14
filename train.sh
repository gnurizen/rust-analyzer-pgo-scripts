#!/bin/bash
set -e

# tricks of the trade!
echo 99 | sudo tee -a /proc/sys/kernel/perf_cpu_time_max_percent
echo 50000 | sudo tee -a /proc/sys/kernel/perf_event_max_sample_rate

INC=5
LBR_RUNS=40
STACK_RUNS=60

OUT=profdata
mkdir -p $OUT

CARGO_PROFILE_RELEASE_LTO=thin
export CARGO_PROFILE_RELEASE_LTO

# If merged.profdata doesn't exist create it
if [ ! -f rust-analyzer-pgo/merged.profdata ]; then
    RUSTFLAGS="-Cprofile-generate=$(pwd)/rust-analyzer-pgo" cargo build --bin rust-analyzer --release
    # clap-rs/clap must be cloned externally
    ./bench.sh 1 ./target/release/rust-analyzer
    # Use llvm.sh to install llvm version 20
    llvm-profdata-20 merge rust-analyzer-pgo/*.profraw -o rust-analyzer-pgo/merged.profdata
fi

if [ $LBR_RUNS -gt 0 ]; then
    cargo build --bin rust-analyzer --profile dev-rel
    # Do it in batches of 10 to avoid massive perf data files
    i=0
    while [ $LBR_RUNS -gt 0 ]; do
        perf record -Fmax -b -e BR_INST_RETIRED.NEAR_TAKEN:uppp -- ./bench.sh $INC ./target/dev-rel/rust-analyzer
        llvm-profgen-20 --binary=./target/dev-rel/rust-analyzer --perfdata=perf.data --output=$OUT/lbr-$i.profraw
        LBR_RUNS=$((LBR_RUNS-$INC))
        i=$((i+1))
    done
    llvm-profdata-20 merge --sample $OUT/lbr-*.profraw -o $OUT/lbr.profdata
fi

if [ $STACK_RUNS -gt 0 ]; then
    # Do it in batches of 10 to avoid massive perf data files
    i=0
    while [ $STACK_RUNS -gt 0 ]; do
        perf record -Fmax -e cycles -- ./bench.sh $INC ./target/dev-rel/rust-analyzer
        # Must be built from autofdo sources
        create_llvm_prof --binary=./target/dev-rel/rust-analyzer --out $OUT/stack-$i.profraw --use_lbr=false
        STACK_RUNS=$((STACK_RUNS-$INC))
        i=$((i+1))
    done
    llvm-profdata-20 merge --sample $OUT/stack-*.profraw -o $OUT/stack.profdata
fi

