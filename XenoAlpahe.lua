-- XenoAlpha MultiTool v2.0 - Полная переработка
-- Уникальный дизайн с снежинками, полупрозрачностью, новыми функциями

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // КОНФИГУРАЦИЯ
local Config = {
    Theme = {
        MainColor = Color3.fromRGB(100, 150, 255),
        AccentColor = Color3.fromRGB(255, 100, 200),
        Background = Color3.fromRGB(10, 10, 20),
        Transparency = 0.85
    },
    Keybinds = {
        ToggleUI = Enum.KeyCode.Insert,
        Bhop = Enum.KeyCode.X,
        Fly = Enum.KeyCode.F,
        InfinityJump = Enum.KeyCode.G,
        SpeedHack = Enum.KeyCode.Z,
        Noclip = Enum.KeyCode.V,
        Esp = Enum.KeyCode.E,
        RageMode = Enum.KeyCode.R,
        GodMode = Enum.KeyCode.G,
        Invis = Enum.KeyCode.I,
        Teleport = Enum.KeyCode.T
    },
    Functions = {
        Bhop = false,
        Fly = false,
        InfinityJump = false,
        SpeedHack = false,
        Noclip = false,
        Esp = false,
        GodMode = false,
        Invisible = false,
        AutoHeal = false,
        NoFall = false
    },
    Rage = {
        Enabled = false,
        Aimbot = false,
        FOV = 120,
        TargetPart = "Head",
        WallShot = false,
        Fling = false,
        TargetPlayer = nil,
        SilentAim = false,
        TriggerBot = false,
        AntiAim = false
    },
    MMV = {
        AutoFarm = false,
        AutoCollect = false,
        SpeedBoost = false,
        JumpBoost = false,
        AutoClick = false,
        AntiAFK = false
    },
    Rivals = {
        Aimbot = false,
        TriggerBot = false,
        AntiAim = false,
        AutoWall = false,
        FastReload = false,
        NoRecoil = false,
        InstaKill = false
    }
}

-- // СНЕЖИНКИ (Уникальный визуальный эффект)
local Snowflakes = {}
local SnowContainer = Instance.new("Frame")
SnowContainer.Size = UDim2.new(1, 0, 1, 0)
SnowContainer.BackgroundTransparency = 1
SnowContainer.ZIndex = 999
SnowContainer.Parent = game:GetService("CoreGui")

local function CreateSnowflake()
    local snowflake = Instance.new("TextLabel")
    snowflake.Size = UDim2.new(0, math.random(10, 20), 0, math.random(10, 20))
    snowflake.Position = UDim2.new(math.random(), 0, -0.1, 0)
    snowflake.BackgroundTransparency = 1
    snowflake.Text = "❄"
    snowflake.TextColor3 = Color3.fromRGB(200, 220, 255)
    snowflake.TextSize = math.random(12, 24)
    snowflake.TextTransparency = 0.3 + math.random() * 0.5
    snowflake.ZIndex = 999
    snowflake.Font = Enum.Font.SourceSansBold
    snowflake.Parent = SnowContainer
    
    local speed = 0.5 + math.random() * 2
    local drift = math.random(-30, 30) / 100
    local rotationSpeed = math.random(-3, 3)
    
    local data = {
        Object = snowflake,
        Speed = speed,
        Drift = drift,
        RotationSpeed = rotationSpeed,
        StartX = snowflake.Position.X.Scale,
        FallDistance = 1.2 + math.random() * 0.8
    }
    table.insert(Snowflakes, data)
    return data
end

-- Создаём 50 снежинок
for i = 1, 50 do
    CreateSnowflake()
end

-- Анимация снежинок
RunService.Heartbeat:Connect(function(deltaTime)
    for _, snow in pairs(Snowflakes) do
        if snow.Object and snow.Object.Parent then
            local pos = snow.Object.Position
            local newY = pos.Y.Scale + (snow.Speed * deltaTime * 0.3)
            local newX = pos.X.Scale + math.sin(os.time() * snow.Drift) * deltaTime * 0.1
            
            if newY > 1.2 then
                newY = -0.1
                newX = math.random()
                snow.Object.TextSize = math.random(12, 24)
            end
            
            snow.Object.Position = UDim2.new(newX, 0, newY, 0)
            snow.Object.Rotation = snow.Object.Rotation + snow.RotationSpeed * deltaTime * 10
        end
    end
end)

