-- Variáveis de controle
local autoDefesaAtivada = false
local personagem = getPersonagem()  -- Função fictícia para obter o personagem

-- Função para alternar a auto defesa
function alternarAutoDefesa()
    if autoDefesaAtivada then
        autoDefesaAtivada = false
        print("Auto defesa desativada.")
    else
        autoDefesaAtivada = true
        print("Auto defesa ativada.")
    end
end

-- Função para detectar ataques inimigos (simplificada)
function detectarAtaquesInimigos()
    -- Aqui você colocaria a lógica de detecção de ataque, como colisões com projéteis ou inimigos
    -- Vamos simular com uma condição de exemplo:
    local ataqueDetectado = verificarAtaque()  -- Função fictícia para verificar ataques

    if autoDefesaAtivada and ataqueDetectado then
        executarDefesa()  -- Função fictícia para realizar defesa
    end
end

-- Função de defesa (simulação)
function executarDefesa()
    print("Defesa ativada: Personagem executando ação de defesa.")
    -- Aqui você pode adicionar a lógica de defesa, como desviar ou bloquear ataques
    personagem.bloquearAtaque()  -- Função fictícia para bloquear ataques
end

-- Função para verificar se um ataque foi detectado
function verificarAtaque()
    -- Lógica para verificar se um inimigo está atacando, como colisões ou proximidade
    -- Para este exemplo, vamos simplesmente retornar verdadeiro para simular um ataque
    return true
end

-- Função principal que é chamada em cada atualização do jogo (Loop)
function atualizarJogo()
    -- Atualiza o estado do jogo, por exemplo, a posição do personagem
    detectarAtaquesInimigos()  -- Chama a função que verifica os ataques e ativa a defesa se necessário
end

-- Exemplo de como ativar e desativar a auto defesa durante o jogo
function teclaAtalho()
    -- A função que é chamada quando o jogador pressiona uma tecla para alternar a auto defesa
    alternarAutoDefesa()
end

-- Simulação de pressionar a tecla de atalho para alternar
teclaAtalho()  -- Ativa a auto defesa
atualizarJogo()  -- Atualiza o jogo para realizar a defesa
teclaAtalho()  -- Desativa a auto defesa
atualizarJogo()  -- Atualiza o jogo novamente sem a defesa
