
module check_win(board, status);

input reg [1:0] board [8:0];
// 00 = nobody won
// 01 = player 1 win
// 10 = player 2 win
// 11 = tie
output reg status [1:0];
if( board[0] != 00 && board[1] != 00 && board[2] != 00 &&
    board[3] != 00 && board[4] != 00 && board[5] != 00 &&
    board[6] != 00 && board[7] != 00 && board[8] != 00 )
    begin
        assign status = 2'b11;
    end
else if(board[0] != 00 && board[0] == board[1] && board[1] == board[2])
    begin
	    assign status = board[0];
    end
else if (board[3] != 00 && board[3] == board[4] && board[4] == board[5])
    begin
        assign status = board[3];
    end
else if (board[6] != 00 && board[6] == board[7] && board[7] == board[8])
    begin
        assign status = board[6];
    end
else if (board[0] != 00 && board[0] == board[3] && board[3] == board[6])
    begin
        assign status = board[0];
    end
else if (board[1] != 00 && board[1] == board[4] && board[4] == board[7])
    begin
        assign status = board[1];
    end
else if (board[2] != 00 && board[2] == board[5] && board[5] == board[8])
    begin
        assign status = board[2];
    end
else if (board[0] != 00 && board[0] == board[4] && board[4] == board[8])
    begin
        assign status = board[0]
    end
else if (board[2] != 00 && board[2] == board[4] && board[4] == board[6])
    begin
        assign status = board[2];
    end
endmodule
