#!/bin/sh

########################################################
# Variables
########################################################

SCRIPT_HOME=`dirname $0 | while read a; do cd $a && pwd && break; done`
SCRIPT_NAME=$(basename $0)
BLUE="\e[34m"
RED="\e[31m"
YELLOW="\e[1;33m"
RESET="\e[0m"

########################################################
# User inputs
########################################################

echo -e "$BLUE[$SCRIPT_NAME]$RESET Defaults: next.js, eslint, prettier"
read -p "$(echo -e $BLUE"[$SCRIPT_NAME]"$RESET$YELLOW Enter app name: $RESET)" appname

if [ "$appname" == "" ]
then
    echo -e "$BLUE[$SCRIPT_NAME]$RESET$RED Please specify an app name!$RESET"
    exit
fi

read -p "$(echo -e $BLUE"[$SCRIPT_NAME]"$RESET$YELLOW Install emotion as well? [Y/n]: $RESET)" optionInstallEmotion
read -p "$(echo -e $BLUE"[$SCRIPT_NAME]"$RESET$YELLOW Install material ui as well? [Y/n]: $RESET)" optionInstallMaterialUi

########################################################
# Next.js
########################################################

APPDIR=$prj/$appname

echo -e "$BLUE[$SCRIPT_NAME]$RESET Running create-next-app"
npx create-next-app@latest $prj/$appname --ts

echo -e "$BLUE[$SCRIPT_NAME]$RESET Deleting "pages/api""
rm -rf $APPDIR/pages/api

echo -e "$BLUE[$SCRIPT_NAME]$RESET Deleting "styles/Home.module.css""
rm -f $APPDIR/styles/Home.module.css

########################################################
# ESLint
########################################################

echo -e "$BLUE[$SCRIPT_NAME]$RESET Updating .eslintrc.json with custom rules"
cat $SCRIPT_HOME/dotfiles/.eslintrc.json > $APPDIR/.eslintrc.json

echo -e "$BLUE[$SCRIPT_NAME]$RESET Updating index.tsx with eslint-disable react/function-component-definition"
cat $SCRIPT_HOME/dotfiles/index.tsx > $APPDIR/pages/index.tsx

########################################################
# Prettier
########################################################

echo -e "$BLUE[$SCRIPT_NAME]$RESET Intalling prettier"
npm --prefix $APPDIR install -D --save-exact prettier eslint-config-prettier eslint-plugin-prettier

echo -e "$BLUE[$SCRIPT_NAME]$RESET Creating .prettierrc.json"
cat $SCRIPT_HOME/dotfiles/.prettierrc.json > $APPDIR/.prettierrc.json

echo -e "$BLUE[$SCRIPT_NAME]$RESET Creating .prettierignore"
cat $APPDIR/.gitignore > $APPDIR/.prettierignore

########################################################
# Emotion
########################################################

if [ "$optionInstallEmotion" != "n" ]
then
    echo -e "$BLUE[$SCRIPT_NAME]$RESET Installing emotion"
    npm --prefix $APPDIR install @emotion/styled @emotion/react
fi

########################################################
# Material UI
########################################################

if [ "$optionInstallMaterialUi" != "n" ]
then
    echo -e "$BLUE[$SCRIPT_NAME]$RESET Installing Material UI"
    npm --prefix $APPDIR install @mui/material @mui/icons-material

    echo -e "$BLUE[$SCRIPT_NAME]$RESET Adding Material UI links to _document.tsx"
    cat $SCRIPT_HOME/dotfiles/_document.tsx > $APPDIR/pages/_document.tsx
fi

echo -e "$BLUE[$SCRIPT_NAME]$RESET Done!"