#!/bin/bash

hex=$1
image=$2

echo "Welcome to HiddenFile."
echo "Created by Nicola Bottura."

echo "                                  "
echo "     	             ,--.     .--.	"
echo "		    /    \. ./    \	"
echo "		   /  /\ /   \ /\  \	"
echo "		  / _/  {~~v~~}  \_ \	"
echo "		 /     {   |   }     \	"
echo "		;   /\{    |    }/\   \ "
echo "		| _/  {    |    }  \_  :"
echo "		|     {    |    }      |"
echo "		|    /{    |    }\     |"
echo "		|   / {    |    } \    |"
echo "		|  /  {    |    }  \   |"
echo "		|  \  \    |    /  /   |"
echo "		|   \  \   |   /  /    |"
echo "		\    \  \  |  /  /     /"
echo "		 \   /   ~~~~~   \    / "


echo " _   _ _________________ _____ _   _  ______ _____ _      _____  "
echo "| | | |_   _|  _  \  _  \  ___| \ | | |  ___|_   _| |    |  ___| "
echo "| |_| | | | | | | | | | | |__ |  \| | | |_    | | | |    | |__   "
echo "|  _  | | | | | | | | | |  __|| .   | |  _|   | | | |    |  __|  "
echo "| | | |_| |_| |/ /| |/ /| |___| |\  | | |    _| |_| |____| |___  "
echo "\_| |_/\___/|___/ |___/ \____/\_| \_/ \_|    \___/\_____/\____/  "
echo "                                                                 "


if [ $# -eq 0 ] ; 
then
	echo "Usage ./hex_to_dec.sh <hexadecimal string> <image_path>" ;
else
	dec=$((16#$hex)) ;
	echo "Decimal version: $dec" ;

	dd if=$image bs=1 skip=$dec of=hidden_zip.zip
fi
