--[[
    Nome do Arquivo: Orca/views/Dashboard/ItemAnalyzer.lua
    Descrição: Componente Roact para a interface de análise de itens.
--]]
local a = require(script.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked
local aN = a.import(script,script.Parent.Parent.include.RuntimeLib)
local aM=a.import(script,script.Parent.Parent.Parent,"hooks","common","rodux-hooks")
local aN=aM.useAppDispatch;
local p = aM.useAppSelector;
local UserInputService = game:GetService("UserInputService")

local ar = a.import(script, script.Parent.Parent.include.RuntimeLib)
local createItemAnalysisCard = i(function(props)
    local dispatch = aN()

    -- Estados do Redux
    local itemName = p(function(state) return state.itemAnalysis.itemName end)
    local itemInfo = p(function(state) return state.itemAnalysis.itemInfo end)
    local isAnalyzing = p(function(state) return state.itemAnalysis.isAnalyzing end)

    local function analyzeItem()
        dispatch({type = "itemAnalysis/startAnalysis"}) -- Dispara a action para iniciar a análise
    end

    local function copyItemInfo()
        UserInputService.Clipboard = itemInfo or "" -- Copia o texto para a área de transferência
    end

    return b.createElement("Frame", {
        Size = UDim2.new(0.9, 0, 0.8, 0),
        Position = UDim2.new(0.05, 0, 0.1, 0),
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        BorderColor3 = Color3.new(0,0,0),
    }, {
        b.createElement("TextLabel", {
            Size = UDim2.new(1, 0, 0.1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.new(0,0,0),
            TextColor3 = Color3.new(1,1,1),
            Text = "Item Analyzer",
            Font = Enum.Font.SourceSansBold,
            TextSize = 20,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            BorderSizePixel = 0,
        }),
        b.createElement("TextBox", {
            Size = UDim2.new(0.65, 0, 0.6, 0),
            Position = UDim2.new(0.05, 0, 0.1, 0),
            BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
            TextColor3 = Color3.new(0.9, 0.9, 0.9),
            Font = Enum.Font.SourceSans,
            TextSize = 12,
            Text = itemInfo or "Aperte 'Analisar' para começar...",
            MultiLine = true,
            ReadOnly = true,
            ScrollBarThickness = 3,
        }),
        b.createElement("TextButton", {
            Size = UDim2.new(0.25, 0, 0.25, 0),
            Position = UDim2.new(0.7, 0, 0.1, 0),
            BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
            TextColor3 = Color3.new(1,1,1),
            Text = isAnalyzing and "Analisando..." or "Analisar",
            Font = Enum.Font.SourceSansBold,
            TextSize = 14,
            [b.Event.Activated] = analyzeItem,
            Active = not isAnalyzing, -- Desativa o botão durante a análise
            BorderSizePixel = 0,
        }),
        b.createElement("TextButton", {
            Size = UDim2.new(0.25, 0, 0.25, 0),
            Position = UDim2.new(0.7, 0, 0.4, 0),
            BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
            TextColor3 = Color3.new(1,1,1),
            Text = "Copiar",
            Font = Enum.Font.SourceSansBold,
            TextSize = 14,
            [b.Event.Activated] = copyItemInfo,
            Visible = itemInfo ~= nil, -- Torna visível apenas quando há informações
            BorderSizePixel = 0,
        })
    })
end

return {default = createItemAnalysisCard}

--[[
    Nome do Arquivo: Orca/store/reducers/itemAnalysisReducer.lua
    Descrição: Reducer para o estado de análise de itens.
--]]
local it = require(script.Parent.Parent.include.RuntimeLib)

local initialState = {
    itemName = nil,
    itemInfo = nil,
    isAnalyzing = false
}

local itemAnalysisReducer = it.createReducer(initialState, {
    ["itemAnalysis/startAnalysis"] = function(state, action)
        return {
            itemName = nil,
            itemInfo = "Analisando...",
            isAnalyzing = true
        }
    end,
    ["itemAnalysis/setItemInfo"] = function(state, action)
        return {
            itemName = action.itemName,
            itemInfo = action.itemInfo,
            isAnalyzing = false
        }
    end
})

return {itemAnalysisReducer = itemAnalysisReducer}

--[[
    Nome do Arquivo: Orca/jobs/itemAnalysisJob.lua
    Descrição: Job para executar a análise do item.
--]]
local a = require(script.Parent.Parent.include.RuntimeLib)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local aN = a.import(script,script.Parent.Parent,"helpers","job-store").onJobChange;
local aD = a.import(script,script.Parent.Parent,"hooks","common","rodux-hooks").useAppDispatch
local setItemInfo = a.import(script,script.Parent.Parent.store.actions.itemAnalysisActions).setItemInfo

local function getEquippedItem()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            -- Tenta encontrar o item equipado na RightHand ou LeftHand
            local rightHand = character:FindFirstChild("RightHand")
            local leftHand = character:FindFirstChild("LeftHand")
            if rightHand and rightHand.Tool then
                return rightHand.Tool
            elseif leftHand and leftHand.Tool then
                return leftHand.Tool
            else
                -- Se não encontrar na mão, tenta encontrar na Backpack (mochila)
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") then
                            return item
                        end
                    end
                end
                return nil
            end
        else
            warn("Humanoid não encontrado no Character")
            return nil
        end
    else
        warn("Character não encontrado para o Player")
        return nil
    end
end

local function analyzeItem()
    local item = getEquippedItem()
    if not item then
        return "Nenhum item equipado."
    end

    local reportText = "Informações do Item:\n"
    reportText = reportText .. "Nome: " .. item.Name .. "\n"

    -- Adicione mais informações conforme necessário
    for key, value in pairs(item:GetProperties()) do
        reportText = reportText .. key .. ": " .. tostring(value) .. "\n"
    end

    return reportText
end

local function startJob()
    local itemInfo = analyzeItem()
    aN({type = "itemAnalysis/setItemInfo", itemName = "Analisando", itemInfo = itemInfo})
end

-- Inicie o monitoramento para o item
aN("itemAnalysis/startAnalysis",startJob)

--[[
    Nome do Arquivo: Orca/views/Dashboard/Dashboard.lua
    Descrição: Integração do componente ItemAnalyzer ao Dashboard.
--]]
local a = require(script.Parent.Parent.include.RuntimeLib)
local b = a.import(script, a.getModule(script, "@rbxts", "roact").src)
local h = a.import(script, a.getModule(script, "@rbxts", "roact-hooked").out)
local i = h.hooked

local ar = a.import(script, script.Parent.Parent.include.RuntimeLib)
local ItemAnalyzer = require(script.Parent.ItemAnalyzer)

local aa = a.import(script, script.Parent.Parent.include.RuntimeLib)
local createDashboardView = i(function(props)

	return b.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.new(0,0,0)
}, {
  b.createElement(ItemAnalyzer.default), -- Adiciona o componente
})
end)

return {default = createDashboardView}
