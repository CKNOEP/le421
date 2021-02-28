

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
  local top_top = -4
  local rowHeight = 18

  -- Hide all previous row frames
  for i, frame in pairs(FramePool_All(scrollChild)) do
   frame:Hide() 
  end
--print (v.roll)

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
    fround:SetText(string.format("Nb Jet: %d", v.round))
    fround:Show()
	
	local fjet =  FramePool_Get(scrollChild)
	fjet:SetPoint("TOPLEFT", w * 0.8, top)
    fjet:SetText(string.format("Jetons: %d", Score))
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
 if minRound >= 3 then
 --print(minRound)
 return false
 end
  -- Always allow rolls if no round started yet
  if not minRound then
    return true
  end

  local myRound = Dice_GetLastValue("round", 0)

  return myRound <= minRound
end
local function Dice_SkeepNextRoll()
 validateBtn:Hide()
 rollBtn:Hide()
 SendChatMessage("Passe : *{rt1}"..Dices[3]..Dices[2]..Dices[1].."{rt1}*","EMOTE")
end
local function Dice_NextRoll()
  --local lastRoll = Dice_GetLastValue("roll", INITIAL_ROLL)

--

	if keepdice3:GetChecked() then
	   -- print("K3: ".."True")  
	  
	else
	  Dices[1]= math.random(1, 6)
	  --  print("K3: ".."False")  
	end
	
	if keepdice2:GetChecked() then
	  --print("K2: ".."True")
	  
	else
	  Dices[2]= math.random(1, 6)
	  --print("K2: ".."False")  
	end
	
	if keepdice1:GetChecked() then
	  -- print("K1: ".."True")  
	  
	else
	  Dices[3]= math.random(1, 6)
	  --print("K1: ".."False")  
	end

	
	
    table.sort(Dices)
		

ScoreMessage=""
 
  --421
  if Dices[1]+Dices[2]+Dices[3]==7 and Dices[1]*Dices[2]*Dices[3]==8 then
  ScoreMessage ="421 , yeah ! -10 jetons au pot"
  Score = -10
  end
  
  --3as
  if Dices[1]+Dices[2]+Dices[3]==3 and Dices[1]*Dices[2]*Dices[3]==1 then
 ScoreMessage ="-7 jetons au pot"
    Score = -7
  end
  
  --3 Six
   if Dices[1]+Dices[2]+Dices[3]==18 then
  ScoreMessage ="-6 jetons au pot"
    Score = -6
  end
  
  --deux As 6
  if Dices[1]+Dices[2]+Dices[3]==8 and Dices[1]*Dices[2]*Dices[3]==6 then
  ScoreMessage ="-6 jetons au pot"
    Score = -6
  end
  --deux As 5
  if Dices[3]==5 and Dices[2] == 1 and Dices[1]==1 then
  ScoreMessage ="-5 jetons au pot"
    Score = -5
  end
   --deux As 4
  if Dices[3]==4 and Dices[2] == 1 and Dices[1]==1 then
  ScoreMessage ="-4 jetons au pot"
    Score = -2
  end 
    --deux As 3
  if Dices[3]==3 and Dices[2] == 1 and Dices[1]==1 then
  ScoreMessage ="-3 jetons au pot"
    Score = -3
  end
    --deux As 2
  if Dices[3]==2 and Dices[2] == 1 and Dices[1]==1 then
 ScoreMessage ="-2 jetons au pot"
   Score = -2
  end
  
  
  --Nenette
  if Dices[3]==2 and Dices[2] == 2 and Dices[1]==1 then
  ScoreMessage ="Outch Nenette +2 jetons DTG"
   Score = 2
  end
  
 
  
  --3 Cinq
	if Dices[1] == 5 and  Dices[2] == 5 and Dices[3] == 5 then
	ScoreMessage ="-5 jetons au pot"
	Score = -5
	end
	  
  --3 Quatre
	if Dices[1] == 4 and  Dices[2] == 4 and Dices[3] == 4 then
	ScoreMessage ="-4 jetons au pot"
	Score = -4
	end
	  
  --3 Trois
	if Dices[1] == 3 and  Dices[2] == 3 and Dices[3] == 3 then
    ScoreMessage ="-2 jetons au pot"
	Score = -3
	end
	  
	
  --3 Deux
	if Dices[1] == 2 and  Dices[2] == 2 and Dices[3] == 2 then
    ScoreMessage ="-2 jetons au pot"
	 Score = -2
	 end
	 
	
	--Suite
	if Dices[3] == Dices[2]+1 and  Dices[2] == Dices[1]+1  then
    ScoreMessage ="Suite : -2 jetons au pot"
	  Score = -2
	end
	
	  
  
  SendChatMessage("joue : -{rt1}"..Dices[3]..Dices[2]..Dices[1].."{rt1}-".."  //   " ..ScoreMessage ,"EMOTE");
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
  validateBtn:Show()
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
  validateBtn:Hide()
  rollBtn:Show()
  keepdice1:Hide()
  keepdice2:Hide()
  keepdice3:Hide()
  
