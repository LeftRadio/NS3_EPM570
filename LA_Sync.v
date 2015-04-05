



/* Module LA sync, inputs/outputs */
module LA_Sync
(
	input               CLK,
	input [7:0]         LA_DATA_IN,
	input [7:0]         DIFF_IN_DATA,
	input [7:0]         DIFF_MASK_DATA,
	input [7:0]         COND_IN_DATA,
	input [7:0]         COND_MASK_DATA,

	output reg [7:0]    LA_DATA_OUT,
	output LA_Sync_RDY
);

/* Internal registers, assigns and other */
reg [7:0]    int_la_data;	// register for isolation rise/front events

wire [7:0]   diff_la_data_0 = int_la_data ^ LA_DATA_IN; 
wire [7:0]   diff_la_data_1 = int_la_data ^ DIFF_IN_DATA; 
wire [7:0]   diff_la_data_and = diff_la_data_0 & diff_la_data_1;



/* Do when the CLK 0->1 */
always @(posedge CLK) begin
	
	/* differents */
	if(diff_la_data_0 != 0) begin
	
		if((DIFF_MASK_DATA & diff_la_data_and) != 0) begin
		
			LA_Sync_RDY = 1;		
		end
		else begin
			LA_Sync_RDY = 0;
		end
		
	end	// if
	
	/* internal LA data register load */
	int_la_data <= LA_DATA_IN;

end  //always

endmodule