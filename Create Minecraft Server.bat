@echo off
REM Stops the user being able to see commands

set ServerFile="https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar"
REM Sets the server file to download

mkdir "Minecraft Server"
cd "Minecraft Server"
REM Creates a directory and enters it

set cwd=%cd%
REM Sets the new directory to the working directory

curl %ServerFile% --output "%cwd%\server.jar"
start server.jar
REM Downloads the server file and starts it

:FindEULA
if exist eula.txt goto SetTrue
goto FindEULA
REM Function to check if the EULA has been generated

:SetTrue
echo eula=true> eula.txt
java -Xmx8G -Xms2G -jar server.jar nogui
REM Sets the EULA to true and re-launches the server