-- Standalone Version of NaverHub
-- This version includes all modules in a single file for easy execution
-- No external loading required

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("[NaverHub] Initializing standalone version...")

-- ============================================
-- HELPERS MODULE
-- ============================================
local Helpers = {}

function Helpers.Notify(title, message, duration)
    duration = duration or 3
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration,
        Icon = "rbxassetid://0"
    })
end

function Helpers.SafeExecute(func, errorMessage)
    local success, err = pcall(func)
    if not success then
        Helpers.Notify("Error", errorMessage or "An error occurred", 5)
        warn("[NaverHub Error]:", err)
        return false
    end
    return true
end

function Helpers.GetCharacter()
    local player = game:GetService("Players").LocalPlayer
    return player and player.Character
end

function Helpers.GetHumanoid()
    local character = Helpers.GetCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

function Helpers.SaveSetting(key, value)
    local success = pcall(function()
        writefile("NaverHub_" .. key .. ".txt", tostring(value))
    end)
    return success
end

function Helpers.LoadSetting(key, default)
    local success, result = pcall(function()
        return readfile("NaverHub_" .. key .. ".txt")
    end)
    return success and result or default
end

function Helpers.AntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    Helpers.Notify("Anti-AFK", "Anti-AFK enabled", 3)
end

function Helpers.GetGameInfo()
    return {
        GameId = game.GameId,
        PlaceId = game.PlaceId,
        JobId = game.JobId
    }
end

function Helpers.GetFPS()
    local RunService = game:GetService("RunService")
    local FPS = 0
    local LastTime = tick()
    RunService.RenderStepped:Connect(function()
        local CurrentTime = tick()
        FPS = math.floor(1 / (CurrentTime - LastTime))
        LastTime = CurrentTime
    end)
    return function() return FPS end
end

function Helpers.GetPing()
    local player = game:GetService("Players").LocalPlayer
    return player and math.floor(player:GetNetworkPing() * 1000) or 0
end

-- ============================================
-- THEMES MODULE
-- ============================================
local Themes = {}

Themes.Default = {
    Name = "Default",
    MainColor = Color3.fromRGB(100, 100, 255),
    BackgroundColor = Color3.fromRGB(20, 20, 30),
    TextColor = Color3.fromRGB(255, 255, 255)
}

Themes.Dark = {
    Name = "Dark",
    MainColor = Color3.fromRGB(60, 60, 80),
    BackgroundColor = Color3.fromRGB(15, 15, 20),
    TextColor = Color3.fromRGB(240, 240, 240)
}

Themes.Ocean = {
    Name = "Ocean",
    MainColor = Color3.fromRGB(50, 150, 200),
    BackgroundColor = Color3.fromRGB(10, 30, 50),
    TextColor = Color3.fromRGB(255, 255, 255)
}

Themes.Purple = {
    Name = "Purple",
    MainColor = Color3.fromRGB(150, 50, 200),
    BackgroundColor = Color3.fromRGB(30, 10, 40),
    TextColor = Color3.fromRGB(255, 255, 255)
}

function Themes.ApplyTheme(gui, themeName)
    local theme = Themes[themeName] or Themes.Default
    if gui.MainFrame then
        gui.MainFrame.BackgroundColor3 = theme.BackgroundColor
    end
    if gui.MainFrame and gui.MainFrame:FindFirstChild("Header") then
        gui.MainFrame.Header.BackgroundColor3 = theme.MainColor
    end
    for _, descendant in pairs(gui:GetDescendants()) do
        if descendant:IsA("TextButton") then
            if descendant.Name ~= "CloseButton" and descendant.Name ~= "MinimizeButton" then
                descendant.BackgroundColor3 = theme.MainColor
                descendant.TextColor3 = theme.TextColor
            end
        elseif descendant:IsA("TextLabel") then
            descendant.TextColor3 = theme.TextColor
        end
    end
    return theme
end

function Themes.GetThemeList()
    return {"Default", "Dark", "Ocean", "Purple"}
end

-- ============================================
-- INTERFACE MODULE
-- ============================================
local Interface = {}
Interface.__index = Interface

local CONFIG = {
    HubName = "NaverHub",
    Version = "v1.0",
    MainColor = Color3.fromRGB(100, 100, 255),
    BackgroundColor = Color3.fromRGB(20, 20, 30),
    TextColor = Color3.fromRGB(255, 255, 255)
}

function Interface.new()
    local self = setmetatable({}, Interface)
    self.ScreenGui = nil
    self.MainFrame = nil
    self.IsOpen = false
    return self
