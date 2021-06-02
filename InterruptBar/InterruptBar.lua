--[[--------------------------------------------------
-- InterruptBar by Frost - Took over this project because of inactivitie for 1 month +
-- InterruptBar by Robrman, Edited by Frost-Xavius | Carlos | Frostanon & Inspired by Kollektiv's InterruptBar
-- Renamed to InterruptBar due alot of request adding this back on curse.
-- Version 1.0


CHANGELOG:

-- Toc push for 7.3
-- InterruptBar took over new version = 1.0

----------------------------------------------------]]
InterruptBarRealm = GetRealmName() --Thanks Jitter88
InterruptBarChar = UnitName("player");
CharIndex=InterruptBarChar.." - "..InterruptBarRealm
InterruptBarDB=InterruptBarDB or {}
InterruptBarDB["CharsUse"]=InterruptBarDB["CharsUse"] or {}
InterruptBarDB["Default"]= InterruptBarDB["Default"] or { scale = 1,scale2=1 , hidden = false,hidden2=false, smart=false, smartPrio=false,prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,growUp=1,growLeft=1, noCD=false,prioOnly=false,}
InterruptBarDB[CharIndex] = InterruptBarDB[CharIndex] or InterruptBarDB["Default"]--{ scale = 1,scale2=1 , hidden = false,hidden2=false, smart=false, smartPrio=false,prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,growUp=1,growLeft=1, noCD=false,prioOnly=false,}
for k,v in pairs(InterruptBarDB) do
	if not (type(InterruptBarDB[k]) == "table" ) then 
		InterruptBarDB[k]=nil
	elseif (k=="Position" and (InterruptBarDB["Position"]["scale2"]==nil)) then 
		InterruptBarDB[k]=nil
	end
end
if (InterruptBarDB["CharsUse"][CharIndex]) then
	CharIndex=InterruptBarDB["CharsUse"][CharIndex]
else
	InterruptBarDB["CharsUse"][CharIndex]=CharIndex
end

local abilities = {}
local order
local arena=false
local bg=false
local band = bit.band
local spell_table=spell_table
local InterruptBar_UpdateText

if spell_table==nil then ChatFrame1:AddMessage("NOT LOADED",0,1,0) end
for k,spell in ipairs(spell_table) do
	local name,_,spellicon = GetSpellInfo(spell.spellID)	
	abilities[spell.spellID] = { icon = spellicon, duration = spell.time }
end

local frame
local bar
local bar2
local x = 15+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
local x2 = 15+((InterruptBarDB[CharIndex].colsPrio/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].colsPrio/2-1)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
local y2 = 0
local count2 = 0
local count=0
local y=0
local totalIcons=0
local GetTime = GetTime
local ipairs = ipairs
local pairs = pairs
local select = select
local floor = floor
local band = bit.band
local GetSpellInfo = GetSpellInfo
local GROUP_UNITS = bit.bor(0x00000010, 0x00000400)
local activetimers = {}
local size = 0
local survival=false

local function getsize()
	size = 0
	for k in pairs(activetimers) do
		size = size + 1
	end
end

local function isInBG()
	local a,type = IsInInstance()
	if (type == "pvp") then
		return true
	end
	return false
end

local function isInArena()
	local _,type = IsInInstance()
	if (type == "arena") then
		return true
	end
	return false
	
end
local function isPrio(ability)
	for _,v in ipairs(spell_table) do
		if v.spellID==ability then--find ability in table
			return v.prio--return prio status for ability
		end
	end
	return false
end

local function getTotalPrio(from)
	local ret=0
	if InterruptBarDB[CharIndex].prio or from then
		for _,v in ipairs(spell_table) do
			if v.prio then
				ret=ret+1
			end
		end
	end
	return ret
end

local function getTotalMain()
	local ret=0
	if InterruptBarDB[CharIndex].prio then
		for _,v in ipairs(spell_table) do
			if not v.prio then
				ret=ret+1
			end
		end
		return ret
	end
	return #(spell_table)
end

local function InterruptBar_AddIcons()

	for _,ability in ipairs(spell_table) do--for all spells in spell table
		local btn = CreateFrame("Frame",nil,bar)
		btn:SetWidth(30)--create the frame and set the dimensions
		btn:SetHeight(30)
		
		if InterruptBarDB[CharIndex].prio and isPrio(ability.spellID) then
			btn:SetPoint("CENTER",bar,"CENTER",x2,y2)
		else
			btn:SetPoint("CENTER",bar,"CENTER",x,y)
		end
			
		btn:SetFrameStrata("LOW")
		local cd = CreateFrame("Cooldown",nil,btn)
		cd.noomnicc = not InterruptBarDB[CharIndex].noCD
		cd.noOCC = not InterruptBarDB[CharIndex].noCD
		cd.noCooldownCount = not InterruptBarDB[CharIndex].noCD
		
		cd:SetAllPoints(btn)
		cd:SetParent(btn)
		cd:SetFrameStrata("LOW")
		cd:Hide()
		
		local texture = btn:CreateTexture(nil,"BACKGROUND")
		texture:SetAllPoints(true)
		texture:SetTexture(abilities[ability.spellID].icon)
		texture:SetTexCoord(0.07,0.9,0.07,0.90)
	
		local text = cd:CreateFontString(nil,"ARTWORK")
		text:SetFont(STANDARD_TEXT_FONT,18,"OUTLINE")
		text:SetTextColor(1,1,0,1)
		text:SetPoint("LEFT",btn,"LEFT",1,0)
		
		btn.texture = texture
		btn.text = text
		btn.duration = abilities[ability.spellID].duration
		btn.cd = cd
		
		if InterruptBarDB[CharIndex].prio and isPrio(ability.spellID) then
			bar2[ability.spellID] = btn
			if (InterruptBarDB[CharIndex].prioOnly and not isPrio(ability.spellID)) then bar2[ability.spellID]:Hide() end
			x2 = x2 + 30 * InterruptBarDB[CharIndex].growLeft
			count2 = count2 + 1
			totalIcons = totalIcons + 1
			if count2 >= InterruptBarDB[CharIndex].colsPrio and InterruptBarDB[CharIndex].colsPrio > 0 then
				y2 = y2 - 30 * InterruptBarDB[CharIndex].growUp
				x2 = 15+((InterruptBarDB[CharIndex].colsPrio/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].colsPrio/2-1)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
				count2=0
			end
		else
			bar[ability.spellID] = btn
			if (InterruptBarDB[CharIndex].prioOnly and not isPrio(ability.spellID)) then bar[ability.spellID]:Hide() end
			x = x + 30 * InterruptBarDB[CharIndex].growLeft
			count = count + 1
			totalIcons = totalIcons + 1
			if count >= InterruptBarDB[CharIndex].cols and InterruptBarDB[CharIndex].cols > 0 then
				y = y - 30 * InterruptBarDB[CharIndex].growUp
				x = 15+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
				count=0
			end
		end
	end
	x = 15+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
	count=0
	y=0
	active=0
	x2 = 15+((InterruptBarDB[CharIndex].colsPrio/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].colsPrio/2-1)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
	count2=0
	y2=0
end

local function InterruptBar_AddIcon(ability)
	if (InterruptBarDB[CharIndex].prioOnly and not isPrio(ability)) then return end
	if InterruptBarDB[CharIndex].prio and isPrio(ability) then
		if not bar2[ability]:IsVisible() then
			bar2[ability]:SetPoint("CENTER",bar2,x2,y2)
			bar2[ability]:Show()
			bar2[ability].text:SetParent(bar2[ability])
			bar2[ability].cd:SetParent(bar2[ability])
			x2 = x2 + 30 * InterruptBarDB[CharIndex].growLeft
			count2 = count2 + 1
			if count2 >= InterruptBarDB[CharIndex].colsPrio and InterruptBarDB[CharIndex].colsPrio > 0 then
				y2 = y2 - 30 * InterruptBarDB[CharIndex].growUp
				x2 = 15+((InterruptBarDB[CharIndex].colsPrio/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].colsPrio/2-1)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
				count2=0
			end
		end
	else
		if not bar[ability]:IsVisible() then
			bar[ability]:SetPoint("CENTER",bar,x,y)
			bar[ability]:Show()
			bar[ability].text:SetParent(bar[ability])
			x = x + 30 * InterruptBarDB[CharIndex].growLeft
			count = count + 1
			if count >= InterruptBarDB[CharIndex].cols and InterruptBarDB[CharIndex].cols > 0 then
				y = y - 30 * InterruptBarDB[CharIndex].growUp
				x = 15+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
				count=0
			end
		end
	end
	local main=getTotalMain()
	if InterruptBarDB[CharIndex].cols == 0 then
		bar:SetWidth(30*main)
	else
		bar:SetWidth(30*InterruptBarDB[CharIndex].cols)
	end
	local numprio=getTotalPrio()
	if InterruptBarDB[CharIndex].prio then
		if InterruptBarDB[CharIndex].colsPrio == 0 then
			bar2:SetWidth(30*numprio)
		else
			bar2:SetWidth(30*InterruptBarDB[CharIndex].colsPrio)
		end
	end
