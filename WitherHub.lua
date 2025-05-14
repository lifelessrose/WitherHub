-- Credits
-- This script was created and maintained by lifelessrose.

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
    Size = UDim2.new(0, 500, 0, 400),
})

if not Window then
    warn("Failed to create UI Window. Ensure the library is working properly.")
    return
end

print("UI Window created successfully")

local Tab = Window:CreateTab("Exploits")
local Category = Tab:CreateCategory("Game Exploits")

Category:CreateButton({
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

Category:CreateSlider({
    Name = "Walkspeed Modifier",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = value
        end
    end
})

Category:CreateSlider({
    Name = "Gravity Modifier",
    Min = 10,
    Max = 500,
    Default = Workspace.Gravity,
    Callback = function(value)
        Workspace.Gravity = value
    end
})

local noclipEnabled = false
Category:CreateToggle({
    Name = "Enable Noclip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        RunService.Stepped:Connect(function()
            if noclipEnabled and Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
})

Category:CreateToggle({
    Name = "Enable God Mode",
    Default = false,
    Callback = function(state)
        if state then
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.MaxHealth = math.huge
                Player.Character.Humanoid.Health = math.huge
            end
        else
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.MaxHealth = 100
                Player.Character.Humanoid.Health = 100
            end
        end
    end
})

Category:CreateButton({
    Name = "Kill All Players",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = 0
            end
        end
    end
})
