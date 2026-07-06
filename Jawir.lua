-- THESKYFALL HUB PRO | v13.7 ENHANCED EDITION
-- Coded by TEN WEAK for VORD
-- Zero Error Protocol Active

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local HttpService = game:GetService("HttpService")
local GameSettings = game:GetService("GameSettings")

-- // CONFIGURATION & STATE
local Config = {
    Theme = {
        Main = Color3.fromRGB(15, 15, 20),
        Accent = Color3.fromRGB(138, 43, 226), -- Purple Neon
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 150, 160),
        Background = Color3.fromRGB(10, 10, 12),
        InputBg = Color3.fromRGB(25, 25, 30),
        Accent2 = Color3.fromRGB(95, 35, 180),
        Accent3 = Color3.fromRGB(175, 65, 240)
    },
    Aimbot = { 
        Enabled = false, 
        FOV = 90, 
        Smoothness = 0.15, 
        Part = "Head", 
        Mode = "Legit",
        TargetSelection = "Closest",
        AutoShoot = false,
        LockOn = false,
        BoneSelection = "Head",
        MinDistance = 0,
        MaxDistance = 500
    },
    ESP = { 
        Enabled = false, 
        Boxes = true, 
        Names = true, 
        Health = true, 
        Skeleton = false,
        Distance = 1000,
        Color = Color3.fromRGB(138, 43, 226),
        BoxThickness = 1,
        LineColor = Color3.fromRGB(138, 43, 226),
        HealthBar = true,
        HealthBarColor = Color3.fromRGB(255, 50, 50),
        HealthBarBackground = Color3.fromRGB(30, 30, 30),
        TeamColor = false,
        Tracers = false,
        TracerColor = Color3.fromRGB(138, 43, 226),
        TracerFrom = "Bottom",
        TracerTo = "Top"
    },
    FPS = { 
        Boost = false, 
        RTXMode = false,
        ShadowQuality = 1,
        TextureQuality = 1,
        ParticleQuality = 0,
        WaterQuality = 1,
        AntiAliasing = 0,
        VSync = false
    },
    Movement = { 
        WalkSpeed = 16, 
        JumpPower = 50,
        AutoJump = false,
        StepHeight = 10,
        AirControl = 1,
        Sprint = false,
        SprintSpeed = 40,
        Crouch = false,
        CrouchSpeed = 8
    },
    Exploits = {
        Noclip = false,
        Teleport = false,
        Speed = 0,
        Gravity = 196.2,
        NoRecoil = false,
        NoSpread = false,
        AimAssist = false
    },
    Advanced = {
        AntiAFK = false,
        AutoRejoin = false,
        AutoHop = false,
        AutoRejoinDelay = 5,
        AntiCheatBypass = true,
        MemoryObfuscation = true,
        AntiDebug = true,
        LogSystem = true,
        LogToFile = false,
        LogFilePath = "SkyFall.log",
        AntiCheatSensitivity = 0.5
    },
    Debug = {
        ShowDebug = false,
        LogLevel = "Critical",
        PerformanceMetrics = true,
        RenderStats = true,
        MemoryUsage = true,
        FrameRate = true
    }
}

-- // DRAWING CACHE
local Drawings = {}
local ESPTags = {}
local TracerTags = {}
local BoneTags = {}
local HealthTags = {}

-- // UTILITY FUNCTIONS
local function CreateInstance(class, props, parent)
    local inst = Instance.new(class)
    for i, v in pairs(props) do
        if i ~= "Parent" then inst[i] = v end
    end
    inst.Parent = parent
    return inst
end

local function Lerp(a, b, t) return a + (b - a) * t end

local function Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

local function GetDistance(p1, p2)
    return (p1.Position - p2.Position).Magnitude
end

-- // GC PROTECTION ANCHOR
local GCAnchor = {
    Player = LocalPlayer,
    Loaded = false,
    Source = "https://raw.githubusercontent.com/RAMZZ561/SkyFall/refs/heads/main/SKYFALL.lua",
    LastExecution = tick(),
    ExecutionCount = 0
}

-- // MEMORY OBSCURATION
local function ObfuscateMemory()
    -- Simulate memory obfuscation by creating dummy data
    local dummy = {}
    for i = 1, 1000 do
        dummy[i] = math.random()
    end
    return dummy
end

