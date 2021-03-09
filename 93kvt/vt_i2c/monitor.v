`ifdef _monitor_v
`else
`define _monitor_v
`ifdef _alldef_hv
`else
`include "vtw_alldef.hv"
`endif
`ifdef VTW_OE_CONTENTION_MONITOR
module monitor(
               I2C_SCL_oe,
               I2C_SDA_oe
              );
`else
module monitor(
               
              );
`endif
  `ifdef VTW_OE_CONTENTION_MONITOR
  input I2C_SCL_oe;
  input I2C_SDA_oe;
  `else
  `endif
  time I2C_SCL_last_contention;
  time I2C_SDA_last_contention;
  initial begin
    I2C_SCL_last_contention=0;
    I2C_SDA_last_contention=0;
  end
  `ifdef VTW_OE_CONTENTION_MONITOR
  // Signal I2C_SCL contention control
  always @(`VTW_TESTER.I2C_SCL or `VTW_TESTER.I2C_SCL_driver or `VTW_TESTER.I2C_SCL_driver_data or I2C_SCL_oe)
    begin
      if(I2C_SCL_last_contention < $time && I2C_SCL_oe === 1 &&
         `VTW_TESTER.I2C_SCL_driver_data !== 1'bx && 
         `VTW_TESTER.I2C_SCL_driver_data !== 1'bz && `VTW_TESTER.I2C_SCL_driver === `VTW_TRUE) begin
         `VTW_LOGGING.contention_message("I2C_SCL");
         I2C_SCL_last_contention = $time;
      end
    end
  
  // Signal I2C_SDA contention control
  always @(`VTW_TESTER.I2C_SDA or `VTW_TESTER.I2C_SDA_driver or `VTW_TESTER.I2C_SDA_driver_data or I2C_SDA_oe)
    begin
      if(I2C_SDA_last_contention < $time && I2C_SDA_oe === 1 &&
         `VTW_TESTER.I2C_SDA_driver_data !== 1'bx && 
         `VTW_TESTER.I2C_SDA_driver_data !== 1'bz && `VTW_TESTER.I2C_SDA_driver === `VTW_TRUE) begin
         `VTW_LOGGING.contention_message("I2C_SDA");
         I2C_SDA_last_contention = $time;
      end
    end
  
  `else
  // Signal I2C_SCL contention control
  always @(`VTW_TESTER.I2C_SCL or `VTW_TESTER.I2C_SCL_driver or `VTW_TESTER.I2C_SCL_driver_data)
    begin
      if(`VTW_TESTER.I2C_SCL === 1'bx && (I2C_SCL_last_contention < $time) && 
         `VTW_TESTER.I2C_SCL_driver_data !== 1'bx && 
         `VTW_TESTER.I2C_SCL_driver_data !== 1'bz && `VTW_TESTER.I2C_SCL_driver === `VTW_TRUE) begin
         `VTW_LOGGING.contention_message("I2C_SCL");
         I2C_SCL_last_contention = $time;
      end
    end
  
  // Signal I2C_SDA contention control
  always @(`VTW_TESTER.I2C_SDA or `VTW_TESTER.I2C_SDA_driver or `VTW_TESTER.I2C_SDA_driver_data)
    begin
      if(`VTW_TESTER.I2C_SDA === 1'bx && (I2C_SDA_last_contention < $time) && 
         `VTW_TESTER.I2C_SDA_driver_data !== 1'bx && 
         `VTW_TESTER.I2C_SDA_driver_data !== 1'bz && `VTW_TESTER.I2C_SDA_driver === `VTW_TRUE) begin
         `VTW_LOGGING.contention_message("I2C_SDA");
         I2C_SDA_last_contention = $time;
      end
    end
  
  `endif
endmodule
`endif
