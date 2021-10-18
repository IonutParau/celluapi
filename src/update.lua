function UpdateFreezers()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasfreezer then
				if cells[y][x].ctype == 24 then
					cells[y+1][x].updated = (cells[y+1][x].ctype ~= 19 and not isUnfreezable(cells[y+1][x].ctype))	--mold disappears if .updated is true
					cells[y-1][x].updated = (cells[y-1][x].ctype ~= 19 and not isUnfreezable(cells[y-1][x].ctype))
					cells[y][x+1].updated = (cells[y][x+1].ctype ~= 19 and not isUnfreezable(cells[y][x+1].ctype))
					cells[y][x-1].updated = (cells[y][x-1].ctype ~= 19 and not isUnfreezable(cells[y][x-1].ctype))
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
end

function UpdateShields()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasshield then
				if not cells[y][x].updated and cells[y][x].ctype == 42 then
					for cx=x-1,x+1 do
						for cy=y-1,y+1 do
							cells[cy][cx].protected = true
						end
					end
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
end

function UpdateMirrors()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasmirror then
				if not cells[y][x].updated and (cells[y][x].ctype == 14 and (cells[y][x].rot == 0 or cells[y][x].rot == 2) or cells[y][x].ctype == 55) then
					local canPushLeft = true
					local canPushRight = true
					if cells[y][x-1] ~= nil then
						if cells[y][x-1].ctype > initialCellCount then
							canPushLeft = canPushCell(x-1, y, x, y, "mirror")
						end
					end
					if cells[y][x+1] ~= nil then
						if cells[y][x+1].ctype > initialCellCount then
							canPushRight = canPushCell(x+1, y, x, y, "mirror")
						end
					end
					if isModdedTrash(cells[y][x-1].ctype) or ((GetSidedTrash(cells[y][x-1].ctype) ~= nil and GetSidedTrash(cells[y][x-1].ctype)(x-1, y, 2) == false)) then
						canPushLeft = false
					end
					if isModdedTrash(cells[y][x+1].ctype) or (GetSidedTrash(cells[y][x+1].ctype) ~= nil and GetSidedTrash(cells[y][x+1].ctype)(x+1, y, 2) == false) then
						canPushRight = false
					end
					if (cells[y][x-1].ctype ~= 11 and cells[y][x-1].ctype ~= 50 and cells[y][x-1].ctype ~= 55 and cells[y][x-1].ctype ~= -1 and cells[y][x-1].ctype ~= 40 and (cells[y][x-1].ctype ~= 14 or cells[y][x-1].rot%2 == 1) and canPushLeft
					and cells[y][x+1].ctype ~= 11 and cells[y][x+1].ctype ~= 50 and cells[y][x+1].ctype ~= 55 and cells[y][x+1].ctype ~= -1 and cells[y][x+1].ctype ~= 40 and (cells[y][x+1].ctype ~= 14 or cells[y][x+1].rot%2 == 1) and canPushRight) or config['mirror_restrictions'] ~= 'true' then
						local oldcell = CopyCell(x-1,y)
						cells[y][x-1] = CopyCell(x+1,y)
						cells[y][x+1] = oldcell
						SetChunk(x-1,y,cells[y][x-1].ctype)
						SetChunk(x+1,y,cells[y][x+1].ctype)
					end
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasmirror then
				local canPushUp = true
				local canPushDown = true
				if cells[y-1] ~= nil then
					if cells[y-1][x].ctype > initialCellCount then
						canPushUp = canPushCell(x, y-1, x, y, "mirror")
					end
				end
				if cells[y+1] ~= nil then
					if cells[y+1][x].ctype > initialCellCount then
						canPushDown = canPushCell(x, y+1, x, y, "mirror")
					end
				end
				if cells[y-1] ~= nil then
					if isModdedTrash(cells[y-1][x].ctype) or ((GetSidedTrash(cells[y-1][x].ctype) ~= nil and GetSidedTrash(cells[y-1][x].ctype)(x, y-1, 3) == false)) then
						canPushUp = false
					end
				end
				if cells[y+1] ~= nil then
					if isModdedTrash(cells[y+1][x].ctype) or ((GetSidedTrash(cells[y+1][x].ctype) ~= nil and GetSidedTrash(cells[y+1][x].ctype)(x, y+1, 3) == false)) then
						canPushDown = false
					end
				end
				if not cells[y][x].updated and (cells[y][x].ctype == 14 and (cells[y][x].rot == 1 or cells[y][x].rot == 3) or cells[y][x].ctype == 55) then
					if cells[y-1][x].ctype ~= 11 and cells[y-1][x].ctype ~= 55 and cells[y-1][x].ctype ~= 50 and cells[y-1][x].ctype ~= -1 and cells[y-1][x].ctype ~= 40 and (cells[y-1][x].ctype ~= 14 or cells[y-1][x].rot%2 == 0)
					and cells[y+1][x].ctype ~= 11 and cells[y+1][x].ctype ~= 55 and cells[y+1][x].ctype ~= -1 and cells[y+1][x].ctype ~= 40 and (cells[y+1][x].ctype ~= 14 or cells[y+1][x].rot%2 == 0) and canPushUp and canPushDown or config['mirror_restrictions'] ~= 'true' then
						local oldcell = CopyCell(x,y-1)
						cells[y-1][x] = CopyCell(x,y+1)
						cells[y+1][x] = oldcell
						SetChunk(x,y-1,cells[y-1][x].ctype)
						SetChunk(x,y+1,cells[y+1][x].ctype)
					end
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		x = x + 1
		y = 0
	end
