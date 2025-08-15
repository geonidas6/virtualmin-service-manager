# Virtualmin Service Manager

Un script Bash simple pour **gérer tous les services Virtualmin** ainsi que **Cloudflare Zero Trust (cloudflared)** en une seule commande.

## 📌 Fonctionnalités
- **Démarrer et activer** tous les services
- **Arrêter et désactiver** tous les services
- **Afficher l’état** actuel de chaque service (ON/OFF)
- Inclut le support pour **Cloudflare Zero Trust (`cloudflared`)**

## 📦 Services gérés
- Virtualmin (Webmin, Usermin)
- Apache Webserver
- PHP-FPM (7.3, 7.4, 8.0, 8.1, 8.2, 8.4)
- BIND DNS Server
- Postfix Mail Server
- Dovecot IMAP/POP3 Server
- Cyrus SASL
- MariaDB Database Server
- Cloudflare Zero Trust (`cloudflared`)

## 🚀 Installation
```bash
# Cloner le repo
git clone https://github.com/TON-USER/virtualmin-service-manager.git
cd virtualmin-service-manager

# Rendre le script exécutable
chmod +x virtualmin.sh

# Optionnel : le rendre accessible partout
sudo mv virtualmin.sh /usr/local/bin/virtualmin
````

## 💻 Utilisation

```bash
virtualmin on      # Active et démarre tous les services
virtualmin off     # Arrête et désactive tous les services
virtualmin status  # Affiche l’état des services
```

OU

```bash
./virtualmin.sh off   # Coupe et désactive tout
./virtualmin.sh on    # Active et démarre tout
./virtualmin.sh status  # Affiche uniquement l'état des services
```


## 📜 Exemple de sortie

```text
🚀 Activation et démarrage de tous les services...
✅ Tous les services sont activés et démarrés.
📊 État des services :
[ON] webmin
[ON] usermin
[ON] apache2
[ON] php7.4-fpm
...
```

## ⚠️ Notes

* Nécessite `systemctl` (donc fonctionne sur Debian, Ubuntu, CentOS, etc.)
* Le script doit être exécuté avec des droits `sudo` pour gérer les services
* Les noms des services doivent correspondre à ceux de votre système

## 📄 Licence

Ce script est distribué sous licence MIT.


Veux-tu que je te fasse aussi ce package prêt à pousser sur GitHub ?
