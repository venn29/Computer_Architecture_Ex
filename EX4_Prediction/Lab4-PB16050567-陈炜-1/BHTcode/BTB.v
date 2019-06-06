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
    input clk,
    input rst,                  //���ڳ�ʼ��
    input [31:0] BrNPC,        //�µ�Ԥ��PC��������תPC,BrNPC
    input [31:0] EXpc,     //�ı���Ԥ��ֵ��PC,EXpc
    input [31:0] CurrentPC,     //������ȡԤ��ֵ
    input BranchE,
    output reg [31:0] PrePC,        //Ԥ��ֵ
    output reg BTBhit               //BTBcache���Ƿ����У�����BHT��
    );

reg [31:0] PreCache[0:15];        //cache�Ĵ�СΪ64
reg [26:0] Pretag[0:15];          //���ڱȽϵ�tag�����2λ�ʹε�6λ���ñȽ�
reg valid[0:15];                  //��Чλ
reg BTBchange;

wire [3:0] updateAddr;
wire [26:0] updateTag;
wire [3:0]  fetchAddr;
wire [26:0] fetchTag;       

assign  updateAddr = EXpc[5:2];      //4λ��ַ�����µ�ӳ���ַ
assign  updateTag =EXpc[31:6];      //26λ����tag
assign fetchAddr = CurrentPC[5:2];
assign fetchTag= CurrentPC[31:6];
always@(*)          //����BTB�Ƿ�flush
begin
    if(rst)
        BTBchange<=0;
    else
    begin
        if(BranchE)     //�����˾���Ҫ�����ǲ���Ҫ��BTB�Ļ����ˣ���ͻ����ԭ����invalid�͸Ļ�������
        begin
            if(valid[updateAddr] == 0||updateTag!=Pretag[updateAddr])
                BTBchange<=1'b1;
            else 
                BTBchange<=0;
        end
        else
            BTBchange<=0;       //�뵥BTB��ͬ�������оͲ��Ļ���
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
        if(BTBchange)     //BTBcache��Ҫ�ı�    
        begin
            valid[updateAddr]<=1'b1;
            Pretag[updateAddr]<=updateTag;
            PreCache[updateAddr]<=BrNPC;
        end     //update    
                                        //�������û�в���
    end     //~rst
end

always@(*)      //��ȡ
begin
    if(rst)
        BTBhit<=0;
    else
    begin
        if(valid[fetchAddr]&&fetchTag==Pretag[fetchAddr])
        begin
            BTBhit<=1'b1;
            PrePC<=PreCache[fetchAddr];
        end         //����
        else
        begin
            BTBhit<=0;
        end
    end     //~rst
end




endmodule
