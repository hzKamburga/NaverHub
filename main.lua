-- NaverHub Main Loader with Loading Screen
-- Advanced Exploit Tools Hub
-- Author: NaverHub Team
-- Version: 2.0

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("[NaverHub] Starting...")

-- Show loading screen
local LoadingScreen = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/gui/loading.lua"))()
LoadingScreen.Show()

-- Load modules
local Interface = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/gui/interface.lua"))()
local Themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/gui/themes.lua"))()
local Helpers = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/utils/helpers.lua"))()

-- Load exploit scripts
local ESPAimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/scripts/esp_aimbot.lua"))()
local Scanner = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/scripts/scanner.lua"))()
local Explorer = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/scripts/explorer.lua"))()

-- Initialize
print("[NaverHub] Loading complete!")

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
    gui:AddLabel("Version: 2.0 - Advanced Tools", "ℹ️")
    gui:AddLabel("Author: NaverHub Team", "👤")
    gui:AddLabel("")
    gui:AddLabel("Advanced Exploit Tools", "⚡")
    gui:AddLabel("")
    gui:AddLabel("Features:", "✨")
    gui:AddLabel("• ESP & Aimbot System")
    gui:AddLabel("• Entity Scanner")
    gui:AddLabel("• Object Explorer (Dex-style)")
    gui:AddLabel("• Target Group System")
    gui:AddLabel("• Hitbox Expansion")
    gui:AddLabel("• NPC Detection")
    gui:AddLabel("")
    gui:AddLabel("Select a tool from the sidebar", "👈")
    gui:AddLabel("")
    gui:AddLabel("Press Right Shift to toggle", "⌨️")
    gui:AddLabel("")
    gui:AddLabel("⚠️ Educational purposes only", "⚠️")
end)

local espTab = gui:AddTab("ESP & Aim", "🎯", function()
    ESPAimbot.Execute(gui, Helpers)
end)

local explorerTab = gui:AddTab("Explorer", "🔍", function()
    Explorer.Execute(gui, Helpers)
end)

local scannerTab = gui:AddTab("Scanner", "📡", function()
    Scanner.Execute(gui, Helpers)
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
    gui:AddLabel("GUI Settings:", "🔧")
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
    
    gui:AddLabel("")
    
    gui:AddButton("Reload Hub", "🔄", function()
        Helpers.Notify("Info", "Reloading NaverHub...", 2)
        wait(1)
        if gui.ScreenGui then
            gui.ScreenGui:Destroy()
        end
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/main.lua"))()
    end)
end)

local aboutTab = gui:AddTab("About", "ℹ️", function()
    gui:ClearContent()
    gui:AddLabel("About NaverHub", "ℹ️")
    gui:AddLabel("")
    gui:AddLabel("NaverHub v2.0", "🚀")
    gui:AddLabel("Advanced Exploit Tools", "⚡")
    gui:AddLabel("")
    gui:AddLabel("Features:", "✨")
    gui:AddLabel("• ESP System - See all players")
    gui:AddLabel("• Aimbot - Auto-targeting")
    gui:AddLabel("• Object Explorer - Dex-style")
    gui:AddLabel("• Target Groups - Custom groups")
    gui:AddLabel("• Hitbox Expansion")
    gui:AddLabel("• Entity Scanner")
    gui:AddLabel("• NPC Detection")
    gui:AddLabel("")
    gui:AddLabel("Controls:", "🎮")
    gui:AddLabel("• Right Shift - Toggle GUI")
    gui:AddLabel("• Drag header to move")
    gui:AddLabel("")
    gui:AddLabel("Created for educational purposes.", "📚")
    gui:AddLabel("Use responsibly!", "⚠️")
    gui:AddLabel("")
    
    gui:AddButton("Show Game Info", "🎮", function()
        local info = Helpers.GetGameInfo()
        local message = string.format("Place ID: %s\nGame ID: %s\nJob ID: %s", 
            tostring(info.PlaceId), 
            tostring(info.GameId),
            tostring(info.JobId))
        Helpers.Notify("Game Info", message, 5)
    end)
    
    gui:AddButton("Show System Info", "💻", function()
        local ping = Helpers.GetPing()
        local message = string.format("Ping: %dms\nExecutor: Synapse/KRNL Compatible", ping)
        Helpers.Notify("System Info", message, 4)
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
Helpers.Notify("NaverHub v2.0", "Loaded! Press Right Shift to toggle", 5)

print("[NaverHub] All systems ready!")
print("[NaverHub] Press Right Shift to toggle GUI")

-- Return GUI instance for external control
return gui