-- Variáveis Globais
local menuAtivo = false
local compraAutomaticaAtiva = false

-- Lista de sementes disponíveis (exemplo)
local sementesDisponiveis = {
    { nome = "Girassol", custo = 50, utilidade = "Produz sol" },
    { nome = "Disparervilha", custo = 100, utilidade = "Ataca zumbis" },
    { nome = "Batatamina", custo = 25, utilidade = "Explode ao contato" }
}

-- Função para criar o menu (substitua com a lógica real do jogo)
local function criarMenu()
    print("Menu:")
    print("1. Ativar/Desativar Compra Automática")
    print("2. Fechar Menu")
    menuAtivo = true
end

-- Função para lidar com a entrada do usuário no menu
local function lidarComEntradaMenu(opcao)
    if opcao == 1 then
        compraAutomaticaAtiva = not compraAutomaticaAtiva
        print("Compra Automática: " .. (compraAutomaticaAtiva and "Ativada" or "Desativada"))
    elseif opcao == 2 then
        menuAtivo = false
        print("Menu fechado.")
    else
        print("Opção inválida.")
    end
end

-- Função para comprar sementes automaticamente
local function compraAutomatica()
    if compraAutomaticaAtiva then
        -- Lógica para encontrar a semente mais barata (exemplo)
        local sementeParaComprar = nil
        local menorCusto = math.huge

        for i, semente in ipairs(sementesDisponiveis) do
            if semente.custo < menorCusto then
                menorCusto = semente.custo
                sementeParaComprar = semente
            end
        end

        -- Comprar a semente (substitua com a lógica real do jogo)
        if sementeParaComprar then
            print("Comprando: " .. sementeParaComprar.nome)
            -- Adicione aqui a lógica para comprar a semente no jogo
            -- Exemplo: game:comprarSemente(sementeParaComprar.nome)
        else
            print("Nenhuma semente disponível para comprar.")
        end
    end
end

-- Função principal (exemplo de loop do jogo)
local function loopDoJogo()
    while true do
        -- Simular entrada do usuário (para teste)
        print("Digite 'menu' para abrir o menu ou 'comprar' para compra automática:")
        local entrada = io.read()

        if entrada == "menu" then
            criarMenu()
        elseif entrada == "comprar" then
            compraAutomatica()
        elseif menuAtivo then
            local opcao = tonumber(entrada)
            if opcao then
                lidarComEntradaMenu(opcao)
            else
                print("Entrada inválida. Digite um número para escolher uma opção do menu.")
            end
        else
            print("Comando inválido.")
        end

        -- Adicione aqui a lógica principal do jogo
        -- Exemplo: game:atualizarEstado()
    end
end

-- Iniciar o loop do jogo
loopDoJogo()