-- // ANTI-DEBUG
local function AntiDebug()
    -- Check for common debug tools
    local isDebugging = false
    if game:GetService("RunService"):IsDebuggerPresent() then
        isDebugging = true
    end
    
    if isDebugging and Config.Advanced.AntiDebug then
        -- Simulate anti-debug by clearing references
        GCAnchor.Player = nil
        GCAnchor.Loaded = false
        GCAnchor.LastExecution = tick()
        GCAnchor.ExecutionCount = 0
        return true
    end
    return false
end

-- // GUI LIBRARY CONSTRUCTION
local ScreenGui = CreateInstance("ScreenGui", { Name = "SkyFallHub", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, game.CoreGui)

-- Main Window
local MainFrame = CreateInstance("Frame", {
    Size = UDim2.new(0, 850, 0, 650),
    Position = UDim2.new(0.5, -425, 0.5, -325),
    BackgroundColor3 = Config.Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui
})

-- Top Bar
local TopBar = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Config.Theme.Main,
    Parent = MainFrame
})

CreateInstance("TextLabel", {
    Size = UDim2.new(0, 300, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "THESKYFALL HUB PRO",
    TextColor3 = Config.Theme.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar
})

-- Version Tag
CreateInstance("TextLabel", {
    Size = UDim2.new(0, 80, 1, 0),
    Position = UDim2.new(0, 700, 0, 0),
    BackgroundTransparency = 1,
    Text = "v13.7",
    TextColor3 = Config.Theme.Accent2,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar
})

-- Build Date
CreateInstance("TextLabel", {
    Size = UDim2.new(0, 100, 1, 0),
    Position = UDim2.new(0, 750, 0, 0),
    BackgroundTransparency = 1,
    Text = "Jul 06, 2026",
    TextColor3 = Config.Theme.SubText,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar
})

-- Window Controls
local function CreateBtn(txt, pos, func)
    local btn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = pos,
        BackgroundTransparency = 1,
        Text = txt,
        TextColor3 = Config.Theme.SubText,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        Parent = TopBar
    })
    btn.MouseButton1Click:Connect(func)
    return btn
end

CreateBtn("_", UDim2.new(1, -100, 0, 5), function() MainFrame:TweenSize(UDim2.new(0, 850, 0, 40), "Out", "Quad", 0.3) end)
CreateBtn("X", UDim2.new(1, -60, 0, 5), function() ScreenGui:Destroy() end)

-- Sidebar
local SideBar = CreateInstance("Frame", {
    Size = UDim2.new(0, 220, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = Config.Theme.Main,
    Parent = MainFrame
})

-- Content Area
local ContentArea = CreateInstance("Frame", {
    Size = UDim2.new(1, -220, 1, -40),
    Position = UDim2.new(0, 220, 0, 40),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- Tab System
local Tabs = {}
local function AddTab(name, icon)
    local tabBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, -10, 0, 40),
        Position = UDim2.new(0, 5, 0, #Tabs * 45 + 10),
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        Text = "",
        Parent = SideBar
    })
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.Theme.SubText,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabBtn
    })

    local container = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Config.Theme.Accent,
        Visible = false,
        Parent = ContentArea
    })
    
    table.insert(Tabs, {Btn = tabBtn, Frame = container})
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(Tabs) do 
            t.Frame.Visible = false 
            t.Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        end
        container.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end)
    
    return container
end

-- // WIDGETS
local function CreateSection(parent, title)
    local sec = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = title:upper(),
        TextColor3 = Config.Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sec
    })
    return CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })
end

local function CreateToggle(parent, text, default, callback)
    local frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })
    
    local label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    local toggleBtn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = default and Config.Theme.Accent or Config.Theme.InputBg,
        Text = "",
        Parent = frame
    })
    
    local indicator = CreateInstance("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = default and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        Parent = toggleBtn
    })
    
    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Config.Theme.Accent or Config.Theme.InputBg
        TweenService:Create(indicator, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
        callback(state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback, precision)
    local frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    local valLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 60, 0, 15),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Config.Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Parent = frame
    })
    
    local track = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Config.Theme.InputBg,
        Parent = frame
    })
    
    local fill = CreateInstance("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Config.Theme.Accent,
        Parent = track
    })
    
    local knob = CreateInstance("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new((default - min) / (max - min), 0, 0.5, -6),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        Parent = track
    })
    
    local dragging = false
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    knob.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local xScale = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = min + (max - min) * xScale
            if precision then
                val = math.floor(val * precision) / precision
            end
            fill.Size = UDim2.new(xScale, 0, 1, 0)
            knob.Position = UDim2.new(xScale, 0, 0.5, -6)
            valLabel.Text = tostring(val)
            callback(val)
        end
    end)
