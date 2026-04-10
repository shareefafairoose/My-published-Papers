`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 08:57:09 PM
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

module four_two_acc(output s,c1,c2, input a1,a2,a3,cin);

wire s1;
/*xor g1(w1,a1,a2);
and g2(w2,a3,w1);
and g3(w3,a1,a2);
xor g4(s1,w1,a3);
or g5(c2,w3,w2);

xor g6(w4,s1,a4);
and g7(w5,cin,w4);
and g8(w6,s1,a4);
xor g9(s,w4,cin);
or g10(c1,w6,w5);*/

fa k1(s1,c2,a1,a2,a3);
ha k2(s,c1,s1,cin);
endmodule

module booth_mul_NN(input [5:0] x,y,output [11:0] z);
wire [2:0] neg;

wire [6:0] p0,p1,p2;

neg_gen g1(x[1],x[0],1'b0,neg[0]);
neg_gen g2(x[3],x[2],x[1],neg[1]);
neg_gen g3(x[5],x[4],x[3],neg[2]);


pp_gen_0 u1(x[1],x[0],1'b0,y[0],p0[0]);
pp_gen_0 u2(x[3],x[2],x[1],y[0],p1[0]);
pp_gen_0 u3(x[5],x[4],x[3],y[0],p2[0]);


genvar i;
generate
for (i=1;i<6;i=i+1) begin
generate_pp Ma2(p0[i],y[i],y[i-1],x[1],x[0],1'b0);
generate_pp Ma11(p1[i],y[i],y[i-1],x[3],x[2],x[1]);
generate_pp Ma20(p2[i],y[i],y[i-1],x[5],x[4],x[3]);
end   
endgenerate

pp_gen_8 u9(x[1],x[0],1'b0,y[5],p0[6]);
pp_gen_8 u10(x[3],x[2],x[1],y[5],p1[6]);
pp_gen_8 u11(x[5],x[4],x[3],y[5],p2[6]);

ha k1(s1,c1,p0[2],p1[0]);
ha k2(s2,c2,p0[3],p1[1]);
four_two_acc k3(s3,ca3,cb3,p0[4],p1[2],p2[0],neg[2]);
four_two_acc k4(s4,ca4,cb4,p0[5],p1[3],p2[1],cb3);
four_two_acc k5(s5,ca5,cb5,p0[6],p1[4],p2[2],cb4);
four_two_acc k6(s6,ca6,cb6,p0[6],p1[5],p2[3],cb5);
four_two_acc k7(s7,ca7,cb7,~p0[6],~p1[6],p2[4],cb6);
fa  k8(s8,c8,1'b1,p2[5],cb7);

assign z = {1'b1,~p2[6],s8,s7,s6,s5,s4,s3,s2,s1,p0[1],p0[0]} + {1'b0,c8,ca7,ca6,ca5,ca4,ca3,c2,c1,neg[1],1'b0,neg[0]} ;

endmodule
module trunc_BM #(parameter k_in = 6,n_in = 16,m_in = 16)(a, b, r);

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
module Barrel_Shifter_k_mn #(parameter k_in = 6,n_in = 16,m_in = 16)(in_a, count, out_a);
input [$clog2(m_in):0]count;
input [(k_in*2)-1:0]in_a;
output [(n_in+m_in)-1:0]out_a;


wire [(n_in + m_in)-1:0] tmp;
assign tmp = {{((n_in + m_in)-(k_in*2)){in_a[(k_in*2)-1]}}, in_a};
assign out_a=(tmp<<(count));

endmodule


module Mux_16_3_k #(parameter k_in = 6, n_in = 16)(in_a, select, out);
    input [$clog2(n_in)-1:0] select;
    input [n_in-1:0] in_a;
    output reg [k_in-3:0] out;

    always @(*) begin
        if (select < 5) begin
            out = in_a[5: 0];
        end else begin
            out = in_a[select-: 4];
        end
    end
endmodule
