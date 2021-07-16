
local classColors = {
	["warrior"] = {0.68, 0.51, 0.33},
	["rogue"] = {1.0, 0.96, 0.31},
	["mage"] = {0.21, 0.60, 0.74},
	["warlock"] = {0.48, 0.41, 0.69},
	["hunter"] = {0.47, 0.73, 0.25},
	["priest"] = {1.0, 1.00, 1.00},
	["paladin"] = {0.96, 0.55, 0.73},
	["druid"] = {1.0, 0.49, 0.04},
	["shaman"] = {0.0, 0.34, 0.77}
}

local Salad_PlayerName,_ = UnitName("player")
local backdrop = {
	bgFile = "Interface\\AddOns\\Offspec_Mag\\Images\\mags_room.tga",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = false,
	edgeSize = 32,
	insets = {
		left = 12,
		right = 12,
		top = 12,
		bottom = 12
	}
}

local frame = CreateFrame("Frame", "Mags_room", UIParent)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:SetHeight(534)
frame:SetWidth(534)
frame:SetPoint("CENTER", 0, 0)
frame:SetBackdrop(backdrop)
frame:SetAlpha(1.00)
frame:SetUserPlaced(true)
frame:SetFrameStrata("HIGH")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:SetScript("OnEvent", function()
	fillGrid()
end)
--frame:Hide()

local Salad_Slider = CreateFrame("Slider", "MySlider1", frame, "OptionsSliderTemplate")
Salad_Slider:SetPoint("BOTTOM", frame, "BOTTOMRIGHT", -80, 20)
Salad_Slider:SetMinMaxValues(0.05, 1.00)
Salad_Slider:SetValue(1.00)
Salad_Slider:SetValueStep(0.05)
getglobal(Salad_Slider:GetName() .. 'Low'):SetText('5%')
getglobal(Salad_Slider:GetName() .. 'High'):SetText('100%')
getglobal(Salad_Slider:GetName() .. 'Text'):SetText('Opacity')
Salad_Slider:SetScript("OnValueChanged", function(self)
	local value = Salad_Slider:GetValue()
	frame:SetAlpha(value)
end)

local Salad_Header = CreateFrame("Frame", "Salad_Header", frame)
Salad_Header:SetPoint("TOP", frame, "TOP", 0, 12)
Salad_Header:SetWidth(256)
Salad_Header:SetHeight(64)
Salad_Header:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Header"
})

local drag = CreateFrame("Frame", nil, frame)
drag:SetWidth(256)
drag:SetHeight(64)
drag:SetPoint("TOP", frame, "TOP", 0, 12)
drag:EnableMouse(true)
drag:SetScript("OnMouseDown", function()
	frame:StartMoving()
end)

drag:SetScript("OnMouseUp", function()
	frame:StopMovingOrSizing()
end)

drag:SetScript("OnHide", function()
	frame:StopMovingOrSizing()
end)

--Display Title on frame
local Salad_Fontstring = Salad_Header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
Salad_Fontstring:SetPoint("CENTER", Salad_Header, "CENTER", 0, 12)
Salad_Fontstring:SetText("Salad_Cthun")

--create button to close out frame
local button = CreateFrame("Button", "Close_button", frame)
button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
button:SetHeight(32)
button:SetWidth(32)
button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
button:SetScript("OnLoad", 
	function()
		button:RegisterForClicks("AnyUp")
	end 
)
button:SetScript("OnClick", 
	function()
		frame:Hide();
	end
)

--Create dot frames
--[[ for i=1,25 do
	dot = CreateFrame("Button", "Dot_"..i, frame)
	dot:SetPoint("CENTER", frame, "CENTER", dotPos[i][1], dotPos[i][2])
	dot:EnableMouse(true)
	dot:SetFrameLevel(dot:GetFrameLevel()+3)
	tooltip = CreateFrame("GameTooltip", "Tooltip_"..i, nil, "GameTooltipTemplate")
	local texdot = dot:CreateTexture("Texture_"..i, "OVERLAY")
	dot.texture = texdot
	texdot:SetAllPoints(dot)
	texdot:SetTexture("Interface\\AddOns\\Offspec_Mag\\Images\\playerdot.tga")
	texdot:Hide()
	dot:SetScript("OnEnter", function()
		tooltip:SetOwner(dot, "ANCHOR_RIGHT")
		tooltip:SetText("Empty")
		tooltip:Show()
	end)
	dot:SetScript("OnLeave", function()
		tooltip:Hide()
	end)
end ]]

--[[ function newDot(dot, tooltip, texture, name, class)
	if (Salad_PlayerName == name) then
		dot:SetWidth(36)
		dot:SetHeight(36)
	else
		dot:SetWidth(20)
		dot:SetHeight(20)
	end
	
	if name ~= "Empty" then
		texture:SetVertexColor(classColors[class][1], classColors[class][2], classColors[class][3], 1.0)
		texture:Show()
	else
		texture:Hide()
	end

	dot:SetScript("OnEnter", function()
		tooltip:SetOwner(dot, "ANCHOR_RIGHT")
		tooltip:SetText(name)
		tooltip:Show()
	end)

	dot:SetScript("OnLeave", function()
		tooltip:Hide()
	end)
end ]]

local dotRes = {{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, -- group 1
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, -- group 2
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
	  	  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
	  	  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}} -- group 8

--[[ function getRaidInfo()
	for i=1,25 do
		local name,_,subgroup,_,class,_,_,_,_,_,role = GetRaidRosterInfo(i);

		--if (class == "Rogue" or class == "Warrior") then
			
		--elseif (class == "Mage" or class == "Warlock" or class == "Hunter") then
			
		--elseif (class == "Priest" or class == "Paladin" or class == "Druid" or class == "Shaman") then
			
		end
	end
end ]]

--[[ function fillGrid()
	wipeReserves()
	getRaidInfo()
	for i=1,8 do
		for j=1,5 do
			local x = ((i-1)*5)+j
			newDot(_G["Dot_"..x], _G["Tooltip_"..x], _G["Texture_"..x], dotRes[i][j][1], strlower(dotRes[i][j][2]))
		end
	end
end ]]

--function wipeReserves()
--	for i=1,8 do
--		for j=1,5 do
--			for k=1,2 do
--				dotRes[i][j][k] = "Empty"
--			end
--		end
--	end
--end

--[[ SLASH_MAG_1 = "/mag";

local function HandleSlashCommands(str)
	if (str == "help") then
		print("|cffffff00Commands:");
		print("|cffffff00   /mag |cff00d2d6help |r|cffffff00-- show this help menu");
		print("|cffffff00   /mag -- open cthun map");
	elseif (str == "fill" or str == "" or str == nil) then
		frame:Show();
		fillGrid()
	else
		print("|cffffff00Command not found");
	end
end

SlashCmdList.MAG = HandleSlashCommands; ]]


