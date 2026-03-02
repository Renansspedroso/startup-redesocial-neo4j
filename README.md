# 🌐 Análise de Redes Sociais com Grafos (Neo4j)

Este repositório contém o projeto final (Capstone) do módulo de banco de dados de grafos. O objetivo foi atuar como Arquiteto de Dados para uma startup de mídia social, projetando e consultando um banco de dados em **Neo4j** para extrair *insights* complexos sobre o comportamento dos usuários.

## 🎯 O Desafio de Negócio
A startup precisava de um protótipo funcional capaz de responder a perguntas estratégicas sobre:
1. Interações e engajamento de usuários (Quem influencia quem?).
2. Popularidade de conteúdo (Quais posts geram mais tração?).
3. Comunidades de interesse (Como os usuários se agrupam por tópicos?).

## 🧠 Arquitetura e Modelagem Avançada
Para resolver o problema garantindo alta performance e escalabilidade, o *Knowledge Graph* foi desenhado aplicando conceitos avançados de modelagem em grafos:

* **Nós Intermediários (Intermediate Nodes):** Em vez de usar um relacionamento simples de "comentou" direto entre usuário e post, a entidade `Comment` foi modelada como um nó intermediário conectando o `User` ao `Post`. Isso permite armazenar propriedades ricas no comentário (como o próprio texto e a data) e facilita a expansão futura da rede (ex: permitir curtidas em comentários).
* **Listas Ligadas (Linked Lists / Timelines):** Utilização do auto-relacionamento `[:NEXT_POST]` na entidade `Post` para encadear as publicações, criando uma linha do tempo cronológica estrutural que otimiza drasticamente a consulta de *feeds* de usuários.
* **Comunidades:** Uso da entidade `Tag` conectada aos posts (`[:HAS_TAG]`) para agrupar dinamicamente os assuntos e mapear os interesses da rede.

## 🗂️ Estrutura do Repositório

* **`modelo_redesocial.png`**: Diagrama estrutural da arquitetura construído na ferramenta Arrows.app.
* **`redesocial.cypher`**: Script Cypher completo contendo:
  1. Criação de *Constraints* para integridade dos dados.
  2. População de dados simulando usuários, conexões (`FOLLOWS`), publicações e interações (`LIKED`, `WROTE`).
  3. **Consultas Analíticas (Queries):** Bloco de consultas
