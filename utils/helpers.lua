-- Utility Helper Functions for NaverHub
-- Common functions used across the hub

local Helpers = {}

-- Notification System
function Helpers.Notify(title, message, duration)
    duration = duration or 3
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration,
        Icon = "rbxassetid://0"
    })
end

-- Safe Script Execution
function Helpers.SafeExecute(func, errorMessage)
    local success, err = pcall(func)
    if not success then
        Helpers.Notify("Error", errorMessage or "An error occurred", 5)
        warn("[NaverHub Error]:", err)
        return false
    end
    return true
end

-- Check if player has required permissions
function Helpers.CheckPermissions()
    local player = game:GetService("Players").LocalPlayer
    if not player then
        return false
    end
    return true
end

-- Tween animation helper
function Helpers.TweenObject(object, properties, duration, easingStyle, easingDirection)
    local TweenService = game:GetService("TweenService")
    
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    duration = duration or 0.3
    
    local tweenInfo = TweenInfo.new(
        duration,
        easingStyle,
        easingDirection
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    return tween
end

-- Button hover effect
function Helpers.AddHoverEffect(button, hoverColor, normalColor)
    button.MouseEnter:Connect(function()
        Helpers.TweenObject(button, {
            BackgroundColor3 = hoverColor,
            BackgroundTransparency = 0.2
        }, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Helpers.TweenObject(button, {
            BackgroundColor3 = normalColor,
            BackgroundTransparency = 0.3
        }, 0.2)
    end)
end

-- Format text with colors
function Helpers.ColorText(text, color)
    return string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255),
        text
    )
end

-- Get player's character
function Helpers.GetCharacter()
    local player = game:GetService("Players").LocalPlayer
    return player and player.Character
end

-- Get player's humanoid
function Helpers.GetHumanoid()
    local character = Helpers.GetCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

-- Check if game is loaded
function Helpers.WaitForGame()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
end

-- Save settings to datastore (local storage simulation)
function Helpers.SaveSetting(key, value)
    local success = pcall(function()
        writefile("NaverHub_" .. key .. ".txt", tostring(value))
    end)
    return success
end

-- Load settings from datastore
function Helpers.LoadSetting(key, default)
    local success, result = pcall(function()
        return readfile("NaverHub_" .. key .. ".txt")
    end)
    
    if success then
        return result
    else
        return default
    end
end

-- Table to string converter
function Helpers.TableToString(tbl, indent)
    indent = indent or 0
    local result = ""
    local indentStr = string.rep("  ", indent)
    
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            result = result .. indentStr .. tostring(k) .. " = {\n"
            result = result .. Helpers.TableToString(v, indent + 1)
            result = result .. indentStr .. "}\n"
        else
            result = result .. indentStr .. tostring(k) .. " = " .. tostring(v) .. "\n"
        end
    end
    
    return result
end

-- Copy text to clipboard (if supported)
function Helpers.CopyToClipboard(text)
    local success = pcall(function()
        setclipboard(text)
    end)
    
    if success then
        Helpers.Notify("Success", "Copied to clipboard!", 2)
    else
        Helpers.Notify("Error", "Clipboard not supported", 3)
    end
    
    return success
end

-- Get game info
function Helpers.GetGameInfo()
    return {
        GameId = game.GameId,
        PlaceId = game.PlaceId,
        JobId = game.JobId,
        GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    }
end

-- Anti-AFK function
function Helpers.AntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    Helpers.Notify("Anti-AFK", "Anti-AFK enabled", 3)
end

-- FPS Counter
function Helpers.GetFPS()
    local RunService = game:GetService("RunService")
    local FPS = 0
    local LastTime = tick()
    
    RunService.RenderStepped:Connect(function()
        local CurrentTime = tick()
        FPS = math.floor(1 / (CurrentTime - LastTime))
        LastTime = CurrentTime
    end)
    
    return function()
        return FPS
    end
end

-- Ping checker
function Helpers.GetPing()
    local player = game:GetService("Players").LocalPlayer
    return player and math.floor(player:GetNetworkPing() * 1000) or 0
end

return Helpers