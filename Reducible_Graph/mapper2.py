import sys
N = 0
for ln, line in enumerate(sys.stdin):
    line = line.strip()
    if ln == 0:
        N = int(line)
        print("%s %s"%(0, N))
    else:
        line = line.split()
        for j, val in enumerate(line):
            print("%s %s %s"%(j+1, ln, val))