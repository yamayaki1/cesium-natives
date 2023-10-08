#!/bin/bash

# Architectures
declare -a Architectures=("x86_64-linux-gnu" "x86_64-windows-gnu" "x86_64-macos-none")

# Compile for Architecture
for architecture in ${Architectures[@]}; do
    # Create output dir
    mkdir -p output/$architecture/

    if [[ "$target" == *-windows-* ]]; then
        extension="dll"
    else
        extension="so"
    fi

    # Compile Zstd
    make -e clean -j 8 -C ./libzstd/lib/ libzstd CC="zig cc -target $architecture" AR="zig ar"
    cp ./libzstd/lib/libzstd.so ./output/$architecture/libzstd.$extension
    
    # Compile LMDB
    make -e clean -j 8 -C ./liblmdb liblmdb.so CC="zig cc -target $architecture" AR="zig ar"
    cp -L ./liblmdb/liblmdb.so ./output/$architecture/liblmdb.$extension
done