@echo off

REM Sets the server file to download
set ServerFile="https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar"

REM Sets the maximum RAM for the server (4BG is default and recommended)
set MaxRam=4

REM Sets the minimum RAM for the server (2BG is default and recommended)
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
if exist start.bat goto SetTrue
echo @echo off> start.bat
echo java -Xmx%MaxRam%G -Xms%MinRam%G -jar server.jar nogui>> start.bat
echo exit>> start.bat
goto SetTrue

REM Sets the EULA to true and re-launches the server
:SetTrue
echo eula=true> eula.txt
java -Xmx8G -Xms2G -jar server.jar nogui