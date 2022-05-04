read -p "Enter app name: " appname

npx create-next-app@latest $appname --ts
cd $appname

echo [INFO] Deleting "pages/api"
rm -rf pages/api

echo [INFO] Deleting "styles/Home.module.css"
rm -f styles/Home.module.css
