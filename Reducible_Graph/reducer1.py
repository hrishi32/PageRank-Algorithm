import sys
prev = -1
outdegree = 0
edges = []
d = 0.85
N = 0
for ln, line in enumerate(sys.stdin):
    line = line.strip()
    line = line.split()
    if ln == 0:
        N = int(line[1])
        print(int(line[1]))

    else:
        if line[0] == prev:
            edges.append(int(line[1]))
            outdegree+=1

        else:
            if prev == -1:
                prev = line[0]
                edges.append(int(line[0]))
                edges.append(int(line[1]))
                outdegree = 1
            else:
                j = 1
                for i in range(N):
                    if j < len(edges) and i == edges[j]-1:
                        j+=1
                        if outdegree == 0:
                            print(float(1.0/N)/d + ((1-d)/N)),
                        else:
                            print(float(1.0/outdegree)*d + ((1-d)/N)),
                    else:
                        print(0),
                print("")
                # print("%s %s"%(prev, " ".join(str(x) for x in edges)))
                edges = []
                prev = line[0]
                edges.append(int(line[0]))
                edges.append(int(line[1]))
                outdegree = 1

j = 1
for i in range(N):
    if j < len(edges) and i == edges[j]-1:
        j+=1
        if outdegree == 0:
            print(float(1.0/N)/d + ((1-d)/N)),
        else:
            print(float(1.0/outdegree)*d + ((1-d)/N)),
    else:
        print(0),
print("")