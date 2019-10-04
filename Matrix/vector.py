import sys
N = 0

for line in sys.stdin:
    line = line.strip()
    N = int(line)
    break

for i in range(N):
    print(1.0/N)