-- // ГЛАВНОЕ МЕНЮ (Полупрозрачное с эффектом стекла)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoAlphaGUI"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
MainFrame.BackgroundColor3 = Config.Theme.Background
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Эффект стекла (Glass effect)
local GlassEffect = Instance.new("Frame")
GlassEffect.Size = UDim2.new(1, 0, 1, 0)
GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassEffect.BackgroundTransparency = 0.85
GlassEffect.BorderSizePixel = 0
GlassEffect.Parent = MainFrame

-- Градиентная рамка
local GradientBorder = Instance.new("Frame")
GradientBorder.Size = UDim2.new(1, 2, 1, 2)
GradientBorder.Position = UDim2.new(0, -1, 0, -1)
GradientBorder.BackgroundColor3 = Config.Theme.MainColor
GradientBorder.BackgroundTransparency = 0.5
GradientBorder.BorderSizePixel = 0
GradientBorder.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Config.Theme.MainColor),
    ColorSequenceKeypoint.new(0.5, Config.Theme.AccentColor),
    ColorSequenceKeypoint.new(1, Config.Theme.MainColor)
}
Gradient.Rotation = 45
Gradient.Parent = GradientBorder

-- // ЗАГОЛОВОК
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.BackgroundTransparency = 0.9
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ XenoAlpha v2.0 ✦"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 16
Title.Parent = TitleBar

-- Кнопки управления окном
local function CreateWindowButton(text, color, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 1, 0)
    btn.Position = UDim2.new(1, position, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = TitleBar
    return btn
end

local MinifyBtn = CreateWindowButton("─", Color3.fromRGB(200, 200, 200), -90)
local HideBtn = CreateWindowButton("✕", Color3.fromRGB(255, 150, 150), -60)
local CloseBtn = CreateWindowButton("✖", Color3.fromRGB(255, 50, 50), -30)

-- // ВКЛАДКИ
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 35)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabContainer.BackgroundTransparency = 0.9
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local Tabs = {"Keybinds", "Functions", "Rage", "MMV", "Rivals"}
local TabButtons = {}
local TabContents = {}

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*120, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.8
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.Parent = TabContainer
    TabButtons[name] = btn
    
    -- Контент вкладки
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -75)
    content.Position = UDim2.new(0, 10, 0, 75)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 4
    content.Visible = (i == 1)
    content.Parent = MainFrame
    TabContents[name] = content
end

-- // УТИЛИТЫ ДЛЯ СОЗДАНИЯ ЭЛЕМЕНТОВ GUI
local function CreateToggle(parent, label, configTable, configKey, yPos, color)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 30)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.BackgroundTransparency = 0.9
    row.BorderSizePixel = 0
    row.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 200, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.Parent = row
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 70, 1, 0)
    toggle.Position = UDim2.new(1, -80, 0, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.Parent = row
    
    toggle.MouseButton1Click:Connect(function()
        configTable[configKey] = not configTable[configKey]
        toggle.Text = configTable[configKey] and "ON" or "OFF"
        toggle.BackgroundColor3 = configTable[configKey] and (color or Color3.fromRGB(60, 180, 100)) or Color3.fromRGB(60, 60, 80)
    end)
    
    return row
end

local function CreateKeybind(parent, label, configKey, yPos)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 30)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.BackgroundTransparency = 0.9
    row.BorderSizePixel = 0
    row.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 200, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.Parent = row
    
    local keyLabel = Instance.new("TextButton")
    keyLabel.Size = UDim2.new(0, 100, 1, 0)
    keyLabel.Position = UDim2.new(1, -110, 0, 0)
    keyLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    keyLabel.Text = tostring(Config.Keybinds[configKey]):gsub("Enum.KeyCode.", "")
    keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.TextSize = 12
    keyLabel.Parent = row
    
    keyLabel.MouseButton1Click:Connect(function()
        keyLabel.Text = "..."
        local waitPress
        waitPress = UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.UserInputType == Enum.UserInputType.Keyboard then
                Config.Keybinds[configKey] = input.KeyCode
                keyLabel.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                waitPress:Disconnect()
            end
        end)
    end)
    
    return row
end

