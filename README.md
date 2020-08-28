# Java Loop Benchmark 

## Requirements (Windows)
- Python 3 with td/tk
- Valid JDK paths set in `run_tests.ps1`

#### How to set JDK paths in `run_tests.ps1`?

`run_tests.ps1` assumes, that all JDKs are installed in one directory, by default `C:\Program Files\Java`.
User should define names of directories with different JDK inside in `javaDirs` variable.

#### How to run benchmark?

Benchmark can be launched by `run_tests.ps1` ran in powershell. 

## Requirements (Linux)
- Python 3
- Maven
- Valid jdk paths set in `run_tests.sh`

#### How to set JDK paths in `run_tests.sh`?

`run_tests.sh` assumes, that each JDK directory is defined by an environmental variable.
User should enter names of environmental variables to `JDKS` variable or define paths.

#### How to run benchmark?

Benchmark can be launched by `run_tests.sh` ran in bash.
