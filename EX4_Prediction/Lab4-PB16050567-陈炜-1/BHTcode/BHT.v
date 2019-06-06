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
    input clk,
    input rst,
    input [31:0] EXpc,
    input [31:0] IDpc,      //ID�μĴ�����PC�������ж�Ԥ���ʵ���Ƿ����
    input [31:0] BrNPC,      //�����������ת��ַ
    input BranchE,
    input [2:0]BranchTypeE,
    input BTBhit,
    output reg [1:0] PredictMiss,        
    output reg BHThit,
    output reg failed
    );
parameter SN=0,WN=2'b01,WT=2'b10,ST=2'b11;      //�ֱ���ǿ�����У��������У������У�ǿ����
reg [1:0] BHT_State [0:15];      //BHT״̬��
initial BHT_State[0]=WN;
initial BHT_State[1]=WN;
initial BHT_State[2]=WN;
initial BHT_State[3]=WN;
initial BHT_State[4]=WN;
initial BHT_State[5]=WN;
initial BHT_State[6]=WN;
initial BHT_State[7]=WN;
initial BHT_State[8]=WN;
initial BHT_State[9]=WN;
initial BHT_State[10]=WN;
initial BHT_State[11]=WN;
initial BHT_State[12]=WN;
initial BHT_State[13]=WN;
initial BHT_State[14]=WN;
initial BHT_State[15]=WN;

wire [3:0] updateAddr;
wire [26:0] updateTag;
wire [3:0]  fetchAddr;
wire [26:0] fetchTag;       

assign  updateAddr = EXpc[5:2];      //4λ��ַ�����µ�ӳ���ַ
assign  updateTag =EXpc[31:6];      //26λ����tag
assign fetchAddr = IDpc[5:2];
assign fetchTag= IDpc[31:6];

reg [7:0] miss;
always@(*)      //���ݵ�ǰ״̬����������� 
begin
    if(rst)
    begin
       BHThit<=0;
    end
    else
    if(BHT_State[fetchAddr]==2'b01||BHT_State[fetchAddr]==0)
        BHThit<=0;
    else
    begin
        if(BTBhit)
            BHThit<=1'b1;
        else
            BHThit<=0;
    end
end

always@(posedge clk)      //����ʵ����ת����ı�״̬
begin
    if (rst)
    begin
        BHT_State[updateAddr]<=WN;
        miss <=0;
    end
    else 
    begin
    if(BranchE)
    begin
        case(BHT_State[updateAddr])
        SN:     begin
       BHT_State[updateAddr]<=WN;
        miss <= miss+1'b1;
        end
        WN:    
        begin
        BHT_State[updateAddr]<=ST;
         miss <= miss +1'b1;
         end
        WT:    BHT_State[updateAddr]<=ST;
        ST:     BHT_State[updateAddr]<=ST;
        endcase
        end
    else
    begin
    if(BranchTypeE!=0)      //������
    begin
        case(BHT_State[updateAddr])
        SN:     BHT_State[updateAddr]<=SN;
        WN:     BHT_State[updateAddr]<=SN;
        WT:    begin
         BHT_State[updateAddr]<=SN;
         miss <=miss +1'b1;
         end
        ST:     begin
        BHT_State[updateAddr]<=WT;
        miss <=miss +1'b1;
        end
        endcase
    end
            //else����Ǹ�������branchָ�û�в���
    end
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