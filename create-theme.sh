#!/bin/bash
if [ "$#" -ne 2 ]; then
	echo "You must specify theme name and css|less in that order, usage example: createtheme.sh THEME less"
	exit	
fi

THEMENAME=$1
DIRPATH="sites/all/themes/$THEMENAME"

if [ -d "$DIRPATH" ]; then
	echo "The theme $THEMENAME already exists"
	exit
fi

if [ "$2" != "css" -a "$2" != "less" ]; then
	echo "You must specify if you going to use pure css or less, usage example: createtheme.sh THEME less";
	exit;
fi

STYLEEXT=$2

echo "creating theme structure";

#create usual directories
mkdir $DIRPATH $DIRPATH/images $DIRPATH/css $DIRPATH/templates

#create a info file
INFOTEXT="name = $THEMENAME\n
description = The custom project theme.\n
package = $THEMENAME\n
version = 1.0\n
core = 7.x\n
stylesheets[screen][] = css/style.$STYLEEXT"

echo -e $INFOTEXT >> $DIRPATH/$THEMENAME.info;

#create css file
echo "//FILE generated with drupal theme creator" >> $DIRPATH/css/style.$STYLEEXT;

echo "[ok] structure created";

if [ "$STYLEEXT" == "less" ]; then
	command -v drush >/dev/null 2>&1 || { echo >&2 "[Warning] If drush is installed i can download less module."; exit 1; }
	
	echo "Downloading less module";
	
	DRUSHDL="drush dl less"
	DRUSHIN="drush en less -y"
	$DRUSHDL
	$DRUSHIN

	DRUSHENTH="drush en $THEMENAME"
	DRUSHINSTH="drush vset theme_default $THEMENAME"
	$DRUSHENTH
	$DRUSHINSTH
fi

echo "DONE"

