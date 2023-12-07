TB_DIR                 = ${S5S_T}/ip/ascii_processor/etc/moh_apb3_uvc/example

VERBOSITY        = UVM_HIGH
EXTRA_OPTS       = +UVM_VERBOSITY=${VERBOSITY}
TEST             = example_test

COMPILE_RESULT   = ${TB_DIR}/rundir/compile.log
COMPILE_COMMAND  = xrun -64bit -uvm -f ${TB_DIR}/file_list/compile.f +access+rwc +timescale=1ns/100ps -c -l ${COMPILE_RESULT}
RUN_RESULT       = ${TB_DIR}/rundir/run.log
RUN_COMMAND_SIM      = xrun -64bit -R -l ${RUN_RESULT} -gui  +UVM_TESTNAME=${TEST}   +timescale=1ns/100ps 
RUN_COMMAND_NO_SIM   = xrun -64bit -R -l ${RUN_RESULT}       +UVM_TESTNAME=${TEST}   +timescale=1ns/100ps 

${COMPILE_RESULT}:
	${COMPILE_COMMAND}

compile: ${COMPILE_RESULT}

.PHONY:${RUN_RESULT}
${RUN_RESULT}: ${COMPILE_RESULT}
	${RUN_COMMAND_NO_SIM}

run: ${RUN_RESULT}

.PHONY:${RUN_RESULT}
${RUN_RESULT}: ${COMPILE_RESULT}
	${RUN_COMMAND_SIM}

run_sim: ${RUN_RESULT}

clean:
	rm -rf `ls --ignore=makefile --ignore=.default --almost-all`
