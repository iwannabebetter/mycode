# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {

}

proc update_PARAM_VALUE.I2S_SENDER_TEST_DATA_WIDTH { PARAM_VALUE.I2S_SENDER_TEST_DATA_WIDTH } {
	# Procedure called to update I2S_SENDER_TEST_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.I2S_SENDER_TEST_DATA_WIDTH { PARAM_VALUE.I2S_SENDER_TEST_DATA_WIDTH } {
	# Procedure called to validate I2S_SENDER_TEST_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.I2S_RECEIVER_NUM { PARAM_VALUE.I2S_RECEIVER_NUM } {
	# Procedure called to update I2S_RECEIVER_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.I2S_RECEIVER_NUM { PARAM_VALUE.I2S_RECEIVER_NUM } {
	# Procedure called to validate I2S_RECEIVER_NUM
	return true
}


proc update_MODELPARAM_VALUE.I2S_RECEIVER_NUM { MODELPARAM_VALUE.I2S_RECEIVER_NUM PARAM_VALUE.I2S_RECEIVER_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.I2S_RECEIVER_NUM}] ${MODELPARAM_VALUE.I2S_RECEIVER_NUM}
}

proc update_MODELPARAM_VALUE.I2S_SENDER_TEST_DATA_WIDTH { MODELPARAM_VALUE.I2S_SENDER_TEST_DATA_WIDTH PARAM_VALUE.I2S_SENDER_TEST_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.I2S_SENDER_TEST_DATA_WIDTH}] ${MODELPARAM_VALUE.I2S_SENDER_TEST_DATA_WIDTH}
}

