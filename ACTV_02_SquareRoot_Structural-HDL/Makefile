ROOT       = $(CURDIR)
RTL_DIR    = ${ROOT}/HDL
TESTS_DIR  = ${ROOT}/Testbenchs
GUI        ?= 0
TB         ?= 1
ifeq ($(GUI),1)
	FLAGS += -gui
endif

CLA:
	cd ${ROOT}/Work && \
	if [ "$(TB)" = "0" ]; then \
		xrun -v2001 ${RTL_DIR}/Described_HDLs/CLA.v $(FLAGS); \
	else \
		xrun -v2001 ${RTL_DIR}/Described_HDLs/CLA.v ${TESTS_DIR}/CLA_16bits_tb.sv $(FLAGS) +define+CLAFULL; \
	fi

CLA2x8:
	cd ${ROOT}/Work && \
	if [ "$(TB)" = "0" ]; then \
		xrun -v2001 ${RTL_DIR}/Described_HDLs/CLA2x8.v $(FLAGS); \
	else \
		xrun -v2001 ${RTL_DIR}/Described_HDLs/CLA.v ${RTL_DIR}/Described_HDLs/CLA2x8.v ${TESTS_DIR}/CLA_16bits_tb.sv $(FLAGS) +define+CLA2x8; \
	fi

CLA4x4:
	cd ${ROOT}/Work && \
	if [ "$(TB)" = "0" ]; then \
		xrun -v2001 ${RTL_DIR}/Described_HDLs/CLA4x4.v $(FLAGS); \
	else \
		xrun -v2001 ${RTL_DIR}/Described_HDLs/CLA.v ${RTL_DIR}/Described_HDLs/CLA4x4.v ${TESTS_DIR}/CLA_16bits_tb.sv $(FLAGS) +define+CLA4x4; \
	fi

ControlPath:
	cd ${ROOT}/Work && \
	if [ "$(TB)" = "0" ]; then \
		xrun -v2001 ${RTL_DIR}/Described_HDLs/ControlPath.v $(FLAGS); \
	else \
		xrun -v2001 ${RTL_DIR}/Described_HDLs/ControlPath.v ${TESTS_DIR}/ControlPath_tb.sv $(FLAGS); \
	fi