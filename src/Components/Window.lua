local Window = {}
Window.__index = Window

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Tab = require("Components/Tab")

function Window.new(options)
	options = options or {}
	
	local self = setmetatable({}, Window)
	
	local gui = Instance.new("ScreenGui")
	gui.Name = "SeizureUI"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

	local WindowFrame = Instance.new("Frame")
	WindowFrame.Name = "Window"
	WindowFrame.Parent = gui
	WindowFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
	WindowFrame.BackgroundTransparency = 1
	WindowFrame.BorderSizePixel = 0
	WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	WindowFrame.Size = isMobile and UDim2.new(0.9, 0, 0, 450) or UDim2.new(0, 834, 0, 500)
	
	local WindowCorner = Instance.new("UICorner")
	WindowCorner.Parent = WindowFrame

	local UIScale = Instance.new("UIScale")
	UIScale.Scale = 0
	UIScale.Parent = WindowFrame

	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = WindowFrame
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
	local lastSize = WindowFrame.Size
	local lastPos = WindowFrame.Position

	createButton("Minimize", "http://www.roblox.com/asset/?id=14953689987", function()
		isMinimized = not isMinimized
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		if isMinimized then
			lastSize = WindowFrame.Size
			local targetSize = isMobile and UDim2.new(0.9, 0, 0, 51) or UDim2.new(0, 834, 0, 51)
			TweenService:Create(WindowFrame, tweenInfo, {Size = targetSize}):Play()
		else
			TweenService:Create(WindowFrame, tweenInfo, {Size = lastSize}):Play()
		end
	end)

	createButton("Fullscreen", "http://www.roblox.com/asset/?id=14953690282", function()
		isMaximized = not isMaximized
		local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		if isMaximized then
			lastSize = WindowFrame.Size
			lastPos = WindowFrame.Position
			local targetSize = isMobile and UDim2.new(1, 0, 0.95, 0) or UDim2.new(1, 0, 1, 0)
			TweenService:Create(WindowFrame, tweenInfo, {
				Size = targetSize,
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
		else
			TweenService:Create(WindowFrame, tweenInfo, {
				Size = lastSize,
				Position = lastPos
			}):Play()
		end
	end)

	createButton("Close", "http://www.roblox.com/asset/?id=14953690570", function()
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		local closeTween = TweenService:Create(UIScale, tweenInfo, {Scale = 0})
		local fadeTween = TweenService:Create(WindowFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
		
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

	local dragging = false
	local dragInput, mousePos, framePos

	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = WindowFrame.Position
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
			WindowFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)

	if not isMobile then
		local resizing = false
		local resizeStart, resizeStartSize

		local ResizeHandle = Instance.new("Frame")
		ResizeHandle.Name = "ResizeHandle"
		ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
		ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
		ResizeHandle.BackgroundTransparency = 1
		ResizeHandle.Parent = WindowFrame
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
				resizeStartSize = WindowFrame.AbsoluteSize
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
				WindowFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
			end
		end)
	end

	local NavBar = Instance.new("Frame")
	NavBar.Name = "NavBar"
	NavBar.Parent = WindowFrame
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

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = WindowFrame
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

	task.wait(0.05)
	local scaleTween = TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
	local fadeTween = TweenService:Create(WindowFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
	
	scaleTween:Play()
	fadeTween:Play()

	self.Window = WindowFrame
	self.Buttons = buttons
	self.IsMobile = isMobile
	self.ContentContainer = ContentContainer
	self.NavList = NavList
	self.Tabs = tabs

	return self
end

function Window:Tab(options)
	return Tab.new(self, options)
end

function Window:DisableTopbarButtons(list)
	for _, name in ipairs(list) do
		if self.Buttons[name] then
			self.Buttons[name].Visible = false
		end
	end
end

return Window
