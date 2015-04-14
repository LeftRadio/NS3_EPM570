module MIN_MAX
(

input [7:0]			ADC_DATA_IN_A,
input [7:0]			ADC_DATA_IN_B,
input [7:0]			LA_DATA_IN_A,
input [7:0]			LA_DATA_IN_B,

input				A_B_SOURSE,
input          		LA_SOURSE,
input       		MIN_MAX_LOAD,
input          		CLK,

output reg [7:0] 	SYNC_OUT_DATA,
output reg [7:0] 	SRAM_OUT_DATA_A,
output reg [7:0] 	SRAM_OUT_DATA_B

);

/* Input multiplexor */
wire [7:0] M_IN_DATA_A = (LA_SOURSE == 0)? ADC_DATA_IN_A : LA_DATA_IN_A;
wire [7:0] M_IN_DATA_B = (LA_SOURSE == 0)? ADC_DATA_IN_B : LA_DATA_IN_B;
wire [7:0] ADC_SYNC_DATA = (A_B_SOURSE == 0)? IN_DATA_A : IN_DATA_B;
wire [7:0] SYNC_DATA = (LA_SOURSE == 0)? ADC_SYNC_DATA : LA_DATA_IN_A;

/* Signal for load MIN/MAX register */
wire min_max_load = LA_SOURSE | MIN_MAX_LOAD;

/* CH A registers */
reg [7:0] IN_DATA_A;
reg [7:0] MAX_DATA_IN_A;
reg [7:0] MIN_DATA_IN_A;
reg [7:0] SRAM_TMP_OUT_A;
	
reg [7:0] IN_DATA_B;
reg [7:0] MAX_DATA_IN_B;
reg [7:0] MIN_DATA_IN_B;
reg [7:0] SRAM_TMP_OUT_B;



/* */
always @(posedge CLK) begin

	/* Load input data to temp storage registers */
	IN_DATA_A <= M_IN_DATA_A;
	IN_DATA_B <= M_IN_DATA_B;
	
	if(min_max_load == 1) begin	
						
		MIN_DATA_IN_A <= IN_DATA_A;
		MAX_DATA_IN_A <= IN_DATA_A;	
		MIN_DATA_IN_B <= IN_DATA_B;
		MAX_DATA_IN_B <= IN_DATA_B;	
		
		if(LA_SOURSE == 0) begin
			
			/* load MIN to tmp out buff register */
			SRAM_TMP_OUT_A <= MIN_DATA_IN_A;
			SRAM_TMP_OUT_B <= MIN_DATA_IN_B;
			
		end
		else begin
			
			SRAM_TMP_OUT_A <= IN_DATA_A;
			SRAM_TMP_OUT_B <= IN_DATA_B;
			
		end
				   
	end
	else begin
					
		/* MIN data */
		if(IN_DATA_A <= MIN_DATA_IN_A) MIN_DATA_IN_A <= IN_DATA_A;
		if(IN_DATA_B <= MIN_DATA_IN_B) MIN_DATA_IN_B <= IN_DATA_B;
		
		/* MAX data */
		if(IN_DATA_A >= MAX_DATA_IN_A) MAX_DATA_IN_A <= IN_DATA_A;
		if(IN_DATA_B >= MAX_DATA_IN_B) MAX_DATA_IN_B <= IN_DATA_B;
		
		/* load MAX to tmp out buff register */
		SRAM_TMP_OUT_A <= MAX_DATA_IN_A;
		SRAM_TMP_OUT_B <= MAX_DATA_IN_B;
		
	end	
	
		
	/* Load data to out registers */
	SRAM_OUT_DATA_A <= SRAM_TMP_OUT_A;
	SRAM_OUT_DATA_B <= SRAM_TMP_OUT_B;	
	
	SYNC_OUT_DATA <= SYNC_DATA;
	
end  //always

endmodule
