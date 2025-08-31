@echo off
REM 

for %%f in (tests\*) do (
    if exist "%%f" (
        echo Running test: %%~nxf
        echo.
        call run.bat "%%f"
        echo.
        echo    -----------------------------------
    )
)

REM 
exit /b