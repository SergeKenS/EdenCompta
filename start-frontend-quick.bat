@echo off
echo ========================================
echo   EdenCompta POS - Demarrage Frontend Rapide
echo ========================================

echo.
echo Demarrage du frontend Flutter...
echo.

cd frontend

echo.
echo 1. Installation des dependances...
flutter pub get

echo.
echo 2. Generation des fichiers de code...
dart run build_runner build --delete-conflicting-outputs

echo.
echo 3. Demarrage de l'application Flutter Web...
echo L'application va s'ouvrir dans votre navigateur...
echo.

flutter run -d web --web-port 3000

pause
