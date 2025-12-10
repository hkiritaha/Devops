# Guide Complet : Création de Jobs Jenkins dans WSL

## Table des matières
1. [Création d'un Job Freestyle](#1-création-dun-job-freestyle)
2. [Configuration d'un Job Freestyle](#2-configuration-dun-job-freestyle)
3. [Création d'un Job Pipeline](#3-création-dun-job-pipeline)
4. [Configuration d'un Job Pipeline](#4-configuration-dun-job-pipeline)

---

## 1. Création d'un Job Freestyle

### Étape 1.1 : Accéder à Jenkins

1. Ouvrez votre navigateur Windows
2. Accédez à : `http://localhost:8080`
3. Connectez-vous avec vos identifiants Jenkins

### Étape 1.2 : Créer un nouveau job

1. Sur le tableau de bord Jenkins, cliquez sur **"+ Nouveau Item"** (New Item) dans le menu de gauche
2. Dans la page qui s'affiche :
   - **Saisissez un nom** : Donnez un nom à votre job (exemple : `JobFree`)
   - **Sélectionnez le type** : Choisissez **"Construire un projet free-style"** (Build a free-style project)
3. Cliquez sur **"OK"**

---

## 2. Configuration d'un Job Freestyle

### Étape 2.1 : Section Générale

1. Dans la page de configuration, vous verrez plusieurs sections
2. **Section "Général"** :
   - **Description** : Vous pouvez ajouter une description du projet (optionnel)
   - **Options disponibles** :
     - ☐ Ce build a des paramètres ?
     - ☐ GitHub project
     - ☐ Supprimer les anciens builds ?
     - ☐ Throttle builds ?
     - ☐ Exécuter des builds simultanément si nécessaire ?

### Étape 2.2 : Configuration de Git (Gestion de code source)

#### Option A : Utiliser un dépôt Git public

1. Dans la section **"Gestion de code source"**, sélectionnez **"Git"**
2. **Repositories** :
   - **Repository URL** : Entrez l'URL de votre dépôt Git
     - Exemple : `https://github.com/mhassini/avec-maven.git`
   - **Credentials** : Laissez **"- aucun -"** pour un dépôt public
   - **Branches to build** : `*/main` (ou la branche de votre choix)

#### Option B : Utiliser un dépôt Git privé

1. **Créer des identifiants** :
   - Allez dans : **Tableau de bord > Identifiants > Système > Identifiants globaux**
   - Cliquez sur **"+ Ajouter"**
   - Ajoutez votre nom d'utilisateur et mot de passe GitHub (ou un Personal Access Token)

2. **Configurer le job** :
   - Dans **"Gestion de code source"**, sélectionnez **"Git"**
   - **Repository URL** : Entrez l'URL de votre dépôt privé
   - **Credentials** : Sélectionnez les identifiants créés précédemment

#### Comment obtenir l'URL Git depuis GitHub

1. Allez sur votre dépôt GitHub
2. Cliquez sur le bouton vert **"Code"**
3. Sélectionnez l'onglet **"HTTPS"**
4. Copiez l'URL affichée (exemple : `https://github.com/username/repository.git`)

### Étape 2.3 : Configuration des déclencheurs de build

Dans la section **"Ce qui déclenche le build"**, vous avez plusieurs options :

#### Option 1 : Build périodique (cron)

1. Cochez **"Construire périodiquement"**
2. Dans le champ **"Planning"**, entrez une expression cron :
   - Exemple : `H/5 * * * *` (toutes les 5 minutes)
   - Exemple : `H * * * *` (toutes les heures)
   - Exemple : `H 2 * * *` (tous les jours à 2h du matin)

**Format cron** : `MINUTE HOUR DAY MONTH DAY_OF_WEEK`
- `H` = valeur aléatoire pour distribuer la charge
- `*` = toutes les valeurs

#### Option 2 : Poll SCM (Scrutation du dépôt)

1. Cochez **"Scrutation de l'outil de gestion de version"**
2. Entrez une expression cron pour vérifier les changements dans Git

#### Option 3 : Déclenchement à distance

1. Cochez **"Déclencher les builds à distance"**
2. Entrez un **"Jeton d'authentification"** (exemple : `my-token`)
3. URL pour déclencher : 
   ```
   http://localhost:8080/job/JobFree/build?token=my-token
   ```

### Étape 2.4 : Configuration des étapes de build

Dans la section **"Étapes du build"**, cliquez sur **"Ajouter une étape au build"**

#### Exemple 1 : Script Shell simple

1. Sélectionnez **"Exécuter un script shell"**
2. Dans le champ **"Commande"**, entrez :
   ```bash
   echo "c'est mon premier job freestyle Jenkins!"
   echo "Date: $(date)"
   ```

#### Exemple 2 : Vérifier l'installation de Maven

1. Sélectionnez **"Exécuter un script shell"**
2. Dans le champ **"Commande"**, entrez :
   ```bash
   mvn -version
   ```

#### Exemple 3 : Compiler un projet Maven

1. Sélectionnez **"Invoquer les cibles Maven de haut niveau"**
2. **Maven Version** : Sélectionnez `M2_HOME` (configuré précédemment)
3. **Goals** : Entrez `clean compile`
   - Autres options : `clean test`, `clean package`, `clean install`

#### Exemple 4 : Script Shell avec Maven

1. Sélectionnez **"Exécuter un script shell"**
2. Dans le champ **"Commande"**, entrez :
   ```bash
   mvn clean compile
   mvn test
   ```

### Étape 2.5 : Actions post-build (optionnel)

Dans la section **"Actions à la suite du build"**, vous pouvez ajouter :

- **Archiver les artefacts** : Pour sauvegarder les fichiers générés
- **Publier les résultats des tests** : Pour afficher les résultats des tests
- **Envoyer un e-mail** : Pour notifier par email

### Étape 2.6 : Sauvegarder la configuration

1. Cliquez sur **"Enregistrer"** en bas de la page
2. Vous serez redirigé vers la page du job

---

## 3. Exécution et visualisation des résultats (Job Freestyle)

### Étape 3.1 : Lancer un build manuellement

1. Sur la page du job, cliquez sur **"Lancer un build"** (Build Now)
2. Le build apparaîtra dans **"Historique des builds"**

### Étape 3.2 : Consulter les résultats

1. **Statut du build** :
   - ✅ **Icône verte** = Build réussi
   - ❌ **Icône rouge** = Build échoué
   - ⚠️ **Icône jaune** = Build instable

2. **Cliquer sur un build** pour voir les détails :
   - **État** : Vue d'ensemble du build
   - **Sortie de la console** : Logs détaillés de l'exécution
   - **Modifications** : Changements Git détectés
   - **Informations de la construction** : Métadonnées du build

### Étape 3.3 : Analyser les erreurs

Si le build échoue :

1. Cliquez sur le build échoué
2. Allez dans **"Sortie de la console"**
3. Lisez les messages d'erreur pour identifier le problème
4. Corrigez la configuration et relancez

**Erreurs courantes** :
- **Erreur Git** : Vérifiez l'URL du dépôt et les credentials
- **Erreur Maven** : Vérifiez que Maven est configuré dans Jenkins
- **Erreur de compilation** : Vérifiez les erreurs dans les logs

---

## 4. Création d'un Job Pipeline

### Étape 4.1 : Créer un nouveau job Pipeline

1. Sur le tableau de bord, cliquez sur **"+ Nouveau Item"**
2. **Saisissez un nom** : `JobPipeline` (ou un nom de votre choix)
3. **Sélectionnez le type** : **"Pipeline"**
4. Cliquez sur **"OK"**

### Étape 4.2 : Configuration du Pipeline - Script direct

Dans la section **"Definition"**, sélectionnez **"Pipeline script"**

#### Exemple 1 : Hello World

Dans le champ **"Script"**, entrez :

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

- Cochez **"Use Groovy Sandbox"** (recommandé)
- Cliquez sur **"Enregistrer"**

#### Exemple 2 : Récupération depuis Git

```groovy
pipeline {
    agent any
    tools {
        maven "M2_HOME"
    }
    stages {
        stage('GIT') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/mhassini/avec-maven.git'
            }
        }
    }
}
```

**Pour un dépôt privé**, ajoutez `credentialsId` :

```groovy
pipeline {
    agent any
    tools {
        maven "M2_HOME"
    }
    stages {
        stage('GIT') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/username/repo.git',
                    credentialsId: 'votre-credential-id'
            }
        }
    }
}
```

#### Exemple 3 : Exécution de commandes Maven

```groovy
pipeline {
    agent any
    tools {
        maven "M2_HOME"
    }
    stages {
        stage('MAVEN') {
            steps {
                sh "mvn -version"
            }
        }
        stage('BUILD') {
            steps {
                sh "mvn clean compile"
            }
        }
        stage('TEST') {
            steps {
                sh "mvn test"
            }
        }
    }
}
```

#### Exemple 4 : Pipeline complet avec plusieurs étapes

```groovy
pipeline {
    agent any
    tools {
        maven "M2_HOME"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/mhassini/avec-maven.git'
            }
        }
        stage('Build') {
            steps {
                sh "mvn clean compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        stage('Package') {
            steps {
                sh "mvn package"
            }
        }
    }
    post {
        success {
            echo 'Build réussi!'
        }
        failure {
            echo 'Build échoué!'
        }
    }
}
```

### Étape 4.3 : Configuration du Pipeline - Depuis Jenkinsfile

#### Étape 4.3.1 : Créer un Jenkinsfile dans votre dépôt Git

1. **Dans WSL**, clonez votre dépôt :
   ```bash
   git clone https://github.com/votre-username/votre-repo.git
   cd votre-repo
   ```

2. **Créer le Jenkinsfile** :
   ```bash
   nano Jenkinsfile
   ```

3. **Ajouter le contenu du pipeline** (exemple) :
   ```groovy
   pipeline {
       agent any
       tools {
           maven "M2_HOME"
       }
       stages {
           stage('Checkout') {
               steps {
                   checkout scm
               }
           }
           stage('Build') {
               steps {
                   sh "mvn clean compile"
               }
           }
           stage('Test') {
               steps {
                   sh "mvn test"
               }
           }
       }
   }
   ```

4. **Sauvegarder et commiter** :
   ```bash
   git add Jenkinsfile
   git commit -m "Add Jenkinsfile"
   git push origin main
   ```

#### Étape 4.3.2 : Configurer Jenkins pour utiliser le Jenkinsfile

1. Dans la configuration du job Pipeline, sélectionnez **"Pipeline script from SCM"**
2. **SCM** : Sélectionnez **"Git"**
3. **Repositories** :
   - **Repository URL** : `https://github.com/votre-username/votre-repo.git`
   - **Credentials** : Sélectionnez vos identifiants (si privé)
   - **Branches to build** : `*/main`
4. **Script Path** : `Jenkinsfile` (nom du fichier dans le dépôt)
5. Cliquez sur **"Enregistrer"**

---

## 5. Déclenchement des builds

### Méthode 1 : Déclenchement manuel

1. Sur la page du job, cliquez sur **"Lancer un build"**

### Méthode 2 : Déclenchement périodique

Dans la configuration du job :
1. Section **"Ce qui déclenche le build"**
2. Cochez **"Construire périodiquement"**
3. Entrez une expression cron (exemple : `H/5 * * * *` pour toutes les 5 minutes)

### Méthode 3 : Déclenchement à distance

1. Dans la configuration du job, section **"Ce qui déclenche le build"**
2. Cochez **"Déclencher les builds à distance"**
3. Entrez un **"Jeton d'authentification"** (exemple : `pipeline-jenkinsfile-token`)
4. **URL pour déclencher** :
   ```
   http://localhost:8080/job/JobPipeline/build?token=pipeline-jenkinsfile-token
   ```
   - Remplacez `JobPipeline` par le nom de votre job
   - Remplacez `pipeline-jenkinsfile-token` par votre jeton

5. **Utilisation** :
   - Ouvrez cette URL dans votre navigateur
   - Ou utilisez `curl` :
     ```bash
     curl http://localhost:8080/job/JobPipeline/build?token=pipeline-jenkinsfile-token
     ```

### Méthode 4 : Webhooks GitHub (avancé)

1. Dans GitHub, allez dans **Settings > Webhooks** de votre dépôt
2. Ajoutez une URL webhook :
   ```
   http://votre-ip-wsl:8080/github-webhook/
   ```
3. Configurez Jenkins pour écouter les webhooks

---

## 6. Visualisation des résultats Pipeline

### Vue Pipeline

1. Sur la page du job Pipeline, vous verrez une **vue graphique** du pipeline
2. Chaque **stage** est représenté par un bloc
3. Les couleurs indiquent le statut :
   - 🟢 **Vert** = Succès
   - 🔴 **Rouge** = Échec
   - 🟡 **Jaune** = En cours

### Console Output

1. Cliquez sur un build
2. Allez dans **"Sortie de la console"**
3. Vous verrez les logs détaillés de chaque stage

---

## 7. Bonnes pratiques

### Pour les Jobs Freestyle

- ✅ Utilisez des noms de jobs descriptifs
- ✅ Ajoutez des descriptions
- ✅ Configurez la suppression automatique des anciens builds
- ✅ Archivez les artefacts importants
- ✅ Configurez des notifications par email

### Pour les Jobs Pipeline

- ✅ Stockez le pipeline dans un Jenkinsfile (version control)
- ✅ Utilisez des stages clairs et descriptifs
- ✅ Ajoutez des étapes de test
- ✅ Gérez les erreurs avec `post { failure { ... } }`
- ✅ Utilisez des variables d'environnement pour la configuration

---

## 8. Dépannage

### Problème : Build échoue avec erreur Git

**Solution** :
- Vérifiez l'URL du dépôt
- Vérifiez les credentials si le dépôt est privé
- Testez l'accès au dépôt depuis WSL :
  ```bash
  git clone https://github.com/username/repo.git
  ```

### Problème : Maven n'est pas trouvé

**Solution** :
- Vérifiez que Maven est configuré dans Jenkins :
  - **Administrer Jenkins > Tools**
  - Vérifiez que `M2_HOME` est configuré avec le chemin : `/usr/share/maven`
- Vérifiez dans WSL :
  ```bash
  echo $M2_HOME
  mvn -version
  ```

### Problème : Java n'est pas trouvé

**Solution** :
- Vérifiez que JDK est configuré dans Jenkins :
  - **Administrer Jenkins > Tools**
  - Vérifiez que `JAVA_HOME` est configuré avec le chemin : `/usr/lib/jvm/java-17-openjdk-amd64`
- Vérifiez dans WSL :
  ```bash
  echo $JAVA_HOME
  java -version
  ```

### Problème : Jenkins n'est pas accessible depuis Windows

**Solution** :
1. Vérifiez l'IP de WSL :
   ```bash
   ip addr show
   ```
2. Configurez le port forwarding dans PowerShell (admin) :
   ```powershell
   netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=8080 connectaddress=172.x.x.x
   ```
   (Remplacez `172.x.x.x` par l'IP de votre WSL)

---

## 9. Commandes utiles WSL

```bash
# Vérifier le statut de Jenkins
sudo systemctl status jenkins

# Redémarrer Jenkins
sudo systemctl restart jenkins

# Voir les logs de Jenkins
sudo tail -f /var/log/jenkins/jenkins.log

# Vérifier les variables d'environnement
echo $JAVA_HOME
echo $M2_HOME

# Tester l'accès Git
git --version

# Tester Maven
mvn -version

# Tester Java
java -version
```

---

## 10. Exemples complets

### Exemple complet : Job Freestyle avec Maven

**Configuration** :
- **Git** : `https://github.com/mhassini/avec-maven.git`
- **Branche** : `main`
- **Déclencheur** : Build périodiquement (`H/5 * * * *`)
- **Build Step** : Invoquer les cibles Maven de haut niveau
  - **Goals** : `clean compile test package`

### Exemple complet : Pipeline avec plusieurs stages

```groovy
pipeline {
    agent any
    tools {
        maven "M2_HOME"
    }
    environment {
        PROJECT_NAME = 'timesheet-devops'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/username/repo.git'
            }
        }
        stage('Build') {
            steps {
                sh "mvn clean compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        stage('Package') {
            steps {
                sh "mvn package"
            }
        }
    }
    post {
        success {
            echo "Build réussi pour ${env.PROJECT_NAME}!"
        }
        failure {
            echo "Build échoué pour ${env.PROJECT_NAME}!"
        }
        always {
            echo "Build terminé."
        }
    }
}
```

---

**Félicitations !** Vous savez maintenant créer et configurer des jobs Jenkins dans WSL. 🎉

