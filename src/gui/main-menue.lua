---------------------------------
-- Window
---------------------------------

ClassicLFG.QueueWindow = CreateFrame("Frame", "ClassicLFGQueueWindow", UIParent, "UIPanelDialogTemplate")
ClassicLFG.QueueWindow:SetSize(400, 600)
ClassicLFG.QueueWindow:SetPoint("CENTER", UIParent, "CENTER")

ClassicLFG.QueueWindow:SetScript("OnMouseDown", function()
	ClassicLFG.QueueWindow:SetMovable(true)
	ClassicLFG.QueueWindow:StartMoving(ClassicLFG.QueueWindow)
end)

ClassicLFG.QueueWindow:SetScript("OnMouseUp", function()
	ClassicLFG.QueueWindow:StopMovingOrSizing()
	ClassicLFG.QueueWindow:SetMovable(false)
end)

---------------------------------
-- Window - Title
---------------------------------

ClassicLFG.QueueWindow.Title:ClearAllPoints();
ClassicLFG.QueueWindow.Title:SetFontObject("GameFontHighlight");
ClassicLFG.QueueWindow.Title:SetPoint("LEFT", ClassicLFGQueueWindowTitleBG, "LEFT", 6, 1);
ClassicLFG.QueueWindow.Title:SetText("ClassicLFG");

---------------------------------
-- Window - Tabs
---------------------------------

ClassicLFG.QueueWindow.Tab_OnClick = function(self)
	for key in pairs(self:GetParent().Tabs) do
		self:GetParent().Tabs[key].content:Hide()
	end
	PanelTemplates_SetTab(self:GetParent(), self:GetID());
	self.content:Show()
	PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON)
end

local function SetTabs(frame, numTabs, ...)
	frame.numTabs = numTabs;
	frame.Tabs = {}
	local contents = {};
	local frameName = frame:GetName();
	
	for i = 1, numTabs do	
		local tab = CreateFrame("Button", frameName.."Tab"..i, frame, "CharacterFrameTabButtonTemplate");
		tab:SetID(i);
		tab:SetText(select(i, ...));
		tab:SetScript("OnClick", ClassicLFG.QueueWindow.Tab_OnClick);
		
		tab.content = CreateFrame("Frame", nil, ClassicLFG.QueueWindow, nil)
		tab.content:SetPoint("TOPLEFT", ClassicLFGQueueWindowDialogBG, "TOPLEFT", 0, 0)
		tab.content:SetPoint("BOTTOMRIGHT", ClassicLFGQueueWindowDialogBG, "BOTTOMRIGHT", 0, 0)
		tab.content:Hide()
		
		table.insert(contents, tab.content);
		table.insert(frame.Tabs, tab)

		if (i == 1) then
			tab:SetPoint("TOPLEFT", ClassicLFG.QueueWindow, "BOTTOMLEFT", 5, 7);
		else
			tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i - 1)], "TOPRIGHT", -14, 0);
		end	
	end
	
	ClassicLFG.QueueWindow.Tab_OnClick(_G[frameName.."Tab1"]);
	
	return unpack(contents);
end

ClassicLFG.QueueWindow.SearchGroup, ClassicLFG.QueueWindow.CreateGroup, ClassicLFG.QueueWindow.Settings = SetTabs(ClassicLFG.QueueWindow, 3, ClassicLFG.Locale["Search Group"], ClassicLFG.Locale["Create Group"], ClassicLFG.Locale["Settings"])
ClassicLFG.QueueWindow:Hide()