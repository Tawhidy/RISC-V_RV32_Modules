// Full Adder single bit

module Full_Adder (
    input logic A, B,
    input logic cin,

    output logic sum, cout
);
    
    assign sum = A ^ B ^ cin;
    assign cout = (A & B) | (B & cin) | (A & cin);
endmodule
