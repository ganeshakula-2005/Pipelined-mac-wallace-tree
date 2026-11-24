`timescale 1ns / 1ps

module wallace_stage #(
    parameter int NUM_COLS = 32,
    parameter int MAX_IN_COL_LEN = 8,
    parameter int MAX_OUT_COL_LEN = 0,
    parameter int IN_COL_LENS[NUM_COLS] = '{default: 0}
)(
    input logic  [NUM_COLS - 1 : 0][MAX_IN_COL_LEN - 1 : 0]in_cols,
    output logic [NUM_COLS - 1 : 0][MAX_OUT_COL_LEN - 1 : 0]out_cols
);

import wallace_pkg::*;

logic [NUM_COLS - 1 : 0][MAX_IN_COL_LEN - 1 : 0]carries_out;
//localparam bit flag_if_carry[NUM_COLS] = expect_carry(IN_COL_LENS);
localparam int out_col_lens[NUM_COLS] = get_next_col_size(IN_COL_LENS);
generate 
    
    for( genvar col = 0; col < NUM_COLS; col++)
    begin : g_col

        localparam int N_FA = IN_COL_LENS[col] / 3;
        localparam int REM = IN_COL_LENS[col] % 3;
        //localparam bit HAS_INCOMING_CARRY = (col > 0) ? flag_if_carry[col-1] : 1'b0;
        //localparam int N_HA = (REM == 2 && HAS_INCOMING_CARRY) ? 1 : 0;
        localparam int N_PASS = (REM == 1) ? 1 :(REM == 2) ? 2 : 0;

        for( genvar f = 0; f < N_FA; f++)
        begin : g_fa

            full_adder u_fa (
                .a(in_cols[col][f * 3]),
                .b(in_cols[col][(f * 3) + 1]),
                .c_in(in_cols[col][(f * 3) + 2]),
                .sum(out_cols[col][f]),
                .c_out(carries_out[col][f])
            );
            
        end
        
        if(N_PASS == 1)
        begin : p_1_bit

            assign out_cols[col][N_FA] = in_cols[col][N_FA * 3];

        end
        else if (N_PASS == 2)
        begin : pass_2_bits

            assign out_cols[col][N_FA] = in_cols[col][(N_FA * 3)];
            assign out_cols[col][N_FA + 1 ] = in_cols[col][(N_FA * 3) + 1];

        end 

        /*   
        if (N_HA == 1 )
        begin : g_ha

            half_adder u_ha (
                .a(in_cols[col][0]),
                .b(in_cols[col][1]),
                .sum(out_cols[col][0]),
                .c_out(carries_out[col][0])
            );
            
        end 
        */
        
        if (col > 0) 
        begin : g_carry_in

            localparam int PREV_CARRIES = (IN_COL_LENS[col-1] / 3);
            genvar k;
            for (k = 0; k < PREV_CARRIES; k++) begin : g_carry_bind

                assign out_cols[col][N_FA + N_PASS + k] = carries_out[col-1][k];

            end
            
        end

        for (genvar i = out_col_lens[col]; i < MAX_OUT_COL_LEN; i++)
        begin:bind_float_to0

            assign out_cols[col][i] = 1'b0;

        end
    
    end 

endgenerate

endmodule
