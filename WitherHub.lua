local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

print("Script started")
print("Player initialized: ", Player)

local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end)

if not success or not Library then
    warn("Failed to load library. Check the URL or your internet connection.")
    return
end

print("Library loaded successfully")

local Window = Library:CreateWindow({
    Name = "WitherHub",
    Theme = Library.Themes.Dark,
    Size = UDim2.new(0, 500, 0, 350),
})

if not Window then
    warn("Failed to create UI Window. Ensure the library is working properly.")
    return
end

print("UI Window created successfully")

local Tab = Window:CreateTab("Exploits")
local Category = Tab:CreateCategory("Game Exploits")

local ESPButton = Category:CreateButton({
    Name = "Enable ESP",
    Callback = function()
        print("ESP Button clicked")
        local ESP = Instance.new("Folder")
        ESP.Name = "ESP"
        ESP.Parent = Workspace

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local esp = Instance.new("BillboardGui")
                esp.AlwaysOnTop = true
                esp.Size = UDim2.new(0, 200, 0, 50)
                esp.Parent = ESP

                local label = Instance.new("TextLabel")
                label.Text = player.Name
                label.Size = UDim2.new(0, 200, 0, 50)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.new(1, 0, 0)
                label.Parent = esp

                esp.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
            end
        end
    end
})

local TeleportButton = Category:CreateButton({
    Name = "Enable Teleport",
    Callback = function()
        print("Teleport Button clicked")
        local TeleportFolder = Instance.new("Folder")
        TeleportFolder.Name = "Teleports"
        TeleportFolder.Parent = Workspace

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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
                    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        Player.Character.HumanoidRootPart.CFrame = teleport.CFrame
                    end
                end)

                teleport.CFrame = player.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

local InfiniteJumpButton = Category:CreateButton({
    Name = "Enable Infinite Jump",
    Callback = function()
        print("Infinite Jump Button clicked")
        UserInputService.JumpRequest:Connect(function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
_

