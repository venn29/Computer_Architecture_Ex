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
    input rst,                  //���ڳ�ʼ��
    input [1:0] BTBflush,           //�ڴ�BTB�������ж�flush���
    input [31:0] BrNPC,        //�µ�Ԥ��PC��������תPC,BrNPC
    input [31:0] EXpc,     //�ı���Ԥ��ֵ��PC,EXpc
    input [31:0] CurrentPC,     //������ȡԤ��ֵ

    output reg [31:0] PrePC,        //Ԥ��ֵ
    output reg BTBhit               //BTBcache���Ƿ�����
    );

reg [31:0] PreCache[16];        //cache�Ĵ�СΪ64
reg [26:0] Pretag[16];          //���ڱȽϵ�tag�����2λ�ʹε�6λ���ñȽ�
reg valid[16];                  //��Чλ

wire [3:0] updateAddr;
wire [26:0] updateTag;
wire [3:0]  fetchAddr;
wire [26:0] fetchTag;       

assign  updateAddr = EXpc[5:2];      //4λ��ַ�����µ�ӳ���ַ
assign  updateTag =EXpc[31:6];      //26λ����tag
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
        if(BTBflush==2'b10)     //��Ҫ����Ч��Ϊ��Ч    
        begin
            valid[updateAddr]<=1'b1;
            Pretag[updateAddr]<=updateTag;
            PreCache[updateAddr]<=BrNPC;
        end     //update
        else if(BTBflush==2'b01)        //��Ҫ����Ч��Ϊ��Ч
            valid[updateAddr]=0;        
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
