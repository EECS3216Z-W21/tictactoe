//Part 1: Module header:
module main(
	// , output logic z
	input [8:0] SW,
	input MAX10_CLK1_50,
   input KEY[2],
   output [3:0] VGA_B, VGA_G, VGA_R,
   output VGA_HS, VGA_VS,
	 output [6:0] HEX0,
	 output [6:0] HEX1,
    output [9:0] LEDR
	 );

	//Part 2: Declarations:

	//FSM-related declarations:
	typedef enum logic [2:0] {play, checkMove, checkWin, p1Win, p2Win, tie, reset} state;
	
	state pr_state;


	//this is a board made of 9 2-bit spaces 
	//0 1 2
	//3 4 5
	//6 7 8

	//00 => unoccupied
	//01 => player 1
	//10 => player 2
	//11 => unused
	
	wire [8:0]move = SW[8:0];
	wire select = KEY[0];
	wire rst = KEY[1];
	
	wire [6:0] out1 = HEX0[6:0];
  	wire [6:0] out2 = HEX1[6:0];
	


	reg [1:0] sq1 = 2'b00;
	reg [1:0] sq2 = 2'b00;
	reg [1:0] sq3 = 2'b00;
	reg [1:0] sq4 = 2'b00;
	reg [1:0] sq5 = 2'b00;
	reg [1:0] sq6 = 2'b00;
	reg [1:0] sq7 = 2'b00;
	reg [1:0] sq8 = 2'b00;
	reg [1:0] sq9 = 2'b00;

	reg [1:0] board [8:0] = '{
	2'b00,2'b00,2'b00,
	2'b00,2'b00,2'b00,
	2'b00,2'b00,2'b00}; 

	reg [6:0] CheckState;

	reg player; //this is the current player
	//0 => player 1
	//1 => player 2

	wire [1:0] winner; //output of checkWin

    reg [4:0] wincounter1 = 5'd0;
	reg [4:0] wincounter2 = 5'd0;

	//TODO - RESET BUTTON TIMER LOGIC
	//Timer-related declarations:
	//const logic [7:0] T1 = <value>, tmax = <value>;
	//always_ff @(posedge clk, posedge rst) if (rst) t <= 0;
	//else if (t < tmax) t <= t + 1; else t <= 0;


	parameter frequency = 10000000;
	
	reg [31:0] counter = 32'd0;
	parameter fps = 60;
	parameter clocks_per_frame = frequency/fps;
	
	// 1000 hz rst polling
	reg [31:0] button_counter = 32'd0;
	parameter polling_rate = frequency/1000;

	reg is_valid = 1'b0;
	reg [3:0] nine_to_four = 4'b0;
	reg [1:0] check_win = 2'b0;
	always @(posedge MAX10_CLK1_50) begin
		button_counter <= button_counter + 1;
		if(pr_state == play)
		begin
			CheckState <= 6'b0000001;
		end
		else if(pr_state == checkMove)
		begin
			CheckState <= 6'b0000010;
		end
		else if(pr_state == checkWin)
		begin
			CheckState <= 6'b0000100;
		end
		else if(pr_state == p1Win)
		begin
			CheckState <= 6'b0001000;
		end
		else if(pr_state == p2Win)
		begin
			CheckState <= 6'b0010000;
		end
		else if(pr_state == tie)
		begin
			CheckState <= 6'b0100000;
		end
		else if(pr_state == reset)
		begin
			CheckState <= 6'b100000;
		end
		
		
		// negedge triggering the rst doesn't work too well
		// better to simply poll every ms and let the state transition
		// at the next frame
		if(button_counter >= polling_rate) begin
			button_counter <= 0;
			if(!rst) begin
				
				pr_state <= reset;
				wincounter1 <= 1'b0;
				wincounter2 <= 1'b0;
		
			end
			if(!select) begin
				// when button is pressed, the next frame will
				// check if the move is valid
				pr_state <= checkMove;
			end
		end
		
	
	
		// frame rate related logic
		counter <= counter + 1;

		board = '{
			sq1,sq2,sq3,
			sq4,sq5,sq6,
			sq7,sq8,sq9}; 
		

		// 00 <= nobody won
		// 01 <= player 1 win
		// 10 <= player 2 win
		// 11 <= tie

		if( board[0] !== 00 && board[1] !== 00 && board[2] !== 00 &&
			 board[3] !== 00 && board[4] !== 00 && board[5] !== 00 &&
			 board[6] !== 00 && board[7] !== 00 && board[8] !== 00 )
			 begin
					check_win <= 2'b11;
			 end
		else if(board[0] !== 00 && board[0] == board[1] && board[1] == board[2])
			 begin
				  check_win <= board[0];
			 end
		else if (board[3] !== 00 && board[3] == board[4] && board[4] == board[5])
			 begin
					check_win <= board[3];
			 end
		else if (board[6] !== 00 && board[6] == board[7] && board[7] == board[8])
			 begin
					check_win <= board[6];
			 end
		else if (board[0] !== 00 && board[0] == board[3] && board[3] == board[6])
			 begin
					check_win <= board[0];
			 end
		else if (board[1] !== 00 && board[1] == board[4] && board[4] == board[7])
			 begin
					check_win <= board[1];
			 end
		else if (board[2] !== 00 && board[2] == board[5] && board[5] == board[8])
			 begin
					check_win <= board[2];
			 end
		else if (board[0] !== 00 && board[0] == board[4] && board[4] == board[8])
			 begin
					check_win <= board[0];
			 end
		else if (board[2] !== 00 && board[2] == board[4] && board[4] == board[6])
			 begin
					check_win <= board[2];
			 end
		else	
			begin
				check_win <= 2'b00;
			end
			 
			 
		if(move == 9'b000000001) begin
			is_valid <= board[0] == 2'b00;
		end
		else if(move == 9'b000000010) begin
			is_valid <= board[1] == 2'b00;
		end
		else if(move == 9'b000000100) begin
			is_valid <= board[2] == 2'b00;
		end
		else if(move == 9'b000001000) begin
			is_valid <= board[3] == 2'b00;
		end
		else if(move == 9'b000010000) begin
			is_valid <= board[4] == 2'b00;
		end
		else if(move == 9'b000100000) begin
			is_valid <= board[5] == 2'b00;
		end
		else if(move == 9'b001000000) begin
			is_valid <= board[6] == 2'b00;
		end
		else if(move == 9'b010000000) begin
			is_valid <= board[7] == 2'b00;
		end
		else if(move == 9'b100000000) begin
			is_valid <= board[8] == 2'b00;
		end
		else begin
			is_valid <= 0;
		end


		if (counter >= clocks_per_frame) begin
			counter <= 0;
			
			
			// state logic
			case(pr_state)
				play: begin
					// holding state
				end
				checkMove: begin
					// check valid location
					if (1==1) begin
						// if it's stupid and it works,
						// is it really that stupid?
						if(move == 9'b000000001) begin
							if(player == 0) begin
								sq1 = 2'b01;
							end
							else begin
								sq1 <= 2'b10;
							end
						end
						else if(move == 9'b000000010) begin
							if(player == 0) begin
								sq2 <= 2'b01;
							end
							else begin
								sq2 <= 2'b10;
							end
						end
						else if(move == 9'b000000100) begin
							if(player == 0) begin
								sq3 <= 2'b01;
							end
							else begin
								sq3 <= 2'b10;
							end
						end
						else if(move == 9'b000001000) begin
							if(player == 0) begin
								sq4 <= 2'b01;
							end
							else begin
								sq4 <= 2'b10;
							end
						end
						else if(move == 9'b000010000) begin
							if(player == 0) begin
								sq5 <= 2'b01;
							end
							else begin
								sq5 <= 2'b10;
							end
						end
						else if(move == 9'b000100000) begin
							if(player == 0) begin
								sq6 <= 2'b01;
							end
							else begin
								sq6 <= 2'b10;
							end
						end
						else if(move == 9'b001000000) begin
							if(player == 0) begin
								sq7 <= 2'b01;
							end
							else begin
								sq7 <= 2'b10;
							end
						end
						else if(move == 9'b010000000) begin
							if(player == 0) begin
								sq8 <= 2'b01;
							end
							else begin
								sq8 <= 2'b10;
							end
						end
						else if(move == 9'b100000000) begin
							if(player == 0) begin
								sq9 <= 2'b01;
							end
							else begin
								sq9 <= 2'b10;
							end
						end
						player <= 1 - player;
						pr_state <= checkWin;

					end
					else begin
						pr_state <= play;
					end
				end
				checkWin: begin
					//checkWin
				 
					//if not win, keep play
					//if win, go to respective win state
					case(check_win)
						2'b00: begin
							pr_state <= play;
						end
						2'b01: begin
							pr_state <= p1Win;
						end
						2'b10: begin
							pr_state <= p2Win;	
						end
						2'b11: begin
							pr_state <= tie;
						end
					endcase 
				end
				p1Win: begin
					//player 1 wins
					wincounter1 <= wincounter1 + 1'b1;
					//-> reset board
					pr_state <= reset;
				end
				p2Win: begin
					//player 2 wins
					 wincounter2 <= wincounter2 + 1'b1;
					//-> reset board
					pr_state <= reset;
				end
				tie: begin
					//tie
			 
					//-> reset board
					pr_state <= reset;
				end
				reset: begin
					//reset board
                    if (wincounter1 >= 5'd9 || wincounter2 >= 5'd9)
						begin
						wincounter1 <= 1'b0;
						wincounter2 <= 1'b0;
	
						end
					player <= 0;
					sq1 = 2'b00;
					sq2 = 2'b00;
					sq3 = 2'b00;
					sq4 = 2'b00;
					sq5 = 2'b00;
					sq6 = 2'b00;
					sq7 = 2'b00;
					sq8 = 2'b00;
					sq9 = 2'b00;
					//back to play
					pr_state <= play;
				end
				default: begin
					CheckState <= 6'b010000;
				end
			endcase	
		end
	end
	
    // VGA
    wire VGA_CTRL_CLK;
                    
    vga_pll u1(
    .areset(),
    .inclk0(MAX10_CLK1_50),
    .c0(VGA_CTRL_CLK),
    .locked());

    
	 wire VGARST;
	 
    vga_controller vga_ins(.iRST_n(1),
                        .iVGA_CLK(VGA_CTRL_CLK),
                        .board(board),
                        .oHS(VGA_HS),
                        .oVS(VGA_VS),
                        .oVGA_B(VGA_B),
                        .oVGA_G(VGA_G),
                        .oVGA_R(VGA_R)); 

    SSLED(wincounter1, out1); // player 1
    SSLED(wincounter2, out2); // player 2
	 assign LEDR[6:0] = CheckState[6:0]; 
	 
endmodule