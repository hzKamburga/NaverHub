-- Example Script 1: Player Tools
-- Educational example showing basic player manipulation

local Script1 = {}

function Script1.GetInfo()
    return {
        Name = "Player Tools",
        Description = "Basic player utility functions",
        Author = "NaverHub",
        Version = "1.0"
    }
end

function Script1.Execute(gui, helpers)
    -- Clear content area
    gui:ClearContent()
    
    -- Add title
    gui:AddLabel("Player Tools", "👤")
    gui:AddLabel("")
    
    -- Walkspeed section
    gui:AddLabel("Movement Speed", "⚡")
    gui:AddLabel("")
    
    gui:AddButton("Walkspeed: Normal (16)", "🚶", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = 16
            helpers.Notify("Success", "Walkspeed set to 16", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddButton("Walkspeed: Fast (50)", "🏃", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = 50
            helpers.Notify("Success", "Walkspeed set to 50", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddButton("Walkspeed: Very Fast (100)", "⚡", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = 100
            helpers.Notify("Success", "Walkspeed set to 100", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddLabel("")
    
    -- Jump power section
    gui:AddLabel("Jump Power", "🦘")
    gui:AddLabel("")
    
    gui:AddButton("Jump Power: Normal (50)", "🦘", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.JumpPower = 50
            helpers.Notify("Success", "Jump power set to 50", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddButton("Jump Power: High (100)", "🚀", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.JumpPower = 100
            helpers.Notify("Success", "Jump power set to 100", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddLabel("")
    
    -- Health section
    gui:AddLabel("Health Management", "❤️")
    gui:AddLabel("")
    
    gui:AddButton("Heal Character", "❤️", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            helpers.Notify("Success", "Character healed to full health", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddButton("Reset Character", "🔄", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.Health = 0
            helpers.Notify("Info", "Character reset", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddLabel("")
    gui:AddLabel("Note: These are basic examples for educational purposes", "ℹ️")
end

return Script1