/**
  ******************************************************************************
  * @file       Decimation_counter.v
  * @author     Neil Lab :: Left Radio
  * @version    v1.5.0
  * @date
  * @brief      Decimation counter for sample data
  ******************************************************************************
**/

module Decimation_counter
(
	input [23:0]        Deicimation_IN,
	input				RST,
	input               CLK,

	output reg          EN,
	output reg          CLK_EN
);

/* registers */
reg [23:0]  Deicimation_reg;
reg rst;


/* IN/OUT temp registers */
always @(posedge CLK) begin

	rst <= RST;
	CLK_EN <= EN;

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