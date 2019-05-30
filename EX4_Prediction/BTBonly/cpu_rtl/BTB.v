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

module BTB(
    input re,           //在纯BTB中用于判断flush与否
    input NewPC,        //新的预测PC，既是跳转PC
    input ChangePC,     //改变了预测值的PC
    input [31:0] CurrentPC,
    output [31:0] PrePC
    );
endmodule
