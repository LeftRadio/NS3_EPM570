
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
		
	input EN,
	input RST,
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
always @ (posedge CLK)
begin : STATE

	
	DATA_SYNC <= DATA_IN;
	
	
	if (RST == 1'b0) begin
				
		gnt_0 <= 0;
		gnt_1 <= 0;
		TRIG_OUT <= 1'b1;
		
	end
	else begin
				
		if(EN == 1'b1) begin
			
			if ((LA_CND_DATA ^ DATA_SYNC_CND_MSK) == 0) begin
					
				gnt_0 <= 1'b1;
							
			end
			else gnt_0 <= 1'b0;
		
			if ((DATA_SYNC_DIFF_MSK & DATA_SYNC_DIFF_DTA & LA_DIFF_MASK) != 0) begin
					
				gnt_1 <= 1'b1;
							
			end
			else gnt_1 <= 1'b0;
			
			
			case(SYNC_MODE)

			`CND_OR_DIFF:	if(gnt_0 | gnt_1 == 1'b1) TRIG_OUT <= 1'b1;
		
			`CND_AND_DIFF:	if(gnt_0 & gnt_1 == 1'b1) TRIG_OUT <= 1'b1;
		
			`COND:			if(gnt_0 == 1'b1) TRIG_OUT <= 1'b1;
		
			`DIFF:			if(gnt_1 == 1'b1) TRIG_OUT <= 1'b1;
                
			default : 		TRIG_OUT <= 1'b0;
		
			endcase	
			
				
		end
		else begin
			
			TRIG_OUT <= 1'b0;	
			
		end
	end
end



//always @ (posedge CLK)
//begin : OUT
//	
//	
//	
//end


endmodule // End of Module arbiter