-- XenoAlpha MultiTool v4.0 - MMV Edition
-- Автозагрузчик, правильные функции MMV, отображение биндов

-- // АВТОЗАГРУЗЧИК (сохраняет чит между играми)
local function AutoLoader()
    -- Проверяем, есть ли уже GUI
    if game:GetService("CoreGui"):FindFirstChild("XenoAlphaGUI") then
        return
    end
    
    -- Создаём скрытый ScreenGui для автозагрузки
    local loaderGui = Instance.new("ScreenGui")
    loaderGui.Name = "XenoLoader"
    loaderGui.Parent = game:GetService("CoreGui")
    loaderGui.Enabled = false -- Скрываем, чтобы не мешать
    
    -- Загружаем основной скрипт
    local success, err = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/AiScriptCreator/Test-scripts/refs/heads/main/XenoAlpahe.lua")
        local func = loadstring(scriptContent)
        if func then
            func()
        end
    end)
    
    if success then
        print("✦ XenoAlpha v4.0 успешно загружен! ✦")
    else
        warn("Ошибка загрузки XenoAlpha: " .. tostring(err))
        -- Повторная попытка через 5 секунд
        task.wait(5)
        AutoLoader()
    end
    
    loaderGui:Destroy()
end

-- Запускаем автозагрузчик
AutoLoader()

