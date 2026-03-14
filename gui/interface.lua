-- Modern Glassmorphism GUI Interface for Roblox Script Hub
-- Advanced glass effect with blur, icons, and modern design

local Interface = {}
Interface.__index = Interface

-- Configuration
local CONFIG = {
    HubName = "NaverHub",
    Version = "v1.0",
    MainColor = Color3.fromRGB(100, 100, 255),
    BackgroundColor = Color3.fromRGB(15, 15, 25),
    GlassColor = Color3.fromRGB(25, 25, 40),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(150, 150, 255)
}

-- Icon library (Lucide icons style)
local ICONS = {
    Home = "🏠",
    Player = "👤",
    Settings = "⚙️",
    Info = "ℹ️",
    Tools = "🔧",
    Speed = "⚡",
    Jump = "🦘",
    Health = "❤️",
    Eye = "👁️",
    Moon = "🌙",
    Palette = "🎨",
    Check = "✓",
    X = "✕",
    Minimize = "−",
    Game = "🎮",
    Clock = "⏱️",
    Signal = "📶"
}

function Interface.new()
    local self = setmetatable({}, Interface)
    self.ScreenGui = nil
    self.MainFrame = nil
    self.IsOpen = false
    self.CurrentTab = nil
    return self
end

function Interface:CreateGui()
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NaverHubGui"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    
    -- Main Container with glass effect
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 700, 0, 450)
    self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    self.MainFrame.BackgroundColor3 = CONFIG.GlassColor
    self.MainFrame.BackgroundTransparency = 0.3
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- Glass effect with UIBlur simulation
    local GlassEffect = Instance.new("Frame")
    GlassEffect.Name = "GlassEffect"
    GlassEffect.Size = UDim2.new(1, 0, 1, 0)
    GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlassEffect.BackgroundTransparency = 0.98
    GlassEffect.BorderSizePixel = 0
    GlassEffect.ZIndex = 0
    GlassEffect.Parent = self.MainFrame
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = self.MainFrame
    
    local GlassCorner = Instance.new("UICorner")
    GlassCorner.CornerRadius = UDim.new(0, 16)
    GlassCorner.Parent = GlassEffect
    
    -- Border glow effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = CONFIG.AccentColor
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.7
    UIStroke.Parent = self.MainFrame
    
    -- Shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ZIndex = -1
    Shadow.Parent = self.MainFrame
    
    -- Create components
    self:CreateHeader()
    self:CreateSidebar()
    self:CreateContentArea()
    self:MakeDraggable()
    
    return self.ScreenGui
end

function Interface:CreateHeader()
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = CONFIG.MainColor
    Header.BackgroundTransparency = 0.4
    Header.BorderSizePixel = 0
    Header.Parent = self.MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header
    
    -- Header gradient
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 200))
    }
    Gradient.Rotation = 45
    Gradient.Parent = Header
    
    -- Title with icon
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Size = UDim2.new(0, 250, 1, 0)
    TitleContainer.Position = UDim2.new(0, 20, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = Header
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 0, 0.5, -20)
    Icon.BackgroundTransparency = 1
    Icon.Text = "🚀"
    Icon.TextColor3 = CONFIG.TextColor
    Icon.TextSize = 28
    Icon.Font = Enum.Font.GothamBold
    Icon.Parent = TitleContainer
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = CONFIG.HubName .. " " .. CONFIG.Version
    Title.TextColor3 = CONFIG.TextColor
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleContainer
    
    -- Control buttons
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(0, 100, 0, 40)
    ButtonContainer.Position = UDim2.new(1, -110, 0.5, -20)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = Header
    
    -- Minimize Button
    local MinimizeButton = self:CreateIconButton(ICONS.Minimize, Color3.fromRGB(255, 200, 50))
    MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
    MinimizeButton.Parent = ButtonContainer
    MinimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    -- Close Button
    local CloseButton = self:CreateIconButton(ICONS.X, Color3.fromRGB(255, 80, 80))
    CloseButton.Position = UDim2.new(0, 50, 0, 0)
    CloseButton.Parent = ButtonContainer
    CloseButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

function Interface:CreateIconButton(icon, color)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 40, 0, 40)
    Button.BackgroundColor3 = color
    Button.BackgroundTransparency = 0.3
    Button.Text = icon
    Button.TextColor3 = CONFIG.TextColor
    Button.TextSize = 18
    Button.Font = Enum.Font.GothamBold
    Button.AutoButtonColor = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        Button.BackgroundTransparency = 0.1
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundTransparency = 0.3
    end)
    
    return Button
end

function Interface:CreateSidebar()
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, -70)
    Sidebar.Position = UDim2.new(0, 10, 0, 65)
    Sidebar.BackgroundColor3 = CONFIG.GlassColor
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = self.MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar
    
    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = CONFIG.AccentColor
    SidebarStroke.Thickness = 1
    SidebarStroke.Transparency = 0.8
    SidebarStroke.Parent = Sidebar
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.Parent = Sidebar
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 12)
    Padding.PaddingLeft = UDim.new(0, 12)
    Padding.PaddingRight = UDim.new(0, 12)
    Padding.PaddingBottom = UDim.new(0, 12)
    Padding.Parent = Sidebar
    
    self.Sidebar = Sidebar
