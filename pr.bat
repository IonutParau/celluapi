@echo off
echo Change to forked repo
git remote set-url origin https://github.com/lieve-blendi/celluapi

echo Generating push with 3 commands:
echo - Adding everything
git add *
echo - Printing status
git status
echo - Commiting
set /p changes="What changes did you make? "
git commit -m %changes%
echo - Pushing to the origins main
git push origin main

echo Now lets create the PR.
gh pr create

echo Change back to main repo by Blendi
git remote set-url origin https://github.com/IonutParau/celluapi