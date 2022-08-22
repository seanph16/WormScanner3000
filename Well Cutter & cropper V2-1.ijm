// Well cutter & Cropper ImageJ plugin
// Sean Harrington & Aaron Au - Roy and Yip labs - University of Toronto
// Change in 2.1 from 1.3: Introduced a logical statement to look at the first row of each plate to determine the x-offset of the plate. To do this I run a gaussian blur on the first
// image of a plate, threshold it, draw 5 rectangles separated by 200 pixels, the rectangle with the lowest std, as it has more pixels in the well, gives an idea of the rough position of the well.
// this is used 
// 1/24/2016 - Version 2.1
//----------------------------------------------------------------------------------------------------------

// Selecting directories to be cropped and creating a 'Circle cut images' subdirectory to save the cropped images to
nPlates = getNumber("Type how many plates you would like to crop", 1);
inputFileArr = newArray();
outputFileArr = newArray();
for(i=0; i < nPlates; i++) {
	temp = getDirectory("Choose the " + (i+1) +"th directory that you want to crop");
	print(temp);
	inputFileArr = Array.concat(inputFileArr, temp);
	OutputFolder = temp + "Circle cut images" + File.separator;
	File.makeDirectory(OutputFolder);
	outputFileArr = Array.concat(outputFileArr, OutputFolder);
	}
//Manually setting the 'X-offset' of the images; The further right the > the x-offset
XoffVal = getNumber("What offset are the images (range 1-8)", 1);
while (XoffVal < 1 || XoffVal > 8) {
	XoffVal = getNumber("Choose a valid selection (1-8)");
	}
Xoff = XoffVal * 50;	
// well cutter function
function cutter(input, output, filename) {
	open(input + filename);
	plateConditionPath = File.getParent(output);
	plateCondition = File.getName(plateConditionPath);
	platePath = File.getParent(input);
	plate = File.getName(platePath);
	n = parseInt(substring(filename, lengthOf(filename)-5, lengthOf(filename)-4));
	if (n == 0) {
		Row = "A";
		} else if (n == 1) {
		Row = "B";
		} else if (n == 2) {
		Row = "C";
		} else if (n == 3) {
		Row = "D";
		} else if (n == 4) {
		Row = "E";
		} else if (n == 5) {
		Row = "F";
		} else if (n == 6) {
		Row = "G";
		} else if (n == 7) {
		Row = "H";
		}
	if (n % 2 == 0)
		for (i = 0; i <= 11; i++) {
		makeOval(Xoff + (20 *i), 2393 + (4366 * i) - (65 * n), 3900, 3900);
		run("Duplicate...", " ");
		run("Clear Outside");
		MeanArr = newArray(0);
		for(x=0; x < 10; x++) {
			for(y=0; y < 10; y++) {
				makeOval(50 + 60 * x, 100 + 60 * y, 3269, 3269);
				getStatistics(area, mean, min, max, std);
				MeanArr = Array.concat(MeanArr, mean);	
				}
			}
		ArrMax = Array.findMaxima(MeanArr, 0);
		OptPos = ArrMax[0];
		yCoord = OptPos % 10;
		tempFloat = parseFloat(OptPos/10);
		xCoord = parseInt(tempFloat);
		makeOval(50 + 60 * xCoord, 100 + 60 * yCoord, 3269, 3269);
		run("Clear Outside");
		if (i < 9) {
			save(output + plate + "_" + plateCondition + "_" + Row + "0" + (i+1) + ".tif");
		} else {
			save(output + plate + "_" + plateCondition + "_" + Row + (i+1) + ".tif");
		}
		close();
		}
	if (n % 2 > 0)
		for (i = 11; i >= 0; i--) {
			makeOval(0 - Xoff - (20 * i), 2000 + (4366 * i) + (65 * n), 3900, 3900);
			run("Duplicate...", " ");
			run("Clear Outside");
			MeanArr = newArray(0);
			for(x=0; x < 10; x++) {
				for(y=0; y < 10; y++) {
					makeOval(50 + 60 * x, 100 + 60 * y, 3269, 3269);
					getStatistics(area, mean, min, max, std);
					MeanArr = Array.concat(MeanArr, mean);	
					}
				}
			ArrMax = Array.findMaxima(MeanArr, 0);
			OptPos = ArrMax[0];
			yCoord = OptPos % 10;
			tempFloat = parseFloat(OptPos/10);
			xCoord = parseInt(tempFloat);
			makeOval(50 + 60 * xCoord, 100 + 60 * yCoord, 3269, 3269);
			run("Clear Outside");
			if (i > 2) {
				save(output + plate + "_" + plateCondition + "_" + Row + "0" + (12-i) + ".tif");
			} else {
				save(output + plate + "_" + plateCondition + "_" + Row + (12-i) + ".tif");
			}
		close();
		}
	close();
	}
// Iterating cutter function over however many plates were inputted
setBatchMode(true);
for (j=0; j < inputFileArr.length; j++) {
	list = getFileList(inputFileArr[j]);
	for(k=0; k < list.length; k++) {
		cutter(inputFileArr[j], outputFileArr[j], list[k]);
		} 
}
setBatchMode(false);
beep();
wait(500);
beep();
wait(500);	
beep();
wait(500);
beep();
wait(500);	
beep();
wait(500);
beep();	
setBatchMode(false);

	

	