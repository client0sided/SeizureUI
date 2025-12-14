local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(tab, options)
	options = options or {}
	local title = options.Title or "Paragraph"
	local content = options.Content or "Paragraph content"

	local self = setmetatable({}, Paragraph)

	local ParagraphFrame = Instance.new("Frame")
	ParagraphFrame.Name = title
	ParagraphFrame.Parent = tab.Content
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

	self.SetTitle = function(newTitle)
		TitleLabel.Text = newTitle
	end
	
	self.SetContent = function(newContent)
		ContentLabel.Text = newContent
	end

	return self
end

return Paragraph
