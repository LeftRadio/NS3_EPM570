
module PWM_BackLight
(
  input [4:0]    Duty_Val,
  input          CLK,

  output reg     BackLight_OUT
);

reg [4:0]  counter = 0;
reg [7:0]  div_cnt;
reg divCLK;


always @(posedge CLK) begin

   if(div_cnt == 0) divCLK <= ~divCLK;
   else div_cnt <= div_cnt - 8'b00000001;
   
end


always @(posedge divCLK) begin

   if(counter == Duty_Val) BackLight_OUT <= 1;
   else if(counter == 5'b11111) BackLight_OUT <= 0;
   else counter <= counter + 5'b1;
   
end



endmodule