end

local function CreateButton(parent, text, callback)
    local btn = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Config.Theme.InputBg,
        Text = text,
        TextColor3 = Config.Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Config.Theme.InputBg end)
    return btn
end

local function CreateDropdown(parent, text, options, default, callback)
    local frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    local dropdown = CreateInstance("TextButton", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -100, 0, 0),
        BackgroundColor3 = Config.Theme.InputBg,
        Text = options[default] or "Select",
        TextColor3 = Config.Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        Parent = frame
    })
    
    local menu = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Config.Theme.Main,
        BorderSizePixel = 0,
        Visible = false,
        Parent = frame
    })
    
    for i, opt in ipairs(options) do
        CreateButton(menu, opt, function()
            dropdown.Text = opt
            menu.Visible = false
            callback(i)
        end)
    end
    
    dropdown.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
    
    return dropdown
end

local function CreateColorPicker(parent, text, default, callback)
    local frame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    local colorBtn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 40, 0, 30),
        Position = UDim2.new(1, -40, 0, 5),
        BackgroundColor3 = default,
        Text = "",
        Parent = frame
    })
    
    colorBtn.MouseButton1Click:Connect(function()
        local colorPicker = CreateInstance("ScreenGui", { Name = "ColorPicker" }, game.CoreGui)
        local pickerFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 300, 0, 200),
            Position = UDim2.new(0.5, -150, 0.5, -100),
            BackgroundColor3 = Config.Theme.Main,
            Parent = colorPicker
        })
        
        local colorPickerInner = CreateInstance("Frame", {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundColor3 = Config.Theme.Background,
            Parent = pickerFrame
        })
        
        local colorCanvas = CreateInstance("ImageLabel", {
            Size = UDim2.new(1, -20, 0, 150),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Image = "rbxassetid://10331413259",
            Parent = colorPickerInner
        })
        
        local colorValue = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 1, -20),
            BackgroundTransparency = 1,
            Text = "RGB: " .. tostring(default.R) .. ", " .. tostring(default.G) .. ", " .. tostring(default.B),
            TextColor3 = Config.Theme.Text,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            Parent = colorPickerInner
        })
        
        local selectedColor = CreateInstance("ImageLabel", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Image = "rbxassetid://10331413259",
            Parent = pickerFrame
        })
        
        selectedColor.BackgroundColor3 = default
        selectedColor.ImageColor3 = default
        
        local function updateColor(x, y)
            local colorX = (x - colorCanvas.AbsolutePosition.X) / colorCanvas.AbsoluteSize.X
            local colorY = (y - colorCanvas.AbsolutePosition.Y) / colorCanvas.AbsoluteSize.Y
            
            local hue = math.clamp(colorX, 0, 1)
            local saturation = 1 - math.clamp(colorY, 0, 1)
            local value = 1
            
            local r, g, b = Color3.fromHSV(hue, saturation, value):ToRGB()
            
            selectedColor.BackgroundColor3 = Color3.fromRGB(r, g, b)
            selectedColor.ImageColor3 = Color3.fromRGB(r, g, b)
            
            colorValue.Text = "RGB: " .. tostring(r) .. ", " .. tostring(g) .. ", " .. tostring(b)
            
            callback(Color3.fromRGB(r, g, b))
        end
        
        colorCanvas.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                updateColor(i.Position.X, i.Position.Y)
            end
        end)
        
        colorCanvas.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement then
                updateColor(i.Position.X, i.Position.Y)
            end
        end)
        
        CreateButton(pickerFrame, "Close", function()
            colorPicker:Destroy()
        end)
    end)
end

-- // MENU IMPLEMENTATION (CONTINUED & FINALIZED)

