#
# Collect data from GMN
# Copyright (C) 2018-2023 Mark McIntyre
#

import os
import logging
import tarfile

import paramiko
from scp import SCPClient

log = logging.getLogger('fbcollector')

class scpconn():
    def __init__(self, basedir, gmn_server, gmn_user, gmn_key, gmn_port=22):
        self.gmnstationlist = os.path.join(basedir, 'gmnstationlist.txt')
        self.gmn_server = gmn_server
        self.gmn_user = gmn_user
        self.gmn_key = gmn_key
        self.gmn_port = gmn_port
        k = paramiko.RSAKey.from_private_key_file(os.path.expanduser(self.gmn_key))
        self.sshcli = paramiko.SSHClient()
        server=self.gmn_server
        user=self.gmn_user
        log.info(f'trying {user}@{server} with {self.gmn_key}')
        self.sshcli.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.sshcli.connect(hostname = server, username = user, pkey = k)
        self.scpcli = SCPClient(self.sshcli.get_transport())
        self.sftpcli = self.sshcli.open_sftp()
        log.info('gmn connection opened')

    def __del__(self):
        self.sftpcli.close()
        self.scpcli.close()
        self.sshcli.close()
        try:
            log.info('gmn connection closed')
        except Exception:
            pass

    def finish(self):
        self.__del__()

    def getListOfStations(self):
        dirlist = self.sftpcli.listdir('/home')
        with open(self.gmnstationlist,'w') as outf:
            outf.write('\n'.join(dirlist))
        return dirlist
    
    def getFilteredStations(self, pref='uk'):
        pref = pref.lower()
        if not os.path.isfile(self.gmnstationlist):
            _ = self.getListOfStations()
        dirlist = open(self.gmnstationlist,'r').readlines()
        dirlist = [x.strip() for x in dirlist if x.startswith(pref)]
        dirlist.sort()
        return dirlist

    def getEventFileByStation(self, stationid, eventdt, basedir, skipfile, skipsftp=False):
        locpath = os.path.join(basedir, eventdt, f'{stationid.upper()}_{eventdt}_event.tar.bz2')
        alreadychecked = [x.strip() for x in open(skipfile, 'r').readlines()]
        if stationid.upper() in alreadychecked:
            log.info(f'skipping {stationid} as marked already-checked')
            return 
        if not skipsftp:
            if not os.path.isfile(locpath):
                rempath = f'/home/{stationid}/files/event_monitor/{stationid.upper()}_{eventdt}_event.tar.bz2'
                try:
                    self.sftpcli.stat(rempath)
                    self.sftpcli.get(rempath, locpath)
                    log.info(f'retrieved {stationid} for {eventdt}')
                except Exception:
                    log.info(f'no data for {stationid}')
            else:
                log.info(f'already retrieved data for {stationid}')
        if os.path.isfile(locpath):
            tarf = tarfile.open(locpath, 'r')
            contents = tarf.getnames()
            ff_files = [x for x in contents if 'FF_' in x or 'FR_' in x or '.jpg' in x or '.cal' in x or '.config' in x]
            if len(ff_files) > 0:
                #print(f'extracting files from {locpath}')
                for fil in ff_files:
                    fname = fil[fil.find(stationid.upper()):]
                    basefname = os.path.basename(fil)
                    if 'captured_stack.jpg' in fil:
                        localname = os.path.join(basedir, eventdt, 'stacks', basefname)
                    elif '.jpg' in fil:
                        localname = os.path.join(basedir, eventdt, 'jpgs', basefname)
                    elif '.mp4' in fil:
                        localname = os.path.join(basedir, eventdt, 'mp4s', basefname)
                    else:
                        localname = os.path.join(basedir, eventdt, fname)
                    if not os.path.isfile(localname):
                        os.makedirs(os.path.split(localname)[0], exist_ok=True)
                        buf = tarf.extractfile(fil)
                        open(localname, 'wb').write(buf.read())
                        log.info(f'saved {localname}')
        return 

    def getEventsByCountry(self, ctry, eventdt, basedir, skipfile, skipsftp=False):
        statlist = self.getFilteredStations(ctry.lower())
        for stat in statlist:
            self.getEventFileByStation(stat, eventdt, basedir, skipfile, skipsftp)

    def getEventsByRegion(self, region, eventdt, basedir, skipfile, skipsftp=False):
        if region == 'Europe':
            ctrylist = ['FR','DE','ES','CH','IT','CZ','PT','HR','SK']
        elif region == 'NorthAmerica':
            ctrylist = ['US','CA','MX']
        elif region == 'AusNZ':
            ctrylist = ['AU','NZ']
        else:
            ctrylist = ['UK','IE','NL','BE']

        for ctry in ctrylist:
            self.getEventsByCountry(ctry, eventdt, basedir, skipfile, skipsftp)





if __name__ == '__main__':
    conn = scpconn('.', 'gmn.uwo.ca','analysis', '~/.ssh/gmnanalysis')
    conn.getListOfStations('ua')
