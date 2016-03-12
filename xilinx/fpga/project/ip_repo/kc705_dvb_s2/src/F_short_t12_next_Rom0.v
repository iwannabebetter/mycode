`timescale 1ns / 1ps
module F_short_t12_next_Rom0(
input	          							clk_1x,
input	          							rst_n,
//////////////////////////////////////////////////////////////
input										rd_en,
input				[4:0]				rdaddr,
output		reg			[167:0]				rd_q
);

always @(posedge clk_1x)begin
	if(~rst_n)begin
		rd_q <= 168'b0;
	end
	else if(rd_en == 1'b1)begin
		case(rdaddr)
			5'h14: rd_q <= 168'b101001011010000010011000100010111110101111100111111100010100101010010110000010011100010111000100101100110100011001001101100101100001100101010111110110110100011000000010;
			5'h13: rd_q <= 168'b100001001010000110010101110110110000101111100100000010100011100011111010001001010000011000111011000000101101110111100101010100010011000011101011010110001001010110111100;
			5'h12: rd_q <= 168'b101010100101001100110100010100101101000100001101010101011101111001010011001000110011001010110000111001101110101011000110110001101001100100111000111100110111000011000111;
			5'h11: rd_q <= 168'b011100101001010111110011100010001101101100011101001001101001000100100110110000010001100001100001000101010000101110101110000111000101100110100101101011101110111000000101;
			5'h10: rd_q <= 168'b000000010011100111010100110000101001111100001100110100101100010000000100000010101101001010010011111010000111001110000111001101010011000001101011000010100001100001100010;
			5'h0f: rd_q <= 168'b010110100001110111111110011110111010011001111101000101001010011000001100001110000101001101111011100100111011001000101000101000110000000001101011101001000111000001100001;
			5'h0e: rd_q <= 168'b100111000100000011110101101100110101111101001100011111100100110100000110110110101110100111111011110111101001000000011011100111100110001111010000101011000011011110001110;
			5'h0d: rd_q <= 168'b111001001110001100000001100011001010000011000111000110111111011110111100001000101010110001001110101100000000010000011001101011101010000000011010111111001001011011011100;
			5'h0c: rd_q <= 168'b011101000010101110000100001010100110001001001011100000110111001011100100111010100110001101001101010101010110110011100111000000101111010100000001110000101110000001000111;
			5'h0b: rd_q <= 168'b110101111110101100010011101100110100100001001001100100010000110100011100011111110001010011110100010110111111111001100101101010111000010010011110010011001001100110010111;
			5'h0a: rd_q <= 168'b011001100101110001011000101111100100011111111000100111000111110010100111010011110111110011111111110001111101111001110011000011011111011110010010111100110011100100101100;
			5'h09: rd_q <= 168'b010010010111010100001110010000001101011100101001101111101000111010011000101100100100011101010100010111101010001001100111101111110001001100101001010001110101011010101000;
			5'h08: rd_q <= 168'b101011111011001111100100000011010001010110001110101001111110000010110001111100011110101111011111101011000010110010001011001010001100011111010001100011111011010100110100;
			5'h07: rd_q <= 168'b100010010100101000001001100010010100001101010100101111000011010110000111100010100000101101110000011001011010000111000000000101000000011100001111010000101100001000000111;
			5'h06: rd_q <= 168'b100001011100011000111110011110110001111010011011011101101001011100010000000110001001011001111110001111110110110110001110010001111001111011000111101011111011101010110100;
			5'h05: rd_q <= 168'b001011001100000011100100110110001101111010111000010110001010111001100110001000100010011111001001011101110111010011001100100001110111000100000001100011111010010000001010;
			5'h04: rd_q <= 168'b000000101011101001000010100001101111011101110001001001111001110110000100001111100000010100110000110110111011101001101101111110101101111100010100010111101110001010111100;
			5'h03: rd_q <= 168'b101010101101010100101111100001011000110011110001110000001111001111110110010111010010100110110011111011010011001110100001010011100011001011010111000011000111011010110000;
			5'h02: rd_q <= 168'b011011111010011010101100010110011111011111111010000010110001111001001111101100011111011000000010010100001111011101001111101111010000011111100110001101110001011000110111;
			5'h01: rd_q <= 168'b010011111000110000110011001000110101011110111110110100111011010000010001100111101100001101101100000111010000010011101001010000100110011101000100011111011001001100100011;
			5'h00: rd_q <= 168'b010010101000000100011101011110000111001001000001101010001110011011101111011100001010001001110111010101101101001100101000100010000010100011101110011000010000001110010110;
		default:rd_q <= 168'b0;
		endcase
	end
end

endmodule