local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local whitelistedPlayers = { "King_sweets2004", "lifelessrose" }
local scriptOwner = "King_sweets2004"
local commandPrefix = ";"

local noclipEnabled = false
local noclipConnection = nil
local flyEnabled = false
local flyConnection = nil
local flySpeed = 1
local godModeEnabled = false

local gui = nil
local noclipButton, flyButton, godModeButton
local mainFrameMinimized = false
local originalMainFrameSizeY = 350
local titleBarHeight = 30

local function isWhitelisted(playerName)
    if playerName == scriptOwner then
        return true
    end
    for _, name in ipairs(whitelistedPlayers) do
        if name == playerName then
            return true
        end
    end
    return false
end

local function createNametag(targetCharacter, tagText, tagColor)
    if not targetCharacter or not targetCharacter:IsA("Model") then return end
    local head = targetCharacter:FindFirstChild("Head")
    if head then
        local oldNametag = head:FindFirstChild("WitherHubNametag")
        if oldNametag then
            oldNametag:Destroy()
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "WitherHubNametag"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = tagText
        label.TextColor3 = tagColor
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0.5
        label.Parent = billboard
    end
end

local function applyPlayerNametag(playerInstance)
    playerInstance.CharacterAdded:Connect(function(char)
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

        if playerInstance.Name == scriptOwner then
            createNametag(char, "👑 WitherHub Owner 👑", Color3.fromRGB(255, 215, 0))
        elseif isWhitelisted(playerInstance.Name) then
            createNametag(char, "✨ WitherHub User ✨", Color3.fromRGB(0, 255, 0))
        end
    end)
    if playerInstance.Character then
        local char = playerInstance.Character
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

        if playerInstance.Name == scriptOwner then
            createNametag(char, "👑 WitherHub Owner 👑", Color3.fromRGB(255, 215, 0))
        elseif isWhitelisted(playerInstance.Name) then
            createNametag(char, "✨ WitherHub User ✨", Color3.fromRGB(0, 255, 0))
        end
    end
end

Players.PlayerAdded:Connect(applyPlayerNametag)
for _, playerInstance in ipairs(Players:GetPlayers()) do
    applyPlayerNametag(playerInstance)
end

local function updateButtonState(button, featureName, isEnabled)
    if button then
        button.Text = featureName .. ": " .. (isEnabled and "ON" or "OFF")
        button.BackgroundColor3 = isEnabled and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(180, 70, 70)
    end
end

local function toggleNoclip()
    if not isWhitelisted(Player.Name) then return end
    noclipEnabled = not noclipEnabled
    updateButtonState(noclipButton, "Noclip", noclipEnabled)
    if noclipEnabled then
        print("WitherHub: Noclip Enabled")
        noclipConnection = RunService.Stepped:Connect(function()
            if Character and Humanoid and noclipEnabled then
                Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                for _, part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            elseif not noclipEnabled and noclipConnection then
                 noclipConnection:Disconnect()
                 noclipConnection = nil
            end
        end)
    else
        print("WitherHub: Noclip Disabled")
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if Character and Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
             for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function toggleFly()
    if not isWhitelisted(Player.Name) then return end
    flyEnabled = not flyEnabled
    updateButtonState(flyButton, "Fly", flyEnabled)
    local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if flyEnabled then
        print("WitherHub: Fly Enabled")
        if humanoidRootPart then
            local bodyVelocity = humanoidRootPart:FindFirstChild("WitherHub_BodyVelocity") or Instance.new("BodyVelocity")
            bodyVelocity.Name = "WitherHub_BodyVelocity"
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.P = 5000
            bodyVelocity.Parent = humanoidRootPart

            local bodyGyro = humanoidRootPart:FindFirstChild("WitherHub_BodyGyro") or Instance.new("BodyGyro")
            bodyGyro.Name = "WitherHub_BodyGyro"
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.P = 5000
            bodyGyro.CFrame = humanoidRootPart.CFrame
            bodyGyro.Parent = humanoidRootPart
        end

        flyConnection = RunService.RenderStepped:Connect(function()
            if not flyEnabled or not Character or not Character:FindFirstChild("HumanoidRootPart") then
                if flyConnection then flyConnection:Disconnect(); flyConnection = nil; end
                return
            end
            humanoidRootPart = Character:FindFirstChild("HumanoidRootPart") 
            if not humanoidRootPart then return end
            
            local cam = workspace.CurrentCamera
            local moveVector = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then moveVector = moveVector - Vector3.new(0,1,0) end
            
            if humanoidRootPart:FindFirstChild("WitherHub_BodyVelocity") then
                humanoidRootPart.WitherHub_BodyVelocity.Velocity = moveVector.Unit * flySpeed * (Humanoid and Humanoid.WalkSpeed/2 or 8)
            end
            if humanoidRootPart:FindFirstChild("WitherHub_BodyGyro") then
                 humanoidRootPart.WitherHub_BodyGyro.CFrame = cam.CFrame
            end
        end)
    else
        print("WitherHub: Fly Disabled")
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if humanoidRootPart then
            local bv = humanoidRootPart:FindFirstChild("WitherHub_BodyVelocity")
            if bv then bv:Destroy() end
            local bg = humanoidRootPart:FindFirstChild("WitherHub_BodyGyro")
            if bg then bg:Destroy() end
        end
    end
