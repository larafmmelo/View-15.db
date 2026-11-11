-- 15 - VIEW: 20 exercícios resolvidos
-- Adaptado para SQLite / DB Browser.
-- Execute este arquivo em um BANCO NOVO e separado.

PRAGMA foreign_keys = ON;

-- ============================================================
-- PREPARAÇÃO: tabelas e dados para os exercícios
-- ============================================================

DROP VIEW IF EXISTS vw_pao_disponivel;
DROP VIEW IF EXISTS vw_clientes_padaria;
DROP VIEW IF EXISTS vw_estoque_ingredientes;
DROP VIEW IF EXISTS vw_vendas_dia;
DROP VIEW IF EXISTS vw_media_bebidas;
DROP VIEW IF EXISTS vw_medicamentos_validos;
DROP VIEW IF EXISTS vw_vendas_medicamentos;
DROP VIEW IF EXISTS vw_relatorio_passagens;
DROP VIEW IF EXISTS vw_telefone_cliente;
DROP VIEW IF EXISTS vw_pacotes_com_vagas;
DROP VIEW IF EXISTS vw_produto_estoque_filial;
DROP VIEW IF EXISTS vw_fornecedor_produtos;
DROP VIEW IF EXISTS vw_baixo_estoque;
DROP VIEW IF EXISTS vw_auditoria_vendas;
DROP VIEW IF EXISTS vw_relatorio_gerencial;

DROP TABLE IF EXISTS Padaria_Pao;
DROP TABLE IF EXISTS Padaria_Cliente;
DROP TABLE IF EXISTS Ingrediente;
DROP TABLE IF EXISTS Padaria_Venda;
DROP TABLE IF EXISTS Padaria_Produto;
DROP TABLE IF EXISTS Farmacia_Medicamento;
DROP TABLE IF EXISTS Medicamento_Venda;
DROP TABLE IF EXISTS Agencia_Cliente;
DROP TABLE IF EXISTS Passagem;
DROP TABLE IF EXISTS Pacote_Turistico;
DROP TABLE IF EXISTS Produto;
DROP TABLE IF EXISTS Estoque;
DROP TABLE IF EXISTS Filial;
DROP TABLE IF EXISTS Fornecedor;
DROP TABLE IF EXISTS Venda;

CREATE TABLE Padaria_Pao (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    preco NUMERIC NOT NULL,
    disponivel INTEGER NOT NULL DEFAULT 1
);
INSERT INTO Padaria_Pao VALUES
(1, 'Pão francês', 0.80, 1),
(2, 'Pão integral', 1.50, 1),
(3, 'Pão de forma', 8.00, 0);

CREATE TABLE Padaria_Cliente (
    codigo INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    telefone TEXT
);
INSERT INTO Padaria_Cliente VALUES
(1, 'Mariana', '(31) 99999-1111'),
(2, 'Pedro', '(31) 99999-2222');

CREATE TABLE Ingrediente (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    quantidade_estoque NUMERIC NOT NULL
);
INSERT INTO Ingrediente VALUES
(1, 'Farinha', 25),
(2, 'Açúcar', 10),
(3, 'Fermento', 4);

CREATE TABLE Padaria_Produto (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    categoria TEXT NOT NULL,
    preco NUMERIC NOT NULL
);
INSERT INTO Padaria_Produto VALUES
(1, 'Suco de laranja', 'Bebidas', 7.00),
(2, 'Café', 'Bebidas', 5.00),
(3, 'Bolo', 'Doces', 18.00);

CREATE TABLE Padaria_Venda (
    id INTEGER PRIMARY KEY,
    data_venda TEXT NOT NULL,
    valor_total NUMERIC NOT NULL
);
INSERT INTO Padaria_Venda VALUES
(1, '2026-11-01', 120.00),
(2, '2026-11-01', 80.00),
(3, '2026-11-02', 150.00);

CREATE TABLE Farmacia_Medicamento (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    data_validade TEXT NOT NULL
);
INSERT INTO Farmacia_Medicamento VALUES
(1, 'Analgésico', '2027-05-10'),
(2, 'Antialérgico', '2025-03-01'),
(3, 'Vitamina', '2028-01-15');