-- // ОСНОВНОЙ СКРИПТ (загружается после автозагрузчика)
-- Используем pcall для защиты от ошибок
local function MainScript()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Camera = Workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    
    -- // КОНФИГУРАЦИЯ
    local Config = {
        Theme = {
            MainColor = Color3.fromRGB(100, 150, 255),
            AccentColor = Color3.fromRGB(255, 100, 200),
            Background = Color3.fromRGB(10, 10, 20)
        },
        Keybinds = {
            ToggleUI = Enum.KeyCode.Insert,
            Bhop = Enum.KeyCode.X,
            Fly = Enum.KeyCode.F,
            SpeedHack = Enum.KeyCode.Z,
            Noclip = Enum.KeyCode.V,
            Esp = Enum.KeyCode.E,
            RageMode = Enum.KeyCode.R,
            GodMode = Enum.KeyCode.G,
            AutoShoot = Enum.KeyCode.Q,
            GrabGun = Enum.KeyCode.G,
            Fling = Enum.KeyCode.F,
            MurderKill = Enum.KeyCode.M
        },
        Functions = {
            Bhop = false,
            Fly = false,
            SpeedHack = false,
            Noclip = false,
            Esp = false,
            GodMode = false,
            AutoHeal = false,
            NoFall = false
        },
        MMV = {
            AutoFling = false,
            GrabGun = false,
            EspMurderSherif = false,
            AutoShootMurder = false,
            NoClipMMV = false,
            SpeedBoost = false,
            JumpBoost = false
        },
        Rage = {
            Enabled = false,
            Aimbot = false,
            FOV = 120,
            TargetPart = "Head",
            WallShot = false,
            SilentAim = false,
            TriggerBot = false,
            Smoothness = 0.3
        }
    }
    
    -- // СОЗДАНИЕ GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XenoAlphaGUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 650, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 20)
    Corner.Parent = MainFrame
    
    -- Эффект стекла
    local GlassEffect = Instance.new("Frame")
    GlassEffect.Size = UDim2.new(1, 0, 1, 0)
    GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlassEffect.BackgroundTransparency = 0.9
    GlassEffect.BorderSizePixel = 0
    GlassEffect.Parent = MainFrame
    local GlassCorner = Instance.new("UICorner")
    GlassCorner.CornerRadius = UDim.new(0, 20)
    GlassCorner.Parent = GlassEffect
    
    -- Заголовок
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.BackgroundTransparency = 0.95
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 250, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "✦ XenoAlpha v4.0 (MMV) ✦"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 18
    Title.Parent = TitleBar
    
    -- Вкладки
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -20, 0, 40)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local Tabs = {"Keybinds", "Functions", "MMV", "Rage"}
    local TabButtons = {}
    local TabContents = {}
    
    for i, name in ipairs(Tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 150, 1, 0)
        btn.Position = UDim2.new(0, (i-1)*155, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.9
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 14
        btn.Parent = TabContainer
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = btn
        TabButtons[name] = btn
        
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -20, 1, -95)
        content.Position = UDim2.new(0, 10, 0, 90)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.ScrollBarThickness = 4
        content.Visible = (i == 1)
        content.Parent = MainFrame
        TabContents[name] = content
    end
    
    -- // ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ GUI
    local function CreateToggleWithBind(parent, label, configTable, configKey, bindKey, yPos, color)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -20, 0, 35)
        row.Position = UDim2.new(0, 10, 0, yPos)
        row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        row.BackgroundTransparency = 0.9
        row.BorderSizePixel = 0
        row.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = row
        
        -- Название функции
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 200, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.Parent = row
        
        -- Отображение бинда
        local bindLabel = Instance.new("TextLabel")
        bindLabel.Size = UDim2.new(0, 80, 1, 0)
        bindLabel.Position = UDim2.new(0, 220, 0, 0)
        bindLabel.BackgroundTransparency = 1
        bindLabel.Text = "[" .. tostring(Config.Keybinds[bindKey]):gsub("Enum.KeyCode.", "") .. "]"
        bindLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        bindLabel.TextXAlignment = Enum.TextXAlignment.Left
        bindLabel.Font = Enum.Font.Gotham
        bindLabel.TextSize = 11
        bindLabel.Parent = row
        
        -- Переключатель
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 70, 1, 0)
        toggle.Position = UDim2.new(1, -80, 0, 0)
        toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        toggle.Text = "OFF"
        toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 12
        toggle.Parent = row
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 8)
        toggleCorner.Parent = toggle
        
        toggle.MouseButton1Click:Connect(function()
            configTable[configKey] = not configTable[configKey]
            toggle.Text = configTable[configKey] and "ON" or "OFF"
            toggle.BackgroundColor3 = configTable[configKey] and (color or Color3.fromRGB(60, 180, 100)) or Color3.fromRGB(60, 60, 80)
        end)
        
        return row
    end
    
    local function CreateKeybind(parent, label, configKey, yPos)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -20, 0, 35)
        row.Position = UDim2.new(0, 10, 0, yPos)
        row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        row.BackgroundTransparency = 0.9
        row.BorderSizePixel = 0
        row.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = row
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 250, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
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
        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 8)
        keyCorner.Parent = keyLabel
        
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
    
    -- // ЗАПОЛНЕНИЕ ВКЛАДОК
    local function SetupTabs()
        -- KEYBINDS
        local keyContent = TabContents["Keybinds"]
        local keyRows = {"ToggleUI", "Bhop", "Fly", "SpeedHack", "Noclip", "Esp", "RageMode", "GodMode", "AutoShoot", "GrabGun", "Fling", "MurderKill"}
        for i, key in ipairs(keyRows) do
            CreateKeybind(keyContent, key, key, 8 + (i-1)*40)
        end
        keyContent.CanvasSize = UDim2.new(0, 0, 0, #keyRows * 40 + 20)
        
        -- FUNCTIONS (с отображением биндов)
        local funcContent = TabContents["Functions"]
        local funcList = {
            {name = "Bhop", bind = "Bhop"},
            {name = "Fly", bind = "Fly"},
            {name = "SpeedHack", bind = "SpeedHack"},
            {name = "Noclip", bind = "Noclip"},
            {name = "Esp", bind = "Esp"},
            {name = "GodMode", bind = "GodMode"},
            {name = "AutoHeal", bind = nil},
            {name = "NoFall", bind = nil}
        }
        for i, func in ipairs(funcList) do
            local color = Color3.fromRGB(60, 180, 100)
            if func.name == "GodMode" then
                color = Color3.fromRGB(180, 60, 200)
            end
            if func.bind then
                CreateToggleWithBind(funcContent, func.name, Config.Functions, func.name, func.bind, 8 + (i-1)*40, color)
            else
                -- Обычный toggle без бинда
                CreateToggleWithBind(funcContent, func.name, Config.Functions, func.name, "ToggleUI", 8 + (i-1)*40, color)
            end
        end
        funcContent.CanvasSize = UDim2.new(0, 0, 0, #funcList * 40 + 20)
        
        -- MMV (с отображением биндов)
        local mmvContent = TabContents["MMV"]
        local mmvFunctions = {
            {name = "Auto Fling", bind = "Fling"},
            {name = "Grab Gun", bind = "GrabGun"},
            {name = "ESP Murder/Sherif", bind = nil},
            {name = "Auto Shoot Murder", bind = "AutoShoot"},
            {name = "NoClip MMV", bind = nil},
            {name = "Speed Boost", bind = nil},
            {name = "Jump Boost", bind = nil}
        }
        for i, func in ipairs(mmvFunctions) do
            local color = Color3.fromRGB(100, 200, 255)
            if func.name == "Auto Shoot Murder" then
                color = Color3.fromRGB(255, 100, 100)
            end
            if func.bind then
                CreateToggleWithBind(mmvContent, func.name, Config.MMV, func.name:gsub(" ", ""), func.bind, 8 + (i-1)*40, color)
            else
                CreateToggleWithBind(mmvContent, func.name, Config.MMV, func.name:gsub(" ", ""), "ToggleUI", 8 + (i-1)*40, color)
            end
        end
        mmvContent.CanvasSize = UDim2.new(0, 0, 0, #mmvFunctions * 40 + 20)
        
        -- RAGE
        local rageContent = TabContents["Rage"]
        local rageElements = {
            {type = "toggle", label = "Rage Mode", key = "Enabled", color = Color3.fromRGB(180, 60, 60)},
            {type = "toggle", label = "Aimbot", key = "Aimbot", color = Color3.fromRGB(180, 60, 60)},
            {type = "toggle", label = "TriggerBot", key = "TriggerBot", color = Color3.fromRGB(180, 60, 60)},
            {type = "toggle", label = "Silent Aim", key = "SilentAim", color = Color3.fromRGB(180, 60, 60)},
            {type = "toggle", label = "WallShot", key = "WallShot", color = Color3.fromRGB(180, 60, 60)},
            {type = "slider", label = "FOV", key = "FOV", min = 30, max = 360},
            {type = "slider", label = "Smoothness", key = "Smoothness", min = 0.1, max = 1.0}
        }
        for i, elem in ipairs(rageElements) do
            if elem.type == "toggle" then
                CreateToggleWithBind(rageContent, elem.label, Config.Rage, elem.key, "ToggleUI", 8 + (i-1)*40, elem.color)
            elseif elem.type == "slider" then
                -- Слайдер (без бинда)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, -20, 0, 35)
                row.Position = UDim2.new(0, 10, 0, 8 + (i-1)*40)
                row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                row.BackgroundTransparency = 0.9
                row.BorderSizePixel = 0
                row.Parent = rageContent
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 10)
                corner.Parent = row
                
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(0, 200, 1, 0)
                lbl.Position = UDim2.new(0, 10, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = elem.label
                lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Font = Enum.Font.Gotham
                lbl.TextSize = 13
                lbl.Parent = row
                
                local slider = Instance.new("TextBox")
                slider.Size = UDim2.new(0, 80, 1, 0)
                slider.Position = UDim2.new(1, -90, 0, 0)
                slider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                slider.Text = tostring(Config.Rage[elem.key])
                slider.TextColor3 = Color3.fromRGB(255, 255, 255)
                slider.Font = Enum.Font.GothamBold
                slider.TextSize = 12
                slider.Parent = row
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 8)
                sliderCorner.Parent = slider
                
                slider.FocusLost:Connect(function()
                    local val = tonumber(slider.Text)
                    if val then
                        Config.Rage[elem.key] = math.clamp(val, elem.min, elem.max)
                        slider.Text = tostring(Config.Rage[elem.key])
                    end
                end)
            end
        end
        rageContent.CanvasSize = UDim2.new(0, 0, 0, #rageElements * 40 + 20)
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
                b.BackgroundTransparency = 0.9
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
    
    -- // ФУНКЦИИ MMV
    -- Auto Fling
    RunService.Heartbeat:Connect(function()
        if Config.MMV.AutoFling and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetRoot = player.Character.HumanoidRootPart
                        local direction = (targetRoot.Position - root.Position).Unit
                        targetRoot.Velocity = direction * 200 + Vector3.new(0, 50, 0)
                    end
                end
            end
        end
    end)
    
    -- Grab Gun (автоматический подбор оружия)
    RunService.Heartbeat:Connect(function()
        if Config.MMV.GrabGun and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, item in pairs(Workspace:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("Part") and item.Name:lower():find("gun") or item.Name:lower():find("weapon") then
                        local distance = (item.Position - root.Position).Magnitude
                        if distance < 20 then
                            fireclickdetector(item:FindFirstChildOfClass("ClickDetector") or item:FindFirstChild("ClickDetector"))
                        end
                    end
                end
            end
        end
    end)
    
    -- ESP Murder/Sherif
    RunService.RenderStepped:Connect(function()
        if Config.MMV.EspMurderSherif then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        local isMurderer = player.Name:lower():find("murderer") or player.Name:lower():find("killer")
                        local isSherif = player.Name:lower():find("sherif") or player.Name:lower():find("sheriff")
                        
                        if isMurderer or isSherif then
                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                local esp = Instance.new("BillboardGui")
                                esp.Size = UDim2.new(0, 100, 0, 30)
                                esp.StudsOffset = Vector3.new(0, 3, 0)
                                esp.AlwaysOnTop = true
                                esp.Parent = player.Character
                                
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.Text = isMurderer and "🔪 MURDERER" or "⭐ SHERIF"
                                label.TextColor3 = isMurderer and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                                label.TextStrokeTransparency = 0.5
                                label.TextScaled = true
                                label.Font = Enum.Font.GothamBold
                                label.Parent = esp
                                
                                task.wait(1)
                                esp:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Auto Shoot Murder
    RunService.Heartbeat:Connect(function()
        if Config.MMV.AutoShootMurder then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and (player.Name:lower():find("murderer") or player.Name:lower():find("killer")) then
                        local root = player.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                            if onScreen then
                                -- Наводимся и стреляем
                                local deltaX = screenPos.X - Mouse.X
                                local deltaY = screenPos.Y - Mouse.Y
                                mousemoverel(deltaX * 0.5, deltaY * 0.5)
                                mouse1click()
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Бинд для Auto Shoot Murder
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Config.Keybinds.AutoShoot then
            Config.MMV.AutoShootMurder = not Config.MMV.AutoShootMurder
            -- Обновляем GUI
            for _, child in pairs(TabContents["MMV"]:GetChildren()) do
                if child:IsA("Frame") and child:FindFirstChild("TextLabel") then
                    local label = child.TextLabel
                    if label.Text:find("Auto Shoot Murder") then
                        local toggle = child:FindFirstChild("TextButton")
                        if toggle then
                            toggle.Text = Config.MMV.AutoShootMurder and "ON" or "OFF"
                            toggle.BackgroundColor3 = Config.MMV.AutoShootMurder and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(60, 60, 80)
                        end
                    end
                end
            end
        end
    end)
    
    -- // ОСТАЛЬНЫЕ ФУНКЦИИ (стандартные)
    -- God Mode, Bhop, Fly, SpeedHack, Noclip, Esp
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
    
    RunService.Heartbeat:Connect(function()
        if Config.Functions.Bhop and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.MoveDirection.Magnitude > 1 and humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid.Jump = true
            end
        end
    end)
    
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
    
    RunService.Heartbeat:Connect(function()
        if Config.Functions.SpeedHack and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 50
            end
        elseif LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if Config.Functions.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    
    -- ESP
    local espTable = {}
    RunService.RenderStepped:Connect(function()
        if Config.Functions.Esp then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        if not espTable[player.Name] then
                            local esp = Instance.new("BillboardGui")
                            esp.Size = UDim2.new(0, 100, 0, 30)
                            esp.StudsOffset = Vector3.new(0, 3, 0)
                            esp.AlwaysOnTop = true
                            esp.Parent = player.Character
                            
                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.Size = UDim2.new(1, 0, 1, 0)
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.Text = player.Name
                            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            nameLabel.TextStrokeTransparency = 0.5
                            nameLabel.TextScaled = true
                            nameLabel.Font = Enum.Font.GothamBold
                            nameLabel.Parent = esp
                            
                            local box = Instance.new("BoxHandleAdornment")
                            box.Size = Vector3.new(3, 5, 1)
                            box.Adornee = player.Character
                            box.Color3 = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 0, 0)
                            box.Transparency = 0.3
                            box.Parent = player.Character
                            
                            espTable[player.Name] = {esp = esp, box = box}
                        end
                    else
                        if espTable[player.Name] then
                            espTable[player.Name].esp:Destroy()
                            espTable[player.Name].box:Destroy()
                            espTable[player.Name] = nil
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
    
    -- // УПРАВЛЕНИЕ ОКНОМ
    local isMinified = false
    local miniButton = Instance.new("TextButton")
    miniButton.Size = UDim2.new(0, 90, 0, 35)
    miniButton.Position = UDim2.new(0.02, 0, 0.1, 0)
    miniButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    miniButton.BackgroundTransparency = 0.3
    miniButton.Text = "✦ Xeno v4.0"
    miniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniButton.Font = Enum.Font.GothamBold
    miniButton.TextSize = 14
    miniButton.Visible = false
    miniButton.Parent = ScreenGui
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 15)
    miniCorner.Parent = miniButton
    
    local function toggleMinify()
        isMinified = not isMinified
        MainFrame.Visible = not isMinified
        miniButton.Visible = isMinified
    end
    
    -- Кнопки управления
    local function createControlButton(text, color, posX, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 35, 1, 0)
        btn.Position = UDim2.new(1, posX, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.TextColor3 = color
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.Parent = TitleBar
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = btn
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    createControlButton("─", Color3.fromRGB(200, 200, 200), -105, toggleMinify)
    createControlButton("✕", Color3.fromRGB(255, 150, 150), -70, function()
        MainFrame.Visible = false
        miniButton.Visible = false
    end)
    createControlButton("✖", Color3.fromRGB(255, 50, 50), -35, function()
        ScreenGui:Destroy()
    end)
    
    miniButton.MouseButton1Click:Connect(toggleMinify)
    
    -- // ГЛОБАЛЬНЫЙ ТОГГЛ
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Config.Keybinds.ToggleUI then
            MainFrame.Visible = not MainFrame.Visible
            if MainFrame.Visible then miniButton.Visible = false end
        end
    end)
    
    -- // КЕЙБИНДЫ
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        for func, key in pairs(Config.Keybinds) do
            if func ~= "ToggleUI" and input.KeyCode == key then
                if Config.Functions[func] ~= nil then
                    Config.Functions[func] = not Config.Functions[func]
                    -- Обновляем GUI
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
    
    print("✦ XenoAlpha v4.0 (MMV Edition) загружен! ✦")
    print("✦ Наслаждайся новыми функциями для MMV! ✦")
end

-- Запускаем основной скрипт
pcall(MainScript)
