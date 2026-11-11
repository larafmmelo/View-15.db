-- 15 - VIEW: exemplos adaptados para SQLite / DB Browser
-- Execute em um BANCO NOVO, separado dos demais trabalhos.

PRAGMA foreign_keys = ON;

-- ------------------------------------------------------------
-- Preparação das tabelas usadas nos exemplos
-- ------------------------------------------------------------
DROP VIEW IF EXISTS vw_produtos_ativos;
DROP VIEW IF EXISTS vw_resumo_fornecedor;
DROP VIEW IF EXISTS vw_valor_estoque;
DROP VIEW IF EXISTS vw_contatos_fornecedor;
DROP VIEW IF EXISTS vw_produto_estoque;
DROP VIEW IF EXISTS vw_total_por_fornecedor;
DROP TABLE IF EXISTS Estoque;
DROP TABLE IF EXISTS Produto;
DROP TABLE IF EXISTS Fornecedor;

CREATE TABLE Fornecedor (
    cnpj TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    telefone TEXT
);

CREATE TABLE Produto (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    cnpj_fornecedor TEXT,
    ativo INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (cnpj_fornecedor) REFERENCES Fornecedor(cnpj)
);

CREATE TABLE Estoque (
    id_produto INTEGER,
    cnpj_filial TEXT,
    quantidade INTEGER NOT NULL DEFAULT 0,
    preco NUMERIC NOT NULL DEFAULT 0,
    PRIMARY KEY (id_produto, cnpj_filial),
    FOREIGN KEY (id_produto) REFERENCES Produto(id)
);

INSERT INTO Fornecedor VALUES
('11111111000111', 'Fornecedor Alfa', '(31) 3333-1111'),
('22222222000122', 'Fornecedor Beta', '(31) 3333-2222');

INSERT INTO Produto VALUES
(1, 'Caderno', '11111111000111', 1),
(2, 'Caneta', '11111111000111', 1),
(3, 'Agenda', '22222222000122', 0);

INSERT INTO Estoque VALUES
(1, '10101010000110', 10, 20.00),
(2, '10101010000110', 50, 3.50),
(1, '30303030000130', 5, 21.00);

-- ------------------------------------------------------------
-- 1. Visão com JOIN e filtro
-- ------------------------------------------------------------
CREATE VIEW vw_produtos_ativos AS
SELECT p.id, p.nome, e.cnpj_filial, e.preco, p.cnpj_fornecedor
FROM Produto AS p
JOIN Estoque AS e ON e.id_produto = p.id
WHERE p.ativo = 1;

SELECT * FROM vw_produtos_ativos;

-- Consultar uma VIEW como se fosse tabela
SELECT nome, preco
FROM vw_produtos_ativos
ORDER BY nome;

-- ------------------------------------------------------------
-- 2. Nomes explícitos para as colunas da visão
-- ------------------------------------------------------------
CREATE VIEW vw_resumo_fornecedor
(codigo, nome_fornecedor, quantidade_produtos) AS
SELECT f.cnpj, f.nome, COUNT(p.id)
FROM Fornecedor AS f
LEFT JOIN Produto AS p ON p.cnpj_fornecedor = f.cnpj
GROUP BY f.cnpj, f.nome;

SELECT * FROM vw_resumo_fornecedor;

-- ------------------------------------------------------------
-- 3. Visão com nomes de colunas contendo espaços
-- No SQLite, use aspas duplas para identificadores.
-- ------------------------------------------------------------
DROP VIEW vw_resumo_fornecedor;

CREATE VIEW vw_resumo_fornecedor
(codigo, "nome do fornecedor", "quantidade de produtos") AS
SELECT f.cnpj, f.nome, COUNT(p.id)
FROM Fornecedor AS f
LEFT JOIN Produto AS p ON p.cnpj_fornecedor = f.cnpj
GROUP BY f.cnpj, f.nome;

SELECT * FROM vw_resumo_fornecedor;

-- ------------------------------------------------------------
-- 4. Visão com agregação e alias
-- ------------------------------------------------------------
CREATE VIEW vw_valor_estoque AS
SELECT id_produto,
       SUM(quantidade * preco) AS valor_total
FROM Estoque
GROUP BY id_produto;

SELECT * FROM vw_valor_estoque
ORDER BY valor_total DESC;

-- ------------------------------------------------------------
-- 5. Visão simples
-- ------------------------------------------------------------
CREATE VIEW vw_contatos_fornecedor AS
SELECT cnpj, nome, telefone
FROM Fornecedor;

SELECT * FROM vw_contatos_fornecedor;

-- ------------------------------------------------------------
-- 6. Visão baseada em JOIN
-- ------------------------------------------------------------
CREATE VIEW vw_produto_estoque AS
SELECT p.id, p.nome, e.cnpj_filial, e.quantidade, e.preco
FROM Produto AS p
JOIN Estoque AS e ON e.id_produto = p.id;

SELECT * FROM vw_produto_estoque;

-- ------------------------------------------------------------
-- 7. Visão agregada
-- ------------------------------------------------------------
CREATE VIEW vw_total_por_fornecedor AS
SELECT cnpj_fornecedor,
       COUNT(*) AS quantidade_produtos
FROM Produto
GROUP BY cnpj_fornecedor;

SELECT * FROM vw_total_por_fornecedor
ORDER BY quantidade_produtos DESC;

-- ------------------------------------------------------------
-- 8. Substituir uma VIEW
-- SQLite não possui CREATE OR REPLACE VIEW.
-- A alternativa é apagar e criar novamente.
-- ------------------------------------------------------------
DROP VIEW vw_produtos_ativos;

CREATE VIEW vw_produtos_ativos AS
SELECT p.id, p.nome, e.cnpj_filial, e.preco,
       p.cnpj_fornecedor
FROM Produto AS p
JOIN Estoque AS e ON e.id_produto = p.id
WHERE p.ativo = 1;

SELECT * FROM vw_produtos_ativos;

-- ------------------------------------------------------------
-- 9. Consultar metadados e definição das views
-- ------------------------------------------------------------
SELECT name AS nome_visao, sql AS definicao
FROM sqlite_master
WHERE type = 'view'
ORDER BY name;

-- ------------------------------------------------------------
-- 10. Remover uma VIEW sem apagar tabela base
-- ------------------------------------------------------------
DROP VIEW IF EXISTS vw_total_por_fornecedor;
SELECT * FROM Produto;
