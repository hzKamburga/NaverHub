-- ESP & Aimbot Script
-- Advanced player detection and targeting system

local ESPScript = {}

-- ESP Settings
local ESPEnabled = false
local ESPColor = Color3.fromRGB(255, 0, 0)
local ESPTransparency = 0.5
local ESPBoxes = {}
local ESPTracers = {}
local ESPNames = {}

-- Aimbot Settings
local AimbotEnabled = false
local AimbotFOV = 100
local AimbotSmoothing = 0.1
local AimbotTarget = nil
local AimbotTeamCheck = true

-- Hitbox Settings
local HitboxEnabled = false
local HitboxSize = 10

function ESPScript.GetInfo()
    return {
        Name = "ESP & Aimbot",
        Description = "Advanced player detection and targeting",
        Author = "NaverHub",
        Version = "1.0"
    }
end

-- ESP Functions
local function CreateESPBox(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local hrp = player.Character.HumanoidRootPart
    
    -- Create box
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Color3 = ESPColor
    box.Transparency = ESPTransparency
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Adornee = hrp
    box.Parent = hrp
    
    -- Create tracer
    local tracer = Instance.new("Beam")
    local att0 = Instance.new("Attachment", workspace.CurrentCamera)
    local att1 = Instance.new("Attachment", hrp)
    tracer.Attachment0 = att0
    tracer.Attachment1 = att1
    tracer.Color = ColorSequence.new(ESPColor)
    tracer.FaceCamera = true
    tracer.Width0 = 0.1
    tracer.Width1 = 0.1
    tracer.Parent = workspace.CurrentCamera
    
    -- Create name tag
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = ESPColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    ESPBoxes[player] = box
    ESPTracers[player] = tracer
    ESPNames[player] = billboard
end

local function RemoveESP(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Destroy()
        ESPBoxes[player] = nil
    end
    if ESPTracers[player] then
        ESPTracers[player]:Destroy()
        ESPTracers[player] = nil
    end
    if ESPNames[player] then
        ESPNames[player]:Destroy()
        ESPNames[player] = nil
    end
end

local function UpdateESP()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer then
            if ESPEnabled then
                if not ESPBoxes[player] then
                    CreateESPBox(player)
                end
            else
                RemoveESP(player)
            end
        end
    end
end

-- Aimbot Functions
local function GetClosestPlayer()
    local localPlayer = game:GetService("Players").LocalPlayer
    local camera = workspace.CurrentCamera
    local closestPlayer = nil
    local shortestDistance = AimbotFOV
    
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if AimbotTeamCheck and player.Team == localPlayer.Team then
                continue
            end
            
            local head = player.Character.Head
            local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
            
            if onScreen then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

local function AimAt(target)
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then
        return
    end
    
    local camera = workspace.CurrentCamera
    local head = target.Character.Head
    local targetPos = head.Position
    
    -- Smooth aiming
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.new(camera.CFrame.Position, targetPos)
    camera.CFrame = currentCFrame:Lerp(targetCFrame, AimbotSmoothing)
end

-- Hitbox Expansion
local function ExpandHitbox(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local hrp = player.Character.HumanoidRootPart
    hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
    hrp.Transparency = 0.8
    hrp.CanCollide = false
end

local function ResetHitbox(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local hrp = player.Character.HumanoidRootPart
    hrp.Size = Vector3.new(2, 2, 1)
    hrp.Transparency = 1
end

-- Main Execute Function
function ESPScript.Execute(gui, helpers)
    gui:ClearContent()
    
    gui:AddLabel("ESP & Aimbot System", "🎯")
    gui:AddLabel("")
    
    -- ESP Section
    gui:AddLabel("ESP Settings", "👁️")
    gui:AddLabel("")
    
    gui:AddButton(ESPEnabled and "Disable ESP" or "Enable ESP", "📦", function()
        ESPEnabled = not ESPEnabled
        UpdateESP()
        helpers.Notify("ESP", ESPEnabled and "ESP Enabled" or "ESP Disabled", 2)
        ESPScript.Execute(gui, helpers)
    end)
    
    gui:AddButton("Change ESP Color: Red", "🔴", function()
        ESPColor = Color3.fromRGB(255, 0, 0)
        helpers.Notify("ESP", "Color changed to Red", 2)
    end)
    
    gui:AddButton("Change ESP Color: Green", "🟢", function()
        ESPColor = Color3.fromRGB(0, 255, 0)
        helpers.Notify("ESP", "Color changed to Green", 2)
    end)
    
    gui:AddButton("Change ESP Color: Blue", "🔵", function()
        ESPColor = Color3.fromRGB(0, 100, 255)
        helpers.Notify("ESP", "Color changed to Blue", 2)
    end)
    
    gui:AddLabel("")
    
    -- Aimbot Section
    gui:AddLabel("Aimbot Settings", "🎯")
    gui:AddLabel("")
    
    gui:AddButton(AimbotEnabled and "Disable Aimbot" or "Enable Aimbot", "🎯", function()
        AimbotEnabled = not AimbotEnabled
        helpers.Notify("Aimbot", AimbotEnabled and "Aimbot Enabled" or "Aimbot Disabled", 2)
        ESPScript.Execute(gui, helpers)
    end)
    
    gui:AddButton("FOV: Small (50)", "🔍", function()
        AimbotFOV = 50
        helpers.Notify("Aimbot", "FOV set to 50", 2)
    end)
    
    gui:AddButton("FOV: Medium (100)", "🔍", function()
        AimbotFOV = 100
        helpers.Notify("Aimbot", "FOV set to 100", 2)
    end)
    
    gui:AddButton("FOV: Large (200)", "🔍", function()
        AimbotFOV = 200
        helpers.Notify("Aimbot", "FOV set to 200", 2)
    end)
    
    gui:AddButton(AimbotTeamCheck and "Disable Team Check" or "Enable Team Check", "👥", function()
        AimbotTeamCheck = not AimbotTeamCheck
        helpers.Notify("Aimbot", AimbotTeamCheck and "Team Check Enabled" or "Team Check Disabled", 2)
        ESPScript.Execute(gui, helpers)
    end)
    
    gui:AddLabel("")
    
    -- Hitbox Section
    gui:AddLabel("Hitbox Expansion", "📏")
    gui:AddLabel("")
    
    gui:AddButton(HitboxEnabled and "Disable Hitbox" or "Enable Hitbox", "📦", function()
        HitboxEnabled = not HitboxEnabled
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer then
                if HitboxEnabled then
                    ExpandHitbox(player)
                else
                    ResetHitbox(player)
                end
            end
        end
        helpers.Notify("Hitbox", HitboxEnabled and "Hitbox Enabled" or "Hitbox Disabled", 2)
        ESPScript.Execute(gui, helpers)
    end)
    
    gui:AddButton("Hitbox Size: Small (5)", "📏", function()
        HitboxSize = 5
        helpers.Notify("Hitbox", "Size set to 5", 2)
    end)
    
    gui:AddButton("Hitbox Size: Medium (10)", "📏", function()
        HitboxSize = 10
        helpers.Notify("Hitbox", "Size set to 10", 2)
    end)
    
    gui:AddButton("Hitbox Size: Large (20)", "📏", function()
        HitboxSize = 20
        helpers.Notify("Hitbox", "Size set to 20", 2)
    end)
    
    gui:AddLabel("")
    gui:AddLabel("Note: Use responsibly and ethically", "⚠️")
end

-- Update loops
game:GetService("RunService").RenderStepped:Connect(function()
    if ESPEnabled then
        UpdateESP()
    end
    
    if AimbotEnabled then
        local target = GetClosestPlayer()
        if target then
            AimAt(target)
        end
    end
end)

-- Player added/removed handlers
game:GetService("Players").PlayerAdded:Connect(function(player)
    if ESPEnabled then
        player.CharacterAdded:Wait()
        CreateESPBox(player)
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

return ESPScript