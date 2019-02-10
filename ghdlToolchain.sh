#!/bin/sh
cc=ghdl
topLayerName=tb_cpu
simuDurationNs=1500
opt=--ieee=synopsys

src_array=(
    ./src/register_n_bits.vhd 
    ./src/mux_2_in.vhd 
    ./src/flipflop.vhd 
    ./src/counter_n_bits.vhd 
    ./src/addi_1_bit.vhd 
    ./src/addi_n_bits.vhd
    ./src/ual.vhd
    ./src/ut.vhd
    ./src/uc_fsm.vhd
    ./src/uc.vhd
    ./src/sync_ram.vhd
    ./src/cpu.vhd

    ./src/tb/tb_cpu.vhd
    ./src/tb/tb_addi_n_bits.vhd
    ./src/tb/tb_ual.vhd
    ./src/tb/tb_ut.vhd
    ./src/tb/tb_uc_fsm.vhd
    ./src/tb/tb_uc.vhd
)

# Clean
${cc} --clean

# Analyse all files 
for src in "${src_array[@]}"
    do ${cc} -a ${opt} ${src}
done

# Display nice message
if [ $? -eq 0 ]; then
    echo "(II) COMPILATION OK"
else
    echo "(EE) COMPILATION FAIL"
    exit
fi

# Build executable
${cc} -e ${opt} ${topLayerName}

# Execute
${cc} -r ${opt} ${topLayerName} --vcd=./vcd/${topLayerName}.vcd --stop-time=${simuDurationNs}ns

# Nice message
if [ $? -eq 0 ]; then
    echo "(II) EXECUTION OK"
else
    echo "(EE) EXECUTION FAIL"
    exit
fi