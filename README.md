# Mini-SD (Sales & Distribution) em ABAP Cloud

<p align="center">
  <img src="https://img.shields.io/badge/SAP-ABAP%20Cloud-0FAAFF?style=for-the-badge&logo=sap&logoColor=white" alt="ABAP Cloud"/>
  <img src="https://img.shields.io/badge/SAP%20BTP-Environment-1B2A47?style=for-the-badge&logo=sap&logoColor=white" alt="SAP BTP"/>
  <img src="https://img.shields.io/badge/ABAP-Clean%20Code-orange?style=for-the-badge" alt="Clean Code"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License MIT"/>
  <img src="https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow?style=for-the-badge" alt="Status"/>
</p>

---

## 📖 Visão Geral

O **Mini-SD** é uma solução simplificada e moderna que simula os principais fluxos do módulo de **Vendas e Distribuição (SD)** do SAP, desenvolvida integralmente sob as diretrizes do **ABAP Cloud**.

O objetivo deste projeto é demonstrar, de forma didática e aderente às boas práticas atuais da SAP, como estruturar um pequeno sistema de vendas — com cadastro de clientes, produtos e pedidos — utilizando **Restricted ABAP**, **Core Data Services (CDS)** e **Object-Oriented ABAP**, tudo pronto para rodar em ambientes **SAP BTP ABAP Environment (Steampunk)**.


---

## 🏗️ Arquitetura e Objetos do Projeto

**📦 Pacote ABAP:** `ZTESTE_PK_01`

### 🗄️ Tabelas de Banco de Dados (TABL)

| Objeto | Tipo | Descrição |
|---|---|---|
| `ZSD_CLIENTE` | Tabela | Cadastro mestre de **Clientes** (dados básicos para vinculação aos pedidos de venda). |
| `ZSD_PRODUTO` | Tabela | Cadastro de **Produtos**, incluindo descrições e preços utilizados no cálculo dos pedidos. |
| `ZSD_PEDIDO_CAB` | Tabela | **Cabeçalho** (Header) dos Pedidos de Venda — armazena dados gerais como cliente, data e status do pedido. |
| `ZSD_PEDIDO_ITM` | Tabela | **Itens** (Items) dos Pedidos de Venda — armazena produto, quantidade e valores por item, vinculados ao cabeçalho. |

### 🧩 Classes ABAP (CLAS)

| Objeto | Tipo | Descrição |
|---|---|---|
| `ZCL_SD_PROCESSADOR_PEDIDO` | Classe de Negócio | Núcleo da aplicação. Responsável pelas **regras de negócio**, validações e processamento (criação, cálculo de totais e persistência) dos pedidos de venda. |
| `ZCL_SD_CARGA_DADOS` | Classe Utilitária | Realiza a **carga inicial de dados de teste** (mock data) nas tabelas de clientes e produtos, facilitando a demonstração do fluxo completo. |
| `ZCL_SD_TESTAR_PEDIDOS` | Classe de Teste | Executa **rotinas operacionais de teste**, simulando a criação de pedidos ponta a ponta e validando o comportamento da classe processadora. |
| `ZCL_HELLO_WORLD_GC` | Classe de Validação | Classe simples utilizada para **validar o ambiente ABAP Cloud** (conectividade, autorizações e configuração do sistema BTP). |

### 📊 Core Data Services / CDS Views (DDLS)

| Objeto | Tipo | Descrição |
|---|---|---|
| `ZCDS_PRODUTOS_MAIS_VENDIDOS` | CDS View | View analítica voltada para **relatórios gerenciais**, agregando dados de vendas para identificar os produtos com maior volume de saída. |

---

## ⚙️ Como Importar no Eclipse (via abapGit)

Siga o passo a passo abaixo para clonar este projeto diretamente no seu sistema **SAP BTP ABAP Environment** utilizando o **Eclipse ADT**:

