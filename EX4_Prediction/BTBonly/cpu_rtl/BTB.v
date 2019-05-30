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
    input rst,                  //用于初始化
    input [1:0] BTBflush,           //在纯BTB中用于判断flush与否
    input [31:0] BrNPC,        //新的预测PC，既是跳转PC,BrNPC
    input [31:0] EXpc,     //改变了预测值的PC,EXpc
    input [31:0] CurrentPC,     //用于提取预测值

    output reg [31:0] PrePC,        //预测值
    output reg BTBhit               //BTBcache中是否命中
    );

reg [31:0] PreCache[16];        //cache的大小为64
reg [26:0] Pretag[16];          //用于比较的tag，最低2位和次低6位不用比较
reg valid[16];                  //有效位

wire [3:0] updateAddr;
wire [26:0] updateTag;
wire [3:0]  fetchAddr;
wire [26:0] fetchTag;       

assign  updateAddr = EXpc[5:2];      //4位地址，更新的映射地址
assign  updateTag =EXpc[31:6];      //26位更新tag
assign fetchAddr = CurrentPC[5:2];
assign fetchTag= CurrentPC[31:6];

always@(*)
begin
    if(rst)
    begin
        for(integer i=0;i<16;i++)
            valid[i]<=0;
    end     //rst
    else 
    begin
        if(BTBflush==2'b10)     //需要从无效变为有效    
        begin
            valid[updateAddr]<=1'b1;
            Pretag[updateAddr]<=updateTag;
            PreCache[updateAddr]<=BrNPC;
        end     //update
        else if(BTBflush==2'b01)        //需要从有效变为无效
            valid[updateAddr]=0;        
                                        //其他情况没有操作
    end     //~rst
end

always@(*)      //读取
begin
    if(rst)
        BTBhit<=0;
    else
    begin
        if(valid[fetchAddr]&&fetchTag==Pretag[fetchAddr])
        begin
            BTBhit<=1'b1;
            PrePC<=PreCache[fetchAddr];
        end         //命中
        else
        begin
            BTBhit<=0;
        end
    end     //~rst
end




endmodule
