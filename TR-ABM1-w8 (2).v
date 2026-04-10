`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 05:43:58 PM
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

module fa(x,y,cin,sum,co);
output sum,co;
input x,y,cin;
wire w1,w2,w3;
xor g1(w1,x,y);
and g2(w2,cin,w1);
and g3(w3,x,y);
xor g4(sum,w1,cin);
or g5(co,w3,w2);
endmodule

module ha(a,b,s,c);
output s,c;
input a,b;
xor X1(s,a,b);
and A1(c,a,b);
endmodule

module four_two_acc (input x1,x2,x3,x4,cin,  output s,c1,c2);
 wire s1;
fa g1(x1,x2,x3,s1,c2);
fa g2(s1,x4,cin,s,c1);
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

module booth_mul_NN(input [7:0] x,y,output [15:0] z);
wire [3:0] neg;

wire [8:0] p0,p1,p2,p3;

neg_gen g1(x[1],x[0],1'b0,neg[0]);
neg_gen g2(x[3],x[2],x[1],neg[1]);
neg_gen g3(x[5],x[4],x[3],neg[2]);
neg_gen g4(x[7],x[6],x[5],neg[3]);


pp_gen_0 u1(x[1],x[0],1'b0,y[0],p0[0]);
pp_gen_0 u2(x[3],x[2],x[1],y[0],p1[0]);
pp_gen_0 u3(x[5],x[4],x[3],y[0],p2[0]);
pp_gen_0 u4(x[7],x[6],x[5],y[0],p3[0]);


genvar i;
generate
for (i=1;i<8;i=i+1) begin
generate_pp Ma2(p0[i],y[i],y[i-1],x[1],x[0],1'b0);
generate_pp Ma11(p1[i],y[i],y[i-1],x[3],x[2],x[1]);
generate_pp Ma20(p2[i],y[i],y[i-1],x[5],x[4],x[3]);
generate_pp Ma29(p3[i],y[i],y[i-1],x[7],x[6],x[5]);
end   
endgenerate

pp_gen_8 u9(x[1],x[0],1'b0,y[7],p0[8]);
pp_gen_8 u10(x[3],x[2],x[1],y[7],p1[8]);
pp_gen_8 u11(x[5],x[4],x[3],y[7],p2[8]);
pp_gen_8 u12(x[7],x[6],x[5],y[7],p3[8]);

fa k1(p0[2],p1[0],neg[1],s1,c1);
ha k2(p0[3],p1[1],s2,c2);
fa k3(p0[4],p1[2],p2[0],s3,c3);
fa k4(p0[5],p1[3],p2[1],s4,c4);

four_two_acc k5(p0[6],p1[4],p2[2],p3[0],neg[3],s5,ca5,cb5);
four_two_acc k6(p0[7],p1[5],p2[3],p3[1],cb5,s6,ca6,cb6);
four_two_acc k7(p0[8],p1[6],p2[4],p3[2],cb6,s7,ca7,cb7);
four_two_acc k8(p0[8],p1[7],p2[5],p3[3],cb7,s8,ca8,cb8);
four_two_acc k9(~p0[8],~p1[8],p2[6],p3[4],cb8,s9,ca9,cb9);
four_two_acc k10(1'b1,p2[7],p3[5],cb9,1'b0,s10,ca10,cb10);
fa  k11(~p2[8],p3[6],cb10,s11,c11);
ha k12(1'b1,p3[7],s12,c12);

ha k13(p0[0],neg[0],s13,c13);
ha k14(c1,s2,s14,c14);
fa k15(c2,s3,neg[2],s15,c15);
ha k16(c3,s4,s16,c16);
ha k17(c4,s5,s17,c17);
ha k18(ca5,s6,s18,c18);
ha k19(ca6,s7,s19,c19);
ha k20(ca7,s8,s20,c20);
ha k21(ca8,s9,s21,c21);
ha k22(ca9,s10,s22,c22);
ha k23(ca10,s11,s23,c23);
ha k24(c11,s12,s24,c24);
ha k25(c12,~p3[8],s25,c25);

assign z = {1'b1,s25,s24,s23,s22,s21,s20,s19,s18,s17,s16,s15,s14,s1,c13,s13} + {c25,c24,c23,c22,c21,c20,c19,c18,c17,c16,c15,c14,1'b0,1'b0,p0[1],1'b0} ;

endmodule
module trunc_BM #(parameter k_in = 8,n_in = 16,m_in = 16)(a, b, r);

input [n_in-1:0] a;
input [m_in-1:0] b;
output [(n_in+m_in)-1:0] r;

wire [$clog2(n_in)-1:0] k1;
wire [$clog2(m_in)-1:0] k2;
wire [k_in-3:0] m,n;
wire [n_in-1:0] l1;
wire [m_in-1:0] l2;
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

booth_mul_NN  h1(.x(mm),.y(nn),.z(tmp));
assign sum=p+q;

Barrel_Shifter_k_mn #(k_in, n_in, m_in) u7(.in_a(tmp), .count(sum), .out_a(r));

endmodule

//--------------------------------
module Barrel_Shifter_k_mn #(parameter k_in = 6,n_in = 16,m_in = 16)(in_a, count, out_a);
input [$clog2(m_in):0]count;
input [(k_in*2)-1:0]in_a;
output [(n_in+m_in)-1:0]out_a;


wire [(n_in + m_in)-1:0] tmp;
assign tmp = {{((n_in + m_in)-(k_in*2)){in_a[15]}}, in_a};
assign out_a=(tmp<<count);

endmodule

//--------------------------------
/*
module Mux_16_3_k #(parameter k_in = 6,n_in = 16)(in_a, select, out);
input [$clog2(n_in)-1:0]select;
input [n_in-1:0]in_a;
output reg [k_in-3:0]out;


integer i;
always @(*) begin
    out = 0;
    for (i = k_in;i<(n_in);i=i+1) begin :mux_gen_block
        if (select == i[$clog2(n_in)-1:0])
            out = in_a[i-: k_in-2];
    end
end

endmodule
*/

module Mux_16_3_k #(parameter k_in = 6, n_in = 16)(in_a, select, out);
    input [$clog2(n_in)-1:0] select;
    input [n_in-1:0] in_a;
    output reg [k_in-3:0] out;

    always @(*) begin
        if (select < 7) begin
            out = in_a[5: 0];
        end else begin
            out = in_a[select-: 6];
        end
    end
endmodule
