
`include "MIN_MAX.v"
`include "RLE.v"

module MIN_MAX_RLE
(

input [7:0]		ADC_DATA_IN_A,
input [7:0]		ADC_DATA_IN_B,
input [7:0]		LA_DATA_IN,

input			A_B_SOURSE,
input          	LA_SOURSE,
input       	MIN_MAX_LOAD,
input			RLE_EN,
input          	CLK,

output [7:0]	SYNC_OUT_DATA,
output [7:0]	SRAM_OUT_DATA_A,
output [7:0]	SRAM_OUT_DATA_B,

output 			LA_SRAM_ADDR_CNT_EN

);


reg [7:0]  la_data;
wire [7:0] LA_DATA;
wire [7:0] LA_CODE;



always @(posedge CLK) begin
	
	la_data <= LA_DATA_IN;
	
end




MIN_MAX  MIN_MAX_1
(
	.ADC_DATA_IN_A(ADC_DATA_IN_A),
	.ADC_DATA_IN_B(ADC_DATA_IN_B),
	.LA_DATA_IN_A(LA_DATA),
	.LA_DATA_IN_B(LA_CODE),

	.A_B_SOURSE(A_B_SOURSE),
	.LA_SOURSE(LA_SOURSE),
	.MIN_MAX_LOAD(MIN_MAX_LOAD),
	.CLK(CLK),

	.SYNC_OUT_DATA(SYNC_OUT_DATA),
	.SRAM_OUT_DATA_A(SRAM_OUT_DATA_A),
	.SRAM_OUT_DATA_B(SRAM_OUT_DATA_B)        
);
     
         
RLE  RLE_1
(
	.LA_IN_DATA(la_data),
	.CLK_EN(MIN_MAX_LOAD),
	.RLE_EN(RLE_EN),
	.CLK(CLK),

	.LA_OUT_DATA(LA_DATA),
	.LA_RLE_OUT_DATA(LA_CODE),
	.LA_SRAM_ADDR_CNT_EN(LA_SRAM_ADDR_CNT_EN)	
);

   
endmodule 