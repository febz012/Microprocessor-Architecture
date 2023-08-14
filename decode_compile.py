
INPUT = ""
inst_line = 0
opcode_dec = ({"MOVSPGR":"00000","MOV":"00001",
               "ADD":"00010","SUB":"00011",
               "MUL":"00100","OR":"00101",
               "AND":"00110","XOR":"00111",
               "XNOR":"01000","NAND":"01001",
               "NOR":"01010","NOT":"01011",
               "STRREG":"01100","STRIN":"01101",
               "SNDOUT":"01110","SNDREG":"01111",
               "JMP":"10000","JC":"10001",
               "JNC":"10010","JSGN":"10011",
               "JNSGN":"10100","JZ":"10101",
               "JNZ":"10110","JVF":"10111",
               "JNVF":"11000","HLT":"11001"})

reg_dec = ({"R0":"00000","R1":"00001","R2":"00010",
            "R3":"00011","R4":"00100","R5":"00101",
            "R6":"00110","R7":"00111","R8":"01000",
            "R9":"01001","R10":"01010","R11":"01011",
            "R12":"01100","R13":"01101","R14":"01110",
            "R15":"01111","R16":"10000","R17":"10001",
            "R18":"10010","R19":"10011","R20":"10100",
            "R21":"10101","R22":"10110","R23":"10111",
            "R24":"11000","R25":"11001","R26":"11010",
            "R27":"11011","R28":"11100","R17":"11101",
            "R30":"11110","R31":"11111"} )

Combined_Instruction = list()

while(INPUT != "END"):
    Instruction = list()
    INPUT = input("INST{} : ".format(inst_line))
    inst_line += 1
    decode = INPUT.split()
    
    
    if(decode[0] == "GENERATE"):
        with open(r"C:\Users\Febin\Desktop\{}.mem".format(decode[1]), 'w') as f:
            for element in Combined_Instruction:
                f.write(element)
                f.write('\n')
            print("File Generated Successfully .....!")
            break
    else :        
        opcode = opcode_dec[decode[0]]
            
        if len(decode) == 4:
            dest = reg_dec[decode[1]]
            source1 = reg_dec[decode[2]]
            if '#' in decode[3]:
                immdt = '{0:016b}'.format(int(decode[3][1:]))
                imm_mode = "1"
                Instruction.append(opcode)
                Instruction.append(dest)
                Instruction.append(source1)
                Instruction.append(imm_mode)
                Instruction.append(immdt)
            else:
                source2 = reg_dec[decode[3]]
                imm_mode = "0"
                unused = "00000000000"
                Instruction.append(opcode)
                Instruction.append(dest)
                Instruction.append(source1)
                Instruction.append(imm_mode)
                Instruction.append(source2)
                Instruction.append(unused)
        elif len(decode) == 3:

             if(decode[0] == "STRREG"):
                 dest = "00000"
                 source1 = reg_dec[decode[1]]
                 immdt = '{0:016b}'.format(int(decode[2]))
                 imm_mode = "0"
                 Instruction.append(opcode)
                 Instruction.append(dest)
                 Instruction.append(source1)
                 Instruction.append(imm_mode)
                 Instruction.append(immdt)
                 
             elif(decode[0] == "SNDREG"):
                 dest = reg_dec[decode[1]]
                 source1 = "00000"
                 immdt = '{0:016b}'.format(int(decode[2]))
                 imm_mode = "0"
                 Instruction.append(opcode)
                 Instruction.append(dest)
                 Instruction.append(source1)
                 Instruction.append(imm_mode)
                 Instruction.append(immdt)
                 
             elif decode[0] == "MOV" or decode[0] == "NOT":
                 dest = reg_dec[decode[1]]
                 if '#' in decode[2]:
                    
                    source1 = "00000"
                    immdt = '{0:016b}'.format(int(decode[2][1:]))
                    imm_mode = "1"
                    Instruction.append(opcode)
                    Instruction.append(dest)
                    Instruction.append(source1)
                    Instruction.append(imm_mode)
                    Instruction.append(immdt)
                    
                 else:
                   
                    source1 = reg_dec[decode[2]] 
                    imm_mode = "0"
                    unused = "00000000000"
                    source2 = "00000"
                    Instruction.append(opcode)
                    Instruction.append(dest)
                    Instruction.append(source1)
                    Instruction.append(imm_mode)
                    Instruction.append(source2)
                    Instruction.append(unused)
                 
        elif len(decode) == 2:  
             if(decode[0] == "MOVSGPR"):
                 dest = reg_dec[decode[1]]
                 source1 = "00000"
                 imm_mode = "0"
                 unused = "00000000000"
                 source2 = "00000"
                 Instruction.append(opcode)
                 Instruction.append(dest)
                 Instruction.append(source1)
                 Instruction.append(imm_mode)
                 Instruction.append(source2)
                 Instruction.append(unused)
                 
             elif(decode[0] == "STRIN"):
                 dest = "00000"
                 source1 = "00000"
                 imm_mode = "1"
                 immdt = '{0:016b}'.format(int(decode[1]))
                 Instruction.append(opcode)
                 Instruction.append(dest)
                 Instruction.append(source1)
                 Instruction.append(imm_mode)
                 Instruction.append(immdt)
                 
             elif(decode[0] == "SNDOUT"):
                 dest = "00000"
                 source1 = "00000"
                 imm_mode = "1"
                 immdt = '{0:016b}'.format(int(decode[1]))
                 Instruction.append(opcode)
                 Instruction.append(dest)
                 Instruction.append(source1)
                 Instruction.append(imm_mode)
                 Instruction.append(immdt)
                 
             elif (decode[0] == "JC" or decode[0] == "JNC" or decode[0] == "JSGN"
                  or decode[0] == "JNSGN" or decode[0] == "JZ" or  decode[0] == "JNZ" or
                   decode[0] == "JVF" or decode[0] == "JNVF" or decode[0] == "JMP"):
                 dest = "00000"
                 source1 = "00000"
                 imm_mode = "1"
                 immdt = '{0:016b}'.format(int(decode[1]))
                 Instruction.append(opcode)
                 Instruction.append(dest)
                 Instruction.append(source1)
                 Instruction.append(imm_mode)
                 Instruction.append(immdt)
        else :

                 dest = "00000"
                 source1 = "00000"
                 imm_mode = "0"
                 unused = "00000000000"
                 source2 = "00000"
                 Instruction.append(opcode)
                 Instruction.append(dest)
                 Instruction.append(source1)
                 Instruction.append(imm_mode)
                 Instruction.append(source2)
                 Instruction.append(unused)

    temp = "".join(Instruction)
    Combined_Instruction.append(temp)
    print(temp)
    
