-- Example Script 2: Game Utilities
-- Educational example showing game utility functions

local Script2 = {}

function Script2.GetInfo()
    return {
        Name = "Game Utilities",
        Description = "Useful game utility functions",
        Author = "NaverHub",
        Version = "1.0"
    }
end

function Script2.Execute(gui, helpers)
    -- Clear content area
    gui:ClearContent()
    
    -- Add title
    gui:AddLabel("=== Game Utilities ===")
    gui:AddLabel("")
    
    -- Anti-AFK
    gui:AddButton("Enable Anti-AFK", function()
        helpers.SafeExecute(function()
            helpers.AntiAFK()
        end, "Failed to enable Anti-AFK")
    end)
    
    -- Show game info
    gui:AddButton("Show Game Info", function()
        helpers.SafeExecute(function()
            local info = helpers.GetGameInfo()
            local message = string.format(
                "Game: %s\nPlace ID: %s\nGame ID: %s",
                info.GameName or "Unknown",
                info.PlaceId,
                info.GameId
            )
            helpers.Notify("Game Info", message, 5)
        end, "Failed to get game info")
    end)
    
    -- Show FPS
    gui:AddButton("Show FPS", function()
        helpers.SafeExecute(function()
            local getFPS = helpers.GetFPS()
            wait(1)
            local fps = getFPS()
            helpers.Notify("FPS", "Current FPS: " .. tostring(fps), 3)
        end, "Failed to get FPS")
    end)
    
    -- Show Ping
    gui:AddButton("Show Ping", function()
        helpers.SafeExecute(function()
            local ping = helpers.GetPing()
            helpers.Notify("Ping", "Current Ping: " .. tostring(ping) .. "ms", 3)
        end, "Failed to get ping")
    end)
    
    gui:AddLabel("")
    
    -- Fullbright
    gui:AddButton("Enable Fullbright", function()
        helpers.SafeExecute(function()
            local Lighting = game:GetService("Lighting")
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            helpers.Notify("Success", "Fullbright enabled", 2)
        end, "Failed to enable fullbright")
    end)
    
    -- Reset Lighting
    gui:AddButton("Reset Lighting", function()
        helpers.SafeExecute(function()
            local Lighting = game:GetService("Lighting")
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
            helpers.Notify("Success", "Lighting reset", 2)
        end, "Failed to reset lighting")
    end)
    
    gui:AddLabel("")
    
    -- Remove fog
    gui:AddButton("Remove Fog", function()
        helpers.SafeExecute(function()
            local Lighting = game:GetService("Lighting")
            Lighting.FogEnd = 100000
            helpers.Notify("Success", "Fog removed", 2)
        end, "Failed to remove fog")
    end)
    
    -- Infinite Jump
    local infiniteJumpEnabled = false
    gui:AddButton("Toggle Infinite Jump", function()
        helpers.SafeExecute(function()
            infiniteJumpEnabled = not infiniteJumpEnabled
            
            if infiniteJumpEnabled then
                local UserInputService = game:GetService("UserInputService")
                local connection
                
                connection = UserInputService.JumpRequest:Connect(function()
                    if infiniteJumpEnabled then
                        local humanoid = helpers.GetHumanoid()
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    else
                        connection:Disconnect()
                    end
                end)
                
                helpers.Notify("Success", "Infinite Jump enabled", 2)
            else
                helpers.Notify("Info", "Infinite Jump disabled", 2)
            end
        end, "Failed to toggle infinite jump")
    end)
    
    gui:AddLabel("")
    gui:AddLabel("Note: Use these features responsibly")
end

return Script2