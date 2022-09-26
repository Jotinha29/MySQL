create database egma;

use egma;

CREATE TABLE `egma`.`venda` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cliente_id` INT NOT NULL,
  `desconto` INT NOT NULL,
  `forma_pagamento` INT NOT NULL,
  `data` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `egma`.`nota` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `produto_id` INT NOT NULL,
  `venda_id` INT NULL,
  `quantidade` INT NOT NULL,
  `preco_custo` VARCHAR(45) NOT NULL,
  `preco_unit` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `egma`.`produto` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `preco_venda` DECIMAL(10,2) NOT NULL,
  `min_estoque` SMALLINT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `egma`.`fornecedorxproduto` (
  `fornecedor_id` INT NOT NULL,
  `produto_id` INT NOT NULL,
  `estoque` INT NOT NULL,
  `preco_custo` DECIMAL(10,2) NOT NULL);

CREATE TABLE `egma`.`fornecedor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE nota ADD CONSTRAINT fk_nota_produto FOREIGN KEY (produto_id) REFERENCES produto(id);
ALTER TABLE nota ADD CONSTRAINT fk_nota_venda FOREIGN KEY (venda_id) REFERENCES venda(id);

ALTER TABLE fornecedorxproduto ADD CONSTRAINT fk_fornecedorxproduto_fornedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id);
ALTER TABLE fornecedorxproduto ADD CONSTRAINT fk_fornecedorxproduto_produto FOREIGN KEY (produto_id) REFERENCES produto(id);

CREATE TABLE `egma`.`cliente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE venda ADD CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id);

ALTER TABLE `egma`.`venda` 
ADD COLUMN `vendedor_id` INT NULL AFTER `data`,
CHANGE COLUMN `forma_pagamento` `pagamento_id` INT NOT NULL ,
CHANGE COLUMN `data` `data` DATETIME NOT NULL ;

CREATE TABLE `egma`.`vendedor` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE venda ADD CONSTRAINT fk_venda_vendedor FOREIGN KEY (vendedor_id) REFERENCES vendedor(id);

CREATE TABLE `egma`.`pagamento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `forma_pagamento` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE venda ADD CONSTRAINT fk_venda_pagamento FOREIGN KEY (pagamento_id) REFERENCES pagamento(id);

ALTER TABLE `egma`.`venda` 
DROP FOREIGN KEY `fk_venda_vendedor`;
ALTER TABLE `egma`.`venda` 
CHANGE COLUMN `vendedor_id` `vendedor_id` INT NOT NULL ;
ALTER TABLE `egma`.`venda` 
ADD CONSTRAINT `fk_venda_vendedor`
  FOREIGN KEY (`vendedor_id`)
  REFERENCES `egma`.`vendedor` (`id`);

ALTER TABLE `egma`.`cliente` 
ADD COLUMN `CPF` VARCHAR(45) NOT NULL AFTER `email`;

ALTER TABLE `egma`.`nota` 
ADD COLUMN `cliente_id` INT NOT NULL AFTER `venda_id`,
ADD COLUMN `pagamento_id` INT NOT NULL AFTER `cliente_id`,
ADD COLUMN `vendedor_id` INT NOT NULL AFTER `pagamento_id`;

ALTER TABLE nota ADD CONSTRAINT fk_nota_pagamento FOREIGN KEY (pagamento_id) REFERENCES pagamento(id);
ALTER TABLE nota ADD CONSTRAINT fk_nota_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id);
ALTER TABLE nota ADD CONSTRAINT fk_nota_vendedor FOREIGN KEY (vendedor_id) REFERENCES vendedor(id);

CREATE TABLE `egma`.`vendaxproduto` (
  `venda_id` INT NOT NULL,
  `produto_id` INT NOT NULL);

ALTER TABLE vendaxproduto ADD CONSTRAINT fk_vendaxproduto_venda FOREIGN KEY (venda_id) REFERENCES venda(id);
ALTER TABLE vendaxproduto ADD CONSTRAINT fk_vendaxproduto_produto FOREIGN KEY (produto_id) REFERENCES produto(id);

CREATE TABLE `egma`.`categoria` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE `egma`.`produto` 
ADD COLUMN `categoria_id` INT NOT NULL AFTER `nome`;

ALTER TABLE produto ADD CONSTRAINT fk_produto_categoria FOREIGN KEY (categoria_id) REFERENCES categoria(id);

CREATE TABLE `egma`.`usuario` (
  `cliente_id` INT NOT NULL,
  `usuario` VARCHAR(45) NOT NULL,
  `senha` VARCHAR(45) NOT NULL,
  `endereço` VARCHAR(45) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  `carrinho_id` INT NOT NULL,
  PRIMARY KEY (`cliente_id`));

ALTER TABLE usuario ADD CONSTRAINT fk_usuario_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id);

CREATE TABLE `egma`.`carrinho` (
  `id` INT NOT NULL,
  `entrega_id` INT NOT NULL,
  `venda_id` INT NOT NULL,
  PRIMARY KEY (`carrinho_id`));

ALTER TABLE usuario ADD CONSTRAINT fk_usuario_carrinho FOREIGN KEY (carrinho_id) REFERENCES carrinho(id);
ALTER TABLE carrinho ADD CONSTRAINT fk_carrinho_venda FOREIGN KEY (venda_id) REFERENCES venda(id);

CREATE TABLE `egma`.`entrega` (
  `id` INT NOT NULL,
  `rastreio` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `status_id` INT NOT NULL,
  `carrinho_id` INT NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `egma`.`status` (
  `status_id` INT NOT NULL,
  `data_status` TIMESTAMP NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`status_id`));

ALTER TABLE `egma`.`entrega` 
ADD COLUMN `previsao` DATE NOT NULL AFTER `descricao`,
ADD COLUMN `venda_id` INT NOT NULL AFTER `carrinho_id`;

ALTER TABLE `egma`.`entrega` 
DROP COLUMN `carrinho_id`;

ALTER TABLE carrinho ADD CONSTRAINT fk_carrinho_entrega FOREIGN KEY (entrega_id) REFERENCES entrega(id);
ALTER TABLE entrega ADD CONSTRAINT fk_entrega_venda FOREIGN KEY (venda_id) REFERENCES venda(id);

ALTER TABLE `egma`.`status` 
CHANGE COLUMN `status_id` `id` INT NOT NULL ;

ALTER TABLE entrega ADD CONSTRAINT fk_entrega_status FOREIGN KEY (status_id) REFERENCES status(id);
