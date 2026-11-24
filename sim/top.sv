`timescale 1ns / 1ps

module top;

logic clk;
logic rst;
logic valid_in;

logic signed [15:0]in_act,in_weight;
logic signed [39:0]prev_sum_in;

logic signed [39:0]expected_output[$];
logic signed [39:0]expected;

wire done;
wire signed [39:0]sum_out;

mac mac_v1(
    .clk(clk),
    .rst(rst),
    .in_weight(in_weight),
    .in_act(in_act),
    .prev_acc(prev_sum_in),
    .valid_in(valid_in),
    .done(done),
    .acc_out(sum_out)
);

class mac_test;

    rand bit signed [15:0]r_in_act;
    rand bit signed [15:0]r_in_weight;
    rand bit signed [39:0]r_prev_sum_in;
    rand bit r_valid_in;

endclass

mac_test v1;

initial 
begin
    clk <= 1'b1;
    forever #5 clk = ~clk;

end

initial 
begin 

    rst <= 1'b1;
    valid_in <= 1'b0;
    in_act <= 16'b0;
    in_weight <= 16'b0;
    prev_sum_in <= 40'b0;

    #10 
    rst <= 1'b0;
end

initial 
begin 
    #20
    v1 = new();
    
    fork
        begin
            repeat (100) @ (posedge clk)
            begin
                    assert(v1.randomize() == 1)
                        else $error("randomization failed");
                
                    in_act = v1.r_in_act;
                    in_weight = v1.r_in_weight;
                    valid_in = v1.r_valid_in;
                    prev_sum_in = v1.r_prev_sum_in;
                   
                    if (valid_in == 1'b1)
                    begin
                        expected_output.push_back((in_act * in_weight) + prev_sum_in );
                        $display("[%0t] in_act = %0d, in_weight = %0d, valid_in = %0d, prev_sum_in = %0d",$time, in_act, in_weight, valid_in, prev_sum_in);
                    end

            end
            $display("[%0t] finished sending all 100 items",$time);

        end

        begin
            forever @(posedge clk)
            begin
                if(done)
                begin 
                    if(expected_output.size() == 0)
                        $error("done generated but nothing on queue");
                    else
                    begin 
                        expected = expected_output.pop_front();
                        if(sum_out != expected) 
                            $display("[%0t] fail expected = %0d actual output = %0d",$time,expected,sum_out);


                    end
                end
            end
        end
    join_any

    $display("[%0t] MAIN: Stimulus complete. Draining pipeline...", $time);
        repeat(40) @(posedge clk); 

        $display("[%0t] MAIN: Simulation Finished.", $time);
        $finish;
end

initial 
begin
        $dumpfile("mac_wave.vcd");
        $dumpvars(0, top);
end
endmodule

