# DEVLOG

## Etapa 1 — mapa e personagem — preparado em 27/10/2026 para a aula de 28/10/2026

- O que fiz: criei a arena de deserto vista de cima e um explorador que anda em quatro direções, com câmera e colisões.
- O mapa é montado com nós Sprite2D, Line2D, Polygon2D e colisões estáticas, posicionados diretamente na cena para edição manual no Godot.
- Para controlar o personagem, execute o projeto e use WASD ou as setas.
- Assistência: código criado com ajuda de IA; vou estudar as funções antes da apresentação.

## Personagem — máquina de estados e animação — 11/11/2026

- No PixelLab Creator, gerei uma folha de sprites PNG transparente de 4 × 4 quadros para a caminhada do explorador nas quatro direções.
- Na cena `entities/player.tscn`, converti o nó para `AnimatedSprite2D` e, no painel `SpriteFrames`, usei “Adicionar quadros de uma folha de sprites” para definir a grade de 4 colunas × 4 linhas e selecionar manualmente as células de cada direção. As animações resultantes são `walk_down`, `walk_left`, `walk_right` e `walk_up`, com escala uniforme `0,5`.
- Mantive o `CollisionShape2D` circular já existente, centralizado no personagem, com raio 11; a forma e o posicionamento ficam editáveis na cena.
- No script `scripts/player.gd`, organizei os estados `IDLE` e `WALKING`. O código escolhe a animação nomeada pela direção e chama `play()`; os recortes, quadros e velocidade ficam salvos como recurso `SpriteFrames` da cena, sem cálculo ou rotação do sprite no código.
- Controles: WASD ou setas. Velocidade padrão: 220.
- Para revisar no Godot: abrir `entities/player.tscn`, selecionar `Sprite2D` e `CollisionShape2D` na árvore da cena e abrir `scripts/player.gd` na aba Script.

## Etapa — escorpiões, combate e HUD — 11/11/2026

- Ajustei a velocidade do explorador para 175 unidades/s, mais controlável para a arena, e aproximei a câmera em 10% (zoom 2,2), mantendo o seguimento suave.
- No PixelLab Creator, gerei `scorpion_walk_4dir.png`: folha pixel art transparente com 4 × 4 quadros e quatro direções. O arquivo foi copiado para `assets/kenney_desert_shooter/tiles/`.
- A cena `entities/scorpion.tscn` contém um `AnimatedSprite2D` com animações direcionais a 8 FPS, corpo com colisão circular e uma `Area2D` para detectar contato com o explorador.
- Os 50 escorpiões perseguem o jogador pela arena. O contato reduz 10 pontos de vida, com intervalo entre danos para evitar várias perdas no mesmo instante.
- A ação Espaço elimina o escorpião próximo à frente do explorador. O contador da HUD acompanha as eliminações até 50.
- A HUD fica no canto superior esquerdo da tela, fora da câmera do mundo, com barra e números de vida, contador de escorpiões e instrução dos controles.
- Controles: WASD/setas para mover; Espaço para atacar.
