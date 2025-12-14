local SeizureUI = {}
SeizureUI.__index = SeizureUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function SeizureUI:CreateWindow(options)
	options = options or {}
	local gui = Instance.new("ScreenGui")
	gui.Name = "SeizureUI"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	if syn and syn.protect_gui then
		syn.protect_gui(gui)
		gui.Parent = game:GetService("CoreGui")
	elseif getgenv and getgenv().gethui then
		gui.Parent = getgenv().gethui()
	else
		gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

	local Window = Instance.new("Frame")
	Window.Name = "Window"
	Window.Parent = gui
	Window.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
	Window.BackgroundTransparency = 0
	Window.BorderSizePixel = 0
	Window.AnchorPoint = Vector2.new(0.5, 0.5)
	Window.Position = UDim2.new(0.5, 0, 0.5, 0)
	Window.Size = isMobile and UDim2.new(0.9, 0, 0, 450) or UDim2.new(0, 834, 0, 500)

	local WindowCorner = Instance.new("UICorner")
	WindowCorner.Parent = Window

	local UIScale = Instance.new("UIScale")
	UIScale.Scale = 0
	UIScale.Parent = Window

	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = Window
	TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TitleBar.Size = UDim2.new(1, 0, 0, 51)

	local TitleCorner = Instance.new("UICorner")
	TitleCorner.Parent = TitleBar

	local TitleNoCorner = Instance.new("Frame")
	TitleNoCorner.Name = "NoCorner"
	TitleNoCorner.Parent = TitleBar
	TitleNoCorner.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TitleNoCorner.BorderSizePixel = 0
	TitleNoCorner.Position = UDim2.new(0, 0, 0.8, 0)
	TitleNoCorner.Size = UDim2.new(1, 0, 0.2, 0)

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

		closeTween:Play()

		closeTween.Completed:Connect(function()
			gui:Destroy()
		end)
	end)

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
			local targetPos = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
			TweenService:Create(Window, TweenInfo.new(0.1), {Position = targetPos}):Play()
		end
	end)

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

	local NavNoCorner = Instance.new("Frame")
	NavNoCorner.Parent = NavBar
	NavNoCorner.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	NavNoCorner.BorderSizePixel = 0
	NavNoCorner.Position = UDim2.new(0.5, 0, 0, 0)
	NavNoCorner.Size = UDim2.new(0.5, 0, 1, 0)
	NavNoCorner.ZIndex = 1

	local NavList = Instance.new("ScrollingFrame")
	NavList.Name = "NavList"
	NavList.Parent = NavBar
	NavList.BackgroundTransparency = 1
	NavList.BorderSizePixel = 0
	NavList.Size = UDim2.new(1, 0, 1, 0)
	NavList.CanvasSize = UDim2.new(0, 0, 0, 0)
	NavList.ScrollBarThickness = 0
	NavList.ZIndex = 3

	local NavLayout = Instance.new("UIListLayout")
	NavLayout.Parent = NavList
	NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NavLayout.Padding = UDim.new(0, 4)
	NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local NavPadding = Instance.new("UIPadding")
	NavPadding.Parent = NavList
	NavPadding.PaddingTop = UDim.new(0, 8)

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = Window
	ContentContainer.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	ContentContainer.BorderSizePixel = 0
	ContentContainer.ClipsDescendants = true
	ContentContainer.Position = UDim2.new(0, 60, 0, 51)
	ContentContainer.Size = UDim2.new(1, -60, 1, -51)

	local ContentCorner = Instance.new("UICorner")
	ContentCorner.Parent = ContentContainer

	local ContentNoCorner = Instance.new("Frame")
	ContentNoCorner.Name = "NoCorner"
	ContentNoCorner.Parent = ContentContainer
	ContentNoCorner.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	ContentNoCorner.BorderSizePixel = 0
	ContentNoCorner.Size = UDim2.new(0, 10, 0, 10)
	ContentNoCorner.Position = UDim2.new(0, 0, 0, 0)

	local tabs = {}

	NavLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		NavList.CanvasSize = UDim2.new(0, 0, 0, NavLayout.AbsoluteContentSize.Y + 16)
	end)

	local scaleTween = TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
	scaleTween:Play()

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

