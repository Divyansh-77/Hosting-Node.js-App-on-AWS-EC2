pipeline {
    // Define a global agent as none, so each stage can specify its own.
    agent none 

    // Environment variables loaded securely from Jenkins credentials.
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        stage('Checkout Code') {
            // This initial checkout can run on the main Jenkins agent.
            agent any 
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/Divyansh-77/Hosting-Node.js-App-on-AWS-EC2.git'
            }
        }

        stage('Terraform Apply') {
            // Use a specific Docker container that has Terraform pre-installed.
            agent {
                docker { image 'hashicorp/terraform:latest' }
            }
            steps {
                echo 'Running Terraform inside a Docker container...'
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Ansible Deploy') {
            // Use a specific Docker container that has Ansible pre-installed.
            agent {
                docker { image 'williamyeh/ansible:ubuntu22.04' }
            }
            steps {
                echo 'Deploying application with Ansible inside a Docker container...'

                // Load the SSH key securely for Ansible to use.
                withCredentials([sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'ANSIBLE_SSH_KEY_FILE')]) {

                    // Get the app server's IP address from Terraform's output.
                    sh 'terraform output -raw public_ip > app_server_ip.txt'

                    // Dynamically create an inventory file for this build.
                    sh 'echo "[webserver]" > inventory_jenkins'
                    sh 'echo "$(cat app_server_ip.txt) ansible_user=ubuntu ansible_ssh_private_key_file=${ANSIBLE_SSH_KEY_FILE}" >> inventory_jenkins'

                    // Run the Ansible playbook, ignoring SSH host key checking for simplicity.
                    sh 'ansible-playbook -i inventory_jenkins playbook.yml --ssh-common-args="-o StrictHostKeyChecking=no"'
                }
            }
        }
    }
}