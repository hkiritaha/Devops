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
    }
    
    options {
        // Conserver les 10 derniers builds
        buildDiscarder(logRotator(numToKeepStr: '10'))
        // Afficher les timestamps dans les logs
        timestamps()
        // Afficher les couleurs dans la console
        ansiColor('xterm')
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
                    // Publier les résultats des tests même en cas d'échec
                    junit 'target/surefire-reports/*.xml'
                    // Publier les rapports de couverture de code (si configuré)
                    publishHTML([
                        reportDir: 'target/site/jacoco',
                        reportFiles: 'index.html',
                        reportName: 'Rapport de couverture',
                        keepAll: true
                    ])
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
        
        stage('Archive Artifacts') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo '💾 Archivage des artefacts...'
                script {
                    // Archiver le JAR principal
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true, allowEmptyArchive: false
                    // Archiver les sources (optionnel)
                    archiveArtifacts artifacts: 'target/*-sources.jar', fingerprint: true, allowEmptyArchive: true
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
            
            // Nettoyer le workspace (optionnel)
            cleanWs()
        }
        success {
            echo '✅ ✅ ✅ BUILD RÉUSSI! ✅ ✅ ✅'
            echo "📦 Artefacts disponibles dans: ${env.BUILD_URL}artifact/"
            script {
                // Notification de succès (peut être étendu avec email, Slack, etc.)
                currentBuild.description = "✅ Succès - Commit: ${env.GIT_COMMIT}"
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
