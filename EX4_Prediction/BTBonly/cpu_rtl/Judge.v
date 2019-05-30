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
module Judge(
    input rst,
    input [31:0] EXpc,
    input [31:0] IDpc,      //ID�μĴ�����PC�������ж�Ԥ���ʵ���Ƿ����
    input [31:0] BrNPC,      //�����������ת��ַ
    input BranchE,
    input BranchTypeE,

    output reg [1:0] BTBflush,          //10��ʱ��ָʾBTB��������Ϊ��Ч��01��ʱ�����cahce��EXpc��Aluout��ͨ����ģ�鴫��,00��ʾ���øı�
    output reg [1:0] PredictMiss        //ͬ�ϣ�
    );

reg [31:0] PreCache[64];        //cache�Ĵ�СΪ64
reg [23:0] Pretag[64];          //���ڱȽϵ�tag�����2λ�ʹε�6λ���ñȽ�
reg valid[64];                  //��Чλ
always@(*)
begin
    if(rst)
    begin
        BTBflush<=0;
        PredictMiss<=0;
    end
    else
    begin
        if(BranchE)     //ʵ��������
        begin
            if(IDpc==BrNPC)     //Ԥ��Ҳ������
            begin
                BTBflush<=0;
                PredictMiss<=0;
            end
            else 
            begin
                BTBflush<=2'b10;        //
                PredictMiss<=2'b10;
            end
        end
        else if(BranchTypeE!=0)     //ʵ��û����
        begin
            if(EXpc+3'b100==IDpc)
            begin
                BTBflush<=0;
                PredictMiss<=0;
            end
            else
            begin
                BTBflush<=2'b01;
                PredictMiss<=2'b01;
            end
        end
        else        //����������תָ��
        begin
            BTBflush<=0;
            PredictMiss<=0;
        end
    end
end
endmodule