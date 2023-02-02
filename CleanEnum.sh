#!/bin/bash

ip=$1

Enumerator() {
	enum4linux -u '' -p '' -val "$ip" | tee enum
	UserList
}

UserList() { 
	echo "========================================( Users on $ip )========================================" | tee "UserDescriptions@$ip"
	cat enum | grep "index" | awk -F "Name:" '{print $2}' | sort | uniq >> "UserDescriptions@$ip"
	GetDomain
	UserNames
}

GetDomain() {
	Domain=$(cat enum | grep 'Got domain/workgroup name:' | awk -F ": " '{print $2}') 
}

UserNames() {
	echo "========================================( Usernames on $ip )========================================" | tee "Usernames@$ip"
	cat enum | grep "user:\[" | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' | sort | uniq > Names.txt
	while IFS= read -r line; do
		echo "$Domain"'\'"$line" >> "Usernames@$ip"
	done < Names.txt
	rm Names.txt
	PasswordPolicy
}

PasswordPolicy() {
	echo "========================================( Password Policies on $ip )========================================" | tee "PasswordPolicies@$ip"
	cat enum | grep "Password Info for Domain" -A 18 >> "PasswordPolicies@$ip"
	DomainGroups
}

DomainGroups() {
	echo "========================================( Domain Groups on $ip )========================================" | tee "DomainGroups@$ip"
	cat enum | grep "Getting domain groups" -A 3000 | grep "group:\[" | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' >> "DomainGroups@$ip"
	GroupMembership
}

GroupMembership() {
	echo "========================================( Domain Group Membership on $ip )========================================" | tee "DomainGroupMembership@$ip"
	cat enum | grep "Getting domain group membership" -A 10000 > GroupMembership.txt
	while IFS= read -r line; do
		echo "Getting Group Membership for $line" >> "DomainGroupMembership@$ip" 
		cat GroupMembership.txt | grep "$line" | awk -F ": " '{print $4}' >> "DomainGroupMembership@$ip"
		echo -e "\n" "\n" "\n" >> "DomainGroupMembership@$ip" 
		echo "===================================================================" >> "DomainGroupMembership@$ip"
	done < "DomainGroups@$ip"
  echo "========================================( Done! )========================================"
	rm GroupMembership.txt
	rm enum
}

Enumerator