end
local function switch_Keepdice1()
		
	if keepdice1:IsShown() == false then
		return
		else
		if keepdice1:GetChecked() == true then
		keepdice1:SetChecked(false)
		else
		keepdice1:SetChecked(true)
		end
		print(keepdice1:GetChecked())
	end
end
local function switch_Keepdice2()
		
	if keepdice2:IsShown() == false then
		return
		else
		if keepdice2:GetChecked() == true then
		keepdice2:SetChecked(false)
		else
		keepdice2:SetChecked(true)
		end
		print(keepdice2:GetChecked())
	end
end
local function switch_Keepdice3()
		
	if keepdice3:IsShown() == false then
		return
		else
		if keepdice3:GetChecked() == true then
		keepdice3:SetChecked(false)
		else
		keepdice3:SetChecked(true)
		end
		print(keepdice3:GetChecked())
	end
end
local function Dice_CaptureRoll(name, roll, min, max, passe)
  local prev = HANDLE.rolls[name]
  --print (prev)
  local round = 0

  if prev then
    round = prev.round
  end

	if passe =="Passe" then
	round=round 
	else
	round = round + 1
	end

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
  Dice_SetEnabled(HANDLE.validateBtn, Dice_CanRoll())
end

local function Dice_ParseChat(msg,name)
  local rx = "^(.+) joue $"
  local passe = string.match(msg,"Pass.")
  
  
  local roll = tonumber(string.match(msg,"%d%d%d"))
  --print (roll)
  local min = tonumber(6)
  local max = tonumber(1)

	
  if name then
  

    Dice_CaptureRoll(name, roll, min, max, passe)

  end
end

local function Dice_OnEvent(frame, event, arg1, arg2, ...)
 
  if event == "CHAT_MSG_EMOTE" then
    
	Dice_ParseChat(string.sub(arg2,1,string.find( arg2, "-" )-1)..arg1,string.sub(arg2,1,string.find( arg2, "-" )-1))

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
  frame.Title:SetText("4.2.1 by l'ancêtre, /421 pour lancer une partie ")

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
  local bw = (w - 12) / 3
  local x = 8
  
  
  local clearBtn = Dice_CreateButton("Nvelle partie", frame)
  clearBtn:SetPoint("BOTTOMLEFT", 8, 8)
  clearBtn:SetSize(bw, 22)
  clearBtn:SetScript('OnClick', Dice_Clear)
  
  rollBtn = Dice_CreateButton("Lancer les dés", frame)
  rollBtn:SetPoint("BOTTOMRIGHT", -8, 8)
  rollBtn:SetSize(bw, 22)
  rollBtn:SetScript('OnClick', Dice_NextRoll)
  
  validateBtn = Dice_CreateButton("Valider les dés", frame)
  validateBtn:SetPoint("BOTTOM", 0 , 8)
  validateBtn:SetSize(bw, 22)
  validateBtn:SetScript('OnClick', Dice_SkeepNextRoll)
  validateBtn:Disable()

  -- Dices Images	
  imgdice1 = Dice_CreateButton("", frame)
  imgdice1:SetPoint("BOTTOMLEFT", 25, 65)
  imgdice1:SetSize(40, 40)
  imgdice1:SetScript('OnClick', switch_Keepdice1)
  imgdice1:SetNormalTexture("Interface\\AddOns\\le421\\images\\1.blp")

  
  imgdice2 = Dice_CreateButton("", frame)
  imgdice2:SetPoint("BOTTOMLEFT", 135, 65)
  imgdice2:SetSize(40, 40)
  imgdice2:SetScript('OnClick', switch_Keepdice2)
  imgdice2:SetNormalTexture("Interface\\AddOns\\le421\\images\\1.blp")

  
  imgdice3 = Dice_CreateButton("", frame)
  imgdice3:SetPoint("BOTTOMLEFT", 245, 65)
  imgdice3:SetSize(40, 40)
  imgdice3:SetScript('OnClick', switch_Keepdice3)
  imgdice3:SetNormalTexture("Interface\\AddOns\\le421\\images\\1.blp")

 -- Option Keep the dice
 
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
  handle.validateBtn = validateBtn
  
end


local function switch_Keepdice2()
	print ("keep2")

end
local function switch_Keepdice3()
	print ("keep3")

end

Dice_Create(HANDLE)
SlashCmdList["DICE"] = function(msg)
   HANDLE.Frame:Show()
end 

-- DEBUG
--HANDLE.Frame:Show()
