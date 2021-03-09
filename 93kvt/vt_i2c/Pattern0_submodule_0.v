`ifdef _Pattern0_submodule_0_v
`else
`define _Pattern0_submodule_0_v
`ifdef _alldef_hv
`else
`include "vtw_alldef.hv"
`endif
module Pattern0_submodule_0;

  // Signal I2C_SCL
  wire       I2C_SCL_tester_comparator;
  
  // Signal I2C_SDA
  wire       I2C_SDA_tester_comparator;
  
  reg initialized;
  reg [0:63] timing_rec;
  integer timing_fp;
  integer timing_read_cnt;
  integer edge_index;
  reg [2047:0] pat_name;
  integer pat_name_fp;
  integer pat_name_cnt;
  // Signal I2C_SCL
  vtw_wfg I2C_SCL_0_wfg(.tester_sync(`VTW_TESTER.Pattern0.tester_control.triggers[0]),
              .cur_vector_number(`VTW_TESTER.Pattern0.tester_control.vector_number),
              .cur_cycle_number(`VTW_TESTER.Pattern0.tester_control.cycle_number),
              .cur_vector_comment(`VTW_TESTER.Pattern0.tester_control.vector_comment),
              .channel_out(`VTW_TESTER.Pattern0.tester_control.I2C_SCL),
              .driver_state(`VTW_TESTER.I2C_SCL_driver));
  vtw_wfg I2C_SCL_1_wfg(.tester_sync(`VTW_TESTER.Pattern0.tester_control.triggers[1]),
              .cur_vector_number(`VTW_TESTER.Pattern0.tester_control.vector_number),
              .cur_cycle_number(`VTW_TESTER.Pattern0.tester_control.cycle_number),
              .cur_vector_comment(`VTW_TESTER.Pattern0.tester_control.vector_comment),
              .channel_out(`VTW_TESTER.Pattern0.tester_control.I2C_SCL),
              .driver_state(`VTW_TESTER.I2C_SCL_driver));
  
  // Signal I2C_SDA
  vtw_wfg I2C_SDA_0_wfg(.tester_sync(`VTW_TESTER.Pattern0.tester_control.triggers[2]),
              .cur_vector_number(`VTW_TESTER.Pattern0.tester_control.vector_number),
              .cur_cycle_number(`VTW_TESTER.Pattern0.tester_control.cycle_number),
              .cur_vector_comment(`VTW_TESTER.Pattern0.tester_control.vector_comment),
              .channel_out(`VTW_TESTER.Pattern0.tester_control.I2C_SDA),
              .driver_state(`VTW_TESTER.I2C_SDA_driver));
  vtw_wfg I2C_SDA_1_wfg(.tester_sync(`VTW_TESTER.Pattern0.tester_control.triggers[3]),
              .cur_vector_number(`VTW_TESTER.Pattern0.tester_control.vector_number),
              .cur_cycle_number(`VTW_TESTER.Pattern0.tester_control.cycle_number),
              .cur_vector_comment(`VTW_TESTER.Pattern0.tester_control.vector_comment),
              .channel_out(`VTW_TESTER.Pattern0.tester_control.I2C_SDA),
              .driver_state(`VTW_TESTER.I2C_SDA_driver));
  vtw_wfg I2C_SDA_2_wfg(.tester_sync(`VTW_TESTER.Pattern0.tester_control.triggers[4]),
              .cur_vector_number(`VTW_TESTER.Pattern0.tester_control.vector_number),
              .cur_cycle_number(`VTW_TESTER.Pattern0.tester_control.cycle_number),
              .cur_vector_comment(`VTW_TESTER.Pattern0.tester_control.vector_comment),
              .channel_out(`VTW_TESTER.Pattern0.tester_control.I2C_SDA),
              .driver_state(`VTW_TESTER.I2C_SDA_driver));
  vtw_wfg I2C_SDA_3_wfg(.tester_sync(`VTW_TESTER.Pattern0.tester_control.triggers[5]),
              .cur_vector_number(`VTW_TESTER.Pattern0.tester_control.vector_number),
              .cur_cycle_number(`VTW_TESTER.Pattern0.tester_control.cycle_number),
              .cur_vector_comment(`VTW_TESTER.Pattern0.tester_control.vector_comment),
              .channel_out(`VTW_TESTER.Pattern0.tester_control.I2C_SDA),
              .driver_state(`VTW_TESTER.I2C_SDA_driver));
  vtw_wfg I2C_SDA_4_wfg(.tester_sync(`VTW_TESTER.Pattern0.tester_control.triggers[6]),
              .cur_vector_number(`VTW_TESTER.Pattern0.tester_control.vector_number),
              .cur_cycle_number(`VTW_TESTER.Pattern0.tester_control.cycle_number),
              .cur_vector_comment(`VTW_TESTER.Pattern0.tester_control.vector_comment),
              .channel_out(`VTW_TESTER.Pattern0.tester_control.I2C_SDA),
              .driver_state(`VTW_TESTER.I2C_SDA_driver));
  
  task initialize;
    begin
      if(initialized !== `VTW_TRUE) begin
        pat_name_fp = $fopen({`VTW_TEST_MEMORY_DIR,"/Pattern0.bin"},"r");
        if(pat_name_fp == 0) begin
            `VTW_LOGGING.error_message({"can't load pattern name from ",`VTW_TEST_MEMORY_DIR,"/Pattern0.bin"});
            $finish;
        end
        pat_name_cnt = $fscanf(pat_name_fp,"%x\n",pat_name);
        $fclose(pat_name_fp);
        
        // Signal I2C_SCL
        timing_fp = $fopen({`VTW_TEST_MEMORY_DIR,"/timing/Pattern0_I2C_SCL_pin_timing.bin"},"r");
        if(timing_fp == 0) begin
            `VTW_LOGGING.error_message({"can't load signal timing from ",`VTW_TEST_MEMORY_DIR,"/timing/Pattern0_I2C_SCL_pin_timing.bin"});
            $finish;
        end
        
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SCL_0_wfg.waveform = timing_rec[56:63];
        I2C_SCL_0_wfg.signal = "I2C_SCL";
        I2C_SCL_0_wfg.pattern = pat_name;
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SCL_0_wfg.edge_num = timing_rec;
        for(edge_index=0; edge_index < I2C_SCL_0_wfg.edge_num; edge_index=edge_index+1)
          begin
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SCL_0_wfg.edge_timing[edge_index] = timing_rec + `I2C_SCL_BOARD_DELAY;
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SCL_0_wfg.edge_info[edge_index] = timing_rec[52:63];
          end
        
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SCL_1_wfg.waveform = timing_rec[56:63];
        I2C_SCL_1_wfg.signal = "I2C_SCL";
        I2C_SCL_1_wfg.pattern = pat_name;
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SCL_1_wfg.edge_num = timing_rec;
        for(edge_index=0; edge_index < I2C_SCL_1_wfg.edge_num; edge_index=edge_index+1)
          begin
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SCL_1_wfg.edge_timing[edge_index] = timing_rec + `I2C_SCL_BOARD_DELAY;
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SCL_1_wfg.edge_info[edge_index] = timing_rec[52:63];
          end
        
        $fclose(timing_fp);
        
        // Signal I2C_SDA
        timing_fp = $fopen({`VTW_TEST_MEMORY_DIR,"/timing/Pattern0_I2C_SDA_pin_timing.bin"},"r");
        if(timing_fp == 0) begin
            `VTW_LOGGING.error_message({"can't load signal timing from ",`VTW_TEST_MEMORY_DIR,"/timing/Pattern0_I2C_SDA_pin_timing.bin"});
            $finish;
        end
        
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_0_wfg.waveform = timing_rec[56:63];
        I2C_SDA_0_wfg.signal = "I2C_SDA";
        I2C_SDA_0_wfg.pattern = pat_name;
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_0_wfg.edge_num = timing_rec;
        for(edge_index=0; edge_index < I2C_SDA_0_wfg.edge_num; edge_index=edge_index+1)
          begin
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_0_wfg.edge_timing[edge_index] = timing_rec + `I2C_SDA_BOARD_DELAY;
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_0_wfg.edge_info[edge_index] = timing_rec[52:63];
          end
        
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_1_wfg.waveform = timing_rec[56:63];
        I2C_SDA_1_wfg.signal = "I2C_SDA";
        I2C_SDA_1_wfg.pattern = pat_name;
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_1_wfg.edge_num = timing_rec;
        for(edge_index=0; edge_index < I2C_SDA_1_wfg.edge_num; edge_index=edge_index+1)
          begin
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_1_wfg.edge_timing[edge_index] = timing_rec + `I2C_SDA_BOARD_DELAY;
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_1_wfg.edge_info[edge_index] = timing_rec[52:63];
          end
        
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_2_wfg.waveform = timing_rec[56:63];
        I2C_SDA_2_wfg.signal = "I2C_SDA";
        I2C_SDA_2_wfg.pattern = pat_name;
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_2_wfg.edge_num = timing_rec;
        for(edge_index=0; edge_index < I2C_SDA_2_wfg.edge_num; edge_index=edge_index+1)
          begin
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_2_wfg.edge_timing[edge_index] = timing_rec + `I2C_SDA_BOARD_DELAY;
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_2_wfg.edge_info[edge_index] = timing_rec[52:63];
          end
        
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_3_wfg.waveform = timing_rec[56:63];
        I2C_SDA_3_wfg.signal = "I2C_SDA";
        I2C_SDA_3_wfg.pattern = pat_name;
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_3_wfg.edge_num = timing_rec;
        for(edge_index=0; edge_index < I2C_SDA_3_wfg.edge_num; edge_index=edge_index+1)
          begin
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_3_wfg.edge_timing[edge_index] = timing_rec + `I2C_SDA_BOARD_DELAY;
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_3_wfg.edge_info[edge_index] = timing_rec[52:63];
          end
        
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_4_wfg.waveform = timing_rec[56:63];
        I2C_SDA_4_wfg.signal = "I2C_SDA";
        I2C_SDA_4_wfg.pattern = pat_name;
        timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
        I2C_SDA_4_wfg.edge_num = timing_rec;
        for(edge_index=0; edge_index < I2C_SDA_4_wfg.edge_num; edge_index=edge_index+1)
          begin
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_4_wfg.edge_timing[edge_index] = timing_rec + `I2C_SDA_BOARD_DELAY;
            timing_read_cnt = $fscanf(timing_fp,"%x\n",timing_rec);
            I2C_SDA_4_wfg.edge_info[edge_index] = timing_rec[52:63];
          end
        
        $fclose(timing_fp);
        
        initialized = `VTW_TRUE;
      end
    end
  endtask
  // Signal I2C_SCL driver control
  always @(I2C_SCL_0_wfg.driver_on)
    `VTW_TESTER.I2C_SCL_driver = `VTW_TRUE;
  always @(I2C_SCL_0_wfg.driver_off)
    `VTW_TESTER.I2C_SCL_driver = `VTW_FALSE;
  always @(I2C_SCL_0_wfg.drive0)
    `VTW_TESTER.I2C_SCL_driver_data = 1'b0;
  always @(I2C_SCL_0_wfg.drive1)
    `VTW_TESTER.I2C_SCL_driver_data = 1'b1;
  always @(I2C_SCL_1_wfg.driver_on)
    `VTW_TESTER.I2C_SCL_driver = `VTW_TRUE;
  always @(I2C_SCL_1_wfg.driver_off)
    `VTW_TESTER.I2C_SCL_driver = `VTW_FALSE;
  always @(I2C_SCL_1_wfg.drive0)
    `VTW_TESTER.I2C_SCL_driver_data = 1'b0;
  always @(I2C_SCL_1_wfg.drive1)
    `VTW_TESTER.I2C_SCL_driver_data = 1'b1;
  
  // Signal I2C_SDA driver control
  always @(I2C_SDA_0_wfg.driver_on)
    `VTW_TESTER.I2C_SDA_driver = `VTW_TRUE;
  always @(I2C_SDA_0_wfg.driver_off)
    `VTW_TESTER.I2C_SDA_driver = `VTW_FALSE;
  always @(I2C_SDA_0_wfg.drive0)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b0;
  always @(I2C_SDA_0_wfg.drive1)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b1;
  always @(I2C_SDA_1_wfg.driver_on)
    `VTW_TESTER.I2C_SDA_driver = `VTW_TRUE;
  always @(I2C_SDA_1_wfg.driver_off)
    `VTW_TESTER.I2C_SDA_driver = `VTW_FALSE;
  always @(I2C_SDA_1_wfg.drive0)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b0;
  always @(I2C_SDA_1_wfg.drive1)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b1;
  always @(I2C_SDA_2_wfg.driver_on)
    `VTW_TESTER.I2C_SDA_driver = `VTW_TRUE;
  always @(I2C_SDA_2_wfg.driver_off)
    `VTW_TESTER.I2C_SDA_driver = `VTW_FALSE;
  always @(I2C_SDA_2_wfg.drive0)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b0;
  always @(I2C_SDA_2_wfg.drive1)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b1;
  always @(I2C_SDA_3_wfg.driver_on)
    `VTW_TESTER.I2C_SDA_driver = `VTW_TRUE;
  always @(I2C_SDA_3_wfg.driver_off)
    `VTW_TESTER.I2C_SDA_driver = `VTW_FALSE;
  always @(I2C_SDA_3_wfg.drive0)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b0;
  always @(I2C_SDA_3_wfg.drive1)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b1;
  always @(I2C_SDA_4_wfg.driver_on)
    `VTW_TESTER.I2C_SDA_driver = `VTW_TRUE;
  always @(I2C_SDA_4_wfg.driver_off)
    `VTW_TESTER.I2C_SDA_driver = `VTW_FALSE;
  always @(I2C_SDA_4_wfg.drive0)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b0;
  always @(I2C_SDA_4_wfg.drive1)
    `VTW_TESTER.I2C_SDA_driver_data = 1'b1;
  
  // Signal I2C_SCL expected control
  always @(negedge `VTW_TESTER.I2C_SCL_comparator)
    begin
      if(`VTW_TESTER.I2C_SCL_comparator === 1'b0)
        `VTW_TESTER.I2C_SCL_expected = 1'bx;
    end
  always @(I2C_SCL_0_wfg.expected)
    begin
      `VTW_TESTER.I2C_SCL_expected = I2C_SCL_0_wfg.expected;
    end
  always @(I2C_SCL_1_wfg.expected)
    begin
      `VTW_TESTER.I2C_SCL_expected = I2C_SCL_1_wfg.expected;
    end
  
  // Signal I2C_SDA expected control
  always @(negedge `VTW_TESTER.I2C_SDA_comparator)
    begin
      if(`VTW_TESTER.I2C_SDA_comparator === 1'b0)
        `VTW_TESTER.I2C_SDA_expected = 1'bx;
    end
  always @(I2C_SDA_0_wfg.expected)
    begin
      `VTW_TESTER.I2C_SDA_expected = I2C_SDA_0_wfg.expected;
    end
  always @(I2C_SDA_1_wfg.expected)
    begin
      `VTW_TESTER.I2C_SDA_expected = I2C_SDA_1_wfg.expected;
    end
  always @(I2C_SDA_2_wfg.expected)
    begin
      `VTW_TESTER.I2C_SDA_expected = I2C_SDA_2_wfg.expected;
    end
  always @(I2C_SDA_3_wfg.expected)
    begin
      `VTW_TESTER.I2C_SDA_expected = I2C_SDA_3_wfg.expected;
    end
  always @(I2C_SDA_4_wfg.expected)
    begin
      `VTW_TESTER.I2C_SDA_expected = I2C_SDA_4_wfg.expected;
    end
  
  // Signal I2C_SCL comparator signal
  assign (strong1,weak0) I2C_SCL_tester_comparator = I2C_SCL_0_wfg.compare | I2C_SCL_1_wfg.compare;
  always @(I2C_SCL_tester_comparator)
    begin
      `VTW_TESTER.I2C_SCL_comparator = I2C_SCL_tester_comparator;
    end
  
  // Signal I2C_SDA comparator signal
  assign (strong1,weak0) I2C_SDA_tester_comparator = I2C_SDA_0_wfg.compare | I2C_SDA_1_wfg.compare | I2C_SDA_2_wfg.compare | 
                                                     I2C_SDA_3_wfg.compare | I2C_SDA_4_wfg.compare;
  always @(I2C_SDA_tester_comparator)
    begin
      `VTW_TESTER.I2C_SDA_comparator = I2C_SDA_tester_comparator;
    end
  
endmodule // Pattern0_submodule_0
`endif
