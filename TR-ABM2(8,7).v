`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 09:07:23 PM
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


module pp_gen_approx(output pp, input a1,b2,b1,b0 ); //encoder3
    
wire w1,w2,w3,w4,w5,w6,w7,w8,w9;

nor g1(w1,~a1,b2);
nor g2(w2,b1,b0);
nor g3(w3,~b2,a1);
nand ga(w4,b1,b0);
nand g4(w6,w4,w3);
nand g5(w5,w1,~w2);
nand g6(pp,w5,w6);

endmodule

module approx_4_2(output s,c,  input a1,a2,a3,a4);
wire w1,w2;

nor g1(w1,a1,a2);
nor g2(w2,a3,a4);
nor g3(c,w1,w2);
nand g4(s,w1,w2);

endmodule


module mux2 (input y7,b2,b1,b0,
            output pp);

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

module pp_gen (input b2,b1,b0,a1,a0, output pp);

wire w1,w2,w3,w4,w5,w6,w7,w8,w9;

nand g1(w1,a0,b1,b0);
xor g2(w2,b1,b0);
nor g3(w3,a0,b1,b0);
nand ga(w4,w2,a1);
nand g4(w5,w2,~a1);
nand g5(w6,w1,w4);
nand g6(w7,~w3,w5);
nand g7(w8,~b2,w6);
nand g8(w9,w7,b2);
nand g9(pp,w9,w8);
endmodule

module approx_booth_mul(input signed [7:0]a,
                 input signed [7:0]x1,
               // input clk,
                 output signed [15:0] result);

wire [3:0] neg;


neg_gen gd1(a[1],a[0],1'b0,neg[0]);
neg_gen gd2(a[3],a[2],a[1],neg[1]);
neg_gen gd3(a[5],a[4],a[3],neg[2]);
neg_gen gd4(a[7],a[6],a[5],neg[3]);


wire [8:0] ppa0,ppa1,ppa2,ppa3; 
wire w1,w2,w3,w4;
  
pp_gen_approx ae1(ppa0[0], x1[0],a[1],a[0],1'b0); 
pp_gen_approx Ma10(ppa1[0],x1[0],a[3],a[2],a[1]);
pp_gen_approx Ma19(ppa2[0],x1[0],a[5],a[4],a[3]);
pp_gen_approx Ma28(ppa3[0],x1[0],a[7],a[6],a[5]);

genvar b;
generate for (b=1;b<8;b=b+1) begin
pp_gen_approx Mva2(ppa0[b],x1[b],a[1],a[0],1'b0);
end
endgenerate
/*
genvar p;
generate for(p=7;p<8;p=p+1) begin
pp_gen Ma11(a[1],a[0],1'b0,x1[p],x1[p-1],ppa0[p]);
end
endgenerate 
*/
genvar d;
generate for (d=1;d<6;d=d+1) begin
pp_gen_approx Mda2(ppa1[d],x1[d],a[3],a[2],a[1]);
end
endgenerate

genvar f;
generate for(f=6;f<8;f=f+1) begin
pp_gen Ma11(a[3],a[2],a[1],x1[f],x1[f-1],ppa1[f]);
end
endgenerate

genvar g;
generate for (g=1;g<4;g=g+1) begin
pp_gen_approx Mda2(ppa2[g],x1[g],a[5],a[4],a[3]);
end
endgenerate

genvar h;
generate for(f=4;f<8;f=f+1) begin
pp_gen Ma20(a[5],a[4],a[3],x1[f],x1[f-1],ppa2[f]);
end
endgenerate

genvar j;
generate for (j=1;j<2;j=j+1) begin
pp_gen_approx Mda2(ppa3[j],x1[j],a[7],a[6],a[5]);
end
endgenerate  

genvar k;
generate for(k=2;k<8;k=k+1) begin
pp_gen Ma29(a[7],a[6],a[5],x1[k],x1[k-1],ppa3[k]);
end
endgenerate

mux2 Ma9(x1[7],a[1],a[0],1'b0,ppa0[8]);
mux2 Ma18(x1[7],a[3],a[2],a[1],ppa1[8]);
mux2 Ma27(x1[7],a[5],a[4],a[3],ppa2[8]);
mux2 Ma36(x1[7],a[7],a[6],a[5],ppa3[8]);

wire [15:0] result1;

assign result[0] = ppa0[0]|neg[0];
assign result[1] = ppa0[1];

assign w2 = ppa1[0]|neg[1];
assign w3 = ppa2[0]|neg[2];
assign w4 = ppa3[0]|neg[3];

wire c1,s2,c2,s3,c3,s4,c4,s5,c5,s6,ca6,cb6,s7,c7,s8,ca8,cb8,s9,ca9,cb9,s10,ca10,cb10,s11,c11,s12,c12;

ha g1(result[2],c1,ppa0[2],w2);
ha g2(s2,c2,ppa0[3],ppa1[1]);
fa g3(s3,c3,ppa0[4],ppa1[2],w3);
fa g4(s4,c4,ppa0[5],ppa1[3],ppa2[1]);
approx_4_2 g5(s5,c5,ppa0[6],ppa1[4],ppa2[2],w4);
approx_4_2 g6(s6,c6,ppa0[7],ppa1[5],ppa2[3],ppa3[1]);
approx_4_2 g7(s7,c7,ppa0[8],ppa1[6],ppa2[4],ppa3[2]);
approx_4_2 g8(s8,c8,ppa0[8],ppa1[7],ppa2[5],ppa3[3]);
four_two_acc g9(s9,ca9,cb9,~ppa0[8],~ppa1[8],ppa2[6],ppa3[4],1'b0);
four_two_acc g10(s10,ca10,cb10,1'b1,ppa2[7],ppa3[5],cb9,1'b0);
fa g11(s11,c11,~ppa2[8],ppa3[6],cb10);
ha g12(s12,c12,1'b1,ppa3[7]);


assign result[15:3] = {1'b1,c12,c11,ca10,ca9,c8,c7,c6,c5,c4,c3,c2,c1} + {1'b0,~ppa3[8],s12,s11,s10,s9,s8,s7,s6,s5,s4,s3,s2};

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

approx_booth_mul  h1(.a(mm),.x1(nn),.result(tmp));
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
