# A Fireball Collector and Analyser for UKMON and GMN
Version: 2026.9.0

This tool allows authorised users to collect fireball data from UKMON and GMN and then to reduce and solve it. 

## Prerequisites
  
* Miniconda or anaconda, required to create python virtual environments for RMS and WMPL. 
* [RMS](https://github.com/CroatianMeteorNetwork/RMS) installed with its own Conda virtual environment. This is used to reduce raw data.
* [WMPL](https://github.com/wmpg/WesternMeteorPyLib/) installed with its own Conda virtual environment. This is used to solve trajectories.
* A local folder where you will store fireball data. This is called `basedir` in this documentation. 

The following are optional: 
* GMN Coordinator's ssh key. See "Collecting Data from GMN" below. 
* WSL2 activated with rsync installed. Required to collect data from GMN. 
* UKMON API Key. See "Sending Solutions to UKMON" below

## Installation
* First install WMPL and RMS in their own Conda environments and verify they're working. 
* Then install this package `setup_fireballCollector.exe` from [here](https://github.com/ukmda/fbcollector/releases).

### Linux Support
The app should also work on Linux. You will need to create a conda or python virtualenv named `fbcollector`, activate it and then clone this repo and install the requirements via `pip install -r requirements.txt`. You should then be able to run the programme by typing `python fireballCollector.py`

## Configuration
* The first time you launch the app, a text editor will appear to allow you to configure the application.
* Update at least the values of `basedir`, `rms_loc`, `rms_env`, `wmpl_loc`, and `wmpl_env` as appropriate and save. 
* Configuration can be updated at any time from the `Configuration` item on the `File` menu. 

## Usage
### Getting Raw Data
* Enter a date and time in the format `YYYYMMDD_HHMMSS` into the `Image Selection` box, then click "Get Images". 
  * After a few seconds, the listbox below should be populated with images from around the time you selected, provided the UKMON live feed captured something. 
  * If nothing appears, check the UKMON [livestream](https://archive.ukmeteors.co.uk/live/index.html) to make sure you chose a suitable time. 
  
* Go through the image list and click `Remove` or press the `Delete` key to delete any that are not of the event you are interested in. 
* Once you've whittled the list down to just the interesting events, you can select `Get ECSVs` from the `Raw` menu. This will attempt to get raw track data for each image in [ECSV](https://docs.astropy.org/en/stable/api/astropy.io.ascii.Ecsv.html) format. 
* You can also click `Get Videos` to collect any video data thats available. 

### Manually Reducing an Image
If you have a FITS or FR file from RMS along with the camera's config and platepar files, you can analyse the data using RMS's `SkyFit2` tool. 

Select an image in the file list then select `Reduce Selected Image` from the `Raw` menu. Once you're finished with SkyFit, remember to press Ctrl-S to save before quitting! This will save the analysis as an ECSV file. 

### Solving from ECSVs
* Once you have at least two ECSVs, you can click `Solve` from the `Solve` menu. This will invoke WMPL which will read the ECSVs and attempt to find a trajectory. It may take some time. 
* If the solver is successful, you can view the solution by selecting `View Solution` from the `Solve` menu. The left-hand list will now show the output of the solver so you can examine it. You can switch back to viewing the raw images by selecting `Review Images` from the `Review` menu. 

* If the solve process fails or if the solution seems very poor then try excluding some detections. To do this, select `Excl/Incl ECSV` from the `Raw` menu then rerun the Solver. 
* If the solution was really bad its worth using `Delete Solution` from the `Solve` menu before attempting a rerun.

## Sending Solutions to UKMON
Once you have a solution, select `Upload orbit` from the `Solve` menu. This will create a Zip file that bundles the created trajectory pickle file with any images and videos. 

If you're a member of the UKMON team and have an API key, the file will be uploaded directly to our server (provided its less than 10MB in size) Otherwise you can upload the file to any file-sharing site and email a link to [us](fireballdata@ukmeteornetwork.org) where one of the team will check and upload it to our Archive. 


## Sharing Raw Data
If you've configured a raw data location in the configuration file, `Share Raw Data` on the raw menu will create a zip file of all the raw data and copy it to the location. For example, if you have Dropbox installed and set the share location to a folder in your Dropbox, then the zip file will be copied there. You can then share the Dropbox link as appropriate. 

## Archiving and Deleting Fireball Data
Once a solution has been obtained and uploaded you can use `Archive this Folder` and `Delete this Folder` to compress the current folder into a zip file, or to delete it entirely. 

### Collecting data from GMN
Members of the GMN Coordinators group who have permission from Denis Vida can also use this tool to collect raw data directly from GMN. 

If you fall into this category you can fill in the `[gmn]` section of the config file with the name of your SSH private key and other details.  This will activate additional menu options to `Get GMN Raw Data` and to use the `Watchlist`.

If you've collected data from GMN using this tool, then you can review the Stacks from each camera via `Review Stacks` on the `Review` menu.

## Logs
You can view the logs from the `File` menu. The logs are created in [%TEMP%/fbcollector](%temp%/fbcollector). 


