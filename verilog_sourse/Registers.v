/**
  ******************************************************************************
  * @file       Registers.v
  * @author     Neil Lab :: Left Radio
  * @version    v2.5.0
  * @date
  * @brief      Registers module
  ******************************************************************************
**/

/* Internal defines */
`define Decim_Low        (5'b00000)
`define Decim_Height0    (5'b00001)
`define Decim_Height1    (5'b00010)
`define Trigger_UP       (5'b00011)
`define Trigger_Down     (5'b00100)
`define WIN_DATA_Low     (5'b00101)
`define WIN_DATA_Height0 (5'b00110)
`define WIN_DATA_Height1 (5'b00111)
`define cnfPin_A         (5'b01000)
`define IN_KEY_A         (5'b01001)
`define Del              (5'b01010)
`define extPin_reg_0_A   (5'b01011)
`define extPin_reg_1_A   (5'b01100)
`define Write_Control_A  (5'b01101)
`define SRAM_DATA        (5'b01111)
`define cnfPin_B     	 (5'b10000)
`define LA_MASK_COND  	 (5'b10001)
`define LA_MASK_DIFF   	 (5'b10010)

module Registers
(
	input               CLK,
	input               Addr_or_Data,
	input               Write,
	input [7:0]         SRAM_TO_MCU_DATA,
	input [7:0]         DATA_IN,
	input [4:0]         IN_KEY,
	
	output reg [7:0]    REG_DATA_OUT,
	
	output reg [23:0]   Decimation,
	output reg [7:0]    Trigger_level_UP,
	output reg [7:0]    Trigger_level_Down,
	output reg [7:0]    LA_TriggerMask_Cond,
	output reg [7:0]    LA_TriggerMask_Diff,
	
	output reg [17:0]   WIN_DATA,
	output reg [7:0]    Delay,
	output reg          Start_Write_s,
	output reg          Enable_Trigger,
	
	output INTRL_0,
	output INTRL_1,
	output Sync_channel_sel,
	output Sync_ON,
	output Sync_OUT_WIN,
	output ReadCounterEN,
	output Read_SRAM_UP,
	output ReadCounter_sLoad,
	output OSC_LA,
	output AND_OR_LA_TRIGG,
	output LA_OR_OSC_TRIGG,
	
	output S1,
	output S2,
	output O_C_A,
	output O_C_B,
	output OSC_EN,
	output A0, A1, A2,
	output B0, B1, B2,
	output BackLight_OUT
);

/* wires and assigns */ 
assign Sync_channel_sel		= cnfPin[0];
assign Sync_ON 				= cnfPin[1];
assign Sync_OUT_WIN			= cnfPin[2];
assign ReadCounterEN		= cnfPin[3];
assign Read_SRAM_UP			= cnfPin[4];
assign OSC_LA				= cnfPin[5];
assign AND_OR_LA_TRIGG		= cnfPin[6];
assign LA_OR_OSC_TRIGG		= cnfPin[7];

assign ReadCounter_sLoad	= cnfPinB[0];
assign INTRL_0				= cnfPinB[1];
assign INTRL_1				= cnfPinB[2];

assign S1					= extPin_reg_0[0];
assign S2					= extPin_reg_0[1];
assign O_C_A				= extPin_reg_0[2];
assign O_C_B				= extPin_reg_0[3];

assign A0					= extPin_reg_1[0];
assign A1					= extPin_reg_1[1];
assign A2					= extPin_reg_1[2];
assign B0					= extPin_reg_1[3];
assign B1					= extPin_reg_1[4];
assign B2					= extPin_reg_1[5];
assign OSC_EN				= extPin_reg_1[6];
assign BackLight_OUT		= extPin_reg_1[7];


/* registers */
reg [4:0]    Sel_Addr_reg;
reg [7:0]    cnfPin;
reg [2:0]    cnfPinB;
reg [1:0]    Write_Control;

reg [3:0]    extPin_reg_0;
reg [7:0]    extPin_reg_1;

reg STR, ENTr, INT_0, INT_1;



/* Resync critical signals with GCLK */
always @(posedge CLK) begin

    STR <= Write_Control[0];
    ENTr <= Write_Control[1];
		
	Start_Write_s <= STR;
    Enable_Trigger <= ENTr;
   
end  //always


/* MCU write */
always @(posedge Write) begin
	
  if(Addr_or_Data == 1'b1) begin

  		/* Write register address */
        Sel_Addr_reg <= DATA_IN[4:0];

  end
  else begin
       
       /* Write data to selected register */
	   case (Sel_Addr_reg)
	   `Decim_Low        : Decimation[7:0]     <=  DATA_IN;
	   `Decim_Height0    : Decimation[15:8]    <=  DATA_IN;
	   `Decim_Height1    : Decimation[23:16]   <=  DATA_IN;
	   `Trigger_UP       : Trigger_level_UP    <=  DATA_IN;
       `Trigger_Down     : Trigger_level_Down  <=  DATA_IN;
	   `WIN_DATA_Low     : WIN_DATA[7:0]       <=  DATA_IN;
	   `WIN_DATA_Height0 : WIN_DATA[15:8]      <=  DATA_IN;
	   `WIN_DATA_Height1 : WIN_DATA[17:16]     <=  DATA_IN[1:0];
	   `cnfPin_A         : cnfPin              <=  DATA_IN;
	   `Del              : Delay               <=  DATA_IN;
	   `extPin_reg_0_A   : extPin_reg_0        <=  DATA_IN[3:0];
	   `extPin_reg_1_A   : extPin_reg_1        <=  DATA_IN;
	   `Write_Control_A  : Write_Control       <=  DATA_IN[1:0];
	   `cnfPin_B  		 : cnfPinB		       <=  DATA_IN[2:0];
	   `LA_MASK_COND	 : LA_TriggerMask_Cond <=  DATA_IN;
	   `LA_MASK_DIFF	 : LA_TriggerMask_Diff <=  DATA_IN;
	   default;		 
	   endcase

  end	
end  //always


/* Data out for MCU read */
always @* begin	//
	
  	case (Sel_Addr_reg)
		`Decim_Low        :  REG_DATA_OUT = Decimation[7:0];
		`Decim_Height0    :	 REG_DATA_OUT = Decimation[15:8];
		`Decim_Height1    :	 REG_DATA_OUT = Decimation[23:16];
		`Trigger_UP       :	 REG_DATA_OUT = Trigger_level_UP;
		`Trigger_Down     :	 REG_DATA_OUT = Trigger_level_Down;
		`WIN_DATA_Low     :	 REG_DATA_OUT = WIN_DATA[7:0];
		`WIN_DATA_Height0 :	 REG_DATA_OUT = WIN_DATA[15:8];
		`WIN_DATA_Height1 :	 REG_DATA_OUT = WIN_DATA[17:16];
		`cnfPin_A         :	 REG_DATA_OUT = cnfPin;
		`IN_KEY_A         :	 REG_DATA_OUT = IN_KEY;		
		`Del              :	 REG_DATA_OUT = Delay;
		`extPin_reg_0_A   :	 REG_DATA_OUT = extPin_reg_0;
		`extPin_reg_1_A   :	 REG_DATA_OUT = extPin_reg_1;
		`Write_Control_A  :	 REG_DATA_OUT = Write_Control;
		`SRAM_DATA        :	 REG_DATA_OUT = SRAM_TO_MCU_DATA;
		`cnfPin_B         :	 REG_DATA_OUT = cnfPinB;
		`LA_MASK_COND	  :  REG_DATA_OUT = LA_TriggerMask_Cond;
	    `LA_MASK_DIFF	  :  REG_DATA_OUT = LA_TriggerMask_Diff;
		default           :  REG_DATA_OUT = 0;
	endcase

end	//always

endmodule