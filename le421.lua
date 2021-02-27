

SLASH_DICE1 = "/421"

local INITIAL_ROLL = 6
Dices = {}
local HANDLE = {
  rolls={},

}

local function FramePool_Init(parent)
  if not parent.FramePool then
    parent.FramePool = {}
  end
end

local function FramePool_All(parent)

  FramePool_Init(parent)
  return parent.FramePool
end

local function FramePool_Put(parent, frame)
  FramePool_Init(parent)
  tinsert(parent.FramePool, frame)
end

local function FramePool_Get(parent)
  FramePool_Init(parent)
  local frame = tremove(parent.FramePool)
  if frame then
    return frame
  else
    return parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  end
end

local function Dice_GetLastValue(key, default)
  local player = UnitName("player")
  local last = HANDLE.rolls[player]

  if last then
    local v = last[key]
    if v then
      return v
    end
  end

  return default
end

local function Dice_SortedRolls()
  local rolls = {}
  for k, v in pairs(HANDLE.rolls) do
    tinsert(rolls, v)
  end
  table.sort(rolls, function (left, right)
      return left.roll > right.roll
  end)
  return rolls
end

local function Dice_SetEnabled(button, enabled)
    if enabled then button:Enable() else button:Disable() end
end

local function isempty(s)
  return s == nil or s == ''
end


local function Dice_UpdateTable()
  local rows = Dice_SortedRolls()
  local scrollFrame = HANDLE.Frame.ScrollFrame
  local scrollChild = scrollFrame.Child
  local w = scrollFrame:GetWidth()
  local top = -4
  local rowHeight = 18

  -- Hide all previous row frames
  for i, frame in pairs(FramePool_All(scrollChild)) do
    frame:Hide() 
  end


  -- Make new row frames if necessary or reuse from pool
  local textFrames = {}

  for k, v in pairs(rows) do

    local color = ""

    -- Set color to red for eliminated playersq
    if isempty(v.roll) then
	return
	end
	
	if v.roll <= 1 then
      color = "|cffff0000"
    end

    local fplayer = FramePool_Get(scrollChild)
    fplayer:SetPoint("TOPLEFT", 4, top)
    fplayer:SetText(string.format("%s%s", color, v.name))
    fplayer:Show()

    local froll = FramePool_Get(scrollChild)
    froll:SetPoint("TOPLEFT", w * 0.4, top)
    froll:SetText(string.format("(%d-%d-%d)", string.sub(v.roll,1,1), string.sub(v.roll,2,2), string.sub(v.roll,3,3)))
    froll:Show()

    local sago = math.floor(time() - v.ts)

    local fround = FramePool_Get(scrollChild)
    fround:SetPoint("TOPLEFT", w * 0.6, top)
    fround:SetText(string.format("Manche %d", v.round))
    fround:Show()
	
	local fjet =  FramePool_Get(scrollChild)
	fjet:SetPoint("TOPLEFT", w * 0.8, top)
    fjet:SetText(string.format("Jet# %d", math.floor((v.round/3)+0.5)))
    fjet:Show()

    tinsert(textFrames, fplayer)
    tinsert(textFrames, froll)
    tinsert(textFrames, fround)
	tinsert(textFrames, fjet)
    
	top = top - rowHeight
  end

  -- Put all row frames back in the pool
  for i, frame in pairs(textFrames) do
    FramePool_Put(scrollChild, frame)
  end

  local h = math.abs(top)

  scrollChild:SetSize(w, h)
end

local function Dice_CanRoll()
    -- Don't allow rolling if we already hit 1
  if Dice_GetLastValue("roll", INITIAL_ROLL) <= 1 then
    return false
  end

  local minRound = nil
	

  
  for k, v in pairs(HANDLE.rolls) do
  
  	if isempty(v.roll) then
	return
	end
  
    -- Do not include 1 rolls (losers)
    if v.roll > 1 then
      if minRound then
        minRound = math.min(minRound, v.round)
      else
        minRound = v.round
      end
    end
  end

  -- Always allow rolls if no round started yet
  if not minRound then
    return true
  end

  local myRound = Dice_GetLastValue("round", 0)

  return myRound <= minRound
end

local function Dice_NextRoll()
  --local lastRoll = Dice_GetLastValue("roll", INITIAL_ROLL)

