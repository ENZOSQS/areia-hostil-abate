# Relatório de requisitos — Areia Hostil: Abate

**Revisão:** 17/11/2026

**Projeto revisado:** base `a9813ba` (`main`, sincronizado com `origin/main`) e alterações locais descritas em `PLANO-ACAO-COMPLETAMENTO.md`

**Documento de referência:** `E:/NOVO OPERA/projeto (1).pdf`, “Projeto do segundo semestre”, Jogos Digitais II, Aula 08, 5 páginas.

## Resultado geral

**O núcleo do jogo e a exportação Web local estão implementados.** A exportação e os recursos do pacote foram conferidos por HTTP, embora a execução visual em navegador permaneça sem confirmação. Publicação, entrega no Classroom, carta individual e apresentação ainda dependem de validação/ação no ambiente acadêmico. As alterações deste complemento ainda estão locais e não fazem parte do commit `a9813ba`.

Este documento é uma auditoria: não altera as regras do jogo. Itens “não verificáveis” dependem da carta sorteada, do Classroom ou da apresentação, que não estão incluídos no material examinado.

## Comparação com o PDF

| Requisito do documento | Situação | Evidência e observação |
|---|---|---|
| Carta: tema, tipo e modo escolhidos e registrados | Parcial | O `README.md` registra deserto com escorpiões, Abate e horda vista de cima. A carta sorteada individual da turma não foi fornecida, então não dá para confirmar que tema e tipo correspondem ao sorteio. |
| Modo horda: arena retangular fechada, uma tela, movimento em quatro direções e colisões | Atendido | Câmera central fixa com zoom 1:1 na viewport 1280×720; teste verifica centro e escala, e captura está em `screenshots/gameplay.png`. |
| Modo horda: inimigos surgem de qualquer ponto da borda | Atendido | `scripts/main.gd` sorteia ao longo do perímetro proporcional aos quatro lados e repete sorteio quando perto do jogador; teste cobre 128 amostras. |
| Aula 09: vida, dano, ataque, objetivo, vitória e derrota | Atendido | `scripts/player.gd`, `scripts/projectile.gd`, `scripts/main.gd` e `scripts/hud.gd` implementam vida, dano, disparo, contador de 50 abates e estados finais. O teste `tests/gameplay_smoke.tscn` cobre combate e finais. |
| Aula 10: inimigo com máquina de estados e contorno de obstáculos | Atendido | `scripts/scorpion.gd` declara estados e testa direções alternativas para contornar colisões. O projeto também tem bloqueios físicos no cenário. |
| Aula 11: arte do tema e horda completa sem travar | Parcial | Há sprites temáticos e limite de 10 inimigos vivos. Smoke test processou 10 por 60 frames em 400,7 ms headless; isso é uma checagem de carga básica, não prova desempenho em todas as máquinas. |
| Aula 12: exportado, rodando fora da Godot, com página publicada | Parcial | Preset e pacote Web de release existem em `build/web/`; HTML, JS, WASM e PCK responderam HTTP 200. O navegador headless ficou no carregamento da engine e não há endereço público; execução visual/publicação permanecem sem confirmar. |
| Aula 13: apresentação em sala | Não verificável | O repositório não comprova a apresentação nem se o responsável consegue explicar o código e as decisões. |
| README com carta, modo, instruções e captura de tela | Parcial | README descreve tema/tipo/modo, controles e captura; a correspondência à carta sorteada não pode ser validada sem a carta individual. |
| Estrutura organizada em cenas, entidades, scripts e sprites | Atendido | Há `scenes/`, `entities/`, `scripts/` e `assets/` com recursos separados. A pasta de sprites usa `assets/`, em vez do nome literal `sprites/` do exemplo do PDF. |
| DEVLOG com 3–5 linhas por aula e registro honesto do processo | Parcial | `DEVLOG.md` contém registros e decisões, mas usa seções por etapa/tema, não uma entrada identificável para cada Aula 08–13. Não há cobertura completa e inequívoca do calendário do PDF. |
| Um commit e uma tag por aula, enviados ao GitHub | Pendente | O histórico tem cinco commits e apenas a tag `etapa-01`. Não existem as tags esperadas `aula-08` a `aula-12`, nem `entrega-final`; os commits não formam um registro por cada encontro indicado no PDF. |
| Origem do código de IA em comentário de uma linha | Atendido | Scripts de gameplay e teste identificam a assistência do Codex em comentário no próprio arquivo. |
| Origem e licença da arte de terceiros no README | Atendido | README e `assets/custom/ORIGEM.md` distinguem recursos Kenney CC0, PixelLab gerado e ícones próprios. |
| Repositório com nome do jogo e link entregue no Classroom com tag `aula-08` | Parcial / não verificável | O repositório GitHub usado tem nome relacionado ao jogo e a tag local/remota disponível é `etapa-01`, não `aula-08`. Não há evidência de envio do link na atividade do Classroom. |

## Requisitos do tipo Abate

O PDF define vitória ao derrotar 50 inimigos e derrota quando a vida acaba. O jogo implementa ambos: a horda gera escorpiões, o jogador atira, a HUD acompanha abates e a sessão termina ao chegar a 50 ou perder toda a vida. O combate e os estados finais foram cobertos pelo teste de fumaça de gameplay já executado anteriormente. O projétil atual é o dardo de areia incandescente descrito no README.

## Itens prioritários para completar a entrega

1. Confirmar a execução visual do build Web no navegador; o teste de recursos via HTTP passou, mas a captura atual não avançou da tela de carregamento.
2. Publicar o pacote Web e registrar o endereço quando a hospedagem estiver configurada.
3. Confirmar a carta sorteada, enviar o link/tag no Classroom e preparar a apresentação explicando código e decisões.
4. Criar uma tag final na entrega revisada sem retrodatá-la; tags por aula só podem representar snapshots históricos identificáveis.

## Verificações e limites desta revisão

- O PDF tem cinco páginas; o texto e as páginas renderizadas foram revisados.
- Código, cenas, README, DEVLOG, plano, tags e histórico Git local/remoto foram inspecionados.
- O teste `tests/gameplay_smoke.tscn` e a inicialização do Godot sem erros estão registrados no relatório de desenvolvimento anterior; não foram repetidos nesta auditoria.
- A nota da disciplina não foi estimada: a rubrica inclui processo no prazo e explicação oral, itens que o repositório não permite avaliar por completo.
