@setlocal
@set script_directory=%~dp0

echo source %script_directory%vimrc >> %USERPROFILE%\.vimrc
git config --global core.excludesfile %script_directory%/gitignore
git config --global push.default simple
echo %%include %script_directory%hgrc >> %USERPROFILE%\.hgrc

REM copy ctags.cnf %userprofile%
