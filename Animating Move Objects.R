##########Animating animal tracks using the "moveVis" pacakage
##John McEvoy 28-07-2017, adapted from example code in"moveVis" package manual
##########################



#You will need to read in data that has a column for "datetime" ,"Lon","Lat" and "ID"
#I normally read in a 'cleaned'data set from processing the data for weekly updates
#be careful with date formats, make sure the data is formatted the way you tell R it is formatted
#e.g.: "'%Y-%m-%d %H:%M:%S' = '2010-10-35 01:02:02"


#Load required packages
library(move)
library(moveVis)

#read in data. This can be a file with multiple animals or a single individual
myanimals.DF<-read.csv(file.choose())

#Cut data to required dates if necessary
#for example if you are only interested in animating movement around a known poaching event

myanimals.DF <- subset(myanimals.DF, myanimals.DF$Date >= as.POSIXct('2017-03-24 21:00:18') &
                          myanimals.DF$Date <= as.POSIXct('2017-03-29 22:00:36'))


#Create a 'move object'
myanimals.MV <- move(x=myanimals.DF$Long, y=myanimals.DF$Lat, time=as.POSIXct(myanimals.DF$Date, format='%Y-%m-%d %H:%M:%S', tz="GMT"),data=myanimals.DF, proj= CRS("+proj=longlat +ellps=WGS84"), animal =myanimals.DF$ID)

#plot the move object to make sure it looks right
plot(myanimals.MV)

#the animation function requires a third party GIF creation software called "ImageMagick"

#specify directory for "ImageMagick". This function searches for where it is installed 
#if not installed it will download a temporary version

conv_dir <- get_imconvert()

# check the 'conv directory
conv_dir

#specify directory to write the animation to

out_dir<-"I:/John/Myanmar_Elephants/GPS_Tracking/Animals"


#specify image title. Can also add caption and subtitle

img_title<-"Movement of Poached Elephant st2010-2595"

#before going ahead and making the animation take a look at the function help file to see all the arguments available
?animate_move



#create a gif of the animal's track. Here I have specified the length of time a frame is displayed for('frame_interval"),
#how many frames to show ("frames_max=0" means all frames are displayed), and the titles of the graph and image name.
#This example will loada basemap from Google Earth.

animate_move(myanimals.MV, out_dir, conv_dir,tail_elements=10, paths_mode="simple",paths_col="yellow",
             frames_nmax=0, frames_interval= 0.6, img_title=img_title, log_level=1,  out_name= "Movement of Poached Elephant st2010-2595")



#You can use the "layer" and "layer_dt" arguments to specify your own raster backround as a sinlge static image or a dynamic timeseries of rasters
#the 'layer' and "layer_dt" objects should be in the form of lists and represent the rasters and the timestamps to display them
# your layer object can be a rasterStack or rasterBrick object
#in this situation it is possible to add the argument "stats_create" . This will use the 'animate_stats' function
#to give an animated output of the raster values in the cells your animal occupies across time. (e.g. NDVI values along a wildebeest migration)

#####I HAVE NOT GOT THIS TO WORK PROPERLY YET!##

#create a raster, raster stack or rasterBrick object
#code below is based on a single static image
myraster<-raster(file.choose())

background<-list(myraster)

#your list of timestamps should be the same length as your list of rasters and should be in POSIXct format
timestamps<-list(as.POSIXct('2017-03-24 21:00:19'))



animate_move(myanimals.MV, out_dir, conv_dir,tail_elements=10, paths_mode="simple", layer = background,layer_dt=timestamps,
             frames_nmax=0, frames_interval= 0.6, img_title=img_title, log_level=1, stats_create=TRUE,
             stats_type="line",stats_title="Raster Statistics", out_name= "Movement of Poached Elephant st2010-2595")

#see moveVis package manual for full explanation of the various functions and arguments

