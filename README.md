# SQL - VIEW (DB Browser for SQLite)

Pacote do conteúdo **15 - Visões com VIEW**, adaptado para SQLite / DB Browser.

## Arquivos

- `00_exemplos_view.sql` — exemplos do material do professor adaptados.
- `01_exercicios_view.sql` — preparação das tabelas e resolução dos 20 exercícios.
- `README.md` — instruções de execução e publicação.

## Como executar

1. Abra o DB Browser for SQLite.
2. Clique em **New Database** e salve um banco novo, por exemplo `view_exemplos.db`.
3. Entre em **Execute SQL**.
4. Abra `00_exemplos_view.sql`.
5. Clique em **Execute all** e depois em **Write Changes**.
6. Crie outro banco novo, por exemplo `view_exercicios.db`.
7. Abra `01_exercicios_view.sql`, clique em **Execute all** e depois em **Write Changes**.

## IMPORTANTE: bancos separados

Use um banco `.db` novo para cada arquivo SQL. O script de exercícios prepara tabelas próprias e remove objetos de mesmo nome para permitir a execução desde o início. Não execute no banco de outro projeto.

## Diferenças entre MySQL e SQLite

| Material MySQL | Adaptação SQLite |
|---|---|
| `CREATE OR REPLACE VIEW` | `DROP VIEW IF EXISTS` e depois `CREATE VIEW` |
| `SHOW TABLES` / `SHOW FULL TABLES` | Consultar `sqlite_master` |
| `information_schema.views` | `sqlite_master` |
| `SHOW CREATE VIEW` | `SELECT sql FROM sqlite_master WHERE type='view' AND name='...'` |
| Crases para identificadores | Aspas duplas para nomes com espaços |
| `WITH CHECK OPTION` | Não é suportado diretamente; pode ser simulado com trigger |
| UPDATE em views simples | Views SQLite são somente leitura por padrão; triggers `INSTEAD OF` podem encaminhar alterações |

## Observações importantes

- Uma VIEW é uma consulta salva; ela não duplica os dados das tabelas base.
- O SQLite não permite `UPDATE` direto em uma VIEW, mesmo que ela seja simples. No exercício 10, foi criado um trigger `INSTEAD OF UPDATE` para encaminhar a alteração à tabela `Agencia_Cliente`.
- O exercício 12 usa um trigger para impedir que um pacote atualizado deixe de ter vagas disponíveis. Isso reproduz a finalidade do `WITH CHECK OPTION` do material, usando o mecanismo disponível no SQLite.
- Views com `GROUP BY`, `COUNT` ou `SUM` são relatórios agregados e não devem ser atualizadas diretamente.
- A visão de medicamentos válidos compara a data de validade com a data atual do computador usando `date('now')`.
- O SQLite guarda a definição das views em `sqlite_master`.

## Como publicar no GitHub

1. Extraia o ZIP.
2. No repositório da disciplina, crie uma pasta como `15-view`.
3. Adicione os dois arquivos `.sql` e este `README.md`.
4. Faça commit e push ou envie os arquivos pelo site do GitHub.
5. Se o professor pediu os scripts, não é necessário publicar os arquivos `.db`.

## Consultas úteis

```sql
-- Listar views
SELECT name FROM sqlite_master WHERE type = 'view';

-- Consultar definição de uma view
SELECT sql FROM sqlite_master
WHERE type = 'view' AND name = 'vw_relatorio_gerencial';

-- Remover uma view sem apagar tabelas
DROP VIEW IF EXISTS nome_da_view;
```
