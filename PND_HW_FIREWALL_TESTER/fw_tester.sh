#!/bin/bash

# --- Define all the hosts IP ---
hosts=( 100.100.6.2 #web server
		100.100.6.3 #proxy
		100.100.1.2 #domain controller
		100.100.1.3 #log server
		100.100.2.100 #kali machine
		100.100.2.254 #arpwatch
		100.100.4.100 #client external 1
		100.100.4.10 #fantastic coffee
)

# --- Define all the services ---
http=80
https=443
ssh=22

echo -e "\e[95m              ****************************************"
echo          "              ************ Firewall tests ************"
echo -e       "              ****************************************\e[0m"
echo ""

if ifconfig | grep -q "tap0"; then # If my host
	IP=$(hostname -I | cut -d " " -f 2)

	# --- PING TEST TO ALL THE HOSTS IN THE ACME NETWORK ---
	echo ""
	echo -e "\e[96m--- PING TEST TO ALL THE HOSTS IN THE ACME NETWORK FROM INTERNET ---"
	echo ""	
	for ip in "${hosts[@]}"; do
		ping -c 1 $ip > /dev/null
		if [ $?	-eq 1 ]
		then
			if [ $ip = ${hosts[0]} ]
			then
				echo -e "\e[31mWARNING: can't ping webserver\e[0m"
			else
				echo -e "\e[92mCan't ping "$ip", firewall is working -> OK\e[0m"
			fi
		else
			echo -e "\e[32mCorrect ping to "$ip"\e[0m"
		fi
	done

	# --- LINK TEST TO THE WEBSERVER ---
	echo ""
	echo -e "\e[96m--- LINK TEST TO WEBSERVER ---\e[0m"
	echo ""
	nc -vz ${hosts[0]} $http 2> /dev/null
	if [ $? -eq 0 ]
	then
		echo -e "\e[92mConnection succeeded\e[0m"
	fi

else # If ACME host
	IP=$(hostname -I)
fi
