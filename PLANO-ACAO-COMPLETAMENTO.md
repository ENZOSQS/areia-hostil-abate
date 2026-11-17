# Plano de ação — conclusão da entrega

**Revisão:** 17/11/2026  
**Referência:** auditoria de `projeto (1).pdf` registrada em `RELATORIO-REQUISITOS.md`.

## 1. Enquadrar a arena inteira

- [x] Mover a câmera para a cena principal, centralizada na origem da arena.
- [x] Usar zoom 1:1 para a área de 1280×720 ocupar a viewport de 1280×720.
- [x] Acrescentar verificações no teste para câmera central e zoom.
- [x] Conferir a renderização 1280×720 e guardar captura do jogo em `screenshots/gameplay.png`.

## 2. Fazer os inimigos surgirem pelas bordas

- [x] Substituir o ponto de surgimento perto do jogador por sorteio ao longo do perímetro.
- [x] Distribuir as posições proporcionalmente ao comprimento dos quatro lados.
- [x] Tentar novamente se a posição sorteada ficar a menos de 220 unidades do jogador.
- [x] Testar 128 posições e confirmar que todos os lados podem ser escolhidos.

## 3. Organizar autoria e créditos

- [x] Colocar comentário de origem de IA nos scripts de gameplay e no teste.
- [x] Registrar separadamente os arquivos Kenney CC0, as gerações PixelLab e os ícones SVG próprios.
- [x] Ligar os créditos e termos de uso a partir do README.
- [x] Incluir a captura renderizada do jogo no README.

## 4. Manter um DEVLOG verificável

- [x] Criar entradas identificadas para as Aulas 08 a 13, com o que entrou, bloqueios e situação.
- [x] Distinguir os prazos da disciplina das datas reais registradas no Git.
- [x] Marcar exportação Web como concluída localmente; publicação fica pendente. Aula 13 ainda não ocorreu em 17/11.

## 5. Validar o build e o comportamento

- [x] Fazer importação limpa dos recursos na cópia de validação.
- [x] Executar `tests/gameplay_smoke.tscn` após as alterações e verificar o resultado.
- [x] Inicializar o projeto headless sem erros de script.
- [x] Gerar pacote Web de release em `build/web/`.
- [ ] Confirmar a execução dentro de navegador: os recursos carregam por HTTP, mas o navegador headless permaneceu na tela de carregamento da engine.
- [x] Medir a horda no limite de 10 inimigos vivos: 60 frames processados em 400,7 ms no smoke test headless.

## 6. Exportar e publicar

- [x] Identificar o template oficial correspondente: Godot 4.7.1.
- [x] Instalar somente o template Web correspondente ao Godot 4.7.1, após conferir o hash oficial.
- [x] Configurar o preset Web e exportar para `build/web/index.html`.
- [x] Servir localmente e confirmar HTTP 200 para HTML, JavaScript, WASM e PCK.
- [ ] Confirmar a execução dentro do navegador; a tela capturada ficou no carregamento da engine.
- [ ] Publicar o build em GitHub Pages e registrar o endereço. GitHub Pages torna o site público; a publicação fica para a etapa final, depois da revisão do build.

## 7. Registrar os incrementos no Git sem alterar datas

- [x] Conferir commits e tags existentes: cinco commits e apenas `etapa-01`.
- [x] Preservar as datas originais e documentar atrasos no DEVLOG.
- [x] Não criar tags `aula-09`/`aula-10` apontando para o mesmo commit combinado: isso não mostraria estados separados. Tags retroativas só serão úteis se cada snapshot real da aula puder ser identificado.
- [ ] Criar a tag de entrega final depois da exportação e do teste final, com a data efetiva do commit.

## 8. Entrega acadêmica e apresentação

- [ ] Confirmar que tema e tipo do README coincidem com a carta individual sorteada.
- [ ] Enviar o link do repositório e a tag adequada na atividade do Classroom.
- [ ] Preparar uma apresentação explicando estados do jogador/inimigo, colisões, tiros, HUD e os limites conhecidos.
- [ ] Registrar o resultado da apresentação no DEVLOG depois que ela acontecer.

## Critério de conclusão

A entrega técnica termina quando os itens de exportação, teste Web e publicação forem concluídos. Classroom, carta sorteada e apresentação precisam de confirmação no ambiente da turma. O histórico preserva as datas reais: nenhum commit ou tag será apresentado como se tivesse sido criado antes de sua data efetiva.
