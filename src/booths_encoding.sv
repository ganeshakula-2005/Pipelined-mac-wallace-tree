`timescale 1ns / 1ps
module booths_encoding(
    input logic signed [15:0]multiplier,
    input logic signed [15:0]multiplicand,
    input logic clk,
    input logic valid_in,
    input logic reset,
    output logic valid_out,
    output logic [31:0][7:0]col_data
);

logic signed [31:0]multiplicand_ext;
logic signed [31:0]partial_product[7:0];
assign multiplicand_ext = signed'({{16{multiplicand[15]}}, multiplicand});

always_comb 
begin 
    for(int i = 0; i <= 7; i++)
            begin
                if (i == 0)
                begin 
                    case({multiplier[1],multiplier[0],1'b0})
                        3'b000,3'b111 : partial_product[i] = 32'b0;
                        3'b001,3'b010 : partial_product[i] =  (multiplicand_ext);
                        3'b101,3'b110 : partial_product[i] = -(multiplicand_ext);
                        3'b011        : partial_product[i] =  (multiplicand_ext  <<< 1 );
                        3'b100        : partial_product[i] = -(multiplicand_ext  <<< 1 );
                        default       : partial_product[i] =  32'b0;
                    endcase
                end
                else 
                begin
                        case({multiplier[(2*i)+1],multiplier[(2*i)],multiplier[(2*i)-1]})
                        3'b000,3'b111 : partial_product[i] = 32'b0;
                        3'b001,3'b010 : partial_product[i] =  (multiplicand_ext <<< (i * 2));
                        3'b101,3'b110 : partial_product[i] = -(multiplicand_ext <<< (i * 2));
                        3'b011        : partial_product[i] =  (multiplicand_ext  <<< ((i * 2) + 1));
                        3'b100        : partial_product[i] = -(multiplicand_ext  <<< ((i * 2) + 1));
                        default       : partial_product[i] =  32'b0;
                    endcase
                end          
            end
end 
always_ff @(posedge clk)
begin
    if(reset)
    begin 
        for ( int i = 0; i <= 31; i++)
        begin 
            col_data[i] <= 8'b0;
        end
        valid_out <= 1'b0;
    end 
    else 
    begin
        if (valid_in)
        begin  
            for(int i = 0; i < 8; i++)
            begin 
                for(int col = 0; col < 32; col++)
                begin 
                    col_data[col][i] <= partial_product[i][col];
                end
            end 
        end 
        else 
        begin
            col_data <= 0;
        end
        valid_out <= valid_in;  

    end
end
endmodule
