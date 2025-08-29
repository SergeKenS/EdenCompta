# 🔧 Résolution de l'erreur de connexion PostgreSQL

## ❌ **Erreur rencontrée :**
```
Connection to localhost:5432 refused. Check that the hostname and port are correct and that the postmaster is accepting TCP/IP connections.
```

## 🔍 **Diagnostic :**
Le backend Spring Boot ne peut pas se connecter à PostgreSQL car :
1. ✅ **Docker** est installé (version 28.3.2)
2. ❌ **Docker Desktop** n'est pas démarré
3. ❌ **PostgreSQL** n'est pas installé localement

## 🚀 **Solutions disponibles :**

### **Option 1 : Démarrer Docker Desktop (Recommandé)**

1. **Ouvrir Docker Desktop**
   - Rechercher "Docker Desktop" dans le menu Démarrer
   - Ou double-cliquer sur l'icône Docker dans la barre des tâches

2. **Attendre que Docker Desktop soit prêt**
   - L'icône Docker doit être verte dans la barre des tâches
   - Cela peut prendre 1-2 minutes

3. **Vérifier que Docker fonctionne :**
   ```bash
   docker ps
   ```

4. **Démarrer PostgreSQL avec Docker :**
   ```bash
   cd backend
   docker-compose up -d
   ```

5. **Vérifier que PostgreSQL est démarré :**
   ```bash
   docker-compose ps
   ```

6. **Redémarrer le backend :**
   ```bash
   mvn spring-boot:run
   ```

### **Option 2 : Installer PostgreSQL localement**

Si vous préférez ne pas utiliser Docker :

1. **Télécharger PostgreSQL 15+ :**
   - Aller sur : https://www.postgresql.org/download/windows/
   - Télécharger la version 15 ou plus récente

2. **Installer PostgreSQL :**
   - Exécuter l'installateur
   - **IMPORTANT :** Noter le mot de passe de l'utilisateur `postgres`
   - Garder le port par défaut (5432)

3. **Configurer la base de données :**
   ```bash
   # Exécuter le script de configuration
   setup-database.bat
   ```

4. **Démarrer le backend :**
   ```bash
   cd backend
   mvn spring-boot:run
   ```

### **Option 3 : Utiliser H2 (Base de données en mémoire pour les tests)**

Pour un démarrage rapide sans PostgreSQL :

1. **Modifier la configuration :**
   Créer le fichier `backend/src/main/resources/application-dev.yml` :
   ```yaml
   spring:
     datasource:
       url: jdbc:h2:mem:testdb
       driver-class-name: org.h2.Driver
       username: sa
       password: 
     
     jpa:
       hibernate:
         ddl-auto: create-drop
       show-sql: true
     
     h2:
       console:
         enabled: true
         path: /h2-console
     
     flyway:
       enabled: false
   
   server:
     port: 8080
   ```

2. **Démarrer avec le profil dev :**
   ```bash
   cd backend
   mvn spring-boot:run -Dspring-boot.run.profiles=dev
   ```

## 🎯 **Solution recommandée :**

**Utilisez l'Option 1 (Docker Desktop)** car :
- ✅ Plus simple à configurer
- ✅ Pas d'installation locale requise
- ✅ Configuration identique à la production
- ✅ Base de données isolée

## 📋 **Étapes détaillées pour Docker Desktop :**

1. **Démarrer Docker Desktop**
2. **Attendre que l'icône soit verte**
3. **Exécuter :**
   ```bash
   cd backend
   docker-compose up -d
   docker-compose ps
   mvn spring-boot:run
   ```

## 🔍 **Vérification du succès :**

Une fois PostgreSQL démarré, vous devriez voir :
```
[INFO] Started PosApplication in X.XXX seconds
```

Et le backend sera accessible sur : `http://localhost:8080`

## 🆘 **Si le problème persiste :**

1. **Vérifier les logs Docker :**
   ```bash
   docker-compose logs postgres
   ```

2. **Redémarrer Docker Desktop complètement**

3. **Vérifier qu'aucun autre service n'utilise le port 5432 :**
   ```bash
   netstat -an | findstr 5432
   ```

4. **Utiliser l'Option 3 (H2) pour un démarrage rapide**
