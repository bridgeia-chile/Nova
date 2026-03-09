# Guía Completa de Instalación y Uso de Nova

## Índice
1. [Requisitos del Sistema](#requisitos-del-sistema)
2. [Instalación en Raspberry Pi 4 (DietPi)](#instalación-en-raspberry-pi-4-dietpi)
   - [Método Automático (Recomendado)](#método-automático-recomendado)
   - [Método Manual](#método-manual)
3. [Configuración Inicial](#configuración-inicial)
4. [Ejecución y Gestión del Servicio](#ejecución-y-gestión-del-servicio)
5. [Solución de Problemas](#solución-de-problemas)
6. [Actualización de Nova](#actualización-de-nova)
7. [Desinstalación](#desinstalación)
8. [Uso Avanzado](#uso-avanzado)

---

## Requisitos del Sistema

### Hardware Compatible
- **Raspberry Pi 4** (Modelo B, 2GB/4GB/8GB de RAM)
- Tarjeta microSD (mínimo 16GB, recomendado 32GB)
- Fuente de alimentación oficial (5V/3A)
- Conexión a Internet (Ethernet o Wi-Fi)

### Software Requerido
- **Sistema Operativo**: DietPi (versión más reciente recomendada)
- **Node.js**: Versión LTS (18.x o superior)
- **Git**: Para clonar el repositorio
- **Dependencias**: `build-essential`, `python3`, `python3-pip`

---

## Instalación en Raspberry Pi 4 (DietPi)

### Método Automático (Recomendado)

Este método utiliza un script de instalación que automatiza todo el proceso.

#### Paso 1: Descargar el script de instalación

Ejecuta el siguiente comando para descargar el script:

```bash
wget https://raw.githubusercontent.com/bridgeia-chile/Nova/master/install-nova.sh -O install-nova.sh
```

*(Si `wget` no está instalado, instálalo con `sudo apt install wget -y`.)*

#### Paso 2: Dar permisos de ejecución

```bash
chmod +x install-nova.sh
```

#### Paso 3: Ejecutar el script como root

```bash
sudo ./install-nova.sh
```

#### Paso 4: Seguir las instrucciones

El script realizará las siguientes acciones:
1. Verificar que el hardware sea una Raspberry Pi 4.
2. Instalar todos los prerequisitos (Git, Node.js, dependencias).
3. Clonar el repositorio de Nova en `/opt/nova`.
4. Instalar las dependencias de Node.js.
5. Configurar un servicio de systemd para Nova.

---

### Método Manual

Si prefieres instalar Nova manualmente, sigue estos pasos:

#### Paso 1: Actualizar el sistema

```bash
sudo apt update && sudo apt upgrade -y
```

#### Paso 2: Instalar prerequisitos

```bash
# Instalar Git
sudo apt install git -y

# Instalar Node.js (versión LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
sudo apt install nodejs -y

# Instalar dependencias adicionales
sudo apt install build-essential python3 python3-pip -y
```

#### Paso 3: Clonar el repositorio

```bash
sudo git clone https://github.com/bridgeia-chile/Nova.git /opt/nova
```

#### Paso 4: Instalar dependencias de Nova

```bash
cd /opt/nova
sudo npm install --production
```

#### Paso 5: Compilar TypeScript (si es necesario)

```bash
sudo npx tsc
```

#### Paso 6: Configurar permisos

```bash
sudo chown -R dietpi:dietpi /opt/nova
```

#### Paso 7: Configurar el servicio de systemd

```bash
# Copiar el archivo de servicio
sudo cp /opt/nova/nova.service /etc/systemd/system/

# Recargar systemd
sudo systemctl daemon-reload

# Habilitar e iniciar el servicio
sudo systemctl enable nova
sudo systemctl start nova
```

---

## Configuración Inicial

### Archivos de Configuración

Nova utiliza archivos de configuración en JSON ubicados en `/opt/nova/config/`. Los archivos principales son:

- **nova.config.json**: Configuración principal para entornos estándar.
- **nova.config.rpi.json**: Configuración específica para Raspberry Pi.

#### Editar la configuración

1. Abre el archivo de configuración:
   ```bash
   sudo nano /opt/nova/config/nova.config.rpi.json
   ```

2. Ajusta los parámetros según tus necesidades (puertos, rutas, etc.).

3. Guarda los cambios con `Ctrl + O` y sal con `Ctrl + X`.

4. Reinicia el servicio para aplicar los cambios:
   ```bash
   sudo systemctl restart nova
   ```

---

## Ejecución y Gestión del Servicio

### Comandos Básicos

| Comando | Descripción |
|---------|-------------|
| `sudo systemctl start nova` | Iniciar el servicio |
| `sudo systemctl stop nova` | Detener el servicio |
| `sudo systemctl restart nova` | Reiniciar el servicio |
| `sudo systemctl status nova` | Ver el estado del servicio |
| `sudo journalctl -u nova -f` | Ver logs en tiempo real |

### Verificar el Estado

Para verificar que Nova se está ejecutando correctamente:

```bash
sudo systemctl status nova
```

Deberías ver algo como:

```
● nova.service - Nova Service
     Loaded: loaded (/etc/systemd/system/nova.service; enabled; vendor preset: enabled)
     Active: active (running) since [fecha y hora]
```

### Ver Logs

Para diagnosticar problemas, revisa los logs:

```bash
sudo journalctl -u nova -f
```

---

## Solución de Problemas

### Problema: El servicio no se inicia

1. **Verifica los logs**:
   ```bash
   sudo journalctl -u nova -f
   ```

2. **Revisa los permisos**:
   ```bash
   sudo chown -R dietpi:dietpi /opt/nova
   ```

3. **Verifica las dependencias**:
   ```bash
   node --version
   npm --version
   ```

### Problema: Error de conexión

1. **Verifica que el puerto esté abierto**:
   ```bash
   sudo netstat -tulnp | grep [puerto]
   ```

2. **Revisa la configuración de red**:
   ```bash
   sudo nano /opt/nova/config/nova.config.rpi.json
   ```

### Problema: Falta memoria

1. **Libera memoria**:
   ```bash
   sudo apt install htop -y
   htop
   ```

2. **Aumenta la memoria swap** (si es necesario):
   ```bash
   sudo dphys-swapfile swapoff
   sudo nano /etc/dphys-swapfile
   ```
   *(Ajusta `CONF_SWAPSIZE` a un valor mayor, como `2048`.)*

---

## Actualización de Nova

Para actualizar Nova a la última versión:

```bash
# Detener el servicio
sudo systemctl stop nova

# Navegar al directorio de Nova
cd /opt/nova

# Actualizar el repositorio
sudo git pull origin master

# Instalar nuevas dependencias (si las hay)
sudo npm install --production

# Recompilar TypeScript (si es necesario)
sudo npx tsc

# Reiniciar el servicio
sudo systemctl start nova
```

---

## Desinstalación

Para desinstalar Nova completamente:

```bash
# Detener y deshabilitar el servicio
sudo systemctl stop nova
sudo systemctl disable nova

# Eliminar el servicio
sudo rm /etc/systemd/system/nova.service
sudo systemctl daemon-reload

# Eliminar el directorio de Nova
sudo rm -rf /opt/nova

# Opcional: Eliminar dependencias (si ya no son necesarias)
sudo apt remove nodejs npm git build-essential python3-pip -y
```

---

## Uso Avanzado

### Variables de Entorno

Nova soporta variables de entorno para configuración dinámica. Puedes definirlas en `/etc/environment`:

```bash
sudo nano /etc/environment
```

Agrega líneas como:

```
NOVA_PORT=3000
NOVA_ENV=production
```

Luego, reinicia el servicio:

```bash
sudo systemctl restart nova
```

### Ejecución en Segundo Plano (Manual)

Si prefieres ejecutar Nova manualmente en segundo plano:

```bash
cd /opt/nova
sudo npm start &
```

### Depuración

Para depurar Nova, ejecuta:

```bash
cd /opt/nova
sudo node --inspect src/index.js
```

Luego, usa Chrome DevTools para conectarte a `localhost:9229`.

---

## Soporte

Si encuentras problemas o tienes preguntas:

1. **Revisa los logs**: `sudo journalctl -u nova -f`
2. **Consulta la documentación**: [Documentación Oficial de Nova](#)
3. **Abre un issue en GitHub**: [bridgeia-chile/Nova Issues](https://github.com/bridgeia-chile/Nova/issues)

---

## Licencia

Nova es software de código abierto bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

*Última actualización: 2026-03-09*
