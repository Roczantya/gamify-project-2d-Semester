pipeline {
    agent any

    environment {

        /* BAGIAN KEAMANAN (5 STARS):
           Menyambungkan Jenkins Credentials ke Terraform Variables.
           Nama di dalam credentials('...') harus sama dengan ID yang kamu buat di Jenkins UI.

        */
        TF_VAR_pm_api_url          = "https://100.121.8.48:8006/api2/json" // Ganti dengan IP Proxmox-mu
        TF_VAR_pm_api_token_id     = credentials('Proxmox_user_token')
        TF_VAR_pm_api_token_secret = credentials('Proxmox_user_token2')
        TF_VAR_target_node         = "fanyla"
        TF_VAR_ssh_public_key = credentials('sshpub')
        // Mematikan pengecekan SSH key agar Ansible tidak berhenti minta konfirmasi
        ANSIBLE_HOST_KEY_CHECKING = 'False'

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
                    // Terraform otomatis membaca variabel TF_VAR_ di atas
                    sh 'terraform apply -auto-approve'
                }
            }
        }



        stage('Config - Ansible') {
    steps {
        echo "Menunggu LXC benar-benar siap (60 detik)..."
        sleep 60 
        sh '''
            export ANSIBLE_HOST_KEY_CHECKING=False
            ansible-playbook -i inventory.ini playbook.yml
        '''
    }
}

        stage('Build & Deploy (Docker)') {
            steps {
                echo 'Membangun Image & Menjalankan Container...'
                // Menjalankan docker-compose untuk App (Backend + Frontend) & MongoDB
                sh 'docker-compose up -d --build'
            }
        }

        stage('Smoke Test') {
            steps {
                echo 'Melakukan Verifikasi Aplikasi...'
                // Menjalankan script test.sh untuk memastikan aplikasi tidak crash
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