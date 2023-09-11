<a name="br1"></a> 

General Processor Architecture

1

Registers and Memory

1\.1

General Purpose Registers (GPR[x]) :- There are 32 GPRs ,each of 16 bit

in size. The registers are acronymed as Rx (where x ranges from 0 - 31 eg:

R0,R11..R29).

1\.2

1\.3

Program Counter (PC) :- The program counter is a 32-bit register which

stores the address of the next instruction to be executed.

Instruction Register (IR[x]) :- The Instruction Register is a 32-bit

register which fetches the instruction from the instruction memory. The

address of the instruction to be fetched is pointed by the PC.

1\.4

Instruction Memory (inst\_mem[x]) : The processor uses Hardvard

Architecture which employs dedicated memory for data and program. A total

of 32 instructions each of 32-bit size can be stored at a time in the memory.



<a name="br2"></a> 

1\.5

Data Memory (data\_mem[x]): Data memory acts as a interlink between the

GPRs and the I/O buffer. Any data which needs to be stored in the GPRs via

I/O pins or vice versa is required to be first stored in the data memory. There

are a total of 32 (16-bit) memory locations available within the CPU.

1\.6

1\.7

Special General Purpose Register (SGPR) : This is a special purpose

register which stores the MSB 16-bits result of the multiplication operation.

Operation Status Register (OSR[15:0]) : The OSR consists of flag and state

variables which store values of some parameters after an operation is

performed.

1\.7.1 Zero Flag (OSR[0]) : Zero flag is raised if the destination register

results in a zero value (0x0000).

1\.7.2 Sign Flag (OSR[1]) : Indicates whether the sign bit (MSB) of a

resultant value is set or not. Sign bit is set to 1 for a negative value and set to 0

otherwise.

1\.7.3 Carry Flag (OSR[2]) : The carry flag is set if there arises a carry as a

result of addition of two numbers.

1\.7.4 Overflow Flag (OSR[3]) : If there is an overflow condition as a result

of performing an addition or subtraction, the overflow flag is raised.

1\.7.5 Stop Flag (OSR[8]) : The stop flag is raised when the processor ‘halt’

command is executed.

1\.7.6 FSM State (OSR[12:10]) : The state/cycle of the machine can be

determined by FSM state bits. ‘000 - IDLE’ , ‘001 - FETCH’ , ‘010 -

DECODE/EXECUTE’ , ‘011 - ASSIGN FLAGS’ , ‘100 - STOP’

0

1

2

3

4-7

8

9

10-12

13-15

ZERO

SIGN

CARRY OVFLOW

\-

STOP

\-

STATE

\-

Operation Status Register

STATE

IDLE

‘10-12’

000

FETCH

001

DECODE/EXECUTE 010

ASSIGN

STOP

011

100

State Table



<a name="br3"></a> 

2

Instruction Set Architecture (ISA)

Each Instruction code has a fixed size of 32-bits. The functionalities of each word

may be vary with the mode of operation. The ISA supports Immediate addressing and

register addressing modes. In case of immediate addressing, the value to be used is

preceded by ‘#’. The GPRs can be addressed by specifying the index of the register to

be used preceded by R. For instance , the 8<sup>th</sup> GPR can be addressed as R8 and the xth

register can be addressed as Rx.

The Instruction set of the processor can be represented as below:

2\.1

Register Addressing Mode : The mode bit is set to ‘0’.

31 : 27

Opcode

xxxxx

26 : 22

Dest. Reg

xxxxx

21 : 17

Src. Reg 1

xxxxx

16

Mode

0

15 : 11

Src. Reg 2

xxxxx

10 : 0

-Unused-

xxxxxxxxxxx

2\.2

Immediate Addressing Mode : The mode bit is set to ‘1’. The LSB 16 bits

are used to represent the immediate value.

31 : 27

Opcode

xxxxx

26 : 22

Dest. Reg

xxxxx

21 : 17

Src. Reg 1

xxxxx

16

Mode

1

15 : 0

Imm. value

xxxxxxxxxxxxxxxx

2\.3 Instruction Set

There are a total of 26 instructions which can be performed by the CPU. They are as

follows.

S No.

Instruction

Description

Mode

Syntax

1\.

2\.

3\.

MOVSGPR

MOV

Move the contents of SGPR to Rx

Move contents of Ry to Rx

Add contents of Ry and Rz then assign

the result to Rx

Reg.

Reg.

Reg.

MOVSGPR Rx

MOV Rx Ry

ADD Rx Ry Rz

ADD

4\.

5\.

6\.

7\.

8\.

SUB

MUL

OR

Subtract contents of Ry and Rz then

assign the result to Rx

Multiply contents of Ry and Rz then

assign the LSB 16 bits to Rx

Bitwise OR Ry with Rz and assign the

result to Rx

Bitwise AND Ry with Rz and assign the

result to Rx

Bitwise XOR Ry with Rz and assign the

result to Rx

Reg.

Reg.

Reg.

Reg.

Reg.

SUB Rx Ry Rz

MUL Rx Ry Rz

OR Rx Ry Rz

AND

XOR

AND Rx Ry Rz

XOR Rx Ry Rz



<a name="br4"></a> 

9\.

XNOR

NAND

NOR

Bitwise XNOR Ry with Rz and assign

