module tb;
  // VALORES DE ENTRADA E SAÍDA
  logic and_a, and_b, and_result;
  logic or_a, or_b, or_result;
  logic not_a, not_result;
  logic nand_a, nand_b, nand_result;
  logic nor_a, nor_b, nor_result;
  logic xor_a, xor_b, xor_result;
  logic xnor_a, xnor_b, xnor_result;

  // INSTÂNCIAS DOS MÓDULOS
  porta_and dut_and(.a(and_a), .b(and_b), .result(and_result));
  porta_or dut_or(.a(or_a), .b(or_b), .result(or_result));
  porta_not dut_not(.a(not_a), .result(not_result));
  porta_nand dut_nand(.a(nand_a), .b(nand_b), .result(nand_result));
  porta_nor dut_nor(.a(nor_a), .b(nor_b), .result(nor_result));
  porta_xor dut_xor(.a(xor_a), .b(xor_b), .result(xor_result));
  porta_xnor dut_xnor(.a(xnor_a), .b(xnor_b), .result(xnor_result));

  initial begin
    // PORTA AND
    $display("== TESTES DA PORTA AND ==");
    $display("a     b      |     result");

    and_a = 0;and_b = 0;
    #5
    $display("%b     %b      |        %b", and_a, and_b, and_result);
    and_a = 1;and_b = 0;
    #5
    $display("%b     %b      |        %b", and_a, and_b, and_result);
    and_a = 0;and_b = 1;
    #5
    $display("%b     %b      |        %b", and_a, and_b, and_result);
    and_a = 1;and_b = 1;
    #5
    $display("%b     %b      |        %b", and_a, and_b, and_result);

    // PORTA OR
    $display("== TESTES DA PORTA OR ==");
    $display("a     b      |     result");

    or_a = 0;or_b = 0;
    #5
    $display("%b     %b      |        %b", or_a, or_b, or_result);
    or_a = 1;or_b = 0;
    #5
    $display("%b     %b      |        %b", or_a, or_b, or_result);
    or_a = 0;or_b = 1;
    #5
    $display("%b     %b      |        %b", or_a, or_b, or_result);
    or_a = 1;or_b = 1;
    #5
    $display("%b     %b      |        %b", or_a, or_b, or_result);

    // PORTA NOT
    $display("== TESTES DA PORTA NOT ==");
    $display("a     |     result");

    not_a = 0;
    #5
    $display("%b     |        %b", not_a, not_result);
    not_a = 1;
    #5
    $display("%b     |        %b", not_a, not_result);
    not_a = 0;
    #5
    $display("%b     |        %b", not_a, not_result);
    not_a = 1;
    #5
    $display("%b     |        %b", not_a, not_result);

    // PORTA NAND
    $display("== TESTES DA PORTA NAND ==");
    $display("a     b      |     result");

    nand_a = 0;nand_b = 0;
    #5
    $display("%b     %b      |        %b", nand_a, nand_b, nand_result);
    nand_a = 1;nand_b = 0;
    #5
    $display("%b     %b      |        %b", nand_a, nand_b, nand_result);
    nand_a = 0;nand_b = 1;
    #5
    $display("%b     %b      |        %b", nand_a, nand_b, nand_result);
    nand_a = 1;nand_b = 1;
    #5
    $display("%b     %b      |        %b", nand_a, nand_b, nand_result);

    // PORTA NOR
    $display("== TESTES DA PORTA NOR ==");
    $display("a     b      |     result");

    nor_a = 0;nor_b = 0;
    #5
    $display("%b     %b      |        %b", nor_a, nor_b, nor_result);
    nor_a = 1;nor_b = 0;
    #5
    $display("%b     %b      |        %b", nor_a, nor_b, nor_result);
    nor_a = 0;nor_b = 1;
    #5
    $display("%b     %b      |        %b", nor_a, nor_b, nor_result);
    nor_a = 1;nor_b = 1;
    #5
    $display("%b     %b      |        %b", nor_a, nor_b, nor_result);

    // PORTA XOR
    $display("== TESTES DA PORTA XOR ==");
    $display("a     b      |     result");

    xor_a = 0;xor_b = 0;
    #5
    $display("%b     %b      |        %b", xor_a, xor_b, xor_result);
    xor_a = 1;xor_b = 0;
    #5
    $display("%b     %b      |        %b", xor_a, xor_b, xor_result);
    xor_a = 0;xor_b = 1;
    #5
    $display("%b     %b      |        %b", xor_a, xor_b, xor_result);
    xor_a = 1;xor_b = 1;
    #5
    $display("%b     %b      |        %b", xor_a, xor_b, xor_result);

    // PORTA XNOR
    $display("== TESTES DA PORTA XNOR ==");
    $display("a     b      |     result");

    xnor_a = 0;xnor_b = 0;
    #5
    $display("%b     %b      |        %b", xnor_a, xnor_b, xnor_result);
    xnor_a = 1;xnor_b = 0;
    #5
    $display("%b     %b      |        %b", xnor_a, xnor_b, xnor_result);
    xnor_a = 0;xnor_b = 1;
    #5
    $display("%b     %b      |        %b", xnor_a, xnor_b, xnor_result);
    xnor_a = 1;xnor_b = 1;
    #5
    $display("%b     %b      |        %b", xnor_a, xnor_b, xnor_result);

    $finish;
  end
endmodule
