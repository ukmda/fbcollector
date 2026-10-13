# Using the Fireball Collector

## Basic usage
To run the application type `~/src/fbcollector/fbcollector/ps1` or `~/src/fbcollector/fbcollector/sh` as appropriate for your platform. 

You can optionally use the `-d` parameter to provide the directory of your raw data. eg 
``` pwsh
~/src/fbcollector/fbcollector/ps1 -d c:\users\yourname\fireballs\20261010_202504
```
This would launch the tool and open the data in the target folder. 

## Configuration
* The first time you launch the app, you may be asked to configure the application.
* Update at least the values of `basedir`, `rms_loc`, `rms_env`, `wmpl_loc`, as appropriate and save. 
* Configuration can be updated at any time from the `Configuration` item on the `File` menu. 

## Using the App
### Getting Raw Data
* Enter a date and time in the format `YYYYMMDD_HHMMSS` into the `Image Selection` box, then click "Get Images". 
  * After a few seconds, the listbox below should be populated with images from around the time you selected, provided the UKMON live feed captured something. 
  * If nothing appears, check the UKMON [livestream](https://archive.ukmeteors.co.uk/live/index.html) to make sure you chose a suitable time. 
  
* Go through the image list and press the `Delete` key to delete any that you are not interested in. 

* Once you've whittled the list down to just the interesting events, you can select `Get ECSVs` from the `Raw` menu. This will attempt to get raw track data for each image in [ECSV](https://docs.astropy.org/en/stable/api/astropy.io.ascii.Ecsv.html) format. 
* You can also click `Get Videos` to collect any video data thats available. 

### Manually Reducing an Image
If you have a FITS or FR file from RMS along with the camera's config and platepar files, and you installed RMS, you can analyse the data using RMS's `SkyFit2` tool. 

From the `File` menu, select `Open in Explorer`. You'll see there are a number of folders, one per camera.

Copy the FF, FR, config and platepar files into the correct camera's folder and close the File Explorer window. If the camera isn't present, create a folder for it. 

Select an image in the file list then select `Reduce Selected Image` from the `Raw` menu. If you've configured RMS correctly, SkyFit2 will launch. Once you're finished with SkyFit remember to press Ctrl-S before quitting, to save the analysis as an ECSV file. 

### Solving from ECSVs
* Once you have at least two ECSVs (either from SkyFit2 or from the UKMON archive), you can click `Solve` from the `Solve` menu. This will invoke WMPL which will read the ECSVs and attempt to find a trajectory. It may take some time. 
* If the solver is successful, you can view the solution by selecting `View Solution` from the `Solve` menu. The left-hand list will now show the output of the solver so you can examine it. You can switch back to viewing the raw images by selecting `Review Images` from the `Review` menu. 

* If the solve process fails or if the solution seems very poor then try excluding some detections. To do this, select `Excl/Incl ECSV` from the `Raw` menu then rerun the Solver. 
* If the solution was really bad its worth using `Delete Solution` from the `Solve` menu before attempting a rerun.

## Sending Solutions to UKMON
Once you have a solution, select `Upload orbit` from the `Solve` menu. This will create a Zip file that bundles the created trajectory pickle file with any images and videos. 

If you're a member of the UKMON team and have an API key, the file will be uploaded directly to our server (provided its less than 10MB in size) Otherwise you can upload the file to any file-sharing site and email a link to [us](fireballdata@ukmeteornetwork.org) where one of the team will check and upload it to our Archive. 


## Sharing Raw Data
If you've configured a raw data location in the configuration file, `Share Raw Data` on the raw menu will create a zip file of all the raw data and copy it to the location. For example, if you have Dropbox installed and set the share location to a folder in your Dropbox, then the zip file will be copied there. You can then share the Dropbox link as appropriate. 

## Archiving and Deleting Fireball Data
Once a solution has been obtained and uploaded you can use `Archive this Folder` to compress the current folder into a zip file. If the data were unusable or not interesting you can use `Delete this Folder` to delete it entirely. 

### Collecting data from GMN
Members of the GMN Coordinators group who have permission from Denis Vida can also use this tool to collect raw data directly from GMN. 

If you fall into this category you can fill in the `[gmn]` section of the config file with the name of your SSH private key and other details.  This will activate additional menu options to `Get GMN Raw Data` and to use the `Watchlist`.

If you've collected data from GMN using this tool, then you can review the Stacks from each camera via `Review Stacks` on the `Review` menu.

## Logs
You can view the logs from the `File` menu. The logs are created in [%TEMP%/fbcollector](%temp%/fbcollector). 