end


local function InterruptBar_SavePosition()
	local point, _, relativePoint, xOfs, yOfs = bar:GetPoint()
	if not InterruptBarDB[CharIndex].Position then 
		InterruptBarDB[CharIndex].Position = {}
	end
	--first bar
	InterruptBarDB[CharIndex].Position.point = point
	InterruptBarDB[CharIndex].Position.relativePoint = relativePoint
	InterruptBarDB[CharIndex].Position.xOfs = xOfs
	InterruptBarDB[CharIndex].Position.yOfs = yOfs
	--second bar
	local point, _, relativePoint, xOfs, yOfs = bar2:GetPoint()
	InterruptBarDB[CharIndex].Position.point2 = point
	InterruptBarDB[CharIndex].Position.relativePoint2 = relativePoint
	InterruptBarDB[CharIndex].Position.xOfs2 = xOfs
	InterruptBarDB[CharIndex].Position.yOfs2 = yOfs
end

local function InterruptBar_LoadPosition()
	if InterruptBarDB[CharIndex].Position then
		bar:SetPoint(InterruptBarDB[CharIndex].Position.point,UIParent,InterruptBarDB[CharIndex].Position.relativePoint,InterruptBarDB[CharIndex].Position.xOfs,InterruptBarDB[CharIndex].Position.yOfs)
			if  InterruptBarDB[CharIndex].Position.point2 then
				bar2:SetPoint(InterruptBarDB[CharIndex].Position.point2,UIParent,InterruptBarDB[CharIndex].Position.relativePoint2,InterruptBarDB[CharIndex].Position.xOfs2,InterruptBarDB[CharIndex].Position.yOfs2)
			else
				bar2:SetPoint("CENTER", UIParent, "CENTER")
			end
	else
		bar:SetPoint("CENTER", UIParent, "CENTER")
		bar2:SetPoint("CENTER", UIParent, "CENTER")
	end
end

local function InterruptBar_Repos()
	if (InterruptBarDB[CharIndex].bgOnly and not bg and InterruptBarDB[CharIndex].arenaOnly and not arena) or (not InterruptBarDB[CharIndex].bgOnly and InterruptBarDB[CharIndex].arenaOnly and not arena) or (not InterruptBarDB[CharIndex].arenaOnly and InterruptBarDB[CharIndex].bgOnly and not bg) then return end
	if not InterruptBarDB[CharIndex].smart then
		x = 15+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
		count=0
		y=0
		for _,v in ipairs(spell_table) do
			if not (InterruptBarDB[CharIndex].prio and isPrio(v.spellID)) then
				bar[v.spellID]:Hide()
				InterruptBar_AddIcon(v.spellID)
				if InterruptBarDB[CharIndex].hidden and not activetimers[v.spellID] then
					bar[v.spellID]:Hide()
				end
			end
		end
	else 
		if InterruptBarDB[CharIndex].hidden then
			x = 15+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
			count=0
			y=0
		end
		for _,v in ipairs(spell_table) do
			if not(isPrio(v.spellID) and InterruptBarDB[CharIndex].prio) then
				bar[v.spellID]:Hide()
				if activetimers[v.spellID] then
					InterruptBar_AddIcon(v.spellID)
				else 
					if InterruptBarDB[CharIndex].hidden then
						bar[v.spellID]:Hide()
					end
				end
			end
		end
	end
	if InterruptBarDB[CharIndex].prio then
		if not InterruptBarDB[CharIndex].smartPrio then
			x2 = 15+((InterruptBarDB[CharIndex].colsPrio/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].colsPrio/2-1)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
			count2 = 0
			y2 = 0
			for _,v in ipairs(spell_table) do
				if InterruptBarDB[CharIndex].prio and isPrio(v.spellID) then
					--bar2[v.spellID]:Hide()
					InterruptBar_AddIcon(v.spellID)
					if InterruptBarDB[CharIndex].hidden2 and not activetimers[v.spellID] then
						bar2[v.spellID]:Hide()
					end
				end
			end
		else
			if InterruptBarDB[CharIndex].hidden2 then
				x2 = 15+((InterruptBarDB[CharIndex].colsPrio/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].colsPrio/2-1)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
				count2 = 0
				y2 = 0
			end
			for _,v in ipairs(spell_table) do
				if InterruptBarDB[CharIndex].prio and isPrio(v.spellID) and InterruptBarDB[CharIndex].hidden2 then
					bar2[v.spellID]:Hide()
					if activetimers[v.spellID] then
						InterruptBar_AddIcon(v.spellID)
					else
						if InterruptBarDB[CharIndex].hidden2 then
							bar2[v.spellID]:Hide()
						end
					end
				end
			end
		end
	end
end

local function InterruptBar_UpdateBar()
	bar:SetScale(InterruptBarDB[CharIndex].scale)
	bar2:SetScale(InterruptBarDB[CharIndex].scale2)
	
	local main=getTotalMain()
	local numprio=getTotalPrio()
	if InterruptBarDB[CharIndex].cols == 0 then
		bar:SetWidth(30*main)
	else
		bar:SetWidth(30*InterruptBarDB[CharIndex].cols)
	end
	if InterruptBarDB[CharIndex].prio then
		if InterruptBarDB[CharIndex].colsPrio == 0 then
			bar2:SetWidth(30*numprio)
		else
			bar2:SetWidth(30*InterruptBarDB[CharIndex].colsPrio)
		end
		bar2:Show()
	end
	if not InterruptBarDB[CharIndex].prio then--if prio was disabled
		for _,v in ipairs(spell_table) do 
			if isPrio(v.spellID) and bar2[v.spellID] then--if spell is prio and on currently on bar2
				bar[v.spellID]=bar2[v.spellID] --move the spell back to bar1
			end
		end
		bar2:Hide()--hide bar2
	elseif InterruptBarDB[CharIndex].prio and table.getn(bar2) == 0 then--if prio is on and bar2 is empty
		for _,v in ipairs(spell_table) do
			if InterruptBarDB[CharIndex].prio and isPrio(v.spellID) then--if spell is prio and prio is on
				if bar[v.spellID] and not bar2[v.spellID] then
					bar2[v.spellID]=bar[v.spellID]--put spell on bar2
				end
			end
		end
	end
	--if bgonly mode is on, and not in a bg, or arenaonly and not in arena, or bgonly and arenaonly modes and not in bg or arena
	if (InterruptBarDB[CharIndex].bgOnly and not bg and InterruptBarDB[CharIndex].arenaOnly and not arena) or (not InterruptBarDB[CharIndex].bgOnly and InterruptBarDB[CharIndex].arenaOnly and not arena) or (not InterruptBarDB[CharIndex].arenaOnly and InterruptBarDB[CharIndex].bgOnly and not bg) then 
		for _,v in ipairs(spell_table) do
			if InterruptBarDB[CharIndex].prio and isPrio(v.spellID) then
				bar2[v.spellID]:Hide()--hide spells on prio and main bar
			else
				bar[v.spellID]:Hide()
			end
		end
		return
	end
	if InterruptBarDB[CharIndex].hidden or InterruptBarDB[CharIndex].hidden2 or InterruptBarDB[CharIndex].smart or InterruptBarDB[CharIndex].smartPrio then
		if InterruptBarDB[CharIndex].smart or InterruptBarDB[CharIndex].smartPrio then
			x = 15+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].cols/2)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
			count=0
			y=0
			x2 = 15+((InterruptBarDB[CharIndex].colsPrio/2)*-30*((InterruptBarDB[CharIndex].growLeft+1)/2))+((InterruptBarDB[CharIndex].colsPrio/2-1)*-30*((InterruptBarDB[CharIndex].growLeft-1)/2))
			y2 = 0
			count2 = 0
		end
		for _,v in ipairs(spell_table) do
			if InterruptBarDB[CharIndex].prio and isPrio(v.spellID) then
				if InterruptBarDB[CharIndex].hidden2 or InterruptBarDB[CharIndex].smartPrio then
					bar2[v.spellID]:Hide()--hide spells on bar2
				else
					bar2[v.spellID]:Show()
				end
				bar2[v.spellID].cd.noomnicc = not InterruptBarDB[CharIndex].noCD
				bar2[v.spellID].cd.noOCC = not InterruptBarDB[CharIndex].noCD--set correct flags to enable/disable omniCC 
				bar2[v.spellID].cd.noCooldownCount = not InterruptBarDB[CharIndex].noCD
				bar2[v.spellID]:SetParent(bar2)
				bar2[v.spellID].cd:SetParent(bar2)
			else	
				if InterruptBarDB[CharIndex].hidden or InterruptBarDB[CharIndex].smart then
					bar[v.spellID]:Hide()--hide spells on main bar
				else
					bar[v.spellID]:Show()
				end
				bar[v.spellID].cd.noomnicc = not InterruptBarDB[CharIndex].noCD
				bar[v.spellID].cd.noOCC = not InterruptBarDB[CharIndex].noCD--set correct flags to enable/disable omniCC 
				bar[v.spellID].cd.noCooldownCount = not InterruptBarDB[CharIndex].noCD
				bar[v.spellID]:SetParent(bar)
			end
		end
	else--if not hidden or smart
		for _,v in ipairs(spell_table) do
			if InterruptBarDB[CharIndex].prio and isPrio(v.spellID) then
				bar2[v.spellID]:Show() --show spell
				bar2[v.spellID].cd.noomnicc = not InterruptBarDB[CharIndex].noCD
				bar2[v.spellID].cd.noOCC = not InterruptBarDB[CharIndex].noCD--set correct flags to enable/disable omniCC 
				bar2[v.spellID].cd.noCooldownCount = not InterruptBarDB[CharIndex].noCD
				bar2[v.spellID]:SetParent(bar2)
			else
				bar[v.spellID]:Show() 
				bar[v.spellID].cd.noomnicc = not InterruptBarDB[CharIndex].noCD
				bar[v.spellID].cd.noOCC = not InterruptBarDB[CharIndex].noCD
				bar[v.spellID].cd.noCooldownCount = not InterruptBarDB[CharIndex].noCD
				bar[v.spellID]:SetParent(bar)
			end
		end
	end
	if InterruptBarDB[CharIndex].prioOnly then--if prio only
		for _,v in ipairs(spell_table) do
			if not isPrio(v.spellID) then--hide non-prio spells
				bar[v.spellID]:Hide()
			end
		end
	end
	if InterruptBarDB[CharIndex].lock then--if bar is locked, disable mouse
		bar:EnableMouse(false)
	else--else, enable mouse
		bar:EnableMouse(true)
	end
	if InterruptBarDB[CharIndex].lockPrio then
		bar2:EnableMouse(false)
	else
		bar2:EnableMouse(true)
	end
