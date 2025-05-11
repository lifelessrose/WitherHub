local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Library:CreateWindow({
    Name = "WitherHub",
    Theme = Library.Themes.Dark,
    Size = UDim2.new(0, 500, 0, 350),
})

local Tab = Window:CreateTab("Exploits")
local Category = Tab:CreateCategory("Game Exploits")

local ESPButton = Category:CreateButton({
    Name = "Enable ESP",
    Callback = function()
        local ESP = Instance.new("Folder")
        ESP.Name = "ESP"
        ESP.Parent = Workspace
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                local esp = Instance.new("BillboardGui")
                esp.AlwaysOnTop = true
                esp.Size = UDim2.new(0, 200, 0, 50)
                esp.Parent = ESP
                local label = Instance.new("TextLabel")
                label.Text = player.Name
                label.Size = UDim2.new(0, 200, 0, 50)
                label.Parent = esp
                esp.Adornee = player.Character
            end
        end
    end
})

local TeleportButton = Category:CreateButton({
    Name = "Enable Teleport",
    Callback = function()
        local TeleportFolder = Instance.new("Folder")
        TeleportFolder.Name = "Teleports"
        TeleportFolder.Parent = Workspace
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                local teleport = Instance.new("Part")
                teleport.Anchored = true
                teleport.CanCollide = false
                teleport.Transparency = 0.5
                teleport.Size = Vector3.new(5, 5, 5)
                teleport.BrickColor = BrickColor.new("Red")
                teleport.Parent = TeleportFolder
                local clickDetector = Instance.new("ClickDetector")
                clickDetector.Parent = teleport
                clickDetector.MouseClick:Connect(function()
                    Player.Character:FindFirstChild("HumanoidRootPart").CFrame = teleport.CFrame
                end)
                teleport.CFrame = player.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

local InfiniteJumpButton = Category:CreateButton({
    Name = "Enable Infinite Jump",
    Callback = function()
        local UIS = game:GetService("UserInputService")
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        UIS.JumpRequest:Connect(function()
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
})
