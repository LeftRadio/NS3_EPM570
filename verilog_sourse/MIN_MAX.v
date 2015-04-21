

module MIN_MAX
(

	input [7:0]			DATA_IN,
	input       		LOAD,
	input          		CLK,

	output reg [7:0] 	DATA_OUT

);

/* registers */
reg [7:0] data_in;
reg [7:0] max_data_in;
reg [7:0] min_data_in;


/* */
always @(posedge CLK) begin
	
	data_in <= DATA_IN;
	
	if(LOAD == 1'b1) begin	
						
		min_data_in <= data_in;
		max_data_in <= data_in;	
		
		/* load MIN data to tmp out buff register */
		DATA_OUT <= min_data_in;			
				   
	end
	else begin
					
		/* MIN data */
		if(data_in <= min_data_in) min_data_in <= data_in;
				
		/* MAX data */
		if(data_in >= max_data_in) max_data_in <= data_in;
				
		/* load MAX to tmp out buff register */
		DATA_OUT <= max_data_in;		
		
	end			
	
	
end  //always



endmodule
