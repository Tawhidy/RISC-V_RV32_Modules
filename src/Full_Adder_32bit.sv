// Full Adder 32-bit

module Full_Adder_32bit (
    input logic [31:0] A, B,
    input logic cin,

    output logic [31:0] sum,
    output logic cout
);

logic [32:0] carry;
assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 32; i++) 
        begin : full_adder_32bit

            Full_Adder FA32 (
                .A(A[i]),
                .B(B[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[32];
endmodule
