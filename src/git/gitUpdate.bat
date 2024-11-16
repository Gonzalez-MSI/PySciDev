@echo off
:: File: git_update.bat

echo Starting Git operations...

:: Add all changes
echo Adding changes...
git add .
if %errorlevel% neq 0 (
    echo Error adding files
    pause
    exit /b %errorlevel%
)

:: Pull latest changes
echo Pulling latest changes...
git pull
if %errorlevel% neq 0 (
    echo Error pulling changes
    pause
    exit /b %errorlevel%
)

:: Commit changes
set /p commit_msg="Enter commit message: "
git commit -m "%commit_msg%"
if %errorlevel% neq 0 (
    echo Error committing changes
    pause
    exit /b %errorlevel%
)

:: Push changes
echo Pushing changes...
git push
if %errorlevel% neq 0 (
    echo Error pushing changes
    pause
    exit /b %errorlevel%
)

echo Git operations completed successfully!
pause