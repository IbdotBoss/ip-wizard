@echo off
setlocal enabledelayedexpansion

REM Display a welcome message
echo ------------------------------------------------
echo ************************************************
echo              Welcome to IP WIZARD               
echo ************************************************
echo ------------------------------------------------

REM Check if a command line parameter (domain name) is provided
if "%~1"=="" (
    REM If no parameter is provided, call the menu function
    call :menu
) else if not "%~2"=="" (
    REM If more than one parameter is provided, display an error message and exit
    echo Too many parameters entered
    exit /b
) else (
    REM If exactly one parameter is provided, proceed with the script
    REM Start a loop to read the file line by line
    for /F "tokens=*" %%A in (%~1) do (
        REM Display the current domain name
        echo Domain: %%A
        REM Set a flag to determine whether to print the IP address
        set printFlag=no
        REM Start another loop to run the nslookup command on the current domain name and parse its output
        for /F "delims=" %%B in ('nslookup %%A 2^>nul') do (
            REM Check if the current line of the nslookup output contains the string "Addresses: "
            REM If it does, set the printFlag to "yes"
            echo %%B | findstr /R /C:"Addresses: " >nul && set printFlag=yes
            REM If the printFlag is "yes", print the current line of the nslookup output (the IP address)
            if "!printFlag!"=="yes" (
                echo %%B
            )
        )
        REM If the printFlag is still "no", no IP address was found, so display an error message
        if "!printFlag!"=="no" (
            echo Invalid domain name or network error
        )
        REM Print a separator line
        echo -----------------------------
    )
    REM Thank the user for using the script and then exit
    echo Thank you for using IP WIZARD 
    exit /b
)

REM Define the menu function
:menu
REM Display a menu to the user and prompt them to make a choice
echo Please select the option you want to proceed:
echo 1) input a domain name
echo 2) quit from the program
set /p choice=Enter your choice:
REM If the user's choice was "1", prompt the user to enter a domain name and then perform the same nslookup process as before
if "!choice!"=="1" (
    set /p domain=Enter a domain name:
    echo -----------------------------
    echo Domain: !domain!
    set printFlag=no
    for /F "delims=" %%B in ('nslookup !domain! 2^>nul') do (
        echo %%B | findstr /R /C:"Addresses: " >nul && set printFlag=yes
        if "!printFlag!"=="yes" (
            echo %%B
        )
    )
    echo -----------------------------
    if "!printFlag!"=="no" (
        echo Invalid domain name or network error
    )
    REM Check if the user has entered 2 to quit
    if "!choice!"=="2" (
        echo Thank you for using IP WIZARD
        exit /b
    )
    goto :menu
) else if "!choice!"=="2" (
    REM If the user's choice was "2", thank the user and exit the script
    echo Thank you for using IP WIZARD
    exit /b
) else (
    REM If the user's choice was neither "1" nor "2", display an error message and go back to the menu
    echo Invalid choice. Please enter 1 or 2.
    goto :menu
)