end

local function InterruptBar_CreateBar()
	bar = CreateFrame("Frame", "InterruptBarMainBar", UIParent)
	bar:SetMovable(true)
	bar:SetWidth(120)
	bar:SetHeight(30)
	bar:SetClampedToScreen(true) 
	bar:SetScript("OnMouseDown",function(self,button) if button == "LeftButton" then self:StartMoving() end end)
	bar:SetScript("OnMouseUp",function(self,button) if button == "LeftButton" then self:StopMovingOrSizing() InterruptBar_SavePosition() end end)
	bar:Show()

	bar2 = CreateFrame("Frame", "InterruptBarPrioBar", UIParent)
	bar2:SetMovable(true)
	bar2:SetWidth(120)
	bar2:SetHeight(30)
	bar2:SetClampedToScreen(true) 
	bar2:SetScript("OnMouseDown",function(self,button) if button == "LeftButton" then self:StartMoving() end end)
	bar2:SetScript("OnMouseUp",function(self,button) if button == "LeftButton" then self:StopMovingOrSizing() InterruptBar_SavePosition() end end)
	bar2:Show()
	
	InterruptBar_AddIcons()
	InterruptBar_UpdateBar()
	InterruptBar_LoadPosition()
end

 function InterruptBar_UpdateText(text,cooldown)
	if  InterruptBarDB[CharIndex].noCD then return end
	if cooldown < 100 then 
		if cooldown <= 0.5 then
			text:SetText("")
		elseif cooldown < 10 then
			text:SetFormattedText(" %d",cooldown)
		else
			text:SetFormattedText("%d",cooldown)
		end
	else
		local m=floor((cooldown+30)/60)
		text:SetFormattedText("%dm",m)
	end
	if cooldown < 6 then 
		text:SetTextColor(1,0,0,1)
	else 
		text:SetTextColor(1,1,0,1) 
	end
end

local function InterruptBar_StopAbility(ref,ability)
	if (InterruptBarDB[CharIndex].hidden2 and isPrio(ability)) or (InterruptBarDB[CharIndex].hidden and not isPrio(ability)) then
		if ref then
			ref:Hide()
		else
			if isPrio(ability) and InterruptBarDB[CharIndex].prio then
				ref=bar2[ability]
			else
				ref=bar[ability]	
			end
		end
	end
	if activetimers[ability] then activetimers[ability] = nil end
	if ref then
		ref.text:SetText("")
		ref.cd:Hide()
	end
	if (InterruptBarDB[CharIndex].hidden or InterruptBarDB[CharIndex].hidden2) and (InterruptBarDB[CharIndex].smart or InterruptBarDB[CharIndex].smartPrio) then InterruptBar_Repos() end
end

local time = 0
local function InterruptBar_OnUpdate(self, elapsed)
	time = time + elapsed
	if time > 0.25 then
		getsize()
		for ability,ref in pairs(activetimers) do
			ref.cooldown = ref.start + ref.duration - GetTime()
			if ref.cooldown <= 0 then
				InterruptBar_StopAbility(ref,ability)
			else 
				InterruptBar_UpdateText(ref.text,floor(ref.cooldown+0.5))
			end
		end
		if size == 0 then frame:SetScript("OnUpdate",nil) end
		time = time - 0.25
	end
end

local function InterruptBar_StartTimer(ref,ability)
	if (InterruptBarDB[CharIndex].bgOnly and not bg and InterruptBarDB[CharIndex].arenaOnly and not arena) or (not InterruptBarDB[CharIndex].bgOnly and InterruptBarDB[CharIndex].arenaOnly and not arena) or (not InterruptBarDB[CharIndex].arenaOnly and InterruptBarDB[CharIndex].bgOnly and not bg) then return end
	if InterruptBarDB[CharIndex].hidden or InterruptBarDB[CharIndex].hidden2 or InterruptBarDB[CharIndex].smart or InterruptBarDB[CharIndex].smartPrio then
		ref:Show()
	end
	local duration
	activetimers[ability] = ref
	ref.cd:Show()
	ref.cd:SetCooldown(GetTime()-0.40,ref.duration)
	ref.start = GetTime()
	InterruptBar_UpdateText(ref.text,ref.duration)
	frame:SetScript("OnUpdate",InterruptBar_OnUpdate)
end
local function InterruptBar_ARENA_PREP_OPPONENT_SPECIALIZATIONS(...)
	local numOpps = GetNumArenaOpponentSpecs()
	for i = 1, numOpps do
		local specID = GetArenaOpponentSpec(i)
		if specID > 0 then
			local _, spec, _, _, _, _, class = GetSpecializationInfoByID(specID)
			if spec == "Survival" then
				survival=true
			end
		end
	end
end


