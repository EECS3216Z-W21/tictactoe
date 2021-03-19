function is_valid(input wire [8:0] location,input reg [1:0] board [8:0]);
	
	if(location == 9'b000000001) begin
		is_valid = board[0] == 2'b00;
	end
	else if(location == 9'b000000010) begin
		is_valid = board[1] == 2'b00;
	end
	else if(location == 9'b000000100) begin
		is_valid = board[2] == 2'b00;
	end
	else if(location == 9'b000001000) begin
		is_valid = board[3] == 2'b00;
	end
	else if(location == 9'b000010000) begin
		is_valid = board[4] == 2'b00;
	end
	else if(location == 9'b000100000) begin
		is_valid = board[5] == 2'b00;
	end
	else if(location == 9'b001000000) begin
		is_valid = board[6] == 2'b00;
	end
	else if(location == 9'b010000000) begin
		is_valid = board[7] == 2'b00;
	end
	else if(location == 9'b100000000) begin
		is_valid = board[8] == 2'b00;
	end
	else begin
		is_valid = 0;
	end
endfunction