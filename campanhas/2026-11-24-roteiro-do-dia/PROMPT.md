# Campanha "Hoje tem obra no seu bairro": Roteiro do Dia, 24/11/2026

Prompt para o **Codex na máquina local** (Windows + Photoshop). Gere **todas as imagens** desta campanha de Instagram: stories, carrossel, capa do Reels e o **pacote de camadas para o vídeo**. A edição do vídeo será feita depois, em outra sessão, a partir da pasta `para-video/` e do arquivo `cenas.json`. Por isso a parte do vídeo precisa sair exatamente no formato pedido abaixo.

Trabalhe sozinho do início ao fim e só volte com tudo pronto, como na skill `$artemagica`. Se ela estiver instalada, siga as regras dela de **logo, texto, PSD em camadas, edições sem manchas e olheiro final**. A diferença é que aqui o trabalho é **criação nova a partir de um briefing**, não a recriação de uma referência: a imagem em `referencia/cronograma-original.jpg` é a **fonte dos dados e da paleta**, não a arte a copiar.

---

## 0. Preparar

1. Clone ou atualize o repositório e use **esta branch**:
   ```powershell
   git clone https://github.com/RodrigoTimotheo1984/artemagica.git   # se ainda não tiver
   cd artemagica
   git fetch origin ccr-cbc8ce03-52hsnv
   git checkout ccr-cbc8ce03-52hsnv
   git pull
   ```
2. Trabalhe dentro de `campanhas/2026-11-24-roteiro-do-dia/`.
3. Logos oficiais: veja se existem arquivos em `referencia/logos/` (brasão da Prefeitura de Várzea Grande e logo da Secretaria de Viação e Obras). **Logo nunca é gerado nem redesenhado.** Se a pasta estiver vazia, crie em cada peça uma camada chamada `LOGO OFICIAL AQUI` (retângulo de reserva com esse texto, no tamanho e lugar certos), siga o trabalho e avise na entrega.
   - **Atenção:** o logo que aparece no cronograma original foi gerado por IA e tem texto embaralhado embaixo de "Várzea Grande". **Não recorte nem reaproveite** esse logo.

---

## 1. O conceito

O cronograma diário da Secretaria de Viação e Obras vira uma **série diária** no Instagram: *"Hoje tem obra no seu bairro"*. O tom é **positivo, de prestação de serviço**: a prefeitura está na rua, em vários bairros, todos os dias. O morador precisa bater o olho e achar o **bairro dele** e o **benefício** (rua sem buraco, rua que não alaga), sem jargão técnico.

É uma série, então **tudo é template**: data, bairros e serviços são **texto digitável** no PSD, para que amanhã o designer troque só o texto e a peça saia em 10 minutos.

### Regras de comunicação pública (obrigatórias)
- **Nenhuma autoridade** em imagem ou texto: sem rosto, nome ou cargo de prefeito ou secretário. A estrela é a obra (CF, art. 37, §1º).
- Nenhum slogan político ou partidário, nenhuma cor de partido além das cores da cidade.
- As imagens geradas são **ilustração estilizada**, nunca foto realista. Não podem parecer registro real de uma obra que não foi fotografada.
- Trabalhadores ilustrados com uniforme e colete **genéricos, sem logo e sem texto** nos uniformes, nas máquinas ou em placas.

---

## 2. Identidade visual

**Paleta** (tirada do cronograma; ajuste fino a olho, se precisar):

| Uso | Cor |
|---|---|
| Verde da prefeitura (base, faixas, fundo neutro) | `#1E6B3C` |
| Amarelo (destaque, Tapa-buraco) | `#F7B500` |
| Marrom-ferrugem (Patrolamento) | `#A3401D` |
| Azul (Drenagem) | `#1F5FE0` |
| Vermelho (Serviços de Pedreiro) | `#E5283C` |
| Azul-marinho (textos de apoio) | `#1B2A6B` |
| Branco / off-white | `#FFFFFF` / `#F7F5EF` |

**Código de cor por serviço:** mantenha sempre a mesma cor para cada serviço em todas as peças. A população aprende que amarelo é buraco, azul é drenagem etc.

