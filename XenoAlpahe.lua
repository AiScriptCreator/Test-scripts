-- XenoAlpha MultiTool v1.0 (Lua GUI)
-- Полный контроль: тема, кейбинды, визуал, рейдж-функции

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // Служба сохранения конфигурации (имитация)
local Config = {
    Theme = "Dark", -- "Dark", "Neon", "Light"
    Keybinds = {
        ToggleUI = Enum.KeyCode.Insert,
        Bhop = Enum.KeyCode.X,
        Fly = Enum.KeyCode.F,
        InfinityJump = Enum.KeyCode.G,
        SpeedHack = Enum.KeyCode.Z,
        Noclip = Enum.KeyCode.V,
        Esp = Enum.KeyCode.E,
        RageMode = Enum.KeyCode.R,
    },
    Functions = {
        Bhop = false,
        Fly = false,
        InfinityJump = false,
        SpeedHack = false,
        Noclip = false,
        Esp = false,
    },
    Rage = {
        Enabled = false,
        Aimbot = false,
        FOV = 120,
        TargetPart = "Head", -- "Head", "Torso", "HumanoidRootPart"
        WallShot = false,
        Fling = false,
        TargetPlayer = nil,
    }
}

-- // Базовые утилиты
local function GetClosestPlayer()
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
    return closest
end

-- // GUI - MAIN FRAME
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoAlphaGUI"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Shadow / Glow effect
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 8, 1, 8)
Shadow.Position = UDim2.new(0, -4, 0, -4)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.Parent = MainFrame

-- // Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "XenoAlpha MultiTool"
Title.TextColor3 = Color3.fromRGB(200, 200, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 14
Title.Parent = TitleBar

-- Minify Button (сворачивание в мини-кнопку)
local MinifyBtn = Instance.new("TextButton")
MinifyBtn.Size = UDim2.new(0, 24, 1, 0)
MinifyBtn.Position = UDim2.new(1, -72, 0, 0)
MinifyBtn.BackgroundTransparency = 1
MinifyBtn.Text = "─"
MinifyBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinifyBtn.Font = Enum.Font.GothamBold
MinifyBtn.TextSize = 18
MinifyBtn.Parent = TitleBar

-- Hide Button (скрыть полностью)
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 24, 1, 0)
HideBtn.Position = UDim2.new(1, -48, 0, 0)
HideBtn.BackgroundTransparency = 1
HideBtn.Text = "✕"
HideBtn.TextColor3 = Color3.fromRGB(255,100,100)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 14
HideBtn.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 1, 0)
CloseBtn.Position = UDim2.new(1, -24, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✖"
CloseBtn.TextColor3 = Color3.fromRGB(255,50,50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

-- // Tab Buttons
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local Tabs = {"Keybinds", "Functions", "Rage"}
local TabButtons = {}
local TabContents = {}

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*120, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.Parent = TabContainer
    TabButtons[name] = btn
    
    -- Content Frame for each tab
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -60)
    content.Position = UDim2.new(0, 0, 0, 60)
    content.BackgroundColor3 = Color3.fromRGB(20,20,25)
    content.BorderSizePixel = 0
    content.Visible = (i == 1)
    content.Parent = MainFrame
    TabContents[name] = content
end

-- // TAB: KEYBINDS
local keybindContent = TabContents["Keybinds"]
local keyRows = {"ToggleUI", "Bhop", "Fly", "InfinityJump", "SpeedHack", "Noclip", "Esp", "RageMode"}

for i, key in ipairs(keyRows) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 28)
    row.Position = UDim2.new(0, 10, 0, 8 + (i-1)*32)
    row.BackgroundColor3 = Color3.fromRGB(28,28,36)
    row.BorderSizePixel = 0
    row.Parent = keybindContent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 140, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = key
    lbl.TextColor3 = Color3.fromRGB(200,200,220)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.Parent = row
    
    local keyLabel = Instance.new("TextButton")
    keyLabel.Size = UDim2.new(0, 100, 1, 0)
    keyLabel.Position = UDim2.new(1, -110, 0, 0)
    keyLabel.BackgroundColor3 = Color3.fromRGB(45,45,55)
    keyLabel.Text = tostring(Config.Keybinds[key]):gsub("Enum.KeyCode.", "")
    keyLabel.TextColor3 = Color3.fromRGB(255,255,255)
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.TextSize = 12
    keyLabel.Parent = row
    
    keyLabel.MouseButton1Click:Connect(function()
        keyLabel.Text = "..."
        local waitPress
        waitPress = UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.UserInputType == Enum.UserInputType.Keyboard then
                Config.Keybinds[key] = input.KeyCode
                keyLabel.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                waitPress:Disconnect()
            end
        end)
    end)
end

-- // TAB: FUNCTIONS (безобидные функции + ESP)
local funcContent = TabContents["Functions"]
local funcList = {"Bhop", "Fly", "InfinityJump", "SpeedHack", "Noclip", "Esp"}

