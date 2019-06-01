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
module Judge(
    input rst,
    input [31:0] EXpc,
    input [31:0] IDpc,      //ID段寄存器的PC，用于判断预测和实际是否相符
    input [31:0] BrNPC,      //计算出来的跳转地址
    input BranchE,
    input [2:0]BranchTypeE,

    output reg [1:0] BTBflush,          //10的时候，指示BTB更新设置为有效，01的时候，设空cahce，EXpc和Aluout不通过本模块传递,00表示不用改变
    output reg [1:0] PredictMiss,        //同上，
    output reg failed
    );
    

always@(*)
begin
    if(rst)
    begin
        BTBflush<=0;
        PredictMiss<=0;
        failed = 1'b0;
    end
    else
    begin
        if(BranchE)     //实际命中了
        begin
            if(IDpc==BrNPC)     //预测也命中了
            begin
                BTBflush<=0;
                PredictMiss<=0;
                failed<=0;
            end
            else 
            begin
                BTBflush<=2'b10;        //
                PredictMiss<=2'b10;
                failed = 1'b1;
            end
        end
        else if(BranchTypeE!=0)     //实际没命中
        begin
            if(EXpc+3'b100==IDpc)
            begin
                BTBflush<=0;
                PredictMiss<=0;
                failed<=0;
            end
            else
            begin
                BTBflush<=2'b01;
                PredictMiss<=2'b01;
                failed = 1'b1;
            end
        end
        else        //根本不是跳转指令
        begin
            BTBflush<=0;
            PredictMiss<=0;
            failed<=0;
        end
    end
end
endmodule