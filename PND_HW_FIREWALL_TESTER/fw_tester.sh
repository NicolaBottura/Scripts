#!/bin/bash

# --- Define all the hosts IP ---
hosts=( 	100.100.6.2 #web server
		100.100.6.3 #proxy
		100.100.1.3 #log server
		100.100.1.2 #domain controller
		100.100.2.100 #kali machine
		100.100.2.254 #arpwatch
		100.100.4.100 #client external 1
		100.100.4.10 #fantastic coffee
		100.101.0.2 #my host pc
)

# --- Define all the services ---
tcp_services=(	80 #HTTP
		443 #HTTPS
		22 #SSH
)

udp_services=(  53 # DNS
		514 #log
)

echo -e "\e[95m              ****************************************"
echo          "              ************ Firewall tests ************"
echo -e       "              ****************************************\e[0m"
echo ""

if ifconfig | grep -q "tap0"; then # If executing from my pc
	IP=$(hostname -I | cut -d " " -f 2)

	# --- PING TEST TO ALL THE HOSTS IN THE ACME NETWORK ---
	echo ""
	echo -e "\e[96m--- PING TEST TO ALL THE HOSTS IN THE ACME NETWORK FROM INTERNET ---"
	echo ""
	for ip in "${hosts[@]}"; do
		ping -c 1 $ip > /dev/null
		if [ $?	-eq 1 ]
		then
			echo -e "\e[92mCan't ping "$ip", firewall is working -> OK\e[0m"
		else
			echo -e "\e[31mWARNING: successful ping to "$ip"\e[0m"
		fi
	done

	# --- LINK TEST TO THE WEBSERVER ---
	echo ""
	echo -e "\e[96m--- LINK TEST TO WEBSERVER ---\e[0m"
	echo ""
	for ip in "${hosts[@]}"; do
		for port in "${tcp_services[@]}"; do
			echo -e "\e[95mConnecting to "$ip" port "$port"\e[0m"
			nc -vz $ip $port 2> /dev/null
			if [ $? -eq 0 ]
			then
				echo -e "\e[92mConnection succeeded\e[0m"
			else
				echo -e "\e[31mWARNING: can't connect to webserver\e[0m"
			fi
		done
	done

elif [ $(hostname -I) = ${hosts[5]} ]; # If ACME host
then
	IP=$(hostname -I)
	
	# --- PING TEST TO ALL THE HOSTS IN THE ACME NETWORK ---
	echo ""
	echo -e "\e[96m--- PING TEST TO ALL THE HOSTS IN THE ACME NETWORK FROM KALI MACHINE ---"
	echo ""
	for ip in "${hosts[@]}"; do
		ping -c 1 $ip > /dev/null
		if [ $?	-eq 1 ]
		then
			echo -e "\e[31mCan't ping "$ip"\e[0m"
		else
			echo -e "\e[92mSuccessful ping to "$ip"\e[0m"
		fi
	done

	# --- LINK TEST TO THE LOG SERVER ---
	echo ""
	echo -e "\e[96m--- LINK TEST TO LOG SERVER ---\e[0m"
	echo ""
	nc -vz ${hosts[2]} $log 2> /dev/null
	if [ $? -eq 0 ]
	then
		echo -e "\e[31mWARNING: Connection succeeded\e[0m"
	else
		echo -e "\e[92mCan't connect to log server, firewall is working -> OK\e[0m"
	fi

	# --- SSH TEST TO SERVER AND DMZ NET ---
	echo ""
	echo -e "\e[96m--- SSH TEST TO WEBSERVER ---\e[0m"
	echo ""
	#£for i int {1..2}; do
	#	ssh zentyal@${hosts[i]}	
	#done	
fi
