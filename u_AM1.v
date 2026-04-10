

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2023 08:40:19 AM
// Design Name: 
// Module Name: wallace
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

module  half_adder (input a,b,
                    output s,c); 
                    
assign s = a^b;
assign c = a&b;
endmodule                      

module full_adder(input a, b, cin, 
                   output S, Cout);
  assign S = a ^ b ^ cin;
  assign Cout = (a & b) | (b & cin) | (a & cin);
endmodule

module four_two_accurate (input x0,x1,x2,x3,cin,
                          output s,c,cout);
                          

wire s1;

full_adder f1(x0,x1,x2,s1,cout);
full_adder f2(x3,s1,cin,s,c);
endmodule 

module oai(input a,b,c,d,
           output y);
wire w1,w2;           
or(w1,a,b);
or(w2,c,d);
nand(y,w1,w2);
endmodule           

module aoi(input a,b,c,d,
           output y);

wire w1,w2;
and(w1,a,b);
and(w2,c,d);
nor(y,w1,w2);
endmodule

module ao22(input a,b,c,d,
            output y );
wire w1,w2,abar,dbar;
not(abar,a);
not(dbar,d);
and(w1,abar,b);
and(w2,c,dbar);
or(y,w1,w2);
endmodule

module aoi22(input a,b,c,d,
             output y);

wire w1,w2,w3;
and(w1,a,b);
and(w2,c,d);  
or(w3,w1,w2);
not(y,w3);           
endmodule             


module approx_four_two(input x0,x1,x2,x3,
               output s,c);
wire a1,a2,a3,a4;
oai g3(x0,x1,x2,x3,a1);
aoi g1(x0,x1,x2,x3,a2);
oai g2(x0,x1,~x0,~x1,a3);
oai g4(x2,x3,~x2,~x3,a4);
aoi g5(a3,a4,~a3,~a4,s);
nand(c,a1,a2);
endmodule


module wallace_approx1(A,B,prod);
    
    //inputs and outputs
    input [7:0] A,B;
    output [15:0] prod;
    //internal variables.
  
    wire [7:0] p0,p1,p2,p3,p4,p5,p6,p7;

//initialize the p's.
    assign  p0 = A & {8{B[0]}};
    assign  p1 = A & {8{B[1]}};
    assign  p2 = A & {8{B[2]}};
    assign  p3 = A & {8{B[3]}};
    assign  p4 = A & {8{B[4]}};
    assign  p5 = A & {8{B[5]}};
    assign  p6 = A & {8{B[6]}};
    assign  p7 = A & {8{B[7]}};


wire s1,c1,s2,c2,s3,c3,s4,c4,s5,c5,s6,c6,s7,c7,cout7,s8,c8,s9,c9,cout9,s10,c10,s11,c11,cout11,s12,c12;
//first stage
    or(s1,p0[4],p1[3]);
    approx_four_two g2(p0[5],p1[4],p2[3],p3[2],s2,c2);
    approx_four_two g3(p0[6],p1[5],p2[4],p3[3],s3,c3);
    half_adder g4(p4[2],p5[1],s4,c4);
    approx_four_two g5 (p0[7],p1[6],p2[5],p3[4],s5,c5);
    approx_four_two g6 (p4[3],p5[2],p6[1],p7[0],s6,c6);
    four_two_accurate g7 (p1[7],p2[6],p3[5],p4[4],p5[3],s7,c7,cout7);
    half_adder g8 (p6[2],p7[1],s8,c8);
    four_two_accurate g9 (p2[7],p3[6],p4[5],p5[4],cout7,s9,c9,cout9);
    half_adder g10(p6[3],p7[2],s10,c10);
    four_two_accurate g11(p3[7],p4[6],p5[5],p6[4],cout9,s11,c11,cout11);
    full_adder g12(p4[7],p5[6],p6[5],s12,c12);
    

//second stage
wire s13,c13,s14,c14,s15,c15,s16,c16,s17,c17,s18,c18,s19,c19,cout19,s20,c20,cout20,s21,c21,cout21,s22,c22,cout22,s23,c23,cout23,s24,c24;

    or(s13,p0[2],p1[1]);
    half_adder oo1(s13,p2[0],prod[2],cc);
    approx_four_two g14(p0[3],p1[2],p2[1],p3[0],s14,c14);
    half_adder oo2(s14,cc,prod[3],cx1);
    half_adder oo3(s1,p2[2],sx2,cx2);
    approx_four_two g15(sx2,c14,p3[1],p4[0],s15,c15);
    approx_four_two g16(s2,cx2,p4[1],p5[0],s16,c16);
    approx_four_two g17(s3,s4,c2,p6[0],s17,c17);
    approx_four_two g18(s5,s6,c3,c4,s18,c18);
    four_two_accurate g19(s7,s8,c5,c6,1'b0,s19,c19,cout19);
    four_two_accurate g20(s9,s10,c7,c8,cout19,s20,c20,cout20);
    four_two_accurate g21(s11,p7[3],c9,c10,cout20,s21,c21,cout21);
    four_two_accurate g22(s12,c11,cout11,p7[4],cout21,s22,c22,cout22);
    four_two_accurate g23(p5[7],p6[6],p7[5],c12,cout22,s23,c23,cout23);
    full_adder g24(p6[7],p7[6],cout23,s24,c24);
    
 //final stage
assign prod[0]= p0[0];

assign prod[1] = p0[1]|p1[0];

assign  prod[15:4] = {p7[7],s24,s23,s22,s21,s20,s19,s18,s17,s16,s15}+{c24,c23,c22,c21,c20,c19,c18,c17,c16,c15,cx1};   

endmodule