`timescale 1ns / 1ps

module wallace_tree_red # (
    parameter int NUM_COLS = 32,
    parameter int MAX_COL_LEN = 8,
    parameter int INITIAL_COL_LENS[NUM_COLS] = '{1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8}

)(
    input logic [NUM_COLS - 1 : 0][MAX_COL_LEN - 1 : 0]col_data,
    input logic valid_in,
    input logic rst,
    input logic clk,
    output logic signed [31:0]final_pp[1:0],
    output logic valid_out 
);

import wallace_pkg::*;
//logic [NUM_COLS - 1 : 0][MAX_COL_LEN - 1 : 0]out_col_data[5 : 0];

logic [NUM_COLS - 1 : 0][5 : 0]out_col_data1;
wallace_stage #(.NUM_COLS(NUM_COLS), .MAX_IN_COL_LEN(MAX_COL_LEN), .MAX_OUT_COL_LEN(6), .IN_COL_LENS(INITIAL_COL_LENS))W_S1 (.in_cols(col_data),.out_cols(out_col_data1)) ;

logic [NUM_COLS - 1 : 0][3 : 0]out_col_data2;
localparam int stage1_col_lens[NUM_COLS] = get_next_col_size(INITIAL_COL_LENS);
wallace_stage #(.NUM_COLS(NUM_COLS), .MAX_IN_COL_LEN(6), .MAX_OUT_COL_LEN(4), .IN_COL_LENS(stage1_col_lens))W_S2 (.in_cols(out_col_data1),.out_cols(out_col_data2)) ;

logic [NUM_COLS - 1 : 0][2 : 0]out_col_data3;
localparam int stage2_col_lens[NUM_COLS] = get_next_col_size(stage1_col_lens);
wallace_stage #(.NUM_COLS(NUM_COLS), .MAX_IN_COL_LEN(4), .MAX_OUT_COL_LEN(3), .IN_COL_LENS(stage2_col_lens))W_S3 (.in_cols(out_col_data2),.out_cols(out_col_data3)) ;

logic [NUM_COLS - 1 : 0][2 : 0]out_col_data4;
localparam int stage3_col_lens[NUM_COLS] = get_next_col_size(stage2_col_lens);
wallace_stage #(.NUM_COLS(NUM_COLS), .MAX_IN_COL_LEN(3), .MAX_OUT_COL_LEN(3), .IN_COL_LENS(stage3_col_lens))W_S4 (.in_cols(out_col_data3),.out_cols(out_col_data4)) ;

logic [NUM_COLS - 1 : 0][2 : 0]out_col_data5;
localparam int stage4_col_lens[NUM_COLS] = get_next_col_size(stage3_col_lens);
wallace_stage #(.NUM_COLS(NUM_COLS), .MAX_IN_COL_LEN(3), .MAX_OUT_COL_LEN(3), .IN_COL_LENS(stage4_col_lens))W_S5 (.in_cols(out_col_data4),.out_cols(out_col_data5)) ;

logic [NUM_COLS - 1 : 0][1 : 0]out_col_data6;
localparam int stage5_col_lens[NUM_COLS] = get_next_col_size(stage4_col_lens);
wallace_stage #(.NUM_COLS(NUM_COLS), .MAX_IN_COL_LEN(3), .MAX_OUT_COL_LEN(2), .IN_COL_LENS(stage5_col_lens))W_S6 (.in_cols(out_col_data5),.out_cols(out_col_data6)) ;

always_ff @( posedge clk)
begin
    if (rst)
    begin 
        valid_out <= 1'b0;
        final_pp <= '{32'b0,32'b0};
    end 
    else 
    begin

        valid_out <= valid_in;
        if(valid_in)
        begin 

            for(int i = 0; i < 2; i++)
            begin 
                for(int col = 0; col < NUM_COLS; col++)
                begin 
                    final_pp[i][col] <= out_col_data6[col][i];
                end 
            end 
        end
        else
        begin
            final_pp[0] <= 32'b0;
            final_pp[1] <= 32'b0;
        end
    end
end

endmodule

