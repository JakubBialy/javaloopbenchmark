#!/usr/bin/env bash

set -e
set -o pipefail

JDKS=($LT_JAVA_8 $LT_JAVA_11 $LT_JAVA_12 $LT_JAVA_13 $LT_JAVA_14 $LT_JAVA_15 $LT_JAVA_16)

timestamp=$(date +"%Y%m%d%_k%M%N")
outputDir=./data/$timestamp
mkdir -p $outputDir

for item in ${JDKS[*]}
do
        curr_java_ver=$(JAVA_HOME=$item python3 ./get_java_version.py)
        curr_java_major_ver=$(JAVA_HOME=$item python3 ./get_java_major_version.py)

        printf "Java version: $curr_java_ver\n"
        printf "Java major version: $curr_java_major_ver\n\n"
        JAVA_HOME=$(echo $item) mvn -Djdk.ver=$curr_java_major_ver clean package

        echo "==="
        echo "$item/bin/java -jar ./target/Java_Benchmarks-0.1.0.jar IteratingBenchmark -jvmArgs -XX:+UseG1GC -bm thrpt -wi 10 -w 5 -r 10 -i 30 -f 1 -rf scsv -rff $outputDir/benchmark_$curr_java_ver.scsv"
        $item/bin/java -jar ./target/Java_Benchmarks-0.1.0.jar IteratingBenchmark -jvmArgs -XX:+UseG1GC -bm thrpt -wi 10 -w 5 -r 10 -i 30 -f 1 -rf scsv -rff $outputDir/benchmark_$curr_java_ver.scsv
done

python3 ./generate_plot.py $outputDir plot_$timestamp.png
