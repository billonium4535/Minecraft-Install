@echo off

REM Links to server and mod downloads:

REM Paper https://papermc.io/downloads
REM Geyser https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/
REM Floodgate https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/

REM Sets the server and mod files to download
set ServerFile="https://api.papermc.io/v2/projects/paper/versions/1.19.3/builds/375/downloads/paper-1.19.3-375.jar"
set GeyserPlugin="https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/build/libs/Geyser-Spigot.jar"
set FloodgatePlugin="https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/build/libs/floodgate-spigot.jar"

REM Sets the maximum RAM for the server (8GB is default and recommended)
set MaxRam=8

REM Sets the minimum RAM for the server (2GB is default and recommended)
set MinRam=2

REM Creates a directory and enters it
mkdir "Minecraft Server"
cd "Minecraft Server"

REM Sets the new directory to the working directory
set cwd=%cd%

REM Downloads the server file and starts it
curl %ServerFile% --ssl-no-revoke --output "%cwd%\server.jar"
start server.jar

REM Function to check if the EULA has been generated
:FindEULA
if exist eula.txt goto StartBat
goto FindEULA

REM Function to create a file to start the server
:StartBat
if exist start.bat goto StopBat
echo @echo off> start.bat
echo java -Xmx%MaxRam%G -Xms%MinRam%G -jar server.jar nogui>> start.bat
echo exit>> start.bat
goto StopBat

REM Function to create a file to stop the server
:StopBat
if exist stop.bat goto SetTrue
echo @echo off> stop.bat
echo netstat -ano ^| findstr :25565 ^>pid.txt>> stop.bat
echo FOR /F "usebackq tokens=5" %%%%A in (pid.txt) do (>> stop.bat
echo 	taskkill /F /PID %%%%A>> stop.bat
echo )>> stop.bat
echo exit>> stop.bat
goto SetTrue

REM Sets the EULA to true and re-launches the server
:SetTrue
echo eula=true> eula.txt
goto InstallPlugins

REM Function to download and install plugins
:InstallPlugins
start start.bat
timeout 20
start stop.bat
timeout 2
cd plugins
curl %GeyserPlugin% --ssl-no-revoke --output "Geyser-Spigot.jar"
curl %FloodgatePlugin% --ssl-no-revoke --output "floodgate-spigot.jar"
cd..
start start.bat
timeout 20
start stop.bat
timeout 2

REM Function to run the server
:RunServer
for /f %%G in ('curl "http://api.ipify.org"') do set ip=%%G
title Connect on %ip%:25565
java -Xmx8G -Xms2G -jar server.jar nogui