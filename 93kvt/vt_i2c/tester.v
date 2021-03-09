`ifdef _tester_v
`else
`define _tester_v
`ifdef _alldef_hv
`else
`include "vtw_alldef.hv"
`endif
module tester(
              I2C_SCL,
              I2C_SDA
             );
  inout  I2C_SCL;
  inout  I2C_SDA;
  // Signal I2C_SCL
  reg I2C_SCL_driver;
  reg I2C_SCL_driver_data;
  reg I2C_SCL_expected;
  reg I2C_SCL_comparator;
  // Signal I2C_SDA
  reg I2C_SDA_driver;
  reg I2C_SDA_driver_data;
  reg I2C_SDA_expected;
  reg I2C_SDA_comparator;
  
  reg test_complete;
  initial
    begin
      test_complete =  1'b0;
      `VTW_STD_UTIL.initialize;
      `ifdef VTW_OWN_INIT
      `VTW_OWN_INIT;
      `endif
      `ifdef VTW_NO_AUTOSTART
      `else
        fork
          begin
            Pattern0_exec;
          end
        join
        test_complete = 1'b1;
      `endif
    end
  
  task Pattern0_exec;
    begin
        #0 -> Pattern0.start;
        @(Pattern0.finished);
    end
  endtask
  
  always @(posedge test_complete)
    begin
      if( test_complete === 1'b1 )
        begin
          `VTW_LOGGING.final_message;
           $finish;
        end
    end
  
  initial
    begin
      I2C_SCL_driver = `VTW_FALSE;
      I2C_SCL_driver_data = $time % 2;
      I2C_SDA_driver = `VTW_FALSE;
      I2C_SDA_driver_data = $time % 2;
    end
  
    // Signal I2C_SCL driver connection
    assign I2C_SCL = (I2C_SCL_driver === `VTW_TRUE && I2C_SCL_driver_data !== 1'bx) ? I2C_SCL_driver_data : 1'bz;
    // Signal I2C_SDA driver connection
    assign I2C_SDA = (I2C_SDA_driver === `VTW_TRUE && I2C_SDA_driver_data !== 1'bx) ? I2C_SDA_driver_data : 1'bz;
    
    Pattern0 Pattern0(
                      .I2C_SCL(I2C_SCL),
                      .I2C_SDA(I2C_SDA)
                     );
endmodule
`endif
