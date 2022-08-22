// Egg & Worm Counter V1.3 (troubleshoot version)
// Sean Harrington & Aaron Au - Roy and Yip labs - University of Toronto
// Iterates through user selected folders using the CountEgg and CountWorm functions to generate these counts.
// 2016/01/27 - Version 1.3
//----------------------------------------------------------------------------------------------------------
nPlates = getNumber("Type how many plates you would like to count eggs and worms for", 1);
inputFileArr = newArray();
for(i=0; i < nPlates; i++) {
	temp = getDirectory("Choose the " + (i+1) +"th directory that you want to analyze") + "Circle cut images" + File.separator;
	inputFileArr = Array.concat(inputFileArr, temp);
	}
wait_time = getNumber("Would you like to delay the macro to allow the plate cutter to cut the raw images? (# of hours)", 0);
wait(wait_time*60*60*1000);
// Functions to count the number of eggs and number of worms in each image in each directory
function CountEggs(input, filename) {
	open(input + filename);
	run("Gaussian Blur...", "sigma=1.5");
	run("Subtract Background...", "rolling=45 light");
	setThreshold(0, 222);
	run("Analyze Particles...", "size=300-6000 circularity=0.15-1.00 show=Masks exclude");
	run("Fill Holes");
	run("Watershed");
	run("Analyze Particles...", "size=300-2500 circularity=0.5-1.00 show=Nothing exclude summarize");
	close();
	close();
	}
function CountWorms(input, filename) {
	open(input + filename);
	getStatistics(area, mean, min, max, std, histogram);
	if (mean <= 70) {
			run("Gaussian Blur...", "sigma=4");
			run("Subtract Background...", "rolling=125 light");
			setThreshold(0, 245, "black & white");
			run("Analyze Particles...", "size=11450-150000 circularity=0.029-0.80 show=Nothing exclude summarize");
			close();
		} else if (mean <= 95) {
			run("Gaussian Blur...", "sigma=4");
			run("Subtract Background...", "rolling=115 light");
			setThreshold(0, 230, "black & white");
			run("Analyze Particles...", "size=11450-150000 circularity=0.029-0.80 show=Nothing exclude summarize");
			close();
		} else if (mean <= 130) {
			run("Gaussian Blur...", "sigma=6");
			run("Subtract Background...", "rolling=75 light");
			setThreshold(0, 225, "black & white");
			run("Analyze Particles...", "size=11450-150000 circularity=0.029-0.80 show=Nothing exclude summarize");
			close();
		} else {
			run("Gaussian Blur...", "sigma=6");
			run("Subtract Background...", "rolling=75 light");
			setThreshold(0, 222, "black & white");
			run("Analyze Particles...", "size=11450-150000 circularity=0.029-0.80 show=Nothing exclude summarize");
			close();
			}
	}
setBatchMode(true);
for (j=0; j < inputFileArr.length; j++) {
	list = getFileList(inputFileArr[j]);
	for(k=0; k < list.length; k++) {
		CountEggs(inputFileArr[j], list[k]);
		}
	for(k=0; k < list.length; k++) {
		CountWorms(inputFileArr[j], list[k]);
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