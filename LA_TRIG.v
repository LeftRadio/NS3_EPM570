//====================================================
// This is FSM demo program using single always
// for both seq and combo logic
// Design Name : fsm_using_single_always
// File Name   : fsm_using_single_always.v
//=====================================================
module LA_TRIG (
	
	input [7:0]	 DATA_IN,
	input [7:0]  Trg_Lv_UP,
	input [7:0]  Trg_Lv_DOWN,
	input [7:0]  LA_MASK_CND,
	input [7:0]  LA_MASK_DIFF,		//
	input [1:0]  SYNC_MODE,			// 
		
	input EN,
	input RST,						// 
	input CLK,
    
	output reg trig_out             //
);

reg [7:0] DATA_SYNC;
reg COND_event_reg;		//
reg DIFF_event_reg;		//
reg sync_state;

reg    req_0, req_1, gnt_0, gnt_1;

//=============Internal Constants======================
parameter SIZE = 3           ;
parameter IDLE  = 3'b001,GNT0 = 3'b010,GNT1 = 3'b100 ;

//=============Internal Variables======================
reg   [SIZE-1:0]          state        ;// Seq part of the FSM
reg   [SIZE-1:0]          next_state   ;// combo part of FSM


//==========Code startes Here==========================
always @ (posedge clock)
begin : FSM
	
	if (RST == 1'b0) begin
		
		state <= #1 IDLE;
		gnt_0 <= 0;
		gnt_1 <= 0;
		
	end
	else begin
		
		DATA_SYNC <= DATA_IN;
		
		case(state)
		
		IDLE :	if ((DATA_SYNC & LA_MASK_CND != 0)) begin
					
					gnt_0 <= 1;
					state <= #1 GNT0;					
					
				end
				else if ((DATA_SYNC & LA_MASK_DIFF) != 0) begin
					
					gnt_1 <= 1;
					state <= #1 GNT1;
					
				end
				else begin
					state <= #1 IDLE;
				end
				
		GNT0 :	if (req_0 == 1'b1) begin
					
					state <= #1 GNT0;
					
				end
				else begin
					
					gnt_0 <= 0;
					state <= #1 IDLE;
					
				end
				
		GNT1 :	if (req_1 == 1'b1) begin
					state <= #1 GNT1;
				end
				else begin
					gnt_1 <= 0;
					state <= #1 IDLE;
				end
				
		default : state <= #1 IDLE;
		endcase
	end
end


always @ (posedge clock)
begin : OUT
	
	/* FSM GNT1 state */
	if(gnt_1 == 0) begin
	
		
	
	end
	
	
end

endmodule // End of Module arbiter










//
//module LA_TRIG
//(
//	input [7:0]	 DATA_IN,
//	input [7:0]  Trg_Lv_UP,
//	input [7:0]  Trg_Lv_DOWN,
//	input [7:0]  LA_MASK_CND,
//	input [7:0]  LA_MASK_DIFF,		//
//	input [1:0]  SYNC_MODE,			// 
//	
//	input EN,				// 
//	input CLK,
//    
//	output reg trig_out             //
//);
//
//reg [7:0] DATA_SYNC;
//reg COND_event_reg;		//
//reg DIFF_event_reg;		//
//reg sync_state;
//
//
//always @(posedge CLK) begin
//     
//	DATA_SYNC <= DATA_IN;
//     
//	if(EN == 0) begin // o?eaaa? cai?auai
//     
//		COND_event_reg <= 0;
//		DIFF_event_reg <= 0; 
//		trig_out <= 1;
//         
//	end
//	else begin 
//         
//		if((LA_MASK_CND & DATA_IN) != 0) begin
//			
//			
//		
//		end
//         
//         
//         
//     end //   
//
//end //
//
//endmodule 