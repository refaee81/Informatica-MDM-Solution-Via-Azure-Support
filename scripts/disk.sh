#!/bin/bash
lsblk
growpart /dev/sda 2 
pvresize /dev/sda2
lvextend -r -L 250G "/dev/mapper/rootvg-homelv"
lvextend -r -L 150G "/dev/mapper/rootvg-tmplv" 