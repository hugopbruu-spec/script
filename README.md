-- LocalScript em StarterPlayerScripts
-- Detecta e repele imediatamente qualquer parte chamada "PhantomBall" enquanto o botão está ativo.
-- Ajuste `range`, `baseReboundForce` e `velMultiplier` conforme necessidade.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

-- aguarda character existir / root
local function getRoot()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local root = getRoot()

-- Configurações (ajuste aqui)
local range = 22                -- alcance de detecção (studs)
local baseReboundForce = 180    -- força mínima de rebote
local velMultiplier = 1.25      -- multiplicador por velocidade atual da bola
local minReboundSpeed = 60      -- velocidade mínima a ser aplicada (evita que fique "presa")
local maxReboundSpeed = 3000    -- teto da velocidade aplicada

local enabled = false

-- GUI simples
local gui = Instance.new("ScreenGui")
gui.Name = "RebateGui"
gui.ResetOnSpawn = false
gui.Parent = guiParent

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 44)
button.Position = UDim2.new(0.05, 0, 0.08, 0)
button.Text = "Ativar Rebater"
button.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.Parent = gui

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 200, 0, 22)
status.Position = UDim2.new(0.05, 0, 0.08, 48)
status.Text = "Estado: Desativado"
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255,255,255)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = gui

button.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		button.Text = "Desativar Rebater"
		button.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
		status.Text = "Estado: Ativado"
	else
		button.Text = "Ativar Rebater"
		button.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
		status.Text = "Estado: Desativado"
	end
end)

-- função que aplica rebote imediato
local function repelBall(ball, rootPos)
	if not (ball and ball:IsA("BasePart")) then return end
	-- segurança: pegar velocidade atual (AssemblyLinearVelocity em física moderna)
	local currentVel = Vector3.new(0,0,0)
	pcall(function()
		currentVel = ball.AssemblyLinearVelocity or ball.Velocity or Vector3.new(0,0,0)
	end)
	local speed = currentVel.Magnitude

	-- calcula direção do repulse: do jogador para fora (bola é empurrada para longe do jogador)
	local dir
	if (ball.Position - rootPos).Magnitude > 0.001 then
		dir = (ball.Position - rootPos).Unit
	else
		-- se ocorrer igualdade de posição (caso raro), escolhe direção aleatória
		dir = Vector3.new(math.random()-0.5, 0.2, math.random()-0.5).Unit
	end

	-- quanto mais rápida a bola, maior a força aplicada
	local desiredSpeed = baseReboundForce + (speed * velMultiplier)
	-- garantir limites
	if desiredSpeed < minReboundSpeed then desiredSpeed = minReboundSpeed end
	if desiredSpeed > maxReboundSpeed then desiredSpeed = maxReboundSpeed end

	-- aplica instantaneamente nova velocidade para afastar a bola
	-- usando pcall para evitar erros caso propriedade seja inacessível
	pcall(function()
		ball.AssemblyLinearVelocity = dir * desiredSpeed
	end)
end

-- Checagem por frame — aplica repel enquanto dentro do alcance
RunService.Heartbeat:Connect(function()
	if not enabled then return end
	-- refresca root caso respawn
	if not root or not root.Parent then
		root = getRoot()
		return
	end

	-- obter partes no raio (mais eficiente que iterar todo workspace)
	local partsInRange = workspace:GetPartBoundsInRadius(root.Position, range)
	if #partsInRange == 0 then return end

	for _, part in ipairs(partsInRange) do
		if part and part:IsA("BasePart") and part.Name == "PhantomBall" then
			-- Se a bola estiver no alcance, repele imediatamente e continuará a aplicar em cada frame
			repelBall(part, root.Position)
		end
	end
end)
