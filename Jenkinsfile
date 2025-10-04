pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/Divyansh-77/Hosting-Node.js-App-on-AWS-EC2.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'

                echo 'Applying Terraform plan...'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Ansible Deploy') {
            steps {
                echo 'Deploying application with Ansible...'

                withCredentials([sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'ANSIBLE_SSH_KEY_FILE')]) {

                    sh 'terraform output -raw public_ip > app_server_ip.txt'

                    sh 'echo "[webserver]" > inventory_jenkins'
                    sh 'echo "$(cat app_server_ip.txt) ansible_user=ubuntu ansible_ssh_private_key_file=${ANSIBLE_SSH_KEY_FILE}" >> inventory_jenkins'

                    sh 'ansible-playbook -i inventory_jenkins playbook.yml'
                }
            }
        }
    }
}