

module top(
input wire p_clk12,

input wire p_upBtn,
input wire p_dwnBtn,

output reg [14:0]p_hLED,
output reg [9:0]p_vLED);

	//MAX 14
	parameter WIDTH = 4'd14; //15
	//MAX 9
	parameter HEIGHT = 4'd9; //9

	parameter POS = 2'd0;
	parameter NEG = 2'd1;
	parameter ZERO = 2'd2;


	initial begin
		p_hLED <= 15'bzzzzzzzzzzzzzzz;
		p_vLED <= 10'bzzzzzzzzzz;
	end

	reg [18:0]ctr = 0;
	reg [3:0]hIndex = 0;
	reg [3:0]vIndex = 0;

	reg [3:0]ballX = 0;
	reg [3:0]ballY = 0;
	reg [1:0]ballXVel = 0;
	reg [1:0]ballYVel = 0;

	always @(posedge p_clk12) begin
			if(hIndex == WIDTH & vIndex == HEIGHT) begin
				hIndex <= 0;
				vIndex <= 0;
			end else if(hIndex == WIDTH) begin
				vIndex <= vIndex + 1;
				hIndex <= 0;
			end else
				hIndex <= hIndex + 1;
				
			if(hIndex == ballX)
			case(hIndex)
				4'd0:
					p_hLED <= 15'bzzzzzzzzzzzzzz0;
				4'd1:
					p_hLED <= 15'bzzzzzzzzzzzzz0z;
				4'd2:
					p_hLED <= 15'bzzzzzzzzzzzz0zz;
				4'd3:
					p_hLED <= 15'bzzzzzzzzzzz0zzz;
				4'd4:
					p_hLED <= 15'bzzzzzzzzzz0zzzz;
				4'd5:
					p_hLED <= 15'bzzzzzzzzz0zzzzz;
				4'd6:
					p_hLED <= 15'bzzzzzzzz0zzzzzz; //fucking up
				4'd7:
					p_hLED <= 15'bzzzzzzz0zzzzzzz;
				4'd8:
					p_hLED <= 15'bzzzzzz0zzzzzzzz; //fucking up
				4'd9:
					p_hLED <= 15'bzzzzz0zzzzzzzzz;
				4'd10:
					p_hLED <= 15'bzzzz0zzzzzzzzzz;
				4'd11:
					p_hLED <= 15'bzzz0zzzzzzzzzzz;
				4'd12:
					p_hLED <= 15'bzz0zzzzzzzzzzzz;
				4'd13:
					p_hLED <= 15'bz0zzzzzzzzzzzzz;
				4'd14:
					p_hLED <= 15'b0zzzzzzzzzzzzzz;
				default:
					p_hLED <= 15'bzzzzzzzzzzzzzzz;
			endcase
					

			if(vIndex == ballY)
			case(vIndex)
				4'd0:
					p_vLED <= 10'bzzzzzzzzz1;
				4'd1:
					p_vLED <= 10'bzzzzzzzz1z;
				4'd2:
					p_vLED <= 10'bzzzzzzz1zz;
				4'd3:
					p_vLED <= 10'bzzzzzz1zzz;
				4'd4:
					p_vLED <= 10'bzzzzz1zzzz;
				4'd5:
					p_vLED <= 10'bzzzz1zzzzz;
				4'd6:
					p_vLED <= 10'bzzz1zzzzzz;
				4'd7:
					p_vLED <= 10'bzz1zzzzzzz;
				4'd8:
					p_vLED <= 10'bz1zzzzzzzz;
				4'd9:
					p_vLED <= 10'b1zzzzzzzzz;
				default:
					p_vLED <= 10'bzzzzzzzzzz;
			endcase

		if(&ctr) begin

			if(ballX == 1)
				ballXVel <= POS;
			if(ballY == 1)
				ballYVel <= POS;
			if(ballX == (WIDTH-1))
				ballXVel <= NEG;
			if(ballY == (HEIGHT-1))
				ballYVel <= NEG;

			if(ballYVel == POS)
				ballY <= ballY + 1;
			else if(ballYVel == NEG)
				ballY <= ballY - 1;

			if(ballXVel == POS)
				ballX <= ballX + 1;
			else if(ballXVel == NEG)
				ballX <= ballX - 1;
		end
		ctr <= ctr + 1;
	end

endmodule