--

	if keepdice3:GetChecked() then
	    print("K3: ".."True")  
	else
	  Dices[1]= math.random(1, 6)
	    print("K3: ".."False")  
	end
	
	if keepdice2:GetChecked() then
	  print("K2: ".."True")  
	else
	  Dices[2]= math.random(1, 6)
	  print("K2: ".."False")  
	end
	
	if keepdice1:GetChecked() then
	   print("K1: ".."True")  
	   
	else
	  Dices[3]= math.random(1, 6)
	  print("K1: ".."False")  
	end

	
	
    table.sort(Dices)
		


  SendChatMessage("joue : -{rt1}"..Dices[3]..Dices[2]..Dices[1].."{rt1}-" ,"EMOTE");
  --421
  if Dices[1]+Dices[2]+Dices[3]==7 and Dices[1]*Dices[2]*Dices[3]==8 then
  SendChatMessage("421 , yeah ! -10 jetons au pot" ,"EMOTE");
  end
  
  --3as
  if Dices[1]+Dices[2]+Dices[3]==3 and Dices[1]*Dices[2]*Dices[3]==1 then
  SendChatMessage("-7 jetons au pot" ,"EMOTE");
  end
  
  --3 Six
   if Dices[1]+Dices[2]+Dices[3]==18 then
  SendChatMessage("-6 jetons au pot" ,"EMOTE");
  end
  
  --deux As 6
  if Dices[1]+Dices[2]+Dices[3]==8 and Dices[1]*Dices[2]*Dices[3]==6 then
  SendChatMessage("-6 jetons au pot" ,"EMOTE");
  end
  --deux As 5
  if Dices[3]==6 and Dices[2] == 1 and Dices[1]==1 then
  SendChatMessage("-5 jetons au pot" ,"EMOTE");
  end
   --deux As 4
  if Dices[3]==4 and Dices[2] == 1 and Dices[1]==1 then
  SendChatMessage("-4 jetons au pot" ,"EMOTE");
  end 
    --deux As 3
  if Dices[3]==3 and Dices[2] == 1 and Dices[1]==1 then
  SendChatMessage("-3 jetons au pot" ,"EMOTE");
  end
    --deux As 2
  if Dices[3]==2 and Dices[2] == 1 and Dices[1]==1 then
  SendChatMessage("-2 jetons au pot" ,"EMOTE");
  end
  
  
  --Nenette
  if Dices[3]==2 and Dices[2] == 2 and Dices[1]==1 then
  SendChatMessage("Outch Nenette +2 jetons DTG" ,"EMOTE");
  end
  
 
  
  --3 Cinq
	if Dices[1] == 5 and  Dices[2] == 5 and Dices[3] == 5 then
    SendChatMessage("-5 jetons au pot" ,"EMOTE");
	end
  --3 Quatre
	if Dices[1] == 4 and  Dices[2] == 4 and Dices[3] == 4 then
    SendChatMessage("-4 jetons au pot" ,"EMOTE");
	end
  --3 Trois
	if Dices[1] == 3 and  Dices[2] == 3 and Dices[3] == 3 then
    SendChatMessage("-2 jetons au pot" ,"EMOTE");
	end
	
  --3 Deux
	if Dices[1] == 2 and  Dices[2] == 2 and Dices[3] == 2 then
    SendChatMessage("-2 jetons au pot" ,"EMOTE");
	end
	
	--Suite
	if Dices[3] == Dices[2]+1 and  Dices[2] == Dices[1]+1  then
    SendChatMessage("Suite : -2 jetons au pot" ,"EMOTE");
	end
  
  
  --SendChatMessage("joue "..Dices[3]..Dices[2]..Dices[1].. " (1-6)","EMOTE")
  imgdice1:SetNormalTexture("Interface\\AddOns\\le421\\images\\"..Dices[3]..".blp")
  imgdice2:SetNormalTexture("Interface\\AddOns\\le421\\images\\"..Dices[2]..".blp")
  imgdice3:SetNormalTexture("Interface\\AddOns\\le421\\images\\"..Dices[1]..".blp")
  keepdice1:SetChecked(false)
  keepdice2:SetChecked(false)
  keepdice3:SetChecked(false)
  keepdice1:Show()
  keepdice2:Show()
  keepdice3:Show()
end




