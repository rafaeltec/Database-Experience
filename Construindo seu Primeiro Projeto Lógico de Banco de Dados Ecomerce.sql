-- Replique a modelagem do projeto lógico de banco de dados para o cenário de e-commerce.
create database ecomerce;
use ecomerce;

-- Criação da tabela Clientes
CREATE TABLE Clientes (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    endereco TEXT,
    telefone VARCHAR(20)
);
select * from clientes;
drop table Clientes;



-- Criação da tabela Categorias
CREATE TABLE Categorias (
    categoria_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) UNIQUE NOT NULL
);
select * from categorias;
drop table Categorias;



-- Criação da tabela Produtos
CREATE TABLE Produtos (
    produto_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL,
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id)
);
select * from produtos;
drop table produtos;



-- Criação da tabela Pedidos
CREATE TABLE Pedidos (
    pedido_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    data DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pendente', 'Concluído', 'Cancelado') DEFAULT 'Pendente',
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);
select * from pedidos;
drop table pedidos;





-- Criação da tabela ItensPedido
CREATE TABLE ItensPedido (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(produto_id)
);
select * from itenspedido;

drop table ItensPedido;



-- Criação da tabela Pagamento
CREATE TABLE Pagamento (
    pagamento_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT UNIQUE NOT NULL,
    tipo ENUM('Cartão de Crédito', 'Boleto', 'PayPal') NOT NULL,
    status ENUM('Pendente', 'Concluído', 'Cancelado') DEFAULT 'Pendente',
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id)
);


select * from Pagamento;
drop table Pagamento;




-- Refine o modelo apresentado :( "vou ter que dropar todas tabelas :(" acrescentando os seguintes pontos 
-- Cliente PJ e PF – Uma conta pode ser PJ ou PF, mas não pode ter as duas informações;
-- Pagamento – Pode ter cadastrado mais de uma forma de pagamento;
--  Entrega – Possui status e código de rastreio;

-- REFINANDO 
-- ______________________________________________________________________________________________________________________________________________________________________

-- Criação da tabela Clientes (Refinada)

CREATE TABLE Clientes (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    endereco TEXT,
    telefone VARCHAR(20),
    tipo ENUM('PF', 'PJ') NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL
);
select* from Clientes;




-- Criação da tabela FormasPagamento
CREATE TABLE FormasPagamento (
    forma_id INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('Cartão de Crédito', 'Boleto', 'PayPal') NOT NULL,
    cliente_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);
select * from FormasPagamento;




-- Criação da tabela Entrega

CREATE TABLE Entrega (
    entrega_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT UNIQUE NOT NULL,
    estatus ENUM('Pendente', 'Em Trânsito', 'Entregue') DEFAULT 'Pendente',
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id)
);
select * from entrega;
drop table Entrega;

-- Populando a tabela Entrega  ATENÇÂO Só podemos inserir onde pedido_id tenha algum valor numerico ! por isso consultei para verificar se tinha pedidos e retornou 5 / 6 /7
INSERT INTO Entrega (pedido_id, estatus, codigo_rastreio)
VALUES (5, 'Pendente', 'ABC123'),
       (6, 'Em Trânsito', 'DEF456'),
       (7, 'Entregue', 'GHI789');

INSERT INTO Entrega (pedido_id, estatus, codigo_rastreio) VALUES
(1, 'Pendente', 'RA123456789BR'),
(2, 'Em Trânsito', 'RB123456789BR'),
(3, 'Entregue', 'RC123456789BR'),
(4, 'Pendente', 'RD123456789BR'),
(5, 'Em Trânsito', 'RE123456789BR'),
(6, 'Entregue', 'RF123456789BR'),
(7, 'Pendente', 'RG123456789BR'),
(8, 'Em Trânsito', 'RH123456789BR'),
(9, 'Entregue', 'RI123456789BR'),
(10, 'Pendente', 'RJ123456789BR');




-- TODAS TABELAS CRIADAS E REFINADAS !
-- Queries para Popular as Novas Tabelas



-- Populando a tabela Clientes (Refinada)
INSERT INTO Clientes (nome, email, senha, endereco, telefone, tipo, cpf_cnpj) VALUES
('João Silva', 'joao@email.com', 'senha123', 'Rua A, 123', '11987654321', 'PF', '123.456.789-00');
SELECT * FROM Clientes WHERE tipo = 'PF';
INSERT INTO Clientes (nome, email, senha, endereco, telefone, tipo, cpf_cnpj) VALUES
('ricardo teles', 'ricardotetinha@email.com', 'dffea123', 'Rua cataaA, 223', '11332354321', 'PJ', '123.436.749-50');
select * from clientes;
SELECT * FROM Clientes WHERE tipo = 'PF';
SELECT * FROM Clientes WHERE tipo = 'PJ';




-- Populando a tabela FormasPagamento
INSERT INTO FormasPagamento (tipo, cliente_id) VALUES
('Cartão de Crédito', 1),
('Boleto', 1);



SELECT * FROM Entrega WHERE status = 'Pendente';

