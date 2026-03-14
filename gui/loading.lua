-- Loading Screen with Animation
-- Beautiful intro animation for NaverHub

local LoadingScreen = {}

function LoadingScreen.Show()
    -- Create loading screen GUI
    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "NaverHubLoading"
    LoadingGui.ResetOnSpawn = false
    LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LoadingGui.IgnoreGuiInset = true
    LoadingGui.Parent = game:GetService("CoreGui")
    
    -- Background
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Background.BorderSizePixel = 0
    Background.Parent = LoadingGui
    
    -- Gradient background
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
    }
    Gradient.Rotation = 45
    Gradient.Parent = Background
    
    -- Logo container
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Size = UDim2.new(0, 300, 0, 300)
    LogoContainer.Position = UDim2.new(0.5, -150, 0.5, -200)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = Background
    
    -- Logo icon
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(1, 0, 0, 150)
    Logo.BackgroundTransparency = 1
    Logo.Text = "🚀"
    Logo.TextColor3 = Color3.fromRGB(150, 150, 255)
    Logo.TextSize = 120
    Logo.Font = Enum.Font.GothamBold
    Logo.TextTransparency = 1
    Logo.Parent = LogoContainer
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 80)
    Title.Position = UDim2.new(0, 0, 0, 160)
    Title.BackgroundTransparency = 1
    Title.Text = "NaverHub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 48
    Title.Font = Enum.Font.GothamBold
    Title.TextTransparency = 1
    Title.Parent = LogoContainer
    
    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 40)
    Subtitle.Position = UDim2.new(0, 0, 0, 240)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Advanced Exploit Tools"
    Subtitle.TextColor3 = Color3.fromRGB(150, 150, 255)
    Subtitle.TextSize = 20
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextTransparency = 1
    Subtitle.Parent = LogoContainer
    
    -- Loading bar container
    local BarContainer = Instance.new("Frame")
    BarContainer.Size = UDim2.new(0, 400, 0, 6)
    BarContainer.Position = UDim2.new(0.5, -200, 0.5, 150)
    BarContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    BarContainer.BorderSizePixel = 0
    BarContainer.BackgroundTransparency = 1
    BarContainer.Parent = Background
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = BarContainer
    
    -- Loading bar
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.BackgroundColor3 = Color3.fromRGB(150, 150, 255)
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = BarContainer
    
    local LoadingBarCorner = Instance.new("UICorner")
    LoadingBarCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarCorner.Parent = LoadingBar
    
    -- Loading bar gradient
    local BarGradient = Instance.new("UIGradient")
    BarGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 255))
    }
    BarGradient.Parent = LoadingBar
    
    -- Status text
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(0, 400, 0, 30)
    StatusText.Position = UDim2.new(0.5, -200, 0.5, 170)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Initializing..."
    StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusText.TextSize = 14
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextTransparency = 1
    StatusText.Parent = Background
    
    -- Animation service
    local TweenService = game:GetService("TweenService")
    
    -- Fade in logo
    TweenService:Create(Logo, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    wait(0.3)
    
    -- Fade in title
    TweenService:Create(Title, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    wait(0.2)
    
    -- Fade in subtitle
    TweenService:Create(Subtitle, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    wait(0.3)
    
    -- Fade in bar container
    TweenService:Create(BarContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play()
    
    -- Fade in status text
    TweenService:Create(StatusText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    wait(0.5)
    
    -- Loading stages
    local stages = {
        {text = "Loading modules...", progress = 0.2},
        {text = "Initializing ESP system...", progress = 0.4},
        {text = "Setting up aimbot...", progress = 0.6},
        {text = "Loading scanner...", progress = 0.8},
        {text = "Finalizing...", progress = 1.0}
    }
    
    for _, stage in ipairs(stages) do
        StatusText.Text = stage.text
        TweenService:Create(LoadingBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(stage.progress, 0, 1, 0)
        }):Play()
        wait(0.6)
    end
    
    wait(0.3)
    
    StatusText.Text = "Ready!"
    StatusText.TextColor3 = Color3.fromRGB(100, 255, 150)
    
    wait(0.5)
    
    -- Fade out animation
    TweenService:Create(Background, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(Logo, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(StatusText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    }):Play()
    
    wait(0.5)
    
    -- Remove loading screen
    LoadingGui:Destroy()
end

return LoadingScreen