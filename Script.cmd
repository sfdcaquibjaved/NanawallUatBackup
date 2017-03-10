@echo OFF
echo Data Backup for UAT Sandbox
cd C:/
cd UatCodeBackup
cd UatGit
echo git operation starting
git add .
git commit -am "Daily UAT backup"
git push -v -u
echo Git operation Done
cd ..
ant GitOperations

pause