local function InterruptBar_COMBAT_LOG_EVENT_UNFILTERED(...)
	local spellID, ability, useSecondDuration
	return function(_, eventtype, _,_, srcName, srcFlags, _,_, dstName, dstFlags,_, id)
		if (band(srcFlags, 0x00000040) == 0x00000040 and (eventtype == "SPELL_CAST_SUCCESS" or eventtype == "SPELL_AURA_APPLIED")) then 
			spellID = id
		else
			return
		end
		if spellID == 49376 then spellID = 16979; useSecondDuration = true end -- Feral Charge - Cat -> Feral Charge - Bear
		if spellID == 91797 then spellID = 91800; end
		if (InterruptBarDB[CharIndex].prioOnly and not isPrio(spellID)) then return end
		if (InterruptBarDB[CharIndex].bgOnly and not bg and InterruptBarDB[CharIndex].arenaOnly and not arena) or (not InterruptBarDB[CharIndex].bgOnly and InterruptBarDB[CharIndex].arenaOnly and not arena) or (not InterruptBarDB[CharIndex].arenaOnly and InterruptBarDB[CharIndex].bgOnly and not bg) then return end
		local cold_snap={82676,44572,45438}
		local prep={1766,1856,36554,51722}
		local readiness={19263,19503,34490}

		if spellID == 11958 then --cold snap 82676 Ring of Frost -- 44572 Deep Freeze -- 45438 Ice Block
			if InterruptBarDB[CharIndex].prio and isPrio(ability) then
				for _,abil in ipairs(cold_snap) do
					if activetimers[abil] then
						InterruptBar_StopAbility(bar2[abil],abil)
					end
				end
			else
				for _,abil in ipairs(cold_snap) do
					if activetimers[abil] then
						InterruptBar_StopAbility(bar[abil],abil)
					end
				end
			end
		elseif spellID == 14185 then --prep
			if InterruptBarDB[CharIndex].prio and isPrio(ability) then
				for _,abil in ipairs(prep) do
					if activetimers[abil] then
						InterruptBar_StopAbility(bar2[abil],abil)
					end
				end
			else
				for _,abil in ipairs(prep) do
					if activetimers[abil] then
						InterruptBar_StopAbility(bar[abil],abil)
					end
				end
			end
			--[[ 1766  Kick 1856  Vanish 36554 Shadowstep 76577 Smoke Bomb 51722 Dismantle
				Non tracked: Sprint, Smoke Bomb]]
		elseif spellID == 23989 then --readiness
			if InterruptBarDB[CharIndex].prio and isPrio(ability) then
				for _,abil in ipairs(readiness) do
					if activetimers[abil] then
						InterruptBar_StopAbility(bar2[abil],abil)
					end
				end
			else
				for _,abil in ipairs(readiness) do
					if activetimers[abil] then
						InterruptBar_StopAbility(bar[abil],abil)
					end
				end
			end
		end
		useSecondDuration = false

		if abilities[spellID] then	
			if useSecondDuration and spellID == 16979 then
				if InterruptBarDB[CharIndex].prio and isPrio(spellID) then
					bar2[spellID].duration=30
				else
					bar[spellID].duration=30
				end
			elseif spellID == 16979 then
				if InterruptBarDB[CharIndex].prio and isPrio(spellID) then
					bar2[spellID].duration=15
				else
					bar[spellID].duration=15
				end
			elseif (spellID == 60192 or spellID == 1499) and survival  then
				if InterruptBarDB[CharIndex].prio and isPrio(spellID) then
					bar2[spellID].duration=12
				else
					bar[spellID].duration=12
				end
			end
			
			if InterruptBarDB[CharIndex].prio and isPrio(spellID) then
				if InterruptBarDB[CharIndex].smartPrio then InterruptBar_AddIcon(spellID) end
				InterruptBar_StartTimer(bar2[spellID],spellID)
			else
				if InterruptBarDB[CharIndex].smart then InterruptBar_AddIcon(spellID) end
				InterruptBar_StartTimer(bar[spellID],spellID)
			end
		end
	end
end

InterruptBar_COMBAT_LOG_EVENT_UNFILTERED = InterruptBar_COMBAT_LOG_EVENT_UNFILTERED()


local function InterruptBar_ResetAllTimers()
	for _,ability in ipairs(spell_table) do
		if InterruptBarDB[CharIndex].prio and isPrio(ability.spellID) then
			InterruptBar_StopAbility(bar2[ability.spellID],ability.spellID)
		else
			InterruptBar_StopAbility(bar[ability.spellID],ability.spellID)
		end
	end
	if not (InterruptBarDB[CharIndex].smart or InterruptBarDB[CharIndex].smartPrio) and not ((InterruptBarDB[CharIndex].smart or InterruptBarDB[CharIndex].smartPrio) and (InterruptBarDB[CharIndex].hidden or InterruptBarDB[CharIndex].hidden2)) then
		InterruptBar_Repos()
	end

end

local function InterruptBar_Reset()
	InterruptBarDB[CharIndex] = InterruptBarDB[CharIndex] or { scale = 1,scale2=1, hidden = false,hidden2=false, smart=false,smartPrio=false,prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,lockPrio=false,growUp=1,growLeft=-1 ,noCD=false,prioOnly=false}
	InterruptBar_ResetAllTimers()
	InterruptBar_UpdateBar()
	InterruptBar_LoadPosition()
	survival=false
end

local function InterruptBar_PLAYER_ENTERING_WORLD(self)
	arena=isInArena()
	bg=isInBG()
	InterruptBar_Reset()
end

local function InterruptBar_Test()
	if (InterruptBarDB[CharIndex].smart or InterruptBarDB[CharIndex].smartPrio) and (InterruptBarDB[CharIndex].hidden or InterruptBarDB[CharIndex].hidden2) then 
		InterruptBar_Repos()
	end
	if InterruptBarDB[CharIndex].prioOnly then 
		for _,ability in ipairs(spell_table) do
			if isPrio(ability.spellID) then
				if InterruptBarDB[CharIndex].smartPrio then InterruptBar_AddIcon(ability.spellID) end
				if InterruptBarDB[CharIndex].prio then
					InterruptBar_StartTimer(bar2[ability.spellID],ability.spellID)
				else
					InterruptBar_StartTimer(bar[ability.spellID],ability.spellID)
				end
			end
		end
	else
		for _,ability in ipairs(spell_table) do
			if InterruptBarDB[CharIndex].prio and isPrio(ability.spellID) then
				if InterruptBarDB[CharIndex].smartPrio then InterruptBar_AddIcon(ability.spellID) end
				InterruptBar_StartTimer(bar2[ability.spellID],ability.spellID)
			else
			if InterruptBarDB[CharIndex].smart then InterruptBar_AddIcon(ability.spellID) end
				InterruptBar_StartTimer(bar[ability.spellID],ability.spellID)
			end
		end
	end
end


