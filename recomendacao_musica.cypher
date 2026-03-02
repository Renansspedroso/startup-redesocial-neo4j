// ============================================================================
// PASSO 1: CONSTRAINTS (Garantindo que IDs e Nomes não se repitam)
// ============================================================================
CREATE CONSTRAINT user_id_unique FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT song_id_unique FOR (s:Song) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT artist_id_unique FOR (a:Artist) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT genre_name_unique FOR (g:Genre) REQUIRE g.name IS UNIQUE;

// ============================================================================
// PASSO 2: POPULANDO O BANCO DE DADOS
// ============================================================================
CREATE
  // 1. Criando Gêneros
  (gRock:Genre {name: 'Rock'}),
  (gPop:Genre {name: 'Pop'}),

  // 2. Criando Artistas
  (a1:Artist {id: 'a1', name: 'Pink Floyd'}),
  (a2:Artist {id: 'a2', name: 'Led Zeppelin'}),
  (a3:Artist {id: 'a3', name: 'Queen'}),
  (a4:Artist {id: 'a4', name: 'The Rolling Stones'}),
  (a5:Artist {id: 'a5', name: 'Michael Jackson'}),

  // 3. Criando Músicas
  (s1:Song {id: 's1', title: 'Time'})-[:PERFORMED_BY]->(a1),
  (s2:Song {id: 's2', title: 'Stairway to Heaven'})-[:PERFORMED_BY]->(a2),
  (s3:Song {id: 's3', title: 'Bohemian Rhapsody'})-[:PERFORMED_BY]->(a3),
  (s4:Song {id: 's4', title: 'Paint It Black'})-[:PERFORMED_BY]->(a4),
  (s5:Song {id: 's5', title: 'Billie Jean'})-[:PERFORMED_BY]->(a5),
  
  // Ligando Músicas aos Gêneros
  (s1)-[:IN_GENRE]->(gRock),
  (s2)-[:IN_GENRE]->(gRock),
  (s3)-[:IN_GENRE]->(gRock),
  (s4)-[:IN_GENRE]->(gRock),
  (s5)-[:IN_GENRE]->(gPop),

  // 4. Criando Usuários
  (u1:User {id: 'u1', name: 'Renan'}), // Você!
  (u2:User {id: 'u2', name: 'Carlos'}),
  (u3:User {id: 'u3', name: 'Ana'}),
  (u4:User {id: 'u4', name: 'Bruno'}),

  // 5. Criando Interações (LISTENED_TO, LIKED, FOLLOWS)
  // Renan ouve muito Pink Floyd e Led Zeppelin (Rock)
  (u1)-[:LISTENED_TO {playCount: 45}]->(s1),
  (u1)-[:LISTENED_TO {playCount: 30}]->(s2),
  (u1)-[:LIKED]->(s1),
  (u1)-[:FOLLOWS]->(a1),

  // Carlos tem um gosto parecido com o do Renan (Ouve Pink Floyd e Led Zeppelin)
  // MAS ele também ouve Queen e Rolling Stones! (Eles serão a recomendação)
  (u2)-[:LISTENED_TO {playCount: 50}]->(s1),
  (u2)-[:LISTENED_TO {playCount: 25}]->(s2),
  (u2)-[:LISTENED_TO {playCount: 60}]->(s3), // Queen
  (u2)-[:LISTENED_TO {playCount: 40}]->(s4), // Stones
  (u2)-[:FOLLOWS]->(a3),

  // Ana ouve Queen, Stones e Michael Jackson
  (u3)-[:LISTENED_TO {playCount: 70}]->(s3),
  (u3)-[:LISTENED_TO {playCount: 55}]->(s4),
  (u3)-[:LISTENED_TO {playCount: 90}]->(s5), // Pop
  
  // Bruno ouve só Pop
  (u4)-[:LISTENED_TO {playCount: 100}]->(s5);

// ============================================================================
// PASSO 3: A QUERY DE RECOMENDAÇÃO (O Coração do Desafio)
// Pergunta: "Quais artistas você recomendaria com base nos artistas de rock mais ouvidos?"
// ============================================================================

// A lógica: Encontrar o que os usuários parecidos com o 'Renan' escutam de Rock, 
// que o 'Renan' ainda NÃO escutou.

/*
MATCH (me:User {name: 'Renan'})-[:LISTENED_TO]->(mySong:Song)-[:IN_GENRE]->(:Genre {name: 'Rock'})
MATCH (mySong)-[:PERFORMED_BY]->(myArtist:Artist)

// Encontra outras pessoas que ouviram os mesmos artistas de Rock que eu
MATCH (other:User)-[:LISTENED_TO]->(:Song)-[:PERFORMED_BY]->(myArtist)

// Vê o que MAIS de Rock essas outras pessoas andam escutando
MATCH (other)-[rel:LISTENED_TO]->(recSong:Song)-[:IN_GENRE]->(:Genre {name: 'Rock'})
MATCH (recSong)-[:PERFORMED_BY]->(recArtist:Artist)

// Garante que não vai me recomendar algo que eu já escuto
WHERE NOT (me)-[:LISTENED_TO]->(:Song)-[:PERFORMED_BY]->(recArtist)

// Calcula a relevância somando as vezes que essas outras pessoas ouviram (playCount)
RETURN recArtist.name AS ArtistaRecomendado, 
       SUM(rel.playCount) AS Pontuacao
ORDER BY Pontuacao DESC
LIMIT 5;
*/