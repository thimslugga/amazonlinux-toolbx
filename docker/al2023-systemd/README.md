# Amazon Linux 2023 Systemd

## Description

This is a customer container image based off Amazon Linux 2023 but with systemd installed and enabled.

```shell
bash-5.2# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.5  0.0  19360 11896 ?        Ss   00:44   0:00 /usr/sbin/init
root          16  0.0  0.0  31984 10204 ?        Ss   00:44   0:00 /usr/lib/systemd/systemd-journald
systemd+      21  0.3  0.0  16928  8720 ?        Ss   00:44   0:00 /usr/lib/systemd/systemd-networkd
systemd+      27  1.4  0.0  19348 12528 ?        Ss   00:44   0:00 /usr/lib/systemd/systemd-resolved
root          31  0.3  0.0  15568  7420 ?        Ss   00:44   0:00 /usr/lib/systemd/systemd-logind
dbus          33  1.0  0.0   8340  3952 ?        Ss   00:44   0:00 /usr/bin/dbus-broker-launch --scope system --audit
dbus          37  0.0  0.0   5000  2704 ?        S    00:44   0:00 dbus-broker --log 4 --controller 9 --machine-id 8e4b65769c4649358be523ce4a11a7cf --max-bytes 536870912 --max-fds 4096 --max-matches 16384 --audit
root          39  0.0  0.0   4236  3260 pts/1    Ss   00:44   0:00 /bin/sh -c if command -v bash >/dev/null 2>&1; then bash; else sh; fi
root          40  0.0  0.0   4500  3688 pts/1    S    00:44   0:00 bash
root          41  0.0  0.0   4720  2552 pts/1    R+   00:44   0:00 ps aux
```

```shell
bash-5.2# cat /etc/os-release
NAME="Amazon Linux"
VERSION="2023"
ID="amzn"
ID_LIKE="fedora"
VERSION_ID="2023"
PLATFORM_ID="platform:al2023"
PRETTY_NAME="Amazon Linux 2023.6.20241121"
ANSI_COLOR="0;33"
CPE_NAME="cpe:2.3:o:amazon:amazon_linux:2023"
HOME_URL="https://aws.amazon.com/linux/amazon-linux-2023/"
DOCUMENTATION_URL="https://docs.aws.amazon.com/linux/"
SUPPORT_URL="https://aws.amazon.com/premiumsupport/"
BUG_REPORT_URL="https://github.com/amazonlinux/amazon-linux-2023"
VENDOR_NAME="AWS"
VENDOR_URL="https://aws.amazon.com/"
SUPPORT_END="2028-03-15"
bash-5.2#
```

## Build

```shell
podman build . -t amazonlinux2023-systemd -f Containerfile
```

## Run

```shell
podman run -d --name amazonlinux2023-systemd amazonlinux2023-systemd
```

