`timescale 1ns / 1ps

module input_register(
    input logic signed [15:0] weights_in,
    input logic signed [15:0] act_in,
    input logic ir_valid,
    output logic valid_out,
    input logic clk,
    input logic rst,
    output logic signed [15:0] act_out,
    output logic signed [15:0] weights_out
    );

 always_ff @ (posedge clk)
 begin 
    if (rst)
     begin
        weights_out <= 16'sd0;
        act_out <= 16'sd0;
        valid_out <= 0; 
    end  
    else
    begin 
        valid_out <= ir_valid;      
        if (ir_valid)
        begin
            weights_out <= weights_in;
            act_out <= act_in;
        end
        else 
        begin
            weights_out <= 0;
            act_out <= 0;
        end
    end
 end
endmodule
