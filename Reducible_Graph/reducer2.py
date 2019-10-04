import sys
N = 0
r = 0
for ln, line in enumerate(sys.stdin):
    line = line.strip()
    line = line.split()
    if ln == 0:
        N = int(line[1])
        print(N)
    
    else:
        if r == 0:
            r = line[0]
        
        if line[0] == r:
            print(line[2]),
        
        else:
            print("")
            r = line[0]
            print(line[2]),
print("")
for i in range(N):
    print(1.0/N)