the result to Rx

Bitwise NAND Ry with Rz and assign

the result to Rx

Bitwise NOR Rywith Rz and assign the

result to Rx

Bitwise NOT Ry and assign the result to

Rx

Store the value of Rx to the xx location

in data memory.

Store the value of Din bus to the xx

location in data memory.

Send the value of data memory at xx

location to Dout bus

Send the value of data memory at xx

location to Rx

Reg.

Reg.

Reg.

Reg.

Reg.

Reg.

Reg.

Reg.

Reg.

XNOR Rx Ry Rz

NAND Rx Ry Rz

NOR Rx Ry Rz

NOT Rx Ry

10\.

11\.

12\.

13\.

14\.

15\.

16\.

17\.

NOT

STRREG

STRIN

SNDOUT

SNDREG

JMP

STRREG Rx xx

STRIN xx

SNDOUT xx

SNDREG Rx xx

JMP xx

Jump to instruction at xx location in inst.

memory

18\.

19\.

20\.

21\.

22\.

23\.

24\.

25\.

26\.

JC

JNC

JSGN

JNSGN

JZ

JNZ

JVF

JNVF

HLT

Jump to xx if carry = 1

Jump to xx if carry = 0

Jump to xx if sign = 1

Jump to xx if sign = 0

Jump to xx if zero = 1

Jump to xx if zero = 0

Jump to xx if overflow = 1

Jump to xx if overflow = 0

Stop execution

Reg.

Reg.

Reg.

Reg.

Reg.

Reg.

Reg.

Reg.

\-

JC xx

JNC xx

JSGN xx

JNSGN xx

JZ xx

JNZ xx

JVF xx

JNVF xx

HLT

\------ -------------------

Immediate Addressing Modes

Move immediate value xx to Rx

Add immediate value xx to Ry assign

the result to Rx

\--------- ---------------------

27\.

28\.

MOV

ADD

Imm

Imm

MOV Rx xx

ADD Rx Ry xx

29\.

30\.

31\.

32\.

33\.

34\.

35\.

36\.

37\.

SUB

MUL

OR

Subtract immediate value xx from Ry

and assign the result to Rx

Multiply immediate value xx with Ry

and assign the LSB 16 bits to Rx

Bitwise OR immediate value xx with Ry

and assign the result to Rx

Bitwise AND immediate value xx with

Ry and assign the result to Rx

Bitwise XOR immediate value xx with

Ry and assign the result to Rx

Bitwise XNOR immediate value xx with

Ry and assign the result to Rx

Bitwise NAND immediate value xx with

Ry and assign the result to Rx

Bitwise NOR immediate value xx with

Ry and assign the result to Rx

Bitwise NOT immediate value xx and

assign the result to Rx

Imm

Imm

Imm

Imm

Imm

Imm

Imm

Imm

Imm

SUB Rx Ry xx

MUL Rx Ry xx

OR Rx Ry xx

AND

XOR

XNOR

NAND

NOR

NOT

AND Rx Ry xx

XOR Rx Ry xx

XNOR Rx Ry xx

NAND Rx Ry xx

NOR Rx Ry xx

NOT Rx xx



<a name="br5"></a> 

2\.3 Opcode Table

Operation

Opcode

MOVSGPR

MOV

ADD

‘00000’

‘00001’

‘00010’

‘00011’

‘00100’

‘00101’

‘00110’

‘00111’

‘01000’

‘01001’

‘01010’

‘01011’

‘01100’

‘01101’

‘01110’

‘01111’

‘10000’

‘10001’

‘10010’

‘10011’

‘10100’

‘10101’

‘10110’

‘10111’

‘11000’

‘11001’

SUB

MUL

OR

AND

XOR

XNOR

NAND

NOR

NOT

STRREG

STRIN

SNDOUT

SNDREG

JMP

JC

JNC

JSGN

JNSGN

JZ

JNZ

JVF

JNVF

HLT

l Eg: [Instruction]:

ADD R1 R5 R14 (Register Addressing Mode)

31 : 27

Opcode

‘00010’

26 : 22

Dest. Reg

00001

21 : 17

Src. Reg 1

00101

16

Mode

0

15 : 11

Src. Reg 2

01110

10 : 0

-Unused-

xxxxxxxxxxx

l Eg: [Instruction]:

XOR R4 R21 #16215 (Immediate Addressing Mode)

31 : 27

Opcode

‘00111’

26 : 22

Dest. Reg Src. Reg 1

00100 10101

21 : 17

16

Mode

1

15 : 0

Imm. value

0011111101010111



<a name="br6"></a> 

3\.

Assembly to Machine code compiler

l The decode\_compile.py is a python program which converts the assembly

language to machine code.

l All instructions need to be in uppercase.

l After all instructions are fed into the the program type “GENERATE” command

followed by the file name to generate the program file ( GENERATE file\_name ).

l Rename the file as ‘inst\_mem.mem’ or the $readmemb() argument can be

changed to the file name.

l Specify the full address of the file inside the $readmemb() function.

4\.

Input and output ports

l

l

l

l

The clk port requires a clock signal for the synchronous state machine.

The sys\_rst port resets the processor and sets the PC to zero.

Din bus is used to send data to the data memory.

Dout is used to send data out of the processor module.

