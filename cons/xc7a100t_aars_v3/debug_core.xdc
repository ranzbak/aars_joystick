set_property MARK_DEBUG false [get_nets joy_test/JS_CS_OBUF]
set_property MARK_DEBUG false [get_nets joy_test/JS_INTA_IBUF]
set_property MARK_DEBUG false [get_nets joy_test/JS_MOSI_OBUF]
set_property MARK_DEBUG false [get_nets joy_test/JS_SCK_OBUF]
set_property MARK_DEBUG false [get_nets joy_test/RX_DV]
set_property MARK_DEBUG true [get_nets reset]
set_property MARK_DEBUG true [get_nets locked]
set_property MARK_DEBUG true [get_nets JS_CS_OBUF]
set_property MARK_DEBUG true [get_nets JS_INTA_IBUF]
set_property MARK_DEBUG true [get_nets JS_MISO_IBUF]
set_property MARK_DEBUG true [get_nets JS_MOSI_OBUF]
set_property MARK_DEBUG true [get_nets JS_SCK_OBUF]
set_property MARK_DEBUG true [get_nets RESET_N_IBUF]
set_property MARK_DEBUG true [get_nets {joy_test/mcp_state[0]}]
set_property MARK_DEBUG true [get_nets {joy_test/mcp_state[1]}]
set_property MARK_DEBUG true [get_nets {joy_test/mcp_state[2]}]






set_property MARK_DEBUG true [get_nets joy_test/joy_spi_master/tx_wait]
set_property MARK_DEBUG true [get_nets joy_test/joy_spi_master/TX_Ready]
set_property MARK_DEBUG true [get_nets {joy_test/tx_pos_reg_n_0_[0]}]
set_property MARK_DEBUG true [get_nets {joy_test/tx_pos_reg_n_0_[2]}]
set_property MARK_DEBUG true [get_nets {joy_test/tx_pos_reg_n_0_[3]}]
set_property MARK_DEBUG false [get_nets {joy_test/joy_spi_master/tx_pos_reg[3]}]
connect_debug_port u_ila_0/probe13 [get_nets [list joy_test/joy_spi_master/tx_wait]]

connect_debug_port u_ila_0/probe16 [get_nets [list joy_test/joy_spi_master/st_done_reg]]

connect_debug_port u_ila_0/probe11 [get_nets [list {joy_test/tx_pos[3]_i_2_n_0}]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk28]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 5 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {joy_test/mcp_state[0]} {joy_test/mcp_state[1]} {joy_test/mcp_state[2]} {joy_test/mcp_state[3]} {joy_test/mcp_state[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list JS_CS_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list JS_INTA_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list JS_MISO_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list JS_MOSI_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list JS_SCK_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list reset]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list RESET_N_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {joy_test/tx_pos[1]_i_1_n_0}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {joy_test/tx_pos[2]_i_1_n_0}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {joy_test/tx_pos_reg_n_0_[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {joy_test/tx_pos_reg_n_0_[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {joy_test/tx_pos_reg_n_0_[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list joy_test/joy_spi_master/TX_Ready]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk28]
