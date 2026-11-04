# Arte Mágica

Skill do Codex que transforma uma arte pronta (ou um briefing) em um **PSD em camadas**, o mais igual possível à arte, fácil de editar e pronto para virar outros formatos.

## O que você precisa

- **Windows**
- **Adobe Photoshop** instalado (feita no Photoshop 2026)
- **Codex** no computador, com o ChatGPT pago

Não precisa de nenhum outro serviço de imagem: as imagens saem do próprio Codex.

## Como instalar

1. Abra o Codex.
2. Cole esta mensagem e envie:

   ```
   $skill-installer instale a skill https://github.com/RodrigoTimotheo1984/artemagica/tree/main/artemagica
   ```

3. Feche e abra o Codex de novo.

**Se a instalação automática não funcionar:** copie a pasta `artemagica` para dentro de `C:\Users\<seu usuário>\.codex\skills\` e abra o Codex de novo.

## Como usar

1. Abra o Photoshop.
2. No Codex, abra a pasta do seu trabalho e comece uma conversa nova.
3. Anexe a arte e escreva, por exemplo:

   ```
   $artemagica
   Quero esta arte em PSD.
   Formato final: 3600x2400.
   ```

Na primeira vez, o Codex pode pedir permissão para controlar o Photoshop. É só aprovar.

## Como ela trabalha

1. **Molde:** a sua arte vira o modelo a ser copiado. Você aprova.
2. **Peças:** ela separa os elementos (fundo, pessoas, produtos, selo, textos) e gera em alta só o que precisa. Você aprova cada peça gerada.
3. **Montagem:** ela usa os pixels da própria arte em camadas com máscara e reconstrói o fundo que fica escondido atrás dos elementos. Mede, olha, corrige e repete.
4. **Testes:** ela troca uma palavra, move um personagem e vira o PSD em outro formato, para provar que dá para editar.
5. **Entrega:** um revisor novo confere tudo, e você recebe o PSD, o PNG, o comparativo e as notas.
6. **Aula:** depois do seu aceite, ela propõe o que aprendeu. Só guarda com o seu "ok", e a próxima arte já começa sabendo.

## O que significam as notas

- **95%** é o mínimo de semelhança, no geral e em cada pedaço. Nada é 100%.
- **90%** é o mínimo do texto editável, porque nenhuma fonte instalada é idêntica a um lettering desenhado.
- **A grafia** não tem porcentagem: está certa ou está errada.
- A régua aponta onde olhar. **Quem decide é o olho**, e a palavra final é sua. Se algo não chegar ao mínimo, ela mostra o melhor resultado e você decide.

O PSD abre **igual à arte**. Para mexer nas palavras, escolha **Editar texto** no painel Composições de camadas.

## Bom saber

- Pode levar **cerca de 1 a 2 horas** por arte. Deixe rodar.
- O logo e o manual da marca são com você: mande os arquivos oficiais junto.
- O gerador do Codex tem limite de tamanho. Para peças muito grandes, como um outdoor, ela tenta caminhos no próprio Photoshop e avisa se a imagem não ficar nítida no tamanho final.
- A régua e o conferidor do PSD (`medir-semelhanca.py` e `verificar-psd.jsx`) são novos. Se derem erro, o Codex pode corrigir e seguir.
- O que ela aprende fica na pasta da skill, no seu computador. Antes de reinstalar, guarde uma cópia da pasta `cerebro`.
