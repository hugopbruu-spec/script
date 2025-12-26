-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-----------------------------------------------------
-- CONFIG
-----------------------------------------------------

local Config = {
    Interval = 1.5,

    Colors = {
        On = Color3.fromRGB(60, 200, 60),
        Off = Color3.fromRGB(200, 60, 60),
        BG = Color3.fromRGB(35, 35, 35),
        Button = Color3.fromRGB(70, 70, 70)
    },

    Font = Enum.Font.GothamBold,

    -- PLANTS VS BRAINROTS
    PlantName = "Peashooter", -- nome da planta
    AutoPlant = false,
    AutoBuyPlant = false,
    AutoCollect = false,
    AutoClaim = false,

    WindowSize = Vector2.new(300, 420)
}

-----------------------------------------------------
-- UTILS
-----------------------------------------------------

local Utils = {}

function Utils:Tween(obj, t, props)
    local tw = TweenService:Create(
        obj,
        TweenInfo.new(t, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        props
    )
    tw:Play()
end

function Utils:Log(msg)
    print("[PVB Auto] " .. msg)
end

-----------------------------------------------------
-- GAME LOGIC
-----------------------------------------------------

local Game = {}

-- Procura tiles disponíveis
function Game:GetFreeTile()
    local tilesFolder = workspace:FindFirstChild("Tiles")
    if not tilesFolder then return end

    for _, tile in ipairs(tilesFolder:GetChildren()) do
        if tile:FindFirstChild("Occupied") and tile.Occupied.Value == false then
            return tile
        end
    end
end

-- PLANTAR
function Game:Plant(tile)
    if not tile then return end

    -- 🔴 SUBSTITUA PELO REMOTE REAL
    -- ReplicatedStorage.Remotes.Plant:FireServer(tile, Config.PlantName)

    Utils:Log("Plantando em "..tile.Name)
end

-- COMPRAR PLANTA
function Game:BuyPlant()
    -- 🔴 SUBSTITUA PELO REMOTE REAL
    -- ReplicatedStorage.Remotes.BuyPlant:FireServer(Config.PlantName)

    Utils:Log("Comprando planta "..Config.PlantName)
end

-- COLETAR DINHEIRO
function Game:Collect()
    -- 🔴 SUBSTITUA PELO REMOTE REAL
    -- ReplicatedStorage.Remotes.CollectMoney:FireServer()

    Utils:Log("Coletando dinheiro")
end

-- RESGATAR RECOMPENSA
function Game:Claim()
    -- 🔴 SUBSTITUA PELO REMOTE REAL
    -- ReplicatedStorage.Remotes.ClaimReward:FireServer()

    Utils:Log("Resgatando recompensa")
end

-----------------------------------------------------
-- LOOPS
-----------------------------------------------------

task.spawn(function()
    while task.wait(Config.Interval) do
        if Config.AutoPlant then
            Game:Plant(Game:GetFreeTile())
        end

        if Config.AutoBuyPlant then
            Game:BuyPlant()
        end

        if Config.AutoCollect then
            Game:Collect()
        end

        if Config.AutoClaim then
            Game:Claim()
        end
    end
end)

-----------------------------------------------------
-- UI
-----------------------------------------------------

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "PVB_AutoUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Config.Colors.BG
Frame.BorderSizePixel = 0
Frame.Size = UDim2.fromOffset(0, 0)
Frame.Position = UDim2.fromScale(0.35, 0.3)

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local function Button(text, y, callback)
    local b = Instance.new("TextButton", Frame)
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = text
    b.Font = Config.Font
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Config.Colors.Off
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(callback)
    return b
end

-----------------------------------------------------
-- BUTTONS
-----------------------------------------------------

local btnPlant = Button("Auto Plant: OFF", 10, function()
    Config.AutoPlant = not Config.AutoPlant
    btnPlant.Text = "Auto Plant: "..(Config.AutoPlant and "ON" or "OFF")
    btnPlant.BackgroundColor3 = Config.AutoPlant and Config.Colors.On or Config.Colors.Off
end)

local btnBuy = Button("Auto Buy Plant: OFF", 52, function()
    Config.AutoBuyPlant = not Config.AutoBuyPlant
    btnBuy.Text = "Auto Buy Plant: "..(Config.AutoBuyPlant and "ON" or "OFF")
    btnBuy.BackgroundColor3 = Config.AutoBuyPlant and Config.Colors.On or Config.Colors.Off
end)

local btnCollect = Button("Auto Collect: OFF", 94, function()
    Config.AutoCollect = not Config.AutoCollect
    btnCollect.Text = "Auto Collect: "..(Config.AutoCollect and "ON" or "OFF")
    btnCollect.BackgroundColor3 = Config.AutoCollect and Config.Colors.On or Config.Colors.Off
end)

local btnClaim = Button("Auto Claim: OFF", 136, function()
    Config.AutoClaim = not Config.AutoClaim
    btnClaim.Text = "Auto Claim: "..(Config.AutoClaim and "ON" or "OFF")
    btnClaim.BackgroundColor3 = Config.AutoClaim and Config.Colors.On or Config.Colors.Off
end)

-----------------------------------------------------
-- OPEN ANIMATION
-----------------------------------------------------

task.wait(0.1)
Utils:Tween(Frame, 0.5, {
    Size = UDim2.fromOffset(Config.WindowSize.X, Config.WindowSize.Y)
})

Utils:Log("UI carregada")
