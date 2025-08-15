#!/bin/bash

# Couleurs
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Liste des services Virtualmin + Cloudflare
services=(
    webmin
    usermin
    apache2
    php7.3-fpm
    php7.4-fpm
    php8.0-fpm
    php8.1-fpm
    php8.2-fpm
    php8.4-fpm
    bind9
    postfix
    dovecot
    saslauthd
    mariadb
    cloudflared
)

# Fonction pour afficher l'état
check_status() {
    echo -e "${YELLOW}📊 État des services :${RESET}"
    for srv in "${services[@]}"; do
        if systemctl is-active --quiet "$srv"; then
            echo -e "${GREEN}[ON]${RESET} $srv"
        else
            echo -e "${RED}[OFF]${RESET} $srv"
        fi
    done
}

# Commande ON
if [ "$1" == "on" ]; then
    echo -e "${YELLOW}🚀 Activation et démarrage de tous les services...${RESET}"
    for srv in "${services[@]}"; do
        sudo systemctl enable "$srv" 2>/dev/null
        sudo systemctl start "$srv" 2>/dev/null
    done
    echo -e "${GREEN}✅ Tous les services sont activés et démarrés.${RESET}"
    check_status

# Commande OFF
elif [ "$1" == "off" ]; then
    echo -e "${YELLOW}🛑 Arrêt et désactivation de tous les services...${RESET}"
    for srv in "${services[@]}"; do
        sudo systemctl stop "$srv" 2>/dev/null
        sudo systemctl disable "$srv" 2>/dev/null
    done
    echo -e "${GREEN}✅ Tous les services sont arrêtés et désactivés.${RESET}"
    check_status

# Commande STATUS
elif [ "$1" == "status" ]; then
    check_status

# Mauvaise utilisation
else
    echo -e "${RED}❌ Utilisation : $0 on|off|status${RESET}"
    exit 1
fi