for i, fname in ipairs(funcList) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 28)
    row.Position = UDim2.new(0, 10, 0, 8 + (i-1)*32)
    row.BackgroundColor3 = Color3.fromRGB(28,28,36)
    row.BorderSizePixel = 0
    row.Parent = funcContent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 140, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = fname
    lbl.TextColor3 = Color3.fromRGB(200,200,220)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.Parent = row
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 60, 1, 0)
    toggle.Position = UDim2.new(1, -70, 0, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(60,60,80)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(200,200,200)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.Parent = row
    
    toggle.MouseButton1Click:Connect(function()
        Config.Functions[fname] = not Config.Functions[fname]
        toggle.Text = Config.Functions[fname] and "ON" or "OFF"
        toggle.BackgroundColor3 = Config.Functions[fname] and Color3.fromRGB(60,180,100) or Color3.fromRGB(60,60,80)
    end)
end

-- // TAB: RAGE (с доп. настройками)
local rageContent = TabContents["Rage"]

local rageRows = {
    {label = "Rage Mode", key = "Enabled", type = "toggle"},
    {label = "Aimbot", key = "Aimbot", type = "toggle"},
    {label = "FOV", key = "FOV", type = "slider", min = 30, max = 360, default = 120},
    {label = "Target Part", key = "TargetPart", type = "option", options = {"Head", "Torso", "HumanoidRootPart"}},
    {label = "Wall Shoot", key = "WallShot", type = "toggle"},
    {label = "Fling", key = "Fling", type = "toggle"},
    {label = "Target Player", key = "TargetPlayer", type = "playerlist"},
}

local function createRageRow(data, index)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 28)
    row.Position = UDim2.new(0, 10, 0, 8 + (index-1)*32)
    row.BackgroundColor3 = Color3.fromRGB(28,28,36)
    row.BorderSizePixel = 0
    row.Parent = rageContent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 140, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = data.label
    lbl.TextColor3 = Color3.fromRGB(200,200,220)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.Parent = row
    
    if data.type == "toggle" then
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 60, 1, 0)
        toggle.Position = UDim2.new(1, -70, 0, 0)
        toggle.BackgroundColor3 = Color3.fromRGB(60,60,80)
        toggle.Text = Config.Rage[data.key] and "ON" or "OFF"
        toggle.TextColor3 = Color3.fromRGB(200,200,200)
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 12
        toggle.Parent = row
        toggle.MouseButton1Click:Connect(function()
            Config.Rage[data.key] = not Config.Rage[data.key]
            toggle.Text = Config.Rage[data.key] and "ON" or "OFF"
            toggle.BackgroundColor3 = Config.Rage[data.key] and Color3.fromRGB(180,60,60) or Color3.fromRGB(60,60,80)
        end)
    elseif data.type == "slider" then
        local slider = Instance.new("TextBox")
        slider.Size = UDim2.new(0, 60, 1, 0)
        slider.Position = UDim2.new(1, -70, 0, 0)
        slider.BackgroundColor3 = Color3.fromRGB(45,45,55)
        slider.Text = tostring(Config.Rage[data.key])
        slider.TextColor3 = Color3.fromRGB(255,255,255)
        slider.Font = Enum.Font.GothamBold
        slider.TextSize = 12
        slider.Parent = row
        slider.FocusLost:Connect(function()
            local val = tonumber(slider.Text)
            if val then
                Config.Rage[data.key] = math.clamp(val, data.min, data.max)
                slider.Text = tostring(Config.Rage[data.key])
            end
        end)
    elseif data.type == "option" then
        local dropdown = Instance.new("TextButton")
        dropdown.Size = UDim2.new(0, 100, 1, 0)
        dropdown.Position = UDim2.new(1, -110, 0, 0)
        dropdown.BackgroundColor3 = Color3.fromRGB(45,45,55)
        dropdown.Text = Config.Rage[data.key]
        dropdown.TextColor3 = Color3.fromRGB(255,255,255)
        dropdown.Font = Enum.Font.GothamBold
        dropdown.TextSize = 12
        dropdown.Parent = row
        local idx = 1
        dropdown.MouseButton1Click:Connect(function()
            idx = idx % #data.options + 1
            Config.Rage[data.key] = data.options[idx]
            dropdown.Text = data.options[idx]
        end)
    elseif data.type == "playerlist" then
        local playerBtn = Instance.new("TextButton")
        playerBtn.Size = UDim2.new(0, 100, 1, 0)
        playerBtn.Position = UDim2.new(1, -110, 0, 0)
        playerBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
        playerBtn.Text = "Select"
        playerBtn.TextColor3 = Color3.fromRGB(255,255,255)
        playerBtn.Font = Enum.Font.GothamBold
        playerBtn.TextSize = 12
        playerBtn.Parent = row
        playerBtn.MouseButton1Click:Connect(function()
            local plrs = {}
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then table.insert(plrs, p.Name) end
            end
            -- В реальном проекте тут было бы выпадающее меню, для демо назначаем первого
            if #plrs > 0 then
                Config.Rage.TargetPlayer = plrs[1]
                playerBtn.Text = plrs[1]
            end
        end)
    end
