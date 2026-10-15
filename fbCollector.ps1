#
# powershell script to run the Fireball Collector
# copyright Mark McIntyre, 2026-

# NB: this script must be run in an Anaconda Powershell prompt
# and you must have created a conda environment "fbcollector"
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

if ($gotconda -and $gotenv) {
	if ($envactive -eq $false) { conda activate $fbenv }
	python $psscriptroot\fireballCollector.py -c $psscriptroot\config.ini $args
	if ($envactive -eq $false) { conda deactivate }
}
else {
	echo ""
	echo "unable to activate conda environment"
	echo "make sure you're running in an Anaconda Powershell prompt and "
	echo "have created the $fbenv conda environment - see the README."
	echo ""
	pause
}
