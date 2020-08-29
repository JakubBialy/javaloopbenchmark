[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$javaDirsRoot = "C:\PROGRA~1\Java"
$javaFile = "bin\java.exe"
$javaCompilerFile = "bin\javac.exe"
$javaDirs = @("jdk1.8.0_241", "jdk-11.0.2", "jdk-12.0.1", "jdk-13.0.1", "jdk-14.0.1", "openjdk-14.0.2", "openjdk-15")

$timestamp = $( Get-Date -Format "yyyyddMMHHmmssffff" )
$output_dir = "./data/" + $timestamp
( mkdir $output_dir) | out-null

foreach ($javaDir in $javaDirs)
{
    #init
    (Remove-Item '.\out' -Force -Recurse) 2>&1>$null
    (New-Item -ItemType Directory -Path '.\out') | out-null

    #compile
    $compiler = $javaDirsRoot + "\" + $javaDir + "\" + $javaCompilerFile
    $java = $javaDirsRoot + "\" + $javaDir + "\" + $javaFile
    & $compiler @("-classpath", ".\libs\jmh-core-1.25.jar;.\libs\jmh-generator-annprocess-1.25.jar", ".\src\main\java\codes\dbg\*.java", "-d", ".\out")

    #make .jar file
    cd out
    & jar -cf benchmark.jar ./
    (Remove-Item '../benchmark.jar' -Force -Recurse) 2>&1>$null
    mv benchmark.jar ..
    cd ..

    & $java @(
    "-classpath",
    "benchmark.jar;./libs/jmh-core-1.25.jar;./libs/jmh-generator-annprocess-1.25.jar;./libs/jopt-simple-4.6.jar;./libs/commons-math3-3.2.jar",
    "codes.dbg.IteratingBenchmark",
    "IteratingBenchmark",
    "-bm", "thrpt",
    "-jvmArgs", "-XX:+UseG1GC",
    "-wi", "10",
    "-w", "5",
    "-r", "10",
    "-i", "30",
    "-f", "1",
    "-rf", "scsv",
    "-rff", "$output_dir/benchmark_$javaDir.scsv")

    Remove-Item 'benchmark.jar' -Force -Recurse

}

python generate_plot.py $output_dir plot_$timestamp.png

#HIBERNATE AFTER BENCHMARKING
#$PowerState = [System.Windows.Forms.PowerState]::Suspend;
#$Force = $true;
#$DisableWake = $false;
#[System.Windows.Forms.Application]::SetSuspendState($PowerState, $Force, $DisableWake);
