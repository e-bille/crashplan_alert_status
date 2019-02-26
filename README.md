# crashplan_alert_status
Extension attribute designed for Jamf Pro. It will report back the backup-status of a client computer backing up to Code42 Crashplan.
The script is developed, tested and implemented with Jamf Pro 10.8, Code42 for Enterprise v.6.8.6

It will return one of the following statuses: 
* NotInstalled: The Code42 clinet is not installed on the computer
* InstalledNoConfig: The client is installed, but no configuration or incorect config is in place. 
* OK: Everything is mighty fine!
* CriticalConnectionAlert: Device have not been in contact with Crashplan for the specified critical limit (Code42 setting)
* WarningConnectionAlert: Device have not been in contact with Crashplan for the specified warning limit (Code42 setting

**Please replace the place holders for the variables with your server details.**
