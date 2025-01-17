@echo off
setlocal enabledelayedexpansion
:: This script will run CodeCloneDetectionAnalyser

:: Set the base path and dependencies
set PROJECT_PATH=C:\Users\mertk\Desktop\CS442\Team02_CodeCloneDetectionAnalyser\
set ANTLR4_PATH=C:\Users\mertk\antlr-4.7-complete.jar

:: Set the tool paths
set TOOL_1_NAME=duplicate-code-detection-tool\
set TOOL_2_NAME=SimpleCC\
set TOOL_3_NAME=myCC\

:: Set the dataset file name from the command line arguments
set DATA_SET_NAME=%~1

:: If no valid dataset file is provided, ask for one
:datasetloop
if not defined DATA_SET_NAME (
    set /p "DATA_SET_NAME=Please provide a dataset folder name: "
    goto :datasetloop
) else if not exist "%PROJECT_PATH%%DATA_SET_NAME%" (
    echo Dataset file "%PROJECT_PATH%%DATA_SET_NAME%" does not exist.
    set DATA_SET_NAME=
    goto :datasetloop
)

:: Prompt the user for input
echo.
echo * Press 1 for Type1 CC detection: Duplicate Code Detection
echo * Press 2 for Type2 CC detection: SimpleCC
echo * Press 3 for Type2 CC detection: myCC
echo * Press 4 to run all the CC detection tools
echo * Press any other key to exit 
echo.

set /p "choice=Choice: "

:: Check the user's input
if "!choice!"=="1" (
    :: Run duplicate code detector Type1
    set /p IGNORE_THRESHOLD="Please provide the ignore threshold for Duplicate Code Detection: "
    python -W ignore "%PROJECT_PATH%%TOOL_1_NAME%duplicate_code_detection.py" --ignore-threshold !IGNORE_THRESHOLD! --csv-output Type1_CC_Percentage.txt -d "%PROJECT_PATH%%DATA_SET_NAME%"

) else if "!choice!"=="2" (
    :: Run SimpleCC Type2
    java -cp "%ANTLR4_PATH%;%PROJECT_PATH%%TOOL_2_NAME%simplecc.jar" jp.naist.se.simplecc.CloneDetectionMain "%PROJECT_PATH%%DATA_SET_NAME%" > Type2_SimpleCC_All_Pairs.txt
    python framework_util.py simpleCC
    
) else if "!choice!"=="3" (
    :: Run myCC Type2
    java -jar "%PROJECT_PATH%%TOOL_3_NAME%target\myCC.jar" "%PROJECT_PATH%%DATA_SET_NAME%" > Type2_myCC_All_Pairs.txt
    python framework_util.py myCC

) else if "!choice!"=="4" (
    :: Duplicate code detector Type1
    set /p IGNORE_THRESHOLD="Please provide the ignore threshold for Duplicate Code Detection: "
    python -W ignore "%PROJECT_PATH%%TOOL_1_NAME%duplicate_code_detection.py" --ignore-threshold !IGNORE_THRESHOLD! --csv-output Type1_CC_Percentage.txt -d "%PROJECT_PATH%%DATA_SET_NAME%"

    :: SimpleCC Type2
    java -cp "%ANTLR4_PATH%;%PROJECT_PATH%%TOOL_2_NAME%simplecc.jar" jp.naist.se.simplecc.CloneDetectionMain "%PROJECT_PATH%%DATA_SET_NAME%" > Type2_SimpleCC_All_Pairs.txt
    python framework_util.py simpleCC

    :: myCC Type2
    java -jar "%PROJECT_PATH%%TOOL_3_NAME%target\myCC.jar" "%PROJECT_PATH%%DATA_SET_NAME%" > Type2_myCC_All_Pairs.txt
    python framework_util.py myCC
    python framework_util.py all

) else (
    exit
)
