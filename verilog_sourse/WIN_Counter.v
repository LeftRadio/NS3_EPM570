/**
  ******************************************************************************
  * @file       WIN_Counter.v
  * @author     Neil Lab :: Left Radio
  * @version    v2.5.0
  * @date
  * @brief      WIN_Counter module
  ******************************************************************************
**/

module WIN_Counter
(
	input [17:0]		WIN_DATA,
	input				TRIG_EVENT_IN,
	input				LA_RLE_CNT_EN,
	input				CNT_EN_0,
	input				CNT_EN_1,
	input				RST,
	input				CLK,

	output 				SRAM_WR_EN,
	output reg			Write_Ready,
	output reg [17:0]	SRAM_ADDR
);

/* wires and assigns */
assign SRAM_WR_EN = (~addr_cnt_en) | Write_Ready;

/* registers */
reg [17:0] win_cnt;
reg cnt_en_0, cnt_en_1;
reg addr_cnt_en;
reg wnt_cnt_en, wnt_cnt_en_0;
reg wr_rdy_0, wr_rdy_1;



/* */
always @(posedge CLK) begin
	
	cnt_en_0 <= CNT_EN_0;
	cnt_en_1 <= CNT_EN_1;
	
end


/* */
always @(posedge CLK) begin
				
	if(RST == 0) begin
	
		wr_rdy_0 <= 0;
		wr_rdy_1 <= 0;
		Write_Ready <= 1'b0;
		addr_cnt_en <= 1'b0;
		win_cnt <= 18'b0;
		
	end
	else begin 
				
		addr_cnt_en <= (cnt_en_0 | cnt_en_1) & LA_RLE_CNT_EN;		
		wnt_cnt_en <= CNT_EN_1 & TRIG_EVENT_IN;
				
		/* begining write proccess */
		if(Write_Ready == 1'b0) begin
		
			/* count sram addr */
			if(addr_cnt_en == 1'b1) begin          
				
				SRAM_ADDR <= SRAM_ADDR + 1'b1;
				
				/* window counter */
				if(wnt_cnt_en == 1'b1) begin
						
					wr_rdy_1 <= wr_rdy_0;
					Write_Ready <= wr_rdy_1;
						   
					if(win_cnt == WIN_DATA) begin
					
						wr_rdy_0 <= 1'b1;
						
					end           
					else begin
				
						win_cnt <= win_cnt + 1'b1;
						
					end
					
				end	/* window counter */
							
			end	/* count sram addr */
		
		end	/* begining write proccess */
			
	end	/* else if RST == 1'b1 */
	
end


endmodule