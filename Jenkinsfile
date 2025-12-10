pipeline {
    agent any
    
    tools {
        maven "M2_HOME"
        jdk "JAVA_HOME"
    }
    
    environment {
        PROJECT_NAME = 'timesheet-devops'
        MAVEN_OPTS = '-Xmx1024m'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du code source depuis Git (branche main)...'
                checkout scm
                // Afficher la branche actuelle pour vérification
                sh 'git branch -v'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Compilation du projet Maven...'
                sh "mvn clean compile"
            }
        }
        
        stage('Test') {
            steps {
                echo 'Exécution des tests...'
                sh "mvn test"
            }
            post {
                always {
                    // Publier les résultats des tests
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Package') {
            steps {
                echo 'Création du package JAR...'
                sh "mvn package -DskipTests"
            }
            post {
                success {
                    // Archiver les artefacts
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
    }
    
    post {
        success {
            echo "✅ Build réussi pour ${env.PROJECT_NAME}!"
            echo "Artefacts disponibles dans target/"
        }
        failure {
            echo "❌ Build échoué pour ${env.PROJECT_NAME}!"
        }
        always {
            echo "📦 Build terminé - Consultez les logs pour plus de détails"
        }
    }
}
