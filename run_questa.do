# QuestaSim/ModelSim batch script.
# Run from the project directory with: vsim -c -do run_questa.do

transcript on
onerror {quit -code 1 -force}
onbreak {quit -code 1 -force}

# Resolve all relative paths from the script location.
set SCRIPT_DIR [file dirname [file normalize [info script]]]
cd $SCRIPT_DIR

if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

vlog -sv -work work Register_File.v
vlog -sv -work work Register_File_tb.v

vsim -voptargs=+acc work.Register_File_tb

# Populate the Wave window when the script is launched from the GUI.
add wave -r /*

# Export a VCD that can be opened with GTKWave.
vcd file register_file.vcd
vcd add -r /Register_File_tb/*

run -all
vcd flush
vcd off
quit -code 0 -force
