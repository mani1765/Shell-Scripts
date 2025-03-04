#!/bin/bash

# Function to suppress output logs
suppress_logs() {
    "$@" > /dev/null 2>&1
}

# Function to update the package list
update_package_list() {
    echo "Updating package list..."
    suppress_logs sudo apt-get update # calling suppress_logs() function
}

# Function to install dependencies
install_dependencies() {
    echo "Installing dependencies..."
    suppress_logs sudo apt-get install -y wget curl build-essential # calling suppress_logs() function
}

# Function to check if Git is installed and its version
check_git_version() {
    local version=$1
    # Check if Git is installed
    if ! command -v git &> /dev/null; then
        echo "Git is not installed. Proceeding with installation..."
        return 1  # Return 1 if Git is not installed
    fi

    # Get installed git version
    installed_version=$(git --version | awk '{print $3}')

    # Check if the specified version is already installed
    if [[ "$installed_version" == "$version" ]]; then
        echo "Git version $version is already installed."
        exit 0  # Exit if the same version is already installed
    fi
}

# Function to install a specific version of Git
install_git() {
    read -p "Enter the Git version you want to install (e.g., 2.39.1): " version

    # Check if Git is installed and its version
    check_git_version $version # calling check_git_version() function and passing user entered version as first argument to this function

    echo "Installing Git version $version..."

    # Fetch and install the specified Git version
    suppress_logs wget https://github.com/git/git/archive/refs/tags/v$version.tar.gz -O /tmp/git-$version.tar.gz
    suppress_logs tar -zxf /tmp/git-$version.tar.gz -C /tmp
    suppress_logs cd /tmp/git-$version
    suppress_logs make prefix=/usr/local all
    suppress_logs sudo make prefix=/usr/local install
}

# Main function to control the script flow
main() {
    update_package_list
    install_dependencies
    install_git
    echo "Git version $version has been installed successfully."
}

# Execute the main function
main
