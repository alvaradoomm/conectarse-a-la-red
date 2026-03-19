#!/usr/bin/env bash

function ayuda {
	echo "
	Script que permite conectar tu equipo de cómputo a una red de forma interactiva.
	"
}

CONFIG_FILE="/etc/network_manager_script.conf"

function mostrar_interfaces {
echo "Interfaces disponibles: "
ip -o link show | awk -F': ' '{print $2}' | while read iface; do
estado=$(cat /sys/class/net/$iface/operstate)
echo "- $iface ($estado)"
done
}

function cambiar_estado {
read -p "Interfaz: " iface
read -p "Estado (up/down): " estado

sudo ip link set "$iface" "$estado"
echo "Estado cambiado."
}

function escanear_wifi {
read -p "Interfaz inalámbrica: " iface
sudo iw dev "$iface" scan | grep SSID
}

function conectar_wifi {
read -p "Interfaz: " iface
read -p "SSID: " ssid
read -p "Contraseña (dejar vacío si es abierta): " pass

if [ -z "$pass" ]; then
    nmcli dev wifi connect "$ssid" ifname "$iface"
else
    nmcli dev wifi connect "$ssid" password "$pass" ifname "$iface"
fi
}

function conectar_cable {
read -p "Interfaz: " iface
sudo dhclient "$iface"
}

function configurar_ip {
read -p "Interfaz: " iface
read -p "Tipo (dhcp/static): " tipo


if [ "$tipo" == "dhcp" ]; then
    sudo dhclient "$iface"
    echo "DHCP aplicado."
    echo "$iface dhcp" | sudo tee -a "$CONFIG_FILE"
else
    read -p "IP: " ipaddr
    read -p "Mascara (ej 24): " mask
    read -p "Gateway: " gw

    sudo ip addr flush dev "$iface"
    sudo ip addr add "$ipaddr/$mask" dev "$iface"
    sudo ip route add default via "$gw"

    echo "$iface static $ipaddr/$mask $gw" | sudo tee -a "$CONFIG_FILE"
fi
}

function aplicar_config_guardada {
if [ ! -f "$CONFIG_FILE" ]; then
echo "No hay configuración guardada."
return
fi
while read line; do
    set -- $line
    iface=$1
    tipo=$2

    if [ "$tipo" == "dhcp" ]; then
        sudo dhclient "$iface"
    else
        ipaddr=$3
        gw=$4

        sudo ip addr flush dev "$iface"
        sudo ip addr add "$ipaddr" dev "$iface"
        sudo ip route add default via "$gw"
    fi
done < "$CONFIG_FILE"
}

while true; do
echo ""
echo "1) Mostrar interfaces"
echo "2) Cambiar estado"
echo "3) Conectar cable"
echo "4) Escanear WiFi"
echo "5) Conectar WiFi"
echo "6) Configurar IP"
echo "7) Aplicar config guardada"
echo "8) Salir"

read -p "Opcion: " op

case $op in
    1) mostrar_interfaces ;;
    2) cambiar_estado ;;
    3) conectar_cable ;;
    4) escanear_wifi ;;
    5) conectar_wifi ;;
    6) configurar_ip ;;
    7) aplicar_config_guardada ;;
    8) exit ;;
    *) echo "Opcion invalida" ;;
esac

done
