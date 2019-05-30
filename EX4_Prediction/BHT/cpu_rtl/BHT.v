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
    input rst,
    input [31:0] EXpc,
    input [31:0] IDpc,      //ID段寄存器的PC，用于判断预测和实际是否相符
    input [31:0] BrNPC,      //计算出来的跳转地址
    input BranchE,
    input [2:0]BranchTypeE,
    input BTBhit,
    output reg [1:0] PredictMiss,        
    output reg BHThit
    );
parameter SN=0,WN=2'b01,WT=2'b10,ST=2'b11;      //分别是强不命中，弱不命中，弱命中，强命中
reg [1:0] BHT_State;      //BHT状态机
initial BHT_State=WN;

always@(*)      //根据当前状态决定命中与否 
begin
    if(rst)
    begin
       BHThit<=0;
    end
    else
    if(BHT_State[1]==0)
        BHThit<=0;
    else
    begin
        if(BTBhit)
            BHThit<=1'b1;
        else
            BHThit<=0;
    end
end

always@(*)      //根据实际跳转情况改变状态
begin
    if(BranchE)
    begin
        case(BHT_State)
        SN:     BHT_State<=WN;
        WN:     BHT_State<=ST;
        WT:     BHT_State<=ST;
        ST:     BHT_State<=ST;
        endcase
    end
    else
    begin
    if(BranchTypeE!=0)      //不命中
    begin
        case(BHT_State)
        SN:     BHT_State<=SN;
        WN:     BHT_State<=SN;
        WT:     BHT_State<=SN;
        ST:     BHT_State<=WT;
        endcase
    end
            //else情况是根本不是branch指令，没有操作
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