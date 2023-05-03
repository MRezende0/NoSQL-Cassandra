# Atividade Cassandra - NoSQL
## Matheus Rezende

----

### Para iniciar o projeto, é necessário rodar esses comandos:

```
docker run --rm -d --name cassandra --hostname cassandra --network cassandra cassandra

docker run --rm -it --network cassandra nuvo/docker-cqlsh cqlsh cassandra 9042 --cqlversion="3.4.6"

DESCRIBE KEYSPACES
```

----

### Atividade 01 - Criação do keyspace

```
CREATE KEYSPACE IF NOT EXISTS loja WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };

use loja;
```

----

### Atividade 02 - Criação das duas tabelas (famílias de colunas) referentes às entidades

```
CREATE TABLE IF NOT EXISTS produtos (
  id_produto INT PRIMARY KEY,
  id_fornecedor INT,
  nome TEXT,
  tipo TEXT,
  preco DECIMAL,
  quantidade INT,
  registro TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fornecedores ( 
    id_fornecedor INT PRIMARY KEY, 
    nome TEXT, 
    endereco TEXT, 
    telefone TEXT, 
    email TEXT, 
    registro TIMESTAMP 
);
```

----

### Atividade 03 - Inclusão de pelos menos cinco registros (linhas) em cada uma das tabelas com dados válidos

```
INSERT INTO produtos (id_produto, id_fornecedor, nome, tipo, preco, quantidade, registro) VALUES 
(1, 2, 'Dipirona', 'Comprimido', 9.99, 100, toTimestamp(now())), 
(2, 3, 'Paracetamol', 'Comprimido', 21.99, 50, toTimestamp(now())), 
(3, 1, 'Rivotril', 'Comprimido', 78.99, 37, toTimestamp(now())), 
(4, 5, 'Loratadina', 'Gota', 11.99, 100, toTimestamp(now())), 
(5, 4, 'Vibral', 'Gota', 45.99, 30, toTimestamp(now()));

INSERT INTO fornecedores (id_fornecedor, nome, endereco, telefone, email, registro) VALUES 
(1, 'Unimed', 'Rua A, 123', '5555-1234', 'unimed@example.com', toTimestamp(now())), 
(2, 'Pfizer', 'Rua B, 456', '5555-5678', 'pfizer@example.com', toTimestamp(now())),
(3, 'Laboratório São Francisco', 'Rua C, 789', '5555-9012', 'laboratoriosaofrancisco@example.com', toTimestamp(now())),
(4, 'Johnson & Johnson', 'Rua D, 13579', '5550-2023', 'johnson@example.com', toTimestamp(now())),
(5, 'Laboratório Andrey', 'Rua E, 2468', '5550-1968', 'laboratorioandrey@example.com', toTimestamp(now()));
```

----

### Atividade 04 - Três comandos diferentes de consulta para cada tabela

```
select * from produtos;
SELECT * FROM produtos WHERE preco > 10 ALLOW FILTERING;
SELECT * FROM produtos WHERE nome = 'Paracetamol' ALLOW FILTERING;

select * from fornecedores;
SELECT * FROM fornecedores WHERE id_fornecedor > 2 ALLOW FILTERING;
SELECT * FROM fornecedores WHERE nome = 'Pfizer' ALLOW FILTERING;
```

----

### Atividade 05 - Dois comandos diferentes de exclusão para cada tabela

```
DELETE FROM produtos WHERE id_produto = 2;
DELETE FROM produtos WHERE preco < 10.00;

DELETE FROM fornecedores WHERE id_fornecedor = 2;
DELETE FROM fornecedores WHERE nome = 'Unimed';
```

----

### Atividade 06 - Dois comandos diferentes de alteração para cada tabela

```
ALTER TABLE produtos ADD fabricante text;
ALTER TABLE produtos ALTER nome TYPE varchar;

ALTER TABLE fornecedores ADD celular TEXT;
ALTER TABLE fornecedores ALTER nome TYPE varchar;
```

----

### Atividade 07 - Um comando de alteração de campos para cada tabela

```
ALTER TABLE produtos RENAME fabricante TO marca;

ALTER TABLE fornecedores ALTER telefone TYPE set<text>;
```

----

### Atividade 08 - Como você faria no Cassandra para possibilitar consultas com WHERE em campos das suas tabelas que não sejam a chave primária, sem usar ALLOW FILTERING?Isso implicaria em mudança da estrutura das tabelas? Ou criação de novas tabelas? Pesquise como isso é feito no Cassandra e responda.

No Cassandra, para possibilitar consultas com WHERE em campos que não são a chave primária, é necessário criar um índice secundário (secondary index) para esses campos. Isso permite que consultas com WHERE em campos não chave primária possam ser executadas de forma eficiente, sem a necessidade do uso de ALLOW FILTERING, que pode ter um impacto negativo no desempenho do cluster.

Para criar um índice secundário, é necessário usar o comando CREATE INDEX da seguinte forma:
    CREATE INDEX nome_campo ON nome_tabela (parametro);

No entanto, é importante lembrar que a criação de índices secundários pode ter um impacto negativo no desempenho de gravação no cluster, já que cada gravação precisa atualizar todos os índices secundários relevantes. Além disso, é importante considerar que o uso excessivo de índices secundários pode levar a problemas de escalabilidade e desempenho no Cassandra, e deve ser feito com cuidado. Por isso, é importante avaliar cuidadosamente a necessidade de criar índices secundários em cada caso específico.
