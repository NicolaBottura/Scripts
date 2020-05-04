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
services=(	80 #HTTP
		443 #HTTPS
		22 #SSH
	        53 # DNS
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
		if [ $ip = $IP ]
		then
			continue
		else
			ping -c 1 $ip > /dev/null
			if [ $?	-eq 1 ]
			then
				echo -e "\e[92mCan't ping "$ip", firewall is working -> OK\e[0m"
			else
				echo -e "\e[91mWARNING: successful ping to "$ip"\e[0m"
			fi
		fi
	done

	# --- CONNECTION TO SERVICES TEST ---
	echo ""
	echo -e "\e[96m--- CONNECTION TO TCP SERVICES TEST ---\e[0m"
	echo ""
	for ip in "${hosts[@]}"; do
		for port in "${tcp_services[@]}"; do
			if [ $ip = $IP ] || [[ $port -eq 22 ]]
			then
				continue
			else
				echo -e "\e[95mConnecting to "$ip" port "$port"\e[0m"
				nc -vz $ip $port -w 3 2> /dev/null
				if [ $? -eq 0 ]
				then
					echo -e "\e[92mConnection succeeded\e[0m"
				else
					echo -e "\e[91mWARNING: can't connect to webserver\e[0m"
				fi
			fi
		done
	done

	# --- CONNECTION TO UDP SERVICES TEST ---
	echo ""
	echo -e "\e[96m--- CONNECTION TO UDP SERVICES TEST ---\e[0m"
	echo ""
	for ip in "${hosts[@]}"; do
		for port in "${udp_services[@]}"; do
			if [ $ip = $IP ]
			then
				continue
			else
				echo -e "\e[95mConnecting to "$ip" port "$port"\e[0m"
				nc -vz $ip $port -w 3 2> /dev/null
				if [ $? -eq 0 ]
				then
					echo -e "\e[92mConnection succeeded\e[0m"
				else
					echo -e "\e[91mWARNING: can't connect to webserver\e[0m"
				fi
			fi
		done
	done

elif [ $(hostname -I) = ${hosts[4]} ] || [ $(hostname -I) = ${hosts[5]} ]; # If CLIENT NET host
then
	IP=$(hostname -I)
	
	# --- PING TEST TO ALL THE HOSTS IN THE ACME NETWORK ---
	echo ""
	echo -e "\e[96m--- PING TEST TO ALL THE HOSTS IN THE ACME NETWORK FROM CLIENT NET ---"
	echo ""
	for ip in "${hosts[@]}"; do
		if [ $ip = $IP ]
		then
			continue
		else
			ping -c 1 $ip > /dev/null
			if [ $?	-eq 1 ]
			then
				echo -e "\e[92mCan't ping "$ip", firewall is working -> OK\e[0m"
			else
				echo -e "\e[91mWARNING: successful ping to "$ip"\e[0m"
			fi
		fi
	done

	# --- CONNECTION TO SERVICES TEST ---
	echo ""
	echo -e "\e[96m--- CONNECTION TO SERVICES TEST ---\e[0m"
	echo ""
	
	echo -e "\e[44m------------ Connecting to "${hosts[3]}" port "${services[3]}" ------------\e[0m"
	echo ""
	host proxyserver.acme-14.test > /dev/null # DNS on dc machine test
	if [ $? -eq 0 ]
	then
		echo -e "\e[92mConnection succeeded\e[0m"
	else
		echo -e "\e[91mWARNING: can't connect\e[0m"
	fi
	echo ""

	for ip in "${hosts[@]}"; do
		for port in "${services[@]}"; do
			if [ $ip = $IP ] || [[ $port -eq 53 ]]
			then
				continue

			# RICORDA DI CREARE UN UTENTE TEST SU TUTTI GLI HOST PER TESTARE SSH
			elif [[ $port -eq 22 ]]
			then
				echo -e "\e[44m------------ Connecting to "$ip" port "$port" ------------\e[0m"
				echo ""
				status=$(ssh -o BatchMode=yes -o ConnectTimeout=5 test@$ip echo ok 2>&1)

				if [[ status == ok ]]
				then
					echo -e "\e[92mCan SSH connect\e[0m"
				elif [[ $status == "Permission denied"* ]]
				then
					echo -e "\e[92mCan SSH connect, but no auth\e[0m"
				else
					echo -e "\e[91mCan't SSH connect\e[0m"
				fi
				echo ""

			elif [[ $port -eq 514 ]]
			then
				echo -e "\e[44m------------ Connecting to "$ip" port "$port" ------------\e[0m"
				echo ""
				nc -v -z -u -w 3 2> /dev/null
				if [ $? -eq 0 ]
				then
					echo -e "\e[92mConnection succeeded\e[0m"
				else
					echo -e "\e[91mWARNING: can't connect\e[0m"
				fi
				echo ""

			else
				echo -e "\e[44m------------ Connecting to "$ip" port "$port" ------------\e[0m"
				echo ""
				nc -vz $ip $port -w 3 2> /dev/null
				if [ $? -eq 0 ]
				then
					echo -e "\e[92mConnection succeeded\e[0m"
				else
					echo -e "\e[91mWARNING: can't connect\e[0m"
				fi
				echo ""
			fi
		done
	done

fi
