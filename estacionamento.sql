CREATE DATABASE IF NOT EXISTS estacionamento CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE estacionamento;

CREATE TABLE cliente (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

INSERT INTO cliente (nome, cpf, telefone, email)
VALUES ('Lucas Silveira', '12345678901', '(11) 99999-0000', 'lucas@email.com');

SELECT * FROM cliente;

CREATE TABLE vaga (
    vaga_id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT UNIQUE NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    ocupada BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO vaga (numero, tipo, ocupada) VALUES
(101, 'CARRO', FALSE),
(102, 'CARRO', FALSE),
(103, 'CARRO', FALSE),
(104, 'CARRO', FALSE);

SELECT * FROM vaga;

CREATE TABLE veiculo (
    veiculo_id INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    cor VARCHAR(30),
    tipo_veiculo VARCHAR(20),
    cliente_id INT NOT NULL,
    vaga_id INT UNIQUE,
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id) ON DELETE CASCADE,
    FOREIGN KEY (vaga_id) REFERENCES vaga(vaga_id)
);

INSERT INTO veiculo (placa, marca, modelo, cor, tipo_veiculo, cliente_id, vaga_id) VALUES
('DEF5678', 'Honda', 'Civic', 'Branco', 'CARRO', 1, 2),
('GHI9012', 'Ford', 'Ka', 'Prata', 'CARRO', 1, 3),
('HGIO234', 'Fiat', 'Palio', 'Branco', 'CARRO', 1, 4);

UPDATE vaga SET ocupada = TRUE WHERE vaga_id = 2;
UPDATE vaga SET ocupada = TRUE WHERE vaga_id = 3;
UPDATE vaga SET ocupada = TRUE WHERE vaga_id = 4;

SELECT * FROM veiculo;

CREATE TABLE funcionario (
    funcionario_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    cargo VARCHAR(30),
    usuario VARCHAR(50) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL
);

INSERT INTO funcionario (nome, cpf, cargo, usuario, senha) VALUES
('Carlos Andrade', '98765432100', 'Atendente', 'carlos.a', 'senha123');

SELECT * FROM funcionario;

CREATE TABLE movimentacao (
    movimentacao_id INT AUTO_INCREMENT PRIMARY KEY,
    data_entrada TIMESTAMP NOT NULL,
    data_saida TIMESTAMP NULL,
    valor_total DECIMAL(10,2),
    cliente_id INT NOT NULL,
    veiculo_id INT NOT NULL,
    funcionario_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id),
    FOREIGN KEY (veiculo_id) REFERENCES veiculo(veiculo_id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionario(funcionario_id)
);

INSERT INTO movimentacao (data_entrada, data_saida, valor_total, cliente_id, veiculo_id, funcionario_id) VALUES
('2025-06-25 08:00:00', '2025-06-25 10:00:00', 25.50, 1, 1, 1),
('2025-06-25 08:00:00', NULL, 0.00, 1, 2, 1),
('2025-06-25 08:00:00', '2025-06-25 12:00:00', 30.00, 1, 3, 1);

SELECT * FROM movimentacao;

CREATE TABLE multa (
    multa_id INT AUTO_INCREMENT PRIMARY KEY,
    data_ocorrencia DATE NOT NULL,
    descricao TEXT,
    valor DECIMAL(10,2),
    status VARCHAR(20) NOT NULL,
    movimentacao_id INT NOT NULL,
    FOREIGN KEY (movimentacao_id) REFERENCES movimentacao(movimentacao_id)
);

INSERT INTO multa (data_ocorrencia, descricao, valor, status, movimentacao_id) VALUES
(CURDATE(), 'Estacionou fora da vaga', 50.00, 'PENDENTE', 1);

SELECT * FROM multa;

CREATE TABLE pagamento (
    pagamento_id INT AUTO_INCREMENT PRIMARY KEY,
    data_pagamento DATE NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    referencia VARCHAR(100),
    movimentacao_id INT UNIQUE NOT NULL,
    FOREIGN KEY (movimentacao_id) REFERENCES movimentacao(movimentacao_id)
);

INSERT INTO pagamento (data_pagamento, valor_pago, forma_pagamento, referencia, movimentacao_id) VALUES
(CURDATE(), 25.50, 'PIX', 'pix-abc123', 1);

SELECT * FROM pagamento;

DROP VIEW IF EXISTS vw_movimentacao_com_multas;

CREATE VIEW vw_movimentacao_com_multas AS
SELECT 
    m.movimentacao_id,
    m.data_entrada,
    m.data_saida,
    m.valor_total,
    m.cliente_id,
    m.veiculo_id,
    m.funcionario_id,
    mu.multa_id,
    mu.data_ocorrencia,
    mu.descricao AS multa_descricao,
    mu.valor AS valor_multa,
    mu.status AS status_multa
FROM movimentacao m
INNER JOIN multa mu ON mu.movimentacao_id = m.movimentacao_id;

SELECT * FROM vw_movimentacao_com_multas;