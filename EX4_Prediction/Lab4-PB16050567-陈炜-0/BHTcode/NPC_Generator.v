`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB��Embeded System Lab��
// Engineer: Haojun Xia
// Create Date: 2019/03/14 11:21:33
// Design Name: RISCV-Pipline CPU
// Module Name: NPC_Generator
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Choose Next PC value
//////////////////////////////////////////////////////////////////////////////////
module NPC_Generator(
    input wire [31:0] PCF,JalrTarget, BranchTarget, JalTarget,PrePC,Expc,
    input wire JalD,JalrE,BHThit,
    input wire [1:0] PredictMiss,           //�������Ϊ10����Ҫ��BranchTarget�����Ϊ00�����ܣ����Ϊ01����pc+4
    output reg [31:0] PC_In
    );
    always @(*)
    begin
        if(PredictMiss==2'b10)         //����ж�Ҫ�������ж�֮ǰ����Ϊ���miss�ˣ��������������жϵ�PCֵ�Ͳ��ɿ���
            PC_In<=BranchTarget;
        else if(PredictMiss==2'b01)
            PC_In<=Expc+4;
        else if(BHThit)
            PC_In <= PrePC;
        else
            PC_In <= PCF+4;
    end
endmodule
