#!/bin/bash

here="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

dt=$1
basedir=$2
getall=$3
server=$4
keyfile=$5

[ "$server" == "" ] && server=analysis@gmn.uwo.ca
[ "$keyfile" == "" ] && keyfile=$HOME/.ssh/gmnanalysis

mkdir -p $basedir/$dt
pushd $basedir/$dt

echo keyfile is $keyfile server is $server

rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/uk*/files/event_monitor/*${dt}*.bz2 .
echo "pausing"
sleep 30
rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/be*/files/event_monitor/*${dt}*.bz2 .
rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/ie*/files/event_monitor/*${dt}*.bz2 .
rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/nl*/files/event_monitor/*${dt}*.bz2 .
if [ "$getall" == "all" ] ; then 
    rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/fr*/files/event_monitor/*${dt}*.bz2 .
    rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/de*/files/event_monitor/*${dt}*.bz2 .
    rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/es*/files/event_monitor/*${dt}*.bz2 .
    rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/ch*/files/event_monitor/*${dt}*.bz2 .
    rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/it*/files/event_monitor/*${dt}*.bz2 .
    rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/cz*/files/event_monitor/*${dt}*.bz2 .
    rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/hr*/files/event_monitor/*${dt}*.bz2 .
    rsync -e "ssh -i ${keyfile}" -avz ${server}:/home/sk*/files/event_monitor/*${dt}*.bz2 .
fi

for f in *.bz2 ; do tar -xvf $f  ; done
if [ -d UKMON ] ; then
    sites=$(ls -1 UKMON)
    for site in $sites ; do
        cams=$(ls -1 UKMON/$site)
        for cam in $cams ; do 
            if [ -d ./$cam ] ; then rm -Rf $cam ; fi
            mv -f UKMON/$site/$cam .
        done
    done
    rm -Rf UKMON
fi 
if [ -d NEMETODE ] ; then
    sites=$(ls -1 NEMETODE)
    for site in $sites ; do
        cams=$(ls -1 NEMETODE/$site)
        for cam in $cams ; do 
            if [ -d ./$cam ] ; then rm -Rf $cam ; fi
            mv -f NEMETODE/$site/$cam .
        done
    done
    rm -Rf NEMETODE
fi 
if [ -d ASEUKMON ] ; then
    sites=$(ls -1 ASEUKMON)
    for site in $sites ; do
        cams=$(ls -1 ASEUKMON/$site)
        for cam in $cams ; do 
            if [ -d ./$cam ] ; then rm -Rf $cam ; fi
            mv -f ASEUKMON/$site/$cam .
        done
    done
    rm -Rf ASEUKMON
fi 
if [ -d "UKMON,NEMETODE" ] ; then
    sites=$(ls -1 "UKMON,NEMETODE")
    for site in $sites ; do
        cams=$(ls -1 "UKMON,NEMETODE/$site")
        for cam in $cams ; do 
            if [ -d ./$cam ] ; then rm -Rf $cam ; fi
            mv -f "UKMON,NEMETODE/$site/$cam" .
        done
    done
    rm -Rf "UKMON,NEMETODE"
fi 
mkdir -p ./stacks
mkdir -p ./jpgs
mkdir -p ./mp4s
cp -f */*.jpg ./jpgs
mv -f ./jpgs/*captured_stack* ./stacks
cp -f */*.mp4 ./mp4s
popd