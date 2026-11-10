# Arte Mágica

Skill do Codex que pega uma arte pronta (ou um briefing) e faz um **PSD de verdade, em camadas e em alta**, que lembra a arte, como um diretor de arte faria a partir de uma referência. Fica fácil de editar e pronto para virar outros formatos.

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

Você só manda a arte. Ela trabalha sozinha e volta com a peça pronta.

1. **Plano:** ela olha a arte como um diretor de arte e decide o caminho de cada elemento: gerar de novo em alta, fazer um fundo novo, criar a letra, aproveitar a própria arte ou deixar o texto digitável. Um crítico (outro diretor de arte) e um instrutor de Photoshop, independentes, discutem o plano com ela antes de qualquer ferramenta.
2. **Assets:** antes de cada parte difícil, ela pesquisa e pergunta ao instrutor como se faz. O crítico aprova os principais antes da montagem.
3. **Montagem:** ela monta o PSD com o fundo inteiro, cada elemento separado com a sombra dele e os textos que mudam digitáveis.
4. **Testes:** ela troca uma palavra, move os elementos e vira o PSD em outro formato, para provar que dá para editar.
5. **Entrega:** um revisor novo confere tudo, e você recebe o PSD, o comparativo e o que faltou, se faltou algo.
6. **Aula:** depois do seu aceite, ela propõe o que aprendeu. Só guarda com o seu "ok", e a próxima arte já começa sabendo.

## O que significam as notas

- **80%** de semelhança, no olho: posição, tamanho, cores, luz e estilo iguais; detalhes podem mudar. É o que você espera de um designer a quem mandou uma referência.
- **A grafia, o logo e o produto real** não têm porcentagem: estão certos ou errados.
- A palavra final é sua. Se algo não chegar lá, ela mostra o melhor resultado e você decide.

## Bom saber

- Ela mira em **cerca de 30 minutos** por arte. Só para antes do fim se faltar algo que não dá para inventar (texto da oferta, logo oficial, foto de produto) ou se precisar gastar ou instalar algo.
- O logo e o manual da marca são com você: mande os arquivos oficiais junto.
- O gerador do Codex tem limite de tamanho. Para peças muito grandes, como um outdoor, ela tenta caminhos no próprio Photoshop e avisa se a imagem não ficar nítida no tamanho final.
- O conferidor do PSD (`verificar-psd.jsx`) é novo. Se der erro, o Codex pode corrigir e seguir.
- O que ela aprende fica na pasta da skill, no seu computador. Antes de reinstalar, guarde uma cópia da pasta `cerebro`.
