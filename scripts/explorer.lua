-- Object Explorer (Dex-style)
-- Explore game objects, NPCs, and models in detail

local ExplorerScript = {}

-- Explorer Settings
local SelectedObject = nil
local ExplorerCache = {}
local TargetGroups = {}

function ExplorerScript.GetInfo()
    return {
        Name = "Object Explorer",
        Description = "Dex-style object explorer for game analysis",
        Author = "NaverHub",
        Version = "1.0"
    }
end

-- Helper Functions
local function GetObjectPath(obj)
    local path = obj.Name
    local current = obj.Parent
    while current and current ~= game do
        path = current.Name .. "." .. path
        current = current.Parent
    end
    return path
end

local function GetObjectInfo(obj)
    local info = {
        Name = obj.Name,
        ClassName = obj.ClassName,
        Path = GetObjectPath(obj),
        Children = #obj:GetChildren(),
        Parent = obj.Parent and obj.Parent.Name or "nil"
    }
    
    -- Additional info for specific types
    if obj:IsA("Model") then
        info.PrimaryPart = obj.PrimaryPart and obj.PrimaryPart.Name or "None"
        info.HasHumanoid = obj:FindFirstChild("Humanoid") ~= nil
    elseif obj:IsA("Humanoid") then
        info.Health = obj.Health
        info.MaxHealth = obj.MaxHealth
        info.WalkSpeed = obj.WalkSpeed
        info.JumpPower = obj.JumpPower
    elseif obj:IsA("BasePart") then
        info.Size = tostring(obj.Size)
        info.Position = tostring(obj.Position)
        info.Transparency = obj.Transparency
        info.CanCollide = obj.CanCollide
    end
    
    return info
end

local function ScanWorkspace()
    local results = {
        Models = {},
        NPCs = {},
        Players = {},
        Parts = {},
        Tools = {},
        Other = {}
    }
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if obj:FindFirstChild("Humanoid") then
                local isPlayer = game:GetService("Players"):GetPlayerFromCharacter(obj)
                if isPlayer then
                    table.insert(results.Players, obj)
                else
                    table.insert(results.NPCs, obj)
                end
            else
                table.insert(results.Models, obj)
            end
        elseif obj:IsA("Tool") then
            table.insert(results.Tools, obj)
        elseif obj:IsA("BasePart") then
            table.insert(results.Parts, obj)
        end
    end
    
    return results
end

local function CreateTargetGroup(name, objects)
    TargetGroups[name] = {
        Objects = objects,
        ESPEnabled = false,
        AimbotEnabled = false,
        Color = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
    }
end

local function ApplyESPToGroup(groupName)
    local group = TargetGroups[groupName]
    if not group then return end
    
    for _, obj in pairs(group.Objects) do
        if obj and obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            local hrp = obj.HumanoidRootPart
            
            -- Create ESP box
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(4, 6, 4)
            box.Color3 = group.Color
            box.Transparency = 0.5
            box.AlwaysOnTop = true
            box.Adornee = hrp
            box.Parent = hrp
            box.Name = "GroupESP_" .. groupName
            
            -- Create name tag
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = hrp
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = hrp
            billboard.Name = "GroupTag_" .. groupName
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = "[" .. groupName .. "] " .. obj.Name
            nameLabel.TextColor3 = group.Color
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Parent = billboard
        end
    end
    
    group.ESPEnabled = true
end

local function RemoveESPFromGroup(groupName)
    local group = TargetGroups[groupName]
    if not group then return end
    
    for _, obj in pairs(group.Objects) do
        if obj and obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            local hrp = obj.HumanoidRootPart
            
            -- Remove ESP
            for _, child in pairs(hrp:GetChildren()) do
                if child.Name == "GroupESP_" .. groupName or child.Name == "GroupTag_" .. groupName then
                    child:Destroy()
                end
            end
        end
    end
    
    group.ESPEnabled = false
end