**Letras:** sem serifa, condensada e bem pesada nos títulos, como no cronograma (ex.: *Barlow Condensed ExtraBold*, *Bebas Neue*, *Oswald Bold*; use a que estiver instalada e seja parecida). Textos de apoio em sem serifa legível (ex.: *Montserrat*, *Barlow*). Use uma família só na série inteira.

**Ícones:** um por serviço, simples, chapados, na cor do serviço (pessoa com pá e monte de asfalto; trator/patrol; escavadeira; parede de tijolos). Pode desenhar em vetor/forma no Photoshop ou gerar e recortar. Precisam ficar nítidos e sem texto.

**Estilo das ilustrações de fundo:** ilustração 3D estilizada, cores vivas e limpas, luz de manhã cedo (sol baixo, céu azul com poucas nuvens), clima de cidade quente do Centro-Oeste: ruas largas, casas térreas, árvores (ipês e mangueiras), poeira leve onde fizer sentido. Clima otimista e de trabalho. Sempre com **área limpa** reservada para o texto (veja os formatos).

---

## 3. Conteúdo (grafia exata: confira letra por letra)

Data da série de hoje: **TERÇA-FEIRA | 24/11/2026** (camada digitável).

| Serviço | Bairro | Texto para o morador |
|---|---|---|
| TAPA-BURACO | Júlio Domingos de Campos | Tapa-buraco na Av. A |
| TAPA-BURACO | Júlio Domingos de Campos | Início das obras na Rua das Margaridas |
| PATROLAMENTO | Sadia III | Ruas niveladas e mais seguras |
| PATROLAMENTO | Mangabeiras | Ruas niveladas e mais seguras |
| DRENAGEM | Joaquim Curvo | Tubulação de 1 metro contra alagamentos |
| DRENAGEM | Jd. União | Rede dupla de drenagem |
| SERVIÇOS DE PEDREIRO | Alameda | Novas bocas de lobo: a chuva escoa e a rua não alaga |

Números do dia: **4 tipos de serviço · 7 frentes de trabalho · 6 bairros**.

Aviso (sempre pequeno e discreto, nunca em destaque de alerta): *Programação sujeita a ajustes conforme o clima e a operação.*

Assinatura: **Prefeitura de Várzea Grande · Secretaria de Viação e Obras** (como logos oficiais, ou reserva de logo; veja o passo 0).

---

## 4. Peças

Exporte em **PNG, sRGB**. PSDs em `editaveis/`. Eles **não sobem** para o GitHub (o `.gitignore` já ignora `*.psd`).

### 4.1 Stories: 1080×1920, pasta `stories/`
Área segura: nada essencial nos **250 px de cima** nem nos **340 px de baixo** (interface do Instagram).

| Arquivo | Conteúdo |
|---|---|
| `story-01-abertura.png` | "Bom dia, Várzea Grande!" + "Bora ver onde as equipes estão hoje?" + data. Deixe um espaço vazio de ~800×300 px no terço de baixo para a **figurinha de enquete** (colocada no app). |
| `story-02-tapa-buraco.png` | Selo amarelo TAPA-BURACO + ícone + bairro + as duas linhas do Júlio Domingos de Campos + ilustração de tapa-buraco. |
| `story-03-patrolamento.png` | Selo marrom PATROLAMENTO + Sadia III e Mangabeiras + "Ruas niveladas e mais seguras" + ilustração da patrol nivelando rua de terra. |
| `story-04-drenagem.png` | Selo azul DRENAGEM + Joaquim Curvo (tubulação de 1 metro) e Jd. União (rede dupla) + ilustração de tubos de concreto e escavadeira. |
| `story-05-pedreiro.png` | Selo vermelho SERVIÇOS DE PEDREIRO + Alameda + bocas de lobo + ilustração de boca de lobo sendo construída no meio-fio. |
| `story-06-fechamento.png` | "Qual rua do seu bairro precisa de atenção?" + espaço vazio de ~800×400 px para a **caixa de perguntas** + aviso discreto. |
| `story-07-missao-cumprida.png` | Template de fim do dia: "Missão cumprida!" + dois quadros **ANTES** / **DEPOIS** com camadas de foto vazias (máscara pronta para a equipe soltar a foto real) + bairro digitável. Exporte com um cinza neutro nos quadros. |

