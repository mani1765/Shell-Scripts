#!/bin/bash

# Function to check if Docker is installed and its version
check_docker_version() {
    local version=$1
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Proceeding with installation..."
        return 1  # Docker is not installed
    fi
    
    # Get the installed version of Docker
    installed_version=$(docker --version | awk '{print $3}' | sed 's/,//')
    
    # Compare the installed version with the requested version
    if [[ "$installed_version" == "$version" ]]; then
        echo "Docker version $version is already installed."
        return 0  # Installed version matches the requested version
    else
        echo "Docker version $installed_version is installed, but you requested $version."
        return 1  # Versions don't match
    fi
}

# Function to install Docker
install_docker() {
    # Prompt the user for the Docker version to install
    read -p "Enter the Docker version you want to install (e.g., 20.10.7): " version
    
    # Check the current Docker version
    check_docker_version $version
    
    # Check the return value of check_docker_version
    if [ $? -eq 1 ]; then  # If Docker is not installed or versions differ
        echo "Proceeding with Docker installation..."
        
        # Update system and install prerequisites for Docker installation
        sudo apt-get update -y &> /dev/null
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common &> /dev/null
        
        # Add Docker’s official GPG key
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &> /dev/null
        
        # Add Docker repository
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &> /dev/null
        
        # Update package index again to include Docker packages
        sudo apt-get update -y &> /dev/null
        
        # Install the requested Docker version
        echo "Installing Docker version $version..."
        sudo apt-get install -y docker-ce=$version docker-ce-cli=$version containerd.io &> /dev/null
        
        # Start Docker service
        sudo systemctl start docker &> /dev/null
        sudo systemctl enable docker &> /dev/null
        
        echo "Docker version $version has been installed successfully."
    else
        echo "Docker is already installed with the requested version."
    fi
}

# Main entry point
install_docker
