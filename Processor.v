`timescale 1ns / 1ps

// Instruction Register Fields
`define oper_type 	IR[31:27]
`define rdst 		IR[26:22]
`define rsrc1 		IR[21:17]
`define imm_mode 	IR[16]
`define rsrc2 		IR[15:11]
`define isrc 		IR[15:0]

// CSR Register Fields
`define fzero 		OSR[0]
`define fsign 		OSR[1]
`define fcarry 		OSR[2]
`define fovf 		OSR[3]
`define bstop 		OSR[8]
`define state 		OSR[12:10]

// Instruction Set | Arithmetic
`define movsgpr 5'b00000
`define mov 	5'b00001
`define add 	5'b00010
`define mul 	5'b00100
`define sub 	5'b00011 

// Instruction Set | Logical
`define ror 	5'b00101
`define r_and	5'b00110
`define rxor 	5'b00111
`define rxnor 	5'b01000
`define rnand 	5'b01001
`define rnor 	5'b01010
`define rnot 	5'b01011

// Instruction Set | Data read/write
`define storereg 	5'b01100
`define storedin 	5'b01101
`define sendout 	5'b01110
`define sendreg 	5'b01111

// Instruction Set | Jump Instructions
`define jump 		5'b10000
`define jc		 	5'b10001
`define jnc		 	5'b10010
`define jsign  	 	5'b10011
`define jnsign		5'b10100
`define jz		 	5'b10101
`define jnz		 	5'b10110
`define jof  	 	5'b10111
`define jnof		5'b11000
`define halt  	 	5'b11001


module top(
	input clk,sys_rst,
  	input [15:0] din,
  	output reg [15:0] dout
);

  	parameter IDLE 		= 3'b000;
    parameter FETCH 	= 3'b001;
    parameter DEC_EXEC 	= 3'b010;
    parameter ASSIGN 	= 3'b011;
    parameter STOP 		= 3'b100;
  
	reg [31:0] IR;
	reg [15:0] GPR [31:0];
	reg [15:0] SGPR;
	reg [31:0] mul_reg;
 	reg [16:0] sum_reg;
  	reg [15:0] OSR;  	
  
  reg [31:0] inst_mem [31:0];		/// MEMORY ////// 			
  reg [15:0] data_mem [31:0];
  reg [31:0] PC = 0;
  
  task decode_exec();
	begin
     ///////////// ALU Design /////////////////////
        
	case(`oper_type)
		
		`movsgpr :	begin	
          			GPR[`rdst] = 0;
					end
					
		`mov :		begin
					 if(`imm_mode)
						GPR[`rdst] = `isrc;
					 else
						GPR[`rdst] = GPR[`rsrc1];
          
					end
					
		`add :		begin
          			 if(`imm_mode) begin
                       sum_reg = GPR[`rsrc1] + `isrc;
                       GPR[`rdst] = sum_reg[15:0];
                     end
          
					 else begin
                       sum_reg = GPR[`rsrc1] + GPR[`rsrc2];
                       GPR[`rdst] = sum_reg[15:0] ;
                     end
          
					end
					
		`sub :		begin
          			if(`imm_mode) begin
						GPR[`rdst] = GPR[`rsrc1] - `isrc;
                      	
         			 end
					 else begin
						GPR[`rdst] = GPR[`rsrc1] - GPR[`rsrc2];
                       
                     end	

					end
		
		`mul :		begin
					 if(`imm_mode)
						mul_reg = GPR[`rsrc1] * `isrc;
					 else
						mul_reg = GPR[`rsrc1] * GPR[`rsrc2];
						
          			 GPR[`rdst] = mul_reg[15:0];
					 SGPR = mul_reg[31:16];
          
        			end
      
     	`ror :		begin
					 if(`imm_mode)
                       GPR[`rdst] = GPR[`rsrc1] | `isrc;
					 else
                       GPR[`rdst] = GPR[`rsrc1] | GPR[`rsrc2];
          			
					end
		
      	`r_and :	begin
					 if(`imm_mode)
                       GPR[`rdst] = GPR[`rsrc1] & `isrc;
					 else
                       GPR[`rdst] = GPR[`rsrc1] & GPR[`rsrc2];
          
					end
      
      	`rxor :		begin
					 if(`imm_mode)
                       GPR[`rdst] = GPR[`rsrc1] ^ `isrc;
					 else
                       GPR[`rdst] = GPR[`rsrc1] ^ GPR[`rsrc2];
          
					end
      
      	`rxnor :	begin
					 if(`imm_mode)
                       GPR[`rdst] = ~(GPR[`rsrc1] ^ `isrc);
					 else
                       GPR[`rdst] = ~(GPR[`rsrc1] ^ GPR[`rsrc2]);
          
					end
      
      	`rnand :	begin
					 if(`imm_mode)
                       GPR[`rdst] = ~(GPR[`rsrc1] & `isrc);
					 else
                       GPR[`rdst] = ~(GPR[`rsrc1] & GPR[`rsrc2]);
          
        			end
      
         `rxor :	begin
					 if(`imm_mode)
                       GPR[`rdst] = ~(GPR[`rsrc1] | `isrc);
					 else
                       GPR[`rdst] = ~(GPR[`rsrc1] | GPR[`rsrc2]);
           
					end
          
         `rnot :	begin
					 if(`imm_mode)
                       GPR[`rdst] = ~(`isrc);
					 else
                       GPR[`rdst] = ~(GPR[`rsrc1]);
           			
					end
				
      	 `storereg :	begin
           				data_mem[`isrc] = GPR[`rsrc1];
         				end
      
      	 `storedin : 	begin
           				data_mem[`isrc] = din;
         				end
      
         `sendout : 	begin
           				dout = data_mem[`isrc];
         				end
      	 
      	 `sendreg :		begin
           				GPR[`rdst] = data_mem[`isrc];
        				end
          ///////////////////// END of ALU Design ////////////////////
      
      	  ///////////////////// JUMP Instructions ////////////////////
      	
      	 `jump	:		begin
           				PC <= `isrc;
         				end
      
         `jc	:		begin
           				if(`fcarry)
                           PC <= `isrc;
                        else
                           `fcarry <= 0;
         				end
      
         `jnc	:		begin
           				if(`fcarry)
                           `fcarry <= 1;
                        else
                           PC <= `isrc;
           				end				
           
         `jsign	:		begin
           				if(`fsign)
                           PC <= `isrc;
                        else
                           `fsign <= 0;
      					end
      
         `jnsign	:	begin
           				if(`fsign)
                           `fsign <= 1;
                        else
                           PC <= `isrc;  
         				end
      
         `jz	:		begin
          				if(`fzero)
                           PC <= `isrc;
                        else
                           `fzero <= 0;
      					end
      
         `jnz	:		begin
           				if(`fzero)
                           `fzero <= 1;
                        else
                           PC <= `isrc;
         				end
      
         `jof	:		begin
           				if(`fovf)
                           PC <= `isrc;
                        else
                           `fovf <= 0;
      					end
      
         `jnof	:		begin
           				if(`fovf)
                           `fovf <= 1;
                        else
                           PC <= `isrc;
           				end
      
         `halt	:		begin
           				`bstop = 1'b1;
         				end
          //////////////////// END of Instruction Execution ///////////////////
           
          endcase 
          
        end
  endtask
  
  		  //////////////////// Flag assignment ////////////////////////////
  
  task assign_flags();
    begin
       
      if(`oper_type == `mul) begin
        `fsign <= SGPR[15];
        `fzero <= ~((|GPR[`rdst]) | (|SGPR));
      end
      
      else begin
        `fsign <= GPR[`rdst][15];
        `fzero <= ~(|GPR[`rdst]);
        end
      
      if(`oper_type == `add) begin  
      	`fcarry <= sum_reg[16];
          if(`imm_mode)
            `fovf = (~GPR[`rsrc1][15] & ~IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & IR[15] & ~GPR[`rdst][15]); ///// Overflow Flag ///////

          else
            `fovf = ((~GPR[`rsrc1][15]) & (~GPR[`rsrc2][15]) & GPR[`rdst][15]) | (GPR[`rsrc1][15] & GPR[`rsrc2][15] & ~(GPR[`rdst][15])); 
        end
      
      else if(`oper_type == `sub) begin
        if(`imm_mode)
          `fovf = ((~GPR[`rsrc1][15]) & `isrc[15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & ~(`isrc[15]) & ~(GPR[`rdst][15])); ///// Overflow Flag /////
      	else
          `fovf = ((~GPR[`rsrc1][15]) & `rsrc2[15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & ~(`rsrc2[15]) & ~(GPR[`rdst][15])); ///// Overflow Flag ////
      
      	end
      end
      endtask
////////////////////// END of flag assignment //////////////////////////////
      
  initial begin
    $readmemb("inst_mem.mem",inst_mem);
  end

  always @(posedge sys_rst) begin
    `state <= IDLE;
  end
  
  always@(posedge clk) begin
      
    case(`state)
      
        IDLE : 	   begin
                    IR <= 0;
                    PC <= 0;
                    `bstop <= 1'b0;
					`state = FETCH;
                   end
      
        FETCH :    begin
                   IR = inst_mem[PC];
          		   PC <= PC + 1;
          		   `state = DEC_EXEC;
                   end
  
      	DEC_EXEC :  begin
                    decode_exec();
          `state = (`bstop)? STOP:ASSIGN;
                    end
      
      	ASSIGN :	begin 
      				assign_flags();
          			`state = FETCH;
      				end
      
      	STOP 	:	begin
          			`state = STOP;
        			end
    endcase
  end
    
endmodule   