local cmdfuncs = {
	status = function() 
		ChatFrame1:AddMessage("Scale - Main Bar(1) = "..InterruptBarDB[CharIndex].scale.."  Prio Bar(2) = "..InterruptBarDB[CharIndex].scale2,0,1,1)
		local cd="Disabled"
		if (InterruptBarDB[CharIndex].hidden) then cd="Enabled"; end
		ChatFrame1:AddMessage("Hidden(1) - "..cd,0,1,1)
		cd="Disabled"
		if (InterruptBarDB[CharIndex].hidden2) then cd="Enabled"; end
		ChatFrame1:AddMessage("Hidden(2) - "..cd,0,1,1)
		cd="Disabled"
		if (InterruptBarDB[CharIndex].smart) then cd="Enabled"; end
		ChatFrame1:AddMessage("Smart(1) - "..cd,0,1,1)
		cd="Disabled"
		if (InterruptBarDB[CharIndex].smartPrio) then cd="Enabled"; end
		ChatFrame1:AddMessage("Smart(2) - "..cd,0,1,1)
		cd="unlocked"
		if (InterruptBarDB[CharIndex].lock) then cd="locked"; end
		ChatFrame1:AddMessage("Locked(1) - "..cd,0,1,1)
		cd="unlocked"
		if (InterruptBarDB[CharIndex].lockPrio) then cd="locked"; end
		ChatFrame1:AddMessage("Locked(2) - "..cd,0,1,1)
		cd="Disabled"
		if (InterruptBarDB[CharIndex].prio) then cd="Enabled"; end
		ChatFrame1:AddMessage("Prio - "..cd,0,1,1)
		cd="Disabled"
		if (InterruptBarDB[CharIndex].arenaOnly) then cd="Enabled"; end
		ChatFrame1:AddMessage("ArenaOnly - "..cd,0,1,1)
		cd="Disabled"
		if (InterruptBarDB[CharIndex].bgOnly) then cd="Enabled"; end
		ChatFrame1:AddMessage("BGOnly - "..cd,0,1,1)
		cd="growing down"
		if (InterruptBarDB[CharIndex].growUp==-1) then cd="growing up"; end
		ChatFrame1:AddMessage("Cooldowns are "..cd.." from the anchor",0,1,1)
		cd="Disabled"
		cd="growing right"
		if (InterruptBarDB[CharIndex].growLeft==-1) then cd="growing left"; end
		ChatFrame1:AddMessage("Cooldowns are "..cd.." from the anchor",0,1,1)
		cd="Disabled"
		if (not InterruptBarDB[CharIndex].noCD) then cd="Enabled"; end
		ChatFrame1:AddMessage("InterruptBar cooldown display is "..cd,0,1,1)
		cd="all spell cooldowns"
		if (InterruptBarDB[CharIndex].prioOnly) then cd="ONLY priority cooldowns"; end
		ChatFrame1:AddMessage("Displaying "..cd.."(PrioOnly mode="..tostring(InterruptBarDB[CharIndex].prioOnly)..")",0,1,1)
		ChatFrame1:AddMessage("Columns per row:  Main Bar(1) = "..InterruptBarDB[CharIndex].cols.."  Prio Bar(2) = "..InterruptBarDB[CharIndex].colsPrio,0,1,1)
	end,
	scale = function(id,v,from) 
		if not id or not v then 
			ChatFrame1:AddMessage("USAGE: scale <bar ID> <number>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			ChatFrame1:AddMessage("Current settings: Main Bar(1) = "..InterruptBarDB[CharIndex].scale.."  Prio Bar(2) = "..InterruptBarDB[CharIndex].scale2,0,1,0)
			return
		end
		if ((id == 1 or id == 2) and v >= 0) then 
			if id==1 then
				InterruptBarDB[CharIndex].scale = v
			elseif id == 2 then
				InterruptBarDB[CharIndex].scale2=v
			end
			if not from then
				ChatFrame1:AddMessage("Scale for bar"..id.." set to"..v,0,1,0)
			end
			InterruptBar_UpdateBar()
			return
		end
		if not from then
			ChatFrame1:AddMessage("USAGE: scale <bar ID> <number>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			ChatFrame1:AddMessage("Current settings: Main Bar(1) = "..InterruptBarDB[CharIndex].scale.."  Prio Bar(2) = "..InterruptBarDB[CharIndex].scale2,0,1,0)
		end
	end,
	hidden = function(id,from) 
		if not id then 
			ChatFrame1:AddMessage("USAGE: hidden <bar ID>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			return
		end
		if ((id == 1 or id == 2)) then 
			local cd="Disabled"
			if id == 1 then
				InterruptBarDB[CharIndex].hidden = not InterruptBarDB[CharIndex].hidden
				if (InterruptBarDB[CharIndex].hidden) then cd="Enabled"; end
			elseif id == 2 then
				InterruptBarDB[CharIndex].hidden2 = not InterruptBarDB[CharIndex].hidden2
				if (InterruptBarDB[CharIndex].hidden2) then cd="Enabled"; end
			end
			if not from then
				ChatFrame1:AddMessage("InterruptBar hidden("..id..") mode is now "..cd,0,1,1)
				ChatFrame1:AddMessage("Enabled = Spells are hidden when not on cooldown",0,1,0)
				ChatFrame1:AddMessage("Disabled = Spells are always visible",0,1,0)
				ChatFrame1:AddMessage("Note: If Smart & Hidden mode are enabled, the cooldowns realign to the anchor when off cooldown",0,1,0)
			end
			InterruptBar_UpdateBar() 
			InterruptBar_Repos() 
		end
	end,
	smart = function(id,from) 
		if not id then 
			ChatFrame1:AddMessage("USAGE: smart <bar ID>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			return
		end
		local cd="Disabled"
		if ((id == 1 or id == 2)) then 
			if id == 1 then
				InterruptBarDB[CharIndex].smart = not InterruptBarDB[CharIndex].smart
				if (InterruptBarDB[CharIndex].smart) then cd="Enabled"; end
			elseif id == 2 then
				InterruptBarDB[CharIndex].smartPrio = not InterruptBarDB[CharIndex].smartPrio
				if (InterruptBarDB[CharIndex].smartPrio) then cd="Enabled"; end
			end
		end
		if not from then
			ChatFrame1:AddMessage("InterruptBar smart mode is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = Spells are only displayed once used and in the order they're used",0,1,0)
			ChatFrame1:AddMessage("Disabled = Spells are always displayed in the same order",0,1,0)
			ChatFrame1:AddMessage("Note: If Smart & Hidden mode are enabled, the cooldowns realign to the anchor when off cooldown",0,1,0)
		end
		InterruptBar_Reset() 
	end,
	lock = function(id,from) 
		if not id then 
			ChatFrame1:AddMessage("USAGE: lock <bar ID>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			return
		end
		if ((id == 1 or id == 2)) then 
			local cd="unlocked"
			if id == 1 then
				InterruptBarDB[CharIndex].lock = not InterruptBarDB[CharIndex].lock
				if (InterruptBarDB[CharIndex].hidden) then cd="locked"; end
			elseif id == 2 then
				InterruptBarDB[CharIndex].lockPrio = not InterruptBarDB[CharIndex].lockPrio
				if (InterruptBarDB[CharIndex].lockPrio) then cd="locked"; end
			end
			if not from then ChatFrame1:AddMessage("InterruptBar bar"..id.." is now "..cd,0,1,1) end
		end
		if not from then
			ChatFrame1:AddMessage("Locked = Bars can't be moved",0,1,0)
			ChatFrame1:AddMessage("Unlocked = Bars can be moved",0,1,0)
		end
		InterruptBar_UpdateBar()
	end,
	prio = function(from) 
		InterruptBarDB[CharIndex].prio = not InterruptBarDB[CharIndex].prio
		if not from then
			local cd="Disabled"
			if (InterruptBarDB[CharIndex].prio) then cd="Enabled"; end
			ChatFrame1:AddMessage("InterruptBar Prio bar is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = A second bar is created, displaying priority spells",0,1,0)
			ChatFrame1:AddMessage("Disabled = InterruptBar displays all spells on the main bar",0,1,0)
		end
		local temp1=InterruptBarDB[CharIndex].smart
		local temp2=InterruptBarDB[CharIndex].smartPrio

		InterruptBar_UpdateBar()
		InterruptBarDB[CharIndex].smartPrio=false
		InterruptBarDB[CharIndex].smart=false
		InterruptBar_Repos() 
		InterruptBarDB[CharIndex].smart=temp1
		InterruptBarDB[CharIndex].smartPrio=temp2
		InterruptBar_UpdateBar()
	end,
	arenaonly = function(from) 
		InterruptBarDB[CharIndex].arenaOnly = not InterruptBarDB[CharIndex].arenaOnly
		if not from then 
			local cd="Disabled"
			if (InterruptBarDB[CharIndex].arenaOnly) then cd="Enabled"; end
			ChatFrame1:AddMessage("InterruptBar Arena Only mode is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = InterruptBar is displayed ONLY in Arenas",0,1,0)
			ChatFrame1:AddMessage("Disabled = InterruptBar is displayed outside of Arenas",0,1,0)
			ChatFrame1:AddMessage("Note: If BGOnly & ArenaOnly are enabled, it will work in Arenas and BGs",0,1,0)
		end
		InterruptBar_Reset() 
	end,
	bgonly = function(from) 
		InterruptBarDB[CharIndex].bgOnly = not InterruptBarDB[CharIndex].bgOnly
		if not from then 
			local cd="Disabled"
			if (InterruptBarDB[CharIndex].bgOnly) then cd="Enabled"; end
			ChatFrame1:AddMessage("InterruptBar BG Only mode is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = InterruptBar is displayed ONLY in Battlegrounds",0,1,0)
			ChatFrame1:AddMessage("Disabled = InterruptBar is displayed outside of Battlegrounds",0,1,0)
			ChatFrame1:AddMessage("Note: If BGOnly & ArenaOnly are enabled, it will work in Arenas and BGs",0,1,0)
		end
		InterruptBar_Reset() 
	end,
	growup=function(from) 		
		InterruptBarDB[CharIndex].growUp=InterruptBarDB[CharIndex].growUp*-1
		if not from then 
			local text="growing down"
			if (InterruptBarDB[CharIndex].growUp==-1) then text="growing up"; end
			ChatFrame1:AddMessage("InterruptBar cooldowns are "..text.." from the anchor",0,1,1)
		end
		InterruptBar_Repos()
		end,
	growleft=function(from) 		
		InterruptBarDB[CharIndex].growLeft=InterruptBarDB[CharIndex].growLeft*-1
		if not from then 
			local text="growing right"
			if (InterruptBarDB[CharIndex].growLeft==-1) then text="growing left"; end
			ChatFrame1:AddMessage("InterruptBar cooldows are "..text.." from the anchor",0,1,1)
		end
		InterruptBar_Repos()
		end,
	nocd=function(from) 
		InterruptBarDB[CharIndex].noCD = not InterruptBarDB[CharIndex].noCD
		if not from then 
			local cd="Disabled"
			if (not InterruptBarDB[CharIndex].noCD) then cd="Enabled"; end
			ChatFrame1:AddMessage("InterruptBar cooldown display is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = InterruptBar displays text",0,1,0)
			ChatFrame1:AddMessage("Disabled = InterruptBar displays no text, OmniCC can be used",0,1,0)
		end
		InterruptBar_Reset()
	end,
	prioonly=function(from)
		InterruptBarDB[CharIndex].prioOnly=not InterruptBarDB[CharIndex].prioOnly
		if not from then
			local cd="all spell cooldowns"
			if (InterruptBarDB[CharIndex].prioOnly) then cd="ONLY priority cooldowns"; end
			ChatFrame1:AddMessage("InterruptBar is now displaying "..cd,0,1,1)
		end
		InterruptBar_Reset()  
	end,
	opts=function()
		InterfaceOptionsFrame_OpenToCategory(InterruptBar.mainpanel);
	end,
	gui=function()
		InterfaceOptionsFrame_OpenToCategory(InterruptBar.mainpanel);
	end,
	config=function()
		InterfaceOptionsFrame_OpenToCategory(InterruptBar.mainpanel);
	end,
	cols = function(id,v,from) 
		if not id or not v then 
			ChatFrame1:AddMessage("USAGE: cols <bar ID> <number>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			ChatFrame1:AddMessage("Current settings: Main Bar(1) = "..InterruptBarDB[CharIndex].cols.."  Prio Bar(2) = "..InterruptBarDB[CharIndex].colsPrio,0,1,0)
			return
		end
		if ((id == 1 or id == 2) and v >= 0) then 
			if id==1 then
				if (v==0) then
					InterruptBarDB[CharIndex].cols = getTotalMain()
				else
					InterruptBarDB[CharIndex].cols = v
				end
			elseif id==2 then
				if (v==0) then
					InterruptBarDB[CharIndex].colsPrio = getTotalPrio()
				else
					InterruptBarDB[CharIndex].colsPrio = v
				end
			end
			if not from then
				ChatFrame1:AddMessage("Cols for bar"..id.." set to "..v,0,1,0)
			end
			InterruptBar_Repos()
			return	
		end
		if not from then
			ChatFrame1:AddMessage("USAGE: /InterruptBar cols <bar ID> <number>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			ChatFrame1:AddMessage("Current settings: Main Bar(1) = "..InterruptBarDB[CharIndex].cols.."  Prio Bar(2) = "..InterruptBarDB[CharIndex].colsPrio,0,1,0)
			ChatFrame1:AddMessage("Example: set main bar cols to 6: /InterruptBar cols 1 6",0,1,0)
		end
	end,
	reset = function() InterruptBar_Reset() end,
	test = function() InterruptBar_Test() end,
}

local cmdtbl = {}
function InterruptBar_Command(cmd)
	for k in ipairs(cmdtbl) do
		cmdtbl[k] = nil
	end
	for v in gmatch(cmd, "[%d|%a|.]+") do
		tinsert(cmdtbl, v)
	end
  local cb = cmdfuncs[cmdtbl[1]] 
  if cb then
  	local s = tonumber(cmdtbl[2])
  	local ss = tonumber(cmdtbl[3])
  	cb(s,ss)
  else
	ChatFrame1:AddMessage("InterruptBar Help",0,1,0)
	ChatFrame1:AddMessage("config - Display current value of options",0,1,0)
	ChatFrame1:AddMessage("scale <bar ID> <number> - Sets the scale factor for the given bar",0,1,0)
  	ChatFrame1:AddMessage("hidden <bar ID> (toggle) - Hides spell icons when off cooldown",0,1,0)
	ChatFrame1:AddMessage("smart <bar ID>(toggle) - Only show CD when used",0,1,0)
  	ChatFrame1:AddMessage("lock <bar ID>(toggle) - Locks the bars in place",0,1,0)
	ChatFrame1:AddMessage("growup (toggle) - The icons grow upwards from the anchor if enabled",0,1,0)
	ChatFrame1:AddMessage("growleft (toggle) - The icons grow left from the anchor if enabled",0,1,0)
	ChatFrame1:AddMessage("prio (toggle) - Displays second anchor with priority spells",0,1,0)
	ChatFrame1:AddMessage("arenaonly (toggle) - Only display cooldowns if in an arena",0,1,0)
	ChatFrame1:AddMessage("bgonly (toggle) - Only display cooldowns if in a battleground",0,1,0)
	ChatFrame1:AddMessage("prioonly (toggle) - Only displays priority cooldowns",0,1,0)
	ChatFrame1:AddMessage("nocd (toggle) - Disables the InterruptBar cooldown text and allows omniCC",0,1,0)
	ChatFrame1:AddMessage("cols <bar ID> <num> (0 = 1 row) - Set number of spells per row for the given bar",0,1,0)
  	ChatFrame1:AddMessage("test - Activates all cooldowns to test InterruptBar",0,1,0)
  	ChatFrame1:AddMessage("reset - Resets all cooldowns",0,1,0)
  end
end

local function InterruptBar_OnLoad(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	if not InterruptBarDB then
		InterruptBarDB={}
	end
	InterruptBarDB["Default"]= InterruptBarDB["Default"] or { scale = 1,scale2=1 , hidden = false,hidden2=false, smart=false, smartPrio=false,prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,growUp=1,growLeft=1, noCD=false,prioOnly=false,}
	InterruptBarDB["CharsUse"]=InterruptBarDB["CharsUse"] or {}
	
	if (InterruptBarDB["CharsUse"][CharIndex]) then
		if (InterruptBarDB[InterruptBarDB["CharsUse"][CharIndex]]) then
			CharIndex=InterruptBarDB["CharsUse"][CharIndex]
		else
			InterruptBarDB["CharsUse"][CharIndex]=CharIndex
			if not InterruptBarDB[CharIndex] then
				InterruptBarDB[CharIndex]=InterruptBarDB["Default"]
			end
		end	
	else
		InterruptBarDB["CharsUse"][CharIndex]=CharIndex
		if not InterruptBarDB[CharIndex] then
			InterruptBarDB[CharIndex]=InterruptBarDB["Default"]
		end
	end
	for k,v in pairs(InterruptBarDB) do
		if not (type(InterruptBarDB[k]) == "table" ) then 
			InterruptBarDB[k]=nil
		elseif (k=="Position" and (InterruptBarDB["Position"]["scale2"]==nil)) then 
			InterruptBarDB[k]=nil
		end
	end
	
	InterruptBar_CreateBar()
	
	SlashCmdList["InterruptBar"] = InterruptBar_Command
	SLASH_InterruptBar1 = "/interruptBar"
	SLASH_InterruptBar2 = "/ib"
	SLASH_InterruptBar3 = "/inter"
	ChatFrame1:AddMessage("InterruptBar by Frost, inspired by Kollektiv's Interrupt Bar & Robrman. Type /InterruptBar or /ib for options.",0,1,0)
end

local eventhandler = {
	["VARIABLES_LOADED"] = function(self) InterruptBar_OnLoad(self) end,
	["PLAYER_ENTERING_WORLD"] = function(self) InterruptBar_PLAYER_ENTERING_WORLD(self) end,
	["COMBAT_LOG_EVENT_UNFILTERED"] = function(self,...) InterruptBar_COMBAT_LOG_EVENT_UNFILTERED(...) end,
	["ARENA_PREP_OPPONENT_SPECIALIZATIONS"] = function(self,...) InterruptBar_ARENA_PREP_OPPONENT_SPECIALIZATIONS(...) end,
}

local function InterruptBar_OnEvent(self,event,...)
	eventhandler[event](self,...)
end

frame = CreateFrame("Frame","InterruptBarMainFrame",UIParent)
frame:SetScript("OnEvent",InterruptBar_OnEvent)
frame:RegisterEvent("VARIABLES_LOADED")

InterruptBar = {};
InterruptBar.mainpanel = CreateFrame( "Frame", "InterruptBarMainPanel", UIParent );
InterruptBar.mainpanel.name = "InterruptBar";
local title = InterruptBar.mainpanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 20, -10)
title:SetText("InterruptBar")
local subtitle = InterruptBar.mainpanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetPoint("RIGHT", InterruptBar.mainpanel, -32, 0)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("General options for InterruptBar")

local buttonPositionY = -60;
local buttonPositionX = 20;

local t = {"prio","prioOnly","arenaOnly","bgOnly","nocd","growLeft","growUp"};
local general_cmd_table={cmdfuncs["prio"],cmdfuncs["prioonly"],cmdfuncs["arenaonly"],cmdfuncs["bgonly"],cmdfuncs["nocd"],cmdfuncs["growleft"],cmdfuncs["growup"]};
local t2 = {"Show Priority bar","Priority Bar Only", "Display Only in Arenas","Display Only in Battlegrounds","Hide InterruptBar cooldown time","Grow icons left from the anchor","Grow icons up from the anchor"};
for i,v in ipairs (t) do
	local InterruptBar_IconOptions_CheckButton = CreateFrame("CheckButton", "InterruptBar_Button_"..v, InterruptBar.mainpanel, "OptionsCheckButtonTemplate");
	InterruptBar_IconOptions_CheckButton:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);
	getglobal(InterruptBar_IconOptions_CheckButton:GetName().."Text"):SetText(t2[i]);

	local function InterruptBar_IconOptions_CheckButton_OnClick()
			general_cmd_table[i](1,"gui")
	end

	local function InterruptBar_IconOptions_CheckButton_OnShow()
		if (v == "growLeft" or v == "growUp") then
			InterruptBar_IconOptions_CheckButton:SetChecked(InterruptBarDB[CharIndex][v]==-1);
		else
			InterruptBar_IconOptions_CheckButton:SetChecked(InterruptBarDB[CharIndex][v]);
		end
	end

	InterruptBar_IconOptions_CheckButton:RegisterForClicks("AnyUp");
	InterruptBar_IconOptions_CheckButton:SetScript("OnClick", InterruptBar_IconOptions_CheckButton_OnClick);
	InterruptBar_IconOptions_CheckButton:SetScript("OnShow", InterruptBar_IconOptions_CheckButton_OnShow);
	buttonPositionY = buttonPositionY - 30;
end

-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(InterruptBar.mainpanel);
-- Make a child panel
InterruptBar.mainbarpanel = CreateFrame( "Frame", "MainBarPanel", InterruptBar.mainpanel);
InterruptBar.mainbarpanel.name = "Main Bar";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
InterruptBar.mainbarpanel.parent = InterruptBar.mainpanel.name;
			
local title = InterruptBar.mainbarpanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 20, -10)
title:SetText("Main Bar Options")

local subtitle = InterruptBar.mainbarpanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetPoint("RIGHT", InterruptBar.mainbarpanel, -32, 0)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Options for InterruptBar Main Bar")	

buttonPositionY = -60;
buttonPositionX = 20;

-- Main bar options
local t = {"hidden","smart","lock"};
local bar_cmd_table={cmdfuncs["hidden"],cmdfuncs["smart"],cmdfuncs["lock"]};
local t2 = {"Hide Icons","Smart", "Lock frame"};
for i,v in ipairs (t) do
	local InterruptBar_IconOptions_CheckButton = CreateFrame("CheckButton", "InterruptBar_Button_"..v, InterruptBar.mainbarpanel, "OptionsCheckButtonTemplate");
	InterruptBar_IconOptions_CheckButton:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);
	getglobal(InterruptBar_IconOptions_CheckButton:GetName().."Text"):SetText(t2[i]);

	local function InterruptBar_IconOptions_CheckButton_OnClick()
			bar_cmd_table[i](1,"gui")
	end

	local function InterruptBar_IconOptions_CheckButton_OnShow()
		InterruptBar_IconOptions_CheckButton:SetChecked(InterruptBarDB[CharIndex][v]);
	end

	InterruptBar_IconOptions_CheckButton:RegisterForClicks("AnyUp");
	InterruptBar_IconOptions_CheckButton:SetScript("OnClick", InterruptBar_IconOptions_CheckButton_OnClick);
	InterruptBar_IconOptions_CheckButton:SetScript("OnShow", InterruptBar_IconOptions_CheckButton_OnShow);
	buttonPositionY = buttonPositionY - 30;
end
local tsliders = {"cols","scale"};
local slider_table={cmdfuncs["cols"],cmdfuncs["scale"]};
local slidert2 = {"Number of cols","Scale (default 1.0)" };
buttonPositionY = buttonPositionY - 30;
for i,v in ipairs (tsliders) do
	local InterruptBar_IconOptions_Slider = CreateFrame("Slider", "InterruptBar_Slider_"..v, InterruptBar.mainbarpanel, "OptionsSliderTemplate");
	InterruptBar_IconOptions_Slider:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);
	getglobal(InterruptBar_IconOptions_Slider:GetName() .. 'Low'):SetText('-');
	getglobal(InterruptBar_IconOptions_Slider:GetName() .. 'High'):SetText('+');
	getglobal(InterruptBar_IconOptions_Slider:GetName() .. 'Text'):SetText(slidert2[i].."\nValue: "..InterruptBarDB[CharIndex][v]);

	if (v == "cols") then
		InterruptBar_IconOptions_Slider:SetMinMaxValues(0,#(spell_table));
		InterruptBar_IconOptions_Slider:SetValueStep(1.0);
	elseif (v == "scale") then
		InterruptBar_IconOptions_Slider:SetMinMaxValues(0.1,2.0);
		InterruptBar_IconOptions_Slider:SetValueStep(0.1);
	end
	
	local function InterruptBar_IconOptions_Slider_OnShow()
		InterruptBar_IconOptions_Slider:SetValue(InterruptBarDB[CharIndex][v]);
	end

	local function InterruptBar_IconOptions_Slider_OnValueChanged()
		slider_table[i](1,InterruptBar_IconOptions_Slider:GetValue(),"gui");
		getglobal(InterruptBar_IconOptions_Slider:GetName() .. 'Text'):SetText(slidert2[i].."\nValue: "..InterruptBarDB[CharIndex][v]);
	end

	InterruptBar_IconOptions_Slider:SetScript("OnValueChanged", InterruptBar_IconOptions_Slider_OnValueChanged);
	InterruptBar_IconOptions_Slider:SetScript("OnShow", InterruptBar_IconOptions_Slider_OnShow);
	buttonPositionY = buttonPositionY - 60;
end

InterfaceOptions_AddCategory(InterruptBar.mainbarpanel);
-- Make a child panel
InterruptBar.priobarpanel = CreateFrame( "Frame", "PrioBarPanel", InterruptBar.mainpanel);
InterruptBar.priobarpanel.name = "Prio Bar";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
InterruptBar.priobarpanel.parent = InterruptBar.mainpanel.name;

local title = InterruptBar.priobarpanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 20, -10)
title:SetText("Prio Bar Options")

local subtitle = InterruptBar.priobarpanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetPoint("RIGHT", InterruptBar.priobarpanel, -32, 0)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Options for InterruptBar Prio Bar")	

buttonPositionY = -60;
buttonPositionX = 20;
local priot = {"hidden2","smartPrio","lockPrio"};
for i,v in ipairs (priot) do
	local InterruptBar_IconOptions_CheckButton = CreateFrame("CheckButton", "InterruptBar_Button_"..v, InterruptBar.priobarpanel, "OptionsCheckButtonTemplate");
	InterruptBar_IconOptions_CheckButton:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);
	getglobal(InterruptBar_IconOptions_CheckButton:GetName().."Text"):SetText(t2[i]);

	local function InterruptBar_IconOptions_CheckButton_OnClick()
			bar_cmd_table[i](2,"gui")
	end

	local function InterruptBar_IconOptions_CheckButton_OnShow()
		InterruptBar_IconOptions_CheckButton:SetChecked(InterruptBarDB[CharIndex][v]);
	end

	InterruptBar_IconOptions_CheckButton:RegisterForClicks("AnyUp");
	InterruptBar_IconOptions_CheckButton:SetScript("OnClick", InterruptBar_IconOptions_CheckButton_OnClick);
	InterruptBar_IconOptions_CheckButton:SetScript("OnShow", InterruptBar_IconOptions_CheckButton_OnShow);

	buttonPositionY = buttonPositionY - 30;
end
tsliders = {"colsPrio","scale2"};
buttonPositionY = buttonPositionY - 30;
for i,v in ipairs (tsliders) do
	local InterruptBar_IconOptions_Slider = CreateFrame("Slider", "InterruptBar_Slider_"..v, InterruptBar.priobarpanel, "OptionsSliderTemplate");
	InterruptBar_IconOptions_Slider:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);

	getglobal(InterruptBar_IconOptions_Slider:GetName() .. 'Low'):SetText('-');
	getglobal(InterruptBar_IconOptions_Slider:GetName() .. 'High'):SetText('+');
	getglobal(InterruptBar_IconOptions_Slider:GetName() .. 'Text'):SetText(slidert2[i].."\nValue: "..InterruptBarDB[CharIndex][v]);
	
	if (v == "colsPrio") then
		local val = getTotalPrio("gui");
		InterruptBar_IconOptions_Slider:SetMinMaxValues(0,val+1);
		InterruptBar_IconOptions_Slider:SetValueStep(1.0);
	elseif (v == "scale2") then
		
		InterruptBar_IconOptions_Slider:SetMinMaxValues(0.1,2.0);
		InterruptBar_IconOptions_Slider:SetValueStep(0.1);
	end
	
	local function InterruptBar_IconOptions_Slider_OnShow()
		InterruptBar_IconOptions_Slider:SetValue(InterruptBarDB[CharIndex][v]);
	end

	local function InterruptBar_IconOptions_Slider_OnValueChanged()
		slider_table[i](2,InterruptBar_IconOptions_Slider:GetValue(),"gui");
		getglobal(InterruptBar_IconOptions_Slider:GetName() .. 'Text'):SetText(slidert2[i].."\nValue: "..InterruptBarDB[CharIndex][v]);
	end

	InterruptBar_IconOptions_Slider:SetScript("OnValueChanged", InterruptBar_IconOptions_Slider_OnValueChanged);
	InterruptBar_IconOptions_Slider:SetScript("OnShow", InterruptBar_IconOptions_Slider_OnShow);

	buttonPositionY = buttonPositionY - 60;
end
InterfaceOptions_AddCategory(InterruptBar.priobarpanel);


-- Make a child panel
InterruptBar.profilepanel = CreateFrame( "Frame", "ProfilePanel", InterruptBar.mainpanel);
InterruptBar.profilepanel.name = "Profiles";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
InterruptBar.profilepanel.parent = InterruptBar.mainpanel.name;

local title = InterruptBar.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 20, -10)
title:SetText("Prio Bar Options")

