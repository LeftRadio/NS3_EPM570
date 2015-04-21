
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



/* Module ADC sync */
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
          

/* Module LA sync */
LA_TRIG LA_TRIG_1
(
	.DATA_IN(SYNC_DATA_IN),
	
	.LA_DIFF_DATA(Trg_Lv_DOWN),
	.LA_DIFF_MASK(LA_MASK_DIFF),
	
	.LA_CND_DATA(Trg_Lv_UP),
	.LA_CND_MASK(LA_MASK_CND),
		
	.SYNC_MODE(la_sync_mode),
	
	.EN(ENABLE_TRIGG),			
	.RST(sync_gl_on_la),  	
	.CLK(CLK),
    
	.TRIG_OUT(LA_trigger_event)
);       
	


endmodule 

