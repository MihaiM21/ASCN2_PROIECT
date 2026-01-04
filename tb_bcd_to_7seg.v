`timescale 1ns / 1ps

module tb_bcd_to_7seg;

    // Semnale
    reg  [3:0] bcd_in;
    wire [6:0] seg_out;
    
    // Variabile pentru verificare
    integer i;
    integer choice;
    integer user_input;
    integer status;
    reg [6:0] expected_patterns [0:15];
    integer errors = 0;

    // Instantiere (Device Under Test)
    bcd_to_7seg #(.ACTIVE_LOW(0)) dut (
        .bcd_in(bcd_in),
        .seg_out(seg_out)
    );


    // Initializare modele asteptate pentru verificare automata
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
        $display("\n=============================================");
        $display("   SIMULARE DIGITALA AFISAJ 7 SEGMENTE   ");
        $display("=============================================");
        $display("Alege modul de functionare:");
        $display("  1 - Testbench automat (0-9)");
        $display("  2 - Introducere manuala");
        $display("=============================================");
        $write("Introdu alegerea ta (1 sau 2): ");
        
        status = $fscanf(32'h8000_0000, "%d", choice);
        
        if (choice == 1) begin
            // Mod Testbench Automat
            $display("\n>>> Rulare testbench automat...\n");
            
            for (i = 0; i <= 9; i = i + 1) begin
                bcd_in = i;
                #10;

                if (seg_out === expected_patterns[i]) begin
                    $display("Test %0d: Input %b -> Output %b [PASS]", 
                             i, i[3:0], seg_out);
                end else begin
                    $display("Test %0d: Input %b -> Output %b [FAIL] (Expected %b)", 
                             i, i[3:0], seg_out, expected_patterns[i]);
                    errors = errors + 1;
                end

                draw_digit(seg_out);
                #100;
            end

            $display("\n=============================================");
            if (errors == 0)
                $display("TOATE TESTELE AU TRECUT CU SUCCES!");
            else
                $display("S-AU GASIT %0d ERORI!", errors);
            $display("=============================================\n");
            
        end else if (choice == 2) begin
            // Mod Input Manual
            $display("\n>>> Mod introducere manuala");
            $display("Introdu cifre de la 0 la 9 (sau -1 pentru iesire)\n");
            
            user_input = 0;
            while (user_input != -1) begin
                $write("Introdu cifra BCD (0-9, sau -1 pt iesire): ");
                status = $fscanf(32'h8000_0000, "%d", user_input);
                
                if (user_input >= 0 && user_input <= 9) begin
                    bcd_in = user_input;
                    #10;
                    
                    $display("\nAfisaj pentru cifra %0d:", user_input);
                    $display("Output binar: %b", seg_out);
                    draw_digit(seg_out);
                    #50;
                end else if (user_input != -1) begin
                    $display("EROARE: Introdu doar cifre intre 0-9!\n");
                end
            end
            
            $display("\n=============================================");
            $display("Simulare incheiata!");
            $display("=============================================\n");
            
        end else begin
            $display("\nAlegere invalida! Inchidere simulare.\n");
        end
        
        $finish;
    end

    // Task pentru desenarea cifrei in consola
    task draw_digit;
        input [6:0] s; // gfedcba
        begin
            // Segmentele: a=s[0], b=s[1], c=s[2], d=s[3], e=s[4], f=s[5], g=s[6]
            
            // Linia 1 (Segment A)
            $write("      ");
            if(s[0]) $write(" _ "); 
            else     $write("   "); 
            $write("\n");

            // Linia 2 (Segmente F, G, B)
            $write("     ");
            if(s[5]) $write("|"); else $write(" ");
            if(s[6]) $write("_"); else $write(" ");
            if(s[1]) $write("|"); else $write(" ");
            $write("\n");

            // Linia 3 (Segmente E, D, C)
            $write("     ");
            if(s[4]) $write("|"); else $write(" ");
            if(s[3]) $write("_"); else $write(" ");
            if(s[2]) $write("|"); else $write(" ");
            $write("\n\n");
        end
    endtask

endmodule