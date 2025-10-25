-- AutoBlockWithButton.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- CONFIGURAÇÕES
local DISTANCIA_ATIVAR = 25
local DELAY_BASE = 0.3
local VELOCIDADE_REF = 120
local DELAY_MIN = 0.05
local BALL_NAME = "Ball"

-- Variável de controle
local autoBlockAtivo = false

-- Função para ativar bloqueio
local function ativarBloqueio()
	if humanoid and humanoid.Health > 0 then
		print("🛡️ Bloqueio ativado automaticamente!")
		-- Se você usa RemoteEvent para bloquear
		ReplicatedStorage:WaitForChild("BloquearEvento"):FireServer()
	end
end

-- Função para encontrar a bola
local function getBall()
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == BALL_NAME then
			return obj
		end
	end
	return nil
end

-- Loop principal
task.spawn(function()
	while task.wait(0.05) do
		if autoBlockAtivo and char and char:FindFirstChild("HumanoidRootPart") then
			local ball = getBall()
			if ball then
				local root = char.HumanoidRootPart
				local distancia = (ball.Position - root.Position).Magnitude

				if distancia <= DISTANCIA_ATIVAR then
					local velocidade = ball.AssemblyLinearVelocity.Magnitude
					local fator = math.clamp(VELOCIDADE_REF / math.max(velocidade,1),0.1,1)
					local delayReacao = math.max(DELAY_BASE * fator, DELAY_MIN)

					task.delay(delayReacao, ativarBloqueio)
				end
			end
		end
	end
end)

-- ==============================
-- Criação do botão GUI
-- ==============================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoBlockGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24
button.Text = "AutoBlock: DESATIVADO"
button.Parent = screenGui

-- Alterna ativação/desativação ao clicar
button.MouseButton1Click:Connect(function()
	autoBlockAtivo = not autoBlockAtivo
	if autoBlockAtivo then
		button.Text = "AutoBlock: ATIVADO"
		button.BackgroundColor3 = Color3.fromRGB(0,255,0)
	else
		button.Text = "AutoBlock: DESATIVADO"
		button.BackgroundColor3 = Color3.fromRGB(255,0,0)
	end
end)
