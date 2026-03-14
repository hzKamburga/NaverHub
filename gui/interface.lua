-- Modern GUI Interface for Roblox Script Hub
-- Glass-morphism inspired design with smooth animations

local Interface = {}
Interface.__index = Interface

-- Configuration
local CONFIG = {
    HubName = "NaverHub",
    Version = "v1.0",
    MainColor = Color3.fromRGB(100, 100, 255),
    BackgroundColor = Color3.fromRGB(20, 20, 30),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(150, 150, 255)
}

function Interface.new()
    local self = setmetatable({}, Interface)
    self.ScreenGui = nil
    self.MainFrame = nil
    self.IsOpen = false
    return self
end

function Interface:CreateGui()
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NaverHubGui"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame (Hub Container)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainFrame.BackgroundColor3 = CONFIG.BackgroundColor
    self.MainFrame.BackgroundTransparency = 0.1
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- Add rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = self.MainFrame
    
    -- Add shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ZIndex = 0
    Shadow.Parent = self.MainFrame
    
    -- Create header
    self:CreateHeader()
    
    -- Create sidebar
    self:CreateSidebar()
    
    -- Create content area
    self:CreateContentArea()
    
    -- Make draggable
    self:MakeDraggable()
    
    return self.ScreenGui
end

function Interface:CreateHeader()
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = CONFIG.MainColor
    Header.BackgroundTransparency = 0.3
    Header.BorderSizePixel = 0
    Header.Parent = self.MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = CONFIG.HubName .. " " .. CONFIG.Version
    Title.TextColor3 = CONFIG.TextColor
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.BackgroundTransparency = 0.3
    CloseButton.Text = "X"
    CloseButton.TextColor3 = CONFIG.TextColor
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    MinimizeButton.BackgroundTransparency = 0.3
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = CONFIG.TextColor
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = Header
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeButton
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
end

function Interface:CreateSidebar()
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = CONFIG.BackgroundColor
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = self.MainFrame
    
    -- Add list layout
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 5)
    ListLayout.Parent = Sidebar
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.Parent = Sidebar
    
    self.Sidebar = Sidebar
end

function Interface:CreateContentArea()
    local ContentArea = Instance.new("ScrollingFrame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -160, 1, -60)
    ContentArea.Position = UDim2.new(0, 155, 0, 55)
    ContentArea.BackgroundColor3 = CONFIG.BackgroundColor
    ContentArea.BackgroundTransparency = 0.8
    ContentArea.BorderSizePixel = 0
    ContentArea.ScrollBarThickness = 6
    ContentArea.Parent = self.MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentArea
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentArea
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.Parent = ContentArea
    
    self.ContentArea = ContentArea
end

function Interface:AddTab(tabName, callback)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.Size = UDim2.new(1, -10, 0, 35)
    TabButton.BackgroundColor3 = CONFIG.MainColor
    TabButton.BackgroundTransparency = 0.5
    TabButton.Text = tabName
    TabButton.TextColor3 = CONFIG.TextColor
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = self.Sidebar
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    TabButton.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
        self:ClearContent()
    end)
    
    return TabButton
end

function Interface:AddButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.BackgroundColor3 = CONFIG.MainColor
    Button.BackgroundTransparency = 0.3
    Button.Text = text
    Button.TextColor3 = CONFIG.TextColor
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = self.ContentArea
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return Button
end

function Interface:AddLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -20, 0, 30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = CONFIG.TextColor
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = self.ContentArea
    
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