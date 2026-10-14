#!/bin/bash
#
# powershell script to install the Fireball Collector
# copyright Mark McIntyre, 2026-

# NB: this script must be run in an Anaconda Powershell prompt
# See the README for more.

here="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

pushd $here > /dev/null

fbenv="fbcollector"
[ $(command -v conda) ] && gotconda=1 || gotconda=0
[ "$conda_default_env" == "fbcollector" ] && envactive=1 || envactive=0
if [ "$CONDA_PREFIX_1" != "" ] ; then
    if test -d $CONDA_PREFIX_1/envs/$fbenv ; then gotenv=1 ; else gotenv=0 ; fi
else 
    if test -d $CONDA_PREFIX/envs/$fbenv ; then gotenv=1 ; else gotenv=0 ; fi
fi 
#echo "$gotconda $envactive $gotenv"

eval "$(conda shell.bash hook)"

if [ $gotconda -eq 1 ] ; then
    if [ $gotenv -eq 0 ] ; then echo "creating conda environment" ; conda create -y -n $fbenv python=3.12 ; fi
	if [ $envactive -eq 0 ] ; then echo "activating env" ; conda activate $fbenv ; fi
    echo $CONDA_DEFAULT_ENV
	pip install -r $here/requirements.txt
    cp $here/config.ini.sample $here/config.ini
else
	echo ""
	echo "This application requires miniconda or anaconda. If you've already"
    echo "installed conda, make sure you're running in a Conda powershell prompt."
    echo "see the README for more details."
	echo ""
	exit
fi
# prompt the user to provide a basedir
basedir="nowhere"
while [ "$basedir" == "nowhere" ] ; do
    echo ""
    echo ""
    read -p "Please enter the full path to where you will store fireball data (basedir): " basedir
    if [ "$basedir" ==  "" ] ; then
        echo "You'll be prompted to update the config file when you first run the app. "
        basedir="none"
    else
        if ! test -d $basedir ; then mkdir -p $basedir ; fi
    fi
done
if [ "$basedir" != "none" ] ; then 
    python -c "from fireballCollector import updateConfigEntry; updateConfigEntry('Fireballs','basedir','${basedir}','./config.ini');"
fi
# lets find WMPL or ask the user for its location.
wmplloc="nowhere"
testwmplloc="$HOME/src/WesternMeteorPyLib"
if test -e $testwmplloc/UpdateOrbitFiles.py ; then 
    echo "WMPL found at $testwmplloc"
    wmplloc=$testwmplloc
fi
testwmplloc="$HOME/source/WesternMeteorPyLib"
if test -e $testwmplloc/UpdateOrbitFiles.py ; then 
    echo "WMPL found at $testwmplloc"
    wmplloc=$testwmplloc
fi

while [ "$wmplloc" == "nowhere" ] ; do
    echo ""
    echo ""
    read -p "Please enter the full path to WMPL or press <enter> to install it: " wmplloc
    if [ "$wmplloc" ==  "" ] ; then
        wmplloc="$HOME/src/WesternMeteorPyLib"
        echo "installing WMPL into $wmplloc"
        test -d ~/src || mkdir ~/src
        pushd ~/src
        git clone --recursive https://github.com/wmpg/WesternMeteorPyLib.git
        cd WesternMeteorPyLib
        rm -Rf wmpl/MetSim
        rm -Rf wmpl/CAMO
        rm -f wmpl/Utils/DynamicMassFit.py
        python ./UpdateOrbitFiles.py
        curl "https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/de430.bsp" -o $wmplloc/wmpl/share/de430.bsp
        python -c "from wmpl.Utils.ShowerAssociation import loadGMNShowerTable"
        popd
    fi
    if ! test -e $wmplloc/UpdateOrbitFiles.py  ; then
        echo "WMPL not found in $wmplloc, please re-enter"
        wmplloc="nowhere"
    fi
done
python -c "from fireballCollector import updateConfigEntry; updateConfigEntry('solver','wmpl_loc','${wmplloc}','./config.ini');"

# now we will find RMS
rmsloc="nowhere"
testrmsloc="$HOME/src/RMS"
if test -e $testrmsloc/RMS/StartCapture.py ; then 
    echo "RMS found at $testrmsloc"
    rmsloc=$testrmsloc
fi
testrmsloc="$HOME/source/RMS"
if test -e $testrmsloc/RMS/StartCapture.py ; then 
    echo "RMS found at $testrmsloc"
    rmsloc=$testrmsloc
fi

while [ "$rmsloc" == "nowhere" ] ; do
    read -p "Please enter the full path to RMS or press <enter> to skip: " rmsloc
    if [ "$rmsloc" ==  "" ] ; then
        echo "To reduce raw data, install RMS and then update this app's configuration."
        rmsloc="none"
    else
        if ! test -d $rmsloc/RMS/StartCapture.py ; then 
            echo "RMS not found in $rmsloc, please re-enter"
            rmsloc="nowhere"
        fi
    fi
done
if [ "$rmsloc" != "none" ] ; then
    python -c "from fireballCollector import updateConfigEntry; updateConfigEntry('reduction','rms_loc','${rmsloc}','./config.ini');"
fi

if [ $envactive -eq 1 ] ; then  conda deactivate ; fi
echo ""
echo "done. To use the application, run ./fbCollector.sh"
popd > /dev/null