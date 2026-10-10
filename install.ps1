#
# powershell script to install the Fireball Collector
# copyright Mark McIntyre, 2026-

# NB: this script must be run in an Anaconda Powershell prompt
# See the README for more.

Function Test-IsCommand {
 Param ($command)
 $oldPreference = $ErrorActionPreference
 $ErrorActionPreference = 'stop'
 try { if (Get-Command $command) { RETURN $true } }
 Catch { RETURN $false }
 Finally { $ErrorActionPreference = $oldPreference }
}
#end function test-CommandExists

$fbenv = "fbcollector"
$gotconda = (test-iscommand conda)
$envactive = ($env:conda_default_env -eq $fbenv)
if (test-path env:conda_prefix_1) { $gotenv = (test-path $env:conda_prefix_1\envs\$fbenv ) }
else { $gotenv = (test-path $env:conda_prefix\envs\$fbenv ) }

# echo "$gotconda $envactive $gotenv"

if ($gotconda) {
    if ($gotenv -eq $false) { echo "creating conda environment" ; conda create -y -n $fbenv python=3.12 }
	if ($envactive -eq $false) { conda activate $fbenv }
	pip install -r $psscriptroot\requirements.txt
	if ($envactive -eq $false) { conda deactivate }
}
else {
	echo ""
	echo "This application requires miniconda or anaconda. If you've already"
    echo "installed conda, make sure you're running in a Conda powershell prompt."
    echo "see the README for more details."
	echo ""
	pause
}
echo ""
echo "done. To use the application, run .\fbCollector.ps1"
