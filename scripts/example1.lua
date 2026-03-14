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
    gui:AddLabel("=== Player Tools ===")
    gui:AddLabel("")
    
    -- Walkspeed modifier
    gui:AddButton("Set Walkspeed (16)", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = 16
            helpers.Notify("Success", "Walkspeed set to 16", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddButton("Set Walkspeed (50)", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = 50
            helpers.Notify("Success", "Walkspeed set to 50", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    -- Jump power modifier
    gui:AddButton("Set Jump Power (50)", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.JumpPower = 50
            helpers.Notify("Success", "Jump power set to 50", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddButton("Set Jump Power (100)", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.JumpPower = 100
            helpers.Notify("Success", "Jump power set to 100", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddLabel("")
    
    -- Reset character
    gui:AddButton("Reset Character", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.Health = 0
            helpers.Notify("Info", "Character reset", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    -- Heal character
    gui:AddButton("Heal Character", function()
        local humanoid = helpers.GetHumanoid()
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            helpers.Notify("Success", "Character healed", 2)
        else
            helpers.Notify("Error", "Humanoid not found", 3)
        end
    end)
    
    gui:AddLabel("")
    gui:AddLabel("Note: These are basic examples for educational purposes")
end

return Script1