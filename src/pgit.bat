@echo off
setlocal enabledelayedexpansion

:: userhelp logic
if "%1"=="--help" (
    echo - pGit, the p^(arody^)Git -
    echo I will not help you, but these are the commands:
    echo.
    echo pgit rem .                  - Destroy all files ^(instead of adding it^)
    echo pgit commit suicide         - Self-explanatory
    echo pgit -p ^<command^>         - Pipe commands to real Git
    echo.
    echo pGit is FOSS. Help with the development on GitHub:
    echo https://github.com/lucmsilva651/pgit
    exit /b 0
)

:: verifying commands
set "command=%1"
SHIFT

if "%command%"=="rem" (
    :: verify args
    if "%1"=="" (
        echo [pgit] No files specified to destroy!
        exit /b 1
    )
    set "target=%1"
    :: delete all arg
    if "%target%"=="." (
        echo [pgit] Removing all files... ^(except the .git folder^)
        for /d %%i in (*) do (
            if /i not "%%i"==".git" (
                echo %%i
                rmdir /s /q "%%i"
            )
        )
        for %%i in (*) do (
            if not "%%i"==".git" (
                echo %%i
                del /q "%%i"
            )
        )
    ) else (
        :: rem specific file
        if exist "%target%" (
            if exist "%target%\*" (
                echo [pgit] Destroying folder: %target%
                rmdir /s /q "%target%"
            ) else (
                echo [pgit] Destroying file: %target%
                del /q "%target%"
            )
        ) else (
            echo [pgit] Error: The file/folder '%target%' doesn't exist.
        )
    )
    goto end
) else if "%command%"=="--pipe" (
    :: pipe to real git
    set "git_command=git"
    :pipe_loop
    if "%1"=="" goto execute_git
    set "git_command=!git_command! %1"
    SHIFT
    goto pipe_loop
) else (
    echo Unknown command: %command%
    echo Use 'pgit --help' to see what commands are available.
    exit /b 1
)

:execute_git
!git_command!

:end
endlocal
exit /b 0
