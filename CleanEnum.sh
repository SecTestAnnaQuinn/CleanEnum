#!/bin/bash

# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
cyan='\033[0;36m'
clear='\033[0m'

ip=$1

Enumerator() {
	echo -e "$red Running enum4linux, this may take a while $clear" "\n\n"
	enum4linux -u '' -p '' -val "$ip" > enum
	UserList
}

UserList() { 

	echo -e "$yellow ========================================(     User Descriptions on $blue $ip $yellow     )========================================" "\n" $clear | tee "UserDescriptions@$ip"
	echo -e $yellow "Full Name \t\t\t\t Description" > "UserDescriptions@$ip"
	echo -e $blue "==============================================================================" $clear >> "UserDescriptions@$ip"
	cat enum | grep "index" | awk -F "Name:" '{print $2}' | awk -F "Desc" '{print $1 ":" $2}' | tr -d "\t"| sed -e 's/Desc//g' | awk -F ": " '{print $1 $2}' | column -s ":" -t >> "UserDescriptions@$ip"
	GetDomain
	UserNames
}

GetDomain() {
	Domain=$(cat enum | grep 'Got domain/workgroup name:' | awk -F ": " '{print $2}') 
}

UserNames() {
	echo -e "$yellow ========================================(         Usernames on $blue $ip $yellow         )========================================" "\n" $clear | tee "Usernames@$ip"
	cat enum | grep "user:\[" | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' | sort | uniq > Names.txt
	while IFS= read -r line; do
		echo $Domain'\'$line >> "Usernames@$ip"
	done < Names.txt
	rm Names.txt
	PasswordPolicy
}

PasswordPolicy() {
	echo -e "$yellow ========================================(     Password Policies on $blue $ip $yellow     )========================================" "\n" $clear | tee "PasswordPolicies@$ip"
	cat enum | grep "Password Info for Domain" -A 18 >> "PasswordPolicies@$ip"
	DomainGroups
}

DomainGroups() {
	echo -e "$yellow ========================================(       Domain Groups on $blue $ip $yellow       )========================================" "\n" $clear | tee "DomainGroups@$ip"
	cat enum | grep "Getting domain groups" -A 100000 | grep "group:\[" | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' >> "DomainGroups@$ip"
	cat enum | grep "Getting domain groups" -A 100000 | grep "group:\[" | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' > "DomainGroupstemp@$ip"
	GroupMembership
}

GroupMembership() {
	echo -e "$yellow ========================================(  Domain Group Membership on $blue $ip $yellow  )========================================" "\n" $clear | tee "DomainGroupMembership@$ip"
	cat enum | grep "Getting domain group membership" -A 100000 > GroupMembership.txt
	while IFS= read -r line; do
		echo -e "$blue Domain Group Membership for $cyan $line $clear" >> "DomainGroupMembership@$ip" 
		cat GroupMembership.txt | grep "$line" | awk -F ": " '{print $4}' >> "DomainGroupMembership@$ip"
		echo -e "\n" "\n" "\n" >> "DomainGroupMembership@$ip" 
		echo -e "$green ===================================================================" >> "DomainGroupMembership@$ip"
	done < "DomainGroupstemp@$ip"
	echo -e "$yellow ========================================(                  $green Done! $yellow                   )========================================" 
	rm "DomainGroupstemp@$ip"
	rm GroupMembership.txt
	rm enum
}

Enumerator

