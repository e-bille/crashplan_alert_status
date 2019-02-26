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

CP_ServerAddress="CRASHPLAN_SRV_URL"
CP_ServerPort="CRASHPLAN_SRV_PORT"
CP_AdminUsername="CRASHPLAN_API_ENABLED_ACCOUNT"
CP_AdminPassword="CRASHPLAN_ACCOUNT PASSWD"

if [ -f /Library/Application\ Support/CrashPlan/.identity ];then
	GUID=`/bin/cat /Library/Application\ Support/CrashPlan/.identity | grep guid | sed s/guid\=//g`
	response="<result>`/usr/bin/curl --silent -u "$CP_AdminUsername":"$CP_AdminPassword" -k https://"$CP_ServerAddress":"$CP_ServerPort"/api/computer/"$GUID"?idType=guid | grep -w alertStates | cut -d, -f 12 | cut -d'"' -f 4`</result>"

	if [ ! $response = "<result></result>" ]; then
		echo $response
	else
		echo "<result>InstalledNoConfig</result>"
	fi
else
	echo "<result>NotInstalled</result>"
fi
