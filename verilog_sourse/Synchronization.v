/**
  ******************************************************************************
  * @file       Synchronization.v
  * @author     Neil Lab :: Left Radio
  * @version    v2.5.0
  * @date
  * @brief      Synchronization module for ADC and LA sourses
  ******************************************************************************
**/

/* Internal includes */ 
`include "ADC_TRIG.v"
`include "LA_TRIG.v"

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
	input LA_SYNC_AND_OR_MODE,

	input SYNC_GLOBAL_ON,
	input Start_Write,	
	input ENABLE_TRIGG,
	input CLK_EN,
	input CLK,
   
	output reg TRIG_EV_OUT	
);


/* wires and assigns */
wire ADC_trigger_event;
wire LA_trigger_event;
wire [1:0] la_sync_mode;
assign la_sync_mode[0] = LA_SYNC_AND_OR_MODE;
assign la_sync_mode[1] = ADC_SYNC_OUT_WIN;

/* sync sourse registers */
reg sync_gl_on_adc;
reg sync_gl_on_la;



/* */
always @(posedge CLK) begin
		
	if(SYNC_GLOBAL_ON == 0) begin		
		TRIG_EV_OUT <= 1'b1;
	end
	else begin	
		
		TRIG_EV_OUT <= (ADC_trigger_event & LA_trigger_event);

		if(ADC_LA_SYNC_SOURSE == 0) begin			
			sync_gl_on_adc <= 1'b1;
			sync_gl_on_la <= 1'b0;			
		end
		else begin			
			sync_gl_on_adc <= 1'b0;
			sync_gl_on_la <= 1'b1;			
		end
		
	end	
	
end



/* Include module ADC sync */
ADC_TRIG  ADC_TRIG_1
(
	.Trg_Lv_UP(Trg_Lv_UP),
	.Trg_Lv_DOWN(Trg_Lv_DOWN),
	.TRIG_DATA_IN(SYNC_DATA_IN),         
	.Delay(Delay[3:0]),             
	.Sync_OUT_WIN(ADC_SYNC_OUT_WIN),
		
	.TRG_EV_EN(ENABLE_TRIGG),
	.RST(sync_gl_on_adc),
	.CLK_EN(CLK_EN),
	.CLK(CLK),
	       
	.trig_out(ADC_trigger_event)
);

/* Include module LA sync */
LA_TRIG LA_TRIG_1
(
	.DATA_IN(SYNC_DATA_IN),
	
	.LA_DIFF_DATA(Trg_Lv_DOWN),
	.LA_DIFF_MASK(LA_MASK_DIFF),
	
	.LA_CND_DATA(Trg_Lv_UP),
	.LA_CND_MASK(LA_MASK_CND),
		
	.SYNC_MODE(la_sync_mode),
	
	.TRG_EV_EN(ENABLE_TRIGG),			
	.RST(sync_gl_on_la),  	
	.CLK_EN(CLK_EN),
	.CLK(CLK),
    
	.TRIG_OUT(LA_trigger_event)
);       
	


endmodule