### 4.2 Carrossel do feed: 1080×1350, pasta `carrossel/`
Margem segura de 80 px. Os slides precisam parecer uma sequência contínua (mesmo fundo, mesma grade; um elemento que "atravessa" do slide 1 para o 2 é bem-vindo).

| Arquivo | Conteúdo |
|---|---|
| `carrossel-01-capa.png` | **"Hoje tem obra no seu bairro!"** + TERÇA-FEIRA \| 24/11/2026 + "arrasta pro lado" com seta. A ilustração mais bonita da série fica aqui. |
| `carrossel-02-resumo.png` | 4 tipos de serviço · 7 frentes de trabalho · 6 bairros, com os 4 ícones nas cores dos serviços. |
| `carrossel-03-tapa-buraco.png` | Tapa-buraco: Júlio Domingos de Campos (Av. A e Rua das Margaridas). |
| `carrossel-04-patrolamento.png` | Patrolamento: Sadia III e Mangabeiras. |
| `carrossel-05-drenagem.png` | Drenagem: Joaquim Curvo e Jd. União. |
| `carrossel-06-pedreiro.png` | Serviços de pedreiro: Alameda, novas bocas de lobo. |
| `carrossel-07-chamada.png` | "Viu sua rua? Marca o vizinho!" + "Comenta qual bairro você quer ver aqui" + aviso discreto + assinatura. |

### 4.3 Capa do Reels: 1080×1920, pasta `reels/`
`capa-reels.png`: "Hoje tem obra no seu bairro!" + data. Todo o essencial dentro do **retângulo central de 1080×1440** (é o recorte que aparece na grade do perfil).

### 4.4 Pacote para o vídeo: pasta `para-video/` (o mais importante para a próxima etapa)

O vídeo será um Reels de ~35 s, editado depois em outra sessão com ffmpeg, a partir **só** desta pasta. Para cada elemento poder entrar animado separadamente:

- **Fundos** (`para-video/fundos/`): ilustração **sem nenhum texto**, em **1296×2304** (20% maior que 1080×1920, para dar zoom lento sem perder nitidez). Área de texto mais limpa no **terço de cima** (até ~y = 900 no quadro final de 1080×1920).
- **Camadas** (`para-video/camadas/`): cada elemento em um **PNG transparente de quadro inteiro, 1080×1920**, já na posição final (o resto do quadro fica transparente). Assim basta empilhar e animar cada um. Sombras e brilhos de cada elemento vão **dentro** do PNG dele. Respeite a área segura dos stories.
- **Marca** (`para-video/marca/`): logos oficiais (ou a reserva) em PNG transparente de quadro inteiro, 1080×1920, na posição da assinatura.

Cenas e arquivos esperados:

