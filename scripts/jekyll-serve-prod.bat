@echo off
title Jekyll server
if exist *.bat goto changeToParentDirectory
goto executeJekyll
:changeToParentDirectory
setlocal
cd ..
:executeJekyll
jekyll serve