end

function DoIntaker(x,y,rot)
	local cx,cy
	if rot == 0 then cx = x + 1 elseif rot == 2 then cx = x - 1 else cx = x end
	if rot == 1 then cy = y + 1 elseif rot == 3 then cy = y - 1 else cy = y end
	PullCell(cx,cy,(rot+2)%4,false,1,false,false)
end

function UpdateIntakers()
	local x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasintaker then
				if not cells[y][x].updated and cells[y][x].ctype == 43 and cells[y][x].rot == 0 then
					DoIntaker(x,y,0)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasintaker then
				if not cells[y][x].updated and cells[y][x].ctype == 43 and cells[y][x].rot == 2 then
					DoIntaker(x,y,2)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasintaker then
				if not cells[y][x].updated and cells[y][x].ctype == 43 and cells[y][x].rot == 3 then
					DoIntaker(x,y,3)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasintaker then
				if not cells[y][x].updated and cells[y][x].ctype == 43 and cells[y][x].rot == 1 then
					DoIntaker(x,y,1)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
end

function DoSuperGenerator(x,y,dir)
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	local copied = {}
	while true do							--what cells to copy?
		cells[cy][cx].scrosses = (cells[cy][cx].supdatekey or -1) == supdatekey and cells[cy][cx].scrosses or 0
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		if (cells[cy][cx].supdatekey or -1) == supdatekey and cells[cy][cx].scrosses >= 3 then
			copied = {}
			cells[cy][cx].testvar = "genbreak"
			break
		elseif cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
			local olddir = direction
			if (cells[cy][cx].rot+3)%4 == direction then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif cells[cy][cx].ctype == 30 then
			local olddir = direction
			if (cells[cy][cx].rot+3)%2 == direction%2 then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif moddedDivergers[cells[cy][cx].ctype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
			local olddir = direction
			direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
			addedrot = addedrot - (direction-olddir)
		elseif (cells[cy][cx].ctype == 47 or cells[cy][cx].ctype == 48) and (cells[cy][cx].rot+2)%2 ~= direction%2 then
			local olddir = direction
			if (cells[cy][cx].rot+1)%4 == direction then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif cx == 0 or cx == width - 1 or cy == 0 or cy == height - 1 then
			if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 then
				local c = CopyCell(cx,cy)
				c.rot = (c.rot+addedrot)%4
				table.insert(copied,c)
			end
			cells[cy][cx].testvar = "genbreak"
			break
		elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38 or (cells[cy][cx].ctype == 48 and (cells[cy][cx].rot+2)%4 == direction)) then
			local canGenCell = CanGenCell(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy, dir)
			if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and canGenCell then
				local c = CopyCell(cx,cy)
				c.rot = (c.rot+addedrot)%4
				table.insert(copied,c)
				cells[cy][cx].testvar = "gen'd"
			else
				cells[cy][cx].testvar = "genbreak"
				break
			end
		end
		cells[cy][cx].scrosses = (cells[cy][cx].supdatekey == supdatekey and cells[cy][cx].scrosses or 0) + 1
		cells[cy][cx].supdatekey = supdatekey
	end 
	local self = CopyCell(x,y)
	for i=1,#copied do
		if not PushCell(x,y,dir,false,1,copied[i].ctype,copied[i].rot,copied[i].ctype == 19,{self.lastvars[1],self.lastvars[2],copied[i].rot},copied[i].protected,false) then
			break
		end
	end
end

function UpdateSuperGenerators()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hassupergenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 54 and cells[y][x].rot == 0 then
					DoSuperGenerator(x,y,0)
					supdatekey = supdatekey + 1
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hassupergenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 54 and cells[y][x].rot == 2 then
					DoSuperGenerator(x,y,2)
					supdatekey = supdatekey + 1
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hassupergenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 54 and cells[y][x].rot == 3 then
					DoSuperGenerator(x,y,3)
					supdatekey = supdatekey + 1
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hassupergenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 54 and cells[y][x].rot == 1 then
					DoSuperGenerator(x,y,1)
					supdatekey = supdatekey + 1
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end

