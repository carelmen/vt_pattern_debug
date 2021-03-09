# TestInsight Tutorial - Debugging patterns with protocols

This is the example material that I presented in TestInsight's Tutorial on pattern debug.

## Contents
* Minimal Advantest 93k Test Program with example I2C Pattern
* Setup file for virtual 93kvt 
* Setup and simulation script for ModelSIM


## Requirements
You need
* A TestInsight 93kvt license
* A verilog simulator, e,g, ModelSim but others work too
* PulseView (or sigrok-cli). If you're on Linux, apt install sigrok should do it.

## Howto
The full testbench is checked in so you can compile it with your simulator
1. Run simulation. Check the run_sim.sh in scrips
2. Open CSV in PulseView 
3. Enable I2C Protocol Decoder
4. (Optional) Check the text output: see sigrok/decode_i2c.sh


