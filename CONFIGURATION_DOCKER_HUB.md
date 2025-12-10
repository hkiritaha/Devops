# Configuration Docker Hub pour Jenkins

## 🔐 Informations nécessaires

- **Username Docker Hub** : `taha246`
- **Personal Access Token** : À obtenir sur https://hub.docker.com/settings/security

⚠️ **Le token ne doit JAMAIS être committé dans Git !**

---

## 📋 Configuration dans Jenkins

### Étape 1 : Créer le credential

1. Dans Jenkins, allez dans **Manage Jenkins** → **Credentials** → **System** → **Global credentials (unrestricted)**
2. Cliquez sur **Add Credentials**
3. Remplissez :
   - **Kind** : `Secret text`
   - **Secret** : Votre Personal Access Token Docker Hub
   - **ID** : `docker-hub-token` ⚠️ **IMPORTANT : Utilisez exactement cet ID**
   - **Description** : `Docker Hub Personal Access Token`
4. Cliquez sur **OK**

### Étape 2 : Vérifier

Le Jenkinsfile utilise automatiquement ce credential avec l'ID `docker-hub-token`.

---

## 🧪 Test de connexion manuel (optionnel)

Pour tester la connexion dans WSL :

```bash
# Méthode interactive
docker login -u taha246
# Entrez votre token quand demandé

# Méthode non-interactive
echo "VOTRE_TOKEN" | docker login -u taha246 --password-stdin
```

---

## ✅ Vérification après configuration

Une fois le credential configuré dans Jenkins, le pipeline :

1. ✅ Construira l'image Docker automatiquement
2. ✅ Se connectera à Docker Hub avec le token sécurisé
3. ✅ Poussera l'image vers Docker Hub

---

## 🔒 Sécurité

- ✅ Le token est stocké de manière sécurisée dans Jenkins Credentials
- ✅ Le token n'apparaît jamais dans les logs Jenkins (masqué automatiquement)
- ✅ Le token n'est jamais committé dans Git

---

## 📚 Documentation

Pour plus de détails sur l'installation Docker et l'intégration dans Jenkins, consultez les guides disponibles dans le projet.

