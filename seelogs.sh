#!/usr/bin/bash

sudo apt update
sudo apt list --upgradable
sudo apt upgrade 

if [ $echo $? = "0" ]
then
   echo -e "\e[25;1;37mMIS a JOUR OK";
else
   echo "result is not good";
fi
title="Entrez votre choix"
printf "\e[5;31;40m%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
options=("kernel log" "journal logs" "list pid memory usage" "Quit")
select opt in "${options[@]}" 
do
    case $opt in
        ("kernel log")
            echo -e "\e[25;1;31;47mcheck your kernel ?\e[m\n"
            read -n 1 -p "kernel PRESS (d) " ans;
            case $ans in
                 d|D)
                   sudo dmesg --level=err,warn,alert,emerg,crit;;
            esac
            ;;
       ("journal logs")
            echo -e "\e[25;1;33mcheck your logs?"
            read -n 1 -p "logs PRESS (l) " ans;
            case $ans in 
                l|L)
                tail -v  /var/log/syslog |  grep failed && sudo cut -d: -f1 /var/log/boot.log  && /usr/bin/sleep 3  && journalctl -xe
            esac 
            ;;
        ("list pid memory usage")
            echo -e "\e[25;1;32mcheck your pid?"
            read -n1 -p "pid PRESS (p) " ans;
            case $ans in 
                 p|P)
                 ps -aux --sort=-%mem;;
            esac
            ;;
        ("Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

read -n 1 -p "Reboot,shutdown,or Quit? (E/r/s) " ans;

case $ans in
    r|R)
        sudo reboot;;
    s|S)
        sudo poweroff;;
    *)
        exit;;
esac