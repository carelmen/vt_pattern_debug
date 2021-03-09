#!/bin/bash

sigrok-cli -I csv:header=yes -i ../93kvt/i2c.csv  -P i2c:sda=I2C_SDA:scl=I2C_SCL  | grep  Data|Address
