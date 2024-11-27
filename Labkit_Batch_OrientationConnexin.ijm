// needs Labkit for segmentation
// needs BIG-EPFL for OrientationJ


// This macro aims to quantify the angle between fibers and connexin
// All function used are available from the stable version of Fiji and  mentioned plugins.




// Macro author R. De Mets
// Version : 0.1.1 , 27/11/2024
// Add min/max measurement

//setBatchMode(true);
run("Close All");
print("\\Clear");
roiManager("reset");


Dialog.create("GUI");
Dialog.addDirectory("Source folder path","");
Dialog.addNumber("Min object size (px)", 100);
Dialog.addNumber("Max circularity (0-1)", 0.8);
Dialog.show();

dirS = Dialog.getString;
ObjSize = Dialog.getNumber();
MaxCirc = Dialog.getNumber();
dirList = getFileList(dirS);

for (folder = 0; folder < dirList.length; folder++) {
	currDir= dirS+dirList[folder];
	filenames = getFileList(currDir);
	showProgress(folder, dirList.length);
	
	for (file = 0; file < filenames.length; file++) {
		currFile = currDir+filenames[file];
		if(endsWith(currFile, "ORG.tif")) { // process czi files matching regex
			//print(currFile);
			run("Bio-Formats Windowless Importer", "open=[" + currFile+"]");
			title = File.nameWithoutExtension;
			rename("image");
			
			run("Set Measurements...", "area mean min fit redirect=image decimal=2");
			run("OrientationJ Dominant Direction");
			Table.rename("Dominant Direction of image", "Results");
			angle = getResult("Orientation [Degrees]", 0);
			print("Angle used: "+angle);
			run("Segment Image With Labkit", "input=image segmenter_file="+currDir+"classifier.classifier use_gpu=false");
			setThreshold(2, 2);
			
			run("Create Selection");
			run("Create Mask");
			rename("mask");
			
			selectWindow("image");
			run("Rotate... ", "angle="+angle+" grid=3 interpolation=None enlarge");
			saveAs("Tiff", currDir+"rotated_image.tif");
			
			selectWindow("mask");
			run("Rotate... ", "angle="+angle+" grid=3 interpolation=None enlarge");
			run("Dilate");
			run("Dilate");
			run("Dilate");
			run("Erode");
			run("Erode");
			
			
			//run("Analyze Particles...", "size=0-Inf circularity=0.00-0.80 display exclude clear add");
			run("Analyze Particles...", "size="+ObjSize+"-Inf pixel circularity=0.00-"+MaxCirc+" display exclude clear add");
			saveAs("Results", currDir+"Results.csv");
			roiManager("Save", currDir+"RoiSet.zip");
			
			run("Close All");
			roiManager("reset");


		}
	}
}
