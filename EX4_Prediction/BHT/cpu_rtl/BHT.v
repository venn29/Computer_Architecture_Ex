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
///��ģ����Ժ�������ΪBHT
module BHT(
    input rst,
    input [31:0] EXpc,
    input [31:0] IDpc,      //ID�μĴ�����PC�������ж�Ԥ���ʵ���Ƿ����
    input [31:0] BrNPC,      //�����������ת��ַ
    input BranchE,
    input [2:0]BranchTypeE,
    input BTBhit,
    output reg [1:0] PredictMiss,        
    output reg BHThit
    );
parameter SN=0,WN=2'b01,WT=2'b10,ST=2'b11;      //�ֱ���ǿ�����У��������У������У�ǿ����
reg [1:0] BHT_State;      //BHT״̬��
initial BHT_State=WN;

always@(*)      //���ݵ�ǰ״̬����������� 
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

always@(*)      //����ʵ����ת����ı�״̬
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
    if(BranchTypeE!=0)      //������
    begin
        case(BHT_State)
        SN:     BHT_State<=SN;
        WN:     BHT_State<=SN;
        WT:     BHT_State<=SN;
        ST:     BHT_State<=WT;
        endcase
    end
            //else����Ǹ�������branchָ�û�в���
    end
end


always@(*)          //���Ԥ����󣬸ı�״̬��ͬʱ����Ҫ֪ͨHazzard��NPC��
begin
    if(rst)
        PredictMiss<=0;
    else
    begin
        if(BranchE)     //ʵ��������
        begin
            if(IDpc==BrNPC)     //Ԥ��Ҳ������
                PredictMiss<=0;
            else 
                PredictMiss<=2'b10;
        end
        else if(BranchTypeE!=0)     //ʵ��û����
        begin
            if(EXpc+3'b100==IDpc)
                PredictMiss<=0;
            else
                PredictMiss<=2'b01;       
        end
        else        //����������תָ��
            PredictMiss<=0;
        
    end
end

endmodule