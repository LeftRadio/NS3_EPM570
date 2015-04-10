module MIN_MAX
(

input [7:0]    A_DATA_IN,
input [7:0]    LA_DATA_IN,
input          LA_SOURSE,
input          MAX_MIN,
input          EN,
input          CLK,
input          CLR,

output reg [7:0] SYNC_OUT_DATA,
output reg [7:0] SRAM_OUT_DATA

);

reg [7:0] MAX_DATA_OUT;
reg [7:0] MIN_DATA_OUT;

wire [7:0] IN_DATA = (LA_SOURSE == 0)? A_DATA_IN : LA_DATA_IN;
wire MIN_MAX_LOAD = LA_SOURSE | EN;
	

always @(posedge CLK) begin

	if(CLR == 0) begin		
		MAX_DATA_OUT <= 0;  
		MIN_DATA_OUT <= 0;
		SRAM_OUT_DATA <= 0;
		SYNC_OUT_DATA <= 0;     
	end
	else begin
			
		SYNC_OUT_DATA <= IN_DATA;
		
		/* maximum for in data */
		if((IN_DATA >= MAX_DATA_OUT) | MIN_MAX_LOAD) begin
				MAX_DATA_OUT <= SYNC_OUT_DATA;
		end;
		
		/* minimum for in data */
		if((IN_DATA <= MIN_DATA_OUT) | MIN_MAX_LOAD) begin
				MIN_DATA_OUT <= SYNC_OUT_DATA;
		end;
			
				
		if(MAX_MIN == 0) begin
			SRAM_OUT_DATA <= MAX_DATA_OUT;	
		end
		else begin
			SRAM_OUT_DATA <= MIN_DATA_OUT;	
		end;
		
	end
		
end  //always

endmodule
