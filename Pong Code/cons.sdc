create_clock -name { clk12 } -period 83.333 -waveform {0 41.667} [get_ports p_clk12]

set_clock_groups -asynchronous -group {clk12}