| # | Cena | Duração sugerida | Fundo | Camadas, na ordem em que entram |
|---|---|---|---|---|
| 1 | abertura | 3 s | `fundos/01-abertura.png` (rua da cidade ao amanhecer, máquinas chegando) | `camadas/01-a-bom-dia.png` ("Bom dia, Várzea Grande!"), `camadas/01-b-chamada.png` ("Olha onde a gente tá hoje" + seta para baixo), `camadas/01-c-data.png` |
| 2 | tapa-buraco | 6 s | `fundos/02-tapa-buraco.png` | `camadas/02-a-selo.png` (selo amarelo + ícone), `camadas/02-b-bairro.png` (Júlio Domingos de Campos), `camadas/02-c-linha1.png` (Tapa-buraco na Av. A), `camadas/02-d-linha2.png` (Início das obras na Rua das Margaridas) |
| 3 | patrolamento | 5 s | `fundos/03-patrolamento.png` | `camadas/03-a-selo.png`, `camadas/03-b-bairros.png` (Sadia III e Mangabeiras), `camadas/03-c-linha1.png` (Ruas niveladas e mais seguras) |
| 4 | drenagem | 7 s | `fundos/04-drenagem.png` | `camadas/04-a-selo.png`, `camadas/04-b-bairro1.png` (Joaquim Curvo + tubulação de 1 metro contra alagamentos), `camadas/04-c-bairro2.png` (Jd. União + rede dupla de drenagem) |
| 5 | pedreiro | 5 s | `fundos/05-pedreiro.png` | `camadas/05-a-selo.png`, `camadas/05-b-bairro.png` (Alameda), `camadas/05-c-linha1.png` (Novas bocas de lobo: a chuva escoa e a rua não alaga) |
| 6 | resumo | 5 s | `fundos/06-resumo.png` (vista aérea estilizada da cidade, fim de tarde) | `camadas/06-a-servicos.png` (4 tipos de serviço), `camadas/06-b-frentes.png` (7 frentes de trabalho), `camadas/06-c-bairros.png` (6 bairros), `camadas/06-d-amanha.png` ("E amanhã tem mais.") |
| 7 | assinatura | 4 s | `fundos/07-assinatura.png` (verde da prefeitura, com textura sutil, sem ilustração) | `camadas/07-a-bom-trabalho.png` ("Bom trabalho a todos!"), `marca/07-logos.png`, `camadas/07-b-aviso.png` (aviso discreto) |

Escreva também **`para-video/cenas.json`** descrevendo exatamente o que foi entregue, neste formato:

```json
{
  "formato": { "largura": 1080, "altura": 1920, "fps": 30 },
  "paleta": { "verde": "#1E6B3C", "amarelo": "#F7B500", "marrom": "#A3401D", "azul": "#1F5FE0", "vermelho": "#E5283C" },
  "cenas": [
    {
      "id": "02-tapa-buraco",
      "duracao_s": 6,
      "fundo": "fundos/02-tapa-buraco.png",
      "camadas": [
        { "arquivo": "camadas/02-a-selo.png",   "texto": "TAPA-BURACO", "caixa": [x, y, largura, altura] },
        { "arquivo": "camadas/02-b-bairro.png", "texto": "Júlio Domingos de Campos", "caixa": [x, y, largura, altura] }
      ]
    }
  ],
  "pendencias": ["ex.: logos oficiais não fornecidos, reserva usada"]
}
```
`caixa` é o retângulo onde o conteúdo visível de cada camada está no quadro de 1080×1920 (para o editor saber de onde animar). Meça nos PNGs reais e não invente valores.

---

## 5. Critério de pronto

- Grafia certa, letra por letra, incluindo acentos (Júlio, Jd. União, TERÇA-FEIRA).
- Bairro legível em **1 segundo** na tela do celular: nome do bairro grande, serviço em segundo plano.
- Código de cor por serviço respeitado em todas as peças.
- Mesma família visual em stories, carrossel, capa e vídeo: parece uma série só.
- Ilustrações bonitas por si: sem texto falso, placas ilegíveis, mãos ou máquinas deformadas, nem logos inventados. Confira a 100%.
- Nenhuma autoridade e nenhum logo gerado.
- PSDs com data, bairros e serviços digitáveis (teste: troque "Sadia III" por um nome maior e veja se o layout aguenta).
- `cenas.json` bate com os arquivos que existem de verdade.

---

## 6. Entregar

1. Escreva `ENTREGA.md` nesta pasta com: a lista de arquivos, uma miniatura/contato das peças (`revisao/contato.png` com todas lado a lado), as pendências (ex.: logo oficial) e o tempo gasto e o número de gerações (o que não souber, escreva "não disponível").
2. Suba **somente PNG, JSON e MD** (sem PSD) para a mesma branch:
   ```powershell
   git add campanhas/2026-11-24-roteiro-do-dia
   git commit -m "Roteiro do Dia 24/11: stories, carrossel, capa do Reels e pacote para vídeo"
   git push origin ccr-cbc8ce03-52hsnv
   ```
   Se o push for recusado porque a branch andou, faça `git pull --no-rebase` e tente de novo. Nunca force.
3. Responda ao usuário com um resumo curto: o que foi feito, o que está pendente e o link da pasta no GitHub.
