@echo off
echo ========================================
echo   EDENCOMPTA - Frontend Standalone
echo ========================================
echo.
echo Demarrage du frontend en mode standalone...
echo (Backend non requis)
echo.

cd frontend

echo Installation des dependances Flutter...
flutter pub get

if %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Impossible d'installer les dependances
    pause
    exit /b 1
)

echo.
echo Lancement de l'application...
echo.
echo Identifiants de test:
echo - Username: admin (ou n'importe quoi)
echo - Password: admin (ou n'importe quoi)
echo.
echo Appuyez sur Ctrl+C pour arreter l'application
echo.

flutter run

pause
