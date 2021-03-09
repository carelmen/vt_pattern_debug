/*
 * File:	clockgen.v
 * Author:	dima@testinsight.com
 * Created:	Tue Dec 23 2003
 * Copyright:	(c) 2003, Test Insight Ltd.
 *
 * Abstract:	Cycle clock generator
 *
 * $Id: clockgen.v,v 1.9 2015/10/12 09:27:13 sasha Exp $
 */


`ifdef _clockgen_v
`else
 `define _clockgen_v

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

module clockgen(tester_sync, delay, cur_vector_number, cur_cycle_number, cur_vector_comment, channel_sync, vector_number, cycle_number, vector_comment);

   // Interface
   input tester_sync;
   input [0:`VTW_DELAY_SIZE-1] delay;
   input [0:`VTW_INTEGER_SIZE-1] cur_vector_number;
   input [0:`VTW_INTEGER_SIZE-1] cur_cycle_number;
   input [0:`VTW_COMMENT_SIZE-1] cur_vector_comment;
   
   output channel_sync;
   output [0:`VTW_INTEGER_SIZE-1] vector_number;
   output [0:`VTW_INTEGER_SIZE-1] cycle_number;
   output [0:`VTW_COMMENT_SIZE-1] vector_comment;

   // Vector 
   
   // Internal constants
   `define CLKGEN_FIFO_DEPTH 32

   // Status
   reg 	 idle;

   // Delay variable
   reg [0:`VTW_DELAY_SIZE-1] delay_value;
   
   // Fifos
   reg [0:`VTW_DELAY_SIZE-1] fifo_memory [0:`CLKGEN_FIFO_DEPTH-1]; 
   reg [0:`VTW_DELAY_SIZE-1] time_memory [0:`CLKGEN_FIFO_DEPTH-1];
   reg [0:`VTW_INTEGER_SIZE-1] vector_memory [0:`CLKGEN_FIFO_DEPTH-1];
   reg [0:`VTW_INTEGER_SIZE-1] cycle_memory [0:`CLKGEN_FIFO_DEPTH-1];
   reg [0:`VTW_COMMENT_SIZE-1] comment_memory [0:`CLKGEN_FIFO_DEPTH-1];

   // Generated sync
   reg 			       channel_sync;
   reg [0:`VTW_INTEGER_SIZE-1] vector_number;
   reg [0:`VTW_INTEGER_SIZE-1] cycle_number;
   reg [0:`VTW_COMMENT_SIZE-1] vector_comment;
   
   // Fifo pointers
   integer 		      ptr_in;
   integer                    ptr_out;
   integer 		      ptr_out_old;

   // Events
   event 		      check;
   event 		      reschedule;
   
   initial
     begin
	idle    = 1;
	ptr_in  = 0;
	ptr_out = 0;
	vector_number = 0;
	cycle_number = 0;
	vector_comment = " ";
     end
	
   
   always @(posedge tester_sync /*or negedge tester_sync*/)
     begin
	if (tester_sync !== 1'bx)
	  begin
	     fifo_memory[ptr_in] = delay;
	     time_memory[ptr_in] = $time;
	     vector_memory[ptr_in] = cur_vector_number;
	     cycle_memory[ptr_in] = cur_cycle_number;
	     comment_memory[ptr_in] = cur_vector_comment;
	     ptr_in = (ptr_in + 1) % `CLKGEN_FIFO_DEPTH;
	     if(idle)
	       ->check;
	  end
     end

   
   always @(check)
     begin
	if(ptr_out != ptr_in)
	  begin
	     idle = 0;
	     delay_value = fifo_memory[ptr_out] - ($time - time_memory[ptr_out]);
	     ptr_out_old = ptr_out;
	     ptr_out = (ptr_out + 1) % `CLKGEN_FIFO_DEPTH;
	     #(delay_value*`VTW_PRECISION2UNIT_FACTOR);
	     vector_number = vector_memory[ptr_out_old];
	     cycle_number = cycle_memory[ptr_out_old];
	     vector_comment = comment_memory[ptr_out_old];
	     if(channel_sync === 1'bx)
	       channel_sync = 0;
	     else
	       channel_sync = !channel_sync;
	     ->reschedule;
	  end // if (ptr_out != ptr_in)
	else
	  idle = 1;
     end // always @ (check)

   always @(reschedule)
     begin
	#0;
	->check;
     end

endmodule // clockgen

`endif // !`ifdef _clockgen_v

