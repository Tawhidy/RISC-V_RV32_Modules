module ALU_tb ();

    logic [31:0] A, B;
    logic [3:0]  opcode;
    logic        carry_in;
    logic [31:0] result;
    logic        zero, carry_out, overflow, negative;

    // Instantiate the ALU
    ALU_32bit DUT (
        .A(A),
        .B(B),
        .opcode(opcode),
        .carry_in(carry_in),
        .result(result),
        .carry_out(carry_out),
        .zero(zero),
        .overflow(overflow),
        .negative(negative)
    );

    initial begin
        // Enable waveform dumping for GTKWave
        $dumpfile("alu_waves.vcd");
        $dumpvars(0, ALU_tb);

        $display("--- STARTING ALU STRESS TEST ---");

        // 1. Test ADD (Opcode: 4'b0000)
        A = 32'd15; B = 32'd10; opcode = 4'b0000; carry_in = 0; 
        #10; 
        $display("ADD (0000): %d + %d = %d", A, B, result);

        // 2. Test SUB (Opcode: 4'b1000)
        A = 32'd25; B = 32'd10; opcode = 4'b1000; carry_in = 1; // carry_in = 1 for 2's complement sub
        #10; 
        $display("SUB (1000): %d - %d = %d", A, B, result);

        // 3. Test AND (Opcode: 4'b0111)
        A = 32'b1100; B = 32'b1010; opcode = 4'b0111; carry_in = 0; 
        #10; 
        $display("AND (0111): %b & %b = %b", A[3:0], B[3:0], result[3:0]);

        // 4. Test OR (Opcode: 4'b0110)
        A = 32'b1100; B = 32'b1010; opcode = 4'b0110; carry_in = 0; 
        #10; 
        $display("OR  (0110): %b | %b = %b", A[3:0], B[3:0], result[3:0]);

        // 5. Test XOR (Opcode: 4'b0100)
        A = 32'b1100; B = 32'b1010; opcode = 4'b0100; carry_in = 0; 
        #10; 
        $display("XOR (0100): %b ^ %b = %b", A[3:0], B[3:0], result[3:0]);

        // 6. Test Shift Left Logical (Opcode: 4'b0001)
        A = 32'd15; B = 32'd2; opcode = 4'b0001; carry_in = 0; 
        #10; 
        $display("SLL (0001): 15 << 2 = %d", result);

        // 7. Test Set Less Than (SLT - Opcode: 4'b0010)
        A = -32'd5; B = 32'd10; opcode = 4'b0010; carry_in = 0; 
        #10; 
        $display("SLT (0010): -5 < 10 = %d (1 means True)", result);

        // 8. Test Zero Flag (Using SUB)
        A = 32'd42; B = 32'd42; opcode = 4'b1000; carry_in = 1; 
        #10; 
        $display("ZERO TEST : %d - %d = %d | Zero Flag: %b", A, B, result, zero);

        $display("--- TEST COMPLETE ---");
        $finish;
    end
endmodule