# DEVLOG

Comecei atrasado: meu primeiro commit é de 27/10 e as aulas 09 a 12 acabaram entrando juntas em novembro. Em cada aula coloquei o prazo e a data real do commit, sem mexer em nenhuma data.

Usei o OpenAI Codex como auxílio nos scripts, principalmente na máquina de estados do jogador (está indicado no topo de cada arquivo). Os sprites foram gerados no PixelLab Creator.

## Aula 08 — 07/10 (commit em 27/10, `04b5ff0`)

O que fiz: a arena do deserto vista de cima, com muro, pedras, cactos e colisão, e o explorador andando nas quatro direções.
O que travou: o sprite do personagem girava inteiro para mostrar a direção, então ele ficava de cabeça para baixo andando para cima.
Como resolvi: tirei a rotação do código e passei a usar uma folha de sprites com uma animação para cada direção (ajuste de 04/11).

## Aula 09 — 21/10 (commit em 11/11, `5d3af95`)

O que fiz: vida, dano, ataque, contador de abates na HUD, vitória nos 50 escorpiões e derrota quando a vida acaba.
O que travou: encostando no escorpião a vida caía várias vezes de uma vez. E o primeiro ataque com Espaço só pegava o escorpião bem na frente, era difícil acertar.
Como resolvi: coloquei um tempo de invulnerabilidade depois de levar dano. Depois troquei o ataque por tiro mirado com o mouse, e cada escorpião aguenta três tiros.

## Aula 10 — 28/10 (commit em 11/11, `5d3af95`, junto com a aula 09)

O que fiz: o escorpião com máquina de estados (entrando, perseguindo, atacando, ferido, eliminado) e desviando de obstáculo com `test_move`.
O que travou: o explorador passava por cima da água do oásis, e os escorpiões nasciam em volta do jogador, às vezes do lado dele, e não pela borda.
Como resolvi: coloquei um `StaticBody2D` em cima da água e mudei o surgimento para um ponto sorteado no contorno da arena, sorteando de novo se cair a menos de 220 do jogador.

## Aula 11 — 04/11 (commit em 17/11, `a9813ba`)

O que fiz: troquei os retângulos pela arte do tema: explorador parado e correndo, escorpião nas quatro direções, mapa com oásis e o dardo de areia. Explorador, escorpião, mapa e obstáculos são do PixelLab; o dardo e o kit médico são SVG feitos com ajuda do Codex; areia, pedras e cactos são do pacote Desert Shooter da Kenney (CC0).
O que travou: a câmera seguia o jogador com zoom 2 e não dava para ver a arena inteira nem os escorpiões chegando. O dardo também ficou grande demais perto da colisão dele.
Como resolvi: tirei a câmera do jogador e deixei uma câmera fixa no centro da arena com zoom 1, e diminuí a escala do dardo. A horda vai até 10 escorpiões vivos ao mesmo tempo sem travar.

## Aula 12 — 11/11 (commits em 17 e 18/11, `fbfe5d5` e `baeeaed`)

O que fiz: exportei para Web e publiquei no GitHub Pages: https://enzosqs.github.io/areia-hostil-abate/
O que travou: não exportava porque faltava o template Web da Godot 4.7.1, e no GitHub Pages a versão com threads não abre, porque ele não manda os cabeçalhos que ela precisa.
Como resolvi: instalei o template e usei o preset Web sem threads, exportando para a pasta `docs/`, que é a que o Pages publica.

## Aula 13 — 18/11

Dia da apresentação em sala.

## Ajustes depois da entrega — 26/11

- Reescrevi o DEVLOG no formato pedido (o que fiz, o que travou, como resolvi).
- Coloquei no topo de cada script o que ele faz e onde tive ajuda de IA, como o professor pediu no aviso de 19/11.
- Tirei do repositório meus arquivos de planejamento, o plugin de integração com IA (`addons/godot_mcp_bridge`) e a cena `scenes/hud.tscn`, que não era usada (a HUD é montada pelo `hud.gd`).
- Tirei uma seção `[input]` repetida do `project.godot`.
- Criei as tags `aula-08` a `aula-12` apontando para os commits de cada etapa. As datas dos commits continuam as reais, e a mensagem de cada tag diz quando o conteúdo entrou.
- Exportei o jogo de novo para `docs/` depois da limpeza, para o pacote publicado não levar mais o plugin.
