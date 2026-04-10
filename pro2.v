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

module approx1(input x0,x1,x2,x3,
               output s,c);

wire a1,a2,a3,a4;
aoi g1(x0,x3,x1,x2,a3);
nor(a1,x0,x3);
nor(a2,x1,x2);
oai g2(a1,a2,~a1,~a2,a4);
nor(c,a1,a2);
nand(s,a3,a4);
endmodule
