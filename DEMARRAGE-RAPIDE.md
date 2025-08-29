# ⚡ Démarrage Rapide - EdenCompta POS

## 🚀 **Solution immédiate (sans PostgreSQL)**

Si vous rencontrez l'erreur de connexion PostgreSQL, utilisez cette solution rapide :

### **1. Démarrer le Backend avec H2 (Base en mémoire)**
```bash
# Exécuter le script de démarrage H2
start-backend-h2.bat
```

**Ou manuellement :**
```bash
cd backend
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

### **2. Démarrer le Frontend**
```bash
# Dans un nouveau terminal
cd frontend
flutter pub get
flutter run -d web
```

## ✅ **Vérification du succès**

- **Backend :** `http://localhost:8080`
- **Console H2 :** `http://localhost:8080/h2-console`
- **Frontend :** `http://localhost:3000` (ou port assigné)

## 🔐 **Comptes de test disponibles**

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Super Admin** | `admin@pos.com` | `admin123` |
| **Manager** | `manager1@pos.com` | `admin123` |
| **Caissier** | `cashier1@pos.com` | `admin123` |

## 🎯 **Utilisation**

1. **Ouvrir** `http://localhost:3000` dans votre navigateur
2. **Choisir** "J'ai déjà un compte"
3. **Se connecter** avec `admin@pos.com` / `admin123`
4. **Explorer** l'application !

## 🔧 **Avantages de cette solution**

- ✅ **Démarrage immédiat** sans configuration PostgreSQL
- ✅ **Base de données en mémoire** (H2)
- ✅ **Données de test** préchargées
- ✅ **Console H2** pour inspecter la base
- ✅ **Pas d'installation** supplémentaire requise

## 📝 **Limitations**

- ❌ **Données perdues** au redémarrage (base en mémoire)
- ❌ **Pas de persistance** des données
- ❌ **Performance limitée** pour de gros volumes

## 🚀 **Pour la production**

Utilisez PostgreSQL avec Docker :
1. **Démarrer Docker Desktop**
2. **Exécuter** `start-backend.bat` (choisir option 1)
3. **Exécuter** `start-frontend.bat`

## 🆘 **En cas de problème**

1. **Vérifier Java 17+ :** `java -version`
2. **Vérifier Maven :** `mvn -version`
3. **Vérifier Flutter :** `flutter doctor`
4. **Nettoyer et relancer :**
   ```bash
   cd backend
   mvn clean
   mvn spring-boot:run -Dspring-boot.run.profiles=dev
   ```

---

**🎉 Votre application EdenCompta POS est maintenant fonctionnelle !**