end

local function toggleGodMode()
    if not isWhitelisted(Player.Name) or not Humanoid then return end
    godModeEnabled = not godModeEnabled
    updateButtonState(godModeButton, "God Mode", godModeEnabled)
    if godModeEnabled then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        print("WitherHub: God mode enabled.")
    else
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
        print("WitherHub: God mode disabled.")
    end
end

local function createWitherHubGui()
    if gui and gui.Parent then gui:Destroy() end

    gui = Instance.new("ScreenGui")
    gui.Name = "WitherHub"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 1000

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, originalMainFrameSizeY)
    mainFrame.Position = UDim2.new(0.02, 0, 0.5, -(originalMainFrameSizeY/2))
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    mainFrame.BorderSizePixel = 2
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true 
    mainFrame.Parent = gui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, titleBarHeight)
    titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleLabel.BorderColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.BorderSizePixel = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "WitherHub - by " .. scriptOwner
    titleLabel.TextSize = 16
    titleLabel.Parent = mainFrame

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0,20,0,20)
    closeButton.Position = UDim2.new(1,-25,0,5) 
    closeButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
    closeButton.TextColor3 = Color3.fromRGB(255,255,255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.ZIndex = 2
    closeButton.Parent = titleLabel
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0,20,0,20)
    minimizeButton.Position = UDim2.new(1,-50,0,5) 
    minimizeButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
    minimizeButton.TextColor3 = Color3.fromRGB(255,255,255)
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Text = "_"
    minimizeButton.ZIndex = 2
    minimizeButton.Parent = titleLabel
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1,0,1,-titleBarHeight)
    contentFrame.Position = UDim2.new(0,0,0,titleBarHeight)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    minimizeButton.MouseButton1Click:Connect(function()
        mainFrameMinimized = not mainFrameMinimized
        if mainFrameMinimized then
            mainFrame.Size = UDim2.new(mainFrame.Size.X.Scale, mainFrame.Size.X.Offset, 0, titleBarHeight)
            minimizeButton.Text = "□" 
            contentFrame.Visible = false
        else
            mainFrame.Size = UDim2.new(mainFrame.Size.X.Scale, mainFrame.Size.X.Offset, 0, originalMainFrameSizeY)
            minimizeButton.Text = "_"
            contentFrame.Visible = true
        end
    end)

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Parent = contentFrame 

    local function createFeatureButton(text, layoutOrder, callback)
        local button = Instance.new("TextButton")
        button.Name = text .. "Button"
        button.Size = UDim2.new(0.9, 0, 0, 35)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.BorderColor3 = Color3.fromRGB(255, 215, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamSemibold
        button.Text = text
        button.LayoutOrder = layoutOrder
        button.Parent = contentFrame 
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        return button
    end

    noclipButton = createFeatureButton("Noclip: OFF", 1, toggleNoclip)
    flyButton = createFeatureButton("Fly: OFF", 2, toggleFly)
    godModeButton = createFeatureButton("God Mode: OFF", 3, toggleGodMode)
    updateButtonState(noclipButton, "Noclip", noclipEnabled)
    updateButtonState(flyButton, "Fly", flyEnabled)
    updateButtonState(godModeButton, "God Mode", godModeEnabled)
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.9,0,0,20)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(220,220,220)
    speedLabel.Text = "WalkSpeed:"
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.LayoutOrder = 4
    speedLabel.Parent = contentFrame
    
    local speedInput = Instance.new("TextBox")
    speedInput.Name = "SpeedInput"
    speedInput.Size = UDim2.new(0.9, 0, 0, 30)
    speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedInput.BorderColor3 = Color3.fromRGB(100, 100, 100)
    speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedInput.PlaceholderText = "Enter speed (e.g., 50)"
    speedInput.Text = tostring(Humanoid and Humanoid.WalkSpeed or 16)
    speedInput.Font = Enum.Font.Gotham
    speedInput.NumbersOnly = true
    speedInput.LayoutOrder = 5
    speedInput.Parent = contentFrame
    speedInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local speedValue = tonumber(speedInput.Text)
            if speedValue and Humanoid then
                Humanoid.WalkSpeed = speedValue
                print("WitherHub: WalkSpeed set to " .. speedValue)
            else
                speedInput.Text = tostring(Humanoid and Humanoid.WalkSpeed or 16)
            end
        end
    end)

    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(0.9,0,0,20)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.TextColor3 = Color3.fromRGB(220,220,220)
    jumpLabel.Text = "JumpPower:"
    jumpLabel.Font = Enum.Font.Gotham
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumpLabel.LayoutOrder = 6
    jumpLabel.Parent = contentFrame

    local jumpInput = Instance.new("TextBox")
    jumpInput.Name = "JumpInput"
    jumpInput.Size = UDim2.new(0.9, 0, 0, 30)
    jumpInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    jumpInput.BorderColor3 = Color3.fromRGB(100, 100, 100)
    jumpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpInput.PlaceholderText = "Enter jump power (e.g., 100)"
    jumpInput.Text = tostring(Humanoid and Humanoid.JumpPower or 50)
    jumpInput.Font = Enum.Font.Gotham
    jumpInput.NumbersOnly = true
    jumpInput.LayoutOrder = 7
    jumpInput.Parent = contentFrame
    jumpInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local jumpValue = tonumber(jumpInput.Text)
            if jumpValue and Humanoid then
                Humanoid.JumpPower = jumpValue
                Humanoid.UseJumpPower = true
                print("WitherHub: JumpPower set to " .. jumpValue)
            else
                jumpInput.Text = tostring(Humanoid and Humanoid.JumpPower or 50)
            end
        end
    end)
    
    local openGuiButton = Instance.new("TextButton")
    openGuiButton.Name = "OpenWitherHubButton"
    openGuiButton.Size = UDim2.new(0, 150, 0, 40)
    openGuiButton.Position = UDim2.new(0, 10, 0, 10)
    openGuiButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    openGuiButton.BorderColor3 = Color3.fromRGB(255, 215, 0)
    openGuiButton.TextColor3 = Color3.fromRGB(255, 215, 0)
    openGuiButton.Font = Enum.Font.GothamBold
    openGuiButton.Text = "WitherHub"
    openGuiButton.Parent = gui
    openGuiButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible and mainFrameMinimized then 
            mainFrameMinimized = true 
             local titleLabelRef = mainFrame:FindFirstChild("TitleLabel")
             if titleLabelRef then
                local minimizeBtnRef = titleLabelRef:FindFirstChild("MinimizeButton")
                if minimizeBtnRef then minimizeBtnRef.MouseButton1Click:Fire() end
             end
        end
    end)

    gui.Parent = Player:WaitForChild("PlayerGui")
    print("WitherHub: GUI Created.")
