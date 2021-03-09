`ifdef _Pattern0_v
`else
`define _Pattern0_v
`ifdef _alldef_hv
`else
`include "vtw_alldef.hv"
`endif
module Pattern0(
                I2C_SCL,
                I2C_SDA
               );

  inout  I2C_SCL;
  inout  I2C_SDA;
  
  `define PATTERN0_PATTERN_MEMORY_SIZE 3527
  
  reg tester_sync;
  reg [0:3] wft;
  reg [0:`VTW_COMMENT_SIZE-1] vector_comment;
  reg [0:`VTW_ID_SIZE-1] vector_subr;
  reg [0:2047] wft_names [0:0];
  reg [0:`VTW_TEXT_SIZE-1] waveform_table;
  reg [0:15] wfc;
  reg [0:51] image [0:`PATTERN0_PATTERN_MEMORY_SIZE-1];
  reg [0:51] vector;
  reg [0:2543] image_params [0:`PATTERN0_PATTERN_MEMORY_SIZE-1];
  reg [0:31] global_params [0:1];
  reg [0:2543] vector_params;
  reg [2047:0] pat_name;
  integer pat_name_fp;
  integer pat_name_cnt;
  integer vector_count;
  integer vector_index;
  event   start;
  integer vector_memory_size;
  integer jump_address;
  integer vector_number;
  integer opcode;
  integer opcode_params;
  integer repeat_count;
  integer cycle_number;
  integer period;
  integer initial_fail_number;
  reg failed;
  event finished;
  reg vectors_exhausted;
  reg shutdown;
  reg breakpoint;
  reg [0:`VTW_TEXT_SIZE-1] str_buffer;
  
  task finalize;
    begin
      tester_control.finalize;
      failed = (`VTW_LOGGING.fail_number - initial_fail_number) > 0;
      -> finished;
      shutdown = 1;
    end
  endtask
  
  Pattern0_timing tester_control(.tester_sync(tester_sync),
                                 .cycle_number(cycle_number),
                                 .vector_number(vector_number),
                                 .vector_comment(vector_comment),
                                 .wft(wft),
                                 .wfc(wfc),
                                 .I2C_SCL(I2C_SCL),
                                 .I2C_SDA(I2C_SDA)
                                );
                                
  task execute;
    begin
      vectors_exhausted = `VTW_FALSE;
      shutdown   = `VTW_FALSE;
      breakpoint = `VTW_FALSE;
      initial_fail_number = `VTW_LOGGING.fail_number;
      wfc = 0;
      wft = 0;
      vector_index = 0;
      cycle_number = 0;
      vector_number = 0;
      opcode_params = 0;
      repeat_count  = 0;
      opcode       = 0;
      tester_control.initialize;
      image[0] = {52{1'bx}};
      $readmemh({`VTW_TEST_MEMORY_DIR,"/vectors/Pattern0_pattern.bin"},image);
      if(image[0] === {52{1'bx}}) begin
          `VTW_LOGGING.error_message({"can't load tester memory from ",`VTW_TEST_MEMORY_DIR,"/vectors/Pattern0_pattern.bin"});
          $finish;
      end
      image_params[0] = {2544{1'bx}};
      $readmemh({`VTW_TEST_MEMORY_DIR,"/vectors/Pattern0_pattern_params.bin"},image_params);
      if(image_params[0] === {2544{1'bx}}) begin
          `VTW_LOGGING.error_message({"can't load auxiliary tester memory from ",`VTW_TEST_MEMORY_DIR,"/vectors/Pattern0_pattern_params.bin"});
          $finish;
      end
      global_params[0] = {32{1'bx}};
      $readmemh({`VTW_TEST_MEMORY_DIR,"/Pattern0_globals.bin"},global_params);
      if(global_params[0] === {32{1'bx}}) begin
          `VTW_LOGGING.error_message({"can't load global paremeters tester memory from ",`VTW_TEST_MEMORY_DIR,"/Pattern0_globals.bin"});
          $finish;
      end
      wft_names[0] = {2048{1'bx}};
      $readmemh({`VTW_TEST_MEMORY_DIR,"/Pattern0_wfts.bin"},wft_names);
      if(wft_names[0] === {2048{1'bx}}) begin
          `VTW_LOGGING.error_message({"can't load wft names from ",`VTW_TEST_MEMORY_DIR,"/Pattern0_wfts.bin"});
          $finish;
      end
      pat_name_fp = $fopen({`VTW_TEST_MEMORY_DIR,"/Pattern0.bin"},"r");
      if(pat_name_fp == 0) begin
          `VTW_LOGGING.error_message({"can't load pattern name from ",`VTW_TEST_MEMORY_DIR,"/Pattern0.bin"});
          $finish;
      end
      pat_name_cnt = $fscanf(pat_name_fp,"%x\n",pat_name);
      $fclose(pat_name_fp);
  
      vector_count = global_params[0];
      vector_memory_size = global_params[1];
      tester_sync = 1'b0;
      while (!shutdown && vector_index < vector_memory_size) begin
        vector = image[vector_index];
        vector_params = image_params[vector_index];
        wft    = vector[0:3];
        wfc    = vector[36:51];
        period = vector[4:35];
        vector_number = vector_params[0:31];
        vector_comment = vector_params[96:2143];
        vector_subr = vector_params[2144:2543];
        opcode         = vector_params[32:63];
        if(opcode & 2)
           begin
             breakpoint        = `VTW_TRUE;
             vectors_exhausted = `VTW_TRUE;
             -> finished;
        end
        if(!breakpoint && vectors_exhausted)
           finalize;
        else
          begin
            waveform_table = wft_names[wft];
            if(!breakpoint)
               begin
                 if (cycle_number % `VTW_LOG_EVERY_VECTOR == 0)
              `VTW_LOGGING.vector_info_message(vector_number,cycle_number,waveform_table,pat_name,vector_comment,vector_subr);
               end
            if(!shutdown)
              begin
                tester_sync = `VTW_TRUE;
                opcode        = vector_params[32:63];
                opcode_params = vector_params[64:95];
                if( opcode & 1)
                  repeat_count = opcode_params;
                else
                  repeat_count = 1;
                #(period/2*`VTW_PRECISION2UNIT_FACTOR);
                tester_sync = 1'b0;
                #((period - period/2)*`VTW_PRECISION2UNIT_FACTOR);
                if(opcode & 1 && opcode_params > 0)
                  begin
                    opcode_params = opcode_params - 1;
                    if( opcode_params !== 0 )
                      begin
                        vector_params[64:95] = opcode_params;
                        image_params[vector_index] = vector_params;
                      end
                    else
                      begin
                        vector_index = vector_index + 1;
                      end
                  end
                else
                  begin
                    if(opcode & 2)
                      begin
                        jump_address = vector_index;
                        breakpoint   = `VTW_TRUE;
                        vectors_exhausted = `VTW_TRUE;
                        -> finished;
                      end
                    if(opcode & 4)
                      vector_index = jump_address;
                    else
                      vector_index = vector_index + 1;
                  end
                if(!shutdown)
                  begin
                    cycle_number = cycle_number + 1;
                    if(vector_index == vector_count)
                       begin
                         vectors_exhausted = `VTW_TRUE;
                         -> finished;
                       end
                  end
              end
            end
        end
    end
  endtask
  always @(start)
      begin
        execute;
      end
  
  always @(finished)
      begin
        pat_name = {2048{1'bx}};
      end
  
endmodule
`endif
