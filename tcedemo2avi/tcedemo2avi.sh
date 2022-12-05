#!/bin/sh
# Configuration file for tcedemo2avi.sh.
# Copyright (C) 2006 Nick Robertson & John Connell (http://www.theramenbowl.com)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


#  
# Check our configuration file, if if exists
#

# What's the name of our config file?
CONF="/usr/etc/tcedemo2avi.conf"

if [ -e $CONF ]; then
   # It does, so source it!
   . $CONF
else
   echo -e "Couldn't find $CONF!  This is required!"
   exit 1
fi 

#
# A quick function to check the screenshots directory
# for 'validity'
#
function check_sshots_dir()
{  
	[ -f '$SSHOTS_PAT' ] && echo "$SSHOTS_PATH does not exist.  Please verify this directory is correct." && exit 1
	SSHOTS_EXIST=`ls $SSHOTS_PATH | grep $SSHOTS_FTYPE | grep "No such file or directory"`
	[ -z "SSHOTS_EXIST" ] && echo "No screenshot files of type $SSHOTS_FTYPE exist in $SSHOTS_PATH.  Please verify this directory is correct." && exit 1
}


#
# Now, lets move on to variable sanity...
#

[ -z "$VWIDTH" ] && echo "Enter the desired video width: (ex: 1024 from 1024x768)" && read VWIDTH
[ -z "$VHEIGHT" ] && echo "Enter the desired video height: (ex: 768 from 1024x768)" && read VHEIGHT
[ -z "$SSHOTS_FTYPE" ] && echo "What file type are your screenshots in? (ex: tga)" && read SSHOTS_FTYPE
[ -z "$SSHOTS_PATH" ] && echo "Which directory contains your TC:E screenshots?" && read SSHOTS_PATH && check_sshots_dir
[ -z "$CODEC" ] && echo "Wich codec you want to compress the demo? (xvid | divx)" && read CODEC
[ -z "$FPS" ] && echo "Wich frame rate do you want to use at conversion? (default 25)" && read FPS

if [ -z "$VIDEO_PATH" ]; then
	echo "Which directory do you want to save your video to?" && read VIDEO_PATH
	if [ ! -d $VIDEO_PATH ]; then
		echo "$VIDEO_PATH does not exist.  Would you like to create it now? (y/n)m" && read VPATH_CONF
		if [ "$VPATH_CONF" = "y" ]; then
			 mkdir "$VIDEO_PATH"
		else
			echo "Please find a suitable path and execute this script again." && exit 1
		fi
	fi
fi

[ -z "$VIDEO_NAME" ] && echo "Enter the filename you want to save the movie as (should have an .avi extension):" && read VIDEO_NAME

# Verify our screenshots directory again, just in case
# we did it from the conf file
check_sshots_dir

# Make sure our video path exists by this point
[ -f '$VIDEO_PATH' ] && mkdir $VIDEO_PATH

# Make the temp directory
mkdir $VIDEO_PATH/$TIMESTAMP

# Move the screenshots over into a 'working directory'
echo "Moving current screenshots to \"$VIDEO_PATH/$TIMESTAMP\""
TEMP=`pwd`; cd $SSHOTS_PATH ; mv `ls $SSHOTS_PATH/ | grep .tga` $VIDEO_PATH/$TIMESTAMP; cd $TEMP
# Change to the directory with the screenshots, so the mf:// will work properly
cd "$VIDEO_PATH/$TIMESTAMP"

# Do the mencoder magic
echo "Creating video \"$VIDEO_PATH/$VIDEO_NAME\"..."
$MENCODER $MENCODER_CREATE_OPTS $VIDEO_PATH/TEMP-$VIDEO_NAME

# Resize it to our desired size now
echo "Resizing video to the desired resolution..."
$MENCODER $VIDEO_PATH/TEMP-$VIDEO_NAME $MENCODER_RESIZE_OPTS $VIDEO_PATH/$VIDEO_NAME

# Remove the temp file
rm $VIDEO_PATH/TEMP-$VIDEO_NAME

echo "Clean up all $SSHOTS_FTYPE screenshots files? (y/n)"
read EMPTY
if [ "$EMPTY" = "y" ]; then
   rm -rf $VIDEO_PATH/$TIMESTAMP
   rm -rf $SSHOTS_PATH/*.$SSHOTS_FTYPE
fi

echo "Process complete."
   
# End of file
