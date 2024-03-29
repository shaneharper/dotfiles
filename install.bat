@echo off

@setlocal
@set script_directory=%~dp0

echo source %script_directory%vimrc>> %USERPROFILE%\.vimrc
git config --global core.excludesfile %script_directory%/gitignore
git config --global push.default simple

echo # This file was generated by %~f0.>> %USERPROFILE%\.hgrc
echo.>> %USERPROFILE%\.hgrc
echo [ui]>> %USERPROFILE%\.hgrc
echo ignore = %script_directory%hgignore>> %USERPROFILE%\.hgrc
echo %%include %script_directory%hgrc>> %USERPROFILE%\.hgrc

REM Settings for Windows Terminal
REM  - Backup %USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.
REM  - copy windows_terminal_settings--i7_12700K_PC.json %USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
REM  - The following profile guids are used on my XPS 15 laptop:
REM      "x64 Developer Command Prompt for VS 2022": {d3d858ea-2ed2-5953-8629-0b7f3fc358ee}
REM      "Developer PowerShell for VS 2022": {1b924807-e994-54ba-9f4e-8d9cd916ba97}
