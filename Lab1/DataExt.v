`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: qihao
// Create Date: 03/09/2019 09:03:05 PM
// Design Name: 
// Module Name: DataExt 
// Target Devices: 
// Tool Versions: 
// Description: 
//////////////////////////////////////////////////////////////////////////////////

`include "Parameters.v"   
module DataExt(
    input wire [31:0] IN,
    input wire [1:0] LoadedBytesSelect,
    input wire [2:0] RegWriteW,
    output reg [31:0] OUT
    );    
    reg [3:0] DuRe;       //

    always@(*)
    begin
        case(RegWriteW)
       `LB:DuRe<=4'b0001<<LoadedBytesSelect;
       `LH:DuRe<=4'b0011<<LoadedBytesSelect;
       `LW:DuRe<=4'b1111;
       `LBU:DuRe<=4'b0001<<LoadedBytesSelect;
       `LHU:DuRe<=4'b0011<<LoadedBytesSelect;
       endcase
    end
    
    
    reg [31:0] OutRaw;//
    always@(*)
    begin
        if(DuRe[0])
            OutRaw[7:0]=IN[7:0];
         else
            OutRaw[7:0]=0;
    end
   always@(*)
   begin
       if(DuRe[1])
           OutRaw[15:8]=IN[15:8];
        else
           OutRaw[15:8]=0;
   end
   always@(*)
   begin
   if(DuRe[2])
      OutRaw[23:16]=IN[23:16];
    else
      OutRaw[23:16]=0;
   end
   always@(*)
   begin
    if(DuRe[3])
       OutRaw[31:24]=IN[31:24];
    else
       OutRaw[31:24]=0;
     end
     
     
     always@(*)
     begin
       if(RegWriteW==`LB||RegWriteW==`LH)     //������չ
         begin
            case(DuRe)
            4'b0001:    OUT<={  {24{ OutRaw[7] }},OutRaw[7:0] };
            4'b0010:    OUT<={ {24 {OutRaw[15]} } , OutRaw[15:8] };
            4'b0100:   OUT<={ {24{OutRaw[23]}},OutRaw[23:16] };
            4'b1000:    OUT<={ {24{OutRaw[31]}},OutRaw[31:24] };
            4'b0011:   OUT<={ {16{OutRaw[15]}},OutRaw[15:0] };
            4'b0110:    OUT<={ {16{OutRaw[23]}},OutRaw[23:8] };
             4'b1100:    OUT<={ {16{OutRaw[31]}},OutRaw[31:16] };
            default:    OUT<=OutRaw;    //1111
            endcase
         end    //if
       else if(RegWriteW==`LBU||RegWriteW==`LHU)     //������չ
                  begin
                     case(DuRe)
                     4'b0001:    OUT<={  24'b0,OutRaw[7:0] };
                     4'b0010:    OUT<={ 24'b0,OutRaw[15:8] };
                     4'b0100:   OUT<={ 24'b0,OutRaw[23:16] };
                     4'b1000:    OUT<={ 24'b0,OutRaw[31:24] };
                     4'b0011:   OUT<={ 16'b0,OutRaw[15:0] };
                     4'b0110:    OUT<={ 16'b0,OutRaw[23:8] };
                      4'b1100:    OUT<={ 16'b0,OutRaw[31:16] };
                     default:    OUT<=OutRaw;    //1111
                     endcase
                  end    // else if
        else
            OUT<=OutRaw;
     end    //always
endmodule

//功能说明
    //DataExt是用来处理非字对齐load的情形，同时根据load的不同模式对Data Mem中load的数进行符号或�?�无符号拓展，组合�?�辑电路
//输入
    //IN                    是从Data Memory中load�??32bit�??
    //LoadedBytesSelect     等价于AluOutM[1:0]，是读Data Memory地址的低两位�??
                            //因为DataMemory是按字（32bit）进行访问的，所以需要把字节地址转化为字地址传给DataMem
                            //DataMem�??次返回一个字，低两位地址用来�??32bit字中挑�?�出我们�??要的字节
    //RegWriteW             表示不同�?? 寄存器写入模�?? ，所有模式定义在Parameters.v�??
//输出
    //OUT表示要写入寄存器的最终�??
//实验要求  
    //实现DataExt模块  