function DoGenerator(x,y,dir,gendir,istwist,dontupdate)
	gendir = gendir or dir
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	if not dontupdate then cells[y][x].updated = true end
	while true do							--what cell to copy?
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		if cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
			local olddir = direction
			if (cells[cy][cx].rot+3)%4 == direction then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif cells[cy][cx].ctype == 30 then
			local olddir = direction
			if (cells[cy][cx].rot+3)%2 == direction%2 then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif moddedDivergers[cells[cy][cx].ctype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
			local olddir = direction
			direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
			addedrot = addedrot - (direction-olddir)
		elseif (cells[cy][cx].ctype == 47 or cells[cy][cx].ctype == 48) and (cells[cy][cx].rot+2)%2 ~= direction%2 then
			local olddir = direction
			if (cells[cy][cx].rot+1)%4 == direction then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38 or (cells[cy][cx].ctype == 48 and (cells[cy][cx].rot+2)%4 == direction)) then
			break
		end
	end 
	addedrot = addedrot + (gendir-dir)
	cells[cy][cx].testvar = "gen'd"
	local canGenCell = CanGenCell(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy, gendir)
	if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and canGenCell then
		if istwist then
			local gentype,genrot = cells[cy][cx].ctype,cells[cy][cx].rot+addedrot
			if cells[y][x].rot%2 == 0 then
				if gentype == 8 then gentype = 9 
				elseif gentype == 9 then gentype = 8 
				elseif gentype == 17 then gentype = 18
				elseif gentype == 18 then gentype = 17 
				elseif gentype == 25 then gentype = 26 genrot = (-genrot)%4
				elseif gentype == 26 then gentype = 25 genrot = (-genrot)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) and genrot%2 == 0 then genrot = (genrot + 1)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) then genrot = (genrot - 1)%4
				elseif (gentype == 15 or gentype == 56) and genrot%2 == 0 then genrot = (genrot - 1)%4
				elseif (gentype == 15 or gentype == 56) then genrot = (genrot + 1)%4
				-- elseif moddedDivegers[gentype] ~= nil then
				-- 	genrot = moddedDivergers[gentype](cx, cy, genrot)
				else genrot = (-genrot)%4 end
			else
				if gentype == 8 then gentype = 9 
				elseif gentype == 9 then gentype = 8 
				elseif gentype == 17 then gentype = 18
				elseif gentype == 18 then gentype = 17 
				elseif gentype == 25 then gentype = 26 genrot = (-genrot + 2)%4
				elseif gentype == 26 then gentype = 25 genrot = (-genrot + 2)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) and genrot%2 == 0 then genrot = (genrot - 1)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) then genrot = (genrot + 1)%4
				elseif (gentype == 15 or gentype == 56) and genrot%2 == 0 then genrot = (genrot + 1)%4
				elseif (gentype == 15 or gentype == 56) then genrot = (genrot - 1)%4
				-- elseif moddedDivegers[gentype] ~= nil then
				-- 	genrot = moddedDivergers[gentype](cx, cy, genrot)
				else genrot = (-genrot + 2)%4 end
			end
			local p = PushCell(x,y,gendir,false,1,gentype,genrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],genrot},cells[cy][cx].protected,false)
			if p then
				local ox, oy = cx, cy
				if direction == 0 then
					cx = x - 1	
				elseif direction == 2 then
					cx = x + 1
				elseif direction == 3 then
					cy = y + 1
				elseif direction == 1 then
					cy = y - 1
				end
				local pos = walkDivergedPath(ox, oy, cx, cy)
				cx, cy = pos.x, pos.y
				modsOnCellGenerated(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy)
			end
		else
			local p = PushCell(x,y,gendir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false)
			if p then
				local ox, oy = cx, cy
				if direction == 0 then
					cx = x - 1	
				elseif direction == 2 then
					cx = x + 1
				elseif direction == 3 then
					cy = y + 1
				elseif direction == 1 then
					cy = y - 1
				end
				local pos = walkDivergedPath(ox, oy, cx, cy)
				cx, cy = pos.x, pos.y
				modsOnCellGenerated(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy)
			end
		end
	end
end

function UpdateGenerators()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 0 or cells[y][x].ctype == 39 and cells[y][x].rot == 0 or cells[y][x].ctype == 22 and (cells[y][x].rot == 0 or cells[y][x].rot == 1)) then
					DoGenerator(x,y,0,0,cells[y][x].ctype == 39,cells[y][x].ctype == 22)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 2 or cells[y][x].ctype == 39 and cells[y][x].rot == 2 or cells[y][x].ctype == 22 and (cells[y][x].rot == 2 or cells[y][x].rot == 3)) then
					DoGenerator(x,y,2,2,cells[y][x].ctype == 39,cells[y][x].ctype == 22)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 3 or cells[y][x].ctype == 39 and cells[y][x].rot == 3 or cells[y][x].ctype == 22 and (cells[y][x].rot == 3 or cells[y][x].rot == 0)) then
					DoGenerator(x,y,3,3,cells[y][x].ctype == 39)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 1 or cells[y][x].ctype == 39 and cells[y][x].rot == 1 or cells[y][x].ctype == 22 and (cells[y][x].rot == 1 or cells[y][x].rot == 2)) then
					DoGenerator(x,y,1,1,cells[y][x].ctype == 39)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
	--angled
	x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 0 then
					DoGenerator(x,y,3,0)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 0 then
					DoGenerator(x,y,1,0)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 2 then
					DoGenerator(x,y,1,2)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 2 then
					DoGenerator(x,y,3,2)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 3 then
					DoGenerator(x,y,2,3)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 3 then
					DoGenerator(x,y,0,3)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 1 then
					DoGenerator(x,y,0,1)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 1 then
					DoGenerator(x,y,2,1)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end

