#!/bin/bash
set -euo pipefail

FLUTTER_VERSION=3.24.3

# Descargar Flutter
curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
tar xf flutter.tar.xz

# Agregar Flutter al PATH
export PATH="$PWD/flutter/bin:$PATH"

# Habilitar soporte web
flutter config --enable-web

# Verificar instalación
flutter doctor

# Construir la web
flutter build web
