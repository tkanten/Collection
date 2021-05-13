#!/bin/bash

echo "4" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio4/direction
echo "1" > /sys/class/gpio/gpio4/value
sleep 5

echo "17" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio17/direction
echo "1" > /sys/class/gpio/gpio17/value
sleep 5

echo "27" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio27/direction
echo "1" > /sys/class/gpio/gpio27/value
sleep 5

echo "4" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio4/direction
echo "0" > /sys/class/gpio/gpio4/value
sleep 5

echo "17" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio17/direction
echo "0" > /sys/class/gpio/gpio17/value
sleep 5

echo "27" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio27/direction
echo "0" > /sys/class/gpio/gpio27/value
sleep 5
