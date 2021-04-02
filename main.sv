//Part 1: Module header:
module main(
	// , output logic z
	input [8:0] SW,
	input MAX10_CLK1_50,
   input KEY[2],
   output [3:0] VGA_B, VGA_G, VGA_R,
   output VGA_HS, VGA_VS,
	
    output [6:0] out1,
    output [6:0] out2
    );

	//Part 2: Declarations:

	//FSM-related declarations:
	typedef enum logic [2:0] {play, checkMove, checkWin, p1Win, p2Win, tie, reset} state;
	
	state pr_state, nx_state;


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
	
	
	reg [1:0] board [8:0] = '{
		2'b00,2'b00,2'b00,
		2'b00,2'b00,2'b00,
		2'b00,2'b00,2'b00}; 


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
	always @(posedge MAX10_CLK1_50) begin
		button_counter <= button_counter + 1;
		// negedge triggering the rst doesn't work too well
		// better to simply poll every ms and let the state transition
		// at the next frame
		
		$display("player 1");
		if(button_counter >= polling_rate) begin
			if(!rst) begin
				button_counter <= 0;
				nx_state <= play;
				player <= 0;
				board <= '{
					2'b00,2'b00,2'b00,
					2'b00,2'b00,2'b00,
					2'b00,2'b00,2'b00};
			end
			if(!select) begin
				// when button is pressed, the next frame will
				// check if the move is valid
				nx_state <= checkMove;
			end
		end
		
	
	
		// frame rate related logic
		counter <= counter + 1;

		pr_state <= nx_state;
		if (counter >= clocks_per_frame) begin
			counter <= 0;
			
			
			// state logic
			case(pr_state)
				play: begin
					//user input
					//TODO
					nx_state <= play;
				end
				checkMove: begin
					//check valid location
					if(is_valid(move, board)) begin 
						if(player == 0) begin
							board[nine_to_four(move)] <= '{2'b01};
						end
						else begin
							board[nine_to_four(move)] <= '{2'b10};
						end
						player <= 1 - player;
						nx_state <= checkWin;
					end
				end
				checkWin: begin
					//checkWin
				 
					//if not win, keep play
					//if win, go to respective win state
					case(check_win(board))
						2'b00: begin
							nx_state <= play;
						end
						2'b01: begin
							nx_state <= p1Win;
						end
						2'b10: begin
							nx_state <= p2Win;
						end
						2'b11: begin
							nx_state <= tie;
						end
					endcase 
				end
				p1Win: begin
					//player 1 wins
					wincounter1 <= wincounter1 + 1'b1;
					//-> reset board
					nx_state <= reset;
				end
				p2Win: begin
					//player 2 wins
					 wincounter2 <= wincounter2 + 1'b1;
					//-> reset board
					nx_state <= reset;
				end
				tie: begin
					//tie
			 
					//-> reset board
					nx_state <= reset;
				end
				reset: begin
					//reset board
                    if (wincounter1 >= 5'd9 || wincounter2 >= 5'd9)
						begin
						    wincounter1 <= 1'b0;
							wincounter2 <= 1'b0;
						end
			 
					//back to play
					nx_state <= play;
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
	 
    vga_controller vga_ins(.iRST_n(KEY[0]),
                        .iVGA_CLK(VGA_CTRL_CLK),
                        .board(board),
                        .oHS(VGA_HS),
                        .oVS(VGA_VS),
                        .oVGA_B(VGA_B),
                        .oVGA_G(VGA_G),
                        .oVGA_R(VGA_R)); 

    SSLED(wincounter1, out1); // player 1
    SSLED(wincounter2, out2); // player 2                       
endmodule