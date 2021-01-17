module Top(
input wire p_clk12,

input wire p_upBtn_p1,
input wire p_dwnBtn_p1,

input wire p_upBtn_p2,
input wire p_dwnBtn_p2,

output reg [14:0]p_hLED,
output reg [9:0]p_vLED);

	//MAX 14 display width
	parameter WIDTH = 4'd14; //15
	//MAX 9 display height
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
	
	reg [3:0] paddleY_p1 = 0;
	reg [3:0] paddleY_p2 = 0;

	always @(posedge p_clk12) begin
	        //Draws the display
			if(hIndex == WIDTH & vIndex == HEIGHT) begin
				hIndex <= 0;
				vIndex <= 0;
			end else if(hIndex == WIDTH) begin
				vIndex <= vIndex + 1;
				hIndex <= 0;
			end else
				hIndex <= hIndex + 1;
				
	        //Draw ball and paddles
			if(hIndex == ballX | hIndex == 0 | hIndex == WIDTH)
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
					p_hLED <= 15'bzzzzzzzz0zzzzzz; //poorly reflowed LED (dead pixel)
				4'd7:
					p_hLED <= 15'bzzzzzzz0zzzzzzz;
				4'd8:
					p_hLED <= 15'bzzzzzz0zzzzzzzz; //poorly reflowed LED (dead pixel)
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
					

			if(vIndex == ballY | 
			vIndex >= paddleY_p1-1 | vIndex <= paddleY_p1+1 |
			vIndex >= paddleY_p2-1 | vIndex <= paddleY_p2+1)
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

            //Ball paddle / wall collisions
			if(ballX == 1 & ballY >= (paddleY_p1-1) & ballY >= (paddleY_p1+1))
				ballXVel <= POS;
		    else if(ballX == 1) fork //out of bounds
		        ballX <= 7;
		        ballY <= 5;
		    join
		    
			if(ballX == (WIDTH-1) & ballY >= (paddleY_p2-1) & ballY >= (paddleY_p2+1))
				ballXVel <= NEG;
		    else if(ballX == (WIDTH-1)) fork //out of bounds
		        ballX <= 7;
		        ballY <= 5;
		    join
		    
		    //Vertical ball collision handling
			if(ballY == (HEIGHT-1))
				ballYVel <= NEG;
		    if(ballY == 1)
				ballYVel <= POS;
		      
		    //Paddle movement logic
			if(paddleY_p1 <= (HEIGHT-1) & p_upBtn_p1)
			    paddleY_p1 <= paddleY_p1 + 1;
			if(paddleY_p1 >= 1 & p_dwnBtn_p1)
			    paddleY_p1 <= paddleY_p1 - 1;
			    
			if(paddleY_p2 <= (HEIGHT-1) & p_upBtn_p2)
			    paddleY_p2 <= paddleY_p2 + 1;
			if(paddleY_p2 >= 1 & p_dwnBtn_p2)
			    paddleY_p2 <= paddleY_p2 - 1;
			     
            //Ball animation
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