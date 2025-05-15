local sP = game:GetService("Players")
local sUIS = game:GetService("UserInputService")
local sRS = game:GetService("RunService")
local sCS = game:GetService("CoreGui")
local lP = sP.LocalPlayer
local lC = lP.Character or lP.CharacterAdded:Wait()
local lH = lC:WaitForChild("Humanoid")
local wLst = { "King_sweets2004", "lifelessrose" }
local sOwn = "King_sweets_2004" 
local cmdPre = ";"
local ncEn = false
local ncCon = nil
local fEn = false
local fCon = nil
local fSpd = 1
local gEn = false
local mainG = nil
local ncBtn, fBtn, gBtn
local mFMini = false
local ogMFSY = 350
local tBH = 30
local function fnIW(pName)
if pName == sOwn then return true end
for _, n in ipairs(wLst) do
if n == pName then return true end
end
return false
end
local function fnCN(tChar, tTxt, tClr)
if not tChar or not tChar:IsA("Model") then return end
local hd = tChar:FindFirstChild("Head")
if hd then
local oNT = hd:FindFirstChild("WitherHubNametag")
if oNT then oNT:Destroy() end
local bG = Instance.new("BillboardGui")
bG.Name = "WitherHubNametag"
bG.Size = UDim2.new(0, 200, 0, 50)
bG.StudsOffset = Vector3.new(0, 2.5, 0)
bG.AlwaysOnTop = true
bG.Parent = hd
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(1, 0, 1, 0)
lbl.BackgroundTransparency = 1
lbl.Text = tTxt
lbl.TextColor3 = tClr
lbl.TextScaled = true
lbl.Font = Enum.Font.GothamBold
lbl.TextStrokeTransparency = 0.5
lbl.Parent = bG
end
end
local function fnAPN(pInst)
pInst.CharacterAdded:Connect(function(chr)
local hum = chr:WaitForChild("Humanoid")
hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
if pInst.Name == sOwn then
fnCN(chr, "👑 WitherHub Owner 👑", Color3.fromRGB(255, 215, 0))
elseif fnIW(pInst.Name) then
fnCN(chr, "✨ WitherHub User ✨", Color3.fromRGB(0, 255, 0))
end
end)
if pInst.Character then
local chr = pInst.Character
local hum = chr:WaitForChild("Humanoid")
hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
if pInst.Name == sOwn then
fnCN(chr, "👑 WitherHub Owner 👑", Color3.fromRGB(255, 215, 0))
elseif fnIW(pInst.Name) then
fnCN(chr, "✨ WitherHub User ✨", Color3.fromRGB(0, 255, 0))
end
end
end
sP.PlayerAdded:Connect(fnAPN)
for _, pInst in ipairs(sP:GetPlayers()) do
fnAPN(pInst)
end
local function fnUBS(btn, fName, isEn)
if btn then
btn.Text = fName .. ": " .. (isEn and "ON" or "OFF")
btn.BackgroundColor3 = isEn and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(180, 70, 70)
end
end
local function fnTNC()
if not fnIW(lP.Name) then return end
ncEn = not ncEn
fnUBS(ncBtn, "Noclip", ncEn)
if ncEn then
print("WitherHub: Noclip Enabled")
ncCon = sRS.Stepped:Connect(function()
if lC and lH and ncEn then
lH:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
for _, prt in ipairs(lC:GetDescendants()) do
if prt:IsA("BasePart") and prt.CanCollide then
prt.CanCollide = false
end
end
elseif not ncEn and ncCon then
ncCon:Disconnect()
ncCon = nil
end
end)
else
print("WitherHub: Noclip Disabled")
if ncCon then
ncCon:Disconnect()
ncCon = nil
end
if lC and lH then
lH:ChangeState(Enum.HumanoidStateType.Running)
for _, prt in ipairs(lC:GetDescendants()) do
if prt:IsA("BasePart") and prt.Name ~= "HumanoidRootPart" then
prt.CanCollide = true
end
end
end
end
end
local function fnTF()
if not fnIW(lP.Name) then return end
fEn = not fEn
fnUBS(fBtn, "Fly", fEn)
local hrp = lC and lC:FindFirstChild("HumanoidRootPart")
if fEn then
print("WitherHub: Fly Enabled")
if hrp then
local bV = hrp:FindFirstChild("WitherHub_BodyVelocity") or Instance.new("BodyVelocity")
bV.Name = "WitherHub_BodyVelocity"; bV.MaxForce = Vector3.new(0, math.huge, 0); bV.Velocity = Vector3.new(0,0,0); bV.P = 5000; bV.Parent = hrp
local bG = hrp:FindFirstChild("WitherHub_BodyGyro") or Instance.new("BodyGyro")
bG.Name = "WitherHub_BodyGyro"; bG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bG.P = 5000; bG.CFrame = hrp.CFrame; bG.Parent = hrp
end
fCon = sRS.RenderStepped:Connect(function()
if not fEn or not lC or not lC:FindFirstChild("HumanoidRootPart") then
if fCon then fCon:Disconnect(); fCon = nil; end
return
end
hrp = lC:FindFirstChild("HumanoidRootPart") 
if not hrp then return end
local cam = workspace.CurrentCamera
local mV = Vector3.new()
if sUIS:IsKeyDown(Enum.KeyCode.W) then mV = mV + cam.CFrame.LookVector end
if sUIS:IsKeyDown(Enum.KeyCode.S) then mV = mV - cam.CFrame.LookVector end
if sUIS:IsKeyDown(Enum.KeyCode.A) then mV = mV - cam.CFrame.RightVector end
if sUIS:IsKeyDown(Enum.KeyCode.D) then mV = mV + cam.CFrame.RightVector end
if sUIS:IsKeyDown(Enum.KeyCode.Space) then mV = mV + Vector3.new(0,1,0) end
if sUIS:IsKeyDown(Enum.KeyCode.LeftControl) or sUIS:IsKeyDown(Enum.KeyCode.C) then mV = mV - Vector3.new(0,1,0) end
if hrp:FindFirstChild("WitherHub_BodyVelocity") then
hrp.WitherHub_BodyVelocity.Velocity = mV.Unit * fSpd * (lH and lH.WalkSpeed/2 or 8)
end
if hrp:FindFirstChild("WitherHub_BodyGyro") then
hrp.WitherHub_BodyGyro.CFrame = cam.CFrame
end
end)
else
print("WitherHub: Fly Disabled")
if fCon then fCon:Disconnect(); fCon = nil; end
if hrp then
local bV = hrp:FindFirstChild("WitherHub_BodyVelocity"); if bV then bV:Destroy() end
local bG = hrp:FindFirstChild("WitherHub_BodyGyro"); if bG then bG:Destroy() end
end
end
end
local function fnTGM()
if not fnIW(lP.Name) or not lH then return end
gEn = not gEn
fnUBS(gBtn, "God Mode", gEn)
if gEn then
lH.MaxHealth = math.huge; lH.Health = math.huge; print("WitherHub: God mode enabled.")
else
lH.MaxHealth = 100; lH.Health = 100; print("WitherHub: God mode disabled.")
end
end
local function fnCGUI()
if mainG and mainG.Parent then mainG:Destroy() end
mainG = Instance.new("ScreenGui")
mainG.Name = "WitherHub"; mainG.ResetOnSpawn = false; mainG.DisplayOrder = 1000
local mFrm = Instance.new("Frame")
mFrm.Name = "MainFrame"; mFrm.Size = UDim2.new(0, 250, 0, ogMFSY); mFrm.Position = UDim2.new(0.02, 0, 0.5, -(ogMFSY/2)); mFrm.BackgroundColor3 = Color3.fromRGB(40, 40, 40); mFrm.BorderColor3 = Color3.fromRGB(255, 215, 0); mFrm.BorderSizePixel = 2; mFrm.Active = true; mFrm.Draggable = true; mFrm.Visible = false; mFrm.ClipsDescendants = true; mFrm.Parent = mainG
local tLbl = Instance.new("TextLabel")
tLbl.Name = "TitleLabel"; tLbl.Size = UDim2.new(1, 0, 0, tBH); tLbl.BackgroundColor3 = Color3.fromRGB(30, 30, 30); tLbl.BorderColor3 = Color3.fromRGB(255, 215, 0); tLbl.BorderSizePixel = 1; tLbl.TextColor3 = Color3.fromRGB(255, 215, 0); tLbl.Font = Enum.Font.GothamBold; tLbl.Text = "WitherHub - by " .. sOwn; tLbl.TextSize = 16; tLbl.Parent = mFrm
local clBtn = Instance.new("TextButton")
clBtn.Name = "CloseButton"; clBtn.Size = UDim2.new(0,20,0,20); clBtn.Position = UDim2.new(1,-25,0,5); clBtn.BackgroundColor3 = Color3.fromRGB(200,50,50); clBtn.TextColor3 = Color3.fromRGB(255,255,255); clBtn.Font = Enum.Font.GothamBold; clBtn.Text = "X"; clBtn.ZIndex = 2; clBtn.Parent = tLbl
clBtn.MouseButton1Click:Connect(function() mFrm.Visible = false end)
local minBtn = Instance.new("TextButton")
minBtn.Name = "MinimizeButton"; minBtn.Size = UDim2.new(0,20,0,20); minBtn.Position = UDim2.new(1,-50,0,5); minBtn.BackgroundColor3 = Color3.fromRGB(80,80,80); minBtn.TextColor3 = Color3.fromRGB(255,255,255); minBtn.Font = Enum.Font.GothamBold; minBtn.Text = "_"; minBtn.ZIndex = 2; minBtn.Parent = tLbl
local cFrm = Instance.new("Frame")
cFrm.Name = "ContentFrame"; cFrm.Size = UDim2.new(1,0,1,-tBH); cFrm.Position = UDim2.new(0,0,0,tBH); cFrm.BackgroundTransparency = 1; cFrm.Parent = mFrm
minBtn.MouseButton1Click:Connect(function()
mFMini = not mFMini
if mFMini then
mFrm.Size = UDim2.new(mFrm.Size.X.Scale, mFrm.Size.X.Offset, 0, tBH); minBtn.Text = "□"; cFrm.Visible = false
else
mFrm.Size = UDim2.new(mFrm.Size.X.Scale, mFrm.Size.X.Offset, 0, ogMFSY); minBtn.Text = "_"; cFrm.Visible = true
end
end)
local uilL = Instance.new("UIListLayout")
uilL.Padding = UDim.new(0, 5); uilL.SortOrder = Enum.SortOrder.LayoutOrder; uilL.HorizontalAlignment = Enum.HorizontalAlignment.Center; uilL.Parent = cFrm
local function crFB(txt, lo, cb)
local btn = Instance.new("TextButton")
btn.Name = txt .. "Button"; btn.Size = UDim2.new(0.9, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); btn.BorderColor3 = Color3.fromRGB(255, 215, 0); btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamSemibold; btn.Text = txt; btn.LayoutOrder = lo; btn.Parent = cFrm
if cb then btn.MouseButton1Click:Connect(cb) end
return btn
end
ncBtn = crFB("Noclip: OFF", 1, fnTNC); fBtn = crFB("Fly: OFF", 2, fnTF); gBtn = crFB("God Mode: OFF", 3, fnTGM)
fnUBS(ncBtn, "Noclip", ncEn); fnUBS(fBtn, "Fly", fEn); fnUBS(gBtn, "God Mode", gEn)
local spdL = Instance.new("TextLabel")
spdL.Size = UDim2.new(0.9,0,0,20); spdL.BackgroundTransparency = 1; spdL.TextColor3 = Color3.fromRGB(220,220,220); spdL.Text = "WalkSpeed:"; spdL.Font = Enum.Font.Gotham; spdL.TextXAlignment = Enum.TextXAlignment.Left; spdL.LayoutOrder = 4; spdL.Parent = cFrm
local spdIn = Instance.new("TextBox")
spdIn.Name = "SpeedInput"; spdIn.Size = UDim2.new(0.9, 0, 0, 30); spdIn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); spdIn.BorderColor3 = Color3.fromRGB(100, 100, 100); spdIn.TextColor3 = Color3.fromRGB(255, 255, 255); spdIn.PlaceholderText = "Enter speed (e.g., 50)"; spdIn.Text = tostring(lH and lH.WalkSpeed or 16); spdIn.Font = Enum.Font.Gotham; spdIn.NumbersOnly = true; spdIn.LayoutOrder = 5; spdIn.Parent = cFrm
spdIn.FocusLost:Connect(function(ep)
if ep then
local sV = tonumber(spdIn.Text)
if sV and lH then lH.WalkSpeed = sV; print("WitherHub: WalkSpeed set to " .. sV)
else spdIn.Text = tostring(lH and lH.WalkSpeed or 16) end
end
end)
local jmpL = Instance.new("TextLabel")
jmpL.Size = UDim2.new(0.9,0,0,20); jmpL.BackgroundTransparency = 1; jmpL.TextColor3 = Color3.fromRGB(220,220,220); jmpL.Text = "JumpPower:"; jmpL.Font = Enum.Font.Gotham; jmpL.TextXAlignment = Enum.TextXAlignment.Left; jmpL.LayoutOrder = 6; jmpL.Parent = cFrm
local jmpIn = Instance.new("TextBox")
jmpIn.Name = "JumpInput"; jmpIn.Size = UDim2.new(0.9, 0, 0, 30); jmpIn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); jmpIn.BorderColor3 = Color3.fromRGB(100, 100, 100); jmpIn.TextColor3 = Color3.fromRGB(255, 255, 255); jmpIn.PlaceholderText = "Enter jump power (e.g., 100)"; jmpIn.Text = tostring(lH and lH.JumpPower or 50); jmpIn.Font = Enum.Font.Gotham; jmpIn.NumbersOnly = true; jmpIn.LayoutOrder = 7; jmpIn.Parent = cFrm
jmpIn.FocusLost:Connect(function(ep)
if ep then
local jV = tonumber(jmpIn.Text)
if jV and lH then lH.JumpPower = jV; lH.UseJumpPower = true; print("WitherHub: JumpPower set to " .. jV)
else jmpIn.Text = tostring(lH and lH.JumpPower or 50) end
end
end)
local opnBtn = Instance.new("TextButton")
opnBtn.Name = "OpenWitherHubButton"; opnBtn.Size = UDim2.new(0, 150, 0, 40); opnBtn.Position = UDim2.new(0, 10, 0, 10); opnBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); opnBtn.BorderColor3 = Color3.fromRGB(255, 215, 0); opnBtn.TextColor3 = Color3.fromRGB(255, 215, 0); opnBtn.Font = Enum.Font.GothamBold; opnBtn.Text = "WitherHub"; opnBtn.Parent = mainG
opnBtn.MouseButton1Click:Connect(function()
mFrm.Visible = not mFrm.Visible
if mFrm.Visible and mFMini then mFMini = true; minBtn.MouseButton1Click:Fire() end
end)
mainG.Parent = lP:WaitForChild("PlayerGui")
print("WitherHub: GUI Created.")
end
local function fnPCmd(fCmd)
local pts = string.split(fCmd, " ")
local cmd = string.lower(pts[1])
local ags = {}
for i = 2, #pts do table.insert(ags, pts[i]) end
if cmd == "speed" then
local tPN = ags[1]; local sV = tonumber(ags[2])
if tPN == "me" and sV and lH then lH.WalkSpeed = sV; print("WitherHub: WalkSpeed set to " .. sV)
if mainG and mainG.MainFrame and mainG.MainFrame.ContentFrame then local sI = mainG.MainFrame.ContentFrame.SpeedInput; if sI then sI.Text = tostring(sV) end end
else print("WitherHub: Usage - ;speed me [value]") end
elseif cmd == "jump" or cmd == "jumppower" then
local tPN = ags[1]; local jV = tonumber(ags[2])
if tPN == "me" and jV and lH then lH.JumpPower = jV; lH.UseJumpPower = true; print("WitherHub: JumpPower set to " .. jV)
if mainG and mainG.MainFrame and mainG.MainFrame.ContentFrame then local jI = mainG.MainFrame.ContentFrame.JumpInput; if jI then jI.Text = tostring(jV) end end
else print("WitherHub: Usage - ;jump me [value]") end
elseif cmd == "god" or cmd == "godme" then
if not gEn then fnTGM() end
elseif cmd == "ungod" or cmd == "ungodme" then
if gEn then fnTGM() end
elseif cmd == "noclip" then fnTNC()
elseif cmd == "fly" then fnTF()
elseif cmd == "rejoin" or cmd == "rj" then
print("WitherHub: Rejoining...")
local TS = game:GetService("TeleportService"); TS:Teleport(game.PlaceId, lP)
elseif cmd == "gui" or cmd == "togglegui" then
if mainG and mainG.MainFrame then mainG.MainFrame.Visible = not mainG.MainFrame.Visible end
elseif cmd == "cmds" or cmd == "commands" or cmd == "help" then
print("WitherHub Commands (" .. cmdPre .. "): speed me [val], jump me [val], god, ungod, noclip, fly, rejoin, gui")
else print("WitherHub: Unknown command '" .. cmd .. "'. Type " .. cmdPre .. "cmds for help.") end
end
lP.Chatted:Connect(function(msg)
if not fnIW(lP.Name) then return end
msg = string.lower(msg)
if string.sub(msg, 1, string.len(cmdPre)) == cmdPre then
local cmdS = string.sub(msg, string.len(cmdPre) + 1)
fnPCmd(cmdS)
end
end)
lP.CharacterAdded:Connect(function(nC)
lC = nC; lH = nC:WaitForChild("Humanoid")
print("WitherHub: New character loaded for LocalPlayer.")
if ncBtn then fnUBS(ncBtn, "Noclip", ncEn) end
if ncEn then if ncCon then ncCon:Disconnect(); ncCon = nil; end local wE = ncEn; ncEn = false; fnTNC(); if not wE then fnTNC() end end
if fBtn then fnUBS(fBtn, "Fly", fEn) end
if fEn then if fCon then fCon:Disconnect(); fCon = nil; end local wE = fEn; fEn = false; fnTF(); if not wE then fnTF() end end
if gBtn then fnUBS(gBtn, "God Mode", gEn) end
if gEn and lH then lH.MaxHealth = math.huge; lH.Health = math.huge
elseif not gEn and lH then lH.MaxHealth = 100; lH.Health = 100 end
if mainG and mainG.MainFrame and mainG.MainFrame.ContentFrame then
local sI = mainG.MainFrame.ContentFrame:FindFirstChild("SpeedInput"); if sI and lH then sI.Text = tostring(lH.WalkSpeed) end
local jI = mainG.MainFrame.ContentFrame:FindFirstChild("JumpInput"); if jI and lH then jI.Text = tostring(lH.JumpPower) end
end
end)
if not fnIW(lP.Name) then
lP:Kick("You are not whitelisted for WitherHub.")
else
print("WitherHub: Welcome, " .. lP.Name)
fnCGUI()
if ncBtn then fnUBS(ncBtn, "Noclip", ncEn) end
if fBtn then fnUBS(fBtn, "Fly", fEn) end
if gBtn then fnUBS(gBtn, "God Mode", gEn) end
end
print("WitherHub Script Loaded. Type " .. cmdPre .. "cmds for commands or use the GUI if whitelisted.")
