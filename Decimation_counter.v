module Decimation_counter
(
input [23:0]        Deicimation_IN,
input               Start_WR,
input               CLK,

output reg          EN,
output reg          CLK_EN
//output              Min_Max_Sel
);

//assign Min_Max_Sel = CLK_EN;

reg [23:0]  Deicimation_reg;


always @(posedge CLK) begin

   if((Start_WR == 0) | (Deicimation_reg == 0)) begin
       Deicimation_reg <= Deicimation_IN;
       if(Start_WR != 0)EN <= 1;
       else EN <=0;
   end
   else begin
       Deicimation_reg <= Deicimation_reg - 24'b1;
       EN <= 0;
   end
   
   CLK_EN <= EN;
   
end




endmodule