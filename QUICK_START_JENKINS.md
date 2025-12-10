# Guide de Démarrage Rapide - Jobs Jenkins dans WSL

## 🚀 Création rapide d'un Job Freestyle

### 1. Créer le job
- **Tableau de bord** → **"+ Nouveau Item"**
- **Nom** : `JobFree`
- **Type** : **"Construire un projet free-style"**
- **OK**

### 2. Configurer Git
- **Gestion de code source** → **Git**
- **Repository URL** : `https://github.com/mhassini/avec-maven.git`
- **Branches** : `*/main`

### 3. Configurer le build
- **Étapes du build** → **"Ajouter une étape"** → **"Exécuter un script shell"**
- **Commande** :
  ```bash
  mvn -version
  ```

### 4. Sauvegarder et lancer
- **Enregistrer**
- **Lancer un build**

---

## 🚀 Création rapide d'un Job Pipeline

### 1. Créer le job
- **Tableau de bord** → **"+ Nouveau Item"**
- **Nom** : `JobPipeline`
- **Type** : **"Pipeline"**
- **OK**

### 2. Configuration simple (Script direct)

**Option A : Hello World**
```groovy
pipeline {
    agent any
    stages {
        stage("Hello") {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

**Option B : Avec Maven**
```groovy
pipeline {
    agent any
    tools {
        maven "M2_HOME"
    }
    stages {
        stage('Build') {
            steps {
                sh "mvn -version"
            }
        }
    }
}
```

### 3. Configuration avec Jenkinsfile (Recommandé)

1. **Dans la configuration** :
   - **Definition** : **"Pipeline script from SCM"**
   - **SCM** : **"Git"**
   - **Repository URL** : URL de votre dépôt
   - **Script Path** : `Jenkinsfile`

2. **Le Jenkinsfile doit être dans votre dépôt Git**

### 4. Sauvegarder et lancer
- **Enregistrer**
- **Lancer un build**

---

## 📋 Commandes utiles

### Vérifications dans WSL
```bash
# Vérifier Jenkins
sudo systemctl status jenkins

# Vérifier Java
java -version
echo $JAVA_HOME

# Vérifier Maven
mvn -version
echo $M2_HOME

# Vérifier Git
git --version
```

### Redémarrer Jenkins
```bash
sudo systemctl restart jenkins
```

### Accéder à Jenkins
- **URL** : `http://localhost:8080`
- Si ça ne fonctionne pas, configurez le port forwarding (voir guide complet)

---

## 🔧 Déclenchement à distance

1. **Dans la configuration du job** :
   - **Ce qui déclenche le build** → **"Déclencher les builds à distance"**
   - **Jeton** : `my-token`

2. **URL pour déclencher** :
   ```
   http://localhost:8080/job/JobPipeline/build?token=my-token
   ```

3. **Tester** :
   - Ouvrez cette URL dans votre navigateur
   - Ou utilisez : `curl http://localhost:8080/job/JobPipeline/build?token=my-token`

---

## ✅ Checklist de configuration

- [ ] Jenkins installé et démarré
- [ ] JDK 17 configuré dans Jenkins (Tools → JAVA_HOME)
- [ ] Maven configuré dans Jenkins (Tools → M2_HOME)
- [ ] Git installé
- [ ] Job créé et configuré
- [ ] Build testé avec succès

---

## 🆘 Problèmes courants

### Jenkins non accessible
```powershell
# Dans PowerShell (admin)
netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=8080 connectaddress=172.x.x.x
```

### Maven non trouvé
- Vérifiez dans **Administrer Jenkins > Tools** que M2_HOME = `/usr/share/maven`

### Git erreur
- Vérifiez l'URL du dépôt
- Pour un dépôt privé, configurez les credentials

---

Pour plus de détails, consultez `GUIDE_JOBS_JENKINS_WSL.md`

