#!/bin/bash

# Function to lookup IP for a domain
lookup() {
    # Print the domain name
    echo "Domain: $1"
    
    # Use the host command to get the IP address of the domain
    # grep is used to filter the output for lines containing "has address"
    # cut is used to extract the IP address from the line
    ip=$(host $1 | grep "has address" | cut -d " " -f 4)
    
    # Check if the IP variable is empty
    if [ -z "$ip" ]
    then
        # If it is, print an error message and return 1 to indicate an error
        echo "Invalid domain name"
        return 1
    else
        # If it's not, print the IP address
        echo "IP Address:"
        # Print each IP on a separate line
        for address in $ip; do
            echo $address
        done
        echo "-----------------------------"
        return 0
    fi
    # No need to unset variables as they are local to the function
}

# Function to process file
process_file() {
    # Check if the file exists
    if [ ! -f "$1" ]; then
        # If the file doesn't exist, print a message and return
        echo "File does not exist :( "
        return 1
    fi

    # Print a welcome message and the name of the file being processed
    echo "------------------------------------------------"
    echo "************************************************"
    echo "             Welcome to IP WIZARD               "
    echo "------------------------------------------------"
    echo "IP Address(s) found from domains in $1"
    echo "************************************************"
    echo "------------------------------------------------"
    
    # Initialize a flag to check if a valid domain was found
    valid_domain_found=0
    
    # Read the file line by line
    while IFS= read -r line
    do
        # Lookup the IP for each domain in the file
        if lookup $line; then
            valid_domain_found=1
        fi
    done < "$1"
    
    # If no valid domain was found in the file, print a message
    if [ $valid_domain_found -eq 0 ]; then
        echo "File doesn't contain a valid domain name or is empty :("
    else
        echo "Thank you for using IP WIZARD :)"
    fi
    # No need to unset variables as they are local to the function
}

# Function to display menu
menu() {
    # Print a welcome message
    echo "------------------------------------------------"
    echo "************************************************"
    echo "             Welcome to IP WIZARD               "
    echo "************************************************"
    echo "------------------------------------------------"
    
    # Loop to keep the menu running until the user chooses to quit
    while true; do
        echo "Please select the option you want to proceed:"
        echo "1) Input a domain name"
        echo "2) Quit from the program"
        
        # Read the user's choice
        read -p "Enter your choice: " choice
        
        # Process the user's choice
        case $choice in
            1)
                # Loop to keep asking for a domain until a valid one is entered
                while true; do
                    read -p "Enter domain name: " domain
        	        echo "-----------------------------"
                    lookup $domain && break
                done
                ;;
            2)
                # If the user chooses to quit, print a goodbye message and exit the script
                echo "Thank you for using IP WIZARD :)"
                exit 0
                ;;
            *)
                # If the user enters an invalid choice, print an error message
                echo "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
    # No need to unset variables as they are local to the function
}

# Main script
if [ $# -eq 0 ]
then
    # If no arguments are provided, display the menu
    menu
elif [ $# -eq 1 ]
then
    # If one argument is provided, assume it's a file name and process the file
    process_file $1
else
    # If more than one argument is provided, print an error message
    echo "Too many parameters entered"
    echo "Please enter only one parameter"
    echo "Thank you :)"
fi
# No need to unset variables as they are local to the function
