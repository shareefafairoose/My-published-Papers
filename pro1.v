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
nand na1(y,w1,w2);
endmodule           

module aoi(input a,b,c,d,
           output y);

wire w1,w2;
and aa1(w1,a,b);
and aa2(w2,c,d);
nor aa3(y,w1,w2);
endmodule

module approx1(input x0,x1,x2,x3,
               output s,c);

wire a1,a2,a3,a4;
oai g3(x0,x1,x2,x3,a1);
aoi g1(x0,x1,x2,x3,a2);
oai g2(x0,x1,~x0,~x1,a3);
oai g4(x2,x3,~x2,~x3,a4);
aoi g5(a3,a4,~a3,~a4,s);
nand(c,a1,a2);

endmodule
