+-----------------------------------+
|              APB UVC              |
+-----------------------------------+

|Author  : Mohammed Mohra           |
|Date    : 23.11.2023               |
|Contact : mohammed.mohra@5.systems |
|Version : 1.0                      |
+-----------------------------------+

The implemented APB UVC is fully compliant to AMBA APB3 specification.
It support both Requester and Completer functionalities along with
comprehensive functional coverage.

+-----------------------------------+
|        Directory structure        |
+-----------------------------------+

  -moh_apb3_uvc
    -etc
      -README.txt
    -example
      -file_list
        -compile.f
      -rundir
        -makefile
      -scripts
        -makefile
      -sv
        -env
          -moh_apb_base_test.sv
          -moh_apb_example_env.sv
          -moh_apb_example_pkg.sv
          -moh_apb_virtual_sequence.sv
          -moh_apb_virtual_sequencer.sv
          -uvm_test_lib.sv
        -tb       
          -clkgen.sv
          -moh_hw_top.sv
          -top.sv
        -test
          -example_test.svh
    -file_list
      -compile.f
    -sv
      -moh_apb_completer_agent.sv
      -moh_apb_completer_driver.sv
      -moh_apb_completer_sequence_lib.sv
      -moh_apb_completer_sequencer.sv
      -moh_apb_config_class.sv
      -moh_apb_env.sv
      -moh_apb_if.sv
      -moh_apb_monitor.sv
      -moh_apb_pkg.sv
      -moh_apb_requester_agent.sv
      -moh_apb_requester_driver.sv
      -moh_apb_requester_sequence_lib.sv
      -moh_apb_requester_sequencer.sv
      -moh_apb_seq_item.sv
      -moh_apb_types.svh

+-----------------------------------+
|              Example              |
+-----------------------------------+

The example directory has an example test and an example environment to perform a back-to-back test
To run the test go into moh_apb3_uvc/example/rundir and run command: 
make run TEST=example_test

This will run an example test that performs a back to back test, and it will run a simulation for the APB3 protocol. 
