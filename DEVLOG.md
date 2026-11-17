# DEVLOG

As datas abaixo distinguem o prazo de cada aula da data real que aparece no histórico Git. Não foram retrodatadas.

## Aula 08 — cenário e movimento — prazo 07/10

- O que entrou: arena de deserto fechada, colisões e movimento em quatro direções.
- Registro disponível: o primeiro commit do mapa e personagem é de 27/10 (`04b5ff0`), posterior ao prazo.
- Resultado: etapa funcional; a câmera foi recentrada em 17/11 para mostrar a arena inteira.

## Aula 09 — vida, dano e objetivo — prazo 21/10

- O que entrou: vida, dano, tiros, contador de abates, vitória em 50 e derrota por vida esgotada.
- Registro disponível: essas mudanças aparecem no commit de 11/11 (`5d3af95`), junto com outros itens.
- Resultado: o teste de gameplay verifica tiros, cura, contagem e finais de partida.

## Aula 10 — inimigo e obstáculos — prazo 28/10

- O que entrou: escorpiões perseguidores, estados de comportamento e tentativa de contornar obstáculos.
- Registro disponível: as mudanças de combate e inimigos foram registradas juntas em 11/11 (`5d3af95`); não há um commit separado por aula.
- Resultado: em 17/11, o surgimento foi ajustado para percorrer os quatro lados do perímetro.

## Aula 11 — arte e horda — prazo 04/11

- O que entrou: folhas pixel art do explorador e dos escorpiões e oásis temático.
- Registro disponível: sprites finais e seus ajustes entraram no Git em 17/11 (`a9813ba`), após o prazo.
- Resultado: o limite cresce até 10 inimigos vivos; o smoke test processou 10 escorpiões por 60 frames em 400,7 ms no modo headless.

## Aula 12 — exportação Web e publicação — prazo 11/11

- O que entrou em 17/11: template Web oficial do Godot 4.7.1 instalado, preset Web sem threads configurado e release exportado para `build/web/`.
- Verificação: servidor local respondeu HTTP 200 para HTML, JavaScript, WASM e PCK; a captura headless do navegador permaneceu na tela de carregamento, então a execução visual no navegador não foi confirmada.
- Situação em 17/11: build local concluído; publicação pública ainda pendente.

## Aula 13 — apresentação — prazo 18/11

- Situação em 17/11: ainda não ocorreu; não há registro de apresentação.
- Preparação: revisar os estados do jogador e inimigos, colisões, disparos, HUD e fluxo de vitória/derrota.
- Lembrete: explicar o código com suas palavras e apontar as decisões e limites que ainda restam.
