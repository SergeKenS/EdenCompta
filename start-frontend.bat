@echo off
echo ========================================
echo   EdenCompta POS - Demarrage Frontend
echo ========================================

echo.
echo 1. Installation des dependances Flutter...
cd frontend
flutter pub get

echo.
echo 2. Generation des fichiers de code...
dart run build_runner build --delete-conflicting-outputs

echo.
echo 3. Demarrage de l'application Flutter Web...
echo L'application va s'ouvrir dans votre navigateur...
flutter run -d web

pause
