function nine_to_four(input wire location[8:0]);
	if(location == 9'b000000001) begin
		nine_to_four = 4'b0000;
	end
	else if(location == 9'b000000010) begin
		nine_to_four = 4'b0001;
	end
	else if(location == 9'b000000100) begin
		nine_to_four = 4'b0010;
	end
	else if(location == 9'b000001000) begin
		nine_to_four = 4'b0011;
	end
	else if(location == 9'b000010000) begin
		nine_to_four = 4'b0100;
	end
	else if(location == 9'b000100000) begin
		nine_to_four = 4'b0101;
	end
	else if(location == 9'b001000000) begin
		nine_to_four = 4'b0110;
	end
	else if(location == 9'b010000000) begin
		nine_to_four = 4'b0111;
	end
	else if(location == 9'b100000000) begin
		nine_to_four = 4'b1000;
	end
endfunction