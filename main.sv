//Part 1: Module header:
module main(clk, select, rst, move);
	// , output logic z
	
	input clk, select, rst;
	input reg [8:0]move;

	//Part 2: Declarations:

	//FSM-related declarations:
	typedef enum logic [2:0] {play, checkMove, checkWin, p1Win, p2Win, tie, reset} state;
	
	state pr_state, nx_state;

	// functions used
	// check_input(location[8:0], board, isValid);


	//this is a board made of 9 2-bit spaces 
	//0 1 2
	//3 4 5
	//6 7 8

	//00 => unoccupied
	//01 => player 1
	//10 => player 2
	//11 => unused
	reg [1:0] board [8:0] = '{
		2'b00,2'b00,2'b00,
		2'b00,2'b00,2'b00,
		2'b00,2'b00,2'b00}; 


	reg player; //this is the current player
	//0 => player 1
	//1 => player 2

	reg [8:0] location; //this is the location a player is making a move to
	wire [1:0] winner; //output of checkWin

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
	always @(posedge clk) begin
		button_counter <= button_counter + 1;
		// negedge triggering the rst doesn't work too well
		// better to simply poll every ms and let the state transition
		// at the next frame
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
							board[nine_to_four(location)] <= '{2'b01};
						end
						else begin
							board[nine_to_four(location)] <= '{2'b10};
						end
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
					 
					 //-> reset board
					nx_state <= reset;
				end
				p2Win: begin
					 //player 2 wins
					 
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
			 
					//back to play
					nx_state <= play;
				end
			endcase	
		end
	end
endmodule 

// if ({x,y} == 2’b01) begin z=1’b1; nx_state <= B; end
// else begin z=1’b0; nx_state <= A; end