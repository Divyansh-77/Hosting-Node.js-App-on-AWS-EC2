pipeline {
    agent any

    environment {
        // Load AWS credentials securely from Jenkins Credentials Manager
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                // This step clones your project code from GitHub
                echo 'Checking out code from GitHub...'
                git 'https://github.com/Divyansh-77/Hosting-Node.js-App-on-AWS-EC2.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                // This step builds your infrastructure from code
                echo 'Initializing Terraform...'
                sh 'terraform init'

                echo 'Applying Terraform plan...'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Ansible Deploy') {
            steps {
                // This step configures the server and deploys the app
                echo 'Deploying application with Ansible...'

                // Use the SSH key securely from Jenkins Credentials
                withCredentials([sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'ANSIBLE_SSH_KEY_FILE')]) {

                    // Get the app server's IP from Terraform output
                    sh 'terraform output -raw public_ip > app_server_ip.txt'

                    // Create the Ansible inventory file for this build
                    sh 'echo "[webserver]" > inventory_jenkins'
                    sh 'echo "$(cat app_server_ip.txt) ansible_user=ubuntu ansible_ssh_private_key_file=${ANSIBLE_SSH_KEY_FILE}" >> inventory_jenkins'

                    // Run the Ansible playbook
                    sh 'ansible-playbook -i inventory_jenkins playbook.yml'
                }
            }
        }
    }
}