local subtitle = InterruptBar.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetPoint("RIGHT", InterruptBar.profilepanel, -32, 0)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("InterruptBar Profile Options")	

buttonPositionY = -60;
buttonPositionX = 20;
local UsingProfileLabel = InterruptBar.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
UsingProfileLabel:SetHeight(32)
UsingProfileLabel:SetPoint("TOPLEFT", buttonPositionX,buttonPositionY)
UsingProfileLabel:SetNonSpaceWrap(true)
UsingProfileLabel:SetJustifyH("LEFT")
UsingProfileLabel:SetJustifyV("TOP")
UsingProfileLabel:SetText("Currently using: "..CharIndex)	


buttonPositionY=-100
local InterruptBar_Options_EditBox = CreateFrame("EditBox", "InterruptBar_NewProfile_NewID", InterruptBar.profilepanel, "InputBoxTemplate");
InterruptBar_Options_EditBox:SetPoint("TOPLEFT", buttonPositionX+5,buttonPositionY);
InterruptBar_Options_EditBox:SetWidth(125);
InterruptBar_Options_EditBox:SetHeight(32);
InterruptBar_Options_EditBox:EnableMouse(true);
InterruptBar_Options_EditBox:SetAutoFocus(false);
InterruptBar_Options_EditBox_Text = InterruptBar_Options_EditBox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall');
InterruptBar_Options_EditBox_Text:SetPoint("TOPLEFT", -3, 10);
InterruptBar_Options_EditBox_Text:SetText("New Profile Name");


