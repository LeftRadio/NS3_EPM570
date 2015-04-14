module WIN_Counter
(
input [17:0]	WIN_DATA,
input 			LA_RLE_CNT_EN,
input			CNT_EN,
input			RST,
input			CLK,

output reg         Write_Ready,
output reg [17:0]  WINcnt
);

reg sr_wr;


always @(posedge CLK) begin
	
	if(RST == 0) begin
		
		Write_Ready <= 0;	
		WINcnt <= 0;
		sr_wr <= 0;
			
	end
	else begin
	
		sr_wr <= CNT_EN & LA_RLE_CNT_EN;
		
		/* Count if CLK and event_in is 1 */
		if(sr_wr == 1) begin          
			             
			if(WINcnt == WIN_DATA) begin
		
				WINcnt <= 0;
				Write_Ready <= 1'b1;		
			end           
			else begin
		
				WINcnt <= WINcnt + 1'b1;							        
			end
		
		end
		
	end	
	
end

endmodule