module dec7seg_nums(
    input  logic [3:0] bcd,      // entrada que será convertida
    output logic [6:0] seg       // números de saída possíveis
);
    always_comb begin
        case (bcd)
            4'd0: seg = 7'b1111110; // 0
            4'd1: seg = 7'b0110000; // 1
            4'd2: seg = 7'b1101101; // 2
            4'd3: seg = 7'b1111001; // 3
            4'd4: seg = 7'b0110011; // 4
            4'd5: seg = 7'b1011011; // 5
            4'd6: seg = 7'b1011111; // 6
            4'd7: seg = 7'b1110000; // 7
            4'd8: seg = 7'b1111111; // 8
            4'd9: seg = 7'b1111011; // 9
            default: seg = 7'b0000000; // nada
        endcase
    end
endmodule

module dec7seg_letters(
    input logic [4:0]bcd, // entrada que será convertida onde o número de entrada equivale a posição da letra no alfabeto
    output logic [6:0]seg // a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
);

    always_comb begin
        case (bcd)
            5'd0:  seg = 7'b1110111; // A
            5'd1:  seg = 7'b0011111; // B
            5'd2:  seg = 7'b1001110; // C
            5'd3:  seg = 7'b0111101; // D
            5'd4:  seg = 7'b1001111; // E
            5'd5:  seg = 7'b1000111; // F
            5'd6:  seg = 7'b1011110; // G
            5'd7:  seg = 7'b0110111; // H
            5'd8:  seg = 7'b0110000; // I
            5'd9:  seg = 7'b0111000; // J
            5'd10: seg = 7'b1000111; // K
            5'd11: seg = 7'b0001110; // L
            5'd12: seg = 7'b1101010; // M
            5'd13: seg = 7'b0010101; // N
            5'd14: seg = 7'b1111110; // O
            5'd15: seg = 7'b1100111; // P
            5'd16: seg = 7'b1110011; // Q
            5'd17: seg = 7'b0000101; // R
            5'd18: seg = 7'b1011011; // S
            5'd19: seg = 7'b0001111; // T
            5'd20: seg = 7'b0111110; // U
            5'd21: seg = 7'b0011100; // V
            5'd22: seg = 7'b0101110; // W
            5'd23: seg = 7'b0110111; // X
            5'd24: seg = 7'b0111011; // Y
            5'd25: seg = 7'b1101101; // Z
            default: seg = 7'b0000000;
        endcase
    end
endmodule
