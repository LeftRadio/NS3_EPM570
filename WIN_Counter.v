module WIN_Counter
(
input [17:0]       WIN_DATA,
input              CLK_EN,
input              Start_Write,
input              event_in,
input              CLK,

output reg         Write_Ready,
output reg [17:0]  WINcnt
);

//reg [17:0]  WINcnt;


always @(posedge CLK) begin
     
   if(Start_Write == 0) begin  // �����     
          WINcnt <= 0;
          Write_Ready <= 0;       
   end
   else if(CLK_EN == 1) begin
          
       /* ���� ������ ������������ �������� �� ��������� �������, ������� ����������� */
       if(event_in == 1) begin 
             
           if(WINcnt == WIN_DATA) begin  // ���� ���������
               Write_Ready <= 1;  // ������ ������ � ��������� ������
           end           
           else WINcnt <= WINcnt + 1'b1;  // ����� �������             
       end
   end

end

endmodule