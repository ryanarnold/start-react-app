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
# read -p "$(echo -e $BOLD$YELLOW"foo bar "$RESET)" INPUT_VARIABLE

########################################################
# Next.js
########################################################

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Defaults: next.js, eslint, prettier"
read -p "$(echo -e $BLUE"[$SCRIPT_NAME]"$RESET$YELLOW Enter app name: $RESET)" appname

if [ "$appname" == "" ]
then
    echo -e "$BLUE[$SCRIPT_NAME]$RESET$RED Please specify an app name!$RESET"
    exit
fi

read -p "$(echo -e $BLUE"[$SCRIPT_NAME]"$RESET$YELLOW Install emotion as well? [Y/n]: $RESET)" optionInstallEmotion
read -p "$(echo -e $BLUE"[$SCRIPT_NAME]"$RESET$YELLOW Install material ui as well? [Y/n]: $RESET)" optionInstallMaterialUi

appdir=$prj/$appname

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Running create-next-app"
npx create-next-app@latest $prj/$appname --ts

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Deleting "pages/api""
rm -rf $appdir/pages/api

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Deleting "styles/Home.module.css""
rm -f $appdir/styles/Home.module.css

########################################################
# ESLint
########################################################

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Updating .eslintrc.json with custom rules"
cat $SCRIPT_HOME/dotfiles/.eslintrc.json > $appdir/.eslintrc.json

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Updating index.tsx with eslint-disable react/function-component-definition"
cat $SCRIPT_HOME/dotfiles/index.tsx > $appdir/pages/index.tsx

########################################################
# Prettier
########################################################

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Intalling prettier"
npm --prefix $appdir install -D --save-exact prettier eslint-config-prettier eslint-plugin-prettier

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Creating .prettierrc.json"
cat $SCRIPT_HOME/dotfiles/.prettierrc.json > $appdir/.prettierrc.json

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Creating .prettierignore"
cat $appdir/.gitignore > $appdir/.prettierignore

########################################################
# Emotion
########################################################

if [ "$optionInstallEmotion" != "n" ]
then
    echo -e "\e[34m[$SCRIPT_NAME]\e[0m Installing emotion"
    npm --prefix $appdir install @emotion/styled @emotion/react
fi

########################################################
# Material UI
########################################################

if [ "$optionInstallMaterialUi" != "n" ]
then
    echo -e "\e[34m[$SCRIPT_NAME]\e[0m Installing Material UI"
    npm --prefix $appdir install @mui/material @mui/icons-material

    echo -e "\e[34m[$SCRIPT_NAME]\e[0m Adding Material UI links to _document.tsx"
    cat $SCRIPT_HOME/dotfiles/_document.tsx > $appdir/pages/_document.tsx
fi

echo -e "\e[34m[$SCRIPT_NAME]\e[0m Done!"