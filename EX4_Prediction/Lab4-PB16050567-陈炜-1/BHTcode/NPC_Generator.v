`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB（Embeded System Lab）
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
    input wire [1:0] PredictMiss,           //如果此数为10，需要拿BranchTarget，如果为00，不管，如果为01，拿pc+4
    output reg [31:0] PC_In
    );
    always @(*)
    begin
        if(PredictMiss==2'b10)         //这个判断要在其他判断之前，因为如果miss了，其他项中用于判断的PC值就不可靠了
            PC_In<=BranchTarget;
        else if(PredictMiss==2'b01)
            PC_In<=Expc+4;
        else if(BHThit)
            PC_In <= PrePC;
        else
            PC_In <= PCF+4;
    end
endmodule
