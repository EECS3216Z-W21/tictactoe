// Code adapted from DE-10 Lite demonstration code.
// Modified by Adam Silverman, 2021.

module vga_controller(iRST_n,
                      iVGA_CLK,
					  board,
                      oBLANK_n,
                      oHS,
                      oVS,
                      oVGA_B,
                      oVGA_G,
                      oVGA_R);
input iRST_n;
input iVGA_CLK;
input reg [1:0] board [8:0]
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [3:0] oVGA_B;
output [3:0] oVGA_G;  
output [3:0] oVGA_R;                       
///////// ////                     
wire [9:0] col;
wire [8:0] row;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;

video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS),
										.col(col),
										.row(row)
										);
										

										
// Combinational circuitry for output
reg [3:0] red;
reg [3:0] blue;
reg [3:0] green;

parameter LEFT_EDGE = 150;
parameter TOP_EDGE = 70;
parameter LINE_WIDTH = 10;
parameter CELL_WIDTH = 100;

parameter RIGHT_EDGE = LEFT_EDGE + 4*LINE_WIDTH + 3*CELL_WIDTH;
parameter BOTTOM_EDGE = TOP_EDGE + 4*LINE_WIDTH + 3*CELL_WIDTH;

always@(posedge iVGA_CLK)
begin
	if (~iRST_n) begin
		red <= 4'h0;
		green <= 4'h0;
		blue <= 4'h0;
	end else begin
		if (cBLANK_n == 1'b1) begin
			// Board lines
			if (col >= LEFT_EDGE && col < LEFT_EDGE + LINE_WIDTH && row >= TOP_EDGE && row < BOTTOM_EDGE) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= LEFT_EDGE + LINE_WIDTH + CELL_WIDTH && col < LEFT_EDGE + 2*LINE_WIDTH + CELL_WIDTH && row >= TOP_EDGE && row < BOTTOM_EDGE) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= LEFT_EDGE + 2*LINE_WIDTH + 2*CELL_WIDTH && col < LEFT_EDGE + 3*LINE_WIDTH + 2*CELL_WIDTH && row >= TOP_EDGE && row < BOTTOM_EDGE) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= LEFT_EDGE + 3*LINE_WIDTH + 3*CELL_WIDTH && col < LEFT_EDGE + 4*LINE_WIDTH + 3*CELL_WIDTH && row >= TOP_EDGE && row < BOTTOM_EDGE) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= LEFT_EDGE && col < RIGHT_EDGE && row >= TOP_EDGE && row < TOP_EDGE + LINE_WIDTH) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= LEFT_EDGE && col < RIGHT_EDGE && row >= TOP_EDGE + LINE_WIDTH + CELL_WIDTH && row < TOP_EDGE + 2*LINE_WIDTH + CELL_WIDTH) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= LEFT_EDGE && col < RIGHT_EDGE && row >= TOP_EDGE + 2*LINE_WIDTH + 2*CELL_WIDTH && row < TOP_EDGE + 3*LINE_WIDTH + 2*CELL_WIDTH) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= LEFT_EDGE && col < RIGHT_EDGE && row >= TOP_EDGE + 3*LINE_WIDTH + 3*CELL_WIDTH && row < TOP_EDGE + 4*LINE_WIDTH + 3*CELL_WIDTH) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end
			
			// Cells, in order
			// 0 1 2
			// 3 4 5
			// 6 7 8
			
			//00 => unoccupied
			//01 => unused
			//10 => player 1
			//11 => player 2
			else if (col >= LEFT_EDGE + LINE_WIDTH && col < LEFT_EDGE + LINE_WIDTH + CELL_WIDTH && row >= TOP_EDGE + LINE_WIDTH && row < TOP_EDGE + LINE_WIDTH + CELL_WIDTH) begin
				if (board[0] == 2'b00) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[0] == 2'b10) begin
					red <= 4'h7;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[0] == 2'b11) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h7;
				end
			end else if (col >= LEFT_EDGE + 2*LINE_WIDTH + CELL_WIDTH && col < LEFT_EDGE + 2*LINE_WIDTH + 2*CELL_WIDTH && row >= TOP_EDGE + LINE_WIDTH && row < TOP_EDGE + LINE_WIDTH + CELL_WIDTH) begin
				if (board[1] == 2'b00) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[1] == 2'b10) begin
					red <= 4'h7;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[1] == 2'b11) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h7;
				end
			end else if (col >= LEFT_EDGE + 3*LINE_WIDTH + 2*CELL_WIDTH && col < LEFT_EDGE + 3*LINE_WIDTH + 3*CELL_WIDTH && row >= TOP_EDGE + LINE_WIDTH && row < TOP_EDGE + LINE_WIDTH + CELL_WIDTH) begin
				if (board[2] == 2'b00) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[2] == 2'b10) begin
					red <= 4'h7;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[2] == 2'b11) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h7;
				end
			end else if (col >= LEFT_EDGE + LINE_WIDTH && col < LEFT_EDGE + LINE_WIDTH + CELL_WIDTH && row >= TOP_EDGE + 2*LINE_WIDTH + CELL_WIDTH && row < TOP_EDGE + 2*LINE_WIDTH + 2*CELL_WIDTH) begin
				if (board[3] == 2'b00) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[3] == 2'b10) begin
					red <= 4'h7;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[3] == 2'b11) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h7;
				end
			end else if (col >= LEFT_EDGE + 2*LINE_WIDTH + CELL_WIDTH && col < LEFT_EDGE + 2*LINE_WIDTH + 2*CELL_WIDTH && row >= TOP_EDGE + 2*LINE_WIDTH + CELL_WIDTH && row < TOP_EDGE + 2*LINE_WIDTH + 2*CELL_WIDTH) begin
				if (board[4] == 2'b00) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[4] == 2'b10) begin
					red <= 4'h7;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[4] == 2'b11) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h7;
				end
			end else if (col >= LEFT_EDGE + 3*LINE_WIDTH + 2*CELL_WIDTH && col < LEFT_EDGE + 3*LINE_WIDTH + 3*CELL_WIDTH && row >= TOP_EDGE + 2*LINE_WIDTH + CELL_WIDTH && row < TOP_EDGE + 2*LINE_WIDTH + 2*CELL_WIDTH) begin
				if (board[5] == 2'b00) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[5] == 2'b10) begin
					red <= 4'h7;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[5] == 2'b11) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h7;
				end
			end else if (col >= LEFT_EDGE + LINE_WIDTH && col < LEFT_EDGE + LINE_WIDTH + CELL_WIDTH && row >= TOP_EDGE + 3*LINE_WIDTH + 2*CELL_WIDTH && row < TOP_EDGE + 3*LINE_WIDTH + 3*CELL_WIDTH) begin
				if (board[6] == 2'b00) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[6] == 2'b10) begin
					red <= 4'h7;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[6] == 2'b11) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h7;
				end
			end else if (col >= LEFT_EDGE + 2*LINE_WIDTH + CELL_WIDTH && col < LEFT_EDGE + 2*LINE_WIDTH + 2*CELL_WIDTH && row >= TOP_EDGE + 3*LINE_WIDTH + 2*CELL_WIDTH && row < TOP_EDGE + 3*LINE_WIDTH + 3*CELL_WIDTH) begin
				if (board[7] == 2'b00) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[7] == 2'b10) begin
					red <= 4'h7;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[7] == 2'b11) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h7;
				end
			end else if (col >= LEFT_EDGE + 3*LINE_WIDTH + 2*CELL_WIDTH && col < LEFT_EDGE + 3*LINE_WIDTH + 3*CELL_WIDTH && row >= TOP_EDGE + 3*LINE_WIDTH + 2*CELL_WIDTH && row < TOP_EDGE + 3*LINE_WIDTH + 3*CELL_WIDTH) begin
				if (board[8] == 2'b00) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[8] == 2'b10) begin
					red <= 4'h7;
					green <= 4'h0;
					blue <= 4'h0;
				end else if (board[8] == 2'b11) begin
					red <= 4'h0;
					green <= 4'h0;
					blue <= 4'h7;
				end
			end
			
			// Default background colour
			else begin
				red <= 4'h0;
				green <= 4'h7;
				blue <= 4'h0;
			end
		// Outside of bounds
		end else begin
			red <= 4'h0;
			green <= 4'h0;
			blue <= 4'h0;
		end
	end
end

assign oVGA_B = blue;
assign oVGA_G = green; 
assign oVGA_R = red;

///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
reg mHS, mVS, mBLANK_n;
always@(posedge iVGA_CLK)
begin
  mHS<=cHS;
  mVS<=cVS;
  mBLANK_n<=cBLANK_n;
  oHS<=mHS;
  oVS<=mVS;
  oBLANK_n<=mBLANK_n;
end

////for signaltap ii/////////////
reg [18:0] H_Cont/*synthesis noprune*/;
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     H_Cont<=19'd0;
  else if (mHS==1'b1)
     H_Cont<=H_Cont+1;
	  else
	    H_Cont<=19'd0;
end
endmodule
