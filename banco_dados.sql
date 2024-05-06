-- Criação do banco de dados
-- Criação da tabela de usuários
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    email VARCHAR(100)
);

-- Criação da tabela de registros de login
CREATE TABLE registros_login (
    id SERIAL PRIMARY KEY,
    usuario_id INT,
    data_hora TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Inserindo dados na tabela de usuários
INSERT INTO usuarios (nome, email) VALUES
('João', 'joao@email.com'),
('Maria', 'maria@email.com');

-- Inserindo dados na tabela de registros de login
INSERT INTO registros_login (usuario_id, data_hora) VALUES
(1, NOW()),
(2, NOW());

-- Criando um trigger para registrar quando um novo usuário é adicionado
CREATE OR REPLACE FUNCTION registrar_novo_usuario()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO registros_login (usuario_id, data_hora)
    VALUES (NEW.id, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Associando o trigger à tabela de usuários
CREATE TRIGGER novo_usuario_trigger
AFTER INSERT ON usuarios
FOR EACH ROW
EXECUTE FUNCTION registrar_novo_usuario();

-- Verificando os dados na tabela de registros de login
SELECT * FROM registros_login;
