@echo off
mkdir "Minecraft Server"
cd "Minecraft Server"
set cwd=%cd%
curl https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar --output "%cwd%\server.jar"
start server.jar
:FindEULA
if exist eula.txt goto SetTrue
goto FindEULA
:SetTrue
echo eula=true> eula.txt
java -Xmx8G -Xms2G -jar server.jar nogui