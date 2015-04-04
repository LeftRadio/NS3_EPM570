module WIN_Counter
(
input [17:0]       WIN_DATA,
input              CLK_EN,
input              Start_Write,
input              trigger_event_in,
input              CLK,

output reg         Write_Ready
);

reg [17:0]  WINcnt;


always @(posedge CLK) begin
     
   if(Start_Write == 0) begin  // сброс     
          WINcnt <= WIN_DATA;
          Write_Ready <= 0;       
   end
   else if(CLK_EN == 1) begin
          
       /* если пришло срабатывание триггера то запускаем счетчик, считать предысторию */
       if(trigger_event_in == 1) begin 
             
           if(WINcnt == 0) begin  // если досчитали
               Write_Ready <= 1;  // выдаем сигнал о окончании записи
           end           
           else WINcnt <= WINcnt - 1'b1;  // иначе считаем             
       end
   end

end

endmodule