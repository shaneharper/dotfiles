@setlocal
@set script_directory=%~dp0

echo source %script_directory%vimrc >> %USERPROFILE%\.vimrc
git config --global core.excludesfile %script_directory%/gitignore
echo %%include %script_directory%hgrc >> %USERPROFILE%\.hgrc
