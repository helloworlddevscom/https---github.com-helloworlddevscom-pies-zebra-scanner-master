if [ -d "pies-zebra-scanner" ]; then
  echo "Removing old output folder ..."
  rm -rf pies-zebra-scanner
fi

echo "Building via vue-cli ..."
vue-cli-service build

echo "Renaming output folder ..."
mv dist pies-zebra-scanner

echo "Removing favicon.ico ..."
rm pies-zebra-scanner/favicon.ico

echo "Moving JS files within output folder ..."
cp -r pies-zebra-scanner/js/* pies-zebra-scanner/
rm -rf pies-zebra-scanner/js

echo "Moving CSS files within output folder ..."
cp -r pies-zebra-scanner/css/* pies-zebra-scanner/
rm -rf pies-zebra-scanner/css

echo "Renaming index.html to match what is in Config.xml ..."
mv pies-zebra-scanner/index.html pies-zebra-scanner/main.html

echo "Copying zebra JS lib files to output folder ..."
cp -r src/lib/ pies-zebra-scanner/

echo "Next steps use Mac format for sed command ..."
echo "Inserting zebra JS lib files into index.html ..."
sed -i '' 's/<head>/<head><script src="ebapi-modules.js"><\/script><script src="elements.js"><\/script>/' "pies-zebra-scanner/main.html"

echo "Removing js && css prefix in index.html ..."
sed -i '' 's/\/js\///g' "pies-zebra-scanner/main.html"
sed -i '' 's/\/css\///g' "pies-zebra-scanner/main.html"


echo "Done. All files are in the pies-zebra-scanner folder."
