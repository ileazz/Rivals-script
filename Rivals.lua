 
local Players = game:GetService("Players")  
local RunService = game:GetService("RunService")  
local LocalPlayer = Players.LocalPlayer  
local Camera = workspace.CurrentCamera  


local ScreenGui = Instance.new("ScreenGui")  
ScreenGui.Parent = game.CoreGui  

local MainFrame = Instance.new("Frame")  
MainFrame.Size = UDim2.new(0, 300, 0, 200)  
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)  
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  
MainFrame.Active = true  
MainFrame.Draggable = true  
MainFrame.Parent = ScreenGui  

local Title = Instance.new("TextLabel")  
Title.Text = "Rivals Cheat (Drag Me)"  
Title.Size = UDim2.new(1, 0, 0, 30)  
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  
Title.TextColor3 = Color3.new(1, 1, 1)  
Title.Parent = MainFrame  

local ToggleButton = Instance.new("TextButton")  
ToggleButton.Text = "Minimize"  
ToggleButton.Size = UDim2.new(0, 80, 0, 25)  
ToggleButton.Position = UDim2.new(1, -85, 0, 5)  
ToggleButton.Parent = MainFrame  

local AimbotToggle = Instance.new("TextButton")  
AimbotToggle.Text = "Aimbot: OFF"  
AimbotToggle.Size = UDim2.new(0.8, 0, 0, 30)  
AimbotToggle.Position = UDim2.new(0.1, 0, 0.2, 0)  
AimbotToggle.Parent = MainFrame  

local ESPToggle = Instance.new("TextButton")  
ESPToggle.Text = "ESP: OFF"  
ESPToggle.Size = UDim2.new(0.8, 0, 0, 30)  
ESPToggle.Position = UDim2.new(0.1, 0, 0.4, 0)  
ESPToggle.Parent = MainFrame  


local AimbotActive = false  
local ESPActive = false  
local ESPBoxes = {}  
local TeamCheck = true 


local function IsEnemy(Player)  
    if not TeamCheck then return true end  
    if LocalPlayer.Team == nil or Player.Team == nil then return true end  
    return LocalPlayer.Team ~= Player.Team  
end  


local function GetClosestEnemy()  
    local MaxDist, Closest = math.huge, nil  
    for _, Player in pairs(Players:GetPlayers()) do  
        if Player ~= LocalPlayer and IsEnemy(Player) then  
            local Char = Player.Character  
            if Char and Char:FindFirstChild("HumanoidRootPart") then  
                local Dist = (Char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude  
                if Dist < MaxDist then  
                    MaxDist, Closest = Dist, Player  
                end  
            end  
        end  
    end  
    return Closest  
end  


local function UpdateESP()  
    for Player, Box in pairs(ESPBoxes) do  
        if not Players:FindFirstChild(Player.Name) or not IsEnemy(Player) then  
            Box:Destroy()  
            ESPBoxes[Player] = nil  
        end  
    end  

    for _, Player in pairs(Players:GetPlayers()) do  
        if Player ~= LocalPlayer and IsEnemy(Player) then  
            local Char = Player.Character  
            if Char and Char:FindFirstChild("HumanoidRootPart") then  
                if not ESPBoxes[Player] then  
                    local Box = Instance.new("BoxHandleAdornment")  
                    Box.Name = Player.Name .. "_ESP"  
                    Box.Size = Vector3.new(3, 6, 3)  
                    Box.Color3 = Color3.fromRGB(255, 0, 0)  
                    Box.Transparency = 0.5  
                    Box.AlwaysOnTop = true  
                    Box.Adornee = Char.HumanoidRootPart  
                    Box.Parent = Char.HumanoidRootPart  
                    ESPBoxes[Player] = Box  
                end  
            end  
        end  
    end  
end  


ToggleButton.MouseButton1Click:Connect(function()  
    MainFrame.Size = MainFrame.Size == UDim2.new(0, 300, 0, 200) and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 200)  
end)  

AimbotToggle.MouseButton1Click:Connect(function()  
    AimbotActive = not AimbotActive  
    AimbotToggle.Text = "Aimbot: " .. (AimbotActive and "ON" or "OFF")  
end)  

ESPToggle.MouseButton1Click:Connect(function()  
    ESPActive = not ESPActive  
    ESPToggle.Text = "ESP: " .. (ESPActive and "ON" or "OFF")  
    if not ESPActive then  
        for _, Box in pairs(ESPBoxes) do Box:Destroy() end  
        ESPBoxes = {}  
    end  
end)  


RunService.RenderStepped:Connect(function()  
    if AimbotActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then  
        local Target = GetClosestEnemy()  
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then  
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)  
        end  
    end  

    
    if ESPActive then  
        UpdateESP()  
    end  
end)  


ScreenGui.Destroying:Connect(function()  
    for _, Box in pairs(ESPBoxes) do Box:Destroy() end  
end)  