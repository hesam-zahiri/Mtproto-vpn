# Mtproto-vpn

# Guide to Convert MTProto Proxy to VPN

## Table of Contents
```
1. [Installation and Script Execution Guide]
2. [Converting MTProto Proxy to VPN (Advanced)]
3. [Usage on Android]
```
---

## Installation and Script Execution Guide

### 📝 Introduction
This guide explains how to use the script to convert MTProto proxy to VPN.

### 🛠 Prerequisites
- Linux operating system (preferably Debian/Ubuntu-based)
- Root access
- Internet connection

### 📥 Installation
```bash
git clone https://github.com/hesam-zahiri/Mtproto-vpn.git
```
```bash
chmod +x Mtproto-vpn.sh
```

### 🚀 Execution
```bash
sudo ./Mtproto-vpn.sh
```

### 🖥 Usage Guide
Interactive menu:
```
1. Enable VPN
2. Disable VPN 
3. Exit
```

### ❌ Troubleshooting
- Check proxy status
- Check firewall
- View logs: `/var/log/redsocks.log`

### ⚠️ Limitations
- TCP-only support
- Requires root access

---

## Converting MTProto Proxy to VPN (Advanced)

### Prerequisites
- Linux server
- Root access
- MTProto proxy

### Step 1: Install Tools
```bash
sudo apt update
```
```bash
sudo apt install -y python3 python3-pip git redsocks iptables
```

### Step 2: Proxy Setup (Optional)
```bash
git clone https://github.com/alexbers/mtprotoproxy.git
```

```
cd mtprotoproxy
```

```
pip3 install -r requirements.txt
```
```
python3 mtprotoproxy.py
```


### Step 3: Configure redsocks
Edit `/etc/redsocks.conf`:
```ini
redsocks {
    local_ip = 127.0.0.1;
    local_port = 12345;
    ip = [IP_PROXY_MTProto];
    port = [PORT_PROXY];
    type = socks5;
}
```
Then:
```bash
sudo systemctl restart redsocks
```

### Step 4: Configure iptables
```bash
sudo iptables -t nat -N REDSOCKS
sudo iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
# ... (other iptables rules)
sudo iptables -t nat -A OUTPUT -p tcp -j REDSOCKS
```

### Step 5: Create TUN Interface
```bash
git clone https://github.com/xjasonlyu/tun2socks.git
cd tun2socks
make
sudo ./tun2socks -device tun0 -proxy socks5://127.0.0.1:12345
sudo ip addr add 10.0.0.1/24 dev tun0
sudo ip link set tun0 up
```

### Connection Test
```bash
curl --socks5 127.0.0.1:12345 ifconfig.me
```

---

## Usage on Android

### Non-Root Method with Proxydroid
1. Convert proxy to SOCKS5:
- You can use the [MTProto-to-SOCKS](https://github.com/TelegramMessenger/MTProxy-to-SOCKS) script for conversion.

2. Proxydroid Settings:
```
Host: Server address
Port: Port number
Type: SOCKS5
```

### Root Method on Android
1. Install Termux
2. Execute the script
3. Configure Android iptables

### ⚠️ Important Notes
- Only TCP is supported
- Requires the app to remain active
- May not be compatible with some apps

---

## 📧 Contact
- GitHub: [github.com/hesam-zahiri](https://github.com/hesam-zahiri)
