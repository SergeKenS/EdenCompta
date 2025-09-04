@echo off
echo ========================================
echo     EdenCompta POS - Demarrage Complet
echo ========================================

echo.
echo Demarrage de la base de donnees PostgreSQL...
cd backend
start "PostgreSQL" cmd /k "docker-compose up"

echo.
echo Attente de 15 secondes pour PostgreSQL...
timeout /t 15 /nobreak >nul

echo.
echo Demarrage du backend Spring Boot...
start "Backend-SpringBoot" cmd /k "mvn spring-boot:run"

echo.
echo Attente de 30 secondes pour le backend...
timeout /t 30 /nobreak >nul

echo.
echo Demarrage du frontend Flutter...
cd ..\frontend
start "Frontend-Flutter" cmd /k "flutter run -d web"

echo.
echo ========================================
echo   Tous les services sont en cours de demarrage !
echo ========================================
echo.
echo URLs importantes :
echo - Frontend : http://localhost:3000 (ou port assigne par Flutter)
echo - Backend API : http://localhost:8080/api
echo - API Docs : http://localhost:8080/swagger-ui/index.html
echo.
echo Comptes de test :
echo - Super Admin : admin@pos.com / admin123
echo - Manager : manager1@pos.com / admin123
echo - Caissier : cashier1@pos.com / admin123
echo.
pause

