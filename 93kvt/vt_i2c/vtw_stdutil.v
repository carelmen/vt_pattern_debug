/*
 * File:	vtw_stdutil.v
 * Author:	dima@testinsight.com
 * Created:	Wed Dec 23 2015
 * Copyright:	(c) 2015, Test Insight Ltd.
 *
 * Abstract:	Standard Verilog utilities
 *
 * $Id: vtw_stdutil.v,v 1.2 2019/05/07 09:35:05 dima Exp $
 */

`ifdef _vtw_stdutil_v
`else
 `define _vtw_stdutil_v

`ifdef _test_hv
`else
 `include "test.hv"
`endif

`ifdef _stddef_hv
`else
 `include "vtw_stddef.hv"
`endif


module vtw_stdutil;

   reg [0:`VTW_PATH_SIZE-1] vtw_test_memory_dir;

   task initialize;

      begin
	if ($value$plusargs("vtw_test_memory_dir=%s", vtw_test_memory_dir) == 0)
  	   vtw_test_memory_dir = `VTW_TEST_MEMORY_DEFAULT_DIR;
      end

   endtask

endmodule // vtw_stdutil

`endif // !`ifdef _vtw_stdutil_v
