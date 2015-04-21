

module Decimation_counter
(
	input [23:0]        Deicimation_IN,
	input				RST,
	input               CLK,

	output reg          EN,
	output reg          CLK_EN
	//output reg          WIN_CNT_EN
);

/* registers */
reg [23:0]  Deicimation_reg;
reg rst;


/* */
always @(posedge CLK) begin

	rst <= RST;
	CLK_EN <= EN;
	//WIN_CNT_EN <= EN | CLK_EN; 

end

/* */
always @(posedge CLK) begin
		
	if(rst == 1'b0) begin
		
		EN <= 1'b0;		
		
	end
	else begin
   
		if(Deicimation_reg == 0) begin
			
			Deicimation_reg <= Deicimation_IN;
			EN <= 1'b1;			
			
		end
		else begin
			
			Deicimation_reg <= Deicimation_reg - 1'b1;
			EN <= 1'b0;
			
		end
		
   end
      
end	





endmodule