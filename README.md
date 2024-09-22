# MIPS Processor and Assembler

This is a single-cycle implementation of MIPS in verilog. The processor is capable of executing the following instructions:

- R-type instructions: `add`, `sub`, `and`, `or`, `slt`, `sll`, `srl`
- I-type instructions: `addi`, `lw`, `sw`, `beq`
- J-type instructions: `j`

To run an assembly program, you can use the assembler provided as `assemble.py`. Run it as follows:

```bash
python assemble.py <assembly_file> -o <output_file>
make run
```

The Instruction Memory, by default loads `memfile.dat`, so be sure to set `output_file` as `memfile.dat` or set the filename in `imem.v`.
