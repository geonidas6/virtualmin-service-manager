#!/bin/bash

# Couleurs
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Liste des services ISPConfig
# Les services PHP sont gérés de manière dynamique
ispconfig_services=(
    apache2
    postfix
    dovecot
    mariadb
    cloudflared
    pure-ftpd-mysql
    rspamd
    redis-server
    memcached
)

# Fonction pour ajouter les services PHP dynamiquement (actifs ou non)
get_php_services() {
    local php_services=()
    # Recherche tous les services php-fpm installés et retourne les noms complets
    for srv in $(systemctl list-unit-files --type=service | grep -o 'php[0-9]\.[0-9]-fpm'); do
        php_services+=("$srv")
    done
    echo "${php_services[@]}"
}

# Fonction : afficher l'état
check_status() {
    local targets=("$@")
    if [ ${#targets[@]} -eq 0 ]; then
        # S'il n'y a pas de cible spécifiée, inclure tous les services d'ISPConfig + PHP
        targets=("${ispconfig_services[@]}" $(get_php_services))
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

# Si aucun argument → afficher l'aide
if [ $# -lt 1 ]; then
    echo -e "${RED}❌ Utilisation : $0 on|off|status [services...]${RESET}"
    exit 1
fi

# Action principale
action=$1
shift # on enlève le 1er argument

# Si aucun service précisé -> tous les services d'ISPConfig + PHP dynamiquement
if [ $# -eq 0 ]; then
    targets=("${ispconfig_services[@]}" $(get_php_services))
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