CREATE TABLE Medicamento_Venda (
    id INTEGER PRIMARY KEY,
    medicamento_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    FOREIGN KEY (medicamento_id) REFERENCES Farmacia_Medicamento(id)
);
INSERT INTO Medicamento_Venda VALUES
(1, 1, 3), (2, 3, 2);

CREATE TABLE Agencia_Cliente (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    telefone TEXT
);
INSERT INTO Agencia_Cliente VALUES
(1, 'Ana Souza', '(31) 98888-1111'),
(2, 'Bruno Lima', '(31) 98888-2222');

CREATE TABLE Passagem (
    codigo INTEGER PRIMARY KEY,
    passageiro TEXT NOT NULL,
    origem TEXT NOT NULL,
    destino TEXT NOT NULL,
    data_voo TEXT NOT NULL,
    valor NUMERIC NOT NULL
);
INSERT INTO Passagem VALUES
(1, 'Ana Souza', 'Belo Horizonte', 'Recife', '2026-12-10', 850),
(2, 'Bruno Lima', 'Belo Horizonte', 'Salvador', '2026-12-15', 720);

CREATE TABLE Pacote_Turistico (
    id INTEGER PRIMARY KEY,
    destino TEXT NOT NULL,
    vagas_disponiveis INTEGER NOT NULL,
    preco NUMERIC NOT NULL
);
INSERT INTO Pacote_Turistico VALUES
(1, 'Porto Seguro', 8, 1200),
(2, 'Gramado', 0, 1800),
(3, 'Maceió', 5, 1500);

CREATE TABLE Fornecedor (
    cnpj TEXT PRIMARY KEY,
    nome TEXT NOT NULL
);
INSERT INTO Fornecedor VALUES
('11111111000111', 'Fornecedor Alfa'),
('22222222000122', 'Fornecedor Beta');

CREATE TABLE Produto (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    cnpj_fornecedor TEXT,
    FOREIGN KEY (cnpj_fornecedor) REFERENCES Fornecedor(cnpj)
);
INSERT INTO Produto VALUES
(1, 'Notebook', '11111111000111'),
(2, 'Mouse', '11111111000111'),
(3, 'Teclado', '22222222000122');

CREATE TABLE Filial (
    cnpj TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    cidade TEXT NOT NULL
);
INSERT INTO Filial VALUES
('10101010000110', 'Filial Centro', 'Belo Horizonte'),
('20202020000120', 'Filial Sul', 'Contagem');

CREATE TABLE Estoque (
    id_produto INTEGER NOT NULL,
    cnpj_filial TEXT NOT NULL,
    quantidade INTEGER NOT NULL,
    valor NUMERIC NOT NULL,
    PRIMARY KEY (id_produto, cnpj_filial),
    FOREIGN KEY (id_produto) REFERENCES Produto(id),
    FOREIGN KEY (cnpj_filial) REFERENCES Filial(cnpj)
);
INSERT INTO Estoque VALUES
(1, '10101010000110', 2, 3500),
(2, '10101010000110', 20, 80),
(3, '20202020000120', 4, 150);

CREATE TABLE Venda (
    id INTEGER PRIMARY KEY,
    data_venda TEXT NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    valor_unitario NUMERIC NOT NULL
);
INSERT INTO Venda VALUES
(1, '2026-11-01', 1, 1, 3500),
(2, '2026-11-01', 2, 2, 80),
(3, '2026-11-02', 3, 1, 150);

-- ============================================================
-- PADARIA
-- ============================================================

-- EXERCÍCIO 1: nome e preço dos pães disponíveis.
CREATE VIEW vw_pao_disponivel AS
SELECT nome, preco
FROM Padaria_Pao
WHERE disponivel = 1;

-- EXERCÍCIO 2: consultar a visão ordenando pelo nome.
SELECT * FROM vw_pao_disponivel
ORDER BY nome;

-- EXERCÍCIO 3: código, nome e telefone dos clientes.
CREATE VIEW vw_clientes_padaria AS
SELECT codigo, nome, telefone
FROM Padaria_Cliente;

-- EXERCÍCIO 4: nome dos ingredientes e quantidade em estoque.
CREATE VIEW vw_estoque_ingredientes AS
SELECT nome, quantidade_estoque
FROM Ingrediente;

