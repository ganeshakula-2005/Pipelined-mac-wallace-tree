`timescale 1ns / 1ps

module mac (
    input logic clk,
    input logic rst,
    input logic valid_in,
    input logic signed [15:0]in_weight,
    input logic signed [15:0]in_act,
    input logic signed [39:0]prev_acc,
    output logic signed [39:0]acc_out,
    output logic done

);

logic valid_buf[3:0];
logic signed [15:0]act_out;
logic signed [15:0]weights_out;
logic  [31:0][7:0]col_data_wire;
logic signed [31:0]final_pp_wire[1:0];
logic signed [39:0]prev_acc_buf[3:0];
logic signed [31:0]product;

input_register IR (
    .weights_in(in_weight),
    .act_in(in_act),
    .ir_valid(valid_in),
    .valid_out(valid_buf[0]),
    .clk(clk),.rst(rst),
    .act_out(act_out),
    .weights_out(weights_out)
);

booths_encoding BE (
    .multiplier(weights_out),
    .multiplicand(act_out),
    .clk(clk),
    .valid_in(valid_buf[0]),
    .reset(rst),
    .valid_out(valid_buf[1]),
    .col_data(col_data_wire)
);

wallace_tree_red WT (
    .col_data(col_data_wire),
    .valid_in(valid_buf[1]),
    .rst(rst),
    .clk(clk),
    .final_pp(final_pp_wire),
    .valid_out(valid_buf[2])
);

final_sum FS (
    .clk(clk),
    .rst(rst),
    .valid_in(valid_buf[2]),
    .final_pp(final_pp_wire),
    .product(product),
    .done(valid_buf[3])
);

accumulate ACC (
    .product(product), 
    .prev_acc(prev_acc_buf[3]), 
    .clk(clk) , 
    .valid_in(valid_buf[3]), 
    .rst(rst), .acc_out(acc_out), 
    .done(done)
);

always @(posedge clk)
begin 
    
        prev_acc_buf[0] <= prev_acc;
        prev_acc_buf[1] <= prev_acc_buf[0];
        prev_acc_buf[2] <= prev_acc_buf[1];
        prev_acc_buf[3] <= prev_acc_buf[2];

    
end 


endmodule
