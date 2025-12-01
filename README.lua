-- Variáveis
local nome = "Jogador"
local nivel = 10
local vida = 100
local ataque = 20

-- Tabela para armazenar informações do inventário
local inventario = {
  "Espada",
  "Poção de cura",
  "Escudo"
}

-- Função para calcular o dano
local function calcularDano(ataque, defesa)
  local dano = ataque - defesa
  if dano < 0 then
    dano = 0
  end
  return dano
end

-- Função para atacar um inimigo
local function atacarInimigo(inimigo)
  local defesaInimigo = inimigo.defesa
  local dano = calcularDano(ataque, defesaInimigo)
  inimigo.vida = inimigo.vida - dano

  print(nome .. " ataca " .. inimigo.nome .. " e causa " .. dano .. " de dano.")

  if inimigo.vida <= 0 then
    print(inimigo.nome .. " foi derrotado!")
  end
end

-- Criar um inimigo
local inimigo = {
  nome = "Goblin",
  vida = 50,
  defesa = 5
}

-- Loop para simular um combate
while inimigo.vida > 0 do
  atacarInimigo(inimigo)
end

-- Imprimir o inventário
print("Inventário:")
for i, item in ipairs(inventario) do
  print(i .. ": " .. item)
end

-- Exemplo de condicional
if nivel >= 10 then
  print(nome .. " atingiu o nível 10 e pode usar habilidades especiais!")
end
