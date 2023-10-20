#!/bin/bash

# Architectures
declare -a Architectures=("x86_64-windows-gnu" "x86_64-linux-gnu" "x86_64-macos-gnu" "aarch64-windows-gnu" "aarch64-linux-gnu" "aarch64-macos-gnu")

# Compile for Architecture
for architecture in ${Architectures[@]}; do
    # Create output dir
    mkdir -p output/$architecture/

    if [[ "$target" == *windows* ]]; then
        extension="dll"
    else
        extension="so"
    fi

    # Compile Zstd
    make -e clean -C ./libzstd/lib/ libzstd CC="zig cc -target $architecture" AR="zig ar"
    cp ./libzstd/lib/libzstd.so ./output/$architecture/libzstd.$extension
    
    # Compile LMDB
    make -e clean -C ./liblmdb liblmdb.so CC="zig cc -target $architecture" AR="zig ar"
    cp -L ./liblmdb/liblmdb.so ./output/$architecture/liblmdb.$extension
done