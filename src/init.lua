-- SeizureUI.lua
local SeizureUI = {}
SeizureUI.__index = SeizureUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function SeizureUI:CreateWindow(options)
	options = options or {}
	local gui = Instance.new("ScreenGui")
	gui.Name = "SeizureUI"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

	local Window = Instance.new("Frame")
	Window.Name = "Window"
	Window.Parent = gui
	Window.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
	Window.BackgroundTransparency = 1
	Window.BorderSizePixel = 0
	Window.AnchorPoint = Vector2.new(0.5, 0.5)
	Window.Position = UDim2.new(0.5, 0, 0.5, 0)
	Window.Size = isMobile and UDim2.new(0.9, 0, 0, 450) or UDim2.new(0, 834, 0, 500)
	
	local WindowCorner = Instance.new("UICorner")
	WindowCorner.Parent = Window

	local UIScale = Instance.new("UIScale")
	UIScale.Scale = 0
	UIScale.Parent = Window

	-- Title Bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = Window
	TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TitleBar.Size = UDim2.new(1, 0, 0, 51)
	Instance.new("UICorner", TitleBar)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Parent = TitleBar
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0.02, 0, 0.3, 0)
	TitleLabel.Size = UDim2.new(0, 200, 0, 18)
	TitleLabel.Font = Enum.Font.GothamMedium
	TitleLabel.Text = options.Title or "Window"
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Window Control Buttons
	local ButtonsFrame = Instance.new("Frame")
	ButtonsFrame.Name = "Buttons"
	ButtonsFrame.Parent = TitleBar
	ButtonsFrame.BackgroundTransparency = 1
	ButtonsFrame.Size = UDim2.new(0, 180, 1, 0)
	ButtonsFrame.AnchorPoint = Vector2.new(1, 0)
	ButtonsFrame.Position = UDim2.new(1, 0, 0, 0)

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, -10)
	layout.Parent = ButtonsFrame

	local buttons = {}
	local order = 1

	local function createButton(name, imageId, callback)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0, 60, 1, 0)
		btn.BackgroundTransparency = 1
		btn.Text = ""
		btn.LayoutOrder = order
		order = order + 1
		btn.Parent = ButtonsFrame

		local img = Instance.new("ImageLabel")
		img.Parent = btn
		img.AnchorPoint = Vector2.new(0.5, 0.5)
		img.BackgroundTransparency = 1
		img.Position = UDim2.new(0.5, 0, 0.5, 0)
		img.Size = UDim2.new(0, 12, 0, 12)
		img.Image = imageId

		btn.MouseButton1Click:Connect(function()
			if callback then callback() end
		end)

		buttons[name] = btn
	end

	local isMinimized = false
	local isMaximized = false
	local lastSize = Window.Size
	local lastPos = Window.Position

	createButton("Minimize", "http://www.roblox.com/asset/?id=14953689987", function()
		isMinimized = not isMinimized
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		if isMinimized then
			lastSize = Window.Size
			local targetSize = isMobile and UDim2.new(0.9, 0, 0, 51) or UDim2.new(0, 834, 0, 51)
			TweenService:Create(Window, tweenInfo, {Size = targetSize}):Play()
		else
			TweenService:Create(Window, tweenInfo, {Size = lastSize}):Play()
		end
	end)

	createButton("Fullscreen", "http://www.roblox.com/asset/?id=14953690282", function()
		isMaximized = not isMaximized
		local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		if isMaximized then
			lastSize = Window.Size
			lastPos = Window.Position
			local targetSize = isMobile and UDim2.new(1, 0, 0.95, 0) or UDim2.new(1, 0, 1, 0)
			TweenService:Create(Window, tweenInfo, {
				Size = targetSize,
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
		else
			TweenService:Create(Window, tweenInfo, {
				Size = lastSize,
				Position = lastPos
			}):Play()
		end
	end)

	createButton("Close", "http://www.roblox.com/asset/?id=14953690570", function()
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		local closeTween = TweenService:Create(UIScale, tweenInfo, {Scale = 0})
		local fadeTween = TweenService:Create(Window, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
		
		local titleFade = TweenService:Create(TitleBar, TweenInfo.new(0.3), {BackgroundTransparency = 1})
		local textFade = TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextTransparency = 1})
		
		closeTween:Play()
		fadeTween:Play()
		titleFade:Play()
		textFade:Play()
		
		for _, btn in pairs(buttons) do
			local btnFade = TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 1})
			btnFade:Play()
			local img = btn:FindFirstChildOfClass("ImageLabel")
			if img then
				local imgFade = TweenService:Create(img, TweenInfo.new(0.3), {ImageTransparency = 1})
				imgFade:Play()
			end
		end
		
		closeTween.Completed:Connect(function()
			gui:Destroy()
		end)
	end)

	-- Dragging
	local dragging = false
	local dragInput, mousePos, framePos

	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = Window.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	TitleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			Window.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)

	-- Resizing (Desktop only)
	if not isMobile then
		local resizing = false
		local resizeStart, resizeStartSize

		local ResizeHandle = Instance.new("Frame")
		ResizeHandle.Name = "ResizeHandle"
		ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
		ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
		ResizeHandle.BackgroundTransparency = 1
		ResizeHandle.Parent = Window
		ResizeHandle.ZIndex = 10

		local ResizeIcon = Instance.new("TextLabel")
		ResizeIcon.Parent = ResizeHandle
		ResizeIcon.BackgroundTransparency = 1
		ResizeIcon.Size = UDim2.new(1, 0, 1, 0)
		ResizeIcon.Text = "⋰"
		ResizeIcon.TextColor3 = Color3.fromRGB(120, 120, 120)
		ResizeIcon.TextSize = 14
		ResizeIcon.Font = Enum.Font.GothamBold

		local ResizeButton = Instance.new("TextButton")
		ResizeButton.Size = UDim2.new(1, 0, 1, 0)
		ResizeButton.BackgroundTransparency = 1
		ResizeButton.Text = ""
		ResizeButton.Parent = ResizeHandle

		ResizeButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizing = true
				resizeStart = input.Position
				resizeStartSize = Window.AbsoluteSize
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						resizing = false
					end
				end)
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - resizeStart
				local newWidth = math.max(500, resizeStartSize.X + delta.X)
				local newHeight = math.max(350, resizeStartSize.Y + delta.Y)
				Window.Size = UDim2.new(0, newWidth, 0, newHeight)
			end
		end)
	end

	-- Navigation (Icon-based sidebar)
	local NavBar = Instance.new("Frame")
	NavBar.Name = "NavBar"
	NavBar.Parent = Window
	NavBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	NavBar.BorderSizePixel = 0
	NavBar.Position = UDim2.new(0, 0, 0, 51)
	NavBar.Size = UDim2.new(0, 60, 1, -51)
	NavBar.ZIndex = 2
	
	local NavCorner = Instance.new("UICorner")
	NavCorner.Parent = NavBar

	local NavList = Instance.new("ScrollingFrame")
	NavList.Name = "NavList"
	NavList.Parent = NavBar
	NavList.BackgroundTransparency = 1
	NavList.BorderSizePixel = 0
	NavList.Size = UDim2.new(1, 0, 1, 0)
	NavList.CanvasSize = UDim2.new(0, 0, 0, 0)
	NavList.ScrollBarThickness = 0

	local NavLayout = Instance.new("UIListLayout")
	NavLayout.Parent = NavList
	NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NavLayout.Padding = UDim.new(0, 4)
	NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local NavPadding = Instance.new("UIPadding")
	NavPadding.Parent = NavList
	NavPadding.PaddingTop = UDim.new(0, 8)

	-- Content Container
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = Window
	ContentContainer.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	ContentContainer.BorderSizePixel = 0
	ContentContainer.Position = UDim2.new(0, 60, 0, 51)
	ContentContainer.Size = UDim2.new(1, -60, 1, -51)
	ContentContainer.ClipsDescendants = true
	
	local ContentCorner = Instance.new("UICorner")
	ContentCorner.Parent = ContentContainer
	
	local NoCorner1 = Instance.new("Frame")
	NoCorner1.Name = "nocorner"
	NoCorner1.Parent = ContentContainer
	NoCorner1.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	NoCorner1.BorderSizePixel = 0
	NoCorner1.Position = UDim2.new(0, 0, 0, 0)
	NoCorner1.Size = UDim2.new(0, 20, 1, 0)
	
	local NoCorner2 = Instance.new("Frame")
	NoCorner2.Name = "nocorner"
	NoCorner2.Parent = ContentContainer
	NoCorner2.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	NoCorner2.BorderSizePixel = 0
	NoCorner2.Position = UDim2.new(0, 0, 0, 0)
	NoCorner2.Size = UDim2.new(1, 0, 0, 20)

	local tabs = {}

	NavLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		NavList.CanvasSize = UDim2.new(0, 0, 0, NavLayout.AbsoluteContentSize.Y + 16)
	end)

	-- Startup animation
	task.wait(0.05)
	local scaleTween = TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
	local fadeTween = TweenService:Create(Window, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
	
	scaleTween:Play()
	fadeTween:Play()

	local obj = setmetatable({
		Window = Window,
		Buttons = buttons,
		IsMobile = isMobile,
		ContentContainer = ContentContainer,
		NavList = NavList,
		Tabs = tabs,
	}, SeizureUI)

	return obj
end

function SeizureUI:Tab(options)
	options = options or {}
	local name = options.Title or "Tab"
	local iconImage = options.Icon
	
	-- If iconImage is an asset ID string, use it directly
	if type(iconImage) == "string" then
		-- If it doesn't start with rbxassetid://, add it
		if not iconImage:match("rbxassetid://") then
			iconImage = "rbxassetid://" .. iconImage
		end
	elseif not iconImage then
		-- Default icon
		iconImage = "rbxassetid://10723374641"
	end
	
	-- Navigation Button (Icon-only with image)
	local NavButton = Instance.new("TextButton")
	NavButton.Name = name
	NavButton.Parent = self.NavList
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

	-- Hover indicator
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

	-- Tab Content
	local TabContent = Instance.new("ScrollingFrame")
	TabContent.Name = name .. "Content"
	TabContent.Parent = self.ContentContainer
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

	-- Hover effects
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
		for _, tab in pairs(self.Tabs) do
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

	local tab = {
		Button = NavButton,
		Icon = IconImage,
		Indicator = HoverIndicator,
		Content = TabContent,
	}

	table.insert(self.Tabs, tab)

	if #self.Tabs == 1 then
		NavButton:SetAttribute("Selected", true)
		NavButton.BackgroundTransparency = 0.7
		IconImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
		HoverIndicator.Size = UDim2.new(0, 3, 0, 32)
		TabContent.Visible = true
	end

	return setmetatable({
		Content = TabContent,
		Button = NavButton,
	}, {__index = self})
end

function SeizureUI:Slider(options)
	options = options or {}
	local title = options.Title or "Slider"
	local desc = options.Desc
	local step = options.Step or 1
	local valueOptions = options.Value or {}
	local min = valueOptions.Min or 0
	local max = valueOptions.Max or 100
	local default = valueOptions.Default or min
	local callback = options.Callback or function() end

	local SliderFrame = Instance.new("Frame")
	SliderFrame.Name = title
	SliderFrame.Parent = self.Content
	SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	SliderFrame.BorderSizePixel = 0
	SliderFrame.Size = desc and UDim2.new(1, -13, 0, 70) or UDim2.new(1, -13, 0, 50)

	local SliderCorner = Instance.new("UICorner")
	SliderCorner.CornerRadius = UDim.new(0, 6)
	SliderCorner.Parent = SliderFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Parent = SliderFrame
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 12, 0, 8)
	TitleLabel.Size = UDim2.new(1, -24, 0, 16)
	TitleLabel.Font = Enum.Font.GothamMedium
	TitleLabel.Text = title
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 13
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Parent = SliderFrame
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Position = UDim2.new(1, -60, 0, 8)
	ValueLabel.Size = UDim2.new(0, 48, 0, 16)
	ValueLabel.Font = Enum.Font.GothamMedium
	ValueLabel.Text = tostring(default)
	ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	ValueLabel.TextSize = 12
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

	if desc then
		local DescLabel = Instance.new("TextLabel")
		DescLabel.Parent = SliderFrame
		DescLabel.BackgroundTransparency = 1
		DescLabel.Position = UDim2.new(0, 12, 0, 26)
		DescLabel.Size = UDim2.new(1, -24, 0, 14)
		DescLabel.Font = Enum.Font.Gotham
		DescLabel.Text = desc
		DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		DescLabel.TextSize = 11
		DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	end

	local sliderYPos = desc and 48 or 32

	local SliderBar = Instance.new("Frame")
	SliderBar.Name = "SliderBar"
	SliderBar.Parent = SliderFrame
	SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	SliderBar.BorderSizePixel = 0
	SliderBar.Position = UDim2.new(0, 12, 0, sliderYPos)
	SliderBar.Size = UDim2.new(1, -24, 0, 6)

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = SliderBar

	local SliderFill = Instance.new("Frame")
	SliderFill.Name = "Fill"
	SliderFill.Parent = SliderBar
	SliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	SliderFill.BorderSizePixel = 0
	SliderFill.Size = UDim2.new(0, 0, 1, 0)

	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = SliderFill

	local SliderButton = Instance.new("TextButton")
	SliderButton.Parent = SliderBar
	SliderButton.BackgroundTransparency = 1
	SliderButton.Size = UDim2.new(1, 0, 1, 0)
	SliderButton.Text = ""

	local dragging = false
	local currentValue = default

	local function roundToStep(value)
		if step < 1 then
			local multiplier = 1 / step
			return math.floor(value * multiplier + 0.5) / multiplier
		else
			return math.floor(value / step + 0.5) * step
		end
	end

	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
		local rawValue = min + (max - min) * pos
		currentValue = roundToStep(rawValue)
		currentValue = math.clamp(currentValue, min, max)
		
		ValueLabel.Text = tostring(currentValue)
		local actualPos = (currentValue - min) / (max - min)
		TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(actualPos, 0, 1, 0)}):Play()
		callback(currentValue)
	end

	local function setInitialValue()
		local pos = (default - min) / (max - min)
		SliderFill.Size = UDim2.new(pos, 0, 1, 0)
		ValueLabel.Text = tostring(default)
		currentValue = default
	end

	setInitialValue()

	SliderButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateSlider(input)
		end
	end)

	SliderButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)

	return {
		SetValue = function(value)
			currentValue = math.clamp(roundToStep(value), min, max)
			ValueLabel.Text = tostring(currentValue)
			local pos = (currentValue - min) / (max - min)
			TweenService:Create(SliderFill, TweenInfo.new(0.2), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
			callback(currentValue)
		end
	}
end

function SeizureUI:Paragraph(options)
	options = options or {}
	local title = options.Title or "Paragraph"
	local content = options.Content or "Paragraph content"

	local ParagraphFrame = Instance.new("Frame")
	ParagraphFrame.Name = title
	ParagraphFrame.Parent = self.Content
	ParagraphFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ParagraphFrame.BorderSizePixel = 0
	ParagraphFrame.Size = UDim2.new(1, -13, 0, 0)
	ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y

	local ParagraphCorner = Instance.new("UICorner")
	ParagraphCorner.CornerRadius = UDim.new(0, 6)
	ParagraphCorner.Parent = ParagraphFrame

	local ParagraphPadding = Instance.new("UIPadding")
	ParagraphPadding.Parent = ParagraphFrame
	ParagraphPadding.PaddingTop = UDim.new(0, 12)
	ParagraphPadding.PaddingBottom = UDim.new(0, 12)
	ParagraphPadding.PaddingLeft = UDim.new(0, 12)
	ParagraphPadding.PaddingRight = UDim.new(0, 12)

	local Texts = Instance.new("Frame")
	Texts.Name = "Texts"
	Texts.Parent = ParagraphFrame
	Texts.BackgroundTransparency = 1
	Texts.Size = UDim2.new(1, 0, 0, 0)
	Texts.AutomaticSize = Enum.AutomaticSize.Y

	local TextsLayout = Instance.new("UIListLayout")
	TextsLayout.Parent = Texts
	TextsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TextsLayout.Padding = UDim.new(0, 4)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Label"
	TitleLabel.Parent = Texts
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, 0, 0, 0)
	TitleLabel.AutomaticSize = Enum.AutomaticSize.Y
	TitleLabel.Font = Enum.Font.Gotham
	TitleLabel.Text = title
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 14
	TitleLabel.TextWrapped = true
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextYAlignment = Enum.TextYAlignment.Top

	local ContentLabel = Instance.new("TextLabel")
	ContentLabel.Name = "Description"
	ContentLabel.Parent = Texts
	ContentLabel.BackgroundTransparency = 1
	ContentLabel.Size = UDim2.new(1, 0, 0, 0)
	ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
	ContentLabel.Font = Enum.Font.Gotham
	ContentLabel.Text = content
	ContentLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	ContentLabel.TextSize = 13
	ContentLabel.TextWrapped = true
	ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
	ContentLabel.TextYAlignment = Enum.TextYAlignment.Top

	return {
		SetTitle = function(newTitle)
			TitleLabel.Text = newTitle
		end,
		SetContent = function(newContent)
			ContentLabel.Text = newContent
		end
	}
end

function SeizureUI:DisableTopbarButtons(list)
	for _, name in ipairs(list) do
		if self.Buttons[name] then
			self.Buttons[name].Visible = false
		end
	end
end

return SeizureUI
