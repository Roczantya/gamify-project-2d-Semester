pipeline {
    agent any

    environment {
        TF_VAR_pm_api_url          = "https://100.121.8.48:8006/api2/json"
        TF_VAR_pm_api_token_id     = credentials('Proxmox_user_token')
        TF_VAR_pm_api_token_secret = credentials('Proxmox_user_token2')
        TF_VAR_target_node         = "fanyla"
        TF_VAR_ssh_public_key      = credentials('sshpub')
        ANSIBLE_HOST_KEY_CHECKING   = 'False'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo 'Tarik kode terbaru dari GitHub...'
                checkout scm
            }
        }

        stage('Infrastructure (Terraform)') {
            steps {
                dir('terraform') {
                    echo 'Memulai Provisioning LXC di Proxmox...'
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Configuration (Ansible)') {
            steps {
                dir('ansible') {
                    echo 'Mengonfigurasi LXC: Install Docker & Docker Compose...'
                    // Gunakan sshagent supaya Ansible punya kunci buat masuk ke LXC
                    sshagent(credentials: ['SSH_LXC_KEY']) { 
                        sh 'ansible-playbook -i inventory.ini playbook.yml'
                    }
                }
            }
        }

        stage('Build & Deploy (Docker)') {
            steps {
                script {
                    echo 'Membangun Image & Menjalankan Container...'
                    /* TIPS: Jika folder backend/frontend kamu ada di dalam folder tertentu, 
                       gunakan dir('nama_foldernya') { ... } di sini.
                    */
                    sh 'docker-compose up -d --build'
                }
            }
        }

        stage('Smoke Test') {
            steps {
                echo 'Melakukan Verifikasi Aplikasi...'
                sh 'bash test.sh'
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
            echo 'WADUH GAGAL! Melakukan Auto-Destroy agar Proxmox tetap bersih...'
            echo '============================================='
            dir('terraform') {
                // FITUR KEAMANAN: Hancurkan LXC kalau gagal biar nggak nyampah
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}