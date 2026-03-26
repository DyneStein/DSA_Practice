@echo off
:: Force the script to strictly run ONLY in its current folder
cd /d "%~dp0"
setlocal enabledelayedexpansion

echo ========================================
echo       Git Auto-Upload Script
echo ========================================
echo.

:: 1. Initialize Git if not already initialized
if not exist ".git" (
    echo [INFO] Initializing Git repository...
    git init
    echo [INFO] Adding remote repository: https://github.com/DyneStein/DSA_Practice
    git remote add origin https://github.com/DyneStein/DSA_Practice
) else (
    echo [INFO] Git repository already initialized.
    :: Ensure remote is set correctly (ignoring error if it already exists)
    git remote add origin https://github.com/DyneStein/DSA_Practice 2>nul
)

:: 2. Find empty directories and add .gitkeep
echo [INFO] Scanning for empty folders to add .gitkeep...
:: dir /s /b /ad lists all directories recursively
:: findstr /v excludes any folders that are .git folders or inside them
for /f "delims=" %%d in ('dir /s /b /ad ^| findstr /v "\\.git$" ^| findstr /v "\\.git\\"') do (
    dir /b /a "%%d\*" >nul 2>nul
    if errorlevel 1 (
        echo   - Found empty folder. Adding .gitkeep: "%%d"
        type nul > "%%d\.gitkeep"
    )
)

:: 3. Track all new, modified, and deleted files
echo [INFO] Staging all files (new, modified, deleted)...
git add .

:: 4. Prompt for commit message
echo.
set "commit_msg="
set /p commit_msg="Enter commit message (Leave blank for 'Daily Auto-Upload'): "

if "!commit_msg!"=="" (
    set "commit_msg=Daily Auto-Upload"
)

:: 5. Commit and push
echo [INFO] Committing changes with message: "!commit_msg!"
git commit -m "!commit_msg!"

echo [INFO] Pushing to main branch on GitHub...
:: Ensure current branch is named main
git branch -M main
git push -u origin main

echo.
echo ========================================
echo       Upload Complete!
echo ========================================
pause
