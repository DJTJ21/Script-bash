#!/bin/bash

# Fonction pour vérifier si une commande existe
command_exists() {
    command -v "$1" &>/dev/null
}

# Fonction pour installer Ansible
install_ansible() {
    echo "Installing Ansible..."
    sudo apt update
    sudo apt install -y ansible
}

# Fonction pour installer Jenkins
install_jenkins() {
    echo "Installing Jenkins..."
    sudo apt update
    sudo apt install -y openjdk-11-jdk
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update
    sudo apt install -y jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
}

# Fonction pour installer Docker
install_docker() {
    echo "Installing Docker..."
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
}

# Fonction pour installer Terraform
install_terraform() {
    echo "Installing Terraform..."
    sudo apt update
    sudo apt install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt update
    sudo apt install -y terraform
}

# Fonction pour installer Minikube
install_minikube() {
    echo "Installing Minikube..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
}

# Fonction pour installer Python
install_python() {
    echo "Installing Python..."
    sudo apt update
    sudo apt install -y python3 python3-pip
}

# Fonction pour installer Nexus (ou JFrog Artifactory)
install_nexus() {
    echo "Installing Nexus..."
    sudo apt update
    sudo apt install -y openjdk-11-jdk
    cd /opt
    sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
    sudo tar -zxvf latest-unix.tar.gz
    sudo mv nexus-3* nexus
    sudo adduser nexus
    sudo chown -R nexus:nexus /opt/nexus
    sudo chown -R nexus:nexus /opt/sonatype-work
    sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus
    sudo update-rc.d nexus defaults
}

# Fonction pour installer SonarQube
install_sonarqube() {
    echo "Installing SonarQube..."
    sudo apt update
    sudo apt install -y openjdk-11-jdk
    cd /opt
    sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.1.44547.zip
    sudo unzip sonarqube-8.9.1.44547.zip
    sudo mv sonarqube-8.9.1.44547 sonarqube
    sudo adduser sonar
    sudo chown -R sonar:sonar /opt/sonarqube
    cd /opt/sonarqube/bin/linux-x86-64
    sudo -u sonar ./sonar.sh start
}

# Fonction pour installer Trivy
install_trivy() {
    echo "Installing Trivy..."
    sudo apt update
    sudo apt install -y wget apt-transport-https gnupg lsb-release
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
    echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/trivy.list
    sudo apt update
    sudo apt install -y trivy
}

# Fonction pour installer AWS CLI
install_awscli() {
    echo "Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
}

# Fonction pour installer kubectl
install_kubectl() {
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
}

# Fonction pour installer Docker Compose
install_docker_compose() {
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

# Fonction pour installer Helm
install_helm() {
    echo "Installing Helm..."
    curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
    sudo apt-get install apt-transport-https --yes
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install -y helm
}

# Liste des outils disponibles
tools=("ansible" "jenkins" "docker" "terraform" "minikube" "python" "nexus" "sonarqube" "trivy" "awscli" "kubectl" "docker-compose" "helm")

# Demande à l'utilisateur de choisir les outils à installer
echo "Choisissez les outils à installer (séparés par des espaces) :"
for i in "${!tools[@]}"; do
    echo "$((i+1)). ${tools[$i]}"
done

read -p "Entrez les numéros des outils à installer : " -a selections

# Installation des outils sélectionnés
for selection in "${selections[@]}"; do
    case "${tools[$((selection-1))]}" in
        ansible)
            install_ansible
            ;;
        jenkins)
            install_jenkins
            ;;
        docker)
            install_docker
            ;;
        terraform)
            install_terraform
            ;;
        minikube)
            install_minikube
            ;;
        python)
            install_python
            ;;
        nexus)
            install_nexus
            ;;
        sonarqube)
            install_sonarqube
            ;;
        trivy)
            install_trivy
            ;;
        awscli)
            install_awscli
            ;;
        kubectl)
            install_kubectl
            ;;
        docker-compose)
            install_docker_compose
            ;;
        helm)
            install_helm
            ;;
        *)
            echo "Option non valide : ${selection}"
            ;;
    esac
done

echo "Installation terminée."