function SeizureUI:CreateTab(options)
	options = options or {}
	local name = options.Title or "Tab"
	local iconImage = options.Icon or "rbxassetid://17303957207"

	local NavButton = Instance.new("TextButton")
	NavButton.Name = name
	NavButton.Parent = self.NavList
	NavButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	NavButton.BackgroundTransparency = 1
	NavButton.BorderSizePixel = 0
	NavButton.Size = UDim2.new(0, 48, 0, 48)
	NavButton.AutoButtonColor = false
	NavButton.Text = ""
	NavButton.ZIndex = 5

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
	IconImage.ZIndex = 6

	local HoverIndicator = Instance.new("Frame")
	HoverIndicator.Name = "Indicator"
	HoverIndicator.Parent = NavButton
	HoverIndicator.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	HoverIndicator.BorderSizePixel = 0
	HoverIndicator.Position = UDim2.new(0, -4, 0.5, 0)
	HoverIndicator.Size = UDim2.new(0, 3, 0, 0)
	HoverIndicator.AnchorPoint = Vector2.new(0, 0.5)
	HoverIndicator.ZIndex = 6

	local IndicatorCorner = Instance.new("UICorner")
	IndicatorCorner.CornerRadius = UDim.new(1, 0)
	IndicatorCorner.Parent = HoverIndicator

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
		TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + ContentPadding.PaddingTop.Offset + ContentPadding.PaddingBottom.Offset)
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

function SeizureUI:CreateParagraph(options)
	options = options or {}
	local title = options.Title or "Paragraph"
	local content = options.Content or "Content"

	local Paragraph = Instance.new("Frame")
	Paragraph.Name = "Paragraph"
	Paragraph.Parent = self.Content
	Paragraph.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Paragraph.BorderSizePixel = 0
	Paragraph.Size = UDim2.new(1, 0, 0, 0)
	Paragraph.AutomaticSize = Enum.AutomaticSize.Y

	local ParagraphCorner = Instance.new("UICorner")
	ParagraphCorner.Parent = Paragraph
	ParagraphCorner.CornerRadius = UDim.new(0, 8)

	local ParagraphPadding = Instance.new("UIPadding")
	ParagraphPadding.Parent = Paragraph
	ParagraphPadding.PaddingBottom = UDim.new(0, 12)
	ParagraphPadding.PaddingLeft = UDim.new(0, 12)
	ParagraphPadding.PaddingRight = UDim.new(0, 12)
	ParagraphPadding.PaddingTop = UDim.new(0, 12)

	local Texts = Instance.new("Frame")
	Texts.Name = "Texts"
	Texts.Parent = Paragraph
	Texts.BackgroundTransparency = 1.000
	Texts.Size = UDim2.new(1, 0, 0, 0)
	Texts.AutomaticSize = Enum.AutomaticSize.Y

	local TextsLayout = Instance.new("UIListLayout")
	TextsLayout.Parent = Texts
	TextsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TextsLayout.Padding = UDim.new(0, 4)

	local Label = Instance.new("TextLabel")
	Label.Name = "Label"
	Label.Parent = Texts
	Label.BackgroundTransparency = 1.000
	Label.Size = UDim2.new(1, 0, 0, 0)
	Label.AutomaticSize = Enum.AutomaticSize.Y
	Label.Font = Enum.Font.Gotham
	Label.Text = title
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 14.000
	Label.TextWrapped = true
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local Description = Instance.new("TextLabel")
	Description.Name = "Description"
	Description.Parent = Texts
	Description.BackgroundTransparency = 1.000
	Description.Size = UDim2.new(1, 0, 0, 0)
	Description.AutomaticSize = Enum.AutomaticSize.Y
	Description.Font = Enum.Font.Gotham
	Description.Text = content
	Description.TextColor3 = Color3.fromRGB(150, 150, 150)
	Description.TextSize = 13.000
	Description.TextWrapped = true
	Description.TextXAlignment = Enum.TextXAlignment.Left

	local ParagraphHandler = {}

	function ParagraphHandler:Set(newTitle, newContent)
		Label.Text = newTitle or Label.Text
		Description.Text = newContent or Description.Text
	end

	return ParagraphHandler
end

function SeizureUI:DisableTopbarButtons(list)
	for _, name in ipairs(list) do
		if self.Buttons[name] then
			self.Buttons[name].Visible = false
		end
	end
end

return SeizureUI
