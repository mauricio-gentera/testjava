//Definición de variables
def versionImage = '1.0.'
def applicationName = 'pocdevops'
def namespace = 'pocdevops'
def projectGCP = 'com-poc-ci-cd'

pipeline {
    agent any

    stages {
        stage('Construcción Imagen') {
            steps {
                echo 'Inicia construcción del proyecto...'
				sh 'chmod +x gradlew'
                //sh './gradlew clean build'
                echo 'Armando la imagen para subir a Google Cloud Platform'
                sh "docker build -t  gcr.io/${projectGCP}/${applicationName}:${versionImage}${env.BUILD_NUMBER} ."
            }
        }
        stage('Push a GCP') {
            steps {
                echo 'Inicia el envío de la imagen al Container Registry...'
                sh "docker push gcr.io/${projectGCP}/${applicationName}:${versionImage}${env.BUILD_NUMBER}"
            }
        }
        stage('Pruebas Unitarias') {
            steps {
                echo 'Se lanzan las pruebas unitarias...'
                //sh './gradlew check'
            }
        }
        stage('Desplegado') {
            steps {
                echo 'Comienza desplegado en desarrollo...'
                echo 'Se crea el namespace si no existe'
                sh "kubectl get ns ${namespace} || kubectl create ns ${namespace}"
                //echo 'Update the imagetag to the latest version'
                sh "sed -i.bak 's#.*gcr.io.*#        image: gcr.io/${projectGCP}/${applicationName}:${versionImage}${env.BUILD_NUMBER}#'  deployment.yaml"
                //sh cscript replace.vbs "deployment.yaml" "gcr.io" "gcr.io/${projectGCP}/${applicationName}:${versionImage}${env.BUILD_NUMBER}"
				echo 'Create or update resources'
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl apply -f k8s/development/service.yaml"
            }
        }
    }

    post {
        always {
            echo 'Se cargan los resultados de las pruebas unitarias...'
            //junit '${applicationName}-all/${applicationName}-ws/build/test-results/**/*.xml'
        }
    }
}
