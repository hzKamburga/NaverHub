-- Game Info & Entity Scanner
-- Scans and displays all entities, NPCs, and objects in the game

local ScannerScript = {}

-- Scanner Settings
local ScanEnabled = false
local ScanResults = {}
local HighlightedObjects = {}

function ScannerScript.GetInfo()
    return {
        Name = "Entity Scanner",
        Description = "Scan and highlight all entities in game",
        Author = "NaverHub",
        Version = "1.0"
    }
end

-- Scanning Functions
local function HighlightObject(obj, color)
    if not obj:IsA("BasePart") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = obj
    highlight.Parent = obj
    
    return highlight
end

local function ScanNPCs()
    local npcs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not game:GetService("Players"):GetPlayerFromCharacter(obj) then
            table.insert(npcs, obj)
        end
    end
    return npcs
end

local function ScanItems()
    local items = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and obj:FindFirstChild("Handle")) then
            table.insert(items, obj)
        end
    end
    return items
end

local function ScanDoors()
    local doors = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("door") and obj:IsA("BasePart") then
            table.insert(doors, obj)
        end
    end
    return doors
end

local function ScanChests()
    local chests = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("chest") or obj.Name:lower():find("box") or obj.Name:lower():find("crate") then
            if obj:IsA("Model") or obj:IsA("BasePart") then
                table.insert(chests, obj)
            end
        end
    end
    return chests
end

local function ClearHighlights()
    for _, highlight in pairs(HighlightedObjects) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    HighlightedObjects = {}
end

-- Main Execute Function
function ScannerScript.Execute(gui, helpers)
    gui:ClearContent()
    
    gui:AddLabel("Entity Scanner", "🔍")
    gui:AddLabel("")
    
    -- NPC Scanner
    gui:AddLabel("NPC Detection", "👾")
    gui:AddLabel("")
    
    gui:AddButton("Scan & Highlight NPCs", "👾", function()
        ClearHighlights()
        local npcs = ScanNPCs()
        for _, npc in pairs(npcs) do
            if npc:FindFirstChild("HumanoidRootPart") then
                local h = HighlightObject(npc.HumanoidRootPart, Color3.fromRGB(255, 0, 0))
                table.insert(HighlightedObjects, h)
            end
        end
        helpers.Notify("Scanner", "Found " .. #npcs .. " NPCs", 3)
    end)
    
    gui:AddButton("ESP All NPCs", "📦", function()
        local npcs = ScanNPCs()
        for _, npc in pairs(npcs) do
            if npc:FindFirstChild("HumanoidRootPart") then
                local hrp = npc.HumanoidRootPart
                
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(4, 6, 4)
                box.Color3 = Color3.fromRGB(255, 100, 0)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.Adornee = hrp
                box.Parent = hrp
                
                table.insert(HighlightedObjects, box)
            end
        end
        helpers.Notify("Scanner", "ESP enabled for " .. #npcs .. " NPCs", 3)
    end)
    
    gui:AddLabel("")
    
    -- Item Scanner
    gui:AddLabel("Item Detection", "🎁")
    gui:AddLabel("")
    
    gui:AddButton("Scan & Highlight Items", "🎁", function()
        ClearHighlights()
        local items = ScanItems()
        for _, item in pairs(items) do
            local part = item:IsA("Tool") and item:FindFirstChild("Handle") or item:FindFirstChild("Handle")
            if part then
                local h = HighlightObject(part, Color3.fromRGB(0, 255, 0))
                table.insert(HighlightedObjects, h)
            end
        end
        helpers.Notify("Scanner", "Found " .. #items .. " items", 3)
    end)
    
    gui:AddButton("Scan Chests/Boxes", "📦", function()
        ClearHighlights()
        local chests = ScanChests()
        for _, chest in pairs(chests) do
            local part = chest:IsA("BasePart") and chest or chest:FindFirstChildWhichIsA("BasePart")
            if part then
                local h = HighlightObject(part, Color3.fromRGB(255, 215, 0))
                table.insert(HighlightedObjects, h)
            end
        end
        helpers.Notify("Scanner", "Found " .. #chests .. " chests", 3)
    end)
    
    gui:AddLabel("")
    
    -- Door Scanner
    gui:AddLabel("Environment Detection", "🚪")
    gui:AddLabel("")
    
    gui:AddButton("Scan & Highlight Doors", "🚪", function()
        ClearHighlights()
        local doors = ScanDoors()
        for _, door in pairs(doors) do
            local h = HighlightObject(door, Color3.fromRGB(0, 150, 255))
            table.insert(HighlightedObjects, h)
        end
        helpers.Notify("Scanner", "Found " .. #doors .. " doors", 3)
    end)
    
    gui:AddButton("Scan All Entities", "🌍", function()
        ClearHighlights()
        local npcs = ScanNPCs()
        local items = ScanItems()
        local chests = ScanChests()
        local doors = ScanDoors()
        
        local total = #npcs + #items + #chests + #doors
        helpers.Notify("Scanner", string.format("Found:\n%d NPCs\n%d Items\n%d Chests\n%d Doors", #npcs, #items, #chests, #doors), 5)
    end)
    
    gui:AddLabel("")
    
    -- Utility
    gui:AddLabel("Utilities", "🔧")
    gui:AddLabel("")
    
    gui:AddButton("Clear All Highlights", "🧹", function()
        ClearHighlights()
        helpers.Notify("Scanner", "All highlights cleared", 2)
    end)
    
    gui:AddButton("Show Workspace Info", "ℹ️", function()
        local descendants = #workspace:GetDescendants()
        local parts = 0
        local models = 0
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                parts = parts + 1
            elseif obj:IsA("Model") then
                models = models + 1
            end
        end
        
        helpers.Notify("Workspace Info", string.format("Total: %d\nParts: %d\nModels: %d", descendants, parts, models), 5)
    end)
    
    gui:AddLabel("")
    gui:AddLabel("Note: Scanner works best in loaded areas", "ℹ️")
end

return ScannerScript