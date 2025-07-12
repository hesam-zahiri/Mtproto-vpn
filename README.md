# Mtproto-vpn

# Guide to Convert MTProto Proxy to VPN

## Table of Contents
```
1. Installation and Script Execution Guide
2. Converting MTProto Proxy to VPN (Advanced)
3. Usage on Android
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
- You can use the [MTProto-to-SOCKS](https://github.com/hesam-zahiri/mtProto_to_socks5.git) script for conversion.

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

### 🔴 Attention
```
- Sure! Here's the English translation of your text in a formal and technical tone:
MTProto is Telegram’s proprietary protocol.
It is not a general-purpose proxy like SOCKS or HTTPS.
This script, when executed, attempts to establish a connection to a server that only understands MTProto — which means it can only tunnel Telegram traffic through it.
So in this setup, even if we try to route all system traffic through it, nothing except Telegram will work.
However, there's an alternative approach using what's called “fake MTProto.”
Some tools can encrypt general traffic in a way that mimics MTProto (primarily to bypass DPI).
But as the name suggests, it’s not real MTProto.
It only appears to be MTProto on the surface (like fake TLS), while in the backend, it’s just a regular proxy.
This is essentially the same technique that tools like Shadowsocks, obfs, etc., use with WebSockets — where neither Telegram nor censorship systems can tell the difference.
Recently, I came across a project called telegram socks 5 proxy.
I haven’t tested it yet, but the developers claim to have wrapped MTProto inside a simplified WARP-style proxy.
Still, all of these solutions are limited to Telegram usage only — not for routing full system traffic.
The project is basic and needs further development, but the concept is interesting:
If we could somehow convert MTProto into a general-purpose proxy like SOCKS5, it could become much more useful.
However, that’s a highly complex task, because MTProto is an application-specific protocol.
It wasn’t designed to handle general TCP traffic.
The only way we could directly tunnel through MTProto would be to write a custom Telegram-like client that can perform authentication, key exchange, etc.
```
- [telegram socks 5 proxy](https://github.com/alexbers/mtprotoproxy)

---

## 📧 Contact
- GitHub: [github.com/hesam-zahiri](https://github.com/hesam-zahiri)


