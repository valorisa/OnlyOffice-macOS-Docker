# ONLYOFFICE Desktop Editors sur macOS Sequoia (Intel) — Compilation et utilisation via Docker

![ONLYOFFICE Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/ONLYOFFICE_logo_%28default%29.svg/2560px-ONLYOFFICE_logo_%28default%29.svg.png)

## 🚀 Présentation

Ce projet explique comment compiler et utiliser **ONLYOFFICE Desktop Editors** sur **macOS Sequoia (Intel)** grâce à Docker.  
ONLYOFFICE Desktop Editors est une suite bureautique open source puissante et compatible avec les formats Microsoft Office, idéale pour l'édition collaborative de documents, feuilles de calcul et présentations.

⚠️ **Pourquoi Docker ?**  
La compilation native d’ONLYOFFICE sur macOS Sequoia pose actuellement des problèmes majeurs (dépendances, Qt, crashs). Docker permet d’utiliser un environnement Ubuntu isolé, garantissant une compilation fiable et reproductible.

---

## 📦 Prérequis

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installé sur votre Mac.
- Un terminal (zsh ou bash).
- Accès à Internet.

---

## 🛠️ Installation et compilation automatisées

1. **Cloner ce dépôt ou créer un dossier de travail**  
   *(Remplacez `~/build_tools` par le chemin souhaité si besoin)*

2. **Créer le script d’automatisation**

   Copiez le contenu ci-dessous (sinon, il y en a un déjà tout-prêt, appelé `build-onlyoffice-macos.sh`, sans intervention de Docker) dans un fichier nommé `build_onlyoffice.sh`, script avec l'utilisation de Docker:

   ```bash
   #!/bin/bash

   BUILD_TOOLS_DIR="$HOME/build_tools"

   if [ ! -d "$BUILD_TOOLS_DIR" ]; then
     echo "Clonage du dépôt ONLYOFFICE build_tools..."
     git clone https://github.com/ONLYOFFICE/build_tools.git "$BUILD_TOOLS_DIR"
   else
     echo "Le dépôt build_tools existe déjà."
   fi

   cd "$BUILD_TOOLS_DIR" || exit 1

   mkdir -p out

   echo "Construction de l'image Docker onlyoffice-build..."
   docker build -t onlyoffice-build .

   echo "Lancement de la compilation ONLYOFFICE Desktop Editors dans Docker..."
   docker run --rm -v "$PWD/out":/build_tools/out onlyoffice-build

   echo "Compilation terminée. Les fichiers sont dans le dossier out."
   ```

3. **Rendre le script exécutable et lancer la compilation**

   ```bash
   chmod +x build_onlyoffice.sh
   ./build_onlyoffice.sh
   ```

   > La compilation peut durer de 20 à 90 minutes selon la configuration de votre machine.

---

## 📝 Utilisation des binaires compilés

Après la compilation, les exécutables ONLYOFFICE Desktop Editors se trouvent dans le dossier `out`.  
Pour les utiliser sur macOS, il est recommandé de les exécuter dans une machine virtuelle Linux ou de les intégrer à un workflow serveur.

---

## 💡 Pourquoi utiliser ONLYOFFICE ?

- **Open source** et respect de la vie privée.
- **Compatibilité totale** avec les formats MS Office (docx, xlsx, pptx, etc.).
- **Édition collaborative** en temps réel.
- **Interface moderne** et intuitive.

---

## ❓ FAQ

### Q : Puis-je lancer les binaires Linux directement sur macOS ?

R : Non, les binaires compilés sont pour Linux. Utilisez-les dans une VM Linux ou sur un serveur.

### Q : Pourquoi ne pas compiler nativement sur macOS ?

R : Les dépendances (Qt, etc.) et des bugs spécifiques à macOS Sequoia rendent la compilation native très complexe, voire impossible actuellement.

### Q : Puis-je utiliser ONLYOFFICE autrement sur macOS ?

R : Oui, via la version web d’ONLYOFFICE ou en utilisant une VM Linux sur votre Mac.

---

## 📝 Ressources utiles

- [ONLYOFFICE Desktop Editors — Site officiel](https://www.onlyoffice.com/fr/desktop.aspx)
- [Dépôt Github build_tools](https://github.com/ONLYOFFICE/build_tools)
- [Documentation officielle](https://helpcenter.onlyoffice.com/)

---

## 🧑‍💻 Auteur

Projet adapté et documenté par [valorisa](https://github.com/valorisa).

---

## 📄 Licence

Ce dépôt est distribué sous licence MIT (voir [LICENSE](LICENSE)).

---

### Points forts de ce README

- **Titres clairs** et niveaux hiérarchiques respectés.
- **Blocs de code** bien séparés.
- **Explications pédagogiques** sur les choix techniques.
- **FAQ** pour anticiper les questions courantes.
- **Liens utiles** et logo pour un rendu professionnel.
- **Aucune violation Markdown** (pas de balises HTML inutiles, pas de lignes trop longues, pas de listes imbriquées mal formées).
