// Modul: Convertor BCD la Afisaj 7 Segmente
// Descriere: Converteste o intrare pe 4 biti (0-9) in semnale pentru 7 segmente.
// Mapare segmente: [6:0] -> {g, f, e, d, c, b, a}
// Logica: Active High (1 = Segment Aprins, 0 = Segment Stins)

module bcd_to_7seg (
    input [3:0] bcd_in,      // Intrare BCD (valori 0-9)
    output reg [6:0] seg_out // Iesire segmente: g f e d c b a
);

    always @(*) begin
        case (bcd_in)
            //                    gfedcba
            4'b0000: seg_out = 7'b0111111; // 0
            4'b0001: seg_out = 7'b0000110; // 1
            4'b0010: seg_out = 7'b1011011; // 2
            4'b0011: seg_out = 7'b1001111; // 3
            4'b0100: seg_out = 7'b1100110; // 4
            4'b0101: seg_out = 7'b1101101; // 5
            4'b0110: seg_out = 7'b1111101; // 6
            4'b0111: seg_out = 7'b0000111; // 7
            4'b1000: seg_out = 7'b1111111; // 8
            4'b1001: seg_out = 7'b1101111; // 9
            default: seg_out = 7'b0000000; // Stins pentru valori > 9 (ex: A-F)
        endcase
    end
endmodule