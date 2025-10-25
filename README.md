-- KillAura.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- CONFIGURAÇÕES
local ALCANCE = 25 -- distância de ativação
local DELAY_BASE = 0.3
local VELOCIDADE_REF = 120
local DELAY_MIN = 0.05

local killAuraAtivo = false

-- GUI para ativar/desativar Kill Aura
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillAuraGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(255,0,0)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24
button.Text = "KillAura: DESATIVADO"
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
	killAuraAtivo = not killAuraAtivo
	if killAuraAtivo then
		button.Text = "KillAura: ATIVADO"
		button.BackgroundColor3 = Color3.fromRGB(0,255,0)
	else
		button.Text = "KillAura: DESATIVADO"
		button.BackgroundColor3 = Color3.fromRGB(255,0,0)
	end
end)

-- Função de ataque/click
local function atacarAlvo(alvo)
	-- Aqui você coloca a lógica real de click/ataque
	print("⚔️ Atacando alvo: "..alvo.Name)
	-- Exemplo usando RemoteEvent
	local eventoAtaque = game.ReplicatedStorage:FindFirstChild("AtaqueEvento")
	if eventoAtaque then
		eventoAtaque:FireServer(alvo)
	end
end

-- Loop principal
RunService.Heartbeat:Connect(function()
	if killAuraAtivo and char and char:FindFirstChild("HumanoidRootPart") then
		local root = char.HumanoidRootPart
		for _, obj in ipairs(workspace:GetChildren()) do
			-- Ignora o próprio jogador
			if obj ~= char and obj:IsA("BasePart") then
				local distancia = (obj.Position - root.Position).Magnitude
				if distancia <= ALCANCE then
					-- Calcula a velocidade do objeto
					local velocidade = obj.AssemblyLinearVelocity.Magnitude
					if velocidade == 0 then
						velocidade = obj.Velocity.Magnitude
					end

					-- Calcula o delay baseado na velocidade (quanto mais rápido, menor o delay)
					local fator = math.clamp(VELOCIDADE_REF / math.max(velocidade,1),0.1,1)
					local delayReacao = math.max(DELAY_BASE * fator, DELAY_MIN)

					task.delay(delayReacao, function()
						atacarAlvo(obj)
					end)
				end
			end
		end
	end
end)
