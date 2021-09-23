# CelLuAPI
A mod of CelLua Machine that adds modding support and even support for running multiple mods at once.
# This mod in paticular
This mod adds a API for adding more mods.
## The Modding API
The modding api allows mod creators to easily make mods. If you only want to install mods, skip to How to install a mod.

This is how the modding API works:
You need a local function for initializing the mod and one for cell updates.
You need to make sure your mod returns a table with 2 fuctions. One called init which initialises the mod and has no arguments, and one called update which updates modded cells and has 4 arguments.
Please note update is called whenever a modded cell from any mod is detected. Dont assume it is always your cell.

The arguments of update are: id, x, y, rotation.

To create a custom cell use addCell. It takes 3 parameters (though there is an optional one as well).

The parameters are: the cell label, the name of the texture file (with .png), a function for defining if it can be pushed (has 6 parameters, the cells x, y, and rotation and the pushers x, y, and rotation). There is a 4th optional argument for defining the type. The types are: normal, mover and enemy. By default its normal.

The modding API allows you to access any function in CelLua, and even override them (not recommended, do not try).

## How to install a mod
To install a mod, after you downloaded CelLuAPI as a .love file, rename it from .love to .zip and then extract it in some folder. In that folder, you have to drag and drop the files of the mod. After that, look for a file called mods.txt and edit it to make sure it has in at least 1 line the name of the mod. After that turn the folder into a zip file and rename the zip file from .zip to .love and then double click it to run it.
## Running
1. Download a release, preferably the latest one, at https://github.com/IonutParau/celluapi/releases
2. Download and install LOVE at https://love2d.org
3. Double-click the .love file (might not work on all OS, for more info see https://love2d.org/wiki/Getting_Started#Running_Games)
## Basic Terminology
Return table - All mods must return a table containing properties that are functions the mod uses to interface with the API.
