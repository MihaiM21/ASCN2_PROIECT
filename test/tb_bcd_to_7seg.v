`timescale 1ns / 1ps

module tb_bcd_to_7seg;

    // Semnale
    reg [3:0] bcd_in;
    wire [6:0] seg_out;
    integer i;

    // Instantierea modulului
    bcd_to_7seg uut (
        .bcd_in(bcd_in),
        .seg_out(seg_out)
    );

    // Mapare segmente pentru claritate in cod
    // seg_out = {g, f, e, d, c, b, a}
    wire a = seg_out[0];
    wire b = seg_out[1];
    wire c = seg_out[2];
    wire d = seg_out[3];
    wire e = seg_out[4];
    wire f = seg_out[5];
    wire g = seg_out[6];

    initial begin
        $display("=== Simulare Convertor BCD la 7 Segmente ===");
        $display("=== UI Minimal: Vizualizare Afisaj ===");
        
        // Loop prin valorile 0 la 9
        for (i = 0; i <= 9; i = i + 1) begin
            bcd_in = i;
            #10; // Asteapta propagarea semnalului

            $display("\nIntrare BCD: %0d (Binar: %b)", i, bcd_in);
            $display("Iesire Segmente (gfedcba): %b", seg_out);
            
            // Desenare UI (ASCII Art) bazat pe starea segmentelor
            // Linia de sus (Segmentul A)
            $write(" ");
            if (a) $write("_"); else $write(" ");
            $display(" ");

            // Linia de mijloc (Segmentele F, G, B)
            if (f) $write("|"); else $write(" ");
            if (g) $write("_"); else $write(" ");
            if (b) $write("|"); else $write(" ");
            $display(" ");

            // Linia de jos (Segmentele E, D, C)
            if (e) $write("|"); else $write(" ");
            if (d) $write("_"); else $write(" ");
            if (c) $write("|"); else $write(" ");
            $display("\n");
        end
        
        $display("=== Simulare Finalizata ===");
        $finish;
    end

endmodule