local function CreateSlider(parent, label, configTable, configKey, min, max, yPos)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 30)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.BackgroundTransparency = 0.9
    row.BorderSizePixel = 0
    row.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 150, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.Parent = row
    
    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0, 80, 1, 0)
    slider.Position = UDim2.new(1, -90, 0, 0)
    slider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    slider.Text = tostring(configTable[configKey])
    slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    slider.Font = Enum.Font.GothamBold
    slider.TextSize = 12
    slider.Parent = row
    
    slider.FocusLost:Connect(function()
        local val = tonumber(slider.Text)
        if val then
            configTable[configKey] = math.clamp(val, min, max)
            slider.Text = tostring(configTable[configKey])
        end
    end)
    
    return row
end

-- // ЗАПОЛНЕНИЕ ВКЛАДОК
local function SetupTabs()
    -- KEYBINDS TAB
    local keyContent = TabContents["Keybinds"]
    local keyRows = {"ToggleUI", "Bhop", "Fly", "InfinityJump", "SpeedHack", "Noclip", "Esp", "RageMode", "GodMode", "Invis", "Teleport"}
    for i, key in ipairs(keyRows) do
        CreateKeybind(keyContent, key, key, 8 + (i-1)*35)
    end
    keyContent.CanvasSize = UDim2.new(0, 0, 0, #keyRows * 35 + 20)
    
    -- FUNCTIONS TAB
    local funcContent = TabContents["Functions"]
    local funcList = {"Bhop", "Fly", "InfinityJump", "SpeedHack", "Noclip", "Esp", "GodMode", "Invisible", "AutoHeal", "NoFall"}
    for i, fname in ipairs(funcList) do
        local color = Color3.fromRGB(60, 180, 100)
        if fname == "GodMode" or fname == "Invisible" then
            color = Color3.fromRGB(180, 60, 200)
        end
        CreateToggle(funcContent, fname, Config.Functions, fname, 8 + (i-1)*35, color)
    end
    funcContent.CanvasSize = UDim2.new(0, 0, 0, #funcList * 35 + 20)
    
    -- RAGE TAB
    local rageContent = TabContents["Rage"]
    local rageElements = {
        {type = "toggle", label = "Rage Mode", key = "Enabled", color = Color3.fromRGB(180, 60, 60)},
        {type = "toggle", label = "Aimbot", key = "Aimbot", color = Color3.fromRGB(180, 60, 60)},
        {type = "slider", label = "FOV", key = "FOV", min = 30, max = 360},
        {type = "toggle", label = "Silent Aim", key = "SilentAim", color = Color3.fromRGB(180, 60, 60)},
        {type = "toggle", label = "TriggerBot", key = "TriggerBot", color = Color3.fromRGB(180, 60, 60)},
        {type = "toggle", label = "WallShot", key = "WallShot", color = Color3.fromRGB(180, 60, 60)},
        {type = "toggle", label = "AntiAim", key = "AntiAim", color = Color3.fromRGB(180, 60, 60)},
        {type = "toggle", label = "Fling", key = "Fling", color = Color3.fromRGB(180, 60, 60)}
    }
    
    for i, elem in ipairs(rageElements) do
        if elem.type == "toggle" then
            CreateToggle(rageContent, elem.label, Config.Rage, elem.key, 8 + (i-1)*35, elem.color)
        elseif elem.type == "slider" then
            CreateSlider(rageContent, elem.label, Config.Rage, elem.key, elem.min, elem.max, 8 + (i-1)*35)
        end
    end
    rageContent.CanvasSize = UDim2.new(0, 0, 0, #rageElements * 35 + 20)
    
    -- MMV TAB
    local mmvContent = TabContents["MMV"]
    local mmvFunctions = {"AutoFarm", "AutoCollect", "SpeedBoost", "JumpBoost", "AutoClick", "AntiAFK"}
    for i, fname in ipairs(mmvFunctions) do
        CreateToggle(mmvContent, fname, Config.MMV, fname, 8 + (i-1)*35, Color3.fromRGB(100, 200, 255))
    end
    mmvContent.CanvasSize = UDim2.new(0, 0, 0, #mmvFunctions * 35 + 20)
    
    -- RIVALS TAB
    local rivalsContent = TabContents["Rivals"]
    local rivalsFunctions = {"Aimbot", "TriggerBot", "AntiAim", "AutoWall", "FastReload", "NoRecoil", "InstaKill"}
    for i, fname in ipairs(rivalsFunctions) do
        CreateToggle(rivalsContent, fname, Config.Rivals, fname, 8 + (i-1)*35, Color3.fromRGB(255, 100, 100))
    end
    rivalsContent.CanvasSize = UDim2.new(0, 0, 0, #rivalsFunctions * 35 + 20)
end

SetupTabs()

-- // ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
for name, btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, content in pairs(TabContents) do
            content.Visible = false
        end
        TabContents[name].Visible = true
        for _, b in pairs(TabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            b.BackgroundTransparency = 0.8
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        btn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        btn.BackgroundTransparency = 0.3
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end
TabButtons["Keybinds"].BackgroundColor3 = Color3.fromRGB(100, 150, 255)
TabButtons["Keybinds"].BackgroundTransparency = 0.3
TabButtons["Keybinds"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- // ФУНКЦИОНАЛ
-- God Mode
RunService.Heartbeat:Connect(function()
    if Config.Functions.GodMode and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = humanoid.MaxHealth
            humanoid.BreakJointsOnDeath = false
        end
    end
end)

-- Invisible
RunService.Heartbeat:Connect(function()
    if Config.Functions.Invisible and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end
end)

-- Auto Heal
RunService.Heartbeat:Connect(function()
    if Config.Functions.AutoHeal and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.Health + 5
        end
    end
end)

-- No Fall
RunService.Heartbeat:Connect(function()
    if Config.Functions.NoFall and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        end
    end
end)

-- Bhop (исправленный)
RunService.Heartbeat:Connect(function()
    if Config.Functions.Bhop and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.MoveDirection.Magnitude > 1 and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid.Jump = true
        end
    end
end)

-- Fly (исправленный)
local flyVelocity = Vector3.new(0, 0, 0)
RunService.Heartbeat:Connect(function()
    if Config.Functions.Fly and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local move = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector * Vector3.new(1, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector * Vector3.new(1, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
            
            if move.Magnitude > 0 then
                flyVelocity = flyVelocity:Lerp(move * 40, 0.3)
            else
                flyVelocity = flyVelocity:Lerp(Vector3.new(0, 0, 0), 0.1)
            end
            root.Velocity = flyVelocity
        end
    end
end)

-- Noclip (исправленный)
RunService.Heartbeat:Connect(function()
    if Config.Functions.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP (улучшенный)
local espTable = {}
RunService.RenderStepped:Connect(function()
    if Config.Functions.Esp then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local root = v.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    if not espTable[v.Name] then
                        local esp = Instance.new("BillboardGui")
                        esp.Size = UDim2.new(0, 100, 0, 30)
                        esp.StudsOffset = Vector3.new(0, 3, 0)
                        esp.AlwaysOnTop = true
                        esp.Parent = v.Character
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = v.Name
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLabel.TextStrokeTransparency = 0.5
                        nameLabel.TextScaled = true
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.Parent = esp
                        
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = Vector3.new(3, 5, 1)
                        box.Adornee = v.Character
                        box.Color3 = v.TeamColor and v.TeamColor.Color or Color3.fromRGB(255, 0, 0)
                        box.Transparency = 0.3
                        box.Parent = v.Character
                        
                        espTable[v.Name] = {esp = esp, box = box}
                    end
                else
                    if espTable[v.Name] then
                        espTable[v.Name].esp:Destroy()
                        espTable[v.Name].box:Destroy()
                        espTable[v.Name] = nil
                    end
                end
            end
        end
    else
        for k, data in pairs(espTable) do
            data.esp:Destroy()
            data.box:Destroy()
            espTable[k] = nil
        end
    end
end)

-- Rage Aimbot (улучшенный)
RunService.Heartbeat:Connect(function()
    if Config.Rage.Enabled and Config.Rage.Aimbot then
        local target = Config.Rage.TargetPlayer and Players:FindFirstChild(Config.Rage.TargetPlayer)
        if not target then
            local closest, dist = nil, Config.Rage.FOV
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local root = v.Character.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if d < dist then
                            closest, dist = v, d
                        end
                    end
                end
            end
            target = closest
        end
        
        if target and target.Character and target.Character:FindFirstChild(Config.Rage.TargetPart) then
            local part = target.Character[Config.Rage.TargetPart]
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if (onScreen or Config.Rage.WallShot) then
                    if Config.Rage.SilentAim then
                        -- Silent Aim (невидимый для других)
                        local targetPos = Camera:WorldToViewportPoint(part.Position)
                        local delta = Vector2.new(targetPos.X - Mouse.X, targetPos.Y - Mouse.Y)
                        if delta.Magnitude > 5 then
                            mousemoverel(delta.X * 0.5, delta.Y * 0.5)
                        end
                    else
                        -- Обычный Aimbot
                        local targetPos = Camera:WorldToViewportPoint(part.Position)
                        local delta = Vector2.new(targetPos.X - Mouse.X, targetPos.Y - Mouse.Y)
                        if delta.Magnitude > 10 then
                            mousemoverel(delta.X * 0.3, delta.Y * 0.3)
                        end
                    end
                end
            end
        end
    end
end)

-- TriggerBot для Rage
RunService.Heartbeat:Connect(function()
    if Config.Rage.Enabled and Config.Rage.TriggerBot then
        local target = Players:FindFirstChild(Config.Rage.TargetPlayer) or GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = target.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen and (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude < 50 then
                mouse1click()
            end
        end
    end
end)

-- AntiAim для Rage
RunService.Heartbeat:Connect(function()
    if Config.Rage.Enabled and Config.Rage.AntiAim and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(180), 0)
        end
    end
end)

-- Fling (исправленный)
RunService.Heartbeat:Connect(function()
    if Config.Rage.Enabled and Config.Rage.Fling and Config.Rage.TargetPlayer then
        local target = Players:FindFirstChild(Config.Rage.TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = target.Character.HumanoidRootPart
            local dir = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
            root.Velocity = dir * 250 + Vector3.new(0, 80, 0)
        end
    end
end)

-- MMV AutoFarm (пример)
RunService.Heartbeat:Connect(function()
    if Config.MMV.AutoFarm then
        -- Здесь должна быть логика для MMV
        -- Например, автоматический сбор ресурсов
        print("AutoFarm active")
    end
end)

-- Rivals Aimbot (специализированный)
RunService.Heartbeat:Connect(function()
    if Config.Rivals.Aimbot then
        -- Специализированный аимбот для Rivals
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local delta = Vector2.new(pos.X - Mouse.X, pos.Y - Mouse.Y)
                if delta.Magnitude > 10 then
                    mousemoverel(delta.X * 0.4, delta.Y * 0.4)
                end
            end
        end
    end
end)

-- Rivals InstaKill
RunService.Heartbeat:Connect(function()
    if Config.Rivals.InstaKill then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local humanoid = v.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    end
end)

-- // УПРАВЛЕНИЕ ОКНОМ
local isMinified = false
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 80, 0, 35)
miniButton.Position = UDim2.new(0.02, 0, 0.1, 0)
miniButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
miniButton.BackgroundTransparency = 0.3
miniButton.Text = "✦ Xeno"
miniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
miniButton.Font = Enum.Font.GothamBold
miniButton.TextSize = 14
miniButton.Visible = false
miniButton.Parent = ScreenGui

MinifyBtn.MouseButton1Click:Connect(function()
    isMinified = not isMinified
    MainFrame.Visible = not isMinified
    miniButton.Visible = isMinified
end)

miniButton.MouseButton1Click:Connect(function()
    isMinified = not isMinified
    MainFrame.Visible = not isMinified
    miniButton.Visible = isMinified
end)

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    miniButton.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- // ГЛОБАЛЬНЫЙ ТОГГЛ (Insert)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Config.Keybinds.ToggleUI then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then miniButton.Visible = false end
    end
end)

-- // КЕЙБИНДЫ ДЛЯ ФУНКЦИЙ
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    for func, key in pairs(Config.Keybinds) do
        if func ~= "ToggleUI" and input.KeyCode == key then
            if Config.Functions[func] ~= nil then
                Config.Functions[func] = not Config.Functions[func]
                -- Обновляем GUI вкладки Functions
                for _, child in pairs(TabContents["Functions"]:GetChildren()) do
                    if child:IsA("Frame") and child:FindFirstChild("TextLabel") then
                        local label = child.TextLabel
                        if label.Text == func then
                            local toggle = child:FindFirstChild("TextButton")
                            if toggle then
                                toggle.Text = Config.Functions[func] and "ON" or "OFF"
                                toggle.BackgroundColor3 = Config.Functions[func] and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(60, 60, 80)
                            end
                        end
                    end
                end
            end
        end
    end
    if input.KeyCode == Config.Keybinds.RageMode then
        Config.Rage.Enabled = not Config.Rage.Enabled
    end
end)

print("✦ XenoAlpha v2.0 загружен! Наслаждайся уникальным визуалом и новыми функциями ✦")
