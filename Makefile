SRCS := *.v

all: mips

mips:
	iverilog $(SRCS) -o mips

run: mips
	./mips

clean:
	rm -f mips
	rm -f *.vcd
	rm -f *.out
	rm -f *.err
