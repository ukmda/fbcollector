# A Fireball Collector and Analyser for UKMON and GMN
Version: 2026.9.0

This tool allows authorised users to collect fireball data from UKMON and GMN and then to reduce and solve it using RMS and WMPL. 

The instructions below should work for Windows, Linux or MacOS, though I have not tested on the latter.

## Prerequisites
  
* Install Miniconda. Its available for Windows from [here](https://www.anaconda.com/docs/getting-started/miniconda/install/windows-cli-install#powershell), and installers for MacOS and Linux are available from the same site. On Linux or MacOS, select "Yes" when asked if you want to integrate Conda into your shell.

*  Install RMS - see [here](https://github.com/CroatianMeteorNetwork/RMS/blob/master/README.md) for instructions. This is needed if you want to manually reduce raw data from cameras to create the files that WMPL can use to solve trajectories. 

* It is NOT necessary to preinstall WMPL as the installer will do this if needed. For more about WMPL see [here](https://github.com/wmpg/WesternMeteorPyLib/blob/master/README.md). 

### Optional Extras 
The following are optional. See "UKMON API and GMN Coordinators keys" below for what they do.  
* GMN Coordinator's ssh key. 
* UKMON API Key. 

## Installation
* Download `setup_fbcollector.zip` file from [here](https://github.com/ukmda/fbcollector/releases)
* Unzip the contents to a folder of your choice. I recommend `$HOME/src/fbcollector`.
* Open an Anaconda Powershell Prompt or Linux Terminal window and change directory to the folder you unzipped the files into.
* run `.\install.ps1` (for windows) or `./install.sh` (for Linux/MacOS)

This will create a Conda environment and install the dependencies, then prompt you for various configuration items.

### Basedir
The installation process will prompt you to provide a `basedir`. This is the place you will keep your fireball data. 

### WMPL
The installation process will search for an existing WMPL installation. If not found you'll be prompted for the location. If you don't have it installed already you can press the Enter key to automatically install it in the default location. 

### RMS
During installation you will be prompted for the location of RMS. If you've not installed it yet, just it enter but remember you'll need RMS installed if you want to manually reduce raw FF or FR files. Installing RMS is explained in its [README](https://github.com/CroatianMeteorNetwork/RMS/blob/master/README.md) file.

## Completing Installation and running the App
Once the installer is finished, you can run the app by opening an Anaconda Powershell prompt or Linux shell a then run `~/src/fbcollector/fbcollector.ps1` or `~/src/fbcollector/fbcollector.sh` as appropriate for your OS (assuming you installed in `~/src/fbcollector` as suggested earlier). There are further instructions in the [USAGE](USAGE.md) file. 


## UKMON API and GMN Coordinators keys
IF you have been given a UKMON API key, you can upload solutions directly to our archive, where they'll be added to the database. This permission is restricted. 

Additionally, authorised GMN Coordinators can collect raw data directly from the GMN servers. This capability is restricted to avoid overloading the GMN servers, and is managed by Denis Vida. 

In both cases please do contact me if you'd like to know more. 