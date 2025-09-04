@echo off
echo ========================================
echo   EdenCompta POS - Demarrage Backend Simple
echo ========================================

echo.
echo Nettoyage du projet...
cd backend
mvn clean

echo.
echo Demarrage du backend avec H2...
echo Le backend sera disponible sur http://localhost:8080
echo.

mvn spring-boot:run -Dspring-boot.run.profiles=dev

pause

