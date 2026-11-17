# Relatório de requisitos — Areia Hostil: Abate

**Revisão:** 17/11/2026
**Escopo:** solicitações de gameplay desta conversa e etapas descritas em `PLANO-ENTREGA.md`.

## Resultado

Os requisitos de gameplay solicitados estão implementados: movimentação e animações direcionais do explorador, máquina de estados, colisão da água, disparos, horda de escorpiões e vitória em 50 abates. O projétil também foi redesenhado como um dardo de areia incandescente, com escala proporcional ao seu formato de colisão.

| Requisito | Situação | Evidência no projeto |
|---|---|---|
| Arena de deserto vista de cima e cenário editável no Godot | Implementado | `scenes/main.tscn` |
| Personagem principal com estados e movimento em quatro direções | Implementado | `scripts/player.gd`, `entities/player.tscn` |
| Animações separadas de repouso e corrida, em quatro direções e quatro quadros | Implementado | `assets/custom/explorer_states.png`, `assets/custom/explorer_states.tres` |
| Sprite pixel art próprio, coerente com o explorador do deserto | Implementado | `assets/custom/explorer_states.png` |
| Bloqueio físico retangular sobre a água do oásis | Implementado | Nó `OasisWaterBlocker` em `scenes/main.tscn` |
| Escorpiões perseguem o jogador e tentam contornar obstáculos; horda aumenta | Implementado | `scripts/scorpion.gd`, `scripts/main.gd` |
| Projétil visualmente coerente e combate funcional | Implementado | `assets/custom/projectile.svg`, `entities/projectile.tscn`, `scripts/projectile.gd` |
| Objetivo de derrotar 50 escorpiões e finais de vitória/derrota | Implementado | `scripts/main.gd`, `scripts/hud.gd` |
| Não criar sistema novo de upgrades | Respeitado | Nenhum sistema novo de upgrades foi acrescentado; o kit médico existente permanece. |
| Relatório de requisitos | Implementado | Este arquivo. |

## Verificações executadas

- `tests/gameplay_smoke.tscn`: passou; verifica seleção das animações, colisão física da água, dano dos tiros, três acertos por escorpião, contagem até 50, cura e finais de partida.
- Inicialização headless do Godot 4.7.1: sem erros de script ou carregamento.
- `git diff --check`: sem erros de formatação.
- O projeto foi aberto e executado no Godot para conferir o novo sprite e a cena do oásis.

## Pendências do plano de entrega

- **Exportação Web:** não concluída. Não há export templates instalados para a versão Godot 4.7.1 nesta máquina, então não foi possível gerar nem validar o pacote HTML5.
- **Página publicada:** não concluída. O plano não especifica hospedagem e publicar tornaria o jogo acessível externamente; é necessária a escolha do destino antes dessa etapa.
- **Arquivo de requisitos da turma:** o PDF `projeto.pdf` não está no diretório do projeto. Este relatório cobre as instruções do chat e o plano local; itens adicionais que existam apenas no PDF da turma não foram auditados.
