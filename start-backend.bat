@echo off
echo ========================================
echo   EdenCompta POS - Demarrage Backend
echo ========================================

echo.
echo Choisissez votre configuration PostgreSQL :
echo 1. PostgreSQL avec Docker
echo 2. PostgreSQL local
echo 3. PostgreSQL deja demarre (passer directement au backend)
echo.
set /p choice="Votre choix (1, 2, ou 3) : "

cd backend

if "%choice%"=="1" (
    echo.
    echo Demarrage de PostgreSQL avec Docker...
    docker-compose up -d
    
    echo.
    echo Attente de 10 secondes pour PostgreSQL...
    timeout /t 10 /nobreak >nul
    
    echo.
    echo Verification de PostgreSQL...
    docker-compose ps
) else if "%choice%"=="2" (
    echo.
    echo Verification de PostgreSQL local...
    echo Assurez-vous que PostgreSQL est demarre et que la base pos_db existe.
    echo Si ce n'est pas le cas, executez setup-database.bat d'abord.
    pause
) else (
    echo.
    echo PostgreSQL suppose deja demarre...
)

echo.
echo Demarrage du backend Spring Boot...
echo Le backend sera disponible sur http://localhost:8080
mvn spring-boot:run

pause
