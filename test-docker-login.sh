#!/bin/bash

# Script de test pour vérifier la connexion Docker Hub
# Usage: ./test-docker-login.sh
#
# ⚠️ IMPORTANT : Remplacez VOTRE_TOKEN_ICI par votre Personal Access Token Docker Hub
# Vous pouvez obtenir votre token sur : https://hub.docker.com/settings/security

echo "🔐 Test de connexion à Docker Hub..."
echo ""

# Configuration
DOCKER_USERNAME="taha246"
DOCKER_TOKEN="VOTRE_TOKEN_ICI"  # ⚠️ Remplacez par votre token

# Vérifier que le token a été remplacé
if [ "$DOCKER_TOKEN" = "VOTRE_TOKEN_ICI" ]; then
    echo "❌ ERREUR : Veuillez remplacer VOTRE_TOKEN_ICI par votre token Docker Hub"
    echo "   Éditez ce fichier et remplacez VOTRE_TOKEN_ICI par votre token"
    exit 1
fi

# Se connecter à Docker Hub
echo "Username: ${DOCKER_USERNAME}"
echo "Connexion en cours..."
echo ""

# Commande de connexion non-interactive
echo "${DOCKER_TOKEN}" | docker login -u "${DOCKER_USERNAME}" --password-stdin

if [ $? -eq 0 ]; then
    echo "✅ Connexion réussie à Docker Hub!"
    echo ""
    echo "Vous pouvez maintenant :"
    echo "  - Construire des images Docker"
    echo "  - Pousser des images vers Docker Hub"
else
    echo "❌ Échec de la connexion"
    exit 1
fi

