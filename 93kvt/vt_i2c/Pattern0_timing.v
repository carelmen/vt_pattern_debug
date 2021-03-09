`ifdef _Pattern0_timing_v
`else
`define _Pattern0_timing_v
`ifdef _alldef_hv
`else
`include "vtw_alldef.hv"
`endif
module Pattern0_timing(tester_sync,vector_number,cycle_number,wft,wfc,vector_comment,I2C_SCL,I2C_SDA);

  input tester_sync;
  input [0:`VTW_INTEGER_SIZE-1] vector_number;
  input [0:`VTW_INTEGER_SIZE-1] cycle_number;
  input [0:`VTW_COMMENT_SIZE-1] vector_comment;
  input [0:3] wft;
  input [0:15] wfc;
  inout  I2C_SCL;
  inout  I2C_SDA;
  wire [0:6] triggers;
  
  Pattern0_timing_control timing_control(.tester_sync(tester_sync),
                                         .wft(wft),
                                         .wfc(wfc),
                                         .triggers(triggers));
                                         
  // Submodules
  Pattern0_submodule_0 Pattern0_submodule_0();
  
  task initialize;
    begin
      Pattern0_submodule_0.initialize;
    end
  endtask
  task finalize;
    begin
      /*
      // Switch off I2C_SCL driver
      `VTW_TESTER.I2C_SCL_driver = `VTW_FALSE;
      // Switch off I2C_SDA driver
      `VTW_TESTER.I2C_SDA_driver = `VTW_FALSE;
      */
    end
  endtask
  
endmodule // Pattern0_timing
`endif
