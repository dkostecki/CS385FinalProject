/*
By: Daniel Kostecki, Sonia Leonato, Thi Nguyen
Class: CS 385
Progress Report 1
*/

//16-bit register
module reg_file (rr1,rr2,wr,wd,regwrite,rd1,rd2,clock);

   input [1:0] rr1,rr2,wr;
   input [15:0] wd;
   input regwrite,clock;
   output [15:0] rd1,rd2;

// registers
   register r1 (wd,c1,q1),
		    r2 (wd,c2,q2),
            r3 (wd,c3,q3);

// output port
   mux4x16 mux1(16'b0,q1,q2,q3,rr1,rd1),
           mux2(16'b0,q1,q2,q3,rr2,rd2);

// input port
   decoder dec(wr[1],wr[0],w3,w2,w1,w0);

   and a (regwrite_and_clock,regwrite,clock);

   and a1 (c1,regwrite_and_clock,w1),
       a2 (c2,regwrite_and_clock,w2),
       a3 (c3,regwrite_and_clock,w3);

endmodule


// The register (16-bit D-flip flop)
module register(D,CLK,Q);
   input [15:0]D;
   input CLK;
   output [15:0]Q;
   
   D_flip_flop d1(D[0],CLK,Q[0]),
			   d2(D[1],CLK,Q[1]),
			   d3(D[2],CLK,Q[2]),
			   d4(D[3],CLK,Q[3]),
			   d5(D[4],CLK,Q[4]),
			   d6(D[5],CLK,Q[5]),
			   d7(D[6],CLK,Q[6]),
			   d8(D[7],CLK,Q[7]),
			   d9(D[8],CLK,Q[8]),
			   d10(D[9],CLK,Q[9]),
			   d11(D[10],CLK,Q[10]),
			   d12(D[11],CLK,Q[11]),
			   d13(D[12],CLK,Q[12]),
			   d14(D[13],CLK,Q[13]),
			   d15(D[14],CLK,Q[14]),
			   d16(D[15],CLK,Q[15]);
endmodule 

module D_flip_flop(D,CLK,Q);
   input D,CLK; 
   output Q; 
   wire CLK1, Y;
   not  not1 (CLK1,CLK);
   D_latch D1(D,CLK, Y),
           D2(Y,CLK1,Q);
endmodule 

module D_latch(D,C,Q);
   input D,C; 
   output Q;
   wire x,y,D1,Q1; 
   nand nand1 (x,D, C), 
        nand2 (y,D1,C), 
        nand3 (Q,x,Q1),
        nand4 (Q1,y,Q); 
   not  not1  (D1,D);
endmodule 

//Multiplexers
module mux4x1(i0,i1,i2,i3,select,y); 
   input i0,i1,i2,i3; 
   input [1:0] select; 
   output y;
   wire a,b,c,d;
   wire [1:0] nS;
   
   not	pS0(nS[0], select[0]),
		pS1(nS[1], select[1]); 
   
   and 		a0(a,i0,nS[1],nS[0]),
			a1(b,i1, select[1],nS[0]),
			a2(c,i2, select[1],nS[0]),
			a3(d,i3, select[1], select[0]);
			
	or		o0(y,a,b,c,d);
endmodule

module mux4x16(i0,i1,i2,i3,select,y);
  input [15:0] i0,i1,i2,i3;
  input [1:0] select;
  output [15:0] y;

  mux4x1 m1(i0[0], i1[0], i2[0], i3[0], select,y[0]),
		 m2(i0[1], i1[1], i2[1], i3[1], select,y[1]),
		 m3(i0[2], i1[2], i2[2], i3[2], select,y[2]),
		 m4(i0[3], i1[3], i2[3], i3[3], select,y[3]),
		 m5(i0[4], i1[4], i2[4], i3[4], select,y[4]),
		 m6(i0[5], i1[5], i2[5], i3[5], select,y[5]),
		 m7(i0[6], i1[6], i2[6], i3[6], select,y[6]),
		 m8(i0[7], i1[7], i2[7], i3[7], select,y[7]),
		 m9(i0[8], i1[8], i2[8], i3[8], select,y[8]),
		 m10(i0[9], i1[9], i2[9], i3[9], select,y[9]),
		 m11(i0[10],i1[10],i2[10],i3[10],select,y[10],
		 m12(i0[11],i1[11],i2[11],i3[11],select,y[11]),
		 m13(i0[12],i1[12],i2[12],i3[12],select,y[12]),
		 m14(i0[13],i1[13],i2[13],i3[13],select,y[13]),
		 m15(i0[14],i1[14],i2[14],i3[14],select,y[14]),
		 m16(i0[15],i1[15],i2[15],i3[15],select,y[15]);
endmodule

module decoder (S1,S0,D3,D2,D1,D0); 
   input S0,S1; 
   output D0,D1,D2,D3; 
 
   not n1 (notS0,S0),
       n2 (notS1,S1);

   and a0 (D0,notS1,notS0), 
       a1 (D1,notS1,   S0), 
       a2 (D2,   S1,notS0), 
       a3 (D3,   S1,   S0); 
endmodule 

// 16-bit ALU
module ALU (op,a,b,result,zero);
   input [15:0] a;
   input [15:0] b;
   input [2:0] op;
   output [15:0] result;
   output zero;
   wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16;
	
   ALU1   a0  (a[0], b[0], op[2], op[1:0],set,op[2],c1, result[0]),
		  a1  (a[1], b[1], op[2], op[1:0],0,  c1,   c2, result[1]),
		  a2  (a[2], b[2], op[2], op[1:0],0,  c2,   c3, result[2]),
		  a3  (a[3], b[3], op[2], op[1:0],0,  c3,   c4, result[3]),
		  a4  (a[4], b[4], op[2], op[1:0],0,  c4,   c5, result[4]),
		  a5  (a[5], b[5], op[2], op[1:0],0,  c5,   c6, result[5]),
		  a6  (a[6], b[6], op[2], op[1:0],0,  c6,   c7, result[6]),
		  a7  (a[7], b[7], op[2], op[1:0],0,  c7,   c8, result[7]),
		  a8  (a[8], b[8], op[2], op[1:0],0,  c8,   c9, result[8]),
		  a9  (a[9], b[9], op[2], op[1:0],0,  c9,   c10,result[9]),
		  a10 (a[10],b[10],op[2], op[1:0],0,  c10,  c11,result[10]),
		  a11 (a[11],b[11],op[2], op[1:0],0,  c11,  c12,result[11]),
		  a12 (a[12],b[12],op[2], op[1:0],0,  c12,  c13,result[12]),
		  a13 (a[13],b[13],op[2], op[1:0],0,  c13,  c14,result[13]),
		  a14 (a[14],b[14],op[2], op[1:0],0,  c14,  c15,result[14]),
   ALUmsb a15 (a[15],b[15],op[2], op[1:0],0,  c15,  c16,result[15],set);

   or o1(or01, result[0],result[1]),
	  o2(or23, result[2],result[3]);
   nor nor1(zero,or01,or23);
endmodule

// 1-bit ALU (used for bits 0-14)
module ALU1 (a,b,binvert,op,less,carryin,carryout,result);
   input a,b,less,carryin,binvert;
   input [1:0] op;
   output carryout,result;
   wire sum, a_and_b, a_or_b, b_inv;
	
   not not1(b_inv, b);
   mux2x1 mux1(b,b_inv,binvert,b1);
   and and1(a_and_b, a, b);
   or or1(a_or_b, a, b);
   fulladder adder1(sum,carryout,a,b1,carryin);
   mux4x1 mux2(a_and_b,a_or_b,sum,less,op[1:0],result); 
endmodule

// 1-bit ALU (used for the rest)
module ALUmsb (a,b,binvert,op,less,carryin,carryout,result,sum);
   input a,b,less,carryin,binvert;
   input [1:0] op;
   output carryout,result,sum;
   wire sum, a_and_b, a_or_b, b_inv;
	
   not not1(b_inv, b);
   mux2x1 mux1(b,b_inv,binvert,b1);
   and and1(a_and_b, a, b);
   or or1(a_or_b, a, b);
   fulladder adder1(sum,carryout,a,b1,carryin);
   mux4x1 mux2(a_and_b,a_or_b,sum,less,op[1:0],result); 
endmodule

// Arithmetic 
module halfadder (S,C,x,y); 
   input x,y; 
   output S,C; 

   xor (S,x,y); 
   and (C,x,y); 
endmodule 

module fulladder (S,C,x,y,z); 
   input x,y,z; 
   output S,C; 
   wire S1,D1,D2;

   halfadder HA1 (S1,D1,x,y), 
             HA2 (S,D2,S1,z); 
   or g1(C,D2,D1); 
endmodule 

//Control Signal
module MainControl (op,control); 
//Control is in the format of: RegDst,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,ALUOp
  input [3:0] op;
  output reg [7:0] control;

  always @(op) case (op)
	//R-types
    4'b0000: control <= 8'b10010010; // add
    4'b0001: control <= 8'b10010010; // sub
    4'b0010: control <= 8'b10010010; // and
    4'b0011: control <= 8'b10010010; // or
    4'b0111: control <= 8'b10010010; // slt
	
	//I-type
    4'b0100: control <= 8'b01010000; // ADDI
endcase
		
		
// To test
module testing ();

 reg [1:0] rr1,rr2,wr;
 reg wd;
 reg regwrite, clock;
 wire rd1,rd2;

 reg_file regs (rr1,rr2,wr,wd,regwrite,rd1,rd2,clock);

 initial 
   begin  

     #10 regwrite=1; //enable writing

     #10 wd=0;       // set write data

     #10      rr1=0;rr2=0;clock=0;
     #10 wr=1;rr1=1;rr2=1;clock=1;
     #10                  clock=0;
     #10 wr=2;rr1=2;rr2=2;clock=1;
     #10                  clock=0;
     #10 wr=3;rr1=3;rr2=3;clock=1;
     #10                  clock=0;

     #10 regwrite=0; //disable writing

     #10 wd=1;       // set write data

     #10 wr=1;rr1=1;rr2=1;clock=1;
     #10                  clock=0;
     #10 wr=2;rr1=2;rr2=2;clock=1;
     #10                  clock=0;
     #10 wr=3;rr1=3;rr2=3;clock=1;
     #10                  clock=0;

     #10 regwrite=1; //enable writing

     #10 wd=1;       // set write data

     #10 wr=1;rr1=1;rr2=1;clock=1;
     #10                  clock=0;
     #10 wr=2;rr1=2;rr2=2;clock=1;
     #10                  clock=0;
     #10 wr=3;rr1=3;rr2=3;clock=1;
     #10                  clock=0;

   end 

 initial
   $monitor ("regwrite=%d clock=%d rr1=%d rr2=%d wr=%d wd=%d rd1=%d rd2=%d",regwrite,clock,rr1,rr2,wr,wd,rd1,rd2);
 
endmodule 


/* Test results

C:\Verilog>iverilog -o t regfile.vl

C:\Verilog>vvp t
regwrite=x clock=x rr1=x rr2=x wr=x wd=x rd1=x rd2=x
regwrite=1 clock=x rr1=x rr2=x wr=x wd=x rd1=x rd2=x
regwrite=1 clock=x rr1=x rr2=x wr=x wd=0 rd1=x rd2=x
regwrite=1 clock=0 rr1=0 rr2=0 wr=x wd=0 rd1=0 rd2=0
regwrite=1 clock=1 rr1=1 rr2=1 wr=1 wd=0 rd1=x rd2=x
regwrite=1 clock=0 rr1=1 rr2=1 wr=1 wd=0 rd1=0 rd2=0
regwrite=1 clock=1 rr1=2 rr2=2 wr=2 wd=0 rd1=x rd2=x
regwrite=1 clock=0 rr1=2 rr2=2 wr=2 wd=0 rd1=0 rd2=0
regwrite=1 clock=1 rr1=3 rr2=3 wr=3 wd=0 rd1=x rd2=x
regwrite=1 clock=0 rr1=3 rr2=3 wr=3 wd=0 rd1=0 rd2=0
regwrite=0 clock=0 rr1=3 rr2=3 wr=3 wd=0 rd1=0 rd2=0
regwrite=0 clock=0 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=0 clock=1 rr1=1 rr2=1 wr=1 wd=1 rd1=0 rd2=0
regwrite=0 clock=0 rr1=1 rr2=1 wr=1 wd=1 rd1=0 rd2=0
regwrite=0 clock=1 rr1=2 rr2=2 wr=2 wd=1 rd1=0 rd2=0
regwrite=0 clock=0 rr1=2 rr2=2 wr=2 wd=1 rd1=0 rd2=0
regwrite=0 clock=1 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=0 clock=0 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=1 clock=0 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=1 clock=1 rr1=1 rr2=1 wr=1 wd=1 rd1=0 rd2=0
regwrite=1 clock=0 rr1=1 rr2=1 wr=1 wd=1 rd1=1 rd2=1
regwrite=1 clock=1 rr1=2 rr2=2 wr=2 wd=1 rd1=0 rd2=0
regwrite=1 clock=0 rr1=2 rr2=2 wr=2 wd=1 rd1=1 rd2=1
regwrite=1 clock=1 rr1=3 rr2=3 wr=3 wd=1 rd1=0 rd2=0
regwrite=1 clock=0 rr1=3 rr2=3 wr=3 wd=1 rd1=1 rd2=1

*/