end

for i, data in ipairs(rageRows) do
    createRageRow(data, i)
end

-- // TAB SWITCHING
for name, btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, content in pairs(TabContents) do
            content.Visible = false
        end
        TabContents[name].Visible = true
        for _, b in pairs(TabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(35,35,45)
        end
        btn.BackgroundColor3 = Color3.fromRGB(55,55,75)
    end)
end
-- Highlight default tab
TabButtons["Keybinds"].BackgroundColor3 = Color3.fromRGB(55,55,75)

-- // FUNCIONALITY: Bhop, Fly, Infinity Jump, Speed Hack, Noclip, ESP
-- Bhop
RunService.Heartbeat:Connect(function()
    if Config.Functions.Bhop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid.MoveDirection.Magnitude > 0 and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid.Jump = true
        end
    end
end)

-- Fly + Noclip
local flyVelocity = Vector3.new(0,0,0)
RunService.Heartbeat:Connect(function()
    if Config.Functions.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector * Vector3.new(1,0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector * Vector3.new(1,0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
        flyVelocity = flyVelocity:Lerp(move * 30, 0.3)
        root.Velocity = flyVelocity
        if Config.Functions.Noclip then
            root.CanCollide = false
        else
            root.CanCollide = true
        end
    end
end)

-- Infinity Jump
RunService.Heartbeat:Connect(function()
    if Config.Functions.InfinityJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            LocalPlayer.Character.Humanoid.Jump = true
        end
    end
end)

-- Speed Hack
RunService.Heartbeat:Connect(function()
    if Config.Functions.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- ESP (простой Box ESP)
local espTable = {}
RunService.RenderStepped:Connect(function()
    if Config.Functions.Esp then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local root = v.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    if not espTable[v.Name] then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = Vector3.new(3,5,1)
                        box.Adornee = v.Character
                        box.Color3 = Color3.fromRGB(255,0,0)
                        box.Transparency = 0.5
                        box.ZIndex = 0
                        box.Parent = v.Character
                        espTable[v.Name] = box
                    end
                else
                    if espTable[v.Name] then espTable[v.Name]:Destroy() espTable[v.Name] = nil end
                end
            end
        end
    else
        for k, box in pairs(espTable) do
            box:Destroy()
            espTable[k] = nil
        end
    end
end)

-- // RAGE: Aimbot + WallShot + Fling
RunService.Heartbeat:Connect(function()
    if Config.Rage.Enabled and Config.Rage.Aimbot then
        local target = Config.Rage.TargetPlayer and Players:FindFirstChild(Config.Rage.TargetPlayer)
        if not target then target = GetClosestPlayer() end
        if target and target.Character and target.Character:FindFirstChild(Config.Rage.TargetPart) then
            local part = target.Character[Config.Rage.TargetPart]
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if (onScreen or Config.Rage.WallShot) then
                    -- AIMBOT (плавное наведение)
                    local targetPos = Camera:WorldToViewportPoint(part.Position)
                    local delta = Vector2.new(targetPos.X - Mouse.X, targetPos.Y - Mouse.Y)
                    if delta.Magnitude > 10 then
                        mousemoverel(delta.X * 0.3, delta.Y * 0.3)
                    end
                end
            end
        end
    end
end)

-- Fling (при активации fling на выбранного игрока)
RunService.Heartbeat:Connect(function()
    if Config.Rage.Enabled and Config.Rage.Fling and Config.Rage.TargetPlayer then
        local target = Players:FindFirstChild(Config.Rage.TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = target.Character.HumanoidRootPart
            local dir = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
            root.Velocity = dir * 200 + Vector3.new(0, 50, 0)
        end
    end
end)

-- // MINIFY (свернуть в кнопку)
local isMinified = false
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 60, 0, 30)
miniButton.Position = UDim2.new(0.02, 0, 0.1, 0)
miniButton.BackgroundColor3 = Color3.fromRGB(30,30,40)
miniButton.Text = "Xeno"
miniButton.TextColor3 = Color3.fromRGB(200,200,255)
miniButton.Font = Enum.Font.GothamBold
miniButton.TextSize = 12
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

-- // HIDE (полностью скрыть)
HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    miniButton.Visible = false
end)

-- // CLOSE (удалить GUI)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- // GLOBAL TOGGLE (Insert)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Config.Keybinds.ToggleUI then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then miniButton.Visible = false end
    end
end)

-- // Дополнительно: переключение функций по кейбиндам
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    for func, key in pairs(Config.Keybinds) do
        if func ~= "ToggleUI" and input.KeyCode == key then
            if Config.Functions[func] ~= nil then
                Config.Functions[func] = not Config.Functions[func]
                -- обновим визуал вкладки Functions (для демо можно пропустить, но для реального GUI нужно перебрать кнопки)
            end
        end
    end
    if input.KeyCode == Config.Keybinds.RageMode then
        Config.Rage.Enabled = not Config.Rage.Enabled
    end
end)

print("XenoAlpha MultiTool загружен. Наслаждайся полным контролем.")
