#!/bin/bash
#Версия v0.2

# Настройки майнера
WAL=3wmGGrKAyhNRMzF5pcyaUNzZAzRupXhMWu
WKN=cpu-1
PW=x

# Интенсивност
COUNT=11
THR=3
INT=-20
MSRMOD=true

# Команда без taskset - ИСПРАВЛЕНО на testv4
BASE_CMD="./miner -Xmx1g -Xms1g -Xss256k -u ${WAL}.${WKN} -h tht.mine-n-krush.org -P 5001 -t $THR -p x"

# Отладчик
log_path="/mnt/ramlogdisk"
log_pattern="miner-*.log"
log_lines_keep=18000
interval=30
ramdisk=true
startlat=1.0

# Окончание настроек

killall java 2>/dev/null || true

# Ramlogdisk
if [ "$ramdisk" = true ]; then
mkdir -p /mnt/ramlogdisk
mount -t tmpfs -o size=1G tmpfs /mnt/ramlogdisk 2>/dev/null || true
else
umount /mnt/ramlogdisk 2>/dev/null || true
rm -rf /mnt/ramlogdisk 2>/dev/null || true
fi

# MSRMOD
if [ "$MSRMOD" = true ]; then
echo "MSRMOD is enabled"
modprobe msr allow_writes=on 2>/dev/null || true
# Даем права на доступ к msr
chmod +r /dev/cpu/*/msr 2>/dev/null || true

if grep -E 'AMD Eng Sample|AMD Ryzen|AMD EPYC' /proc/cpuinfo > /dev/null; then
if grep "cpu family[[:space:]]\{1,\}:[[:space:]]25" /proc/cpuinfo > /dev/null; then
if grep "model[[:space:]]\{1,\}:[[:space:]]97" /proc/cpuinfo > /dev/null; then
echo "Detected Zen4 CPU"
wrmsr -a 0xc0011020 0x4400000000000 2>/dev/null || echo "wrmsr failed - install msr-tools"
wrmsr -a 0xc0011021 0x4000000000040 2>/dev/null || echo "wrmsr failed - install msr-tools"
wrmsr -a 0xc0011022 0x8680000401570000 2>/dev/null || echo "wrmsr failed - install msr-tools"
wrmsr -a 0xc001102b 0x2040cc10 2>/dev/null || echo "wrmsr failed - install msr-tools"
echo "MSR register values for Zen4 applied"
else
echo "Detected Zen3 CPU"
wrmsr -a 0xc0011020 0x4480000000000 2>/dev/null || echo "wrmsr failed - install msr-tools"
wrmsr -a 0xc0011021 0x1c000200000040 2>/dev/null || echo "wrmsr failed - install msr-tools"
wrmsr -a 0xc0011022 0xc000000401570000 2>/dev/null || echo "wrmsr failed - install msr-tools"
wrmsr -a 0xc001102b 0x2000cc10 2>/dev/null || echo "wrmsr failed - install msr-tools"
echo "MSR register values for Zen3 applied"
fi
else
echo "Detected Zen1/Zen2 CPU"
wrmsr -a 0xc0011020 0 2>/dev/null || echo "wrmsr failed - install msr-tools"
wrmsr -a 0xc0011021 0x40 2>/dev/null || echo "wrmsr failed - install msr-tools"
wrmsr -a 0xc0011022 0x1510000 2>/dev/null || echo "wrmsr failed - install msr-tools"
wrmsr -a 0xc001102b 0x2000cc16 2>/dev/null || echo "wrmsr failed - install msr-tools"
echo "MSR register values for Zen1/Zen2 applied"
fi
elif grep "Intel" /proc/cpuinfo > /dev/null; then
echo "Detected Intel CPU"
wrmsr -a 0x1a4 0xf 2>/dev/null || echo "wrmsr failed - install msr-tools"
echo "MSR register values for Intel applied"
else
echo "No supported CPU detected"
echo "Failed to apply MSRMOD"
fi
else
echo "MSRMOD is disabled"
fi

# Запуск экземпляров с привязкой к ядрам
for i in $(seq 0 $((COUNT - 1))); do
SESSION="miner-$((i+1))"
CPU_START=$((i * THR))
CPU_END=$((CPU_START + THR - 1))
CPU_LIST=$(seq -s, $CPU_START $CPU_END)
echo "[+] Запускаю screen-сессию $SESSION на ядрах $CPU_LIST"
screen -L -Logfile /mnt/ramlogdisk/"miner-$((i+1))".log -dmS "$SESSION" bash -c "taskset -c $CPU_LIST $BASE_CMD" 2>/dev/null || echo "Screen failed to start"
sleep "$startlat"
done

