#!/bin/bash

# Convert MTProto proxy to VPN
# https://Github.com/hesam-zahiri

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run with root access!"
  exit 1
fi

install_dependencies() {
  echo "[*] Installing prerequisites..."
  apt-get update >/dev/null 2>&1
  apt-get install -y redsocks iptables iproute2 curl >/dev/null 2>&1
}

get_proxy_info() {
  echo -n "MTProto proxy server address (example: proxy.example.com): "
  read PROXY_IP
  echo -n "Proxy port (usually 443): "
  read PROXY_PORT
  echo -n "Proxy secret key: "
  read PROXY_SECRET
}

configure_redsocks() {
  echo "[*] Setting up redsocks..."
  cat > /etc/redsocks.conf <<EOL
base {
    log_debug = off;
    log_info = off;
    log = "file:/var/log/redsocks.log";
    daemon = on;
    redirector = iptables;
}

redsocks {
    local_ip = 127.0.0.1;
    local_port = 1080;
    ip = $PROXY_IP;
    port = $PROXY_PORT;
    type = socks5;
}
EOL

  systemctl restart redsocks
  echo "[+] redsocks configured successfully"
}

configure_iptables() {
  echo "[*] Configuring iptables..."
  
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X
  
  # Redirect traffic to redsocks
  iptables -t nat -N REDSOCKS
  iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
  iptables -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
  iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
  iptables -t nat -A REDSOCKS -d 169.254.0.0/16 -j RETURN
  iptables -t nat -A REDSOCKS -d 172.16.0.0/12 -j RETURN
  iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
  iptables -t nat -A REDSOCKS -d 224.0.0.0/4 -j RETURN
  iptables -t nat -A REDSOCKS -d 240.0.0.0/4 -j RETURN
  iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 1080
  iptables -t nat -A OUTPUT -p tcp -j REDSOCKS
  
  echo "[+] iptables successfully configured"
}

setup_tun_interface() {
  echo "[*] Creating TUN interface..."
  
  ip link delete dev tun0 >/dev/null 2>&1
  ip tuntap add mode tun dev tun0
  ip addr add 10.8.0.1/24 dev tun0
  ip link set tun0 up
  
  echo "[+] TUN interface created successfully"
}

show_status() {
  echo ""
  echo "========================================"
  echo "VPN configuration completed successfully!"
  echo "----------------------------------------"
  echo "Proxy address: $PROXY_IP:$PROXY_PORT"
  echo "TUN interface: tun0 (10.8.0.1/24)"
  echo "To disable, run the script again"
  echo "========================================"
  echo ""
}

disable_vpn() {
  echo "[*] Disabling VPN..."
  
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X
  
  ip link delete dev tun0 >/dev/null 2>&1
  systemctl stop redsocks
  
  echo "[+] VPN successfully disabled"
  exit 0
}

main_menu() {
  clear
  echo "Convert MTProto proxy to VPN"
  echo "----------------------------------------"
  echo "1. Enable VPN"
  echo "2. Disable VPN"
  echo "3. Exit"
  echo -n "Select [1-3]: "
  read choice

  case $choice in
    1)
      install_dependencies
      get_proxy_info
      configure_redsocks
      configure_iptables
      setup_tun_interface
      show_status
      ;;
    2)
      disable_vpn
      ;;
    3)
      exit 0
      ;;
    *)
      echo "Invalid option!"
      sleep 1
      main_menu
      ;;
  esac
}

main_menu
