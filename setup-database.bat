@echo off
echo ========================================
echo  EdenCompta POS - Configuration Base de Donnees
echo ========================================

echo.
echo IMPORTANT : Assurez-vous d'avoir PostgreSQL installe localement
echo.
echo Si PostgreSQL n'est pas installe, telechargez-le depuis :
echo https://www.postgresql.org/download/windows/
echo.
echo Configuration requise :
echo - Version : PostgreSQL 15+
echo - Port : 5432 (par defaut)
echo - Superuser : postgres (par defaut)
echo.

echo Appuyez sur une touche pour continuer avec la configuration...
pause >nul

echo.
echo ========================================
echo Creation de la base de donnees et utilisateur
echo ========================================

echo.
echo Connexion a PostgreSQL en tant que superuser...
echo (Vous devrez entrer le mot de passe de l'utilisateur postgres)

psql -U postgres -h localhost -p 5432 -c "CREATE DATABASE pos_db;"
psql -U postgres -h localhost -p 5432 -c "CREATE USER pos_user WITH PASSWORD 'pos_password';"
psql -U postgres -h localhost -p 5432 -c "GRANT ALL PRIVILEGES ON DATABASE pos_db TO pos_user;"
psql -U postgres -h localhost -p 5432 -c "ALTER USER pos_user CREATEDB;"

echo.
echo ========================================
echo Configuration terminee !
echo ========================================

echo.
echo Informations de connexion :
echo - Base de donnees : pos_db
echo - Utilisateur : pos_user
echo - Mot de passe : pos_password
echo - Host : localhost
echo - Port : 5432
echo.

pause