end

local function processCommand(fullCommand)
    local parts = string.split(fullCommand, " ")
    local command = string.lower(parts[1])
    local args = {}
    for i = 2, #parts do
        table.insert(args, parts[i])
    end

    if command == "speed" then
        local targetPlayerName = args[1]
        local speedValue = tonumber(args[2])
        if targetPlayerName == "me" and speedValue and Humanoid then
            Humanoid.WalkSpeed = speedValue
            print("WitherHub: WalkSpeed set to " .. speedValue)
            if gui and gui.MainFrame and gui.MainFrame.ContentFrame then local speedInput = gui.MainFrame.ContentFrame.SpeedInput; if speedInput then speedInput.Text = tostring(speedValue) end end
        else
            print("WitherHub: Usage - ;speed me [value]")
        end
    elseif command == "jump" or command == "jumppower" then
        local targetPlayerName = args[1]
        local jumpValue = tonumber(args[2])
        if targetPlayerName == "me" and jumpValue and Humanoid then
            Humanoid.JumpPower = jumpValue
            Humanoid.UseJumpPower = true
            print("WitherHub: JumpPower set to " .. jumpValue)
             if gui and gui.MainFrame and gui.MainFrame.ContentFrame then local jumpInput = gui.MainFrame.ContentFrame.JumpInput; if jumpInput then jumpInput.Text = tostring(jumpValue) end end
        else
            print("WitherHub: Usage - ;jump me [value]")
        end
    elseif command == "god" or command == "godme" then
        if not godModeEnabled then toggleGodMode() end
    elseif command == "ungod" or command == "ungodme" then
        if godModeEnabled then toggleGodMode() end
    elseif command == "noclip" then
        toggleNoclip()
    elseif command == "fly" then
        toggleFly()
    elseif command == "rejoin" or command == "rj" then
        print("WitherHub: Rejoining...")
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, Player)
    elseif command == "gui" or command == "togglegui" then
        if gui and gui.MainFrame then
            gui.MainFrame.Visible = not gui.MainFrame.Visible
        end
    elseif command == "cmds" or command == "commands" or command == "help" then
        print("WitherHub Commands (" .. commandPrefix .. "): speed me [val], jump me [val], god, ungod, noclip, fly, rejoin, gui")
    else
        print("WitherHub: Unknown command '" .. command .. "'. Type " .. commandPrefix .. "cmds for help.")
    end