-- Populando a tabela Categorias
INSERT INTO Categorias (nome) VALUES
('Eletrônicos'),
('Roupas'),
('Livros');
SELECT * FROM Produtos WHERE categoria_id = (SELECT categoria_id FROM Categorias WHERE nome = 'Eletrônicos');

-- Populando a tabela Produtos
INSERT INTO Produtos (nome, descricao, preco, estoque, categoria_id) VALUES
('iPhone 13', 'Smartphone da Apple', 7999.99, 20, 1),
('Camiseta Polo', 'Camiseta masculina', 59.99, 50, 2);
SELECT * FROM Produtos WHERE estoque < 10;
SELECT * FROM Categorias;

-- Populando a tabela Pedidos PENDENTE_____________________________________________________________
INSERT INTO Pedidos (cliente_id, status) VALUES
(1, 'Pendente');
INSERT INTO Pedidos (cliente_id, status) VALUES
(4, 'Concluído');
INSERT INTO Pedidos (cliente_id, status) VALUES
(65, 'Concluído');

select * from pedidos;
SELECT * FROM Pedidos WHERE cliente_id = 1;
SELECT * FROM Pedidos WHERE status = 'Concluído';

-- Populando a tabela ItensPedido
INSERT INTO ItensPedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 7999.99),
(1, 2, 2, 59.99);



-- Populando a tabela FormasPagamento
INSERT INTO FormasPagamento (tipo, cliente_id) VALUES
('Cartão de Crédito', 1),
('Boleto', 1);
SELECT * FROM FormasPagamento WHERE cliente_id = 1;

-- TESTANDO QUERIES____________________________________________________________________________________

-- Algumas das perguntas que podes fazer para embasar as queries SQL:

    -- Quantos pedidos foram feitos por cada cliente?

SELECT cliente_id, COUNT(*) AS numero_de_pedidos
FROM Pedidos
GROUP BY cliente_id;

    
    -- Algum vendedor também é fornecedor?
    
    -- Criação da tabela Vendedores
CREATE TABLE Vendedores (
    vendedor_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20)
);
-- Criação da tabela Fornecedores
CREATE TABLE Fornecedores (
    fornecedor_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20)
);

-- Populando a tabela Vendedores
INSERT INTO Vendedores (nome, email, cpf_cnpj, telefone) VALUES
('João Silva', 'joao.vendedor@email.com', '123.456.789-00', '11987654321'),
('Maria Oliveira', 'maria.vendedor@email.com', '987.654.321-00', '11987654322');

-- Populando a tabela Fornecedores
INSERT INTO Fornecedores (nome, email, cpf_cnpj, telefone) VALUES
('Carlos Souza', 'carlos.fornecedor@email.com', '111.222.333-44', '11987654323'),
('Ana Pereira', 'ana.fornecedor@email.com', '555.666.777-88', '11987654324');

-- tive que repetir o João Silva em fornecedor sendo que ele já é vendedor, para poder funcionar a querie
INSERT INTO Fornecedores (nome, email, cpf_cnpj, telefone) VALUES
('João Silva', 'joao.vendedor@email.com', '123.456.789-00', '11987654321');

-- ASSIM RESPONDENDO A PERGUNTA ANTERIOR  -- Algum vendedor também é fornecedor?

SELECT V.nome AS Vendedor, F.nome AS Fornecedor
FROM Vendedores V
INNER JOIN Fornecedores F ON V.email = F.email;

SELECT V.nome AS Vendedor, F.nome AS Fornecedor
FROM Vendedores V
INNER JOIN Fornecedores F ON V.cpf_cnpj = F.cpf_cnpj;


    
    -- Relação de produtos, fornecedores e estoques;
    
    
    
    -- Criação da tabela ProdutoFornecedor
CREATE TABLE ProdutoFornecedor (
    produto_id INT,
    fornecedor_id INT,
    PRIMARY KEY (produto_id, fornecedor_id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(produto_id),
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(fornecedor_id)
);
select * from ProdutoFornecedor;

-- Populando a tabela ProdutoFornecedor

-- Inserir dados na tabela ProdutoFornecedor
INSERT INTO ProdutoFornecedor (produto_id, fornecedor_id)
VALUES (1, 1), -- Associa o produto com ID 1 ao fornecedor com ID 101
       (2, 2); -- Associa o produto com ID 2 ao fornecedor com ID 102
      



SELECT P.nome AS Produto, F.nome AS Fornecedor, P.estoque AS Estoque
FROM Produtos P
INNER JOIN ProdutoFornecedor PF ON P.produto_id = PF.produto_id
INNER JOIN Fornecedores F ON PF.fornecedor_id = F.fornecedor_id;


   
    
    
    -- Relação de nomes dos fornecedores e nomes dos produtos;
    
SELECT F.nome AS Fornecedor, P.nome AS Produto
FROM Fornecedores F
INNER JOIN ProdutoFornecedor PF ON F.fornecedor_id = PF.fornecedor_id
INNER JOIN Produtos P ON PF.produto_id = P.produto_id;



