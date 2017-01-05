@echo off
title Jekyll clean
if exist *.bat goto changeToParentDirectory
goto executeJekyll
:changeToParentDirectory
setlocal
cd ..
:executeJekyll
jekyll clean