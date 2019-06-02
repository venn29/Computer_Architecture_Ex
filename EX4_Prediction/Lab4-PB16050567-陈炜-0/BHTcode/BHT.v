`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 23:52:07
// Design Name: 
// Module Name: BTB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

////记得去改HazzardUnit
///此模块可以后面升级为BHT
module BHT(
    input clk,
    input rst,
    input [31:0] EXpc,
    input [31:0] IDpc,      //ID段寄存器的PC，用于判断预测和实际是否相符
    input [31:0] BrNPC,      //计算出来的跳转地址
    input BranchE,
    input [2:0]BranchTypeE,
    input BTBhit,
    output reg [1:0] PredictMiss,        
    output reg BHThit,
    output reg failed
    );
parameter SN=0,WN=2'b01,WT=2'b10,ST=2'b11;      //分别是强不命中，弱不命中，弱命中，强命中
reg [1:0] BHT_State [0:15];      //BHT状态机
initial BHT_State[0]=WN;
initial BHT_State[1]=WN;
initial BHT_State[2]=WN;
initial BHT_State[3]=WN;
initial BHT_State[4]=WN;
initial BHT_State[5]=WN;
initial BHT_State[6]=WN;
initial BHT_State[7]=WN;
initial BHT_State[8]=WN;
initial BHT_State[9]=WN;
initial BHT_State[10]=WN;
initial BHT_State[11]=WN;
initial BHT_State[12]=WN;
initial BHT_State[13]=WN;
initial BHT_State[14]=WN;
initial BHT_State[15]=WN;

wire [3:0] updateAddr;
wire [26:0] updateTag;
wire [3:0]  fetchAddr;
wire [26:0] fetchTag;       

assign  updateAddr = EXpc[5:2];      //4位地址，更新的映射地址
assign  updateTag =EXpc[31:6];      //26位更新tag
assign fetchAddr = IDpc[5:2];
assign fetchTag= IDpc[31:6];

reg [7:0] miss;
always@(*)      //根据当前状态决定命中与否 
begin
    if(rst)
    begin
       BHThit<=0;
    end
    else
    if(BHT_State[fetchAddr]==2'b01||BHT_State[fetchAddr]==0)
        BHThit<=0;
    else
    begin
        if(BTBhit)
            BHThit<=1'b1;
        else
            BHThit<=0;
    end
end

always@(posedge clk)      //根据实际跳转情况改变状态
begin
    if (rst)
    begin
        BHT_State[updateAddr]<=WN;
        miss <=0;
    end
    else 
    begin
    if(BranchE)
    begin
        case(BHT_State[updateAddr])
        SN:     begin
       BHT_State[updateAddr]<=WN;
        miss <= miss+1'b1;
        end
        WN:    
        begin
        BHT_State[updateAddr]<=ST;
         miss <= miss +1'b1;
         end
        WT:    BHT_State[updateAddr]<=ST;
        ST:     BHT_State[updateAddr]<=ST;
        endcase
        end
    else
    begin
    if(BranchTypeE!=0)      //不命中
    begin
        case(BHT_State[updateAddr])
        SN:     BHT_State[updateAddr]<=SN;
        WN:     BHT_State[updateAddr]<=SN;
        WT:    begin
         BHT_State[updateAddr]<=SN;
         miss <=miss +1'b1;
         end
        ST:     begin
        BHT_State[updateAddr]<=WT;
        miss <=miss +1'b1;
        end
        endcase
    end
            //else情况是根本不是branch指令，没有操作
    end
    end
end


always@(*)          //如果预测错误，改变状态的同时，还要通知Hazzard和NPC，
begin
    if(rst)
        PredictMiss<=0;
    else
    begin
        if(BranchE)     //实际命中了
        begin
            if(IDpc==BrNPC)     //预测也命中了
        
                PredictMiss<=0;
            else 
                PredictMiss<=2'b10;
        end
        else if(BranchTypeE!=0)     //实际没命中
        begin
            if(EXpc+3'b100==IDpc)
                PredictMiss<=0;
            else
                PredictMiss<=2'b01;   
        end
        else        //根本不是跳转指令
            PredictMiss<=0;
    end
end

endmodule