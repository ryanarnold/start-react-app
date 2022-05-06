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
read -p "$(echo -e $BLUE"[$SCRIPT_NAME]"$RESET$YELLOW Enter app name: $RESET)" APPNAME

if [ "$APPNAME" == "" ]
then
    echo -e "$BLUE[$SCRIPT_NAME]$RESET$RED Please specify an app name!$RESET"
    exit
fi

read -p "$(echo -e $BLUE"[$SCRIPT_NAME]"$RESET$YELLOW Install emotion? [Y/n]: $RESET)" optionInstallEmotion
read -p "$(echo -e $BLUE"[$SCRIPT_NAME]"$RESET$YELLOW Install material ui? [Y/n]: $RESET)" optionInstallMaterialUi

########################################################
# Next.js
########################################################

APPDIR=$prj/$APPNAME

echo -e "$BLUE[$SCRIPT_NAME]$RESET Running create-next-app"
npx create-next-app@latest $prj/$APPNAME --ts

echo -e "$BLUE[$SCRIPT_NAME]$RESET Deleting "pages/api""
rm -rf $APPDIR/pages/api

echo -e "$BLUE[$SCRIPT_NAME]$RESET Deleting "styles/Home.module.css""
rm -f $APPDIR/styles/Home.module.css

echo -e "$BLUE[$SCRIPT_NAME]$RESET Creating _document.tsx"
cat $SCRIPT_HOME/dotfiles/_document.tsx > $APPDIR/pages/_document.tsx

echo -e "$BLUE[$SCRIPT_NAME]$RESET Updating index.tsx"
cat $SCRIPT_HOME/dotfiles/index.tsx > $APPDIR/pages/index.tsx

########################################################
# ESLint and Prettier
########################################################

echo -e "$BLUE[$SCRIPT_NAME]$RESET Installing ESLint and Prettier"
npm --prefix $APPDIR install -D eslint prettier eslint-config-prettier eslint-plugin-prettier

echo -e "$BLUE[$SCRIPT_NAME]$RESET Creating .prettierrc.json"
cat $SCRIPT_HOME/dotfiles/.prettierrc.json > $APPDIR/.prettierrc.json

echo -e "$BLUE[$SCRIPT_NAME]$RESET Creating .prettierignore"
cat $APPDIR/.gitignore > $APPDIR/.prettierignore

cd $APPDIR
echo -e "$BLUE[$SCRIPT_NAME]$RESET Initializing ESLint"
npm init @eslint/config

echo -e "$BLUE[$SCRIPT_NAME]$RESET Updating .eslintrc.json with custom rules"
cat $SCRIPT_HOME/dotfiles/.eslintrc.json > $APPDIR/.eslintrc.json


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
fi

########################################################
# VS Code
########################################################

echo -e "$BLUE[$SCRIPT_NAME]$RESET Creating VS Code workspace settings"
mkdir $APPDIR/.vscode
cat $SCRIPT_HOME/dotfiles/vscode_settings.json > $APPDIR/.vscode/settings.json

echo -e "$BLUE[$SCRIPT_NAME]$RESET Done!"
