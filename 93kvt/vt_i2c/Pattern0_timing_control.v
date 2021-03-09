`ifdef _Pattern0_timing_control_v
`else
`define _Pattern0_timing_control_v
`ifdef _alldef_hv
`else
`include "vtw_alldef.hv"
`endif
module Pattern0_timing_control(tester_sync,wft,wfc,triggers);

  input  tester_sync;
  input  [0:3] wft;
  input  [0:15] wfc;
  output [0:6] triggers;
  reg    [0:6] triggers;
  reg    enable;
  
  initial
    begin
      triggers = {7{1'b0}};
    end
  
  always @(posedge tester_sync)
    begin
      // Signal I2C_SCL
      if((wft === 0) && (wfc[0:7] === 1))
        triggers[0] = ~triggers[0];
      if((wft === 0) && (wfc[0:7] === 2))
        triggers[1] = ~triggers[1];
      // Signal I2C_SDA
      if((wft === 0) && (wfc[8:15] === 1))
        triggers[2] = ~triggers[2];
      if((wft === 0) && (wfc[8:15] === 2))
        triggers[3] = ~triggers[3];
      if((wft === 0) && (wfc[8:15] === 3))
        triggers[4] = ~triggers[4];
      if((wft === 0) && (wfc[8:15] === 4))
        triggers[5] = ~triggers[5];
      if((wft === 0) && (wfc[8:15] === 5))
        triggers[6] = ~triggers[6];
    end
    
  always @(negedge tester_sync)
    begin
      triggers = {7{1'b0}};
    end
  
endmodule // Pattern0_timing_control
`endif