local function Dice_Clear()
  HANDLE.rolls = {}
  Dice_UpdateTable()
  Dice_SetEnabled(HANDLE.RollButton, true)
  keepdice1:SetChecked(false)
  keepdice2:SetChecked(false)
  keepdice3:SetChecked(false)
  imgdice1:SetNormalTexture("Interface\\AddOns\\le421\\images\\1"..".blp")
  imgdice2:SetNormalTexture("Interface\\AddOns\\le421\\images\\1"..".blp")
  imgdice3:SetNormalTexture("Interface\\AddOns\\le421\\images\\1"..".blp")
  keepdice1:Hide()
  keepdice2:Hide()
  keepdice3:Hide()
  
end

local function Dice_CaptureRoll(name, roll, min, max)
  local prev = HANDLE.rolls[name]
  --print (prev)
  local round = 0

  if prev then
    round = prev.round
  end

  round = round + 1

  HANDLE.rolls[name] = {
    name=name,
    roll=roll,
    min=min,
    max=max,
    ts=time(),
    round=round
  }

  Dice_UpdateTable()
  Dice_SetEnabled(HANDLE.RollButton, Dice_CanRoll())
end

local function Dice_ParseChat(msg,name)
  local rx = "^(.+) joue $"
  --print ("Rx:"..msg:match(rx))
  --print("msg:"..msg)
  --print ("pos:".. string.find( msg, "joue" ))
  --local name = UnitName("player");
  --, sroll, smin, smax = msg:match(rx)
  --local name, sroll, smin, smax = msg:match(rx)
  --local roll = tonumber(Dices[3]..Dices[2]..Dices[1])+1-1
  --print (msg)
  
  local roll = tonumber(string.match(msg,"%d%d%d"))
  --print (roll)
  local min = tonumber(6)
  local max = tonumber(1)
  --print(name,roll,min,max)
--name = arg2
	
  if name then
  

    Dice_CaptureRoll(name, roll, min, max)

    -- For testing purposes only
    -- for i=1,3 do
    --   Dice_CaptureRoll(name..i, roll-i, min, max-1)
    -- end
  end
end

local function Dice_OnEvent(frame, event, arg1, arg2, ...)
 
  if event == "CHAT_MSG_EMOTE" then
    
	Dice_ParseChat(string.sub(arg2,1,string.find( arg2, "-" )-1)..arg1,string.sub(arg2,1,string.find( arg2, "-" )-1))
	-- debug.
	--print ("pos -:".. string.find( arg2, "-" ))
	--print(arg2)
	--print(string.sub(arg2,1,string.find( arg2, "-" )-1)) 
	--print("parsechat:",string.sub(arg2,1,string.find( arg2, "-" )-1),arg1)
  end
end

local function Dice_CreateButton(text, parent)
  local btn = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
  btn:SetText(text)
  btn:SetNormalFontObject("GameFontNormal")
  btn:SetHighlightFontObject("GameFontHighlight")
  return btn
end

