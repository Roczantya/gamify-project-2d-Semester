pipeline {
    agent any

    environment {
        // --- CREDENTIALS ---
        TF_VAR_pm_api_url          = "https://100.121.8.48:8006/api2/json"
        TF_VAR_pm_api_token_id     = credentials('Proxmox_user_token')
        TF_VAR_pm_api_token_secret = credentials('Proxmox_user_token2')
        TF_VAR_target_node         = "fanyla"
        
        // Gembok untuk Terraform (Secret Text)
        TF_VAR_ssh_public_key      = credentials('sshpub')
        
        // ID Kunci Private untuk Ansible & SSH (SSH Username with private key)
        SSH_KEY_ID                 = 'SSH_Private_Key' // Ganti dengan ID kredensial SSH kamu di Jenkin
        
        ANSIBLE_HOST_KEY_CHECKING  = 'False'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo 'Tarik kode terbaru dari GitHub...'
                checkout scm
            }
        }

        stage('Infrastructure - Terraform') {
            steps {
                dir('terraform') {
                    echo 'Memulai Provisioning LXC di Proxmox...'
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        
        stage('Config - Ansible') {
            steps {
                echo "Menunggu LXC siap (40 detik)..."
                sleep 65
                sshagent(["${env.SSH_KEY_ID}"]) {
                    sh '''
                        ssh-keygen -f "$HOME/.ssh/known_hosts" -R "192.168.1.16" || true
                        cd ansible && ansible-playbook -i inventory.ini playbook.yml
                    '''
                }
            }
        }

        stage('Deploy - Docker') {
            steps {
                echo 'Mengirim kode & Menjalankan Docker...'
                sshagent(["${env.SSH_KEY_ID}"]) {
                    sh '''
                        # 1. Buat folder di target
                        ssh -o StrictHostKeyChecking=no root@192.168.1.16 "mkdir -p /root/app"
                        
                        # 2. Kirim semua isi folder saat ini ke target
                        # Kita pakai -r (recursive) dan pastikan path-nya benar
                        scp -o StrictHostKeyChecking=no -r ./* root@192.168.1.16:/root/app/
                        
                        # 3. Baru jalankan docker-compose
                        ssh -o StrictHostKeyChecking=no root@192.168.1.16 "cd /root/app && docker-compose up -d --build"
                    '''
                }
            }
        }

        stage('Smoke Test') {
            steps {
                echo 'Melakukan Verifikasi Aplikasi dengan test.sh...'
                // Jika test.sh ada di repo GitHub (di root folder)
                // Dan script tersebut akan mengetes IP 192.168.1.16
                sh 'bash test.sh' 
            }
        }
    } // Akhir blok STAGES

    post {
        success {
            echo '============================================='
            echo 'HORE! PIPELINE BERHASIL & APLIKASI JALAN!'
            echo '============================================='
        }
        failure {
            echo '============================================='
            echo 'WADUH GAGAL! Menghancurkan LXC agar bersih...'
            echo '============================================='
            dir('terraform') {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}