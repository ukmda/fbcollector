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
}
else {
	echo ""
	echo "This application requires miniconda or anaconda. If you've already"
    echo "installed conda, make sure you're running in a Conda powershell prompt."
    echo "see the README for more details."
	echo ""
	pause
}
$wmplloc = "$HOME/src/WesternMeteorPyLib"
if ((test-path $wmplloc\UpdateOrbitFiles.py) -eq $true) {
    echo "`nWMPL found at $wmplloc"
}
else {
    $wmplloc = "nowhere"
    while ($wmplloc -eq "nowhere" ) {
        $wmplloc = read-host -prompt "`n`nPlease enter the full path to WMPL or press <enter> to install it "
        if ($wmplloc -eq  "") {
            $wmplloc = "$HOME/src/WesternMeteorPyLib"
            echo "installing WMPL into $wmplloc"
            mkdir ~/src
            pushd ~/src
            git clone --recursive https://github.com/wmpg/WesternMeteorPyLib.git
            cd WesternMeteorPyLib
            Remove-Item -Recurse wmpl/MetSim
            Remove-Item -Recurse wmpl/CAMO
            Remove-Item wmpl/Utils/DynamicMassFit.py
            python ./UpdateOrbitFiles.py
            curl "https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/de430.bsp" -o $wmplloc/wmpl/share/de430.bsp
            python -c "from wmpl.Utils.ShowerAssociation import loadGMNShowerTable"
            popd
        }
        if ((test-path $wmplloc\UpdateOrbitFiles.py) -eq $false) {
            echo "WMPL not found in $wmplloc, please re-enter"
            $wmplloc = "nowhere"
        }
    }
}
echo "TODO do something to store wmplloc in the config file"

if ($envactive -eq $false) { conda deactivate }
echo ""
echo "done. To use the application, run .\fbCollector.ps1"
