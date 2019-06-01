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
    input clk,
    input rst,                  //用于初始化
    input [31:0] BrNPC,        //新的预测PC，既是跳转PC,BrNPC
    input [31:0] EXpc,     //改变了预测值的PC,EXpc
    input [31:0] CurrentPC,     //用于提取预测值
    input BranchE,
    output reg [31:0] PrePC,        //预测值
    output reg BTBhit               //BTBcache中是否命中，传到BHT中
    );

reg [31:0] PreCache[0:15];        //cache的大小为64
reg [26:0] Pretag[0:15];          //用于比较的tag，最低2位和次低6位不用比较
reg valid[0:15];                  //有效位
reg BTBchange;

wire [3:0] updateAddr;
wire [26:0] updateTag;
wire [3:0]  fetchAddr;
wire [26:0] fetchTag;       

assign  updateAddr = EXpc[5:2];      //4位地址，更新的映射地址
assign  updateTag =EXpc[31:6];      //26位更新tag
assign fetchAddr = CurrentPC[5:2];
assign fetchTag= CurrentPC[31:6];
always@(*)          //决定BTB是否flush
begin
    if(rst)
        BTBchange<=0;
    else
    begin
        if(BranchE)     //命中了就需要决定是不是要改BTB的缓存了，冲突或者原本是invalid就改缓存内容
        begin
            if(valid[updateAddr] == 0||updateTag!=Pretag[updateAddr])
                BTBchange<=1'b1;
            else 
                BTBchange<=0;
        end
        else
            BTBchange<=0;       //与单BTB不同，不命中就不改缓存
    end
        
end


always@(posedge clk)
begin
    if(rst)
    begin
       valid[0]=0;
       valid[1]=0;
       valid[2]=0;
       valid[3]=0;
       valid[4]=0;
       valid[5]=0;
       valid[6]=0;
       valid[7]=0;
       valid[8]=0;
       valid[9]=0;
       valid[10]=0;
       valid[11]=0;
       valid[12]=0;
       valid[13]=0;
       valid[14]=0;
       valid[15]=0;
    end     //rst
    else 
    begin
        if(BTBchange)     //BTBcache需要改变    
        begin
            valid[updateAddr]<=1'b1;
            Pretag[updateAddr]<=updateTag;
            PreCache[updateAddr]<=BrNPC;
        end     //update    
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
