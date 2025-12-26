-----------------------------------------------------
-- SERVICES
-----------------------------------------------------

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
        Background = Color3.fromRGB(15, 15, 20),
        Accent = Color3.fromRGB(160, 70, 255),
        Button = Color3.fromRGB(30, 30, 40),
        ButtonOn = Color3.fromRGB(120, 60, 200),
        Text = Color3.fromRGB(255, 255, 255)
    },

    Font = Enum.Font.GothamBold,

    WindowSize = Vector2.new(420, 520),

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

local Utils = {}

function Utils:Tween(obj, t, props)
    TweenService:Create(
        obj,
        TweenInfo.new(t, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        props
    ):Play()
end

function Utils:Log(msg)
    print("[PVB AUTO] " .. msg)
end

-----------------------------------------------------
-- GAME FUNCTIONS
-----------------------------------------------------

local Game = {}

-- 🔹 Busca tiles livres
function Game:GetFreeTile()
    local tiles = workspace:FindFirstChild("Tiles")
    if not tiles then return nil end

    for _, tile in ipairs(tiles:GetChildren()) do
        if tile:FindFirstChild("Occupied")
        and tile.Occupied.Value == false then
            return tile
        end
    end
end

-- 🔹 Plantar
function Game:Plant(tile)
    if not tile then return end

    -- 🔴 REMOTE REAL AQUI
    -- ReplicatedStorage.Remotes.Plant:FireServer(tile, Config.PlantName)

    Utils:Log("Plantado em "..tile.Name)
end

-- 🔹 Comprar planta
function Game:BuyPlant()
    -- 🔴 REMOTE REAL AQUI
    -- ReplicatedStorage.Remotes.BuyPlant:FireServer(Config.PlantName)

    Utils:Log("Comprando planta "..Config.PlantName)
end

-- 🔹 Coletar dinheiro
function Game:Collect()
    -- 🔴 REMOTE REAL AQUI
    -- ReplicatedStorage.Remotes.Collect:FireServer()

    Utils:Log("Coletando dinheiro")
end

-- 🔹 Resgatar recompensa
function Game:Claim()
    -- 🔴 REMOTE REAL AQUI
    -- ReplicatedStorage.Remotes.Claim:FireServer()

    Utils:Log("Resgatando recompensa")
end

-----------------------------------------------------
-- MAIN LOOP (SEGURADO)
-----------------------------------------------------

task.spawn(function()
    while task.wait(Config.Interval) do
        if State.AutoPlant then
            Game:Plant(Game:GetFreeTile())
        end
        if State.AutoBuy then
            Game:BuyPlant()
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
-- UI
-----------------------------------------------------

local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "PVB_UI"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(0, 0)
Main.Position = UDim2.fromScale(0.32, 0.25)
Main.BackgroundColor3 = Config.Theme.Background
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

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
-- TITLE
-----------------------------------------------------

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.Text = "🌱 Plants vs Brainrots AUTO"
Title.Font = Config.Font
Title.TextScaled = true
Title.TextColor3 = Config.Theme.Accent
Title.BackgroundTransparency = 1

-----------------------------------------------------
-- BUTTON CREATOR
-----------------------------------------------------

local function CreateButton(text, y, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(1, -40, 0, 45)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.Text = text
    btn.Font = Config.Font
    btn.TextScaled = true
    btn.TextColor3 = Config.Theme.Text
    btn.BackgroundColor3 = Config.Theme.Button
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-----------------------------------------------------
-- BUTTONS
-----------------------------------------------------

local btnPlant = CreateButton("Auto Plant: OFF", 70, function()
    State.AutoPlant = not State.AutoPlant
    btnPlant.Text = "Auto Plant: "..(State.AutoPlant and "ON" or "OFF")
    btnPlant.BackgroundColor3 = State.AutoPlant and Config.Theme.ButtonOn or Config.Theme.Button
end)

local btnBuy = CreateButton("Auto Buy Plant: OFF", 130, function()
    State.AutoBuy = not State.AutoBuy
    btnBuy.Text = "Auto Buy Plant: "..(State.AutoBuy and "ON" or "OFF")
    btnBuy.BackgroundColor3 = State.AutoBuy and Config.Theme.ButtonOn or Config.Theme.Button
end)

local btnCollect = CreateButton("Auto Collect: OFF", 190, function()
    State.AutoCollect = not State.AutoCollect
    btnCollect.Text = "Auto Collect: "..(State.AutoCollect and "ON" or "OFF")
    btnCollect.BackgroundColor3 = State.AutoCollect and Config.Theme.ButtonOn or Config.Theme.Button
end)

local btnClaim = CreateButton("Auto Claim: OFF", 250, function()
    State.AutoClaim = not State.AutoClaim
    btnClaim.Text = "Auto Claim: "..(State.AutoClaim and "ON" or "OFF")
    btnClaim.BackgroundColor3 = State.AutoClaim and Config.Theme.ButtonOn or Config.Theme.Button
end)

-----------------------------------------------------
-- OPEN ANIMATION
-----------------------------------------------------

task.wait(0.1)
Utils:Tween(Main, 0.6, {
    Size = UDim2.fromOffset(Config.WindowSize.X, Config.WindowSize.Y)
})

Utils:Log("UI carregada com sucesso")
