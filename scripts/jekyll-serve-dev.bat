@echo off
title Jekyll server dev
if exist *.bat goto changeToParentDirectory
goto executeJekyll
:changeToParentDirectory
setlocal
cd ..
:executeJekyll
jekyll serve --drafts