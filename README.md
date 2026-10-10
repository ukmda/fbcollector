# A Fireball Collector and Analyser for UKMON and GMN
Version: 2026.9.0

This tool allows authorised users to collect fireball data from UKMON and GMN and then to reduce and solve it using RMS and WMPL. The instructions below should work for Windows, Linux or MacOS, thought I have not tested on the latter.

## Prerequisites
  
* Install Miniconda. Its available for Windows from [here](https://www.anaconda.com/docs/getting-started/miniconda/install/windows-cli-install#powershell), and installers for MacOS and Linux are available from the same site. On Linux or MacOS, select "Yes" when asked if you want to integrate Conda into your shell.

* It is NOT necessary to preinstall WMPL or RMS as the installer will do this if needed. For more about WMPL and RMS see [here](https://github.com/wmpg/WesternMeteorPyLib/blob/master/README.md) and [here](https://github.com/CroatianMeteorNetwork/RMS/blob/master/README.md).

### Optional Extras 
The following are optional:
* GMN Coordinator's ssh key. See "Collecting Data from GMN" below. 
* UKMON API Key. See "Sending Solutions to UKMON" below

## Installation
* Download `setup_fbcollector.zip` file from [here](https://github.com/ukmda/fbcollector/releases)
* Unzip the contents to a folder of your choice. I recommend `$HOME/src/fbcollector`.
* Open an Anaconda Powershell Prompt or Linux Terminal window and change directory to the folder you unzipped the files into.
* run `.\install.ps1` (for windows) or `./install.sh` (for Linux/MacOS)

This will create a Conda environment and install the dependencies, then look for WMPL and RMS. 

### Installing WMPL
The install script search for an existing WMPL installation. If not found, you'll be prompted for the location or you can press the Enter key to automatically install it in the default location. 

### Installing RMS


