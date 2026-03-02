// ============================================================================
// PASSO 1: CONSTRAINTS (Garantindo a integridade dos dados)
// ============================================================================
CREATE CONSTRAINT user_id_unique FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT post_id_unique FOR (p:Post) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT comment_id_unique FOR (c:Comment) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT tag_name_unique FOR (t:Tag) REQUIRE t.name IS UNIQUE;

// ============================================================================
// PASSO 2: POPULANDO O BANCO DE DADOS (A REDE SOCIAL)
// ============================================================================
CREATE
  // 1. Criando as Tags (Comunidades)
  (t1:Tag {name: 'Neo4j'}),
  (t2:Tag {name: 'Grafos'}),
  (t3:Tag {name: 'DataScience'}),

  // 2. Criando os Usuários
  (u1:User {id: 'u1', username: 'Renan'}), // Você é o influenciador!
  (u2:User {id: 'u2', username: 'Alice'}),
  (u3:User {id: 'u3', username: 'Bob'}),
  (u4:User {id: 'u4', username: 'Carol'}),

  // 3. Usuários se seguindo (FOLLOWS)
  (u2)-[:FOLLOWS]->(u1), // Alice segue Renan
  (u3)-[:FOLLOWS]->(u1), // Bob segue Renan
  (u4)-[:FOLLOWS]->(u1), // Carol segue Renan
  (u1)-[:FOLLOWS]->(u2), // Renan segue Alice de volta

  // 4. Criando os Posts (e conectando aos autores e tags)
  // Post 1 (Mais antigo)
  (p1:Post {id: 'p1', content: 'Começando meus estudos em Neo4j hoje!', date: '2026-03-01'})
  <-[:PUBLISHED]- (u1),
  (p1)-[:HAS_TAG]->(t1),

  // Post 2 (Mais novo)
  (p2:Post {id: 'p2', content: 'Modelagem de grafos é muito superior a tabelas relacionais para redes sociais.', date: '2026-03-02'})
  <-[:PUBLISHED]- (u1),
  (p2)-[:HAS_TAG]->(t1),
  (p2)-[:HAS_TAG]->(t2),

  // Post da Alice
  (p3:Post {id: 'p3', content: 'Alguém recomenda cursos de Data Science?', date: '2026-03-02'})
  <-[:PUBLISHED]- (u2),
  (p3)-[:HAS_TAG]->(t3),

  // 5. A LISTA LIGADA (TIMELINE do Renan)
  // O Post 2 aponta para o Post 1 como o próximo post mais antigo
  (p2)-[:NEXT_POST]->(p1),

  // 6. Curtidas (LIKED)
  (u2)-[:LIKED]->(p2),
  (u3)-[:LIKED]->(p2),
  (u4)-[:LIKED]->(p2), // Post 2 viralizou!
  (u1)-[:LIKED]->(p3),

  // 7. O NÓ INTERMEDIÁRIO (Comentários)
  (c1:Comment {id: 'c1', text: 'Excelente observação, Renan!', date: '2026-03-02'})
  <-[:WROTE]- (u2),
  (c1)-[:ON_POST]->(p2),

  (c2:Comment {id: 'c2', text: 'Concordo plenamente. Grafos são o futuro.', date: '2026-03-02'})
  <-[:WROTE]- (u3),
  (c2)-[:ON_POST]->(p2);