@echo off
echo ========================================
echo   EdenCompta POS - Demarrage Backend Corrige
echo ========================================

echo.
echo Changement vers le repertoire backend...
cd backend

echo.
echo Nettoyage du projet...
mvn clean

echo.
echo Compilation du projet...
mvn compile

echo.
echo Demarrage du backend avec H2...
echo Le backend sera disponible sur http://localhost:8080
echo.

mvn spring-boot:run -Dspring-boot.run.profiles=dev

pause
