/**
  ******************************************************************************
  * @file       ADC_TRIG.v
  * @author     Neil Lab :: Left Radio
  * @version    v1.5.0
  * @date
  * @brief      Trigger for ADC sourse
  ******************************************************************************
**/

/* Internal defines */ 
`define CND_OR_DIFF			(2'b00)
`define CND_AND_DIFF		(2'b01)
`define COND        		(2'b10)
`define DIFF		        (2'b11)

module LA_TRIG
(	
	input [7:0]	 DATA_IN,	
	input [7:0]  LA_DIFF_DATA,
	input [7:0]  LA_DIFF_MASK,	
	input [7:0]  LA_CND_DATA,
	input [7:0]  LA_CND_MASK,	
	input [1:0]  SYNC_MODE,
		
	input TRG_EV_EN,
	input RST,
	input CLK_EN,
	input CLK,
        
	output reg TRIG_OUT
);

/* wires and assigns */ 
wire [7:0] DATA_SYNC_CND_MSK = DATA_SYNC & LA_CND_MASK;
wire [7:0] DATA_SYNC_DIFF_MSK = DATA_IN ^ DATA_SYNC;
wire [7:0] DATA_SYNC_DIFF_DTA = DATA_SYNC ^ LA_DIFF_DATA;

/* registers */ 
reg [7:0] DATA_SYNC;
reg gnt_0, gnt_1;



/* */
always @ (posedge CLK) begin
	
	/* temp input starage data register */ 
	DATA_SYNC <= DATA_IN;

end


/* */
always @ (posedge CLK) begin
		
	/* LA sync is OFF, continuously out 1 */
	if (RST == 1'b0) begin
				
		gnt_0 <= 0;
		gnt_1 <= 0;
		TRIG_OUT <= 1'b1;
		
	end
	else begin
		
		/* LA sync ON, trigger events DISABLE(reg 0x0D bit 1) */	
		if(TRG_EV_EN == 1'b0) begin
			TRIG_OUT <= 1'b0;
		end
		else begin	

			/* Triger ENABLE, processing samples if allowed  */
			if(CLK_EN == 1'b1) begin
			
				if ((LA_CND_DATA ^ DATA_SYNC_CND_MSK) == 0) begin						
					gnt_0 <= 1'b1;								
				end
				else gnt_0 <= 1'b0;
			
				if ((DATA_SYNC_DIFF_MSK & DATA_SYNC_DIFF_DTA & LA_DIFF_MASK) != 0) begin						
					gnt_1 <= 1'b1;								
				end
				else gnt_1 <= 1'b0;
				
				/* Sync mode switch */
				case(SYNC_MODE)
	
				`CND_OR_DIFF:	if(gnt_0 | gnt_1 == 1'b1) TRIG_OUT <= 1'b1;
			
				`CND_AND_DIFF:	if(gnt_0 & gnt_1 == 1'b1) TRIG_OUT <= 1'b1;
			
				`COND:			if(gnt_0 == 1'b1) TRIG_OUT <= 1'b1;
			
				`DIFF:			if(gnt_1 == 1'b1) TRIG_OUT <= 1'b1;
					
				default : 		TRIG_OUT <= 1'b0;
			
				endcase
				
			end			
		end
		
	end
	
end


endmodule // End of Module arbiter