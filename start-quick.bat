@echo off
echo ========================================
echo   EdenCompta POS - Demarrage Rapide Complet
echo ========================================

echo.
echo Cette solution utilise H2 (base en memoire) pour un demarrage immediat.
echo.

echo Demarrage du backend avec H2...
cd backend
start "Backend-H2" cmd /k "mvn spring-boot:run -Dspring-boot.run.profiles=dev"

echo.
echo Attente de 30 secondes pour le backend...
timeout /t 30 /nobreak >nul

echo.
echo Demarrage du frontend Flutter...
cd ..\frontend
start "Frontend-Flutter" cmd /k "flutter run -d chrome --web-port 3001"

echo.
echo ========================================
echo   Demarrage en cours !
echo ========================================
echo.
echo URLs importantes :
echo - Frontend : http://localhost:3001
echo - Backend API : http://localhost:8080/api
echo - Console H2 : http://localhost:8080/h2-console
echo.
echo Comptes de test :
echo - Super Admin : admin / admin123
echo - Manager : manager1 / admin123
echo - Caissier : cashier1 / admin123
echo.
echo Les fenetres de terminal vont s'ouvrir automatiquement.
echo Attendez que les services soient completement demarres.
echo.

pause
