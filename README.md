# CelLua Machine
A fanmade version of Sam Hogan's Cell Machine, based heavily off the Mystic Mod, that adds a bunch of new cells and features.
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

The parameters are: the cell label, the name of the texture file (with .png), a function for defining if it can be pushed (has 6 parameters, the cells x, y, and rotation and the pushers x, y, and rotation). There is a 4th optional argument for defining if it is a puller/pusher. Recommended for things that need to pull.

The modding API allows you to access any function in CelLua, and even override them (not recommended, do not try).

## How to install a mod
To install a mod you just need to put the mod's files in here.
After that, you need to find the mods.txt file. In that file, you need to make sure there is a line with the exact name of the .lua file the mod needs.
## Running
1. Download a release, preferably the latest one, at https://github.com/KyYay/CelLua-Machine/releases
2. Download and install LOVE at https://love2d.org
3. Double-click the .love file (might not work on all OS, for more info see https://love2d.org/wiki/Getting_Started#Running_Games)
## Sharing Levels
When you click the save button, the code for your level will simply be copied straight to your clipboard.
If you use an app or website to share levels that has markdown, like Discord, use some method of supressing it, otherwise it's possible that the code will not be posted properly. The easiest way with Discord is to surround your code in two \` marks.
## Compiling mods
1. Create a zip file of the whole game directory (make sure the zip contains the files and *not* the folder OF the files)
2. Rename the .zip to .love <br>
For more info see https://love2d.org/wiki/Game_Distribution#Create_a_.love-file
## Basic Terminology
Semi-immovable - A cell that cannot be moved by pushing or pulling, but can still be moved by position-swapping cells like mirrors and gears. Gate cells are an example of this.
## New Cells
Trash Cell - Deletes any cells that get pushed into it. Taken from the Mystic Mod. <br>
![image](https://user-images.githubusercontent.com/71151507/126050831-631a3a5e-856f-418b-a6a5-0d82c4834672.png)

One/Two/Three Directional - Can only be pushed towards the marked directions. <br>
![image](https://user-images.githubusercontent.com/71151507/126050754-adf65e40-b0f1-46d7-838a-be619b70080b.png) ![image](https://user-images.githubusercontent.com/71151507/126050761-58bd68c4-b6e1-45ed-a641-2215cd5e7efc.png) ![image](https://user-images.githubusercontent.com/71151507/126050767-433d2200-dd3a-496a-bf16-98f90d3abcb0.png)

180° Rotator Cell - Rotates cells 180 degrees. <br>
![image](https://user-images.githubusercontent.com/71151507/126050775-03e39b96-f705-44a9-bc3f-14cfa01945c1.png)

Mirror Cell - Swaps the cells that it's arrows point to. <br>
![image](https://user-images.githubusercontent.com/71151507/126050777-9a8072e9-88d6-453c-84f5-43e31b175d9a.png)
![image](https://user-images.githubusercontent.com/71151507/129133790-319f2167-1cd9-40c4-8c92-fb0c3a856dcd.png)

Puller Cell - Pulls cells. Does not push cells. <br>
![image](https://user-images.githubusercontent.com/71151507/126050778-88e20293-cea0-4c5c-a925-e1a74ae26202.png)

Diverger Cell - Any forces that come into the sides which the arrows point to get rotated 90° and teleported to the end of the diverger. This is a dangerous cell to play with, as it's very concept provides the possibility of infinite loops; I have done my best to prevent these, but if an infinite loop slips by, it will stop the loop and create a trash cell, for debugging purposes. <br>
![image](https://user-images.githubusercontent.com/71151507/126050780-6e618371-dfce-4482-b580-87d5b6cac04b.png)
![image](https://user-images.githubusercontent.com/71151507/126437594-23d8c6c9-2389-4a0f-b4cb-ffd15b14dc73.png)
![image](https://user-images.githubusercontent.com/71151507/129133820-a32bc89b-67c8-4270-b996-7204b47771c5.png)
![image](https://user-images.githubusercontent.com/71151507/129133824-0087fa14-4d51-465c-be3a-34a01603ee2e.png)

Redirector Cell - Sets the rotation of the 4 cells it touches to it's own rotation. Wont affect other redirectors. <br>
![image](https://user-images.githubusercontent.com/71151507/126050783-5fd81eeb-c7f5-433a-b894-36390eb88dfe.png)

Gear Cell - Grabs the 8 cells nearby and rotates them 45 degrees around itself. Cells going from diagonally adjacent to orthogonally adjacent will have their rotation adjusted. <br>
![image](https://user-images.githubusercontent.com/71151507/126050785-8d82bd19-1859-4a33-a3c8-a15a94a1a761.png)
![image](https://user-images.githubusercontent.com/71151507/126050787-560bc47e-8b21-4807-aea1-ecbb3170ace8.png)

Mold Cell - Upon being generated by a generator, the generated cell will disappear (but the forces from being cloned will still apply.) <br>
![image](https://user-images.githubusercontent.com/71151507/126050788-3ec06ebc-e78f-4282-af07-ea3c509ea1c9.png)

Repulse Cell - Applies a pushing force in all 4 directions. <br>
![image](https://user-images.githubusercontent.com/71151507/126256027-cf7ef041-e25f-4b42-a5d8-ca7f0a8001a0.png)

Weight Cell - This cell will effectively remove the force from one mover that is trying to push it. They will stack with each other. <br>
![image](https://user-images.githubusercontent.com/71151507/126050791-9d8e1397-cad7-4137-97a1-e8d5bb40f2cf.png)

Cross Generator Cell - Clones in two directions. <br>
![image](https://user-images.githubusercontent.com/71151507/126051500-9b347b2a-0b6a-44c6-adfa-714374a4958f.png)

Strong Enemy Cell - An enemy cell that takes two hits to kill. <br>
![image](https://user-images.githubusercontent.com/71151507/126051507-b1d115c5-bcc6-41af-8f70-b32fbb13d633.png)

Freezer Cell - Stops adjacent cells from preforming their actions. Other cells will still treat them as normal. If a cell is moved next to it after it's subtick finishes, the cell will act normally.<br>
![image](https://user-images.githubusercontent.com/71151507/126086251-545d9fc6-6bb9-463d-9c85-de33d05621db.png)

Angled Generators - Generate at an angle. Rotation of the generated cell will be affected. <br>
![image](https://user-images.githubusercontent.com/71151507/126085128-11d6900b-ba94-4275-9d5b-9bd95307cbd1.png)
![image](https://user-images.githubusercontent.com/71151507/126085129-7a778814-2352-4d35-89d4-4ec5b4119da9.png)

Impulse Cell - Pulls cells 2 spaces away towards it. Can pull through trash cells and enemies.<br>
![image](https://user-images.githubusercontent.com/71151507/126256021-7ad374ce-d851-4522-a8b8-438a2306bc69.png)

Advancer Cell - Acts like a mover and puller combined. They are also, in a way, "smarter" than pullers, as if there is too much force going against them when they try to pull, they will just let go and only do the pushing.<br>
![image](https://user-images.githubusercontent.com/71151507/126256042-04006b8b-500b-428b-82d2-e10dbd3d3c98.png)

Flipper Cell - Will effectively "flip" the 4 neighboring cells horizontally or vertically, depending on it's own rotation. "Flipping" includes turning clockwise cells into counter-clockwise cells, and vice versa.<br>
![image](https://user-images.githubusercontent.com/71151507/126307519-0dea882f-cb75-4082-8b86-8ac5a3cef3ea.png)

Twist Generator Cell - Acts like a flipper and a generator combined.<br>
![image](https://user-images.githubusercontent.com/71151507/127073322-801b8fe9-34c9-4232-b8f0-7d5aaebf1436.png)

Gate Cell - Act like conditional (and semi-immobile) generator cells. They take in cells on their left and right, sort of acting like a trash cell, and clone the cell behind them if the condition is satisfied. <br>
From left to right: OR, AND, XOR, NOR, NAND, XNOR <br>
![image](https://user-images.githubusercontent.com/71151507/127064896-f5d1c6d5-3062-439b-88d4-2ddf1f705a9f.png)
![image](https://user-images.githubusercontent.com/71151507/127064903-5fd4e6ec-3354-4fff-b69d-bfffb33a5e89.png)
![image](https://user-images.githubusercontent.com/71151507/127064924-07acf6ee-6a06-4d40-bd8c-98ec8695b5a3.png)
![image](https://user-images.githubusercontent.com/71151507/127064933-1cbd9f5a-a70c-48ae-af46-7b6a9dcd773c.png)
![image](https://user-images.githubusercontent.com/71151507/127064945-b49cc596-046d-46b9-b18e-b62112483798.png)
![image](https://user-images.githubusercontent.com/71151507/127064950-c689dded-9b02-44fe-8806-769a9c8b4bfd.png)

Ghost Cell - Acts like a wall cell that cannot be generated, similar to the level border in the Mystic Mod.<br>
![image](https://user-images.githubusercontent.com/71151507/127099228-cd03e282-1d3a-41bf-9b4c-26490defd86f.png)

Bias Cell - Acts sort of like a frozen mover cell, it will add force to a mover that pushes with it and subtract force from a mover that pushes against it but never moves itself. <br>
![image](https://user-images.githubusercontent.com/71151507/127790970-efada7d0-49d3-43d2-ab10-68ffa2d6e927.png)

Replicator Cell - Basically a generator that generates the cell in front of it. Has a cross variant. <br>
![image](https://user-images.githubusercontent.com/71151507/127790974-ca4f2c12-7b16-49a1-a86c-4455dcfb04b1.png)
![image](https://user-images.githubusercontent.com/71151507/127790979-31ac7e7e-20e9-4bd2-a07c-75e238414540.png)

Intaker Cell - Described by KyYay as "some unholy abomination of a trash cell, an impulse cell, and some sort of weird reverse generator". Basically sucks cells in and destroys them. <br>
![image](https://user-images.githubusercontent.com/71151507/127790986-bce70bd9-e955-4a39-b075-4f5295d3b664.png)

Shield Cell - Protects the cells around it from crashing into enemy cells, being crashed into by enemy cells, or being transformed into fungus.<br>
![image](https://user-images.githubusercontent.com/71151507/127791071-993f3893-7768-4790-8992-1d91018aded4.png)

Fungal Cell - Transforms any cells that get pushed into it into more fungus cells.<br>
![image](https://user-images.githubusercontent.com/71151507/127791074-24b3e584-629d-4628-99ce-c25388a94aa1.png)

Forker Cell - Acts sort of like a diverger, but it's one-way and duplicates cells that come into it. Currently does not work with pulling, only pushing.<br>
NOTE: These cells are very unstable if used in a nuke, and are very very likely to crash your game. You have been warned. <br>
![image](https://user-images.githubusercontent.com/71151507/127791086-ab71252d-802e-4c46-ac83-e64b48a1db83.png)
![image](https://user-images.githubusercontent.com/71151507/127791139-7a469fe1-12be-4349-81af-af8053a8bcb8.png)

Demolisher Cell - Acts like a trash cell, but when something is pushed into it, it also destroys the 4 cells around it (if they are destroyable). <br>
![image](https://user-images.githubusercontent.com/71151507/129134219-68c8d8ca-a070-42e4-9f26-26fa734ff3a0.png)

Opposition Cell - Can be pushed in the direction of the blue arrow, and pulled in the direction of the pink arrow. Yellow line represents being able to be both pushed and pulled in both directions that the line points in, like a slide cell. <br>
![image](https://user-images.githubusercontent.com/71151507/129134269-6b6d9c28-5017-4653-8622-754bdd8ec9a3.png)
![image](https://user-images.githubusercontent.com/71151507/129134282-54b95e5b-f8dc-4e1b-8d16-640036992434.png)
![image](https://user-images.githubusercontent.com/71151507/129134295-ea119d80-b00c-4d6c-95e6-09cfa49b8dfa.png)

Super Repulsor Cell - Acts like a repulsor, but it will push cells infinitely until it either comes across an obstacle or realizes it's in an infinite loop. <br>
![image](https://user-images.githubusercontent.com/71151507/129133999-c803ac2c-0313-4389-add9-d2cfde2141c6.png)

Super Generator Cell - Generates the entire row of cells behind it. Will not generate if it gets in an infinite loop. <br>
![image](https://user-images.githubusercontent.com/71151507/129133932-584544b2-364e-4548-a6a4-94acb248be1f.png)

Double Rotator Cell - Acts like a cw rotator on two sides, and like a ccw rotator on the other two. <br>
![image](https://user-images.githubusercontent.com/71151507/129176904-791dd055-9d7e-4ab6-aca7-3c20311defec.png)

Driller Cell - Acts sort of like a mirror cell, but it swaps the cell it's pointing to with itself (or deletes itself if it tries to swap a trash or demolisher cell). Has no actual pushing or pulling force. <br>
![image](https://user-images.githubusercontent.com/71151507/129170430-d7a0289d-6b17-4313-ba6f-87fee77297ee.png)

Current priority system (updating from left to right) <br>
![image](https://user-images.githubusercontent.com/71151507/129170459-4d88cc0e-19b0-4305-ba96-bdfba2e1baee.png) <br>
(Cross generators are like normal generators but are activated in two different subticks, and angled generators are updated after normal/cross generators)<br>
(The same logic applies to replicators and the cross mirror)<br>
(Twist generators update at the same time as normal generators)<br>
(All types of gate cells update at the same time)
