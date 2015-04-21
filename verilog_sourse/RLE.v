

module RLE
(
	input [7:0]			LA_IN_DATA,
	input       		CLK_EN,
	input				RLE_EN,
	input          		CLK,

	output reg [7:0]	LA_OUT_DATA,
	output reg [7:0]	LA_RLE_OUT_DATA,
	output reg			LA_SRAM_ADDR_CNT_EN	
);

/* registers */
reg addr_cnt_en_0;
reg[7:0] la_in_data_0;
reg[7:0] rle_cnt;


/* */
always @(posedge CLK) begin

		if(CLK_EN == 1'b0)	begin
		
			LA_SRAM_ADDR_CNT_EN <= 1'b0;
			
		end
		else begin
		
			la_in_data_0 <= LA_IN_DATA;
			
			if( (la_in_data_0 != LA_IN_DATA) || (RLE_EN == 0) || (rle_cnt == 255) ) begin
		
				addr_cnt_en_0 <= 1'b1;
				rle_cnt <= 8'b0;
			
			end
			else begin
		
				addr_cnt_en_0 <= 1'b0;
				rle_cnt <= rle_cnt + 1'b1;
			
			end
							
			LA_OUT_DATA <= la_in_data_0;
			LA_RLE_OUT_DATA <= rle_cnt;			
			LA_SRAM_ADDR_CNT_EN <= addr_cnt_en_0;
					
		end	
	
end // always psg CLK


endmodule