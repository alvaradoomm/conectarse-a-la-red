Script de conexión de red (Linux)

Este script permite gestionar la conexión de red de forma interactiva desde terminal. Está pensado para pruebas, prácticas o entornos simples.

Requisitos
  Linux con:
    ip (iproute2)
    nmcli (NetworkManager)
    iw
    dhclient
* Permisos de superusuario (sudo)

Ejecución
chmod +x script.sh
./script.sh

Funcionalidades

  1. Ver interfaces
    Muestra todas las interfaces disponibles junto con su estado actual (up/down).

  2. Cambiar estado de interfaz
    Permite activar o desactivar una interfaz manualmente.

  3. Conexión por cable
    Levanta la interfaz y obtiene IP automáticamente mediante DHCP.

  4. Escaneo de redes WiFi
    Lista los SSID disponibles usando la interfaz inalámbrica.

  5. Conexión a red WiFi
    Permite conectarse a una red:
      Abierta (sin contraseña)
      Protegida (requiere contraseña)

  6. Configuración de IP
    Permite elegir:
    DHCP (automático)
    Estática (IP, máscara y gateway)

  La configuración se guarda en:
  /etc/net_script.conf

  7. Cargar configuración guardada
    Aplica la última configuración guardada manualmente.


Notas importantes
* La persistencia no es automática al reiniciar el sistema.
* El script no reemplaza un gestor de red real.
* Puede haber conflictos si NetworkManager ya está controlando la interfaz.
* No valida errores avanzados (ej: contraseña incorrecta, red inexistente, etc.)

Ejemplo de uso
1. Ejecutar el script
2. Elegir opción "1" para ver interfaces
3. Elegir opción "5" para conectarse a WiFi
4. Elegir opción "6" para configurar IP

Limitaciones
* No soporta configuraciones complejas (VLAN, bridges, etc.)
* No detecta automáticamente el tipo de interfaz
* No guarda múltiples configuraciones
