module bcd_to_7seg #(
    parameter ACTIVE_LOW = 0 // 0 = Active High (LED aprins la 1), 1 = Active Low
)(
    input  wire [3:0] bcd_in,
    output wire [6:0] seg_out
);

    reg [6:0] segments_raw;
 
    // Logica de decodare (Standard Truth Table)
    // Format: g f e d c b a
    always @(*) begin
        case (bcd_in)
            4'h0: segments_raw = 7'b0111111;
            4'h1: segments_raw = 7'b0000110;
            4'h2: segments_raw = 7'b1011011;
            4'h3: segments_raw = 7'b1001111;
            4'h4: segments_raw = 7'b1100110;
            4'h5: segments_raw = 7'b1101101;
            4'h6: segments_raw = 7'b1111101;
            4'h7: segments_raw = 7'b0000111;
            4'h8: segments_raw = 7'b1111111;
            4'h9: segments_raw = 7'b1101111;
            default: segments_raw = 7'b0000000; // Stins pentru intrari invalide (A-F)
        endcase
    end

    // Procesare iesire in functie de polaritate
    assign seg_out = (ACTIVE_LOW) ? ~segments_raw : segments_raw;

endmodule