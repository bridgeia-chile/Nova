#!/bin/bash

# Script de instalación para Nova en Raspberry Pi 4 (DietPi)
# Autor: Bridgeia Chile
# Fecha: 2026-03-09

# --- Funciones auxiliares ---
function print_header() {
    echo "==========================================="
    echo "  Instalador de Nova para Raspberry Pi 4"
    echo "==========================================="
    echo ""
}

function print_step() {
    echo "✓ Paso $1: $2"
}

function print_error() {
    echo "✗ Error: $1"
    exit 1
}

function check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        print_error "Este script debe ejecutarse como root (sudo)."
    fi
}

function verify_hardware() {
    print_step 1 "Verificando hardware (Raspberry Pi 4)..."

    # Verificar modelo de Raspberry Pi
    MODEL=$(cat /proc/device-tree/model)
    if [[ "$MODEL" != *"Raspberry Pi 4"* ]]; then
        print_error "Este script solo es compatible con Raspberry Pi 4. Modelo detectado: $MODEL"
    fi

    # Verificar arquitectura (ARM)
    ARCH=$(uname -m)
    if [[ "$ARCH" != "aarch64" && "$ARCH" != "armv7l" ]]; then
        print_error "Arquitectura no soportada: $ARCH. Se requiere ARM (aarch64 o armv7l)."
    fi

    echo "  - Modelo: $MODEL"
    echo "  - Arquitectura: $ARCH"
    echo "  - Hardware verificado correctamente."
    echo ""
}

function install_prerequisites() {
    print_step 2 "Instalando prerequisitos..."

    # Actualizar paquetes
    echo "  - Actualizando paquetes..."
    apt update -y || print_error "Falló al actualizar paquetes."
    apt upgrade -y || print_error "Falló al actualizar paquetes."

    # Instalar Git
    echo "  - Instalando Git..."
    apt install git -y || print_error "Falló al instalar Git."

    # Instalar Node.js (versión LTS)
    echo "  - Instalando Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - || print_error "Falló al configurar Node.js."
    apt install nodejs -y || print_error "Falló al instalar Node.js."

    # Instalar dependencias comunes
    echo "  - Instalando dependencias..."
    apt install -y build-essential python3 python3-pip || print_error "Falló al instalar dependencias."

    # Verificar instalaciones
    echo "  - Verificando instalaciones..."
    git --version || print_error "Git no se instaló correctamente."
    node --version || print_error "Node.js no se instaló correctamente."
    npm --version || print_error "NPM no se instaló correctamente."

    echo "  - Prerequisitos instalados correctamente."
    echo ""
}

function clone_nova_repo() {
    print_step 3 "Clonando repositorio Nova..."

    # Clonar el repositorio
    git clone https://github.com/bridgeia-chile/Nova.git /opt/nova || print_error "Falló al clonar el repositorio."

    # Navegar al directorio
    cd /opt/nova || print_error "No se pudo acceder al directorio /opt/nova."

    echo "  - Repositorio clonado en /opt/nova."
    echo ""
}

function install_nova() {
    print_step 4 "Instalando Nova..."

    # Instalar dependencias de Node.js
    echo "  - Instalando dependencias de Node.js..."
    npm install --production || print_error "Falló al instalar dependencias de Node.js."

    # Compilar TypeScript (si es necesario)
    if [ -f "tsconfig.json" ]; then
        echo "  - Compilando TypeScript..."
        npx tsc || print_error "Falló al compilar TypeScript."
    fi

    # Configurar permisos
    echo "  - Configurando permisos..."
    chown -R dietpi:dietpi /opt/nova || print_error "Falló al configurar permisos."

    echo "  - Nova instalado correctamente."
    echo ""
}

function configure_service() {
    print_step 5 "Configurando servicio de Nova..."

    # Copiar archivo de servicio
    if [ -f "nova.service" ]; then
        cp nova.service /etc/systemd/system/ || print_error "Falló al copiar el archivo de servicio."
        systemctl daemon-reload || print_error "Falló al recargar systemd."
        systemctl enable nova || print_error "Falló al habilitar el servicio."
        systemctl start nova || print_error "Falló al iniciar el servicio."
        echo "  - Servicio configurado y iniciado."
    else
        echo "  - Advertencia: No se encontró el archivo nova.service."
    fi

    echo ""
}

function print_summary() {
    print_header
    echo "Instalación completada con éxito!"
    echo ""
    echo "Resumen:"
    echo "  - Directorio de instalación: /opt/nova"
    echo "  - Servicio: nova (systemd)"
    echo "  - Estado del servicio: $(systemctl is-active nova)"
    echo ""
    echo "Para verificar el servicio, ejecuta:"
    echo "  systemctl status nova"
    echo ""
    echo "Para ver los logs, ejecuta:"
    echo "  journalctl -u nova -f"
    echo ""
}

# --- Ejecución principal ---
print_header
check_root
verify_hardware
install_prerequisites
clone_nova_repo
install_nova
configure_service
print_summary