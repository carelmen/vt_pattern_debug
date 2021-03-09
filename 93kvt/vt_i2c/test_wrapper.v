`ifdef VTW_INCLUDE_ALL_SOURCES
`include "test.hv"
`include "board.hv"
`include "vtw_wfgdef.hv"
`include "vtw_stddef.hv"
`include "vtw_logger.hv"
`include "vtw_alldef.hv"
`include "vtw_stdutil.hv"
`include "clockgen.v"
`include "vtw_logger.v"
`include "vtw_wfg.v"
`include "vtw_stdutil.v"
`include "Pattern0_timing.v"
`include "Pattern0.v"
`include "Pattern0_timing_control.v"
`include "Pattern0_submodule_0.v"
`include "tester.v"
`include "monitor.v"
`else
`include "vtw_alldef.hv"
`endif
module test_wrapper;

  wire SPI_MOSI;
  wire SPI_MISO;
  wire SPI_CS;
  wire SPI_CLK;
  wire I2C_SCL;
  wire I2C_SDA;
  wire JTAG_TCK;
  wire JTAG_TMS;
  wire JTAG_TDI;
  wire JTAG_TDO;
  wire JTAG_TRSTN;
  wire SWDIO;
  wire SWCLK;
  
  vtw_logger vtw_logger(
                       );
  vtw_stdutil vtw_stdutil(
                        );

/*
  `ifdef VTW_OE_CONTENTION_MONITOR
  `ifdef VTW_OWN_MONITOR_CONNECTION
  `else
  monitor monitor(
                  .I2C_SCL_oe(I2C_SCL_oe),
                  .I2C_SDA_oe(I2C_SDA_oe)
                 );
  `endif
  `else
  monitor monitor(
                 );
  `endif
`ifdef VTW_NO_DUT
`else
`ifdef VTW_OWN_DUT_CONNECTION
`else
  dut dut(
          .SPI_MOSI(SPI_MOSI),
          .SPI_MISO(SPI_MISO),
          .SPI_CS(SPI_CS),
          .SPI_CLK(SPI_CLK),
          .I2C_SCL(I2C_SCL),
          .I2C_SDA(I2C_SDA),
          .JTAG_TCK(JTAG_TCK),
          .JTAG_TMS(JTAG_TMS),
          .JTAG_TDI(JTAG_TDI),
          .JTAG_TDO(JTAG_TDO),
          .JTAG_TRSTN(JTAG_TRSTN),
          .SWDIO(SWDIO),
          .SWCLK(SWCLK)
         );
`endif
`endif

`ifdef VTW_USER_CODE
`VTW_USER_CODE
`endif
*/
  tester tester(
                .I2C_SCL(I2C_SCL),
                .I2C_SDA(I2C_SDA)
               );
   
  initial
    begin
`ifdef VTW_OWN_DUMP
       $monitor("web_ %3d I2C_SCL=%b I2C_SDA=%b", $time, I2C_SCL, I2C_SDA);
       
`else
       
`ifdef VTW_FSDB_DUMP

      $fsdbDumpfile("dut.fsdb");
      $fsdbDumpvarsToFile("dut_fsdb.list");
`else
      $dumpfile("dut.vcd");
       
      $dumpvars(1,`VTW_LOGGING.fail_number);
      $dumpvars(1,`VTW_LOGGING.compare_number);
      $dumpvars(1,SPI_MOSI);
      $dumpvars(1,SPI_MISO);
      $dumpvars(1,SPI_CS);
      $dumpvars(1,SPI_CLK);
      $dumpvars(1,I2C_SCL);
      $dumpvars(1,I2C_SDA);
      $dumpvars(1,JTAG_TCK);
      $dumpvars(1,JTAG_TMS);
      $dumpvars(1,JTAG_TDI);
      $dumpvars(1,JTAG_TDO);
      $dumpvars(1,JTAG_TRSTN);
      $dumpvars(1,SWDIO);
      $dumpvars(1,SWCLK);

`ifdef VTW_SKIP_PATTERN_PARAMETERS
`else
      $dumpvars(1,tester.Pattern0.cycle_number);
      $dumpvars(1,tester.Pattern0.repeat_count);
      $dumpvars(1,tester.Pattern0.vector_number);
      $dumpvars(1,tester.Pattern0.waveform_table);
      $dumpvars(1,tester.Pattern0.vector_comment);
      $dumpvars(1,tester.Pattern0.vector_subr);
      $dumpvars(1,tester.Pattern0.pat_name);
`endif

      $dumpvars(1,tester.I2C_SCL_driver);
      $dumpvars(1,tester.I2C_SCL_driver_data);
      $dumpvars(1,tester.I2C_SCL_expected);
      $dumpvars(1,tester.I2C_SCL_comparator);
      $dumpvars(1,tester.I2C_SDA_driver);
      $dumpvars(1,tester.I2C_SDA_driver_data);
      $dumpvars(1,tester.I2C_SDA_expected);
      $dumpvars(1,tester.I2C_SDA_comparator);
`endif
`endif
    end
    
endmodule
