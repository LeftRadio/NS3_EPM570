module MIN_MAX
(
input [7:0]    DATA_IN,
input          EN,
input          CLK,
input          CLR,

output reg [7:0] DATA_REG,
output reg [7:0] MAX_DATA_OUT,
output reg [7:0] MIN_DATA_OUT
);

		
always @(posedge CLK) begin

	if(CLR == 0) begin
		DATA_REG <= 0;
		MAX_DATA_OUT <= 0;  
		MIN_DATA_OUT <= 0;      
	end
	else begin
			
		DATA_REG <= DATA_IN;
			
		if((DATA_REG >= MAX_DATA_OUT) | (EN == 1)) begin
			MAX_DATA_OUT <= DATA_REG;
		end;
		
		if((DATA_REG <= MIN_DATA_OUT) | (EN == 1)) begin
			MIN_DATA_OUT <= DATA_REG;
		end;	
	end
		
end  //always

endmodule