end

function Interface:CreateGui()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NaverHubGui"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainFrame.BackgroundColor3 = CONFIG.BackgroundColor
    self.MainFrame.BackgroundTransparency = 0.1
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = self.MainFrame
    
    self:CreateHeader()
    self:CreateSidebar()
    self:CreateContentArea()
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
        if callback then callback() end
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
        if callback then callback() end
    end)
    
    return Button
end

function Interface:AddLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -20, 0, 25)
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

function Interface:Show()
    if self.ScreenGui.Parent == nil then
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end
    self.MainFrame.Visible = true
    self.IsOpen = true
end

-- ============================================
-- MAIN EXECUTION
-- ============================================

-- Check if already loaded
if game:GetService("CoreGui"):FindFirstChild("NaverHubGui") then
    game:GetService("CoreGui"):FindFirstChild("NaverHubGui"):Destroy()
    wait(0.5)
end

-- Create GUI
local gui = Interface.new()
gui:CreateGui()

-- Add Home Tab
gui:AddTab("Home", function()
    gui:ClearContent()
    gui:AddLabel("=== Welcome to NaverHub ===")
    gui:AddLabel("")
    gui:AddLabel("Version: 1.0 Standalone")
    gui:AddLabel("")
    gui:AddLabel("Educational script hub for Roblox")
    gui:AddLabel("")
    gui:AddLabel("Features:")
    gui:AddLabel("• Modern UI design")
    gui:AddLabel("• Player tools")
    gui:AddLabel("• Game utilities")
    gui:AddLabel("• Theme customization")
    gui:AddLabel("")
    gui:AddLabel("Press Right Shift to toggle")
end)

-- Add Player Tools Tab
gui:AddTab("Player", function()
    gui:ClearContent()
    gui:AddLabel("=== Player Tools ===")
    gui:AddLabel("")
    
    gui:AddButton("Walkspeed 16", function()
        local h = Helpers.GetHumanoid()
        if h then h.WalkSpeed = 16 Helpers.Notify("Success", "Walkspeed: 16", 2) end
    end)
    
    gui:AddButton("Walkspeed 50", function()
        local h = Helpers.GetHumanoid()
        if h then h.WalkSpeed = 50 Helpers.Notify("Success", "Walkspeed: 50", 2) end
    end)
    
    gui:AddButton("Jump Power 50", function()
        local h = Helpers.GetHumanoid()
        if h then h.JumpPower = 50 Helpers.Notify("Success", "Jump: 50", 2) end
    end)
    
    gui:AddButton("Heal Character", function()
        local h = Helpers.GetHumanoid()
        if h then h.Health = h.MaxHealth Helpers.Notify("Success", "Healed", 2) end
    end)
end)

-- Add Game Utils Tab
gui:AddTab("Utils", function()
    gui:ClearContent()
    gui:AddLabel("=== Game Utilities ===")
    gui:AddLabel("")
    
    gui:AddButton("Enable Anti-AFK", function()
        Helpers.SafeExecute(function() Helpers.AntiAFK() end)
    end)
    
    gui:AddButton("Show FPS", function()
        local getFPS = Helpers.GetFPS()
        wait(1)
        Helpers.Notify("FPS", "FPS: " .. getFPS(), 3)
    end)
    
    gui:AddButton("Show Ping", function()
        Helpers.Notify("Ping", "Ping: " .. Helpers.GetPing() .. "ms", 3)
    end)
    
    gui:AddButton("Fullbright", function()
        local L = game:GetService("Lighting")
        L.Brightness = 2
        L.ClockTime = 14
        L.FogEnd = 100000
        Helpers.Notify("Success", "Fullbright ON", 2)
    end)
end)

-- Add Settings Tab
gui:AddTab("Settings", function()
    gui:ClearContent()
    gui:AddLabel("=== Settings ===")
    gui:AddLabel("")
    gui:AddLabel("Themes:")
    gui:AddLabel("")
    
    for _, theme in ipairs(Themes.GetThemeList()) do
        gui:AddButton("Theme: " .. theme, function()
            Themes.ApplyTheme(gui.ScreenGui, theme)
            Helpers.Notify("Theme", theme .. " applied", 2)
        end)
    end
end)

-- Show GUI
gui:Show()

-- Toggle keybind
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        gui:Toggle()
    end
end)

Helpers.Notify("NaverHub", "Loaded! Press Right Shift", 5)
print("[NaverHub] Standalone version loaded successfully!")