function DoReplicator(x,y,dir,update)
	local direction = dir
	local cx = x
	local cy = y
	local addedrot = 0
	if update then cells[y][x].updated = true end
	while true do							--what cell to copy?
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		if cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
			local olddir = direction
			if (cells[cy][cx].rot+3)%4 == direction then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif cells[cy][cx].ctype == 30 then
			local olddir = direction
			if (cells[cy][cx].rot+3)%2 == direction%2 then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif moddedDivergers[cells[cy][cx].ctype] and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
			local olddir = direction
			direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
			addedrot = addedrot - (direction-olddir)
		elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38 or (cells[cy][cx].ctype == 48 and (cells[cy][cx].rot+2)%4 == direction)) then
			break
		end
	end 
	cells[cy][cx].testvar = "gen'd"
	local canGenCell = CanGenCell(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy, dir)
	if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and canGenCell then
		local p = PushCell(x,y,dir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false)
		if p then
			local ox, oy = cx, cy
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			local pos = walkDivergedPath(ox, oy, cx, cy)
			cx, cy = pos.x, pos.y
			modsOnCellGenerated(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy)
		end
	end
end

function UpdateReplicators()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasreplicator then
				if not cells[y][x].updated and (cells[y][x].ctype == 44 and cells[y][x].rot == 0 or cells[y][x].ctype == 45 and (cells[y][x].rot == 0 or cells[y][x].rot == 1)) then
					DoReplicator(x,y,0,cells[y][x].ctype ~= 45)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasreplicator then
				if not cells[y][x].updated and (cells[y][x].ctype == 44 and cells[y][x].rot == 2 or cells[y][x].ctype == 45 and (cells[y][x].rot == 2 or cells[y][x].rot == 3)) then
					DoReplicator(x,y,2,cells[y][x].ctype ~= 45)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasreplicator then
				if not cells[y][x].updated and (cells[y][x].ctype == 44 and cells[y][x].rot == 3 or cells[y][x].ctype == 45 and (cells[y][x].rot == 3 or cells[y][x].rot == 0)) then
					DoReplicator(x,y,3,true)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasreplicator then
				if not cells[y][x].updated and (cells[y][x].ctype == 44 and cells[y][x].rot == 1 or cells[y][x].ctype == 45 and (cells[y][x].rot == 1 or cells[y][x].rot == 2)) then
					DoReplicator(x,y,1,true)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end

function UpdateMold()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasmold then
				if cells[y][x].ctype == 19 and cells[y][x].updated then
					cells[y][x].ctype = 0
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
end

function UpdateFlippers()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasflipper then
				if not cells[y][x].updated and cells[y][x].ctype == 29 and cells[y][x].rot%2 == 0 then
					for i=-1,1,2 do	--when lazy
						if cells[y][x+i].ctype == 8 then cells[y][x+i].ctype = 9 
						elseif cells[y][x+i].ctype == 9 then cells[y][x+i].ctype = 8 
						elseif cells[y][x+i].ctype == 17 then cells[y][x+i].ctype = 18
						elseif cells[y][x+i].ctype == 18 then cells[y][x+i].ctype = 17 
						elseif cells[y][x+i].ctype == 25 then cells[y][x+i].ctype = 26 cells[y][x+i].rot = (-cells[y][x+i].rot + 2)%4
						elseif cells[y][x+i].ctype == 26 then cells[y][x+i].ctype = 25 cells[y][x+i].rot = (-cells[y][x+i].rot + 2)%4
						elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
						elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
						elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
						elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) and cells[y][x+i].rot%2 == 1 then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
						elseif hasFlipperTranslation(cells[y][x+i].ctype) then cells[y][x+i].ctype = makeFlipperTranslation(cells[y][x+i].ctype) SetChunk(x+i, y, cells[y][x+i].ctype)
						else cells[y][x+i].rot = (-cells[y][x+i].rot + 2)%4 end
					end
					for i=-1,1,2 do
						if cells[y+i][x].ctype == 8 then cells[y+i][x].ctype = 9 
						elseif cells[y+i][x].ctype == 9 then cells[y+i][x].ctype = 8 
						elseif cells[y+i][x].ctype == 17 then cells[y+i][x].ctype = 18
						elseif cells[y+i][x].ctype == 18 then cells[y+i][x].ctype = 17 
						elseif cells[y+i][x].ctype == 25 then cells[y+i][x].ctype = 26 cells[y+i][x].rot = (-cells[y+i][x].rot + 2)%4
						elseif cells[y+i][x].ctype == 26 then cells[y+i][x].ctype = 25 cells[y+i][x].rot = (-cells[y+i][x].rot + 2)%4
						elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
						elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
						elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
						elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
						elseif hasFlipperTranslation(cells[y+i][x].ctype) then cells[y+i][x].ctype = makeFlipperTranslation(cells[y+i][x].ctype) SetChunk(x, y+i, cells[y+i][x].ctype)
						else cells[y+i][x].rot = (-cells[y+i][x].rot + 2)%4 end
					end
				elseif not cells[y][x].updated and cells[y][x].ctype == 29 then
					for i=-1,1,2 do	--when lazy
						if cells[y][x+i].ctype == 8 then cells[y][x+i].ctype = 9 
						elseif cells[y][x+i].ctype == 9 then cells[y][x+i].ctype = 8 
						elseif cells[y][x+i].ctype == 17 then cells[y][x+i].ctype = 18
						elseif cells[y][x+i].ctype == 18 then cells[y][x+i].ctype = 17 
						elseif cells[y][x+i].ctype == 25 then cells[y][x+i].ctype = 26 cells[y][x+i].rot = (-cells[y][x+i].rot - 2)%4
						elseif cells[y][x+i].ctype == 26 then cells[y][x+i].ctype = 25 cells[y][x+i].rot = (-cells[y][x+i].rot - 2)%4
						elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
						elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
						elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
						elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
						elseif hasFlipperTranslation(cells[y][x+i].ctype) then cells[y][x+i].ctype = makeFlipperTranslation(cells[y][x+i].ctype) SetChunk(x+i, y, cells[y][x+i].ctype)
						else cells[y][x+i].rot = (-cells[y][x+i].rot)%4 end
					end
					for i=-1,1,2 do
						if cells[y+i][x].ctype == 8 then cells[y+i][x].ctype = 9 
						elseif cells[y+i][x].ctype == 9 then cells[y+i][x].ctype = 8 
						elseif cells[y+i][x].ctype == 17 then cells[y+i][x].ctype = 18
						elseif cells[y+i][x].ctype == 18 then cells[y+i][x].ctype = 17 
						elseif cells[y+i][x].ctype == 25 then cells[y+i][x].ctype = 26 cells[y+i][x].rot = (-cells[y+i][x].rot)%4
						elseif cells[y+i][x].ctype == 26 then cells[y+i][x].ctype = 25 cells[y+i][x].rot = (-cells[y+i][x].rot)%4
						elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
						elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
						elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
						elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
						elseif hasFlipperTranslation(cells[y+i][x].ctype) then cells[y+i][x].ctype = makeFlipperTranslation(cells[y+i][x].ctype) SetChunk(x, y+i, cells[y+i][x].ctype)
						else cells[y+i][x].rot = (-cells[y+i][x].rot)%4 end
					end
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
end

