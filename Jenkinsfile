pipeline {
    agent any

    environment {
        // 1. PUSAT KONTROL IP (Ganti di sini aja kalau mau pindah alamat)
        LXC_IP                     = "192.168.1.16"
        
        TF_VAR_pm_api_url          = "https://100.121.8.48:8006/api2/json"
        TF_VAR_pm_api_token_id     = credentials('Proxmox_user_token')
        TF_VAR_pm_api_token_secret = credentials('Proxmox_user_token2')
        TF_VAR_target_node         = "fanyla"
        TF_VAR_ssh_public_key      = credentials('sshpub')
        
        SSH_KEY_ID                 = 'SSH_Private_Key' 
        ANSIBLE_HOST_KEY_CHECKING  = 'False'
        
        // 2. TAMBAHAN TIMEOUT (Biar gak gampang putus asa pas download)
        DOCKER_CLIENT_TIMEOUT      = '300'
        COMPOSE_HTTP_TIMEOUT       = '300'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Infrastructure - Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        
        stage('Config - Ansible') {
            steps {
                echo "Menunggu LXC siap..."
                sleep 65
                sshagent(["${env.SSH_KEY_ID}"]) {
                    // Pakai kutip tiga ganda (""") biar variabel ${LXC_IP} kebaca
                    sh """
                        ssh-keygen -f "\$HOME/.ssh/known_hosts" -R "${env.LXC_IP}" || true
                        cd ansible && ansible-playbook -i inventory.ini playbook.yml
                    """
                }
            }
        }

        stage('Deploy - Docker') {
            steps {
                echo 'Mengirim kode & Menjalankan Docker...'
                sshagent(["${env.SSH_KEY_ID}"]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no root@${env.LXC_IP} "mkdir -p /root/app"
                        scp -o StrictHostKeyChecking=no -r ./* root@${env.LXC_IP}:/root/app/
                        ssh -o StrictHostKeyChecking=no root@${env.LXC_IP} "cd /root/app && docker-compose up -d --build"
                    """
                }
            }
        }

        stage('Smoke Test') {
            steps {
                echo "Melakukan Verifikasi di ${env.LXC_IP}..."
                // Panggil script test dengan argumen IP
                sh "bash test.sh ${env.LXC_IP}" 
            }
        }
    }

    post {
        success {
            echo '============================================='
            echo 'HORE! PIPELINE BERHASIL & APLIKASI JALAN!'
            echo '============================================='
        }
        failure {
            echo '============================================='
            echo 'WADUH GAGAL!'
            echo '============================================='
            // TIPS: Matikan sementara terraform destroy kalau mau debug log error di dalam LXC
            // dir('terraform') { sh 'terraform destroy -auto-approve' }
        }
    }
}