-- Main Execute Function
function ExplorerScript.Execute(gui, helpers)
    -- Don't clear here, let the tab system handle it
    
    gui:AddLabel("Object Explorer", "🔍")
    gui:AddLabel("")
    
    -- Scan workspace
    gui:AddLabel("Workspace Scanner", "🌍")
    gui:AddLabel("")
    
    gui:AddButton("Scan Workspace", "🔍", function()
        local results = ScanWorkspace()
        ExplorerCache = results
        
        local message = string.format(
            "Scan Complete:\n• %d NPCs\n• %d Players\n• %d Models\n• %d Tools\n• %d Parts",
            #results.NPCs,
            #results.Players,
            #results.Models,
            #results.Tools,
            #results.Parts
        )
        helpers.Notify("Explorer", message, 5)
        
        -- Refresh UI
        gui:ClearContent()
        ExplorerScript.Execute(gui, helpers)
    end)
    
    gui:AddLabel("")
    
    -- NPC Groups
    if ExplorerCache.NPCs and #ExplorerCache.NPCs > 0 then
        gui:AddLabel("NPC Groups (" .. #ExplorerCache.NPCs .. ")", "👾")
        gui:AddLabel("")
        
        gui:AddButton("Create NPC Target Group", "🎯", function()
            CreateTargetGroup("NPCs", ExplorerCache.NPCs)
            helpers.Notify("Explorer", "Created NPC target group", 2)
            gui:ClearContent()
            ExplorerScript.Execute(gui, helpers)
        end)
        
        gui:AddButton("Show NPC Details", "📋", function()
            if #ExplorerCache.NPCs > 0 then
                local npc = ExplorerCache.NPCs[1]
                local info = GetObjectInfo(npc)
                local details = string.format(
                    "Name: %s\nClass: %s\nChildren: %d\nHas Humanoid: %s",
                    info.Name,
                    info.ClassName,
                    info.Children,
                    tostring(info.HasHumanoid)
                )
                helpers.Notify("NPC Info", details, 5)
            end
        end)
        
        gui:AddLabel("")
    end
    
    -- Target Groups Management
    if next(TargetGroups) then
        gui:AddLabel("Target Groups", "🎯")
        gui:AddLabel("")
        
        for groupName, group in pairs(TargetGroups) do
            gui:AddButton(
                string.format("%s (%d objects)", groupName, #group.Objects),
                "📦",
                function()
                    -- Show group options
                    gui:ClearContent()
                    gui:AddLabel("Group: " .. groupName, "🎯")
                    gui:AddLabel("")
                    gui:AddLabel("Objects: " .. #group.Objects, "📦")
                    gui:AddLabel("")
                    
                    gui:AddButton(
                        group.ESPEnabled and "Disable ESP" or "Enable ESP",
                        "👁️",
                        function()
                            if group.ESPEnabled then
                                RemoveESPFromGroup(groupName)
                                helpers.Notify("Group ESP", "Disabled for " .. groupName, 2)
                            else
                                ApplyESPToGroup(groupName)
                                helpers.Notify("Group ESP", "Enabled for " .. groupName, 2)
                            end
                            gui:ClearContent()
                            ExplorerScript.Execute(gui, helpers)
                        end
                    )
                    
                    gui:AddButton("Change Color: Red", "🔴", function()
                        group.Color = Color3.fromRGB(255, 0, 0)
                        if group.ESPEnabled then
                            RemoveESPFromGroup(groupName)
                            ApplyESPToGroup(groupName)
                        end
                        helpers.Notify("Group", "Color changed", 2)
                    end)
                    
                    gui:AddButton("Change Color: Green", "🟢", function()
                        group.Color = Color3.fromRGB(0, 255, 0)
                        if group.ESPEnabled then
                            RemoveESPFromGroup(groupName)
                            ApplyESPToGroup(groupName)
                        end
                        helpers.Notify("Group", "Color changed", 2)
                    end)
                    
                    gui:AddButton("Change Color: Blue", "🔵", function()
                        group.Color = Color3.fromRGB(0, 100, 255)
                        if group.ESPEnabled then
                            RemoveESPFromGroup(groupName)
                            ApplyESPToGroup(groupName)
                        end
                        helpers.Notify("Group", "Color changed", 2)
                    end)
                    
                    gui:AddLabel("")
                    
                    gui:AddButton("Expand All Hitboxes", "📏", function()
                        for _, obj in pairs(group.Objects) do
                            if obj and obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                                local hrp = obj.HumanoidRootPart
                                hrp.Size = Vector3.new(10, 10, 10)
                                hrp.Transparency = 0.8
                                hrp.CanCollide = false
                            end
                        end
                        helpers.Notify("Group", "Hitboxes expanded", 2)
                    end)
                    
                    gui:AddButton("Reset Hitboxes", "🔄", function()
                        for _, obj in pairs(group.Objects) do
                            if obj and obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                                local hrp = obj.HumanoidRootPart
                                hrp.Size = Vector3.new(2, 2, 1)
                                hrp.Transparency = 1
                            end
                        end
                        helpers.Notify("Group", "Hitboxes reset", 2)
                    end)
                    
                    gui:AddLabel("")
                    
                    gui:AddButton("Delete Group", "🗑️", function()
                        RemoveESPFromGroup(groupName)
                        TargetGroups[groupName] = nil
                        helpers.Notify("Group", "Deleted " .. groupName, 2)
                        gui:ClearContent()
                        ExplorerScript.Execute(gui, helpers)
                    end)
                    
                    gui:AddLabel("")
                    
                    gui:AddButton("← Back to Explorer", "◀️", function()
                        gui:ClearContent()
                        ExplorerScript.Execute(gui, helpers)
                    end)
                end
            )
        end
        
        gui:AddLabel("")
    end
    
    -- Advanced Tools
    gui:AddLabel("Advanced Tools", "🔧")
    gui:AddLabel("")
    
    gui:AddButton("List All Humanoids", "👤", function()
        local humanoids = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") then
                table.insert(humanoids, obj)
            end
        end
        helpers.Notify("Explorer", "Found " .. #humanoids .. " Humanoids", 3)
    end)
    
    gui:AddButton("Find Models with Name", "🔍", function()
        -- Example: Find all models containing "Enemy" in name
        local found = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower():find("enemy") then
                table.insert(found, obj)
            end
        end
        
        if #found > 0 then
            CreateTargetGroup("Enemies", found)
            helpers.Notify("Explorer", "Found " .. #found .. " enemies, created group", 3)
            gui:ClearContent()
            ExplorerScript.Execute(gui, helpers)
        else
            helpers.Notify("Explorer", "No enemies found", 2)
        end
    end)
    
    gui:AddButton("Clear All Groups", "🧹", function()
        for groupName, _ in pairs(TargetGroups) do
            RemoveESPFromGroup(groupName)
        end
        TargetGroups = {}
        helpers.Notify("Explorer", "All groups cleared", 2)
        gui:ClearContent()
        ExplorerScript.Execute(gui, helpers)
    end)
    
    gui:AddLabel("")
    gui:AddLabel("Tip: Scan workspace first to explore objects", "💡")
end

return ExplorerScript