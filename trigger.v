
module trigger
(
input [7:0]  Trg_Lv_UP,
input [7:0]  Trg_Lv_DOWN,
input [7:0]  TRIG_DATA_IN,
input [7:0]  Delay,          // Delay, LPF
input Sync_OUT_WIN,          // Sync win mode, sets Trg_Lv_UP and Trg_Lv_DOWN
input Start_Write,           // 
input CLK_EN,                // 
input Enable_Trig,           // 
input sync_ON,
//input LA_TRIGG_IN,
//input Analog_or_LA,
input CLK,
    
output reg trig_out             // выход триггера
);

reg         first_event_reg;     // oneiaea aey ?ac?aoaiey n?aaaouaaiey o?eaaa?a
reg         last_event_reg;      // nianoaaiii nai o?eaaa?
reg 		sync_state;
reg [7:0]   SlCounter;           // caaa??ea
//reg [7:0]	DATA_SYNC_0;
reg [7:0]	DATA_SYNC;

// данные для синхронизации, в зависимости от sync_sourse, 0/1 - канал А или В соответсвенно
wire sync_state_0 = (Trg_Lv_UP > DATA_SYNC) & (Trg_Lv_DOWN < DATA_SYNC)? ~Sync_OUT_WIN : Sync_OUT_WIN;  // условие триггера

//assign     sync_state_out = sync_state;
//assign     trig_out = last_event_reg;


always @(posedge CLK) begin
     
     DATA_SYNC <= TRIG_DATA_IN;
     
     sync_state <= sync_state_0;
     trig_out <= last_event_reg;
     
//     if(sync_sourse == 0) DATA_SYNC_0 <= DATA_IN_A;
//     else DATA_SYNC_0 <= DATA_IN_B;
     
     
     if(Enable_Trig == 0) begin // триггер запрещен
     
         first_event_reg <= 0;
         last_event_reg <= 0;
         SlCounter <= Delay;
         
     end
     else if(CLK_EN == 1) begin // клок и триггер разрешен
         
         if(sync_ON == 0) last_event_reg <= 1'b1;
//         else if(Analog_or_LA == 1) begin
//             if(LA_TRIGG_IN == 1) last_event_reg <= 1'b1;         
//         end         
         else if(first_event_reg == 0) begin    // выбор события. Если первое еще не сработало работаем с ним. Иначе - со вторым.
         
             // работаем с первым событием
             if(sync_state == 1) begin
                 // условие активно
                 if(SlCounter == 0) begin
                     // задержка закончена
                     first_event_reg <= 1'b1;                     
                 end
                 else begin
                     // задержка не закончена
                     SlCounter <= SlCounter - 1'b1;
                 end
             end
             else begin
                 // условие неактивно
                 SlCounter <= Delay;
             end
         end
         else begin
         // работаем со вторым событием
             if(sync_state == 0) begin
                 last_event_reg <= 1;
             end
         end
     end //   

end //

endmodule 