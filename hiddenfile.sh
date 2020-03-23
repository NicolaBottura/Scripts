#!/bin/bash

hex=$1
image=$2

echo "Welcome to HiddenFile."
echo "Created by @Nicola Bottura."

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


if [ $# -eq 0 ] ; 
then
	echo "Usage ./hex_to_dec.sh <hexadecimal string> <image_path>" ;
else
	dec=$((16#$hex)) ;
	echo "Decimal version: $dec" ;

	dd if=$image bs=1 skip=$dec of=hidden_zip.zip
fi
