/*
 * File:	vtw_wfg.v
 * Author:	dima@testinsight.com
 * Created:	Tue Dec 23 2003
 * Copyright:	(c) 2003, Test Insight Ltd.
 *
 * Abstract:	Waveform generator code
 *
 * $Id: vtw_wfg.v,v 1.19 2019/05/29 12:56:48 dima Exp $
 */

`ifdef _vtw_wfg_v
`else
 `define _vtw_wfg_v

/* Setup */
`ifdef VTW_IGNORE_FAILURES
 `define VTW_WFG_COMPARE 0
`else
 `define VTW_WFG_COMPARE 1
`endif

`ifdef _test_hv
`else
 `include "test.hv"
`endif

`ifdef _stddef_hv
`else
 `include "vtw_stddef.hv"
`endif

`ifdef _wfgdef_hv
`else
 `include "vtw_wfgdef.hv"
`endif

`ifdef _logger_hv
`else
 `include "vtw_logger.hv"
`endif


/* Waveform generator module */
module vtw_wfg(tester_sync, cur_vector_number, cur_cycle_number, cur_vector_comment, channel_out, driver_state);

   input                               tester_sync;
   input [0:`VTW_INTEGER_SIZE-1]       cur_vector_number;
   input [0:`VTW_INTEGER_SIZE-1]       cur_cycle_number;
   input [0:`VTW_COMMENT_SIZE-1]       cur_vector_comment;
   input                               channel_out;
   input                               driver_state;			       

   reg 				       driver_on;
   reg                                 driver_off;
   reg 				       compare;
   reg                                 edge_strobe;
   
   // Waveform parameters
   reg [0:`VTW_TEXT_SIZE-1] 	       waveform;
   reg [0:`VTW_TEXT_SIZE-1] 	       signal;
   reg [0:`VTW_TEXT_SIZE-1] 	       pattern;

   // Memories
   reg [0:`VTW_DELAY_SIZE-1] 	          edge_timing [0:`VTW_CHANNEL_MAX_EDGES-1];
   reg [0:`VTW_CHANNEL_EDGE_DATA_SIZE-1]  edge_info   [0:`VTW_CHANNEL_MAX_EDGES-1];

   // Hardware
   reg 					  drive0;
   reg 					  drive1;
   reg 				          expected;

   // Temporary variables
   integer 				  edge_num;
   integer 				  i;
   integer                                compare_failed;
   real                                   edge_strobe_window;
   wire [0:`VTW_DELAY_SIZE-1] 		  first_delay;
   reg [0:`VTW_CHANNEL_EDGE_DATA_SIZE-1]  edge_params;
   
   // Wires
   wire 				  channel_sync;
   wire [0:`VTW_INTEGER_SIZE-1] 	  vector_number;
   wire [0:`VTW_INTEGER_SIZE-1] 	  cycle_number;
   wire [0:`VTW_COMMENT_SIZE-1]           vector_comment;
   

   // Initialization
   initial
     begin
	edge_strobe_window = 0;
        if ($value$plusargs("edge_strobe_window=%s", edge_strobe_window) == 0)
          edge_strobe_window = `VTW_EDGE_STROBE_WINDOW;
	compare = `VTW_FALSE;
	edge_strobe = `VTW_FALSE;
	drive0 = 1'bx;
	drive1 = 1'bx;
	expected = 1'bx;
     end

   task init_drive_registers;

      input integer edge_index;
      
      if( edge_index < edge_num )
	begin
	   
	   edge_params = edge_info[edge_index];

	   case(edge_params[`VTW_EDGE_ACTION_STATE_SELECT])
	     `VTW_EDGE_ACTION_DRIVE_LOW     : drive0 = ( drive0 === 1'b0 || drive0 === 1'b1 ) ? ~drive0 : 1'b0;
	     `VTW_EDGE_ACTION_DRIVE_HIGH    : drive1 = ( drive1 === 1'b0 || drive1 === 1'b1 ) ? ~drive1 : 1'b0;
	   endcase // case(edge_params[`VTW_EDGE_ACTION_STATE_SELECT])
	end
   endtask
   
   
   always @(posedge channel_sync or negedge channel_sync)
     begin

	if(channel_sync !== 1'bx)
	  begin
	     for(i=0; i < edge_num; i=i+1)
	       begin


		  edge_params = edge_info[i];
		  
		  if(i > 0) 
		    #((edge_timing[i] - edge_timing[i-1])*`VTW_PRECISION2UNIT_FACTOR);

		  init_drive_registers(i);
		  expected = 1'bx;
		  
 		  // Direction
		  if(edge_params[`VTW_EDGE_DRIVE_STATE_SELECT] === `VTW_EDGE_DRIVE_ON)
		    begin
		       compare = `VTW_FALSE;
		       driver_on = (driver_on === 1'b0 || driver_on === 1'b1 ) ? ~driver_on : 1'b0;
		    end
		  else if (edge_params[`VTW_EDGE_DRIVE_STATE_SELECT] == `VTW_EDGE_DRIVE_OFF)
		    begin
		       driver_off = (driver_off === 1'b0 || driver_off === 1'b1) ? ~driver_off : 1'b0;
		    end
		  
		  if(edge_params[`VTW_EDGE_DRIVE_STATE_SELECT] !== `VTW_EDGE_DRIVE_ON &&
		     edge_params[`VTW_EDGE_COMPARE_STATE_SELECT] === `VTW_EDGE_COMPARE_OFF )
		    compare = `VTW_FALSE;

		  if(edge_params[`VTW_EDGE_ACTION_STATE_SELECT] !== `VTW_EDGE_ACTION_NOP)
		    begin
		       
		       if(edge_params[`VTW_EDGE_ACTION_STATE_SELECT] === `VTW_EDGE_ACTION_DRIVE_LOW      ||
			  edge_params[`VTW_EDGE_ACTION_STATE_SELECT] === `VTW_EDGE_ACTION_DRIVE_HIGH)
			 begin
			 end
		       else if(edge_params[`VTW_EDGE_ACTION_STATE_SELECT] !== `VTW_EDGE_ACTION_NOP)
			 begin
			    start_compare(edge_params);
			    if(driver_state !== `VTW_FALSE)
			      `VTW_LOGGING.driver_on_compare_message(vector_number,cycle_number,waveform,signal,pattern);

			 end // if (edge_params[`VTW_EDGE_ACTION_STATE_SELECT] !== `VTW_EDGE_ACTION_NOP)

		       
		    end // if (edge_params[`VTW_EDGE_ACTION_STATE_SELECT] !== `VTW_EDGE_ACTION_NOP)

	       end // for (i=0; i < edge_num; i=i+1)
	  end // if (channel_sync !== 1'bx)
     end // always @ (posedge channel_sync or negedge channel_sync)

   
   always @(channel_out or negedge compare)
     begin
	if(compare === `VTW_TRUE)
	  if(compare_mismatch(channel_out, expected))
	    begin
	       compare = `VTW_ERROR;
	       `VTW_LOGGING.fail_message(vector_number, cycle_number, vector_comment, waveform, signal, pattern, channel_out, expected);
	    end
     end

   always @(posedge compare)
     begin
	if ( edge_strobe_window == 0)
	  #(`VTW_EDGE_STROBE_WINDOW*`VTW_TIMEUNIT_FACTOR);
	else
	  #(edge_strobe_window*`VTW_TIMEUNIT_FACTOR);
	if(compare_failed)
	  begin
	     if( edge_strobe === `VTW_FALSE )
	       compare = `VTW_ERROR;
	  end
	if( edge_strobe === `VTW_TRUE )
	  begin
	     compare = `VTW_FALSE;
	     edge_strobe = `VTW_FALSE;
	     expected = 1'bx;
	  end
     end
   
   // Wiring
   assign first_delay = edge_timing[0];

   clockgen clockgen(.tester_sync(tester_sync),
                     .cur_vector_number(cur_vector_number),
                     .cur_cycle_number(cur_cycle_number),
                     .cur_vector_comment(cur_vector_comment),
                     .delay(first_delay), 
                     .channel_sync(channel_sync),
                     .vector_number(vector_number),
                     .cycle_number(cycle_number),
                     .vector_comment(vector_comment));


   task start_compare;

      input [0:`VTW_CHANNEL_EDGE_DATA_SIZE-1]  compare_params;
      
      begin

	 case(compare_params[`VTW_EDGE_ACTION_STATE_SELECT])
	   `VTW_EDGE_ACTION_COMPARE_LOW   : expected = 1'b0;
	   `VTW_EDGE_ACTION_COMPARE_HIGH  : expected = 1'b1;
	   `VTW_EDGE_ACTION_COMPARE_MID   : expected = 1'bz;
	   default:                         expected = 1'bx;
	 endcase // case(edge_params[`VTW_EDGE_ACTION_STATE_SELECT])

	 if(compare_params[`VTW_EDGE_COMPARE_STATE_SELECT] === `VTW_EDGE_COMPARE_NOP)
	   begin
	      edge_strobe = `VTW_TRUE;
	   end
	 else
	   begin
	      edge_strobe = `VTW_FALSE;
	   end
	 
	 if( expected !== 1'bx )
	   begin
	      `VTW_LOGGING.compare_number = `VTW_LOGGING.compare_number + 1;
	      compare = `VTW_TRUE;
	      compare_failed = compare_mismatch(channel_out, expected);
	      if(compare_failed)
		begin
		   `VTW_LOGGING.fail_message(vector_number, cycle_number, vector_comment, waveform, signal, pattern, 
					     channel_out, expected);
	      
		end
	   end // if ( expected !== 1'bx )
	 
      end
   endtask
   

   function compare_mismatch;
      input real_data;
      input expected_data;
      
      begin

	 if( (expected_data !== 1'bx) && (real_data !== expected_data) && `VTW_WFG_COMPARE)
	   begin
	      compare_mismatch = `VTW_TRUE;
	   end
	 else
	   begin
	      compare_mismatch = `VTW_FALSE;
	   end

      end
   endfunction
   
endmodule // channel

`endif
