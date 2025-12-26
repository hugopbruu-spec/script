-----------------------------------------------------
-- ❄️ FrostBR | Plants vs Brainrots
-- UI Profissional | Preto & Roxo | Arrastável
-----------------------------------------------------

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-----------------------------------------------------
-- CONFIG
-----------------------------------------------------

local Config = {
    Interval = 1.2,

    Theme = {
        BG = Color3.fromRGB(12, 12, 18),
        Panel = Color3.fromRGB(20, 20, 30),
        Button = Color3.fromRGB(35, 35, 50),
        ButtonOn = Color3.fromRGB(140, 70, 255),
        Accent = Color3.fromRGB(170, 80, 255),
        Text = Color3.fromRGB(255,255,255),
        SubText = Color3.fromRGB(180,180,180)
    },

    Font = Enum.Font.GothamBold,
    PlantName = "Peashooter"
}

-----------------------------------------------------
-- STATE
-----------------------------------------------------

local State = {
    AutoPlant = false,
    AutoBuy = false,
    AutoCollect = false,
    AutoClaim = false
}

-----------------------------------------------------
-- UTILS
-----------------------------------------------------

local function Tween(obj, time, props)
    TweenService:Create(
        obj,
        TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

local function Log(msg)
    print("[FrostBR] "..msg)
end

-----------------------------------------------------
-- GAME LOGIC (ADAPTÁVEL)
-----------------------------------------------------

local Game = {}

function Game:GetFreeTile()
    local tiles = workspace:FindFirstChild("Tiles")
    if not tiles then return end

    for _, tile in ipairs(tiles:GetChildren()) do
        if tile:FindFirstChild("Occupied") and tile.Occupied.Value == false then
            return tile
        end
    end
end

function Game:Plant(tile)
    if not tile then return end
    -- 🔴 COLOQUE O REMOTE REAL AQUI
    -- ReplicatedStorage.Remotes.Plant:FireServer(tile, Config.PlantName)
    Log("Plantando em "..tile.Name)
end

function Game:Buy()
    -- 🔴 REMOTE REAL
    Log("Comprando planta")
end

function Game:Collect()
    -- 🔴 REMOTE REAL
    Log("Coletando dinheiro")
end

function Game:Claim()
    -- 🔴 REMOTE REAL
    Log("Resgatando recompensa")
end

-----------------------------------------------------
-- MAIN LOOP (SEGURO)
-----------------------------------------------------

task.spawn(function()
    while task.wait(Config.Interval) do
        if State.AutoPlant then
            Game:Plant(Game:GetFreeTile())
        end
        if State.AutoBuy then
            Game:Buy()
        end
        if State.AutoCollect then
            Game:Collect()
        end
        if State.AutoClaim then
            Game:Claim()
        end
    end
end)

-----------------------------------------------------
-- UI BASE
-----------------------------------------------------

local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "FrostBR_UI"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(0,0)
Main.Position = UDim2.fromScale(0.32,0.25)
Main.BackgroundColor3 = Config.Theme.BG
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

-----------------------------------------------------
-- DRAG SYSTEM
-----------------------------------------------------

local dragging, dragStart, startPos

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-----------------------------------------------------
-- HEADER
-----------------------------------------------------

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundColor3 = Config.Theme.Panel
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,18)

local Icon = Instance.new("Frame", Header)
Icon.Size = UDim2.fromOffset(36,36)
Icon.Position = UDim2.new(0,15,0.5,-18)
Icon.BackgroundColor3 = Config.Theme.Accent
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)

local Title = Instance.new("TextLabel", Header)
Title.Position = UDim2.new(0,65,0,10)
Title.Size = UDim2.new(1,-70,0,25)
Title.Text = "FrostBR"
Title.Font = Config.Font
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Config.Theme.Text
Title.BackgroundTransparency = 1

local Sub = Instance.new("TextLabel", Header)
Sub.Position = UDim2.new(0,65,0,32)
Sub.Size = UDim2.new(1,-70,0,18)
Sub.Text = "Plants vs Brainrots"
Sub.Font = Enum.Font.Gotham
Sub.TextScaled = true
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.TextColor3 = Config.Theme.SubText
Sub.BackgroundTransparency = 1

-----------------------------------------------------
-- BUTTON CREATOR (PRO)
-----------------------------------------------------

local function CreateToggle(text, y, stateKey)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(1,-40,0,46)
    btn.Position = UDim2.new(0,20,0,y)
    btn.BackgroundColor3 = Config.Theme.Button
    btn.Text = text.." : OFF"
    btn.Font = Config.Font
    btn.TextScaled = true
    btn.TextColor3 = Config.Theme.Text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

    btn.MouseEnter:Connect(function()
        Tween(btn,0.15,{BackgroundColor3 = Config.Theme.ButtonOn})
    end)

    btn.MouseLeave:Connect(function()
        if not State[stateKey] then
            Tween(btn,0.15,{BackgroundColor3 = Config.Theme.Button})
        end
    end)

    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        btn.Text = text.." : "..(State[stateKey] and "ON" or "OFF")
        Tween(btn,0.2,{
            BackgroundColor3 = State[stateKey] and Config.Theme.ButtonOn or Config.Theme.Button
        })
        Log(text.." = "..tostring(State[stateKey]))
    end)

    return btn
end

-----------------------------------------------------
-- BUTTONS
-----------------------------------------------------

CreateToggle("Auto Plant", 90, "AutoPlant")
CreateToggle("Auto Buy Plant", 150, "AutoBuy")
CreateToggle("Auto Collect", 210, "AutoCollect")
CreateToggle("Auto Claim", 270, "AutoClaim")

-----------------------------------------------------
-- OPEN ANIMATION
-----------------------------------------------------

task.wait(0.1)
Tween(Main,0.6,{Size = UDim2.fromOffset(460,560)})
Log("FrostBR carregado com sucesso")
