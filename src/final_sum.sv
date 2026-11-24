`timescale 1ns / 1ps

module final_sum (
    input  logic        clk,
    input  logic        rst,
    input  logic        valid_in,
    input  logic signed [31:0]final_pp[1:0],
    output logic signed [31:0]product,
    output logic        done

);


always_ff @ (posedge clk)
begin 

    if (rst)
    begin 
        product <= 32'b0;
        done <= 1'b0;
    end 
    else
    begin 
        done <= valid_in;
        if (valid_in)
        begin 
            product <= final_pp[0] + final_pp[1];
        end 
        else 
        begin
            product <= 32'b0;
        end
    end 
end 

endmodule
