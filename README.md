# RISC-ISA based 6-stage 16-bit pipeline processor
RISC-ISA based 6-stage 16-bit pipeline processor

IITB-RISC is a MIPS based 16 bit processor. The IITB-RISC-23 has 8 general-purpose registers (R0 to
R7). Register R0 always stores Program Counter. All addresses are byte addressable and instructions.
Always it fetches two bytes for instruction and data. This architecture uses condition code register
which has two flags Carry flag ( C ) and Zero flag (Z). The IITB-RISC-23 is very simple, but it is
general enough to solve complex problems. The architecture allows predicated instruction execution
and multiple load and store execution. There are three machine-code instruction formats (R, I, and J
type) and a total of 14 instructions.
