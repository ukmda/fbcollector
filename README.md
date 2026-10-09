# A Fireball Collector and Analyser for UKMON and GMN
Version: 2026.9.0

This tool allows authorised users to collect fireball data from UKMON and GMN and then to reduce and solve it. The instructions below should work for Windows, Linux or MacOS, thought I have not tested on the latter.

## Prerequisites
  
* Install Miniconda. Its available for Windows from [here](https://www.anaconda.com/docs/getting-started/miniconda/install/windows-cli-install#powershell), and installers for MacOS and Linux are available from the same site. On Linux or MacOS, select "Yes" when asked if you want to integrate Conda into your shell.

* Install [WMPL](https://github.com/wmpg/WesternMeteorPyLib/). If you only intend to use WMPL to solve orbits and trajectories, you can follow the instructions below. 

* Install [RMS](https://github.com/CroatianMeteorNetwork/RMS). This is used to 'reduce' the raw data to create a file that the solver can use. 

### Optional Extras 
The following are optional:
* GMN Coordinator's ssh key. See "Collecting Data from GMN" below. 
* UKMON API Key. See "Sending Solutions to UKMON" below

## Installation
* Open an Anaconda Powershell Prompt or Linux Terminal window. 

* Create and activate a conda environment to run the application in:
  ``` bash
  conda create -n fbcollector python=3.12
  conda activate fbcollector
  ```

In the same window, create a folder for the application and change directory into it:
``` bash
mkdir ~/src/fbcollector
cd ~/src/fbcollector
```
* Now download the app package [setup_fbcollector.]() and save it into this folder.
 

### Installing WMPL for Trajectory Solving Only
As we will only be using WMPL in for trajectory solving, we don't need some components of the library. The following steps will install just the components we need.

Install GIT from [here](https://git-scm.com/install/). 

Windows only: Install MS Build Tools from [here](https://go.microsoft.com/fwlink/LinkId=691126). Once the installer opens, just click the Install button, no need to select any options. 

Now open a powershell or terminal window and type the following:
``` bash
mkdir ~/src
cd ~/src
git clone --recursive https://github.com/wmpg/WesternMeteorPyLib.git
cd WesternMeteorPyLib
rm -R wmpl/CAMO 
rm -R wmpl/MetSim 
rm -R wmpl/Utils/DynamicMassFit.py
python setup.py
```
Its safe to delete the the mentioned files and folders as the Simulation functionality is not used for trajectory solving. 
Note that the last command will error out after downloading some data files. This is to be expected and won't affect trajectory solving. 

Finally test the installation:
``` bash
python -m wmpl.Formats.ECSV --help
```
This should display the help screen for the ECSV solver tool. 
