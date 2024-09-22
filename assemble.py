import argparse

parser = argparse.ArgumentParser(description="Assemble a MIPS assembly file")
parser.add_argument("file", help="The input file")
parser.add_argument("-o", "--output", help="The output file")
argv = parser.parse_args()


def twos_complement(num, n):
    min_val = -(1 << (n - 1))
    max_val = (1 << (n - 1)) - 1
    if num < min_val or num > max_val:
        raise ValueError(
            f"Value {num} cannot be represented in {n} bits two's complement"
        )
    if num < 0:
        num = (1 << n) + num
    return f"{num:0{n}b}"[-n:]


# read file
f = open(argv.file, "r")
asm = f.read().splitlines()
f.close()

instr_by_label = {}
offsets = {}
curr_section = None

# first pass, parse labels
for line in asm:
    if (":" not in line) and (not curr_section):
        raise Exception("Invalid label")
    if ":" in line:
        new_section = line.split(":")[0].strip()
        offsets[new_section] = offsets.get(curr_section, 0) + len(
            instr_by_label.get(curr_section, [])
        )
        instr = line.split(":")[1].strip()
        if instr:
            instr_by_label[new_section] = [instr]
        else:
            instr_by_label[new_section] = []
        curr_section = new_section
    else:
        instr_by_label[curr_section].append(line.strip())


# register table
register_table = {}
for i in range(32):
    register_table[f"${i}"] = bin(i)[2:].rjust(5, "0")

out = []
for label in offsets:
    for i, instr in enumerate(instr_by_label[label]):
        try:
            op = instr.split(" ", 1)[0].strip().lower()
            args = [s.strip() for s in instr.split(" ", 1)[1].strip().split(",")]
            if op == "add":
                out.append(
                    int(
                        f"000000{register_table[args[1]]}{register_table[args[2]]}{register_table[args[0]]}00000100000",
                        2,
                    )
                )
            elif op == "sub":
                out.append(
                    int(
                        f"000000{register_table[args[1]]}{register_table[args[2]]}{register_table[args[0]]}00000100010",
                        2,
                    )
                )
            elif op == "and":
                out.append(
                    int(
                        f"000000{register_table[args[1]]}{register_table[args[2]]}{register_table[args[0]]}00000100100",
                        2,
                    )
                )
            elif op == "or":
                out.append(
                    int(
                        f"000000{register_table[args[1]]}{register_table[args[2]]}{register_table[args[0]]}00000100101",
                        2,
                    )
                )
            elif op == "slt":
                out.append(
                    int(
                        f"000000{register_table[args[1]]}{register_table[args[2]]}{register_table[args[0]]}00000101010",
                        2,
                    )
                )
            elif op == "lw" or op == "sw":
                if ("(" not in args[1]) or (")" not in args[1]):
                    raise Exception(f"Invalid instruction {instr}")
                imm, rs = [s.strip() for s in args[1][:-1].split("(")]
                out.append(
                    int(
                        f"10{int(op == 'sw')}011{register_table[rs]}{register_table[args[0]]}{twos_complement(int(imm), 16)}",
                        2,
                    )
                )
            elif op == "beq":
                if args[2] not in offsets:
                    raise Exception(f"Invalid label {args[2]} in instruction {instr}")
                out.append(
                    int(
                        f"000100{register_table[args[0]]}{register_table[args[1]]}{twos_complement(offsets[args[2]] - offsets[label] - i - 1,16)}",
                        2,
                    )
                )
            elif op == "addi":
                out.append(
                    int(
                        f"001000{register_table[args[1]]}{register_table[args[0]]}{twos_complement(int(args[2]),16)}",
                        2,
                    )
                )
            elif op == "j":
                if args[0] not in offsets:
                    raise Exception(f"Invalid label {args[0]} in instruction {instr}")
                out.append(int(f"000010{twos_complement(offsets[args[0]], 26)}", 2))
            else:
                raise Exception(f"Invalid instruction {instr}")
        except Exception as e:
            print(f"Error at line {i+1} in section {label}: {e}")

# write to file
outfile = argv.output or (argv.file.split(".")[0] + ".dat")
f = open(outfile, "w")
for instr in out:
    f.write(f"{instr:08x}\n")
f.close()
