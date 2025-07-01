#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------
# Script de compilation « from scratch » d'ONLYOFFICE Desktop Editors
# pour macOS Sequoia (Intel).
#
# Usage : chmod +x build-onlyoffice-macos.sh
#         ./build-onlyoffice-macos.sh
# ---------------------------------------------------------

# 1. Vérifier Homebrew
if ! command -v brew &>/dev/null; then
  echo "Homebrew non trouvé. Installation en cours..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew trouvé, mise à jour..."
  brew update
fi

# 2. Installer les dépendances système
echo "Installation des dépendances Homebrew..."
brew install \
  git \
  cmake \
  python@3.11 \
  node@16 \
  yarn \
  pkg-config \
  icu4c \
  freetype \
  fontconfig \
  glib \
  libsecret \
  qt@5

# 3. Préparer l’environnement Qt et Node
export PATH="/usr/local/opt/qt@5/bin:/usr/local/opt/node@16/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/qt@5/lib"
export CPPFLAGS="-I/usr/local/opt/qt@5/include"
export PKG_CONFIG_PATH="/usr/local/opt/qt@5/lib/pkgconfig"

# 4. Cloner le dépôt
REPO="https://github.com/ONLYOFFICE/DesktopEditors.git"
DIR="DesktopEditors"
if [ -d "$DIR" ]; then
  echo "Le répertoire $DIR existe déjà. Suppression préalable..."
  rm -rf "$DIR"
fi
echo "Clonage du dépôt $REPO..."
git clone "$REPO"
cd "$DIR"

# (Optionnel) Passer sur la branche release
# echo "Passage sur la branche 'release'..."
# git checkout release

# 5. Installer les modules JS via Yarn
echo "Installation des modules JavaScript (Yarn)..."
yarn install --frozen-lockfile

# 6. Compiler le backend C++/Qt
echo "Création du dossier build et compilation C++/Qt..."
mkdir -p build && cd build
cmake .. \
  -DPLATFORM_MAC=ON \
  -DCMAKE_BUILD_TYPE=Release
make -j"$(sysctl -n hw.logicalcpu)"
cd ..

# 7. Compiler l’interface Electron
echo "Compilation de l’interface Electron..."
yarn run build:desktop

# 8. (Optionnel) Signature et création du DMG
DMG_NAME="ONLYOFFICE-DesktopEditors.dmg"
APP_PATH="dist/mac/ONLYOFFICE.app"
CODE_IDENTITY="Developer ID Application: Votre Nom (ID…)"  # <— À modifier

if command -v codesign &>/dev/null && command -v hdiutil &>/dev/null; then
  echo "Signature de l’application avec l’identité '$CODE_IDENTITY'..."
  codesign --deep --force --options runtime \
    --sign "$CODE_IDENTITY" \
    "$APP_PATH"

  echo "Création du DMG $DMG_NAME..."
  hdiutil create -volname "ONLYOFFICE Desktop Editors" \
    -srcfolder "$APP_PATH" \
    -ov -format UDZO "$DMG_NAME"
  echo "DMG généré : $(pwd)/$DMG_NAME"
else
  echo "Codesign ou hdiutil introuvable : "
  echo "  - L’application n’a pas été signée."
  echo "  - Le DMG n’a pas été créé automatiquement."
fi

echo "Compilation terminée !"
echo "Vous trouverez l’application dans : $(pwd)/dist/mac/ONLYOFFICE.app"
