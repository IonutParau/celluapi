# ✨CelLuAPI
A mod of CelLua Machine that adds modding support and even support for running multiple mods at once.
## 🧾How to install a mod
To install a mod, after you downloaded CelLuAPI as a .love (or .zip) file, rename it from .love to .zip and then extract it in some folder. In that folder, you have to drag and drop the files of the mod. After that, look for a file called mods.txt and edit it to make sure it has in at least 1 line the name of the mod. After that turn the folder into a zip file and rename the zip file from .zip to .love and then double click it to run it. Also you can drag and drop the folder to the love2d.
## 💻The modding API
The modding API is what allows mods to operate. The modding API can be found at the [WiKi](https://github.com/IonutParau/celluapi/wiki).
## 🏃‍♂️Running
1. [Download a release](https://github.com/IonutParau/celluapi/releases), preferably the latest version
2. Download and install [LÖVE](https://love2d.org)
3. Double-click the .love file (might not work on all OS, for more information [see](https://love2d.org/wiki/Getting_Started#Running_Games) )
## 🧪Basic Terminology
**Return table** - All mods must return a table containing properties that are functions the mod uses to interface with the API.
