#!/bin/bash
#
# powershell script to run the Fireball Collector
# copyright Mark McIntyre, 2026-

# NB: this script must be run in an Anaconda Powershell prompt
# and you must have created a conda environment "fbcollector"
# See the README for more.

here="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

fbenv="fbcollector"
[ $(command -v conda) ] && gotconda=1 || gotconda=0
[ "$conda_default_env" == "fbcollector" ] && envactive=1 || envactive=0
if [ "$CONDA_PREFIX_1" != "" ] ; then
    if test -d $CONDA_PREFIX_1/envs/$fbenv ; then gotenv=1 ; else gotenv=0 ; fi
else 
    if test -d $CONDA_PREFIX/envs/$fbenv ; then gotenv=1 ; else gotenv=0 ; fi
fi 
# echo "$gotconda $envactive $gotenv"

eval "$(conda shell.bash hook)"
if [[ $gotconda -eq 1 && $gotenv -eq 1 ]] ; then
	[ $envactive -eq 0 ] && conda activate $fbenv 
	python $here/fireballCollector.py -c $here/config.ini $*
	[ $envactive -eq 0 ] && conda deactivate
else 
	echo ""
	echo "unable to activate conda environment"
	echo "make sure you're running in an Anaconda Powershell prompt and "
	echo "have created the $fbenv conda environment - see the README."
	echo ""
	pause
fi
