import sys
# outdegree = [0]
for ln, line in enumerate(sys.stdin):
    if ln == 0:
        line = line.strip()
        print("%s %s"%(0, line))
    else:
        line = line.strip()
        print(line)
    # line = line.strip()

    # if ln == 0:
    #     print(int(line))

    # else:
    #     line = line.split()
    #     print("%s %s"%(int(line[0])-1, int(line[1])-1))
    #     outdegree[int(line[0])]+=1



