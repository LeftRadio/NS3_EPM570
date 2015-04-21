
module trigger
(
	input [7:0]  Trg_Lv_UP,
	input [7:0]  Trg_Lv_DOWN,
	input [7:0]  TRIG_DATA_IN,
	input [7:0]  Delay,          // Delay, LPF
	input Sync_OUT_WIN,          
	input Start_Write,           
	input CLK_EN,                
	input Enable_Trig,           
	input sync_ON,
	input CLK,
    
	output reg trig_out             
);


/* wires and assigns */
wire sync_state_0 = (Trg_Lv_UP > DATA_SYNC) & (Trg_Lv_DOWN < DATA_SYNC)? ~Sync_OUT_WIN : Sync_OUT_WIN;


/* registers */
reg         first_event_reg;     
reg         last_event_reg;      
reg 		sync_state;
reg [7:0]   SlCounter;           
reg [7:0]	DATA_SYNC;



/* */
always @(posedge CLK) begin
     
     DATA_SYNC <= TRIG_DATA_IN;
     
     sync_state <= sync_state_0;
     trig_out <= last_event_reg;
   
	/* triger disable */
	if(Enable_Trig == 1'b0) begin 
     
         first_event_reg <= 1'b0;
         last_event_reg <= 1'b0;
         SlCounter <= Delay;
         
	end
	else if(CLK_EN == 1'b1) begin 
                  
         if(sync_ON == 1'b0) begin 
			
			last_event_reg <= 1'b1;
   
         end         
         else if(first_event_reg == 1'b0) begin    // выбор события. Если первое еще не сработало работаем с ним. Иначе - со вторым.
         
             if(sync_state == 1'b1) begin
                 
                 if(SlCounter == 1'b0) begin
                     first_event_reg <= 1'b1;                     
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
			
			/* work with last event */ 
			if(sync_state == 1'b0) last_event_reg <= 1'b1;
			
         end
     end 

end //

endmodule 