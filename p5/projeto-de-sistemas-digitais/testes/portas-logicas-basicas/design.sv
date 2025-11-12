module porta_and (
	input logic a, b,
	output logic result
);
  assign result = a & b;
endmodule

module porta_or (
  input logic a, b,
  output logic result
);

  assign result = a | b;
endmodule

module porta_not (
	input logic a,
  	output logic result
);
  assign result = ~a;
endmodule

module porta_nand(
	input logic a, b,
  	output logic result
);
  assign result = ~(a & b);
endmodule

module porta_nor(
	input logic a, b,
  	output logic result
);
  assign result = ~(a | b);
endmodule

module porta_xor(
	input logic a, b,
  	output logic result
);
  assign result = a ^ b;

endmodule

module porta_xnor(
	input logic a, b,
  	output logic result
);
  assign result = ~(a ^ b);
endmodule