end

function Interface:CreateContentArea()
    local ContentArea = Instance.new("ScrollingFrame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -210, 1, -80)
    ContentArea.Position = UDim2.new(0, 200, 0, 70)
    ContentArea.BackgroundColor3 = CONFIG.GlassColor
    ContentArea.BackgroundTransparency = 0.6
    ContentArea.BorderSizePixel = 0
    ContentArea.ScrollBarThickness = 4
    ContentArea.ScrollBarImageColor3 = CONFIG.AccentColor
    ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentArea.Parent = self.MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 12)
    ContentCorner.Parent = ContentArea
    
    local ContentStroke = Instance.new("UIStroke")
    ContentStroke.Color = CONFIG.AccentColor
    ContentStroke.Thickness = 1
    ContentStroke.Transparency = 0.8
    ContentStroke.Parent = ContentArea
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentArea
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    ContentPadding.Parent = ContentArea
    
    self.ContentArea = ContentArea
end

function Interface:AddTab(tabName, icon, callback)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.Size = UDim2.new(1, 0, 0, 45)
    TabButton.BackgroundColor3 = CONFIG.MainColor
    TabButton.BackgroundTransparency = 0.7
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.Sidebar
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabButton
    
    -- Icon
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Position = UDim2.new(0, 10, 0.5, -15)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.TextColor3 = CONFIG.TextColor
    IconLabel.TextSize = 20
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = TabButton
    
    -- Text
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -50, 1, 0)
    TextLabel.Position = UDim2.new(0, 45, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = tabName
    TextLabel.TextColor3 = CONFIG.TextColor
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = TabButton
    
    -- Hover and click effects
    TabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= TabButton then
            TabButton.BackgroundTransparency = 0.5
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= TabButton then
            TabButton.BackgroundTransparency = 0.7
        end
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        -- Reset all tabs
        for _, child in pairs(self.Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundTransparency = 0.7
            end
        end
        
        -- Highlight current tab
        TabButton.BackgroundTransparency = 0.3
        self.CurrentTab = TabButton
        
        if callback then
            callback()
        end
    end)
    
    return TabButton
end

function Interface:AddButton(text, icon, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundColor3 = CONFIG.MainColor
    Button.BackgroundTransparency = 0.5
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = self.ContentArea
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 12)
    ButtonCorner.Parent = Button
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = CONFIG.AccentColor
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.7
    ButtonStroke.Parent = Button
    
    -- Icon
    if icon then
        local IconLabel = Instance.new("TextLabel")
        IconLabel.Size = UDim2.new(0, 35, 0, 35)
        IconLabel.Position = UDim2.new(0, 12, 0.5, -17)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Text = icon
        IconLabel.TextColor3 = CONFIG.TextColor
        IconLabel.TextSize = 22
        IconLabel.Font = Enum.Font.GothamBold
        IconLabel.Parent = Button
    end
    
    -- Text
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, icon and -60 or -20, 1, 0)
    TextLabel.Position = UDim2.new(0, icon and 55 or 10, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = CONFIG.TextColor
    TextLabel.TextSize = 15
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Button
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        Button.BackgroundTransparency = 0.3
        ButtonStroke.Transparency = 0.4
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundTransparency = 0.5
        ButtonStroke.Transparency = 0.7
    end)
    
    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return Button
end

function Interface:AddLabel(text, icon)
    local Label = Instance.new("Frame")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.BackgroundTransparency = 1
    Label.Parent = self.ContentArea
    
    if icon then
        local IconLabel = Instance.new("TextLabel")
        IconLabel.Size = UDim2.new(0, 25, 0, 25)
        IconLabel.Position = UDim2.new(0, 0, 0, 2)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Text = icon
        IconLabel.TextColor3 = CONFIG.AccentColor
        IconLabel.TextSize = 18
        IconLabel.Font = Enum.Font.GothamBold
        IconLabel.Parent = Label
    end
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, icon and -30 or 0, 1, 0)
    TextLabel.Position = UDim2.new(0, icon and 30 or 0, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = CONFIG.TextColor
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextWrapped = true
    TextLabel.Parent = Label
    
    return Label
end

function Interface:ClearContent()
    for _, child in pairs(self.ContentArea:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

function Interface:MakeDraggable()
    local dragging = false
    local dragInput, mousePos, framePos
    
    local function update(input)
        local delta = input.Position - mousePos
        self.MainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
    
    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Interface:Toggle()
    self.IsOpen = not self.IsOpen
    self.MainFrame.Visible = self.IsOpen
end

function Interface:Minimize()
    self.MainFrame.Visible = false
    self.IsOpen = false
end

function Interface:Show()
    if self.ScreenGui.Parent == nil then
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end
    self.MainFrame.Visible = true
    self.IsOpen = true
end

return Interface