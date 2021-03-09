# Apply patch to monitor I2C Signals
patch vt_i2c/test_wrapper.v ../simulation/export_i2c.patch

# Create ModelSim library
vlib pattern_sim

# Map work directory top pattern sim library
vmap work pattern_sim

# Compile all sources
vlog  +define+VTW_SKIP_PATTERN_PARAMETERS +define+VTW_NO_DUT +define+VTW_OWN_DUMP vt_i2c/*.v vt_i2c/*.hv

# Run simulation
vsim -c -do ../simulation/i2c_run_sim.do test_wrapper

# Extract toggles from simulation output
grep web transcript  | awk  -F= '{print $2,$3}' | sed s/I2C_SDA//g | sed s/z/0/g | sed s/"  "/" "/g >  i2c.csv
