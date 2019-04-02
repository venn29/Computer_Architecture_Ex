`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB (Embeded System Lab)
// Engineer: Haojun Xia
// Create Date: 2019/02/08
// Design Name: RISCV-Pipline CPU
// Module Name: ControlUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: RISC-V Instruction Decoder
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module ControlUnit(
    input wire [6:0] Op,
    input wire [2:0] Fn3,
    input wire [6:0] Fn7,
    output wire JalD,
    output wire JalrD,
    output reg [2:0] RegWriteD,
    output wire MemToRegD,
    output reg [3:0] MemWriteD,
    output wire LoadNpcD,
    output reg [1:0] RegReadD,
    output reg [2:0] BranchTypeD,
    output reg [3:0] AluContrlD,
    output wire [1:0] AluSrc2D,
    output wire AluSrc1D,
    output reg [2:0] ImmType        
    );
    parameter C_Jal=7'b110_1111,C_Jalr=7'b110_0111,C_Branch=7'b110_0011,C_Load=7'b000_0011,C_Store=7'b010_0011,C_ICom=7'b001_0011,C_Compute=011_0011,C_LUI=7'b011_0111,C_AUIPC=7'b011_0111;
    //JalD
    always@(*)
    begin
        if(Op==C_Jal)
            JalD<=1'b1;
        else
            JalD<=0;
    end
    //JalrD
    always@(*)
    begin
        if(Op==C_Jalr)
            JalrD<=1'b1;
        else
            JalrD<=0;
    end
    //RegWrite
    always@(*)
    begin
        if(Op!=C_Load)
            RegWriteD<=0;
        else
        begin
            case Fn3:
                3'b000: RegWriteD<=LB;
                3'b001: RegWriteD<=LH;
                3'b010: RegWriteD<=LW;
                3'b100: RegWriteD<=LBU;
                3'b101: RegWriteD<=LHU;
                default:RegWriteD<=0;
            endcase
        end
    end
    //MemToReg
    always@(*)
    begin
        if(Op==C_Store)
            MemToReg<=1'b1;
        else
            MemToRegD<=0;
    end
    //MemWriteD
    always@(*)
    begin
        if(Op!=C_Store)
            MemWriteD<=0;
        else
        begin
            case Fn3:
                3'b000:MemWriteD<=4'b0001;
                3'b001:MemWriteD<=4'b0011;
                3'b010:MemWriteD<=4'b1111;
                default:MemWriteD<=0;
            endcase
        end
    end
    //loadPC
    always@(*)
    begin
        if(Op==C_Jal||Op==C_Jalr)
            loadPC<=1'b1;
        else
            loadPC<=0;
    end
    //RegRead
    always@(*)
    begin
        case Op:
            C_Jalr:     RegReadD<=2'b10;
            C_Branch:   RegReadD<=2'b11;
            C_Load:     RegReadD<=2'b10;
            C_Store:    RegReadD<=2'b11;
            C_ICom:     RegReadD<=2'b10;
            C_Compute:  RegReadD<=2'b11;
            default:    RegReadD<=0;
        endcase
    end
    //BranchType
    always@(*)
    begin
        if(Op!=C_Branch)
            BranchTypeD<=NOBRANCH;
        else
        begin
            case Fn3:
                3'b000:BranchTypeD<=BEQ;
                3'b001:BranchTypeD<=BNE;
                3'b100:BranchTypeD<=BLT;
                3'b101:BranchTypeD<=BGE;
                3'b110:BranchTypeD<=BLTU;
                3'b111:BranchTypeD<=BGEU;
                default:BranchTypeD<=0;
            endcase
        end
    end
    //AluControlD
    always@(*)
    begin
        case Op:
            C_LUI:      AluControlD<=LUI;
            C_Branch:   AluControlD<=SUB;
            C_ICom:
            begin
                case: Fn3
                    3'b000:     AluControlD<=ADD;
                    3'b010:     AluControlD<=SLT;       //有符号比较
                    3'b011:     AluControlD<=SLTU;
                    3'b100:     AluControlD<=XOR;
                    3'b110:     AluControlD<=OR;
                    3'b111:     AluControlD<=AND;
                    3'b001:     AluControlD<=SLL;
                    3'b101:
                    begin
                        case Fn7[5] :
                            1'b1:   AluControlD<=SRL;
                            0:      AluControlD<=SRA;
                        endcase
                    end
                endcase
            end
            C_Compute:
            begin
                case: Fn3
                    3'b000: 
                    begin   
                        case Fn7[5] :
                            1'b1:   AluControlD<=SUB;
                            0:      AluControlD<=ADD;
                        endcase
                    end
                    3'b010:     AluControlD<=SLT;       //有符号比较
                    3'b011:     AluControlD<=SLTU;
                    3'b100:     AluControlD<=XOR;
                    3'b110:     AluControlD<=OR;
                    3'b111:     AluControlD<=AND;
                    3'b001:     AluControlD<=SLL;
                    3'b101:
                    begin
                        case Fn7[5] :
                            1'b1:   AluControlD<=SRL;
                            0:      AluControlD<=SRA;
                        endcase
                    end
                endcase
            end
            default:    AluControlD<=AND;
        endcase      
    end

    //Alusrc1D
    always@(*)
    begin
        if(Op==C_Branch)
            Alusrc1D<=1'b1;
        else
            AluSrc1D<=0;
    end
    
    //Alusrc2D
    always@(*)
    begin
        if(Op==C_ICom&&(Fn3==3'b001||Fn3==3'b101))        //移位操作
            Alusrc2D<=2'b01;
        else if(Op==C_Compute||Op==C_Branch||Op==C_Store)
            Alusrc2D<=2'b00;
        else
            Alusrc2D<=0;
    end

    //ImmType
    always@(*)
    begin
        
    end


endmodule

//功能说明
    //ControlUnit       是本CPU的指令译码器，组合逻辑电路
//输入
    // Op               是指令的操作码部分
    // Fn3              是指令的func3部分
    // Fn7              是指令的func7部分
//输出
    // JalD==1          表示Jal指令到达ID译码阶段
    // JalrD==1         表示Jalr指令到达ID译码阶段
    // RegWriteD        表示ID阶段的指令对应的 寄存器写入模式 ，所有模式定义在Parameters.v中
    // MemToRegD==1     表示ID阶段的指令需要将data memory读取的值写入寄存器,
    // MemWriteD        共4bit，采用独热码格式，对于data memory的32bit字按byte进行写入,MemWriteD=0001表示只写入最低1个byte，和xilinx bram的接口类似
    // LoadNpcD==1      表示将NextPC输出到ResultM
    // RegReadD[1]==1   表示A1对应的寄存器值被使用到了，RegReadD[0]==1表示A2对应的寄存器值被使用到了，用于forward的处理
    // BranchTypeD      表示不同的分支类型，所有类型定义在Parameters.v中
    // AluContrlD       表示不同的ALU计算功能，所有类型定义在Parameters.v中
    // AluSrc2D         表示Alu输入源2的选择
    // AluSrc1D         表示Alu输入源1的选择
    // ImmType          表示指令的立即数格式，所有类型定义在Parameters.v中   
//实验要求  
    //实现ControlUnit模块   