function UpdateRotators()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasrotator then
				if not cells[y][x].updated and cells[y][x].ctype == 56 then
					if cells[y][x].rot == 0 then
						cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
						cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
						cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
						cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
					elseif cells[y][x].rot == 1 then
						cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
						cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
						cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
						cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
					elseif cells[y][x].rot == 2 then
						cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
						cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
						cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
						cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
					else
						cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
						cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
						cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
						cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
					end
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasrotator then
				if not cells[y][x].updated and cells[y][x].ctype == 8 then
					cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
					cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
					cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
					cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
				elseif not cells[y][x].updated and cells[y][x].ctype == 9 then
					cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
					cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
					cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
					cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
				elseif not cells[y][x].updated and cells[y][x].ctype == 10 then
					cells[y][x-1].rot = (cells[y][x-1].rot - 2)%4
					cells[y][x+1].rot = (cells[y][x+1].rot - 2)%4
					cells[y-1][x].rot = (cells[y-1][x].rot - 2)%4
					cells[y+1][x].rot = (cells[y+1][x].rot - 2)%4
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
end

function UpdateGears()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasgear then
				if not cells[y][x].updated and cells[y][x].ctype == 17 then
					local jammed = false
					for i=0,8 do
						if i ~= 4 then
							cx = i%3-1
							cy = math.floor(i/3)-1
							if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 40 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 or cells[y+cy][x+cx].ctype == 50 then
								jammed = true
							end
							if cells[y+cy][x+cx].ctype > initialCellCount then
								if isModdedTrash(cells[y+cy][x+cx].ctype) or (GetSidedTrash(cells[y+cy][x+cx].ctype) ~= nil and GetSidedTrash(cells[y+cy][x+cx].ctype)(cx, cy, direction) == false) then
									jammed = true
								else
									jammed = not canPushCell(x+cx, y+cy, x, y, "gear")
								end
							end
							if config['gears_restrictions'] ~= 'true' then
								jammed = false
							end
						end
					end
					if not jammed then
						local oldcell
						local storedcell = CopyCell(x-1,y)
						for i=-1,1 do
							oldcell = CopyCell(x+i,y-1)	
							cells[y-1][x+i] = storedcell
							if i == 0 then
								cells[y-1][x+i].rot = (storedcell.rot+1)%4
							end
							storedcell = oldcell
						end
						oldcell = CopyCell(x+1,y)	
						cells[y][x+1] = storedcell
						cells[y][x+1].rot = (storedcell.rot+1)%4
						storedcell = oldcell
						for i=1,-1,-1 do
							oldcell = CopyCell(x+i,y+1)	
							cells[y+1][x+i] = storedcell
							if i == 0 then
								cells[y+1][x+i].rot = (storedcell.rot+1)%4
							end
							storedcell = oldcell
						end
						cells[y][x-1] = storedcell
						cells[y][x-1].rot = (storedcell.rot+1)%4
						SetChunk(x+1,y+1,cells[y+1][x+1].ctype)
						SetChunk(x,y+1,cells[y+1][x].ctype)
						SetChunk(x-1,y+1,cells[y+1][x-1].ctype)
						SetChunk(x+1,y,cells[y][x+1].ctype)
						SetChunk(x+1,y-1,cells[y-1][x+1].ctype)
						SetChunk(x,y-1,cells[y-1][x].ctype)
						SetChunk(x-1,y-1,cells[y-1][x-1].ctype)
						SetChunk(x-1,y,cells[y][x-1].ctype)
					end
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
	x,y = width-1,0
	while y < height do
		while x >= 0 do
			if GetChunk(x,y).hasgear then
				if not cells[y][x].updated and cells[y][x].ctype == 18 then
					local jammed = false
					for i=0,8 do
						if i ~= 4 then
							cx = i%3-1
							cy = math.floor(i/3)-1
							if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 40 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 or cells[y+cy][x+cx].ctype == 50 then
								jammed = true
							end
							if cells[y+cy][x+cx].ctype > initialCellCount then
								if isModdedTrash(cells[y+cy][x+cx].ctype) or (GetSidedTrash(cells[y+cy][x+cx].ctype) ~= nil and GetSidedTrash(cells[y+cy][x+cy].ctype)(x+cx, y+cy, direction) == false) then
									jammed = true
								else
									jammed = not canPushCell(x+cx, y+cy, x, y, "gear")
								end
							end
							if config['gears_restrictions'] ~= 'true' then
								jammed = false
							end
						end
					end
					if not jammed then
						local oldcell
						local storedcell = CopyCell(x+1,y)
						for i=1,-1,-1 do
							oldcell = CopyCell(x+i,y-1)	
							cells[y-1][x+i] = storedcell
							if i == 0 then
								cells[y-1][x+i].rot = (storedcell.rot-1)%4
							end
							storedcell = oldcell
						end
						oldcell = CopyCell(x-1,y)	
						cells[y][x-1] = storedcell
						cells[y][x-1].rot = (storedcell.rot-1)%4
						storedcell = oldcell
						for i=-1,1 do
							oldcell = CopyCell(x+i,y+1)	
							cells[y+1][x+i] = storedcell
							if i == 0 then
								cells[y+1][x+i].rot = (storedcell.rot-1)%4
							end
							storedcell = oldcell
						end
						cells[y][x+1] = storedcell
						cells[y][x+1].rot = (storedcell.rot-1)%4
						SetChunk(x+1,y+1,cells[y+1][x+1].ctype)
						SetChunk(x,y+1,cells[y+1][x].ctype)
						SetChunk(x-1,y+1,cells[y+1][x-1].ctype)
						SetChunk(x+1,y,cells[y][x+1].ctype)
						SetChunk(x+1,y-1,cells[y-1][x+1].ctype)
						SetChunk(x,y-1,cells[y-1][x].ctype)
						SetChunk(x-1,y-1,cells[y-1][x-1].ctype)
						SetChunk(x-1,y,cells[y][x-1].ctype)
					end
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		y = y + 1
		x = width-1
	end
