module KeyPad (input Key[7:0], output  Board[8:0],output confirm)

input Key[7:0];
output Board[8:0];
output confirm;

reg  loc[8:0];
reg check;

loc[0] = Key[7]&Key[3];
loc[1] = Key[7]&Key[2];
loc[2] = Key[7]&Key[1];
loc[3] = Key[6]&Key[3];
loc[4] = Key[6]&Key[2];
loc[5] = Key[6]&Key[1];
loc[6] = Key[5]&Key[3];
loc[7] = Key[5]&Key[2];
loc[8] = Key[5]&Key[1];
check = Key[1]&Key[4];

assign Board = loc;
assign confirm = check;

endmodule
