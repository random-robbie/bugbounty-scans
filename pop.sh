#!/bin/bash
echo "[*]Copying from main Aquatone folder to githhub folder [*]"
cp -R  /root/aquatone/ /home/host/bugbounty-scans/
echo "[*]Removing Readme[*]"
rm README.md
echo "[*]Generating New Readme[*]"
python list.py >> README.md
echo "[*]Git Add All[*]"
git add -A
echo "[*]Git Commit[*]"
git commit -m "Auto update"
echo "[*]Git Push[*]"
git push
