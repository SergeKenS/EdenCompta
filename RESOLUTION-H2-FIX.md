# 🔧 Résolution du problème H2 Driver

## ❌ **Erreur rencontrée :**
```
java.lang.ClassNotFoundException: org.h2.Driver
```

## 🔍 **Cause du problème :**
La dépendance H2 dans le `pom.xml` avait le scope `test`, ce qui la rendait indisponible pour le profil `dev`.

## ✅ **Solution appliquée :**

### **1. Modification du pom.xml**
```xml
<!-- AVANT (problématique) -->
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>test</scope>  <!-- ❌ Disponible seulement pour les tests -->
</dependency>

<!-- APRÈS (corrigé) -->
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>runtime</scope>  <!-- ✅ Disponible pour l'exécution -->
</dependency>
```

### **2. Nettoyage et redémarrage**
```bash
cd backend
mvn clean
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

## 🚀 **Scripts de démarrage disponibles :**

| Script | Description | Usage |
|--------|-------------|-------|
| `start-backend-simple.bat` | **Démarrage simple avec nettoyage** | Solution recommandée |
| `start-backend-h2.bat` | Démarrage H2 standard | Si le nettoyage n'est pas nécessaire |
| `start-quick.bat` | Démarrage complet automatique | Backend + Frontend |

## 🎯 **Utilisation recommandée :**

1. **Exécuter :** `start-backend-simple.bat`
2. **Attendre** que le backend démarre (voir les logs)
3. **Vérifier** sur `http://localhost:8080/actuator/health`
4. **Démarrer le frontend** avec `start-frontend-quick.bat`

## 🔍 **Vérification du succès :**

Le backend est démarré quand vous voyez :
```
[INFO] Started PosApplication in X.XXX seconds
```

Et ces URLs sont accessibles :
- **Backend :** `http://localhost:8080`
- **Console H2 :** `http://localhost:8080/h2-console`
- **Health Check :** `http://localhost:8080/actuator/health`

## 🆘 **Si le problème persiste :**

1. **Vérifier Java 17+ :** `java -version`
2. **Vérifier Maven :** `mvn -version`
3. **Nettoyer complètement :**
   ```bash
   cd backend
   mvn clean
   mvn dependency:resolve
   mvn spring-boot:run -Dspring-boot.run.profiles=dev
   ```

## 📝 **Configuration H2 utilisée :**

Le profil `dev` utilise cette configuration dans `application-dev.yml` :
```yaml
spring:
  datasource:
    url: jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE;MODE=PostgreSQL
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
```

## 🎉 **Résultat attendu :**

- ✅ Backend Spring Boot démarré sur port 8080
- ✅ Base de données H2 en mémoire avec données de test
- ✅ Console H2 accessible pour inspecter la base
- ✅ API REST fonctionnelle
- ✅ Authentification JWT opérationnelle
