/**
  ******************************************************************************
  * @file       ADC_TRIG.v
  * @author     Neil Lab :: Left Radio
  * @version    v1.5.0
  * @date
  * @brief      Trigger for ADC sourse
  ******************************************************************************
**/

module ADC_TRIG
(
	input [7:0]  Trg_Lv_UP,
	input [7:0]  Trg_Lv_DOWN,
	input [7:0]  TRIG_DATA_IN,
	input [3:0]  Delay,
	input Sync_OUT_WIN,
		
	input TRG_EV_EN,
	input RST,
	input CLK_EN,
	input CLK,
    
	output trig_out             
);

/* wires and assigns */
assign trig_out = last_event_reg;

/* registers */
reg         first_event_reg;     
reg         last_event_reg;      
reg 		sync_state, sync_state_0, sync_state_1;
reg [3:0]   SlCounter;           
reg [7:0]	DATA_SYNC;



/* */
always @(posedge CLK) begin
    
    /* temp input starage data register */ 
    DATA_SYNC <= TRIG_DATA_IN;
    
    /* Verify trigger levels conditions */
    if(Trg_Lv_UP > DATA_SYNC) sync_state_0 <= 1'b1;
    else sync_state_0 <= 1'b0;

    if(Trg_Lv_DOWN < DATA_SYNC) sync_state_1 <= 1'b1;
    else sync_state_1 <= 1'b0;

    /* If both conditions is true out invert signal */
    if(sync_state_0 & sync_state_1) sync_state <= ~Sync_OUT_WIN;
    else sync_state <= Sync_OUT_WIN;

end



/* */
always @(posedge CLK) begin     
    
    /* ADC sync is OFF, continuously out 1 */
    if(RST == 1'b0) begin          
        last_event_reg <= 1'b1;   
    end 
    else begin  
		
        /* ADC sync ON, trigger events DISABLE(reg 0x0D bit 1) */
        if(TRG_EV_EN == 1'b0) begin
		                  
			 first_event_reg <= 1'b0;
			 last_event_reg <= 1'b0;
			 SlCounter <= Delay;
			 
		end        
		else begin

            /* Triger ENABLE, processing samples if allowed  */    
            if(CLK_EN == 1'b1) begin    
			 	
                /* Fist event */
				if(first_event_reg == 1'b0) begin    
			         
                    /* First event conditions are met, example for "FRONT" is 1 when TRG_LVL_DWN < ADC data(DATA_SYNC) */
					if(sync_state == 1'b1) begin
					    
                        /* LPF counter */
						if(SlCounter == 1'b0) begin
							first_event_reg <= 1'b1;     /* First event done */
						end
						else begin                     
							SlCounter <= SlCounter - 1'b1;
						end 

					end
					else begin   
					 
						SlCounter <= Delay;
	
					end 
				end        
				else begin
				
					/* Work with last event, example for "FRONT" is 1 when TRG_LVL_DWN > ADC data(DATA_SYNC) */ 
					if(sync_state == 1'b0) begin
                        last_event_reg <= 1'b1;     /* Last event, trigger done */
                    end
				
				end
	
			 end        
			 
		 end
    end

end //

endmodule