-- EXERCÍCIO 5: valor vendido por dia.
CREATE VIEW vw_vendas_dia AS
SELECT data_venda, SUM(valor_total) AS valor_vendido
FROM Padaria_Venda
GROUP BY data_venda;

-- EXERCÍCIO 6: preço médio dos produtos da categoria Bebidas.
CREATE VIEW vw_media_bebidas AS
SELECT AVG(preco) AS preco_medio
FROM Padaria_Produto
WHERE categoria = 'Bebidas';

-- ============================================================
-- FARMÁCIA
-- ============================================================

-- EXERCÍCIO 7: medicamentos com validade posterior à data atual.
-- As datas estão no formato ISO (AAAA-MM-DD), comparável no SQLite.
CREATE VIEW vw_medicamentos_validos AS
SELECT id, nome, data_validade
FROM Farmacia_Medicamento
WHERE date(data_validade) > date('now');

-- EXERCÍCIO 8: nome do medicamento e quantidade vendida.
CREATE VIEW vw_vendas_medicamentos AS
SELECT m.nome AS medicamento,
       v.quantidade AS quantidade_vendida
FROM Medicamento_Venda AS v
JOIN Farmacia_Medicamento AS m
  ON m.id = v.medicamento_id;

-- ============================================================
-- AGÊNCIA DE VIAGENS
-- ============================================================

-- EXERCÍCIO 9: relatório de passagens com nomes explícitos.
CREATE VIEW vw_relatorio_passagens
(codigo_passagem, nome_passageiro, cidade_origem,
 cidade_destino, data_da_viagem, preco_passagem) AS
SELECT codigo, passageiro, origem, destino, data_voo, valor
FROM Passagem;

-- EXERCÍCIO 10: visão de telefones.
-- SQLite não permite UPDATE diretamente em VIEW.
-- O trigger INSTEAD OF UPDATE encaminha a alteração à tabela base.
CREATE VIEW vw_telefone_cliente AS
SELECT id, nome, telefone
FROM Agencia_Cliente;

CREATE TRIGGER trg_atualiza_telefone_cliente
INSTEAD OF UPDATE OF telefone ON vw_telefone_cliente
BEGIN
    UPDATE Agencia_Cliente
    SET telefone = NEW.telefone
    WHERE id = OLD.id;
END;

-- Exemplo de uso do recurso:
UPDATE vw_telefone_cliente
SET telefone = '(31) 97777-1111'
WHERE id = 1;

-- EXERCÍCIO 11: visão somente de pacotes com vagas disponíveis.
CREATE VIEW vw_pacotes_com_vagas AS
SELECT id, destino, vagas_disponiveis, preco
FROM Pacote_Turistico
WHERE vagas_disponiveis > 0;

-- EXERCÍCIO 12: SQLite não suporta WITH CHECK OPTION.
-- O trigger abaixo permite atualizar a visão, mas bloqueia
-- uma alteração que faça vagas_disponiveis ficar em zero ou menos.
CREATE TRIGGER trg_atualiza_pacote_com_vagas
INSTEAD OF UPDATE OF destino, vagas_disponiveis, preco
ON vw_pacotes_com_vagas
BEGIN
    SELECT CASE
        WHEN NEW.vagas_disponiveis <= 0
        THEN RAISE(ABORT, 'O pacote precisa continuar com vagas disponíveis')
    END;

    UPDATE Pacote_Turistico
    SET destino = NEW.destino,
        vagas_disponiveis = NEW.vagas_disponiveis,
        preco = NEW.preco
    WHERE id = OLD.id;
END;

-- Exemplo válido:
UPDATE vw_pacotes_com_vagas
SET vagas_disponiveis = 6
WHERE id = 1;

-- Para testar a proteção, retire os comentários e execute separadamente:
-- UPDATE vw_pacotes_com_vagas SET vagas_disponiveis = 0 WHERE id = 1;
-- O SQLite deve rejeitar a operação por causa do trigger.

-- ============================================================
-- EMPRESA
-- ============================================================

-- EXERCÍCIO 13: Produto + Estoque + Filial.
CREATE VIEW vw_produto_estoque_filial AS
SELECT p.id AS codigo_produto,
       p.nome AS produto,
       f.nome AS filial,
       f.cidade,
       e.quantidade,
       e.valor