1. **Pré-requisitos**
   - Ter o **Eclipse** com o plugin **ABAP Development Tools (ADT)** instalado.
   - Ter o plugin **abapGit for Eclipse (ADT)** instalado ([veja aqui como instalar](https://github.com/abapGit/ADT_frontend)).
   - Possuir acesso a um sistema **SAP BTP ABAP Environment (Trial ou produtivo)**.

2. **Criar o Pacote de Destino**
   - No Eclipse, conecte-se ao seu sistema ABAP Cloud.
   - Crie um novo pacote chamado `ZTESTE_PK_01` (ou o nome de sua preferência).

3. **Vincular o Repositório abapGit**
   - Clique com o botão direito no pacote criado.
   - Selecione **Team ➜ Link to Git Repository...**
   - Cole a URL deste repositório GitHub:
     ```
     https://github.com/SEU-USUARIO/mini-sd-abap-cloud.git
     ```
   - Escolha a branch `main` e confirme.

4. **Fazer o Pull dos Objetos**
   - Com o repositório vinculado, clique com o botão direito nele.
   - Selecione **Pull** para trazer todos os objetos (tabelas, classes e CDS Views) para o seu sistema.

5. **Ativar os Objetos**
   - Após o pull, ative todos os objetos importados (`Ctrl + F3` ou botão **Activate All**).

✅ Pronto! O projeto **Mini-SD** estará disponível e ativo no seu ambiente ABAP Cloud.

---

## ▶️ Como Executar e Testar

### 1️⃣ Carga Inicial de Dados (Mock Data)

Antes de testar os pedidos, é necessário popular as tabelas de Clientes e Produtos:

1. Abra a classe `ZCL_SD_CARGA_DADOS` no ADT.
2. Certifique-se de que o método `IF_OO_ADT_CLASSRUN~MAIN` esteja implementado com a lógica de carga.
3. Pressione **F9** (ou clique em **Run As ➜ ABAP Application (Console)**).
4. Verifique no console de saída se os registros foram inseridos com sucesso nas tabelas `ZSD_CLIENTE` e `ZSD_PRODUTO`.

### 2️⃣ Execução dos Testes Operacionais

Com os dados de teste já carregados, execute a simulação do fluxo de pedidos:

1. Abra a classe `ZCL_SD_TESTAR_PEDIDOS` no ADT.
2. Pressione **F9** (ou clique em **Run As ➜ ABAP Application (Console)**).
3. Acompanhe no console o resultado do processamento — a classe irá acionar `ZCL_SD_PROCESSADOR_PEDIDO` para criar pedidos, calcular totais e validar as regras de negócio.

### 3️⃣ Validação do Ambiente (Opcional)

Caso queira apenas validar se o ambiente ABAP Cloud está corretamente configurado:

1. Abra a classe `ZCL_HELLO_WORLD_GC`.
2. Pressione **F9** para executar e confirmar a saída no console.

### 4️⃣ Consultando o Relatório de Produtos Mais Vendidos

1. Abra a CDS View `ZCDS_PRODUTOS_MAIS_VENDIDOS` no ADT.
2. Clique com o botão direito ➜ **Open With ➜ Data Preview** (ou pressione `Shift + F8`).
3. Analise os dados agregados de vendas diretamente na visualização de dados.

---

## 🚀 Tecnologias & Boas Práticas

Este projeto foi construído com foco total em aderência às práticas modernas de desenvolvimento SAP:

- ☁️ **ABAP Cloud** — desenvolvimento restrito ao *Cloud Development Model*, garantindo compatibilidade e portabilidade entre sistemas SAP BTP e S/4HANA Cloud.
- 🔒 **ABAP Restricted Syntax (Syntax Check Cloud Development)** — uso exclusivo de instruções e APIs liberadas (*Released APIs*) para o ambiente Cloud, evitando comandos obsoletos ou não suportados.
- 🧼 **Clean ABAP** — código orientado a objetos, nomenclatura clara, métodos curtos e coesos, seguindo o guia [Clean ABAP](https://github.com/SAP/styleguides/blob/main/clean-abap/CleanABAP.md).
- 🧱 **Programação Orientada a Objetos (OO)** — toda a lógica de negócio encapsulada em classes especializadas, com responsabilidades bem definidas (Single Responsibility Principle).
- 📊 **Core Data Services (CDS)** — modelagem semântica de dados para análises e relatórios, aproveitando o poder de agregação nativo do CDS.
- 🔄 **abapGit** — versionamento de código-fonte ABAP integrado ao Git, permitindo controle de versão colaborativo como em qualquer stack moderna.
- 🧪 **Console-based Testing (`IF_OO_ADT_CLASSRUN`)** — testes executáveis diretamente pelo ADT via `F9`, sem necessidade de transações clássicas (SE38/SE80).

---

## 👤 Autor

**Gabriel Cecilio Menezes**

- 💼 LinkedIn: www.linkedin.com/in/gabriel-cecilio-bb938035b
- 📧 E-mail: gabrielceciliomenezes@gmail.com
