module accumulate (
    input logic signed[31:0]product,
    input logic signed [39:0]prev_acc,
    input logic clk,
    input logic valid_in,
    input logic rst,
    output logic signed [39:0]acc_out,
    output logic done
);

logic signed [39:0]product_ext;
assign product_ext = signed' ({{8{product[31]}},product});

always_ff @(posedge clk)
begin
    if (rst)
    begin
        done <= 1'b0;
        acc_out <= 40'b0;
    end
    else 
    begin 
        done <= valid_in;
        if (valid_in)
        begin 
            acc_out <= product_ext + prev_acc;
        end 
        else
            acc_out <= 40'b0;
    end 

end

endmodule
