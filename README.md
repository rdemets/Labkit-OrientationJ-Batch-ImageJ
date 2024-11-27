# Motivations


The aim of this macro is to measure the angle between connexin and the main directionality of the fibers in batch using Labkit and OrientationJ.

## How to install

No installation is required to use the macro.

## Requirements

This macro requires **BIG-EPFL** and **Labkit** from the Fiji plugins updater.

## How to use

Drag and drop the ijm file into Fiji and click on Run. 
Three fields will appear. The first one will ask for the path of the folder to process. It is expected to find a list of folders each containing a tif file ending by **ORG.tif** and a **classifier.classifier** from Labkit.
<br>The second and third field are used to filter object minimum size and maximum circularity.
<br>Each folder will be populated with a rotated image, a zip file containing the ROI of the detected objects, a csv file with the result


## Updates history
(0.1.0) Works in batch
<br>(0.1.1) Add mean min max measurement on each image.
