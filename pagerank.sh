#!/bin/bash
echo -e "---------------Initiating Hadoop Code-----------------"
date > hadoop.log
date > mapred.log

if [ "$1" == "init" ]
then
    # /home/hadoop/hadoop-3.2.0/sbin/stop-all.sh
    echo -e "\n\n---------------Initiating Hadoop Setup-----------------\n\n"
    /home/hadoop/hadoop-3.2.0/bin/hdfs namenode -format &>> hadoop.log
    /home/hadoop/hadoop-3.2.0/sbin/start-all.sh &>> hadoop.log
    /home/hadoop/hadoop-3.2.0/bin/hdfs dfs -mkdir /user &>> hadoop.log
    /home/hadoop/hadoop-3.2.0/bin/hdfs dfs -mkdir /user/hadoop &>> hadoop.log
fi

/home/hadoop/hadoop-3.2.0/bin/hdfs dfs -rm -r /user/hadoop/* &>> hadoop.log

echo -e  "\n\n-----------------Running First MapReduce---------------\n\n"
/home/hadoop/hadoop-3.2.0/bin/hdfs dfs -put ~/Desktop/BigData/PageRank/Matrix/input.txt input1.txt &>> hadoop.log
/home/hadoop/hadoop-3.2.0/bin/hadoop jar /home/hadoop/hadoop-3.2.0/share/hadoop/tools/lib/hadoop-streaming-3.2.0.jar -file ~/Desktop/BigData/PageRank/Matrix/mapper1.py ~/Desktop/BigData/PageRank/Matrix/reducer1.py -mapper "python mapper1.py" -reducer "python reducer1.py" -input /user/hadoop/input1.txt -output /user/hadoop/mapred1 &>> mapred.log
rm -r ~/Desktop/BigData/PageRank/Matrix/Output/* &>> hadoop.log
mkdir ~/Desktop/BigData/PageRank/Matrix/Output/1 &>> hadoop.log
/home/hadoop/hadoop-3.2.0/bin/hdfs dfs -get mapred1/* ~/Desktop/BigData/PageRank/Matrix/Output/1 &>> hadoop.log
rm -r ~/Desktop/BigData/PageRank/Matrix/Output/1/*SUCCESS &>> hadoop.log
mv ~/Desktop/BigData/PageRank/Matrix/Output/1/part* ~/Desktop/BigData/PageRank/Matrix/Output/1/output.txt &>> hadoop.log

echo -e "\n\n-----------------Running Second MapReduce---------------\n\n"
/home/hadoop/hadoop-3.2.0/bin/hdfs dfs -put ~/Desktop/BigData/PageRank/Matrix/Output/1/output.txt input2.txt &>> hadoop.log
/home/hadoop/hadoop-3.2.0/bin/hadoop jar /home/hadoop/hadoop-3.2.0/share/hadoop/tools/lib/hadoop-streaming-3.2.0.jar -file ~/Desktop/BigData/PageRank/Matrix/mapper2.py ~/Desktop/BigData/PageRank/Matrix/reducer2.py -mapper "python mapper2.py" -reducer "python reducer2.py" -input /user/hadoop/input2.txt -output /user/hadoop/mapred2 &>> mapred.log
# rm -r ~/Desktop/BigData/PageRank/Matrix/Output/*
mkdir ~/Desktop/BigData/PageRank/Matrix/Output/2 &>> hadoop.log
/home/hadoop/hadoop-3.2.0/bin/hdfs dfs -get mapred2/* ~/Desktop/BigData/PageRank/Matrix/Output/2 &>> hadoop.log
rm -r ~/Desktop/BigData/PageRank/Matrix/Output/2/*SUCCESS &>> hadoop.log
mv ~/Desktop/BigData/PageRank/Matrix/Output/2/part* ~/Desktop/BigData/PageRank/Matrix/Output/2/output.txt &>> hadoop.log
cat ~/Desktop/BigData/PageRank/Matrix/Output/2/output.txt| tee ~/Desktop/BigData/PageRank/Matrix/Output/2/output  | python ~/Desktop/BigData/PageRank/Matrix/vector.py | tee -a ~/Desktop/BigData/PageRank/Matrix/Output/2/output

echo -e "\n\n-----------------Running Third MapReduce---------------\n\n"

for ((i=0; i<11; i++))
do
    echo -e "--- Iteration $i ---"
    /home/hadoop/hadoop-3.2.0/bin/hdfs dfs -put ~/Desktop/BigData/PageRank/Matrix/Output/2/output input3.txt &>> hadoop.log
    /home/hadoop/hadoop-3.2.0/bin/hadoop jar /home/hadoop/hadoop-3.2.0/share/hadoop/tools/lib/hadoop-streaming-3.2.0.jar -file ~/Desktop/BigData/PageRank/Matrix/mapper3.py ~/Desktop/BigData/PageRank/Matrix/reducer3.py -mapper "python mapper3.py" -reducer "python reducer3.py" -input /user/hadoop/input3.txt -output /user/hadoop/mapred3 &>> mapred.log
    # rm -r ~/Desktop/BigData/PageRank/Matrix/Output/*
    mkdir ~/Desktop/BigData/PageRank/Matrix/Output/3 &>> hadoop.log
    /home/hadoop/hadoop-3.2.0/bin/hdfs dfs -get mapred3/* ~/Desktop/BigData/PageRank/Matrix/Output/3 &>> hadoop.log
    rm -r ~/Desktop/BigData/PageRank/Matrix/Output/3/*SUCCESS &>> hadoop.log
    mv ~/Desktop/BigData/PageRank/Matrix/Output/3/part* ~/Desktop/BigData/PageRank/Matrix/Output/3/output.txt &>> hadoop.log
    rm -r ./*.py
    cat ~/Desktop/BigData/PageRank/Matrix/Output/3/output.txt | sort | tee ~/Desktop/BigData/PageRank/Matrix/Output/3/output.txt >trash
    cat ~/Desktop/BigData/PageRank/Matrix/Output/3/output.txt | python Remove/remove.py | tee ~/Desktop/BigData/PageRank/Matrix/Output/3/output.txt > trash
    cat ~/Desktop/BigData/PageRank/Matrix/Output/2/output.txt| tee ~/Desktop/BigData/PageRank/Matrix/Output/2/output >trash
    cat ~/Desktop/BigData/PageRank/Matrix/Output/3/output.txt | tee -a ~/Desktop/BigData/PageRank/Matrix/Output/2/output >trash
    rm trash
    cat ~/Desktop/BigData/PageRank/Matrix/Output/3/output.txt
done