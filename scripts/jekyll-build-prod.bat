@echo off
title Jekyll build
if exist *.bat goto changeToParentDirectory
goto executeJekyll
:changeToParentDirectory
setlocal
cd ..
:executeJekyll
call jekyll build
pause