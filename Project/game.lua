-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)

local difficulty = 6


function init()
    Build()
end


function Build()
	tsize=25
	xinicial=5
	yinicial=40
	tiles={}
	grid={}
	texts={}
	tapped={}
	for x=1,difficulty+3 do
		tiles[x]={}
		tapped[x]={}
		grid[x]={}
		texts[x]={}
		for y=1,difficulty+3 do
		
			local curtile=display.newRect(10,10,tsize,tsize)
			curtile.x=xinicial+((x-1)*(tsize+1))
			curtile.y=yinicial+((y-1)*(tsize+1))
			
			local curtext=display.newText(0,0,0,native.systemFont,20)
			curtext.x=curtile.x
			curtext.y=curtile.y
			curtext:setFillColor(0,0,0)
			
			if x<4 and y<4 then
				display.remove(curtile)
				curtile=nil
				display.remove(curtext)
				curtext=nil
			end
			
			if y>3 then
				curtile.y=curtile.y+2
			end
			
			if x>3 then
				curtile.x=curtile.x+2
			end
			
			tiles[x][y]=curtile
			
			if y>3 and x>3 then
				display.remove(curtext)
				curtext=nil
				
				function Wrapper()
					Action(x,y)
				end
				
				tiles[x][y]:addEventListener("tap",Wrapper)
			end
			
			texts[x][y]=curtext
			
		end
	end
	New()
end

function New()
	for x=1,difficulty+3 do 
		for y=1,difficulty+3 do
			grid[x][y]=0
			if (texts[x][y]) then
				if (texts[x][y].text) then
					texts[x][y].text="0"
				end
			end
		end
	end
	
	for x=4,difficulty+3 do
		for y=4,difficulty+3 do
			grid[x][y]=math.random(0,1)
			tiles[x][y]:setFillColor(1,1,1)
			-- if grid[x][y]==1 then
				tapped[x][y]=false
				-- tiles[x][y]:setFillColor(0.5,0.5,0.5)
			-- else
				-- tapped[x][y]=true
			-- end
		end
	end
	
	local changed=true
	while changed==true do
		print "CHECK!"
		changed=false
		
		for y=4,difficulty+3 do
			local xcount=0
			for x=4,difficulty+3 do
				if grid[x][y]==1 and grid[x-1][y]==0 and xcount<3 then
					xcount=xcount+1
				elseif grid[x][y]==1 and grid[x-1][y]==0 then
					grid[x][y]=0
					tiles[x][y]:setFillColor(1,1,1)
					print "DELETED!"
					changed=true
				end
			end
			print ("Y-"..y-3 .."  count-"..xcount)
		end
		print "--"
		for x=4,difficulty+3 do
			local ycount=0
			for y=4,difficulty+3 do
				if grid[x][y]==1 and grid[x][y-1]==0 and ycount<3 then
					ycount=ycount+1
				elseif grid[x][y]==1 and grid[x][y-1]==0 then
					grid[x][y]=0
					tiles[x][y]:setFillColor(1,1,1)
					print "DELETED!"
					changed=true
				end
			end
			print ("X-"..x-3 .."  count-"..ycount)
		end
	end

	-- print "CHECK!"
	-- changed=false
	
	for y=4,difficulty+3 do
		local group=0
		for x=difficulty+3,3,-1 do
			if grid[x][y]==1 then
				group=group+1
			else
				local set=false
				local cont=3
				while (set==false and cont>0) do
					
					if (texts[cont][y].text=="0") then
						texts[cont][y].text=group
						set=true
					else
						cont=cont-1
					end
				end
				group=0
			end
		end
		-- print ("Y-"..y-3 .."  count-"..xcount)
	end
	-- print "--"
	for x=4,difficulty+3 do
		local group=0
		for y=difficulty+3,3,-1 do
			if grid[x][y]==1 then
				group=group+1
			else
				local set=false
				local cont=3
				while (set==false and cont>0) do
					if (texts[x][cont].text=="0") then
						texts[x][cont].text=group
						set=true
					else
						cont=cont-1
					end
				end
				group=0
			end
		end
		-- print ("X-"..x-3 .."  count-"..ycount)
	end

	for x=1,difficulty+3 do
		for y=1,difficulty+3 do
			if (texts[x][y]) then
				if (texts[x][y].text=="0") then
					texts[x][y].isVisible=false
				else
					texts[x][y].isVisible=true
				end
			end
		end
	end
	
	for y=4,difficulty+3 do
		local xdone=true
		for x=4,difficulty+3 do
			if (tapped[x][y]==false and grid[x][y]==1) then
				xdone=false
			end
		end
		if xdone==true then
			for x=4,difficulty+3 do
				if (tapped[x][y]==false) then
					tiles[x][y]:setFillColor(0.2,0.2,0.8)
				end
			end
		end
	end
	
	for x=4,difficulty+3 do
		local ydone=true
		for y=4,difficulty+3 do
			if (tapped[x][y]==false and grid[x][y]==1) then
				ydone=false
			end
		end
		if ydone==true then
			for y=4,difficulty+3 do
				if (tapped[x][y]==false) then
					tiles[x][y]:setFillColor(0.2,0.2,0.8)
				end
			end
		end
	end 
end

function Action(x,y)
	if tapped[x][y]==false then
		-- print (x..","..y)
		if grid[x][y]==1 then
			tapped[x][y]=true
			tiles[x][y]:setFillColor(0.2,0.8,0.2)
		elseif grid[x][y]==0 then
			tapped[x][y]=true
			tiles[x][y]:setFillColor(0.8,0.2,0.2)
		end
		
		local xdone=true
		for ax=4,difficulty+3 do
			if (tapped[ax][y]==false and grid[ax][y]==1) then
				xdone=false
			end
		end
		if xdone==true then
			for ax=4,difficulty+3 do
				if (tapped[ax][y]==false) then
					tapped[ax][y]=true
					tiles[ax][y]:setFillColor(0.2,0.2,0.8)
				end
			end
		end
		
		local ydone=true
		for ay=4,difficulty+3 do
			if (tapped[x][ay]==false and grid[x][ay]==1) then
				ydone=false
			end
		end
		if ydone==true then
			for ay=4,difficulty+3 do
				if (tapped[x][ay]==false) then
					tapped[x][ay]=true
					tiles[x][ay]:setFillColor(0.2,0.2,0.8)
				end
			end
		end
		
		Check()
	end
end

function Check()
	local finish=true
	for x=4,difficulty+3 do
		for y=4,difficulty+3 do
			if tapped[x][y]==false and grid[x][y]==1 then
				finish=false
			end
		end
	end
	if finish==true then
		-- print "DONE"
		timer.performWithDelay(5000,New)
	end
end

