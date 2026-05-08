# Predição de Gravidade em Casos de Violência Contra a Mulher no Estado de São Paulo

Projeto desenvolvido como parte do Projeto Integrador do curso de Tecnologia em Ciência de Dados da **Faculdade de Tecnologia Jundiaí – Deputado Ary Fossen (FATEC Jundiaí)**.

## 📌 Sobre o projeto

O objetivo deste trabalho é desenvolver um modelo preditivo capaz de classificar casos de violência contra a mulher no estado de São Paulo como **graves ou não graves**, utilizando técnicas de ciência de dados e aprendizado de máquina.

Os dados utilizados foram obtidos por meio do **Sistema de Informação de Agravos de Notificação (SINAN)**, do Ministério da Saúde.

## 🛠️ Tecnologias utilizadas

- **Python** – limpeza e pré-processamento dos dados
- **R** – modelagem com regressão logística

## 📁 Arquivos do repositório

| Arquivo | Descrição |
|---|---|
| `Limpeza_Dados.ipynb` | Notebook Python com todo o processo de limpeza e criação de variáveis |
| `Regressão_Logistica.R` | Script R com o modelo de regressão logística, curva ROC e matriz de confusão |

## 📊 Resultados

| Métrica | Valor |
|---|---|
| Acurácia | 76,25% |
| Sensibilidade | 79,03% |
| Especificidade | 57,46% |
| Acurácia Balanceada | 68,24% |
| Kappa | 0,2565 |

## ▶️ Como executar

**Limpeza dos dados (Python):**
- Abra o arquivo `Limpeza_Dados.ipynb` no Google Colab ou Jupyter Notebook
- Faça o upload do arquivo `violencia_sp.csv`
- Execute as células em ordem

**Modelo (R):**
- Abra o arquivo `Regressão_Logistica.R` no RStudio
- Instale os pacotes necessários: `readr`, `caret` e `pROC`
- Aponte o caminho correto para o arquivo `modelo_limpo.csv` gerado pelo notebook Python
- Execute o script
