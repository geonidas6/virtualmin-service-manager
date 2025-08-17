#!/bin/bash

# Couleurs
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Liste des services Virtualmin + Cloudflare
all_services=(
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

# Fonction : afficher l'état
check_status() {
    local targets=("$@")
    if [ ${#targets[@]} -eq 0 ]; then
        targets=("${all_services[@]}")
    fi

    echo -e "${YELLOW}📊 État des services :${RESET}"
    for srv in "${targets[@]}"; do
        if systemctl is-active --quiet "$srv"; then
            echo -e "${GREEN}[ON]${RESET} $srv"
        else
            echo -e "${RED}[OFF]${RESET} $srv"
        fi
    done
}

# Si aucun argument → afficher aide
if [ $# -lt 1 ]; then
    echo -e "${RED}❌ Utilisation : $0 on|off|status [services...]${RESET}"
    exit 1
fi

# Action principale
action=$1
shift  # on enlève le 1er argument (on/off/status)

# Si aucun service précisé → tous
if [ $# -eq 0 ]; then
    targets=("${all_services[@]}")
else
    targets=("$@")
fi

case $action in
    on)
        echo -e "${YELLOW}🚀 Activation et démarrage...${RESET}"
        for srv in "${targets[@]}"; do
            sudo systemctl enable "$srv" 2>/dev/null
            sudo systemctl start "$srv" 2>/dev/null
        done
        echo -e "${GREEN}✅ Terminé.${RESET}"
        check_status "${targets[@]}"
        ;;
    off)
        echo -e "${YELLOW}🛑 Arrêt et désactivation...${RESET}"
        for srv in "${targets[@]}"; do
            sudo systemctl stop "$srv" 2>/dev/null
            sudo systemctl disable "$srv" 2>/dev/null
        done
        echo -e "${GREEN}✅ Terminé.${RESET}"
        check_status "${targets[@]}"
        ;;
    status)
        check_status "${targets[@]}"
        ;;
    *)
        echo -e "${RED}❌ Utilisation : $0 on|off|status [services...]${RESET}"
        exit 1
        ;;
esac