FROM Produto AS p
JOIN Estoque AS e ON e.id_produto = p.id
JOIN Filial AS f ON f.cnpj = e.cnpj_filial;

-- EXERCÍCIO 14: resposta explicativa em comentário.
-- Uma VIEW com SUM(valor) é agregada: cada linha representa um
-- resultado calculado a partir de várias linhas da tabela base.
-- Não há uma única linha original para o SQLite atualizar de forma
-- inequívoca. Por isso, a alteração deve ser feita nas tabelas base.

-- EXERCÍCIO 15: listar todas as visões do banco atual.
-- sqlite_master é o catálogo de metadados do SQLite.
SELECT name AS nome_visao
FROM sqlite_master
WHERE type = 'view'
ORDER BY name;

-- EXERCÍCIO 16: obter o texto completo da visão de fornecedores e produtos.
CREATE VIEW vw_fornecedor_produtos AS
SELECT f.cnpj, f.nome AS fornecedor, p.id AS codigo_produto,
       p.nome AS produto
FROM Fornecedor AS f
LEFT JOIN Produto AS p ON p.cnpj_fornecedor = f.cnpj;

SELECT sql AS definicao_completa
FROM sqlite_master
WHERE type = 'view'
  AND name = 'vw_fornecedor_produtos';

-- EXERCÍCIO 17: SQLite não possui CREATE OR REPLACE VIEW.
-- Alternativa: DROP VIEW IF EXISTS e depois CREATE VIEW novamente.
DROP VIEW IF EXISTS vw_fornecedor_produtos;

CREATE VIEW vw_fornecedor_produtos AS
SELECT f.cnpj, f.nome AS fornecedor,
       f.nome || ' - ' || COALESCE(p.nome, 'Sem produto') AS item_relatorio,
       p.id AS codigo_produto,
       p.nome AS produto
FROM Fornecedor AS f
LEFT JOIN Produto AS p ON p.cnpj_fornecedor = f.cnpj;

-- EXERCÍCIO 18: visão de produtos com estoque baixo.
CREATE VIEW vw_baixo_estoque AS
SELECT p.id, p.nome, e.quantidade, f.nome AS filial
FROM Produto AS p
JOIN Estoque AS e ON e.id_produto = p.id
JOIN Filial AS f ON f.cnpj = e.cnpj_filial
WHERE e.quantidade < 5;

-- Remover somente a visão; a tabela Estoque continua existindo.
DROP VIEW IF EXISTS vw_baixo_estoque;

-- EXERCÍCIO 19: visão de auditoria com GROUP BY e COUNT.
-- É uma visão de consulta/relatório, não deve ser atualizada diretamente.
CREATE VIEW vw_auditoria_vendas AS
SELECT id_produto,
       COUNT(*) AS quantidade_registros,
       SUM(quantidade) AS unidades_vendidas
FROM Venda
GROUP BY id_produto;

-- EXERCÍCIO 20: relatório gerencial de vendas.
CREATE VIEW vw_relatorio_gerencial AS
SELECT v.data_venda,
       p.nome AS produto,
       SUM(v.quantidade) AS unidades_vendidas,
       SUM(v.quantidade * v.valor_unitario) AS faturamento
FROM Venda AS v
JOIN Produto AS p ON p.id = v.id_produto
GROUP BY v.data_venda, p.id, p.nome;

-- ============================================================
-- CONSULTAS PARA CONFERIR OS RESULTADOS
-- ============================================================
SELECT * FROM vw_pao_disponivel ORDER BY nome;
SELECT * FROM vw_clientes_padaria;
SELECT * FROM vw_estoque_ingredientes;
SELECT * FROM vw_vendas_dia;
SELECT * FROM vw_media_bebidas;
SELECT * FROM vw_medicamentos_validos;
SELECT * FROM vw_vendas_medicamentos;
SELECT * FROM vw_relatorio_passagens;
SELECT * FROM vw_telefone_cliente;
SELECT * FROM vw_pacotes_com_vagas;
SELECT * FROM vw_produto_estoque_filial;
SELECT * FROM vw_fornecedor_produtos;
SELECT * FROM vw_auditoria_vendas;
SELECT * FROM vw_relatorio_gerencial;

-- Definições de todas as visões que ainda existem:
SELECT name, sql
FROM sqlite_master
WHERE type = 'view'
ORDER BY name;