end

function UpdateRedirectors()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasredirector then
				if not cells[y][x].updated and cells[y][x].ctype == 16 then
					if cells[y][x-1].ctype ~= 16 then cells[y][x-1].rot = cells[y][x].rot end
					if cells[y][x+1].ctype ~= 16 then cells[y][x+1].rot = cells[y][x].rot end
					if cells[y-1][x].ctype ~= 16 then cells[y-1][x].rot = cells[y][x].rot end
					if cells[y+1][x].ctype ~= 16 then cells[y+1][x].rot = cells[y][x].rot end
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
end

function UpdateImpulsers()
	local x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasimpulser then
				if not cells[y][x].updated and cells[y][x].ctype == 28 then
					if x > 1 then PullCell(x-2,y,0,false,1) end
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasimpulser then
				if not cells[y][x].updated and cells[y][x].ctype == 28 then
					if x < width-2 then PullCell(x+2,y,2,false,1) end
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasimpulser then
				if not cells[y][x].updated and cells[y][x].ctype == 28 then
					if y < height-2 then PullCell(x,y+2,3,false,1) end
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasimpulser then
				if not cells[y][x].updated and cells[y][x].ctype == 28 then
					if y > 1 then PullCell(x,y-2,1,false,1) end
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
end

function UpdateRepulsers()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasrepulser then
				if not cells[y][x].updated and cells[y][x].ctype == 20 then
					PushCell(x,y,0)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasrepulser then
				if not cells[y][x].updated and cells[y][x].ctype == 20 then
					PushCell(x,y,2)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasrepulser then
				if not cells[y][x].updated and cells[y][x].ctype == 20 then
					PushCell(x,y,3)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasrepulser then
				if not cells[y][x].updated and cells[y][x].ctype == 20 then
					PushCell(x,y,1)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end

