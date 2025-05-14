#!/bin/bash
set -e

rm -rf bin
mkdir -p bin

function build() {
 name=$1
 time CARGO_PROFILE_RELEASE_LTO=thin cargo build --bin rust-analyzer --release --target-dir ./pgobuilds/${1}thin
 time CARGO_PROFILE_RELEASE_LTO=fat cargo build --bin rust-analyzer --release --target-dir ./pgobuilds/${1}fat
}

# LBR samples and stack samples must be generated externally and converted to profdata files
RUSTFLAGS="-Zprofile-sample-use=$(pwd)/profdata/lbr.profdata" build lbrpgo
RUSTFLAGS="-Zprofile-sample-use=$(pwd)/profdata/stack.profdata" build spgo

# Build w/o PGO
build stock

# Run train.sh first to get the profdata files
RUSTFLAGS="-Cprofile-use=$(pwd)/rust-analyzer-pgo/merged.profdata" build ipgo