local function Dice_Create(handle)
  local w = 400
  local h = 400
  
  local frame = CreateFrame("FRAME", "DiceFrame", UIParent, "UIPanelDialogTemplate")
  frame:SetSize(w, h)
  frame:SetPoint("CENTER")

  -- Dialog title
  frame.Title:SetText("4.2.1 by l'ancêtre")

  -- Make frame draggable
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame:Hide()
  

  -- Register for chat events
  frame:RegisterEvent("CHAT_MSG_EMOTE")
  frame:SetScript("OnEvent", Dice_OnEvent)

  -- Scrollable Frame
  local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
  scrollFrame:SetPoint("TOPLEFT", DiceFrameDialogBG, "TOPLEFT", 4, -4)
  scrollFrame:SetPoint("BOTTOMRIGHT", DiceFrameDialogBG, "BOTTOMRIGHT", -22, 82)
  -- scrollFrame:SetClipsChildren(true)

  local scrollChild = CreateFrame("Frame", nil, scrollFrame)

  scrollFrame:SetScrollChild(scrollChild)

  scrollFrame.Child = scrollChild
  frame.ScrollFrame = scrollFrame

  -- Buttons
  local bw = (w - 12) / 2
  local x = 8
  local clearBtn = Dice_CreateButton("Efface", frame)
  clearBtn:SetPoint("BOTTOMLEFT", x, 8)
  clearBtn:SetSize(bw, 22)
  clearBtn:SetScript('OnClick', Dice_Clear)
  

  local rollBtn = Dice_CreateButton("Lancer les dés", frame)
  rollBtn:SetPoint("BOTTOMLEFT", x + bw, 8)
  rollBtn:SetSize(bw, 22)
  rollBtn:SetScript('OnClick', Dice_NextRoll)

  imgdice1 = Dice_CreateButton("", frame)
  imgdice1:SetPoint("BOTTOMLEFT", 25, 65)
  imgdice1:SetSize(40, 40)
  imgdice1:SetScript('OnClick', Dice_Keepdice1)
  imgdice1:SetNormalTexture("Interface\\AddOns\\le421\\images\\1.blp")

  
  imgdice2 = Dice_CreateButton("", frame)
  imgdice2:SetPoint("BOTTOMLEFT", 135, 65)
  imgdice2:SetSize(40, 40)
  imgdice2:SetScript('OnClick', Dice_Keepdice2)
  imgdice2:SetNormalTexture("Interface\\AddOns\\le421\\images\\1.blp")

  
  imgdice3 = Dice_CreateButton("", frame)
  imgdice3:SetPoint("BOTTOMLEFT", 245, 65)
  imgdice3:SetSize(40, 40)
  imgdice3:SetScript('OnClick', Dice_Keepdice3)
  imgdice3:SetNormalTexture("Interface\\AddOns\\le421\\images\\1.blp")

 
 
  keepdice1 = CreateFrame("CheckButton","dice1", frame, "UICheckButtonTemplate")
  keepdice1:SetPoint("BOTTOMLEFT", 25 , 25)
  keepdice1.text = _G["dice1".."Text"]
  keepdice1.text:SetText("Garde Dé 1")

  keepdice1:SetScript("OnClick", function(self,event,arg1) 
	  if self:GetChecked() then
		print("le Dé1("..Dices[3]..")ne sera pas relancé")
		return true
	  else
		print("le Dé1("..Dices[1]..")sera relancé")
		return false
	  end
  
  end)
  keepdice1:Hide()
  
  keepdice2 = CreateFrame("CheckButton","dice2", frame, "UICheckButtonTemplate")
  keepdice2:SetPoint("BOTTOMLEFT", 135 , 25)
  keepdice2.text = _G["dice2".."Text"]
  keepdice2.text:SetText("Garde Dé 2")
  keepdice2:SetScript("OnClick", function(self,event,arg1) 
	  if self:GetChecked() then
		print("le Dé2("..Dices[2]..")ne sera pas relancé")
		return true
	  else
		print("le Dé2("..Dices[2]..")sera relancé")
		return false
	  end
  end)
  keepdice2:Hide()
  
  keepdice3 = CreateFrame("CheckButton","dice3", frame, "UICheckButtonTemplate")
  keepdice3:SetPoint("BOTTOMLEFT", 245 , 25)
  keepdice3.text = _G["dice3".."Text"]
  keepdice3.text:SetText("Garde Dé 3")
  keepdice3:SetScript("OnClick", function(self,event,arg1) 
	  if self:GetChecked() then
		print("le Dé3("..Dices[1]..")ne sera pas relancé")
		return true
	  else
		print("le Dé3("..Dices[1]..")sera relancé")
		return false
	  end
  end)
  keepdice3:Hide()
  
  
  
  handle.Frame = frame
  handle.ClearButton = clearBtn
  handle.RollButton = rollBtn
  
end



local function Dice_Keepdice1(self, event)
		if keepdice1:GetChecked() then
		  keepdice1:SetChecked(true)
		else
		  keepdice1:GetChecked(false)
		end
end
local function Dice_Keepdice2(self, event)
		if keepdice1:GetChecked() then
		  keepdice1:SetChecked(true)
		else
		  keepdice1:GetChecked(false)
		end
end
local function Dice_Keepdice3(self, event)
		if keepdice1:GetChecked() then
		  keepdice1:SetChecked(true)
		else
		  keepdice1:GetChecked(false)
		end
end

Dice_Create(HANDLE)
SlashCmdList["DICE"] = function(msg)
   HANDLE.Frame:Show()
end 

-- DEBUG
HANDLE.Frame:Show()
