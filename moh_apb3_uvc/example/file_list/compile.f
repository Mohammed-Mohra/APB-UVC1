-64
-uvmhome $UVMHOME
-timescale 1ns/1ns

-f $S5S_T/ip/ascii_processor/etc/moh_apb3_uvc/file_list/compile.f

-incdir $S5S_T/ip/ascii_processor/etc/moh_apb3_uvc/example/sv/env/
-incdir $S5S_T/ip/ascii_processor/etc/moh_apb3_uvc/example/sv/test/

$S5S_T/ip/ascii_processor/etc/moh_apb3_uvc/example/sv/env/moh_apb_example_pkg.sv
$S5S_T/ip/ascii_processor/etc/moh_apb3_uvc/example/sv/tb/clkgen.sv
$S5S_T/ip/ascii_processor/etc/moh_apb3_uvc/example/sv/tb/moh_hw_top.sv
$S5S_T/ip/ascii_processor/etc/moh_apb3_uvc/example/sv/tb/top.sv
