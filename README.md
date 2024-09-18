The following files are for educational purposes only.

First, you download the file batmobile.bat on the client-side. If it doesn’t exist in the Startup folder, it will copy itself there and restart the computer. Afterward, it checks if the file shackmobile.ps1 exists in the Startup folder. If not, it will write the content to a file in the Startup folder, save it as shackmobile.ps1, and restart the computer. Then, it checks if the file monitor.bat exists in the Startup folder, and if not, it will write the content to a file in the Startup folder, save it as monitor.bat, and restart the computer.

If the files batmobile.bat, shackmobile.ps1, and monitor.bat are already present in the Startup folder, the file batmobile.bat will execute them in a hidden window.

*Batmobile.bat during execution:*

Runs the files monitor.bat and shackmobile.ps1 in a hidden window and monitors if their windows are closed or killed. If so, it will restart them.

*Monitor.bat during execution:*

Checks if the file batmobile.bat is running. If it’s killed or its window is closed, it will restart it.

*Shackmobile.ps1 during execution:*

Performs a reverse shell to the attacker's IP address and port specified in the code. Additionally, it checks if someone tries to open the Startup folder, and if so, it closes it immediately.