function DoSuperRepulser(x,y,dir)
	local cx,cy,direction = x,y,dir
	while true do
		while true do
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
				local olddir = direction
				if (cells[cy][cx].rot+3)%4 == direction then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
			elseif cells[cy][cx].ctype == 30 then
				local olddir = direction
				if (cells[cy][cx].rot+3)%2 == direction%2 then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
			elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38) then
				break
			end
		end 
		local canGenCell = CanGenCell(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy, direction)
		if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 11 and cells[cy][cx].ctype ~= 50 and cells[cy][cx].ctype ~= 12 and cells[cy][cx].ctype ~= 23 and (cells[cy][cx].rot ~= (direction+2)%4 or cells[cy][cx].ctype ~= 43)
		and (cells[cy][cx].ctype ~= 47 and cells[cy][cx].ctype ~= 48 or cells[cy][cx].rot ~= direction) and (cells[cy][cx].ctype < 31 or cells[cy][cx].ctype > 36 or cells[cy][cx].rot%2 == direction%2) and canGenCell then
			cells[cy][cx].scrosses = (cells[cy][cx].supdatekey == supdatekey and cells[cy][cx].scrosses or 0) + 1
			cells[cy][cx].supdatekey = supdatekey
			if cells[cy][cx].scrosses >= 999999999 then
				cells[cy][cx].testvar = "loop"
				break
			end
			if direction == 0 then cx = cx - 1 elseif direction == 2 then cx = cx + 1 end
			if direction == 1 then cy = cy - 1 elseif direction == 3 then cy = cy + 1 end
			if not PushCell(cx,cy,direction,true,999999999999999999) then
				break
			end
			if direction == 0 then cx = cx + 1 elseif direction == 2 then cx = cx - 1 end
			if direction == 1 then cy = cy + 1 elseif direction == 3 then cy = cy - 1 end
		else
			cells[cy][cx].testvar = "break"
			break
		end
	end
end

function UpdateSuperRepulsers()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hassuperrep then
				if not cells[y][x].updated and cells[y][x].ctype == 49 then
					DoSuperRepulser(x,y,0)
					supdatekey = supdatekey + 1
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hassuperrep then
				if not cells[y][x].updated and cells[y][x].ctype == 49 then
					DoSuperRepulser(x,y,2)
					supdatekey = supdatekey + 1
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hassuperrep then
				if not cells[y][x].updated and cells[y][x].ctype == 49 then
					DoSuperRepulser(x,y,3)
					supdatekey = supdatekey + 1
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hassuperrep then
				if not cells[y][x].updated and cells[y][x].ctype == 49 then
					DoSuperRepulser(x,y,1)
					supdatekey = supdatekey + 1
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end

function DoDriller(x,y,dir)
	local x2,y2 = x,y
	if dir == 0 then x2 = x+1 elseif dir == 2 then x2 = x-1 end
	if dir == 1 then y2 = y+1 elseif dir == 3 then y2 = y-1 end
	if cells[y2][x2].ctype ~= 11 and cells[y2][x2].ctype ~= 50 and cells[y2][x2].ctype ~= -1 and cells[y2][x2].ctype ~= 40 and not isModdedTrash(cells[y2][x2].ctype) and not (GetSidedTrash(cells[y2][x2].ctype) ~= nil and GetSidedTrash(cells[y2][x2].ctype)(x2, y2, dir) == true) then
		if cells[y2][x2].ctype > initialCellCount then
			local canPush = canPushCell(x2, y2, x, y, "drill")
			if not canPush then
				return
			end
		end
		local oldcell = CopyCell(x,y)
		cells[y][x] = CopyCell(x2,y2)
		cells[y2][x2] = oldcell
		SetChunk(x,y,cells[y][x].ctype)
		SetChunk(x2,y2,cells[y2][x2].ctype)
	elseif cells[y2][x2].ctype == 11 or cells[y2][x2].ctype == 50 or isModdedTrash(cells[y2][x2].ctype) or (GetSidedTrash(cells[y2][x2].ctype) ~= nil and GetSidedTrash(cells[y2][x2].ctype)(x2, y2, dir) == true) then
		cells[y][x].ctype = 0
		if cells[y2][x2].ctype == 50 then
			if x2 < width-1 and (not cells[y2][x2+1].protected and cells[y2][x2+1].ctype ~= -1 and cells[y2][x2+1].ctype ~= 11 and cells[y2][x2+1].ctype ~= 40 and cells[y2][x2+1].ctype ~= 50) then cells[y2][x2+1].ctype = 0 end
			if x2 > 0 and (not cells[y2][x2-1].protected and cells[y2][x2-1].ctype ~= -1 and cells[y2][x2-1].ctype ~= 11 and cells[y2][x2-1].ctype ~= 40 and cells[y2][x2-1].ctype ~= 50) then cells[y2][x2-1].ctype = 0 end
			if y2 < height-1 and (not cells[y2+1][x2].protected and cells[y2+1][x2].ctype ~= -1 and cells[y2+1][x2].ctype ~= 11 and cells[y2+1][x2].ctype ~= 40 and cells[y2+1][x2].ctype ~= 50) then cells[y2+1][x2].ctype = 0 end
			if y2 > 0 and (not cells[y2-1][x2].protected and cells[y2-1][x2].ctype ~= -1 and cells[y2-1][x2].ctype ~= 11 and cells[y2-1][x2].ctype ~= 40 and cells[y2-1][x2].ctype ~= 50) then cells[y2-1][x2].ctype = 0 end
		end
		if isModdedTrash(cells[y2][x2].ctype) or (GetSidedTrash(cells[y2][x2].ctype) ~= nil and GetSidedTrash(cells[y2][x2].ctype)(x2, y2, dir) == true) then
			modsOnTrashEat(cells[y2][x2].ctype, x2, y2, cells[y][x], x, y)
		end
		love.audio.play(destroysound)
	end
end

