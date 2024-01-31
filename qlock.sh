#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
clear
database_file="db"

hide_input() {
    stty -echo
    trap 'stty echo' EXIT
}

show_input() {
    stty echo
}

encryption_menu() {
    read -p "   Enter key: " -s key
    echo
    read -p "   Enter phrase: " -s plaintext

    encrypted_text=$(echo "$plaintext" | openssl enc -aes-128-cbc -a -salt -k "$key" -pbkdf2)
    clear
    echo -e "\n\n   Encrypted phrase: \n   $encrypted_text \n"
    exit 0
}

decryption_menu() {
    read -p "   Enter encrypted phrase: " encrypted_text
    hide_input
    read -p "   Enter the decryption key: " -s key
    echo
    show_input

    decrypted_text=$(echo "$encrypted_text" | openssl enc -aes-128-cbc -a -d -salt -k "$key" -pbkdf2 2>/dev/null)

    if [ $? -eq 0 ]; then
        echo -e "\n\n   Decrypted phrase: \n   $decrypted_text \n"
        exit 0
    else
        echo -e "\n\n   Decrypted phrase: "
        random_words
        exit 0
    fi
}

random_words() {
    if [ -f "$database_file" ]; then
        words=$(shuf -n $(($RANDOM % 7 + 4)) "$database_file" | tr '\n' ' ')
        echo "   $words"
    else
        echo "Error: Database file $database_file not found."
    fi
}
while true; do
    echo -e "${NC} 
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⠀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣷⣦⠀⠀⠀⠀⠀⠀⠀${RED}      _         _   ${NC}
⠀⠀⠀⠀⠀⠀⣾⣿⣿⠟⠉⠀⠀⠀⠉⠻⣿⣿⣷⠀⠀⠀⠀⠀⠀${RED}  ___| |___ ___| |_ ${NC}
⠀⠀⠀⠀⠀⢸⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⡇⠀⠀⠀⠀⠀${RED} | . | | . |  _| '_|${NC}
⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀${RED} |_  |_|___|___|_,_|${NC}
⠀⠀⠀⣠⣤⣼⣿⣿⣧⣤⣤⣤⣤⣤⣤⣤⣼⣿⣿⣧⣤⣄⠀⠀⠀${RED}   |_|              ${NC}
⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀ ${GREEN}|  By Mercad [@DEMxN]${NC}
⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀ +-------------------+
⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀ ${GREEN}|  1. Encryption${NC}
⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀ ${GREEN}|  2. Decryption${NC}
⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀ ${GREEN}|  3. Exit${NC}
⠀⠀⠈⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠁⠀⠀\n${GREEN}"
    read -p "   Selcet (1/2/3): " choice

    case $choice in
        1)
            encryption_menu
            ;;
        2)
            decryption_menu
            ;;
        3)
            clear
            echo -e "${NC}Bye Bye!"
            exit 0
            ;;
        *)
            clear
            ;;
    esac
done
