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

////�ǵ�ȥ��HazzardUnit

module BTB(
    input re,           //�ڴ�BTB�������ж�flush���
    input NewPC,        //�µ�Ԥ��PC��������תPC
    input ChangePC,     //�ı���Ԥ��ֵ��PC
    input [31:0] CurrentPC,
    output [31:0] PrePC
    );
endmodule
