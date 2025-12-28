`timescale 1ns / 1ps

module tb_bcd_to_7seg;

    // Semnale
    reg  [3:0] bcd_in;
    wire [6:0] seg_out;
    
    // Variabile pentru verificare
    integer i;
    reg [6:0] expected_patterns [0:15];
    integer errors = 0;

    // Instantiere (Device Under Test)
    bcd_to_7seg #(.ACTIVE_LOW(0)) dut (
        .bcd_in(bcd_in),
        .seg_out(seg_out)
    );

    // Definire Culori ANSI pentru consola
    localparam string RED   = "\033[1;31m";
    localparam string GREEN = "\033[1;32m";
    localparam string RESET = "\033[0m";
    localparam string BOLD  = "\033[1m";

    // Initializare modele asteptate (Golden Model) pentru verificare automata
    initial begin
        expected_patterns[0] = 7'b0111111; expected_patterns[1] = 7'b0000110;
        expected_patterns[2] = 7'b1011011; expected_patterns[3] = 7'b1001111;
        expected_patterns[4] = 7'b1100110; expected_patterns[5] = 7'b1101101;
        expected_patterns[6] = 7'b1111101; expected_patterns[7] = 7'b0000111;
        expected_patterns[8] = 7'b1111111; expected_patterns[9] = 7'b1101111;
        // Restul sunt 0
        for(i=10; i<16; i=i+1) expected_patterns[i] = 7'b0000000;
    end

    initial begin
        $display("%s\n=============================================", BOLD);
        $display("   SIMULARE DIGITALA AFISAJ 7 SEGMENTE   ");
        $display("=============================================%s", RESET);

        for (i = 0; i <= 9; i = i + 1) begin
            bcd_in = i;
            #10; // Asteapta propagarea

            // 1. Verificare Automata (Self-Checking)
            if (seg_out === expected_patterns[i]) begin
                $display("Test %0d: Input %b -> Output %b %s[PASS]%s", 
                         i, i[3:0], seg_out, GREEN, RESET);
            end else begin
                $display("Test %0d: Input %b -> Output %b %s[FAIL] (Expected %b)%s", 
                         i, i[3:0], seg_out, RED, expected_patterns[i], RESET);
                errors = errors + 1;
            end

            // 2. Desenare UI Simulat
            draw_digit(seg_out);
            #100; // Pauza mica intre afisari
        end

        // Rezultat final
        $display("\n=============================================");
        if (errors == 0)
            $display("%sTOATE TESTELE AU TRECUT CU SUCCES!%s", GREEN, RESET);
        else
            $display("%sS-AU GASIT %0d ERORI!%s", RED, errors, RESET);
        $display("=============================================\n");
        $finish;
    end

    // Task pentru desenarea cifrei in consola
    task draw_digit;
        input [6:0] s; // gfedcba
        begin
            // Segmentele: a=s[0], b=s[1], c=s[2], d=s[3], e=s[4], f=s[5], g=s[6]
            
            // Linia 1 (Segment A)
            $write("      ");
            if(s[0]) $write("%s _ %s", RED, RESET); 
            else     $write("   "); 
            $write("\n");

            // Linia 2 (Segmente F, G, B)
            $write("     ");
            if(s[5]) $write("%s|%s", RED, RESET); else $write(" ");
            if(s[6]) $write("%s_%s", RED, RESET); else $write(" ");
            if(s[1]) $write("%s|%s", RED, RESET); else $write(" ");
            $write("\n");

            // Linia 3 (Segmente E, D, C)
            $write("     ");
            if(s[4]) $write("%s|%s", RED, RESET); else $write(" ");
            if(s[3]) $write("%s_%s", RED, RESET); else $write(" ");
            if(s[2]) $write("%s|%s", RED, RESET); else $write(" ");
            $write("\n\n");
        end
    endtask

endmodule