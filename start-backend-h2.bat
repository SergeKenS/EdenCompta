@echo off
echo ========================================
echo   EdenCompta POS - Demarrage Backend (H2)
echo ========================================

echo.
echo Demarrage du backend avec base de donnees H2 en memoire...
echo Cette option permet un demarrage rapide sans PostgreSQL.
echo.

cd backend

echo.
echo Demarrage du backend Spring Boot avec profil 'dev'...
echo Le backend sera disponible sur http://localhost:8080
echo La console H2 sera disponible sur http://localhost:8080/h2-console
echo.

mvn spring-boot:run -Dspring-boot.run.profiles=dev

pause
