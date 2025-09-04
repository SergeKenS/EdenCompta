@echo off
echo ========================================
echo   EdenCompta POS - Demarrage Backend Java Direct
echo ========================================

echo.
echo Compilation du projet...
cd backend
mvn clean compile

echo.
echo Demarrage avec Java direct...
echo.

java -cp "target/classes;target/dependency/*" -Dspring.profiles.active=dev com.votreentreprise.pos.PosApplication

pause

