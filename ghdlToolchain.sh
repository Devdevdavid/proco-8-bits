#!/bin/sh
cc=ghdl
topLayerName=tb_ut
simuDurationNs=500

src_array=(
    ./src/cpu.vhd
    ./src/register_n_bits.vhd 
    ./src/mux_2_in.vhd 
    ./src/flipflop.vhd 
    ./src/counter_n_bits.vhd 
    ./src/adder_n_bits/addi_1_bit.vhd 
    ./src/adder_n_bits/addi_n_bits.vhd
    ./src/ual.vhd
    ./src/ut.vhd

    ./src/tb_cpu.vhd
    ./src/adder_n_bits/tb_addi_n_bits.vhd
    ./src/tb_ual.vhd
    ./src/tb_ut.vhd
)

# Clean
${cc} --clean

# Analyse all files 
for src in "${src_array[@]}"
    do ${cc} -a ${src} 
done

# Display nice message
if [ $? -eq 0 ]; then
    echo "(II) COMPILATION OK"
else
    echo "(EE) COMPILATION FAIL"
    exit
fi

# Build executable
${cc} -e ${topLayerName}

# Execute
${cc} -r ${topLayerName} --vcd=${topLayerName}.vcd --stop-time=${simuDurationNs}ns

# Nice message
if [ $? -eq 0 ]; then
    echo "(II) EXECUTION OK"
else
    echo "(EE) EXECUTION FAIL"
    exit
fi