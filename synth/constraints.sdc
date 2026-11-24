# 1. Define clock: Let's start with a target period of 2.0 ns (500 MHz)
    create_clock -name clk -period 1.7 [get_ports clk]
    
    # 2. Input arrival delays (time taken outside the chip before reaching input ports)
    set_input_delay -clock clk 0.2 [all_inputs -no_clocks]
    
    # 3. Output required delays (time needed by external devices after leaving output ports)
    set_output_delay -clock clk 0.2 [all_outputs]
    
    # 4. Model clock jitter/uncertainty (50 ps)
    set_clock_uncertainty 0.05 [get_clocks clk]
