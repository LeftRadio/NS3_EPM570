module MIN_MAX
(
input [7:0]    A_DATA_IN,
input [7:0]    LA_DATA_IN,
input          LA_SOURSE,
input          EN,
input          CLK,
input          CLR,

output reg [7:0] MAX_DATA_OUT,
output reg [7:0] MIN_DATA_OUT
);

wire [7:0] IN_DATA = (LA_SOURSE == 0)? A_DATA_IN : LA_DATA_IN;
		

	
always @(posedge CLK) begin

	if(CLR == 0) begin		
		MAX_DATA_OUT <= 0;  
		MIN_DATA_OUT <= 0;      
	end
	else begin
			
		if(EN == 1)	begin
			if((IN_DATA >= MAX_DATA_OUT) | (LA_SOURSE == 1)) begin
				MAX_DATA_OUT <= IN_DATA;
			end;
			if((IN_DATA <= MIN_DATA_OUT) | (LA_SOURSE == 1)) begin
				MIN_DATA_OUT <= IN_DATA;
			end;
		end
		
		
	end
		
end  //always

endmodule
