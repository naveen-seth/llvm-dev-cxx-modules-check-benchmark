#!/usr/bin/env bash

echo "Disabling address space randomization"
echo 0 > /proc/sys/kernel/randomize_va_space

echo "Setting scaling_governor to performance"
for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
  echo performance > "$i"
done

