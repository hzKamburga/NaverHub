# Installation Guide

## How to Use NaverHub

### Method 1: GitHub Raw Link (Easiest)

Simply execute this in your Roblox executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/main.lua"))()
```

Or use the standalone version:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/standalone.lua"))()
```

### Method 2: Local Execution (For Testing)

1. Copy the contents of `standalone.lua`
2. Paste into your Roblox executor
3. Execute

## Controls

- **Right Shift**: Toggle GUI visibility
- **Drag**: Click and drag the header to move the window
- **X Button**: Close/hide the GUI
- **- Button**: Minimize the GUI

## Features

### Home Tab
- Welcome screen with hub information
- Feature list and instructions

### Player Tools Tab
- Walkspeed modification (16, 50)
- Jump power modification (50, 100)
- Character reset/heal functions

### Game Utils Tab
- Anti-AFK system
- Game information display
- FPS and ping monitoring
- Fullbright toggle
- Lighting reset
- Fog removal
- Infinite jump toggle

### Settings Tab
- Theme selection (6 themes: Default, Dark, Ocean, Purple, Red, Green)
- Position saving
- GUI customization

### About Tab
- Hub information
- Credits
- Additional utilities

## Customization

### Adding New Scripts

1. Create a new file in `scripts/` folder (e.g., `example3.lua`)
2. Follow this template:

```lua
local Script3 = {}

function Script3.GetInfo()
    return {
        Name = "Your Script Name",
        Description = "Description here",
        Author = "Your Name",
        Version = "1.0"
    }
end

function Script3.Execute(gui, helpers)
    gui:ClearContent()
    gui:AddLabel("=== Your Script ===")
    
    gui:AddButton("Button Name", function()
        -- Your code here
        helpers.Notify("Success", "Action completed", 2)
    end)
end

return Script3
```

3. Load it in `main.lua`:
```lua
local Script3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/hzKamburga/NaverHub/main/scripts/example3.lua"))()
```

4. Add a tab for it:
```lua
local script3Tab = gui:AddTab("Your Tab", function()
    Script3.Execute(gui, Helpers)
end)
```

### Creating Custom Themes

Edit `gui/themes.lua` and add a new theme:

```lua
Themes.YourTheme = {
    Name = "YourTheme",
    MainColor = Color3.fromRGB(R, G, B),
    BackgroundColor = Color3.fromRGB(R, G, B),
    TextColor = Color3.fromRGB(R, G, B),
    AccentColor = Color3.fromRGB(R, G, B),
    SuccessColor = Color3.fromRGB(R, G, B),
    ErrorColor = Color3.fromRGB(R, G, B),
    WarningColor = Color3.fromRGB(R, G, B)
}
```

## Important Notes

- This hub is for **educational purposes only**
- Always follow Roblox Terms of Service
- Use responsibly and ethically
- Test in private servers first
- Some features may not work in all games
- Executor compatibility may vary

## Troubleshooting

### GUI doesn't appear
- Check if your executor supports `game:GetService("CoreGui")`
- Try pressing Right Shift to toggle visibility
- Restart the script

### Scripts don't work
- Ensure all modules are loaded correctly
- Check console for error messages
- Verify executor compatibility

### Theme not saving
- Your executor may not support `writefile`/`readfile`
- Themes will reset on each execution

## Support

For issues or questions:
- Check the console for error messages
- Verify all files are loaded correctly
- Ensure your executor is up to date

## Legal Disclaimer

This script hub is created for educational purposes to demonstrate Lua scripting concepts in Roblox. Users are responsible for ensuring their use complies with Roblox's Terms of Service. The creators are not responsible for any misuse or consequences resulting from the use of this software.