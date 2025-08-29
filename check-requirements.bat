@echo off
echo ========================================
echo  EdenCompta POS - Verification des Prerequis
echo ========================================

echo.
echo 1. Verification de Java...
java -version 2>nul
if %errorlevel% equ 0 (
    echo [OK] Java est installe
) else (
    echo [ERREUR] Java n'est pas installe ou pas dans le PATH
    echo Installez Java 17+ depuis : https://adoptium.net/
)

echo.
echo 2. Verification de Maven...
mvn -version 2>nul
if %errorlevel% equ 0 (
    echo [OK] Maven est installe
) else (
    echo [ERREUR] Maven n'est pas installe ou pas dans le PATH
    echo Installez Maven depuis : https://maven.apache.org/download.cgi
)

echo.
echo 3. Verification de Flutter...
flutter --version 2>nul
if %errorlevel% equ 0 (
    echo [OK] Flutter est installe
    flutter doctor
) else (
    echo [ERREUR] Flutter n'est pas installe ou pas dans le PATH
    echo Installez Flutter depuis : https://flutter.dev/docs/get-started/install
)

echo.
echo 4. Verification de PostgreSQL...
psql --version 2>nul
if %errorlevel% equ 0 (
    echo [OK] PostgreSQL est installe
) else (
    echo [ERREUR] PostgreSQL n'est pas installe ou pas dans le PATH
    echo Installez PostgreSQL depuis : https://www.postgresql.org/download/
)

echo.
echo 5. Verification de Docker (optionnel)...
docker --version 2>nul
if %errorlevel% equ 0 (
    echo [OK] Docker est installe
) else (
    echo [INFO] Docker n'est pas installe (optionnel pour PostgreSQL)
)

echo.
echo ========================================
echo Verification terminee
echo ========================================

pause
