# PIES Zebra Scanner App
This project is used to build the HTML/CSS/JS frontend files needed for the app. Essentially all of the app logic is found in this code/project.

## Tech Overview
- JS frontend app using Vue.js & SCSS
- Built using NVM & Node (can use the nvmrc file and `$ nvm i` for node version control)

## Project Structure
- project-root/
  - node_modules/ (project dependencies managed via package.json)
  - pies-zebra-scanner/ (output directory, generated via build script, will be copied/deployed to device)
  - src/ (source code)
    - components/ (vue components, just broken up into common widgets/screens/base-classes for better organization)
    - img/ (images to be used in the app)
    - lib/ (zebra library files)
    - style/ (frontend styles, all manually included in the main style file)
    - App.vue (main vue file)
    - main.js (main JS file)
    - main.scss (main style file)
  - .nvmrc (nvm/node version helper)
  - build_vue_cli.sh (build script)
  - package.json (project dependencies via NPM)

## How to local serve without scanner
In order to serve the project, first run `$ npm i` if you have not already to install all dependencies. Then simply run the serve command `$ npm run serve`.

## How to Build
In order to build the project, first run `$ npm i` if you have not already to install all dependencies. Then simply run the build `$ npm run build`. It will build the JS & SCSS, then copy additional assets like images & lib files. It will all output to a new directory `pies-zebra-scanner/`.

## How to Deploy
This is still a litle bit under development but here is the test process so far:
1. Deploy the [Zebra Demo App](https://techdocs.zebra.com/enterprise-browser/3-0/guide/featuredemo/) to a device. Essentially copy the APK to the device via [Android file transfer](https://www.android.com/filetransfer/) and then manually install the app on device.
2. Also deploying/copying the build directory from this project to the device into the Zebra Demo App data directory Android/data/com.zebra.mdna.enterprisebrowser
3. Modifying the Config.xml to use the pies-zebra-scanner/main.html file.
4. Repeat #2 as changes are made.

## Helpful Docs
- [Enterprise Browser 3.3 Overview](https://techdocs.zebra.com/enterprise-browser/3-3/guide/about/)
- [Enterprise Browser Download](https://www.zebra.com/us/en/support-downloads/software/developer-tools/enterprise-browser.html)
- [Enterprise Browser Demo App](https://techdocs.zebra.com/enterprise-browser/3-0/guide/featuredemo/)
- [Enterprise Browser Licensing](https://techdocs.zebra.com/enterprise-browser/latest/guide/licensing/)
- [Quickbase API](https://helpv2.quickbase.com/hc/en-us/sections/4408105467540-Quickbase-API-Call-Reference)
