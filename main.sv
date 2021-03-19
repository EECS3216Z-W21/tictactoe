//Part 1: Module header:
module main(clk, rst, move);
// , output logic z

input logic clk;
input logic rst;
input reg [8:0]move;

//Part 2: Declarations:

//FSM-related declarations:
typedef enum logic [2:0] {play, checkWin, p1Win, p2Win, tie, reset} state;
state pr_state, nx_state;

//Modules used
//check_input(location[8:0], board, isValid);

/* Check_win
00 => no win
01 => p1
10 => p2
11 => tie/cat's game
*/

check_win(board, winner);

//this is a board made of 9 2-bit spaces 
//0 1 2
//3 4 5
//6 7 8

//00 => unoccupied
//01 => unused
//10 => player 1
//11 => player 2
reg [1:0] board [8:0]; 


reg player; //this is the current player
//0 => player 1
//1 => player 2

reg [8:0] location; //this is the location a player is making a move to

wire isValid; //is a move valid

wire [1:0] winner; //output of checkWin

//TODO - RESET BUTTON TIMER LOGIC
//Timer-related declarations:
//const logic [7:0] T1 = <value>, tmax = <value>;
//always_ff @(posedge clk, posedge rst) if (rst) t <= 0;
//else if (t < tmax) t <= t + 1; else t <= 0;

//FSM state register:
always_ff @(posedge clk, posedge rst)
 if(rst) pr_state <= play; else pr_state <= nx_state;

//FSM combinational logic: 
always
case(pr_state)
	 play: begin
		//user input
		//TODO
		
		//check valid location
			if(isValid == 1'b0) begin 
				//go back to play state?
				nx_state <= play;
			end
			else begin
				//check if win
//				player = ~player;
				nx_state <= checkWin;
			end
	 end
	 checkWin: begin
	 //checkWin
	 
	 //if not win, keep play
	 //if win, go to respective win state
		 if(winner == 2'b00) begin
				nx_state <= play;
		 end
		 else if (winner == 2'b01) begin
			nx_state <= p1Win;
		 end
		 else if (winner == 2'b01) begin
			nx_state <= p2Win;
		 end
		 else if (winner == 2'b11) begin
			nx_state <= tie;
		 end 
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
endmodule 

// if ({x,y} == 2’b01) begin z=1’b1; nx_state <= B; end
// else begin z=1’b0; nx_state <= A; end