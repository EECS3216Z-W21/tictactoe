// Code adapted from DE-10 Lite demonstration code.
// Modified by Adam Silverman and Tuan Dau, 2020.

module vga_controller(iRST_n,
                      iVGA_CLK,
							 distance,
                      oBLANK_n,
                      oHS,
                      oVS,
                      oVGA_B,
                      oVGA_G,
                      oVGA_R);
input iRST_n;
input iVGA_CLK;
input [31:0] distance;
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

// Reuse 7seg decoders for distance - construct segments to display
wire [6:0] hundreds;
wire [6:0] tens;
wire [6:0] ones;

seg7 s0(distance % 10, ones);
seg7 s1((distance % 100) / 10, tens);
seg7 s2((distance % 1000) / 100, hundreds);

always@(posedge iVGA_CLK)
begin
	if (~iRST_n) begin
		red <= 4'h0;
		green <= 4'h0;
		blue <= 4'h0;
	end else begin
		if (cBLANK_n == 1'b1) begin
			// Hundreds digit
			if (col > 90 && col < 150 && row >= 150 && row <= 170 && ~hundreds[0]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col > 90 && col < 150 && row >= 230 && row <= 250 && ~hundreds[6]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col > 90 && col < 150 && row >= 310 && row <= 330 && ~hundreds[3]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 70 && col <= 90 && row >= 150 && row <= 240 && ~hundreds[5]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 70 && col <= 90 && row > 240 && row <= 330 && ~hundreds[4]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 150 && col <= 170 && row >= 150 && row <= 240 && ~hundreds[1]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 150 && col <= 170 && row > 240 && row <= 330 && ~hundreds[2]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end
			
			// Tens digit
			else if (col > 250 && col < 310 && row >= 150 && row <= 170 && ~tens[0]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col > 250 && col < 310 && row >= 230 && row <= 250 && ~tens[6]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col > 250 && col < 310 && row >= 310 && row <= 330 && ~tens[3]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 230 && col <= 250 && row >= 150 && row <= 240 && ~tens[5]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 230 && col <= 250 && row > 240 && row <= 330 && ~tens[4]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 310 && col <= 330 && row >= 150 && row <= 240 && ~tens[1]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 310 && col <= 330 && row > 240 && row <= 330 && ~tens[2]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end
			
			// Ones digit
			else if (col > 410 && col < 470 && row >= 150 && row <= 170 && ~ones[0]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col > 410 && col < 470 && row >= 230 && row <= 250 && ~ones[6]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col > 410 && col < 470 && row >= 310 && row <= 330 && ~ones[3]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 390 && col <= 410 && row >= 150 && row <= 240 && ~ones[5]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 390 && col <= 410 && row > 240 && row <= 330 && ~ones[4]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 470 && col <= 490 && row >= 150 && row <= 240 && ~ones[1]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end else if (col >= 470 && col <= 490 && row > 240 && row <= 330 && ~ones[2]) begin
				red <= 4'hf;
				green <= 4'hf;
				blue <= 4'hf;
			end
			
			// Default colour
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
