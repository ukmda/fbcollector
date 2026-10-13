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

pushd $psscriptroot

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
    copy $PSScriptRoot\config.ini.sample $PSScriptRoot\config.ini
}
else {
	echo ""
	echo "This application requires miniconda or anaconda. If you've already"
    echo "installed conda, make sure you're running in a Conda powershell prompt."
    echo "see the README for more details."
	echo ""
	pause
}
# prompt the user to provide a basedir
$basedir = "nowhere"
while ($basedir -eq "nowhere" ) {
    $basedir = read-host -prompt "`n`nPlease enter the full path to where you will store fireball data (basedir)"
    if ($rmsloc -eq  "") {
        Write-Output "You'll be prompted to update the config file when you first run the app. "
        $basedir = "none"
    }
    else
    {
        if ((test-path $basedir) -eq $false) {
            mkdir $basedir
        }
    }
}
if ($basedir -ne "none") {
    $basedir = $basedir.replace("\","/")
    python -c "from fireballCollector import updateConfigEntry; updateConfigEntry('Fireballs','basedir','${basedir}','./config.ini');"
}

# lets find WMPL or ask the user for its location.
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
$wmplloc = $wmplloc.replace("\","/")
python -c "from fireballCollector import updateConfigEntry; updateConfigEntry('solver','wmpl_loc','${wmplloc}','./config.ini');"

# now we will find RMS
$rmsloc = "nowhere"
while ($rmsloc -eq "nowhere" ) {
    $rmsloc = read-host -prompt "`n`nPlease enter the full path to RMS or press <enter> to skip"
    if ($rmsloc -eq  "") {
        Write-Output "To reduce raw data, install RMS and then update this app's configuration."
        $rmsloc = "none"
    }
    else
    {
        if ((test-path $rmsloc\RMS\StartCapture.py) -eq $false) {
            echo "RMS not found in $rmsloc, please re-enter"
            $wmplloc = "nowhere"
        }
    }
}
if ($rmsloc -ne "none") {
    $rmsloc = $rmsloc.replace("\","/")
    python -c "from fireballCollector import updateConfigEntry; updateConfigEntry('reduction','rms_loc','${rmsloc}','./config.ini');"
}

if ($envactive -eq $false) { conda deactivate }
echo ""
echo "done. To use the application, run .\fbCollector.ps1"
popd