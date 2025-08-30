#!/bin/bash
echo "===== Server Performance Stats ====="
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1 "%"}')

echo "Total CPU Usage: $cpu_usage"
mem_total=$(free -m | awk '/Mem:/ {print $2}')
mem_used=$(free -m | awk '/Mem:/ {print $3}')
mem_percent=$(awk "BEGIN {printf \"%.2f\", ($mem_used/$mem_total)*100}")

echo "Memory Usage: $mem_used MB / $mem_total MB ($mem_percent%)"
disk_used=$(df -h / | awk 'NR==2 {print $3}')
disk_total=$(df -h / | awk 'NR==2 {print $2}')
disk_percent=$(df -h / | awk 'NR==2 {print $5}')

echo "Disk Usage: $disk_used / $disk_total ($disk_percent)"

echo "Top 5 Processes by CPU:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

echo "Top 5 Processes by Memory:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

echo "OS Version: $(uname -a)"

echo "Uptime: $(uptime -p)"

echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"

echo "Logged-in Users:"
who

echo "Failed Login Attempts:"
if [ -r /var/log/auth.log ]; then
	grep "Failed password" /var/log/auth.log | wc -l
else
	echo "auth.log not found or not readable"
fi