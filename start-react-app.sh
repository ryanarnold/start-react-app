#!/bin/sh

########################################################
# Variables
########################################################

SCRIPT_HOME=`dirname $0 | while read a; do cd $a && pwd && break; done`

########################################################
# Next.js
########################################################

read -p "Enter app name: " appname

appdir=$prj/$appname

echo -e "\e[34m[$0]\e[0m Running create-next-app"
npx create-next-app@latest $prj/$appname --ts

echo -e "\e[34m[$0]\e[0m Deleting "pages/api""
rm -rf $appdir/pages/api

echo -e "\e[34m[$0]\e[0m Deleting "styles/Home.module.css""
rm -f $appdir/styles/Home.module.css

########################################################
# ESLint
########################################################

echo -e "\e[34m[$0]\e[0m Updating .eslintrc.json with custom rules"
node $SCRIPT_HOME/update-eslintrc.js $appdir
cat $SCRIPT_HOME/dotfiles/.eslintrc.json $appdir/.eslintrc.json

echo -e "\e[34m[$0]\e[0m Updating index.tsx with eslint-disable react/function-component-definition"
cat $SCRIPT_HOME/dotfiles/index.tsx > $appdir/pages/index.tsx

########################################################
# Prettier
########################################################

echo -e "\e[34m[$0]\e[0m Intalling prettier"
npm --prefix $appdir install -D --save-exact prettier eslint-config-prettier eslint-plugin-prettier

echo -e "\e[34m[$0]\e[0m Creating .prettierrc.json"
cat $SCRIPT_HOME/dotfiles/.prettierrc.json > $appdir/.prettierrc.json

echo -e "\e[34m[$0]\e[0m Creating .prettierignore"
cat $appdir/.gitignore > $appdir/.prettierignore

########################################################
# Emotion
########################################################

echo -e "\e[34m[$0]\e[0m Installing emotion"
npm --prefix $appdir install @emotion/styled @emotion/react

echo -e "\e[34m[$0]\e[0m Installing Material UI"
npm --prefix $appdir install @mui/material @mui/icons-material

echo -e "\e[34m[$0]\e[0m Adding Material UI links to _document.tsx"
cat $SCRIPT_HOME/dotfiles/_document.tsx > $appdir/pages/_document.tsx

echo -e "\e[34m[$0]\e[0m Done!"