-- New Profile Save Button
local InterruptBar_CreateProfile_SaveButton = CreateFrame("Button", "InterruptBar_ProfileSaveButton",InterruptBar.profilepanel, "OptionsButtonTemplate");
InterruptBar_CreateProfile_SaveButton:SetPoint("TOPLEFT",buttonPositionX+130,buttonPositionY-5);
InterruptBar_CreateProfile_SaveButton:SetWidth(50);
InterruptBar_CreateProfile_SaveButton:SetHeight(21);
InterruptBar_CreateProfile_SaveButton:SetText("Save");

local function CreateNewProfile()
	InterruptBarDB[InterruptBar_Options_EditBox:GetText()]=InterruptBarDB[InterruptBar_Options_EditBox:GetText()] or { scale = 1,scale2=1 , hidden = false,hidden2=false, smart=false, smartPrio=false,prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,growUp=1,growLeft=1, noCD=false,prioOnly=false,}
	InterruptBar_Options_EditBox:SetText("")
end
InterruptBar_CreateProfile_SaveButton:SetScript("OnClick", CreateNewProfile)


buttonPositionX = buttonPositionX+195
buttonPositionY = -100
local subtitle = InterruptBar.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", buttonPositionX+10,buttonPositionY+15)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Use Profile...")
if not DropDownMenuUse then
   CreateFrame("Button", "DropDownMenuUse", InterruptBar.profilepanel, "UIDropDownMenuTemplate")
