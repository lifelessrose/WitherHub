--[[
    ===================================================
    WitherHub Script
    Created by: lifelessrose & King_sweets2004
    Owner: King_sweets2004
    Contributors: lifelessrose
    ===================================================
]]

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Whitelist and Owner
local whitelistedPlayers = { "King_sweets2004", "AnotherUsername" }
local scriptOwner = "King_sweets2004"

-- Check Whitelist
local function isWhitelisted(playerName)
    for _, name in ipairs(whitelistedPlayers) do
        if name == playerName then
            return true
        end
    end
    return false
end

-- Nametag Creation Function
local function createNametag(character, tagText, tagColor)
    if character:FindFirstChild("Head") then
        local head = character:FindFirstChild("Head")
        if not head:FindFirstChild("WitherHubNametag") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "WitherHubNametag"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = tagText
            label.TextColor3 = tagColor
            label.TextScaled = true
            label.Font = Enum.Font.SourceSansBold
            label.Parent = billboard
        end
    end
end

-- Add Nametag to Owner or Users
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if player.Name == scriptOwner then
            createNametag(character, "WitherHub Owner", Color3.new(1, 0.8, 0)) -- Gold color for owner
        elseif isWhitelisted(player.Name) then
            createNametag(character, "WitherHub User", Color3.new(0, 1, 0)) -- Green color for users
        end
    end)
end)

-- Initial Check for Current Player
if Player.Name == scriptOwner then
    createNametag(Player.Character or Player.CharacterAdded:Wait(), "WitherHub Owner", Color3.new(1, 0.8, 0))
elseif not isWhitelisted(Player.Name) then
    Player:Kick("You are not whitelisted for WitherHub.")
else
    createNametag(Player.Character or Player.CharacterAdded:Wait(), "WitherHub User", Color3.new(0, 1, 0))
end
