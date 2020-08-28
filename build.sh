#mvn clean
#mvn package
#"C:\Program Files\Java\jdk-14.0.1\bin\java.exe" --enable-preview -XX:+UnlockDiagnosticVMOptions -XX:LogFile=log2.txt -XX:CompileCommand=print,*codes.dbg.EvenOddSumBenchmark::findMax_if -XX:PrintAssemblyOptions=syntax -jar ./target/Java_Benchmarks-0.1.0.jar
JAVA_HOME=$(echo $LT_JAVA_14) mvn clean package
