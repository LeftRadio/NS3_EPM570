
`include "trigger.v"


module Synchronization
(	
	input [7:0] SYNC_DATA_IN,
	input [7:0] Delay,
	input [7:0] Trg_Lv_UP,
	input [7:0] Trg_Lv_DOWN,
	input [7:0] LA_MASK_CND,
	input [7:0] LA_MASK_DIFF,
	
	input ADC_LA_SYNC_SOURSE,
	input ADC_SYNC_OUT_WIN,
	input [1:0] LA_SYNC_MODE,

	input SYNC_GLOBAL_ON,
	input Start_Write,	
	input ENABLE_TRIGG,
	input CLK_EN,
	input EN,
	input CLK,
   
	output reg WinCnt_EN,
	output SRAM_WR
);


wire ADC_trigger_event;
wire LA_trigger_event;

assign SRAM_WR = ~WinCnt_EN;

/* sync sourse registers */
reg sync_gl_on_adc;
reg sync_gl_on_la;


always @(posedge CLK) begin
	
	WinCnt_EN <= ( (EN | CLK_EN) & (ADC_trigger_event & LA_trigger_event) );
	
	if(ADC_LA_SYNC_SOURSE == 0) begin
		
		sync_gl_on_adc <= 1'b1;
		sync_gl_on_la <= 1'b0;
		
	end
	else begin
		
		sync_gl_on_adc <= 1'b0;
		sync_gl_on_la <= 1'b1;
		
	end
	
end



trigger  trigger_1
(
	.CLK(CLK),
	.CLK_EN(CLK_EN),
	.Trg_Lv_UP(Trg_Lv_UP),
	.Trg_Lv_DOWN(Trg_Lv_DOWN),
	.TRIG_DATA_IN(SYNC_DATA_IN),         
	.Delay(Delay),             
	.Start_Write(Start_Write),
	
	.Sync_OUT_WIN(ADC_SYNC_OUT_WIN),
	.sync_ON(sync_gl_on_adc),
	.Enable_Trig(ENABLE_TRIGG),
	       
	.trig_out(ADC_trigger_event)
);
          

LA_TRIG LA_TRIG_1
(
	.DATA_IN(SYNC_DATA_IN),
	.Trg_Lv_UP(Trg_Lv_UP),
	.Trg_Lv_DOWN(Trg_Lv_DOWN),
	.LA_MASK_CND(LA_MASK_CND),
	.LA_MASK_DIFF(LA_MASK_DIFF),	//
	
	.SYNC_MODE(LA_SYNC_MODE),		//	
	.RST(sync_gl_on_la),  
	.ENABLE(ENABLE_TRIGG),			// 
	.CLK(CLK),
    
	.trig_out(LA_trigger_event)		//
);       


endmodule 