end
 
DropDownMenuUse:ClearAllPoints()
DropDownMenuUse:SetPoint("TOPLEFT", buttonPositionX-10, buttonPositionY)
DropDownMenuUse:Show()
 
local items = {}

local function OnClick(self)
   UIDropDownMenu_SetSelectedID(DropDownMenuUse, self:GetID())
   InterruptBarDB["CharsUse"][InterruptBarChar.." - "..InterruptBarRealm]=self:GetText()
   CharIndex=self:GetText()
   UsingProfileLabel:SetText("Currently using: "..CharIndex)
   InterruptBar_Reset()
end
 
local function initialize(self, level)
items = {};
 	for k,v in pairs(InterruptBarDB) do
		if (type(InterruptBarDB[k]) == "table" and not(k =="CharsUse")) then table.insert(items,k) end
	end
   local info = UIDropDownMenu_CreateInfo()
   for k,v in pairs(items) do
      info = UIDropDownMenu_CreateInfo()
      info.text = v
      info.value = v
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end

UIDropDownMenu_Initialize(DropDownMenuUse, initialize)
UIDropDownMenu_SetWidth(DropDownMenuUse, 160);
UIDropDownMenu_SetButtonWidth(DropDownMenuUse, 180)
UIDropDownMenu_SetSelectedID(DropDownMenuUse, 1)
UIDropDownMenu_JustifyText(DropDownMenuUse, "LEFT")

buttonPositionX = 5
buttonPositionY = buttonPositionY -60

local subtitle = InterruptBar.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", buttonPositionX+20,buttonPositionY+15)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Copy From...")

if not DropDownMenuCopy then
   CreateFrame("Button", "DropDownMenuCopy", InterruptBar.profilepanel, "UIDropDownMenuTemplate")
end

DropDownMenuCopy:ClearAllPoints()
DropDownMenuCopy:SetPoint("TOPLEFT", buttonPositionX, buttonPositionY)
DropDownMenuCopy:Show()
 
local function OnClick(self)
   UIDropDownMenu_SetSelectedID(DropDownMenuCopy, self:GetID())
   InterruptBarDB[InterruptBarChar.." - "..InterruptBarRealm]=InterruptBarDB[self:GetText()]
   CharIndex=InterruptBarChar.." - "..InterruptBarRealm
   UsingProfileLabel:SetText("Currently using: "..CharIndex)
   InterruptBar_Reset()
end
 
local function initialize(self, level)
items = {};
 	for k,v in pairs(InterruptBarDB) do
		if (type(InterruptBarDB[k]) == "table" and not(k =="CharsUse")) then table.insert(items,k) end
	end
   local info = UIDropDownMenu_CreateInfo()
   for k,v in pairs(items) do
      info = UIDropDownMenu_CreateInfo()
      info.text = v
      info.value = v
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end
 
UIDropDownMenu_Initialize(DropDownMenuCopy, initialize)
UIDropDownMenu_SetWidth(DropDownMenuCopy, 160);
UIDropDownMenu_SetButtonWidth(DropDownMenuCopy, 180)
UIDropDownMenu_SetSelectedID(DropDownMenuCopy, 1)
UIDropDownMenu_JustifyText(DropDownMenuCopy, "LEFT")

buttonPositionX = buttonPositionX+220

local subtitle = InterruptBar.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", buttonPositionX,buttonPositionY+15)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Delete Profile")

if not DropDownMenuDel then
   CreateFrame("Button", "DropDownMenuDel", InterruptBar.profilepanel, "UIDropDownMenuTemplate")
end

DropDownMenuDel:ClearAllPoints()
DropDownMenuDel:SetPoint("TOPLEFT", buttonPositionX-20, buttonPositionY)
DropDownMenuDel:Show()
 
local function OnClick(self)
	InterruptBarDB[self:GetText()]=nil
	if (CharIndex == self:GetText()) then
		if ((InterruptBarChar.." - "..InterruptBarRealm)==self:GetText()) then
			InterruptBarDB["CharsUse"][InterruptBarChar.." - "..InterruptBarRealm]="Default"
			CharIndex="Default"
		else
			CharIndex=InterruptBarChar.." - "..InterruptBarRealm
			if not InterruptBarDB[CharIndex] then
				InterruptBarDB[CharIndex] = InterruptBarDB["Default"]
			end
			InterruptBarDB["CharsUse"][CharIndex]=CharIndex
		end
		UsingProfileLabel:SetText("Currently using: "..CharIndex)	
	end
	items = {};
 	for k,v in pairs(InterruptBarDB) do
		if (type(InterruptBarDB[k]) == "table" and not(k =="CharsUse")and not (k == "Default")) then table.insert(items,k) end
	end
	InterruptBar_Reset()
end
 
local function initialize(self, level)
items = {};
 	for k,v in pairs(InterruptBarDB) do
		if (type(InterruptBarDB[k]) == "table" and not(k =="CharsUse")and not (k == "Default")) then table.insert(items,k) end
	end
	local info = UIDropDownMenu_CreateInfo()
	for k,v in pairs(items) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		info.func = OnClick
		UIDropDownMenu_AddButton(info, level)
	end
end
	
UIDropDownMenu_Initialize(DropDownMenuDel, initialize)
UIDropDownMenu_SetWidth(DropDownMenuDel, 160);
UIDropDownMenu_SetButtonWidth(DropDownMenuDel, 180)
UIDropDownMenu_SetSelectedID(DropDownMenuDel, 1)
UIDropDownMenu_JustifyText(DropDownMenuDel, "LEFT")
-- Add the child to the Interface Options
InterfaceOptions_AddCategory(InterruptBar.profilepanel);