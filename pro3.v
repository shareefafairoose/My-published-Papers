`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2023 08:22:21 AM
// Design Name: 
// Module Name: approx1
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
module oai(input a,b,c,d,
           output y);
wire w1,w2;           
or oa1(w1,a,b);
or oa2(w2,c,d);
nand oa3(y,w1,w2);
endmodule           


module approx1(input x0,x1,x2,x3,
               output s,c);

wire a1,a2,a3,a4,a5;

nand oa4(a1,x0,x2);
nor oa5(a2,x0,x2);
nor oa6(a3,x1,x3);
nor oa7(a4,a2,a3);
oai ga2(a2,a3,~a2,~a3,a5);
nand oa8(c,a1,~a4);
nand oa9(s,a5,a1);
endmodule
