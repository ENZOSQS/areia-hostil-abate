# Areia Hostil: Abate

Jogo 2D de arena vista de cima, criado por Enzo Rafael para Jogos Digitais II.

## Carta do projeto

- Tema: deserto com escorpiões de areia.
- Tipo: Abate — vencer ao derrotar 50 inimigos.
- Modo: horda em arena vista de cima.

## Como jogar

- Mova-se com **WASD** ou as **setas**.
- Mire com o mouse e segure o **botão esquerdo** ou **Espaço** para disparar.
- Sobreviva à horda e derrote **50 escorpiões**. Kits médicos podem restaurar vida.
- Ao terminar, use **R** ou o botão na tela para reiniciar.

O projeto contém a arena editável no Godot, explorador animado em quatro direções, escorpiões com estados de movimento e dano, dardos de areia incandescente, itens de cura, horda progressiva, HUD e finais de vitória e derrota. As animações do explorador são montadas em oito sequências de quatro quadros no recurso SpriteFrames da cena, para edição no painel de animações do Godot.

## Organização

- `scenes/main.tscn`: mapa e arena editáveis.
- `entities/`: cenas independentes do jogador, inimigos, projéteis e itens.
- `scripts/`: lógica e máquinas de estado do jogo.
- `assets/custom/`: sprites pixel art e ícones feitos para o projeto.

## Origem

O código desta etapa foi feito com assistência de IA (OpenAI Codex), identificada por comentário nos scripts. Os sprites externos estão identificados e licenciados em `assets/kenney_desert_shooter/LICENSE.txt`.

## Sprites do deserto

O projeto inclui sprites selecionados do **Desert Shooter Pack**, de Kenney, para areia, árvores, cactos, pedras e personagem. O mapa foi montado na cena com nós posicionados e ajustáveis no editor; nenhum script instancia ou desenha os objetos do cenário. O pacote é CC0. A licença e os links da fonte estão em `assets/kenney_desert_shooter/LICENSE.txt`.
