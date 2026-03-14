-- Theme Configuration for NaverHub
-- Customizable color schemes and styling options

local Themes = {}

-- Default Theme
Themes.Default = {
    Name = "Default",
    MainColor = Color3.fromRGB(100, 100, 255),
    BackgroundColor = Color3.fromRGB(20, 20, 30),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(150, 150, 255),
    SuccessColor = Color3.fromRGB(50, 255, 100),
    ErrorColor = Color3.fromRGB(255, 50, 50),
    WarningColor = Color3.fromRGB(255, 200, 50)
}

-- Dark Theme
Themes.Dark = {
    Name = "Dark",
    MainColor = Color3.fromRGB(60, 60, 80),
    BackgroundColor = Color3.fromRGB(15, 15, 20),
    TextColor = Color3.fromRGB(240, 240, 240),
    AccentColor = Color3.fromRGB(100, 100, 120),
    SuccessColor = Color3.fromRGB(40, 200, 80),
    ErrorColor = Color3.fromRGB(200, 40, 40),
    WarningColor = Color3.fromRGB(200, 160, 40)
}

-- Ocean Theme
Themes.Ocean = {
    Name = "Ocean",
    MainColor = Color3.fromRGB(50, 150, 200),
    BackgroundColor = Color3.fromRGB(10, 30, 50),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(100, 200, 255),
    SuccessColor = Color3.fromRGB(50, 255, 150),
    ErrorColor = Color3.fromRGB(255, 80, 80),
    WarningColor = Color3.fromRGB(255, 200, 100)
}

-- Purple Theme
Themes.Purple = {
    Name = "Purple",
    MainColor = Color3.fromRGB(150, 50, 200),
    BackgroundColor = Color3.fromRGB(30, 10, 40),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(200, 100, 255),
    SuccessColor = Color3.fromRGB(100, 255, 150),
    ErrorColor = Color3.fromRGB(255, 50, 100),
    WarningColor = Color3.fromRGB(255, 150, 50)
}

-- Red Theme
Themes.Red = {
    Name = "Red",
    MainColor = Color3.fromRGB(200, 50, 50),
    BackgroundColor = Color3.fromRGB(40, 10, 10),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(255, 100, 100),
    SuccessColor = Color3.fromRGB(100, 255, 100),
    ErrorColor = Color3.fromRGB(255, 50, 50),
    WarningColor = Color3.fromRGB(255, 200, 50)
}

-- Green Theme
Themes.Green = {
    Name = "Green",
    MainColor = Color3.fromRGB(50, 200, 100),
    BackgroundColor = Color3.fromRGB(10, 30, 20),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(100, 255, 150),
    SuccessColor = Color3.fromRGB(50, 255, 100),
    ErrorColor = Color3.fromRGB(255, 80, 80),
    WarningColor = Color3.fromRGB(255, 200, 50)
}

-- Function to apply theme
function Themes.ApplyTheme(gui, themeName)
    local theme = Themes[themeName] or Themes.Default
    
    -- Apply to main frame
    if gui.MainFrame then
        gui.MainFrame.BackgroundColor3 = theme.BackgroundColor
    end
    
    -- Apply to header
    if gui.MainFrame and gui.MainFrame:FindFirstChild("Header") then
        gui.MainFrame.Header.BackgroundColor3 = theme.MainColor
    end
    
    -- Apply to all buttons
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

-- Get all available themes
function Themes.GetThemeList()
    return {
        "Default",
        "Dark",
        "Ocean",
        "Purple",
        "Red",
        "Green"
    }
end

return Themes