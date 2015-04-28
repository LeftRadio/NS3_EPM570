/**
  ******************************************************************************
  * @file       MIN_MAX_RLE.v
  * @author     Neil Lab :: Left Radio
  * @version    v2.5.0
  * @date
  * @brief      MIN_MAX_RLE module
  ******************************************************************************
**/

/* Internal includes */
`include "MIN_MAX.v"
`include "RLE.v"

module MIN_MAX_RLE
(

	input [7:0]			ADC_DATA_IN_A,
	input [7:0]			ADC_DATA_IN_B,
	input [7:0]			LA_DATA_IN,

	input				A_B_SOURSE,
	input          		LA_DATA_SOURSE,
	input				LA_SYNC_SOURSE,
	input       		MIN_MAX_LOAD,
	input				MIN_MAX_LOCK,
	input				LA_CLK_EN,	
	input          		CLK,

	output reg [7:0]	SYNC_OUT_DATA,
	output [7:0]		SRAM_OUT_DATA_A,
	output [7:0]		SRAM_OUT_DATA_B,

	output 				LA_SRAM_ADDR_CNT_EN

);

/* wires and assigns */
wire [7:0] LA_DATA;
wire [7:0] LA_CODE;

wire [7:0] ADC_SYNC_DATA = (A_B_SOURSE == 0)? adc_in_data_a : adc_in_data_b;
wire [7:0] SYNC_DATA = (LA_SYNC_SOURSE == 0)? ADC_SYNC_DATA : LA_DATA_IN;

wire [7:0] M_IN_DATA_A = (LA_DATA_SOURSE == 0)? adc_in_data_a : LA_DATA;
wire [7:0] M_IN_DATA_B = (LA_DATA_SOURSE == 0)? adc_in_data_b : LA_CODE;

wire la_addr;
assign LA_SRAM_ADDR_CNT_EN = (~LA_DATA_SOURSE) | la_addr;
wire RLE_EN = A_B_SOURSE;

/* registers */
reg [7:0] la_data_0;
reg [7:0] adc_in_data_a, adc_in_data_b;
reg min_max_load, min_max_load_0;



/* */
always @(posedge CLK) begin

	/* resync registers */
	la_data_0 <= LA_DATA_IN;
	adc_in_data_a <= ADC_DATA_IN_A;
	adc_in_data_b <= ADC_DATA_IN_B;
	
	SYNC_OUT_DATA <= SYNC_DATA;
	
	/* 2 cycle delay for min/max load */
	min_max_load_0 <= LA_DATA_SOURSE | MIN_MAX_LOAD;
	min_max_load <= min_max_load_0 ;	
	
end



/* RLE module, if OFF in data simple trnsfer to out and LA_CODE
   ignory in MCU firmware */
RLE  RLE_1
(
	.LA_IN_DATA(la_data_0),
	.CLK_EN(LA_CLK_EN),
	.RLE_EN(RLE_EN),
	.CLK(CLK),

	.LA_OUT_DATA(LA_DATA),
	.LA_RLE_OUT_DATA(LA_CODE),
	.LA_SRAM_ADDR_CNT_EN(la_addr)	
);

/* MIN/MAX module CH A */
MIN_MAX  MIN_MAX_1
(
	.DATA_IN(M_IN_DATA_A),
	.LOAD(min_max_load),
	.CLK(CLK),

	.DATA_OUT(SRAM_OUT_DATA_A)        
);

/* MIN/MAX module CH B */
MIN_MAX  MIN_MAX_2
(
	.DATA_IN(M_IN_DATA_B),
	.LOAD(min_max_load),
	.CLK(CLK),

	.DATA_OUT(SRAM_OUT_DATA_B)        
);   
   

   
endmodule 