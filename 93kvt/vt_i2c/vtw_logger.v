/*
 * File:	vtw_logger.v
 * Author:	dima@testinsight.com
 * Created:	Tue Dec 23 2003
 * Copyright:	(c) 2003, Test Insight Ltd.
 *
 * Abstract:	Virtual tester logger messages
 *
 * $Id: vtw_logger.v,v 1.17 2019/05/07 09:35:05 dima Exp $
 */

`ifdef _vtw_logger_v
`else
 `define _vtw_logger_v

`ifdef _test_hv
`else
 `include "test.hv"
`endif

`ifdef _stddef_hv
`else
 `include "vtw_stddef.hv"
`endif

`ifdef _logger_hv
`else
 `include "vtw_logger.hv"
`endif

// Local defines for internal use
`define VTW_MAX_LOG_NUM 20
`define VTW_INVALID_FILE_HANDLE -1

module vtw_logger;

   integer fail_number;
   integer compare_number;

   integer hLogFile;                 		
   integer hFailFile;
   integer hWarnFile;
   integer hWaverFile;

   reg 	   test_pass;
   reg 	   test_fail;
   reg 	   test_end;

   reg [0:`VTW_PATH_SIZE-1] vtw_log_filename;
   reg [0:`VTW_PATH_SIZE-1] vtw_logfail_filename;
   reg [0:`VTW_PATH_SIZE-1] vtw_logwarn_filename;
   reg [0:`VTW_PATH_SIZE-1] vtw_logwaver_filename;

   reg [0:`VTW_TEXT_SIZE-1] vtw_pattern_names [0:`VTW_MAX_LOG_NUM-1];
   integer vtw_pattern_handles [0:`VTW_MAX_LOG_NUM];
   
   initial
     begin
	fail_number    = 0;
	compare_number = 0;
	test_pass      = 0;
	test_fail      = 0;
	test_end       = 0;

	// Log file support
        vtw_log_filename = `VTW_LOGFILE;
        vtw_logfail_filename = `VTW_LOGFAIL;
        vtw_logwarn_filename = `VTW_LOGWARN;
	vtw_logwaver_filename = `VTW_LOGWAVER;

        if ($value$plusargs("vtw_logfile=%s", vtw_log_filename) == 0)
           vtw_log_filename = `VTW_LOGFILE;

        if ($value$plusargs("vtw_logfail=%s", vtw_logfail_filename) == 0)
           vtw_logfail_filename = `VTW_LOGFAIL;

        if ($value$plusargs("vtw_logwarn=%s", vtw_logwarn_filename) == 0)
           vtw_logwarn_filename = `VTW_LOGWARN;

        if ($value$plusargs("vtw_logwaver=%s", vtw_logwaver_filename) == 0)
           vtw_logwaver_filename = `VTW_LOGWAVER;


        $display("Opening log files : %0s,%0s,%0s,%0s.", 
		 vtw_log_filename, vtw_logfail_filename, vtw_logwarn_filename, vtw_logwaver_filename);

        hLogFile   = $fopen(vtw_log_filename) | 1;
        hFailFile  = $fopen(vtw_logfail_filename);
        hWarnFile  = $fopen(vtw_logwarn_filename);
	hWaverFile = $fopen(vtw_logwaver_filename);

	init_pattern_handles;
     end
	
   // Reset registers after delay
   always @(posedge test_pass) begin
      #`VTW_CONTROL_PULSE;
      test_pass = 0;
   end

   always @(posedge test_fail) begin
      #`VTW_CONTROL_PULSE;
      test_fail = 0;
   end
   
   always @(posedge test_end) begin
      #`VTW_CONTROL_PULSE;
      test_end = 0;
   end

   task init_pattern_handles;

      integer index;
      
      for(index = 0; index < `VTW_MAX_LOG_NUM; index = index+1)
	vtw_pattern_handles[index] = `VTW_INVALID_FILE_HANDLE;

   endtask
     
   task error_message;

      input [0:`VTW_ERRMSG_SIZE -1] message;
      
      begin

	 $fdisplay(hLogFile|hFailFile,"[ VTSIMERR ][ %0s ]",message);
	 
      end

   endtask
      
   task fail_message;

      input [0:`VTW_INTEGER_SIZE-1] vector_number;
      input [0:`VTW_INTEGER_SIZE-1] cycle_number;
      input [0:`VTW_COMMENT_SIZE-1] vector_comment;
      input [0:`VTW_TEXT_SIZE-1] waveform;
      input [0:`VTW_TEXT_SIZE-1] signal;
      input [0:`VTW_TEXT_SIZE-1] pattern;
      input                      real_data;
      input                      expected_data;
      integer                    index;
      integer 			 fh;
      integer                    hAllLogs;

      begin

	 hAllLogs = hLogFile|hFailFile;
	 
         `ifdef VTW_PATTERN_BASED_FAIL_LOG
	   fh = `VTW_INVALID_FILE_HANDLE;
	 
	   for(index = 0; index < `VTW_MAX_LOG_NUM && fh == -1; index=index+1)
	     if( vtw_pattern_names[index] == pattern ) begin
	     fh = vtw_pattern_handles[index];
	   end
	 
	   if(fh == `VTW_INVALID_FILE_HANDLE) begin
	     for(index = 0; index < `VTW_MAX_LOG_NUM && fh == -1; index=index+1)
	       if(vtw_pattern_handles[index] == -1 ) begin
	         fh = $fopen({pattern,".log"});
	         vtw_pattern_names[index] = pattern;
	         vtw_pattern_handles[index] = fh;
	       end
	   end

	   if(fh != `VTW_INVALID_FILE_HANDLE) 
	     hAllLogs = hAllLogs | fh;
	 `endif
	 
	 `ifdef VTW_NO_DUT
	 `else
	   fail_number = fail_number + 1;

	   if( (vector_comment[0:7] == 8'd32) && (vector_comment[8:15] == 8'b0) )
	     $fdisplay(hAllLogs,"[ VTCMPVAL ][ compare failed ][ %0s in %0s ][ vector #%0d ][ cycle #%0d ][ wfc %0s][ real %0b ][ exp %0b ][ time %0t ]",
		       signal,pattern,vector_number,cycle_number,waveform,real_data, expected_data,$realtime);
	   else
	     $fdisplay(hAllLogs,"[ VTCMPVAL ][ compare failed ][ %0s in %0s ][ vector #%0d ][ cycle #%0d ][ comment %0s ][ wfc %0s][ real %0b ][ exp %0b ][ time %0t ]",
		       signal,pattern,vector_number,cycle_number,vector_comment,waveform,real_data,expected_data,$realtime);

  	   $fdisplay(hWaverFile,"%0d\t%0s\t%0b\t%0b",cycle_number+1,signal,expected_data,real_data);
	 `endif
      end
   endtask // fail_message

   task driver_off_drive_message;

      input [0:`VTW_INTEGER_SIZE-1] vector_number;
      input [0:`VTW_INTEGER_SIZE-1] cycle_number;
      input [0:`VTW_TEXT_SIZE-1] waveform;
      input [0:`VTW_TEXT_SIZE-1] signal;
      input [0:`VTW_TEXT_SIZE-1] pattern;
      
      begin
	 $fdisplay(hLogFile|hWarnFile,"[ VTDRVOFF ][ drive attempt while driver off or unstable ][ %0s in %0s ][ vector #%0d ][ cycle #%0d ][ time %0t ]",
		   signal,pattern,vector_number,cycle_number,$realtime);
      end
   endtask
    
   task driver_on_compare_message;

      input [0:`VTW_INTEGER_SIZE-1] vector_number;
      input [0:`VTW_INTEGER_SIZE-1] cycle_number;
      input [0:`VTW_TEXT_SIZE-1] waveform;
      input [0:`VTW_TEXT_SIZE-1] signal;
      input [0:`VTW_TEXT_SIZE-1] pattern;

      begin
	 $fdisplay(hLogFile|hWarnFile,"[ VTDRVONU ][ compare attempt while driver on or unstable ][ %0s in %0s ][ vector #%0d ][ cycle #%0d ][ time %0t ]",
		   signal,pattern,vector_number,cycle_number,$realtime);
      end
   
   endtask // driver_on_compare_message

   task contention_message;

      input [0:`VTW_TEXT_SIZE-1] signal;

      begin
	 $fdisplay(hLogFile|hWarnFile,"[ VTDRVCNT ][ contention between device and tester ][ signal %0s ][ time %0t ]",
		  signal,$realtime);
      end
   
   endtask // contention_message
   
   task vector_info_message;

      input [0:`VTW_INTEGER_SIZE-1] vector_number;
      input [0:`VTW_INTEGER_SIZE-1] cycle_number;
      input [0:`VTW_TEXT_SIZE-1]    waveform_table;
      input [0:`VTW_TEXT_SIZE-1]    pattern;
      input [0:`VTW_COMMENT_SIZE-1] vector_comment;
      input [0:`VTW_ID_SIZE-1]      vector_subr;
      reg   [0:`VTW_TEXT_SIZE-1]    system_time;

      reg   [0:2*`VTW_TEXT_SIZE] opt_fields;

      begin
	 `ifdef VTW_SILENT
	 `else
	  `ifdef VTW_LOG_TIMESTAMP
	     localtime(system_time);
    	     $fdisplay(hLogFile,"[ VTSYSTIM ][ system time %0s]",system_time);
	  `endif

         optional_fields(vector_comment,vector_subr,opt_fields);
         $fdisplay(hLogFile,"[ VTVECINF ][ vector information ][ pattern %0s ][ vector #%0d ][ cycle #%0d ][ wft %0s ][ time %0t ]%0s",
		   pattern,vector_number,cycle_number,waveform_table,$realtime,opt_fields);

	  `endif
      end
   endtask // vector_info_message

   task final_message;

      begin
	 $fdisplay(hLogFile,"\n-------------------------------------------------------------------------------------------");
	 $fdisplay(hLogFile,"Verilog TestBench completed, see log files %0s,%0s,%0s.",vtw_log_filename, vtw_logfail_filename, vtw_logwarn_filename);
	 `ifdef VTW_NO_DUT
	   $fdisplay(hLogFile,"Status : off-line execution (without device), nothing was checked.");
	 `else
	 if(fail_number === 0)
	   $fdisplay(hLogFile,"Status : simulation passed.");
	 else
	   $fdisplay(hLogFile,"Status : simulation failed with %0d errors detected.",fail_number);
	 `endif

	 $fdisplay(hLogFile,"Total number of compare operations executed : %0d.",compare_number);
	 $fdisplay(hLogFile,"-------------------------------------------------------------------------------------------");
      end

   endtask // final_message

   task localtime;

      output [0:`VTW_TEXT_SIZE-1] system_time;
      reg    [0:`VTW_TEXT_SIZE-1] system_time;

      integer 			fd;
      integer 			i;
      integer 			len;

      begin
	 $system({`VTW_DATE_CMD, " > ",`VTW_DATE_FILE });
	 fd = $fopen(`VTW_DATE_FILE, "r");
	 len = $fgets(system_time,fd);
	 $fclose(fd);
	 $system({"rm ",`VTW_DATE_FILE});
	 for(i=0; i<`VTW_BYTE_SIZE; i = i + 1)
	   system_time[`VTW_TEXT_SIZE-`VTW_BYTE_SIZE+i] = 1'b0;
      end


   endtask
   
   task optional_fields;

      input  [0:`VTW_COMMENT_SIZE-1] vector_comment;
      input  [0:`VTW_ID_SIZE-1]      vector_subr;
      output [0:2*`VTW_TEXT_SIZE]    opt_fields;
      reg    [0:2*`VTW_TEXT_SIZE]    opt_fields;

      begin
         opt_fields = "";
 	 if( !((vector_subr[0:7] == 8'd32) && (vector_subr[8:15] == 8'b0)) )
             opt_fields = {opt_fields,"[ ",vector_subr," ]"};
	 if( !((vector_comment[0:7] == 8'd32) && (vector_comment[8:15] == 8'b0)) )
             opt_fields = {opt_fields,"[ comment ",vector_comment," ]"};
      end

   endtask

endmodule // vtw_logger

`endif // !`ifdef _vtw_logger_v