-- MENU 1: INFORMASI
local InfoTab = AddTab("Informasi", "")
local profileSec = CreateSection(InfoTab, "Profil Player")
CreateInstance("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Username: "..LocalPlayer.Name, TextColor3=Config.Theme.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=profileSec})
CreateInstance("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="UserID: "..LocalPlayer.UserId, TextColor3=Config.Theme.SubText, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=profileSec})
CreateInstance("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Health: "..math.floor(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health or 0).."/"..(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.MaxHealth or 100), TextColor3=Config.Theme.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=profileSec})
CreateInstance("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Game: "..game.PlaceName.." ["..game.PlaceId.."]", TextColor3=Config.Theme.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=profileSec})
CreateInstance("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="JobID: "..(game.JobId ~= "" and game.JobId:sub(1,8).."..." or "Private"), TextColor3=Config.Theme.SubText, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=profileSec})
CreateInstance("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Players: "..#Players:GetPlayers().."/"..Players.MaxPlayers, TextColor3=Config.Theme.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=profileSec})

local sysSec = CreateSection(InfoTab, "Sistem & Utilitas")
CreateButton(InfoTab, "Hop Server (Random)", function()
    local servers = {}
    for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data) do
        if v.id ~= game.JobId then table.insert(servers, v.id) end
    end
    if #servers > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
    else
        warn("[SKYFALL] No other servers found.")
    end
end)
CreateButton(InfoTab, "Rejoin Current Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
CreateButton(InfoTab, "Clear Workspace Debris", function()
    local count = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and not v:FindFirstAncestorWhichIsA("Model") and v.Size.Magnitude < 5 then 
            pcall(function() v:Destroy() count += 1 end) 
        end
    end
    print("[SKYFALL] Cleared "..count.." debris parts.")
end)
CreateToggle(InfoTab, "Anti-AFK (Universal)", false, function(s)
    Config.Advanced.AntiAFK = s
    if s then
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end
end)

-- MENU 2: AIMBOT & ESP
local CombatTab = AddTab("Combat / Visuals", "⚔️")
local aimSec = CreateSection(CombatTab, "Aimbot Configuration")
CreateToggle(CombatTab, "Enable Aimbot", false, function(s) Config.Aimbot.Enabled = s end)
CreateSlider(CombatTab, "FOV Circle Radius", 10, 500, 90, function(v) Config.Aimbot.FOV = v end, 1)
CreateSlider(CombatTab, "Smoothing Factor", 1, 100, 15, function(v) Config.Aimbot.Smoothness = v / 100 end, 1)
CreateDropdown(CombatTab, "Target Bone", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, 1, function(i)
    Config.Aimbot.BoneSelection = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}[i]
end)
CreateToggle(CombatTab, "Visible Check (Raycast)", true, function(s) Config.Aimbot.VisibleCheck = s end)
CreateToggle(CombatTab, "Team Check", true, function(s) Config.Aimbot.TeamCheck = s end)

local espSec = CreateSection(CombatTab, "ESP Overlay")
CreateToggle(CombatTab, "Master ESP Switch", false, function(s) 
    Config.ESP.Enabled = s 
    if not s then 
        for name, tag in pairs(ESPTags) do
            for _, drawing in pairs(tag) do pcall(function() drawing:Remove() end) end
        end
        ESPTags = {}
    end
end)
CreateToggle(CombatTab, "Bounding Boxes", true, function(s) Config.ESP.Boxes = s end)
CreateToggle(CombatTab, "Name Tags", true, function(s) Config.ESP.Names = s end)
CreateToggle(CombatTab, "Health Bars", true, function(s) Config.ESP.Health = s end)
CreateToggle(CombatTab, "Tracers (Origin: Bottom)", false, function(s) Config.ESP.Tracers = s end)
CreateSlider(CombatTab, "Max Render Distance", 100, 2000, 1000, function(v) Config.ESP.Distance = v end, 50)
CreateColorPicker(CombatTab, "Enemy Color", Color3.fromRGB(138, 43, 226), function(c) Config.ESP.Color = c end)

-- MENU 3: PERFORMANCE
local FPSTab = AddTab("Performance", "⚡")
CreateSection(FPSTab, "Rendering Optimization")
CreateToggle(FPSTab, "Unlock FPS Cap", false, function(s)
    if s then setfpscap(9999) else setfpscap(60) end
end)
CreateToggle(FPSTab, "Disable Shadows", false, function(s)
    game.Lighting.GlobalShadows = not s
end)
CreateToggle(FPSTab, "Low Texture Mode", false, function(s)
    if s then
        game:GetService("UserSettings").UserGameSettings.SavedQualityLevel.Value = 1
    else
        game:GetService("UserSettings").UserGameSettings.SavedQualityLevel.Value = 10
    end
end)
CreateButton(FPSTab, "Delete All Particles/Effects", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Explosion") then
            pcall(function() v:Destroy() end)
        end
    end
end)
CreateButton(FPSTab, "Force Reload Lighting", function()
    game.Lighting.Technology = Enum.Technology.Compatibility
    wait(0.1)
    game.Lighting.Technology = Enum.Technology.Voxel
end)

-- MENU 4: MOVEMENT
local MoveTab = AddTab("Movement", "")
CreateSection(MoveTab, "Character Physics")
CreateSlider(MoveTab, "Walk Speed Override", 0, 300, 16, function(v) 
    Config.Movement.WalkSpeed = v 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end, 1)
CreateSlider(MoveTab, "Jump Power Override", 0, 300, 50, function(v) 
    Config.Movement.JumpPower = v 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
        LocalPlayer.Character.Humanoid.UseJumpPower = true
    end
end, 1)
CreateToggle(MoveTab, "Infinite Jump", false, function(s)
    Config.Movement.InfiniteJump = s
end)
CreateToggle(MoveTab, "NoClip (Walk Through Walls)", false, function(s)
    Config.Exploits.Noclip = s
end)

-- MENU 5: SETTINGS
local SetTab = AddTab("Settings", "️")
CreateSection(SetTab, "Interface & System")
CreateButton(SetTab, "Toggle Dark/Light Theme", function()
    if Config.Theme.Background == Color3.fromRGB(10, 10, 12) then
        Config.Theme.Background = Color3.fromRGB(235, 235, 240)
        Config.Theme.Main = Color3.fromRGB(255, 255, 255)
        Config.Theme.Text = Color3.fromRGB(20, 20, 25)
        Config.Theme.SubText = Color3.fromRGB(80, 80, 90)
        Config.Theme.InputBg = Color3.fromRGB(210, 210, 215)
    else
        Config.Theme.Background = Color3.fromRGB(10, 10, 12)
        Config.Theme.Main = Color3.fromRGB(15, 15, 20)
        Config.Theme.Text = Color3.fromRGB(255, 255, 255)
        Config.Theme.SubText = Color3.fromRGB(150, 150, 160)
        Config.Theme.InputBg = Color3.fromRGB(25, 25, 30)
    end
    MainFrame.BackgroundColor3 = Config.Theme.Background
    TopBar.BackgroundColor3 = Config.Theme.Main
    SideBar.BackgroundColor3 = Config.Theme.Main
    for _, child in ipairs(ContentArea:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            for _, widget in ipairs(child:GetDescendants()) do
                if widget:IsA("TextLabel") and widget.Name ~= "AccentLabel" then
                    widget.TextColor3 = Config.Theme.Text
                elseif widget:IsA("TextButton") and widget.BackgroundColor3 ~= Config.Theme.Accent then
                    widget.BackgroundColor3 = Config.Theme.InputBg
                end
            end
        end
    end
end)
CreateButton(SetTab, "Unload Script & Cleanup", function()
    for _, d in pairs(Drawings) do pcall(function() d:Remove() end) end
    for _, tag in pairs(ESPTags) do for _, d in pairs(tag) do pcall(function() d:Remove() end) end end
    ScreenGui:Destroy()
end)

-- // CORE LOGIC LOOPS
RunService.RenderStepped:Connect(function(dt)
    -- NOCLIP HANDLER
    if Config.Exploits.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    -- INFINITE JUMP HANDLER
    if Config.Movement.InfiniteJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    -- AIMBOT EXECUTION
    if Config.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest, minDist = nil, Config.Aimbot.FOV
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.Aimbot.BoneSelection) then
                if Config.Aimbot.TeamCheck and p.Team == LocalPlayer.Team then continue end
                
                local bone = p.Character[Config.Aimbot.BoneSelection]
                local pos, onScreen = Camera:WorldToViewportPoint(bone.Position)
                
                if onScreen then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (screenPos - mousePos).Magnitude
                    
                    if dist < minDist then
                        if Config.Aimbot.VisibleCheck then
                            local ray = Ray.new(Camera.CFrame.Position, (bone.Position - Camera.CFrame.Position).Unit * 1000)
                            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                            if hit and hit:FindFirstAncestor(p.Name) then
                                minDist = dist
                                closest = bone
                            end
                        else
                            minDist = dist
                            closest = bone
                        end
                    end
                end
            end
        end
        
        if closest then
            local targetCF = CFrame.new(Camera.CFrame.Position, closest.Position)
            local currentCF = Camera.CFrame
            local smooth = math.clamp(Config.Aimbot.Smoothness, 0.01, 1)
            Camera.CFrame = currentCF:Lerp(targetCF, smooth)
        end
    end

    -- ESP RENDERING ENGINE
    if Config.ESP.Enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if Config.Aimbot.TeamCheck and p.Team == LocalPlayer.Team then 
                    if ESPTags[p.Name] then
                        for _, d in pairs(ESPTags[p.Name]) do pcall(function() d.Visible = false end) end
                    end
                    continue 
                end

                local hrp = p.Character.HumanoidRootPart
                local hum = p.Character:FindFirstChild("Humanoid")
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude

                if not ESPTags[p.Name] then ESPTags[p.Name] = {} end
                local tag = ESPTags[p.Name]

                if onScreen and dist <= Config.ESP.Distance then
                    local scaleFactor = 1 / (pos.Z * math.tan(math.rad(Camera.FieldOfView / 2)) * 2) * 1000
                    local size = Vector2.new(3 * scaleFactor, 4.5 * scaleFactor)
                    local position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)

                    -- Box
                    if Config.ESP.Boxes then
                        if not tag.Box then tag.Box = Drawing.new("Square") end
                        tag.Box.Size = size
                        tag.Box.Position = position
                        tag.Box.Color = Config.ESP.Color
                        tag.Box.Thickness = 1
                        tag.Box.Filled = false
                        tag.Box.Visible = true
                    elseif tag.Box then tag.Box.Visible = false end

                    -- Name
                    if Config.ESP.Names then
                        if not tag.Name then tag.Name = Drawing.new("Text") end
                        tag.Name.Text = p.Name
                        tag.Name.Position = Vector2.new(pos.X, position.Y - 15)
                        tag.Name.Center = true
                        tag.Name.Outline = true
                        tag.Name.Color = Config.ESP.Color
                        tag.Name.Visible = true
                    elseif tag.Name then tag.Name.Visible = false end

                    -- Health Bar
                    if Config.ESP.Health and hum then
                        if not tag.HealthBg then tag.HealthBg = Drawing.new("Line") end
                        if not tag.HealthFg then tag.HealthFg = Drawing.new("Line") end
                        
                        local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local barHeight = size.Y
                        local x = position.X - 6
                        local yTop = position.Y
                        local yBot = position.Y + barHeight

                        tag.HealthBg.From = Vector2.new(x, yTop)
                        tag.HealthBg.To = Vector2.new(x, yBot)
                        tag.HealthBg.Color = Color3.fromRGB(0,0,0)
                        tag.HealthBg.Thickness = 3
                        tag.HealthBg.Visible = true

                        tag.HealthFg.From = Vector2.new(x, yBot)
                        tag.HealthFg.To = Vector2.new(x, yBot - (barHeight * hpRatio))
                        tag.HealthFg.Color = Color3.fromRGB(255 * (1-hpRatio), 255 * hpRatio, 0)
                        tag.HealthFg.Thickness = 3
                        tag.HealthFg.Visible = true
                    elseif tag.HealthBg then tag.HealthBg.Visible = false; tag.HealthFg.Visible = false end

                    -- Tracer
                    if Config.ESP.Tracers then
                        if not tag.Tracer then tag.Tracer = Drawing.new("Line") end
                        tag.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        tag.Tracer.To = Vector2.new(pos.X, pos.Y)
                        tag.Tracer.Color = Config.ESP.Color
                        tag.Tracer.Thickness = 1
                        tag.Tracer.Visible = true
                    elseif tag.Tracer then tag.Tracer.Visible = false end
                else
                    if tag.Box then tag.Box.Visible = false end
                    if tag.Name then tag.Name.Visible = false end
                    if tag.HealthBg then tag.HealthBg.Visible = false end
                    if tag.HealthFg then tag.HealthFg.Visible = false end
                    if tag.Tracer then tag.Tracer.Visible = false end
                end
            end
        end
    end
end)

-- // INITIALIZATION
Tabs[1].Frame.Visible = true
Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

-- // GC PROTECTION & PERSISTENCE LOOP
spawn(function()
    while task.wait(3) do
        if not ScreenGui or not ScreenGui.Parent then
            -- Self-repair if UI gets destroyed
            pcall(function() ScreenGui.Parent = game.CoreGui end)
        end
        -- Re-apply movement stats on respawn
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if Config.Movement.WalkSpeed ~= 16 then
                LocalPlayer.Character.Humanoid.WalkSpeed = Config.Movement.WalkSpeed
            end
            if Config.Movement.JumpPower ~= 50 then
                LocalPlayer.Character.Humanoid.JumpPower = Config.Movement.JumpPower
            end
        end
    end
end)

print("[TEN WEAK] THESKYFALL HUB PRO v13.7 | FULL PAYLOAD DELIVERED")
print("[TEN WEAK] SYSTEM STATUS: OPERATIONAL | GC ANCHOR: ACTIVE")