end

Player.Chatted:Connect(function(message)
    if not isWhitelisted(Player.Name) then
        return
    end

    message = string.lower(message)
    if string.sub(message, 1, string.len(commandPrefix)) == commandPrefix then
        local commandStr = string.sub(message, string.len(commandPrefix) + 1)
        processCommand(commandStr)
    end
end)

Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    print("WitherHub: New character loaded for LocalPlayer.")
    
    if noclipButton then updateButtonState(noclipButton, "Noclip", noclipEnabled) end
    if noclipEnabled then
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil; end
        local wasEnabled = noclipEnabled; noclipEnabled = false; toggleNoclip(); 
        if not wasEnabled then toggleNoclip() end 
    end

    if flyButton then updateButtonState(flyButton, "Fly", flyEnabled) end
     if flyEnabled then
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil; end
        local wasEnabled = flyEnabled; flyEnabled = false; toggleFly();
        if not wasEnabled then toggleFly() end
    end
    
    if godModeButton then updateButtonState(godModeButton, "God Mode", godModeEnabled) end
    if godModeEnabled and Humanoid then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    elseif not godModeEnabled and Humanoid then
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
    end

    if gui and gui.MainFrame and gui.MainFrame.ContentFrame then
        local speedInput = gui.MainFrame.ContentFrame:FindFirstChild("SpeedInput")
        if speedInput and Humanoid then speedInput.Text = tostring(Humanoid.WalkSpeed) end
        local jumpInput = gui.MainFrame.ContentFrame:FindFirstChild("JumpInput")
        if jumpInput and Humanoid then jumpInput.Text = tostring(Humanoid.JumpPower) end
    end
end)

if not isWhitelisted(Player.Name) then
    Player:Kick("You are not whitelisted for WitherHub.")
else
    print("WitherHub: Welcome, " .. Player.Name)
    createWitherHubGui()
    if noclipButton then updateButtonState(noclipButton, "Noclip", noclipEnabled) end
    if flyButton then updateButtonState(flyButton, "Fly", flyEnabled) end
    if godModeButton then updateButtonState(godModeButton, "God Mode", godModeEnabled) end
end

print("WitherHub Script Loaded. Type " .. commandPrefix .. "cmds for commands or use the GUI if whitelisted.")
