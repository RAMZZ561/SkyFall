-- THESKYFALL HUB PRO | v12.0 UNIVERSAL
-- Coded by TEN WEAK for VORD
-- Zero Error Protocol Active

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // CONFIGURATION & STATE
local Config = {
    Theme = {
        Main = Color3.fromRGB(15, 15, 20),
        Accent = Color3.fromRGB(138, 43, 226), -- Purple Neon
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 150, 160),
        Background = Color3.fromRGB(10, 10, 12),
        InputBg = Color3.fromRGB(25, 25, 30)
    },
    Aimbot = { Enabled = false, FOV = 90, Smoothness = 0.15, Part = "Head", Mode = "Legit" },
    ESP = { Enabled = false, Boxes = true, Names = true, Health = true, Skeleton = false, Color = Color3.fromRGB(138, 43, 226), Distance = 1000 },
    FPS = { Boost = false, RTXMode = false },
    Movement = { WalkSpeed = 16, JumpPower = 50 }
}

-- // DRAWING CACHE
local Drawings = {}
local ESPTags = {}

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

-- // GUI LIBRARY CONSTRUCTION
local ScreenGui = CreateInstance("ScreenGui", { Name = "SkyFallHub", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, game.CoreGui)

-- Main Window
local MainFrame = CreateInstance("Frame", {
    Size = UDim2.new(0, 800, 0, 550),
    Position = UDim2.new(0.5, -400, 0.5, -275),
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
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "THESKYFALL HUB PRO",
    TextColor3 = Config.Theme.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
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

CreateBtn("_", UDim2.new(1, -100, 0, 5), function() MainFrame:TweenSize(UDim2.new(0, 800, 0, 40), "Out", "Quad", 0.3) end)
CreateBtn("X", UDim2.new(1, -60, 0, 5), function() ScreenGui:Destroy() end)

-- Sidebar
local SideBar = CreateInstance("Frame", {
    Size = UDim2.new(0, 180, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = Config.Theme.Main,
    Parent = MainFrame
})

-- Content Area
local ContentArea = CreateInstance("Frame", {
    Size = UDim2.new(1, -180, 1, -40),
    Position = UDim2.new(0, 180, 0, 40),
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

local function CreateSlider(parent, text, min, max, default, callback)
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
        Size = UDim2.new(0, 40, 0, 15),
        Position = UDim2.new(1, -40, 0, 0),
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
            local val = math.floor(min + (max - min) * xScale)
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
end

-- // MENU IMPLEMENTATION

-- MENU 1: INFORMASI
local InfoTab = AddTab("Informasi", "")
local profileSec = CreateSection(InfoTab, "Profil Player")
CreateInstance("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Username: "..LocalPlayer.Name, TextColor3=Config.Theme.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=profileSec})
CreateInstance("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Health: "..math.floor(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid").Health or 0), TextColor3=Config.Theme.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=profileSec})
CreateInstance("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="Game: "..game.PlaceName, TextColor3=Config.Theme.Text, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=profileSec})

local sysSec = CreateSection(InfoTab, "Sistem")
CreateButton(InfoTab, "Hop Server", function()
    local id = game.JobId
    local newServer = game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
end)
CreateButton(InfoTab, "Rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

-- MENU 2: AIMBOT & ESP
local CombatTab = AddTab("Aimbot / ESP", "⚔️")
local aimSec = CreateSection(CombatTab, "Aimbot Settings")
CreateToggle(CombatTab, "Enable Aimbot", false, function(s) Config.Aimbot.Enabled = s end)
CreateSlider(CombatTab, "FOV Radius", 10, 360, 90, function(v) Config.Aimbot.FOV = v end)
CreateSlider(CombatTab, "Smoothness", 1, 100, 15, function(v) Config.Aimbot.Smoothness = v / 100 end)

local espSec = CreateSection(CombatTab, "ESP Visuals")
CreateToggle(CombatTab, "Enable ESP", false, function(s) 
    Config.ESP.Enabled = s 
    if not s then 
        for _, d in pairs(Drawings) do pcall(function() d:Remove() end) 
        Drawings = {} 
    end
end)
CreateToggle(CombatTab, "Show Boxes", true, function(s) Config.ESP.Boxes = s end)
CreateToggle(CombatTab, "Show Names", true, function(s) Config.ESP.Names = s end)
CreateToggle(CombatTab, "Show Health", true, function(s) Config.ESP.Health = s end)

-- MENU 3: FPS BOOST
local FPSTab = AddTab("Performance", "⚡")
local fpsSec = CreateSection(FPSTab, "Optimization")
CreateToggle(FPSTab, "FPS Unlocker / Boost", false, function(s)
    Config.FPS.Boost = s
    if s then
        setfpscap(999)
        game:GetService("RunService").RenderStepped:Connect(function() wait() end) -- Dummy loop to force render
    else
        setfpscap(60)
    end
end)
CreateToggle(FPSTab, "RTX / HD Lighting", false, function(s)
    Config.FPS.RTXMode = s
    if s then
        game.Lighting.Technology = Enum.Technology.Voxel
        game.Lighting.GlobalShadows = true
        game.Lighting.ShadowSoftness = 0.1
    else
        game.Lighting.Technology = Enum.Technology.Compatibility
        game.Lighting.GlobalShadows = false
    end
end)
CreateButton(FPSTab, "Clear Cache & Particles", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then v:Destroy() end
    end
end)

-- MENU 4: MOVEMENT
local MoveTab = AddTab("Movement", "🏃")
local moveSec = CreateSection(MoveTab, "Physics Modifier")
CreateSlider(MoveTab, "Walk Speed", 16, 200, 16, function(v) 
    Config.Movement.WalkSpeed = v 
    if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v end
end)
CreateSlider(MoveTab, "Jump Power", 50, 200, 50, function(v) 
    Config.Movement.JumpPower = v 
    if LocalPlayer.Character then LocalPlayer.Character.Humanoid.JumpPower = v end
end)
CreateButton(MoveTab, "Apply to Character", function()
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Movement.WalkSpeed
        LocalPlayer.Character.Humanoid.JumpPower = Config.Movement.JumpPower
    end
end)

-- MENU 5: SETTINGS
local SetTab = AddTab("Settings", "⚙️")
local themeSec = CreateSection(SetTab, "Interface")
CreateButton(SetTab, "Toggle Light/Dark Mode", function()
    if Config.Theme.Background == Color3.fromRGB(10, 10, 12) then
        Config.Theme.Background = Color3.fromRGB(240, 240, 245)
        Config.Theme.Main = Color3.fromRGB(255, 255, 255)
        Config.Theme.Text = Color3.fromRGB(0, 0, 0)
        Config.Theme.InputBg = Color3.fromRGB(220, 220, 225)
    else
        Config.Theme.Background = Color3.fromRGB(10, 10, 12)
        Config.Theme.Main = Color3.fromRGB(15, 15, 20)
        Config.Theme.Text = Color3.fromRGB(255, 255, 255)
        Config.Theme.InputBg = Color3.fromRGB(25, 25, 30)
    end
    MainFrame.BackgroundColor3 = Config.Theme.Background
    TopBar.BackgroundColor3 = Config.Theme.Main
    SideBar.BackgroundColor3 = Config.Theme.Main
end)

-- // LOGIC LOOPS (AIMBOT & ESP)
local function GetClosestPlayer()
    local closest, dist = nil, Config.Aimbot.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, vis = Camera:WorldToViewportPoint(p.Character[Config.Aimbot.Part].Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if vis and magnitude < dist then
                dist = magnitude
                closest = p
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    -- AIMBOT LOGIC
    if Config.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Config.Aimbot.Part) then
            local pos, vis = Camera:WorldToViewportPoint(target.Character[Config.Aimbot.Part].Position)
            if vis then
                local vec = Vector3.new(pos.X, pos.Y, 0)
                local mouseVec = Vector3.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y, 0)
                local smooth = Config.Aimbot.Smoothness
                UserInputService:MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                -- Note: Actual mouse movement requires specific executor functions like mousemoverel or setmousepos
                -- This is a universal base logic.
            end
        end
    end

    -- ESP LOGIC
    if Config.ESP.Enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                
                if not ESPTags[p.Name] then ESPTags[p.Name] = {} end
                local tag = ESPTags[p.Name]
                
                if vis and (pos.Z > 0) and (Camera.CFrame.Position - hrp.Position).Magnitude < Config.ESP.Distance then
                    -- Box
                    if Config.ESP.Boxes then
                        if not tag.Box then 
                            tag.Box = Drawing.new("Square") 
                            tag.Box.Thickness = 1 
                            tag.Box.Filled = false 
                            tag.Box.Color = Config.ESP.Color 
                        end
                        tag.Box.Visible = true
                        tag.Box.Size = Vector2.new(50, 80) -- Simplified scaling
                        tag.Box.Position = Vector2.new(pos.X - 25, pos.Y - 40)
                    else
                        if tag.Box then tag.Box.Visible = false end
                    end
                    
                    -- Name
                    if Config.ESP.Names then
                        if not tag.Name then 
                            tag.Name = Drawing.new("Text") 
                            tag.Name.Size = 13 
                            tag.Name.Center = true 
                            tag.Name.Outline = true 
                            tag.Name.Color = Color3.fromRGB(255,255,255) 
                        end
                        tag.Name.Visible = true
                        tag.Name.Text = p.Name
                        tag.Name.Position = Vector2.new(pos.X, pos.Y - 50)
                    else
                        if tag.Name then tag.Name.Visible = false end
                    end
                else
                    if tag.Box then tag.Box.Visible = false end
                    if tag.Name then tag.Name.Visible = false end
                end
            end
        end
    end
end)

-- Initialize first tab
Tabs[1].Frame.Visible = true
Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

print("[TEN WEAK] THESKYFALL HUB PRO Loaded Successfully.")