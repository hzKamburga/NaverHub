-- NaverHub Main Loader
-- Educational Roblox Script Hub
-- Author: NaverHub Team
-- Version: 1.0

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Load modules
local Interface = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/gui/interface.lua"))()
local Themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/gui/themes.lua"))()
local Helpers = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/utils/helpers.lua"))()

-- Load scripts
local Script1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/scripts/example1.lua"))()
local Script2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/scripts/example2.lua"))()

-- Initialize
print("[NaverHub] Loading...")

-- Check if already loaded
if game:GetService("CoreGui"):FindFirstChild("NaverHubGui") then
    game:GetService("CoreGui"):FindFirstChild("NaverHubGui"):Destroy()
    wait(0.5)
end

-- Create GUI
local gui = Interface.new()
gui:CreateGui()

-- Add tabs with icons
local homeTab = gui:AddTab("Home", "🏠", function()
    gui:ClearContent()
    gui:AddLabel("Welcome to NaverHub", "🚀")
    gui:AddLabel("")
    gui:AddLabel("Version: 1.0", "ℹ️")
    gui:AddLabel("Author: NaverHub Team", "👤")
    gui:AddLabel("")
    gui:AddLabel("This is an educational script hub")
    gui:AddLabel("for learning Lua scripting in Roblox.")
    gui:AddLabel("")
    gui:AddLabel("Select a tab from the sidebar to begin.")
    gui:AddLabel("")
    gui:AddLabel("Features:", "✨")
    gui:AddLabel("• Modern glassmorphism UI")
    gui:AddLabel("• Icon-based navigation")
    gui:AddLabel("• Multiple themes")
    gui:AddLabel("• Modular script system")
    gui:AddLabel("")
    gui:AddLabel("Press Right Shift to toggle", "⌨️")
end)

local script1Tab = gui:AddTab("Player", "👤", function()
    Script1.Execute(gui, Helpers)
end)

local script2Tab = gui:AddTab("Game", "🎮", function()
    Script2.Execute(gui, Helpers)
end)

local settingsTab = gui:AddTab("Settings", "⚙️", function()
    gui:ClearContent()
    gui:AddLabel("Settings", "⚙️")
    gui:AddLabel("")
    gui:AddLabel("Theme Selection:", "🎨")
    gui:AddLabel("")
    
    local themes = Themes.GetThemeList()
    for _, themeName in ipairs(themes) do
        gui:AddButton("Theme: " .. themeName, "🎨", function()
            Themes.ApplyTheme(gui.ScreenGui, themeName)
            Helpers.Notify("Theme", "Applied " .. themeName .. " theme", 2)
            Helpers.SaveSetting("Theme", themeName)
        end)
    end
    
    gui:AddLabel("")
    gui:AddLabel("Other Settings:", "🔧")
    gui:AddLabel("")
    
    gui:AddButton("Save Current Position", "💾", function()
        local pos = gui.MainFrame.Position
        Helpers.SaveSetting("PosX", pos.X.Offset)
        Helpers.SaveSetting("PosY", pos.Y.Offset)
        Helpers.Notify("Success", "Position saved", 2)
    end)
    
    gui:AddButton("Reset Position", "🔄", function()
        gui.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
        Helpers.Notify("Success", "Position reset", 2)
    end)
end)

local aboutTab = gui:AddTab("About", "ℹ️", function()
    gui:ClearContent()
    gui:AddLabel("About NaverHub", "ℹ️")
    gui:AddLabel("")
    gui:AddLabel("NaverHub v1.0", "🚀")
    gui:AddLabel("")
    gui:AddLabel("An educational Roblox script hub")
    gui:AddLabel("designed for learning Lua scripting")
    gui:AddLabel("and game development concepts.")
    gui:AddLabel("")
    gui:AddLabel("Features:", "✨")
    gui:AddLabel("• Clean, modern interface")
    gui:AddLabel("• Modular architecture")
    gui:AddLabel("• Multiple themes")
    gui:AddLabel("• Easy to extend")
    gui:AddLabel("")
    gui:AddLabel("Created for educational purposes.", "📚")
    gui:AddLabel("Always follow Roblox Terms of Service.", "⚠️")
    gui:AddLabel("")
    
    gui:AddButton("Show Game Info", "🎮", function()
        local info = Helpers.GetGameInfo()
        local message = string.format("Place ID: %s\nGame ID: %s", info.PlaceId, info.GameId)
        Helpers.Notify("Game Info", message, 5)
    end)
end)

-- Load saved settings
local savedTheme = Helpers.LoadSetting("Theme", "Default")
Themes.ApplyTheme(gui.ScreenGui, savedTheme)

local savedPosX = Helpers.LoadSetting("PosX", -350)
local savedPosY = Helpers.LoadSetting("PosY", -225)
gui.MainFrame.Position = UDim2.new(0.5, tonumber(savedPosX) or -350, 0.5, tonumber(savedPosY) or -225)

-- Show GUI
gui:Show()

-- Trigger home tab by default
homeTab.MouseButton1Click:Fire()

-- Add keybind to toggle (Right Shift)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        gui:Toggle()
    end
end)

-- Notification
Helpers.Notify("NaverHub", "Loaded successfully! Press Right Shift to toggle", 5)

print("[NaverHub] Loaded successfully!")
print("[NaverHub] Press Right Shift to toggle GUI")

-- Return GUI instance for external control
return gui