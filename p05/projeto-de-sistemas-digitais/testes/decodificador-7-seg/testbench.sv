module testbench;
    // VALORES DE ENTRADA E SAÍDA
    logic [3:0] bcd_nums;
    logic [6:0] seg_nums;
    logic [4:0] bcd_letters;
    logic [6:0] seg_letters;

    // INSTÂNCIAS DOS MÓDULOS
    dec7seg_nums dut_nums(.bcd(bcd_nums), .seg(seg_nums));
    dec7seg_letters dut_letters(.bcd(bcd_letters), .seg(seg_letters));

    initial begin
        // TESTES DO DISPLAY DE 7 SEGMENTOS PARA NÚMEROS
        $display("DISPLAY DE 7 SEGMENTOS PARA NÚMEROS");

        bcd_nums = 'b0000;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        bcd_nums = 'b0001;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        bcd_nums = 'b0010;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        bcd_nums = 'b0011;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        bcd_nums = 'b0100;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        bcd_nums = 'b0101;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        bcd_nums = 'b0110;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        bcd_nums = 'b0111;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        bcd_nums = 'b1000;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        bcd_nums = 'b1001;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_nums, seg_nums);

        // TESTES DO DISPLAY DE 7 SEGMENTOS PARA LETRAS
        $display("DISPLAY DE 7 SEGMENTOS PARA LETRAS");

        bcd_letters = 'b00000;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b00001;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b00010;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b00011;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b00100;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b00101;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b00110;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b00111;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b01000;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b01001;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b01010;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b01011;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b01100;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b01101;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b01110;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b01111;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b10000;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b10001;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b10010;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b10011;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b10100;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b10101;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b10110;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b10111;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b11000;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b11001;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        bcd_letters = 'b11010;
        #2
        $display("Entrada: %b    | Saída: %b", bcd_letters, seg_letters);

        $finish;
    end
endmodule
