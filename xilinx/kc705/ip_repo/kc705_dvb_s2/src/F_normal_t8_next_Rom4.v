
`timescale 1ns / 1ps
module F_normal_t8_next_Rom4(
input	          							clk_1x,
input	          							rst_n,
//////////////////////////////////////////////////////////////
input										rd_en,
input			[4:0]				rdaddr,
output		reg			[127:0]				rd_q
);

always @(posedge clk_1x)begin
	if(~rst_n)begin
		rd_q <= 128'b0;
	end
	else if(rd_en == 1'b1)begin
		case(rdaddr)
			5'h0f: rd_q <= 128'b11011001001000001111011011010010101001000101110101011100011000010011011000110111011110101100011000010101000011101010111000111011;
			5'h0e: rd_q <= 128'b00111010011111111011100110001110001100000000010100000101110000101001011000011110101001000100101010110001000010011010001011100011;
			5'h0d: rd_q <= 128'b01000111011001010001001101000111001001001111011111100110010111011111011100101001110111010000101001110000000000010000011111110111;
			5'h0c: rd_q <= 128'b11100101011000100011111001000000000001001010110101000010111001010101100100000111100011110000111100011111101101110010010001110000;
			5'h0b: rd_q <= 128'b01000101010000110101100110000010001010010010010011111010100110111000001101101010101100000111101000010011101100000110001100110001;
			5'h0a: rd_q <= 128'b01101011110111101100000111110111100101000010111101010111010010011111010000001100010010110011111000011010101101001000100110111111;
			5'h09: rd_q <= 128'b01010110010111010011110011010000010001110001101111011001111110010010010111000111001000100001100001000011100000010100111111011001;
			5'h08: rd_q <= 128'b00111001101000010101111000111000101100000101110010011011101110010110110011111010111100111000000001010100101101011011111010000010;
			5'h07: rd_q <= 128'b01011100010000101101001101111010110001101111110000010100010011111010101000010101110101100000010101111000010001010110111000101100;
			5'h06: rd_q <= 128'b01010100100100111111011110000000000010011010111010111110001110110111000000010101010011111101111001011110111111000110010001111110;
			5'h05: rd_q <= 128'b10101100001110010101011111010100111000010001011001000011111000101110001100010110010010011110100100100101011010010000101011000101;
			5'h04: rd_q <= 128'b01000010000000011111101100101100111110011110100110011100000110010111000001000100001111010101000110011111101010101101001111011110;
			5'h03: rd_q <= 128'b01001101010100001111110100110000110010001111110110110100101111100101001110000101100001010011011011101110101001011000010001000100;
			5'h02: rd_q <= 128'b11010010100010001111101100100100100110110000101101110011110100001100011001010101001011100010111110111011100111110110001010111101;
			5'h01: rd_q <= 128'b11011110111110011000011111101110110001001110111010001010100100010001001001100101101100110000010101010000100101010101111110011000;
			5'h00: rd_q <= 128'b00010111000101000100001110010001111100011111100101001010100000000000110101110001110001110110101000110101101011100100011101011011;
		default:rd_q <= 128'b0;
		endcase
	end
end

endmodule