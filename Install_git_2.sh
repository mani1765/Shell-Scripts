#!/bin/bash

# Function to check if Git is installed and its version
check_git_version() {
    local version=$1
    
    # Check if Git is installed
    if ! command -v git &> /dev/null; then
        echo "Git is not installed. Proceeding with installation..."
        return 1  # Git is not installed
    fi
    
    # Get the installed version of Git
    installed_version=$(git --version | awk '{print $3}')
    
    # Compare the installed version with the requested version
    if [[ "$installed_version" == "$version" ]]; then
        echo "Git version $version is already installed."
        return 0  # Installed version matches the requested version
    else
        echo "Git version $installed_version is installed, but you requested $version."
        return 1  # Versions don't match
    fi
}

# Function to install Git
install_git() {
    # Prompt the user for the Git version to install
    read -p "Enter the Git version you want to install (e.g., 2.39.1): " version
    
    # Check the current Git version
    check_git_version $version
    
    # Check the return value of check_git_version
    if [ $? -eq 1 ]; then  # If Git is not installed or versions differ
        echo "Proceeding with Git installation..."
        
        # Installation steps (simplified for this example)
        # Update system and install dependencies
        sudo apt-get update -y &> /dev/null
        sudo apt-get install -y curl wget build-essential &> /dev/null
        
        # Download and install the requested version of Git
        echo "Downloading Git version $version..."
        wget https://github.com/git/git/archive/refs/tags/v$version.tar.gz &> /dev/null
        
        # Extract and install
        tar -xf v$version.tar.gz &> /dev/null
        cd git-$version || exit
        make prefix=/usr/local all &> /dev/null
        sudo make prefix=/usr/local install &> /dev/null
        cd ..
        rm -rf git-$version v$version.tar.gz
        
        echo "Git version $version has been installed successfully."
    else
        echo "Git is already installed with the requested version."
    fi
}

# Main entry point
install_git
