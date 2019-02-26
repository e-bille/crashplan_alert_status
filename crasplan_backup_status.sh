#!/bin/sh
# Written by Erik Bille
# Version 2.0 2019-02-05

# Extension attribute designed for Jamf Pro. It will report back the backup-status of a client computer backing up to Code42 Crashplan.
# The script is developed, tested and implemented with Jamf Pro 10.8, Code42 for Enterprise v.6.8.6
# 
# It will return one of the following statuses: 
# * NotInstalled: The Code42 clinet is not installed on the computer
# * InstalledNoConfig: The client is installed, but no configuration or incorect config is in place. 
# * OK: Everything is mighty fine!
# * CriticalConnectionAlert: Device have not been in contact with Crashplan for the specified critical limit (Code42 setting)
# * WarningConnectionAlert: Device have not been in contact with Crashplan for the specified warning limit (Code42 setting
#
# Please replace the place holders in for the variables below with your server details. 

CP_ServerAddress="CRASHPLAN_SRV_URL"
CP_ServerPort="CRASHPLAN_SRV_PORT"
CP_AdminUsername="CRASHPLAN_API_ENABLED_ACCOUNT"
CP_AdminPassword="CRASHPLAN_ACCOUNT PASSWD"

# Check if .identity is in place. If not, then Crashplan is not installed
if [ -f /Library/Application\ Support/CrashPlan/.identity ];then
	# Get computer GUID from .identity for API-call later
	GUID=`/bin/cat /Library/Application\ Support/CrashPlan/.identity | grep guid | sed s/guid\=//g`
	# API-call to crashplan
	response="<result>`/usr/bin/curl --silent -u "$CP_AdminUsername":"$CP_AdminPassword" -k https://"$CP_ServerAddress":"$CP_ServerPort"/api/computer/"$GUID"?idType=guid | grep -w alertStates | cut -d, -f 12 | cut -d'"' -f 4`</result>"

	# Check API-response. If empty the the client is not configured or missconfigured
	if [ ! $response = "<result></result>" ]; then
		# API-reponse is not empty. Echo the respons for JAMF Pro to read. 
		echo $response
	else
		echo "<result>InstalledNoConfig</result>"
	fi
else
	# The .identy file is not found and hence Crashplan is not installed
	echo "<result>NotInstalled</result>"
fi
