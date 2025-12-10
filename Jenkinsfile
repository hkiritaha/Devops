pipeline {
    agent any
    
    tools {
        maven "M2_HOME"
        jdk "JAVA_HOME"
    }
    
    environment {
        PROJECT_NAME = 'timesheet-devops'
        MAVEN_OPTS = '-Xmx1024m'
        BUILD_TIMESTAMP = "${new Date().format('yyyy-MM-dd HH:mm:ss')}"
        // Configuration Docker
        DOCKER_HUB_USER = 'taha246'
        DOCKER_IMAGE_NAME = 'timesheet-devops'
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
        DOCKER_IMAGE_FULL = "${DOCKER_HUB_USER}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
        DOCKER_IMAGE_LATEST = "${DOCKER_HUB_USER}/${DOCKER_IMAGE_NAME}:latest"
    }
    
    options {
        // Conserver les 10 derniers builds
        buildDiscarder(logRotator(numToKeepStr: '10'))
        // Afficher les timestamps dans les logs
        timestamps()
        // Timeout de 30 minutes pour le pipeline complet
        timeout(time: 30, unit: 'MINUTES')
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📥 Récupération du code source depuis Git (branche main)...'
                checkout scm
                script {
                    // Afficher les informations Git
                    env.GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    env.GIT_BRANCH = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
                    env.GIT_AUTHOR = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%an"').trim()
                    echo "📍 Branche: ${env.GIT_BRANCH}"
                    echo "🔖 Commit: ${env.GIT_COMMIT}"
                    echo "👤 Auteur: ${env.GIT_AUTHOR}"
                }
            }
        }
        
        stage('Environment Info') {
            steps {
                echo '🔍 Informations sur l\'environnement...'
                sh '''
                    echo "Java Version:"
                    java -version
                    echo ""
                    echo "Maven Version:"
                    mvn -version
                    echo ""
                    echo "Git Version:"
                    git --version
                    echo ""
                    echo "Docker Version:"
                    docker --version || echo "Docker non disponible"
                    echo ""
                    echo "Working Directory:"
                    pwd
                '''
            }
        }
        
        stage('Build') {
            steps {
                echo '🔨 Compilation du projet Maven...'
                sh "mvn clean compile -DskipTests"
            }
            post {
                success {
                    echo '✅ Compilation réussie!'
                }
                failure {
                    echo '❌ Échec de la compilation!'
                    error('La compilation a échoué')
                }
            }
        }
        
        stage('Test') {
            steps {
                echo '🧪 Exécution des tests...'
                sh "mvn test"
            }
            post {
                always {
                    script {
                        // Publier les résultats des tests seulement si les fichiers existent
                        try {
                            def reportFiles = sh(returnStdout: true, script: 'ls target/surefire-reports/*.xml 2>/dev/null || echo ""').trim()
                            if (reportFiles) {
                                echo "📊 Publication des rapports de tests..."
                                junit 'target/surefire-reports/*.xml'
                            } else {
                                echo "⚠️ Aucun rapport de test trouvé (les tests n'ont peut-être pas pu compiler)"
                            }
                        } catch (Exception e) {
                            echo "⚠️ Impossible de publier les rapports de tests: ${e.message}"
                        }
                    }
                }
                success {
                    echo '✅ Tous les tests sont passés!'
                }
                failure {
                    echo '❌ Certains tests ont échoué!'
                }
            }
        }
        
        stage('Package') {
            steps {
                echo '📦 Création du package JAR...'
                sh "mvn package -DskipTests"
            }
            post {
                success {
                    echo '✅ Package créé avec succès!'
                    script {
                        // Lister les artefacts créés
                        def jarFiles = sh(returnStdout: true, script: 'find target -name "*.jar" -type f').trim()
                        echo "📦 Artefacts créés:\n${jarFiles}"
                    }
                }
                failure {
                    echo '❌ Échec de la création du package!'
                }
            }
        }
        
        stage('Docker Build & Push') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo '🐳 Construction de l\'image Docker...'
                script {
                    // Vérifier que Docker est disponible
                    sh 'docker --version'
                    
                    // Construire l'image Docker
                    echo "🔨 Build de l'image: ${env.DOCKER_IMAGE_FULL}"
                    sh "docker build -t ${env.DOCKER_IMAGE_FULL} -t ${env.DOCKER_IMAGE_LATEST} ."
                    
                    // Lister les images créées
                    sh 'docker images | grep timesheet-devops'
                }
            }
            post {
                success {
                    echo '✅ Image Docker construite avec succès!'
                }
                failure {
                    echo '❌ Échec de la construction de l\'image Docker!'
                }
            }
        }
        
        stage('Docker Login & Push') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo '🔐 Connexion à Docker Hub...'
                script {
                    // Se connecter à Docker Hub avec le token
                    // Le token est passé via les credentials Jenkins (ID: docker-hub-token)
                    withCredentials([string(credentialsId: 'docker-hub-token', variable: 'DOCKER_TOKEN')]) {
                        sh "echo ${DOCKER_TOKEN} | docker login -u ${env.DOCKER_HUB_USER} --password-stdin"
                    }
                    
                    // Push l'image avec le tag du build
                    echo "📤 Push de l'image: ${env.DOCKER_IMAGE_FULL}"
                    sh "docker push ${env.DOCKER_IMAGE_FULL}"
                    
                    // Push l'image avec le tag latest
                    echo "📤 Push de l'image latest: ${env.DOCKER_IMAGE_LATEST}"
                    sh "docker push ${env.DOCKER_IMAGE_LATEST}"
                    
                    echo "✅ Images poussées vers Docker Hub:"
                    echo "   - ${env.DOCKER_IMAGE_FULL}"
                    echo "   - ${env.DOCKER_IMAGE_LATEST}"
                    echo "   URL: https://hub.docker.com/r/${env.DOCKER_HUB_USER}/${env.DOCKER_IMAGE_NAME}"
                }
            }
            post {
                success {
                    echo '✅ Images Docker poussées vers Docker Hub avec succès!'
                }
                failure {
                    echo '❌ Échec du push vers Docker Hub!'
                }
            }
        }
        
        stage('Archive Artifacts') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo '💾 Archivage des artefacts...'
                script {
                    // Archiver le JAR principal
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
        
        stage('Build Summary') {
            steps {
                echo '📊 Résumé du build...'
                script {
                    def buildInfo = """
                    ╔═══════════════════════════════════════════════════════╗
                    ║           RÉSUMÉ DU BUILD                             ║
                    ╠═══════════════════════════════════════════════════════╣
                    ║ Projet      : ${env.PROJECT_NAME}                    ║
                    ║ Build #     : ${env.BUILD_NUMBER}                   ║
                    ║ Branche     : ${env.GIT_BRANCH}                     ║
                    ║ Commit      : ${env.GIT_COMMIT}                     ║
                    ║ Auteur      : ${env.GIT_AUTHOR}                     ║
                    ║ Timestamp   : ${env.BUILD_TIMESTAMP}                ║
                    ║ Statut      : ${currentBuild.currentResult}        ║
                    ╚═══════════════════════════════════════════════════════╝
                    """
                    echo buildInfo
                }
            }
        }
    }
    
    post {
        always {
            echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
            echo "🏁 Pipeline terminé - Build #${env.BUILD_NUMBER}"
            echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        }
        success {
            echo '✅ ✅ ✅ BUILD RÉUSSI! ✅ ✅ ✅'
            echo "📦 Artefacts disponibles dans: ${env.BUILD_URL}artifact/"
            echo "🐳 Image Docker disponible sur Docker Hub:"
            echo "   - ${env.DOCKER_IMAGE_FULL}"
            echo "   - ${env.DOCKER_IMAGE_LATEST}"
            echo "   URL: https://hub.docker.com/r/${env.DOCKER_HUB_USER}/${env.DOCKER_IMAGE_NAME}"
            script {
                // Notification de succès (peut être étendu avec email, Slack, etc.)
                currentBuild.description = "✅ Succès - Commit: ${env.GIT_COMMIT} - Docker: ${env.DOCKER_IMAGE_FULL}"
            }
        }
        failure {
            echo '❌ ❌ ❌ BUILD ÉCHOUÉ! ❌ ❌ ❌'
            echo '📋 Consultez les logs pour plus de détails'
            script {
                currentBuild.description = "❌ Échec - Commit: ${env.GIT_COMMIT}"
            }
        }
        unstable {
            echo '⚠️ ⚠️ ⚠️ BUILD INSTABLE! ⚠️ ⚠️ ⚠️'
            script {
                currentBuild.description = "⚠️ Instable - Commit: ${env.GIT_COMMIT}"
            }
        }
    }
}
