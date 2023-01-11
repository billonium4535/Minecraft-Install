@echo off

REM Paper https://papermc.io/downloads
REM Geyser https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/
REM Floodgate https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/

set ServerFile="https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/263/downloads/paper-1.19.2-263.jar"
set GeyserPlugin="https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar"
set FloodgatePlugin="https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/build/libs/floodgate-spigot.jar"

mkdir "Minecraft Server"
cd "Minecraft Server"
set cwd=%cd%
curl %ServerFile% --output "%cwd%\server.jar"
start server.jar

:FindEULA
if exist eula.txt goto StartBat
goto FindEULA

:StartBat
if exist start.bat goto StopBat
echo @echo off> start.bat
echo java -Xmx8G -Xms2G -jar server.jar nogui>> start.bat
echo exit>> start.bat
goto StopBat

:StopBat
if exist stop.bat goto SetTrue
echo @echo off> stop.bat
echo netstat -ano ^| findstr :25565 ^>pid.txt>> stop.bat
echo FOR /F "usebackq tokens=5" %%%%A in (pid.txt) do (>> stop.bat
echo 	taskkill /F /PID %%%%A>> stop.bat
echo )>> stop.bat
echo exit>> stop.bat
goto SetTrue

:SetTrue
echo eula=true> eula.txt
goto InstallPlugins

:InstallPlugins
start start.bat
timeout 20
start stop.bat
timeout 2
cd plugins
curl %GeyserPlugin% --output "Geyser-Spigot.jar"
curl %FloodgatePlugin% --output "floodgate-spigot.jar"
cd..
start start.bat
timeout 20
start stop.bat
timeout 2

:RunServer
for /f %%G in ('curl "http://api.ipify.org"') do set ip=%%G
title Connect on %ip%:25565
java -Xmx8G -Xms2G -jar server.jar nogui