
`include "trigger.v"
`include "WIN_Counter.v"   
   
   
module Synchronization
(

input [7:0] Trg_Lv_UP,
input [7:0] Trg_Lv_DOWN,
input [7:0] DATA_IN_A,
input [7:0] DATA_IN_B,
input [17:0] WIN_DATA,
input [7:0]  Delay,
input Sync_channel_sel,
input Sync_OUT_WIN, sync_ON,
input Start_Write, CLK_EN,
input Enable_Trig,
input LA_TRIGG_IN,
input LA_OR_OSC_TRIGG,
input CLK,
   
output Write_Ready,
output sync_state_out
//output [17:0] WIN_DATA_OUT
);

wire trigger_event;
wire Wr_Ready;

assign Write_Ready = Start_Write & Wr_Ready;

trigger  trigger_1
         (
         .CLK(CLK),
         .CLK_EN(CLK_EN),
         .Trg_Lv_UP(Trg_Lv_UP),
         .Trg_Lv_DOWN(Trg_Lv_DOWN),
         .DATA_IN_A(DATA_IN_A),
         .DATA_IN_B(DATA_IN_B),
         .Delay(Delay),
         .sync_sourse(Sync_channel_sel),         
         .Start_Write(Start_Write),
         .Enable_Trig(Enable_Trig),
         .Sync_OUT_WIN(Sync_OUT_WIN),
         .sync_ON(sync_ON),         
         .LA_TRIGG_IN(LA_TRIGG_IN),
         .Analog_or_LA(LA_OR_OSC_TRIGG),
         .trig_out(trigger_event),
         .sync_state_out(sync_state_out)
         );
          

WIN_Counter  WIN_Counter_1
         (         
         .CLK(CLK),
         .CLK_EN(CLK_EN),
         .WIN_DATA(WIN_DATA),
         //.WINcnt(WIN_DATA_OUT),
         .Start_Write(Start_Write),         
         .trigger_event_in(trigger_event),
         .Write_Ready(Wr_Ready)                  
         );

endmodule 

