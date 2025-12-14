local Tab = {}
Tab.__index = Tab

local TweenService = game:GetService("TweenService")

local Slider = require("Components/Slider")
local Paragraph = require("Components/Paragraph")

function Tab.new(window, options)
	options = options or {}
	local name = options.Title or "Tab"
	local iconImage = options.Icon
	
	if type(iconImage) == "string" then
		if not iconImage:match("rbxassetid://") then
			iconImage = "rbxassetid://" .. iconImage
		end
	elseif not iconImage then
		iconImage = "rbxassetid://10723374641"
	end
	
	local self = setmetatable({}, Tab)
	
	local NavButton = Instance.new("TextButton")
	NavButton.Name = name
	NavButton.Parent = window.NavList
	NavButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	NavButton.BackgroundTransparency = 1
	NavButton.BorderSizePixel = 0
	NavButton.Size = UDim2.new(0, 48, 0, 48)
	NavButton.AutoButtonColor = false
	NavButton.Text = ""
	
	local NavCorner = Instance.new("UICorner")
	NavCorner.CornerRadius = UDim.new(0, 8)
	NavCorner.Parent = NavButton

	local IconImage = Instance.new("ImageLabel")
	IconImage.Parent = NavButton
	IconImage.BackgroundTransparency = 1
	IconImage.BorderSizePixel = 0
	IconImage.Position = UDim2.new(0.25, 0, 0.25, 0)
	IconImage.Size = UDim2.new(0.5, 0, 0.5, 0)
	IconImage.Image = iconImage
	IconImage.ImageColor3 = Color3.fromRGB(200, 200, 200)

	local HoverIndicator = Instance.new("Frame")
	HoverIndicator.Name = "Indicator"
	HoverIndicator.Parent = NavButton
	HoverIndicator.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	HoverIndicator.BorderSizePixel = 0
	HoverIndicator.Position = UDim2.new(0, -4, 0.5, 0)
	HoverIndicator.Size = UDim2.new(0, 3, 0, 0)
	HoverIndicator.AnchorPoint = Vector2.new(0, 0.5)
	
	local IndicatorCorner = Instance.new("UICorner")
	IndicatorCorner.CornerRadius = UDim.new(1, 0)
	IndicatorCorner.Parent = HoverIndicator

	local TabContent = Instance.new("ScrollingFrame")
	TabContent.Name = name .. "Content"
	TabContent.Parent = window.ContentContainer
	TabContent.BackgroundTransparency = 1
	TabContent.BorderSizePixel = 0
	TabContent.Size = UDim2.new(1, 0, 1, 0)
	TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabContent.ScrollBarThickness = 6
	TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
	TabContent.Visible = false

	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.Parent = TabContent
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Padding = UDim.new(0, 12)

	local ContentPadding = Instance.new("UIPadding")
	ContentPadding.Parent = TabContent
	ContentPadding.PaddingTop = UDim.new(0, 7)
	ContentPadding.PaddingBottom = UDim.new(0, 16)
	ContentPadding.PaddingLeft = UDim.new(0, 7)
	ContentPadding.PaddingRight = UDim.new(0, 20)

	ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 32)
	end)

	NavButton.MouseEnter:Connect(function()
		if not NavButton:GetAttribute("Selected") then
			TweenService:Create(NavButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
		end
	end)

	NavButton.MouseLeave:Connect(function()
		if not NavButton:GetAttribute("Selected") then
			TweenService:Create(NavButton, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		end
	end)

	NavButton.MouseButton1Click:Connect(function()
		for _, tab in pairs(window.Tabs) do
			tab.Button:SetAttribute("Selected", false)
			TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			TweenService:Create(tab.Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play()
			TweenService:Create(tab.Indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
			tab.Content.Visible = false
		end
		
		NavButton:SetAttribute("Selected", true)
		TweenService:Create(NavButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
		TweenService:Create(IconImage, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		TweenService:Create(HoverIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 32)}):Play()
		TabContent.Visible = true
	end)

	local tabData = {
		Button = NavButton,
		Icon = IconImage,
		Indicator = HoverIndicator,
		Content = TabContent,
	}

	table.insert(window.Tabs, tabData)

	if #window.Tabs == 1 then
		NavButton:SetAttribute("Selected", true)
		NavButton.BackgroundTransparency = 0.7
		IconImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
		HoverIndicator.Size = UDim2.new(0, 3, 0, 32)
		TabContent.Visible = true
	end

	self.Content = TabContent
	self.Button = NavButton
	self.Window = window

	return self
end

function Tab:Slider(options)
	return Slider.new(self, options)
end

function Tab:Paragraph(options)
	return Paragraph.new(self, options)
end

return Tab