function UpdateDrillers()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasdriller then
				if not cells[y][x].updated and cells[y][x].ctype == 57 and cells[y][x].rot == 0 then
					DoDriller(x,y,0)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasdriller then
				if not cells[y][x].updated and cells[y][x].ctype == 57 and cells[y][x].rot == 2 then
					DoDriller(x,y,2)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasdriller then
				if not cells[y][x].updated and cells[y][x].ctype == 57 and cells[y][x].rot == 3 then
					DoDriller(x,y,3)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasdriller then
				if not cells[y][x].updated and cells[y][x].ctype == 57 and cells[y][x].rot == 1 then
					DoDriller(x,y,1)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end

function DoAdvancer(x,y,dir)
	cells[y][x].updated = true
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	if PushCell(cx,cy,dir,true,0) and cells[y][x].ctype == 0 then	--this is why i made pushcell return whether movement was a success or not
		PullCell(x,y,dir,true,1,true,true,true)
	end
end

function UpdateAdvancers()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasadvancer then
				if not cells[y][x].updated and cells[y][x].ctype == 27 and cells[y][x].rot == 0 then
					DoAdvancer(x,y,0)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasadvancer then
				if not cells[y][x].updated and cells[y][x].ctype == 27 and cells[y][x].rot == 2 then
					DoAdvancer(x,y,2)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasadvancer then
				if not cells[y][x].updated and cells[y][x].ctype == 27 and cells[y][x].rot == 3 then
					DoAdvancer(x,y,3)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasadvancer then
				if not cells[y][x].updated and cells[y][x].ctype == 27 and cells[y][x].rot == 1 then
					DoAdvancer(x,y,1)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end

function UpdatePullers()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).haspuller then
				if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 0 then
					cells[y][x].updated = true
					PullCell(x,y,0)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).haspuller then
				if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 2 then
					cells[y][x].updated = true
					PullCell(x,y,2)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).haspuller then
				if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 3 then
					cells[y][x].updated = true
					PullCell(x,y,3)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).haspuller then
				if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 1 then
					cells[y][x].updated = true
					PullCell(x,y,1)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end

function DoMover(x,y,dir)
	cells[y][x].updated = true
	local cx
	local cy
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	PushCell(cx,cy,dir,true,0)	--it'll come across itself as it moves and get 1 totalforce
end

function UpdateMovers()
	local x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 0 then
					DoMover(x,y,0)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 2 then
					DoMover(x,y,2)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 3 then
					DoMover(x,y,3)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 1 then
					DoMover(x,y,1)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
end

function DoGate(x,y,dir,gtype)
	if (gtype == 1 and (cells[y][x].inl or cells[y][x].inr)) or													--or
	(gtype == 2 and cells[y][x].inl and cells[y][x].inr) or														--and
	(gtype == 3 and (cells[y][x].inl or cells[y][x].inr) and not (cells[y][x].inl and cells[y][x].inr)) or		--xor
	(gtype == 4 and not (cells[y][x].inl or cells[y][x].inr)) or												--nor
	(gtype == 5 and not (cells[y][x].inl and cells[y][x].inr)) or												--nand
	(gtype == 6 and not ((cells[y][x].inl or cells[y][x].inr) and not (cells[y][x].inl and cells[y][x].inr))) then	--xnor
		local direction = (dir+2)%4
		local cx = x
		local cy = y
		local addedrot = 0
		while true do							--what cell to copy?
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
				local olddir = direction
				if (cells[cy][cx].rot+3)%4 == direction then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
				addedrot = addedrot - (direction-olddir)
			elseif cells[cy][cx].ctype == 30 then
				local olddir = direction
				if (cells[cy][cx].rot+3)%2 == direction%2 then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
				addedrot = addedrot - (direction-olddir)
			elseif (cells[cy][cx].ctype == 47 or cells[cy][cx].ctype == 48) and (cells[cy][cx].rot+2)%2 ~= direction%2 then
				local olddir = direction
				if (cells[cy][cx].rot+1)%4 == direction then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
				addedrot = addedrot - (direction-olddir)
			elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38 or (cells[cy][cx].ctype == 48 and (cells[cy][cx].rot+2)%4 == direction)) then
				break
			end
		end 
		cells[cy][cx].testvar = "gen'd"
		if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 then
			PushCell(x,y,dir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype >= 31 and cells[cy][cx].ctype <= 36,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected)
		end
	end
	cells[y][x].testvar = (cells[y][x].inl and 1 or 0).. " " ..(cells[y][x].inr and 1 or 0)
end

function UpdateGates()
	local x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasgate then
				if not cells[y][x].updated and (cells[y][x].ctype >= 31 and cells[y][x].ctype <= 36) and cells[y][x].rot == 0 then
					DoGate(x,y,0,cells[y][x].ctype-30)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasgate then
				if not cells[y][x].updated and (cells[y][x].ctype >= 31 and cells[y][x].ctype <= 36) and cells[y][x].rot == 2 then
					DoGate(x,y,2,cells[y][x].ctype-30)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasgate then
				if not cells[y][x].updated and (cells[y][x].ctype >= 31 and cells[y][x].ctype <= 36) and cells[y][x].rot == 3 then
					DoGate(x,y,3,cells[y][x].ctype-30)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasgate then
				if not cells[y][x].updated and (cells[y][x].ctype >= 31 and cells[y][x].ctype <= 36) and cells[y][x].rot == 1 then
					DoGate(x,y,1,cells[y][x].ctype-30)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
end