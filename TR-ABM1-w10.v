`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 10:00:20 PM
// Design Name: 
// Module Name: trunc_BM
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

module muxaa (input a1,a0,sel,  output out);
assign out = sel? a1:a0;
endmodule

module LOPD_4s_Msb(input [3:0] x,
                   output [1:0] y,
                   output v);

wire w1,w2,w3;      
    
muxaa g2(~x[2],x[2],x[3],y[1]);    
muxaa g3(x[1],~x[1],x[3],w1);  
muxaa g4(x[0],~x[0],x[3],w2);  

nor g6(y[0],y[1],w1);
nand g7(w3,w1,w2);
nor g9(v,y[1],w3);

           
endmodule

module LOPD_4s_inter(input [3:0] x,
                     input msb,
                     output [1:0] y,
                     output v);     

wire w1,w2,w3,w4,w5,w6;    
    
muxaa g1(x[3],~x[3],msb,w1);    
muxaa g2(x[2],~x[2],msb,w2);    
muxaa g3(x[1],~x[1],msb,w3);  
muxaa g4(x[0],~x[0],msb,w4);  

nand g5(y[1],w1,w2);
nand g6(w5,w2,~w3);
nand g7(w6,w3,w4);
nand g8(y[0],w1,w5);
nor g9(v,y[1],w6); 
           
endmodule

module LOPD(input [15:0] x,
               output [3:0] y
               );
               

wire v3,v2,v1,v0;

wire w1,w2,w3,w4,w5,w6;    
wire [7:0] op;
   
LOPD_4s_Msb g1(x[15:12],op[7:6],v3);
LOPD_4s_inter g2(x[11:8],x[15],op[5:4],v2); 
LOPD_4s_inter ga1(x[7:4],x[15],op[3:2],v1); 
LOPD_4s_inter ga2(x[3:0],x[15],op[1:0],v0); 

wire va1;
wire [5:0] ya;
               
not g3(ya[5],v3);
not g5(ya[2],v1);
assign ya[4:3] = v3? op[5:4]:op[7:6];
assign ya[1:0] = v1? op[1:0]:op[3:2];
nand g6(va1,v3,v2);
//nand g7(va0,v1,v0);
//nor g8(v,va1,va0);
assign y[3] = va1;
assign y[2:0] = va1? ya[5:3]:ya[2:0];
              
endmodule
module approx_4_2(output s,c,  input a1,a2,a3,a4);
wire w1,w2;

nor g1(w1,a1,a2);
nor g2(w2,a3,a4);
nor g3(c,w1,w2);
nand g4(s,w1,w2);
endmodule

module fa(sum,co,x,y,cin);
output sum,co;
input x,y,cin;
wire w1,w2,w3;
xor g1(w1,x,y);
and g2(w2,cin,w1);
and g3(w3,x,y);
xor g4(sum,w1,cin);
or g5(co,w3,w2);
endmodule

module ha(s,c,a,b);
output s,c;
input a,b;
xor X1(s,a,b);
and A1(c,a,b);
endmodule

module four_two_acc(output s,c1,c2, input a1,a2,a3,a4,cin);

wire w1,w2,w3,w4,w5,w6;
xor g1(w1,a1,a2);
and g2(w2,a3,w1);
and g3(w3,a1,a2);
xor g4(s1,w1,a3);
or g5(c2,w3,w2);

xor g6(w4,s1,a4);
and g7(w5,cin,w4);
and g8(w6,s1,a4);
xor g9(s,w4,cin);
or g10(c1,w6,w5);
endmodule

module generate_pp (output pp ,  input a1,a0,b2,b1,b0);

wire w1,w2,w3,w4,w5,w6,w7,w8,w9;

and g1(w1,a0,b1,b0);
xor g2(w2,b1,b0);
and g3(w3,w2,a1);
and ga(w4,w2,~a1);
or g4(w6,w1,w3);
and g5(w5,~a0,~b1,~b0);
or g6(w7,w4,w5);
and g7(w8,~b2,w6);
and g8(w9,w7,b2);
or g9(pp,w9,w8);
endmodule

module pp_gen_0 (input b2,b1,b0,a0,  output pp);
wire w1,w2,w3,w4,w5,w6,w7;

and g1(w1,b2,~b0,~a0);
and g2(w2,b2,~b1);
nand g3(w3,a0,b0);
xor g4(w4,b1,b0);
and g5(w5,~b2,a0);
and g6(w6,w2,w3);
and g7(w7,w4,w5);
or g8(pp,w1,w6,w7);
endmodule

module pp_gen_8 (input b2,b1,b0,y7, output pp);

wire w1,w2,w3,w4,w5,w6;

nand g1(w1,b0,b1);
and g2(w2,b2,~y7);
and g3(w3,w1,w2);
and g4(w4,~b2,y7);
or g5(w5,b1,b0);
and g6(w6,w4,w5);
or g7(pp,w3,w6);
endmodule

module neg_gen (input b2,b1,b0,  output neg);
wire w1;
nand g1(w1,b0,b1);
and g2(neg,w1,b2);
endmodule

module booth_mul_NN(input signed [9:0] x,y,output signed [19:0] z);
wire [4:0] neg;

wire  [10:0] p0,p1,p2,p3,p4;

neg_gen g1(x[1],x[0],1'b0,neg[0]);
neg_gen g2(x[3],x[2],x[1],neg[1]);
neg_gen g3(x[5],x[4],x[3],neg[2]);
neg_gen g4(x[7],x[6],x[5],neg[3]);
neg_gen g5(x[9],x[8],x[7],neg[4]);


pp_gen_0 u1(x[1],x[0],1'b0,y[0],p0[0]);
pp_gen_0 u2(x[3],x[2],x[1],y[0],p1[0]);
pp_gen_0 u3(x[5],x[4],x[3],y[0],p2[0]);
pp_gen_0 u4(x[7],x[6],x[5],y[0],p3[0]);
pp_gen_0 u5(x[9],x[8],x[7],y[0],p4[0]);


genvar i;
generate
for (i=1;i<10;i=i+1) begin
generate_pp Ma2(p0[i],y[i],y[i-1],x[1],x[0],1'b0);
generate_pp Ma11(p1[i],y[i],y[i-1],x[3],x[2],x[1]);
generate_pp Ma20(p2[i],y[i],y[i-1],x[5],x[4],x[3]);
generate_pp Ma29(p3[i],y[i],y[i-1],x[7],x[6],x[5]);
generate_pp Ma30(p4[i],y[i],y[i-1],x[9],x[8],x[7]);
end   
endgenerate

pp_gen_8 u9(x[1],x[0],1'b0,y[9],p0[10]);
pp_gen_8 u10(x[3],x[2],x[1],y[9],p1[10]);
pp_gen_8 u11(x[5],x[4],x[3],y[9],p2[10]);
pp_gen_8 u12(x[7],x[6],x[5],y[9],p3[10]);
pp_gen_8 u13(x[9],x[8],x[7],y[9],p4[10]);

ha ka(sa,ca,p0[0],neg[0]);
ha kb(sb,cb,p1[0],neg[1]);
fa k1(s1,c1,p0[4],p1[2],p2[0]);
fa k2(s2,c2,p0[5],p1[3],p2[1]);
four_two_acc k3(s3,ca3,cb3,p0[6],p1[4],p2[2],p3[0],neg[3]);
four_two_acc k4(s4,ca4,cb4,p0[7],p1[5],p2[3],p3[1],cb3);
four_two_acc k5(s5,ca5,cb5,p0[8],p1[6],p2[4],p3[2],cb4);
ha ke(se,ce,p4[0],neg[4]);
four_two_acc k6(s6,ca6,cb6,p0[9],p1[7],p2[5],p3[3],cb5);
four_two_acc k7(s7,ca7,cb7,p0[10],p1[8],p2[6],p3[4],cb6);
four_two_acc k8(s8,ca8,cb8,p0[10],p1[9],p2[7],p3[5],cb7);
four_two_acc k9(s9,ca9,cb9,~p0[10],~p1[10],p2[8],p3[6],cb8);
four_two_acc k10(s10,ca10,cb10,1'b1,p2[9],p3[7],p4[5],cb9);
fa k11(s11,c11,~p2[10],p3[8],cb10);
fa k12(s12,c12,1'b1,p3[9],p4[7]);


////////////////stage 2 //////////////////////////

ha k15(s15,c15,ca,p0[1]);
ha k16(s16,c16,p0[2],sb);
fa k17(s17,c17,cb,p0[3],p1[1]);
ha k18(s18,c18,s1,neg[2]);
ha k19(s19,c19,c1,s2);
ha k20(s20,c20,s3,c2);
ha k21(s21,c21,s4,ca3);
fa k22(s22,c22,s5,se,ca4);
four_two_acc k23(s23,ca23,cb23,s6,p4[1],ca5,ce,1'b0);
four_two_acc k24(s24,ca24,cb24,s7,p4[2],ca6,cb23,1'b0);
four_two_acc k25(s25,ca25,cb25,s8,p4[3],ca7,cb24,1'b0);
four_two_acc k26(s26,ca26,cb26,s9,p4[4],ca8,cb25,1'b0);
fa  k27(s27,c27,s10,ca9,cb26);
fa  k28(s28,c28,s11,p4[6],ca10);
ha k29(s29,c29,s12,c11);
fa k30(s30,c30,~p3[10],p4[8],c12);
ha k31(s31,c31,1'b1,p4[9]);


assign z =  {1'b0,c31,c30,c29,c28,c27,ca26,ca25,ca24,ca23,c22,c21,c20,c19,c18,c17,c16,c15,1'b0,1'b0} + {1'b1,~p4[10],s31,s30,s29,s28,s27,s26,s25,s24,s23,s22,s21,s20,s19,s18,s17,s16,s15,sa};
endmodule
module trunc_BM #(parameter k_in = 10,n_in = 16,m_in = 16)(a, b, r);

input [n_in-1:0] a;
input [m_in-1:0] b;
output [(n_in+m_in)-1:0] r;

wire [$clog2(n_in)-1:0] k1;
wire [$clog2(m_in)-1:0] k2;
wire [k_in-3:0] m,n;
//wire [n_in-1:0] l1;
//wire [m_in-1:0] l2;
wire [(k_in*2)-1:0] tmp;
wire [$clog2(m_in)-1:0] p;
wire [$clog2(m_in)-1:0] q;
wire [$clog2(m_in):0]sum;
wire [k_in-1:0]mm,nn;

LOPD  u1(.x(a), .y(k1));
LOPD  u2(.x(b),.y(k2));

Mux_16_3_k #(k_in, n_in) u5(.in_a(a), .select(k1), .out(m));
Mux_16_3_k #(k_in, m_in) u6(.in_a(b), .select(k2), .out(n));

assign p=(k1>(k_in-2))?k1-(k_in-2):0;
assign q=(k2>(k_in-2))?k2-(k_in-2):0;

assign mm=(k1>k_in-2)?({a[n_in-1],m,1'b1}):{a[n_in-1],a[k_in-2:0]};
assign nn=(k2>k_in-2)?({b[n_in-1],n,1'b1}):{b[n_in-1],b[k_in-2:0]};

booth_mul_NN  h1(mm,nn,tmp);
assign sum=p+q;

Barrel_Shifter_k_mn #(k_in, n_in, m_in) u7(.in_a(tmp), .count(sum), .out_a(r));

endmodule

//--------------------------------
module Barrel_Shifter_k_mn #(parameter k_in = 10,n_in = 16,m_in = 16)(in_a, count, out_a);
input [$clog2(m_in):0]count;
input [(k_in*2)-1:0]in_a;
output [(n_in+m_in)-1:0]out_a;


wire [(n_in + m_in)-1:0] tmp;
assign tmp = {{((n_in + m_in)-(k_in*2)){in_a[(k_in*2)-1]}}, in_a};
assign out_a=(tmp<<(count));

endmodule

//--------------------------------

module Mux_16_3_k #(parameter k_in = 6, n_in = 16)(in_a, select, out);
    input [$clog2(n_in)-1:0] select;
    input [n_in-1:0] in_a;
    output reg [k_in-3:0] out;

    always @(*) begin
        if (select < 9) begin
            out = in_a[7: 0];
        end else begin
            out = in_a[select-: 8];
        end
    end
endmodule
