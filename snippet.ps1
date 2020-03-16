param(
 [string]$CHOICE1,
 [string]$CHOICE2,
 [string]$CHOICE3,
 [string]$CHOICE4
)

switch ( $CHOICE1 )
{
create-role { 
	connect-viserver -server $CHOICE2
	new-virole -name $CHOICE3 -privilege (get-viprivilege -id global.diagnostics, global.health, global.licenses, global.settings, system.anonymous, system.view, system.read)
	disconnect-viserver -confirm:$false
	}

check-role { 
	connect-viserver -server $CHOICE2
	get-virole $CHOICE3 | get-viprivilege | select Id
	disconnect-viserver -confirm:$false
	}

add-2-role { 
	connect-viserver -server $CHOICE2
	new-vipermission -entity (get-folder -norecursion) -principal $CHOICE3 -role $CHOICE4 -propagate:$true 
	disconnect-viserver -confirm:$false
	}
 
check-account { 
	connect-viserver -server $CHOICE2
	get-vipermission -principal $CHOICE3
	disconnect-viserver -confirm:$false
	}

skyline-prep {
 	Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
 	choco install putty
	choco install curl
	}

check-update {plink -ssh root@$CHOICE2 -no-antispoof "/opt/vmware/bin/vamicli update --check" }

install-update {plink -ssh root@$CHOICE2 -no-antispoof "/opt/vmware/bin/vamicli update --install latest --accepteula" }

check-version {plink -ssh root@$CHOICE2 -no-antispoof "/opt/vmware/bin/vamicli version --appliance" }

nsx-prep { install-module PowerNSX }

check-nsxaccount { 
	connect-nsxserver -vCenterServer $CHOICE2
	get-nsxuserrole $CHOICE3 
	disconnect-nsxserver -confirm:$false
	}

vrops-prep { install-module Vmware.VimAutomation.vROps }

check-vropsaccount { 
	connect-omserver $CHOICE2
	get-omuser $CHOICE3
	disconnect-omserver -confirm:$false
	}

default { 
	''
	'USAGE: skyline-help.ps1 ARG VARIABLE' 
	'		(vcenter arg): 	[create-role|check-role|add-2-role|check-account]'
	'		(skyline arg):	[skyline-prep|check-update|install-update|check-version]'
	'		(nsx arg):	[nsx-prep|check-nsxaccount]'
	'		(vrops arg):	[vrops-prep|check-vropsaccount]'
	''
	}
}
