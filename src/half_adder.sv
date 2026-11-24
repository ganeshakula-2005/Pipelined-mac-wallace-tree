module half_adder (
    input logic a,
    input logic b,
    output logic sum,
    output logic c_out
);

always_comb
begin
    sum = a ^ b;
    c_out = a & b;
end
endmodule
