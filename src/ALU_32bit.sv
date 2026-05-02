module ALU_32bit (
    input logic [31:0] A, B,
    input logic [3:0] opcode,
    input logic carry_in,
    output logic [31:0] result,
    output logic zero, carry_out, overflow, negative
);

localparam ADD_OP  = 4'b0000,
           SUB_OP  = 4'b1000,
           AND_OP  = 4'b0111,
           OR_OP   = 4'b0110,
           XOR_OP  = 4'b0100,
           SLL_OP  = 4'b0001,
           SRL_OP  = 4'b0101, 
           SRA_OP  = 4'b1101,
           SLT_OP  = 4'b0010,
           SLTU_OP = 4'b0011;           

logic [31:0] B_operated;
logic [32:0] add_result;
assign B_operated = (opcode == SUB_OP) ? ~B : B;

// Perform addition or subtraction
Full_Adder_32bit FA32 (
    .A(A),
    .B(B_operated),
    .cin(carry_in),
    .sum(add_result[31:0]),
    .cout(add_result[32])
);

// Determine result based on opcode
always_comb begin
    case (opcode)
        ADD_OP, SUB_OP: result = add_result[31:0] ;
        AND_OP: result = A & B;
        OR_OP: result = A | B;
        XOR_OP: result = A ^ B;
        SLL_OP: result = A << B[4:0];
        SRL_OP: result = A >> B[4:0];
        SRA_OP: result = $signed(A) >>> B[4:0];
        SLT_OP: result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
        SLTU_OP: result = (A < B) ? 32'b1 : 32'b0;
        default: result = 32'b0;
    endcase
end

// Set flags
assign zero = (result == 32'b0);
assign carry_out = ((opcode == ADD_OP) || (opcode == SUB_OP)) ? add_result[32] : 1'b0;
assign overflow = ((opcode == ADD_OP) || (opcode == SUB_OP)) ? ((A[31] == B_operated[31]) && (result[31] != A[31])) : 1'b0;
assign negative = result[31];

endmodule
