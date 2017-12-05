---Modelo Relacional
CREATE SCHEMA Palcos;
SET search_path to Palcos;

CREATE TABLE Patrocinador(
	cod					integer,
	nome					varchar(40),
	contribuicao				numeric(10,2) CHECK (contribuicao > 0),
	CONSTRAINT patrocinador_pk PRIMARY KEY (cod)
);

CREATE TABLE Edição(
	numero					serial,
	arrecadacao				numeric(20,2),
	ano					numeric(4,0) CHECK (ano > 0),
	n_pessoas				int CHECK (n_pessoas > 0),
	CONSTRAINT edicao_pk PRIMARY KEY (numero)
);

CREATE TABLE Equipamento(
	n_serie					varchar(30),
	nome					varchar(40),
	tipo					varchar(20) 
	CONSTRAINT equipamentos CHECK (
		UPPER(tipo) = 'EFEITO ESPECIAL' OR
		UPPER(tipo) = 'ILUMINAÇÃO' OR
		UPPER(tipo) = 'SOM' OR
		UPPER(tipo) = 'CONTROLE'
	),
	CONSTRAINT equipamento_pk PRIMARY KEY (n_serie)
);
CREATE TABLE Midia(
	nome					varchar(40),
	tipo					varchar(10) check(
							tipo = 'DVD' OR
							tipo = 'CD'
							/*se tiver mais alguma coisa coloca kk*/
						),
	CONSTRAINT midia_pk PRIMARY KEY (nome,tipo)
);

CREATE TABLE Instrumento(
	cod					integer,
	nome_instrumento			varchar(40),
	tipo					varchar(20),--colocar o check dos tipos de equipamentos
	CONSTRAINT Instrumento_pk PRIMARY KEY (cod)
);

CREATE TABLE Artista(
	nome					varchar(40),
	nacionalidade				varchar(20),
	CONSTRAINT artista_pk PRIMARY KEY (nome)
);

CREATE TABLE Banda(
	cod					integer,
	nome					varchar(40),
	genero					varchar(33),
	CONSTRAINT generos CHECK (
		UPPER(genero) = 'Heavy Metal' OR 
		UPPER(genero) = 'MPB' OR 
		UPPER(genero) = 'JAZZ' OR 
		UPPER(genero) = 'POP' OR 
		UPPER(genero) = 'ROCK' OR
		UPPER(genero) = 'WORLD'
	),
	CONSTRAINT banda_pk PRIMARY KEY (cod)
);


CREATE TABLE Hotel (
	nome					varchar(40),
	endereço				varchar(120),
	telefone				varchar(15),
	cod_banda 				integer,
	CONSTRAINT hotel_fk FOREIGN KEY (cod_banda) REFERENCES Banda(cod),
	CONSTRAINT hotel_pk PRIMARY KEY (cod_banda,telefone)
);

CREATE TABLE Funcionario(
	cpf				varchar(11),
	nome				varchar(40),
	sexo				char,
	funcao				varchar(120),
	palco				integer,
	CONSTRAINT funcionario_pk	PRIMARY KEY (cpf,palco)
);

CREATE TABLE Palco(
	nome_palco				varchar(40),
	cod					integer,
	responsavel				varchar(11),
	CONSTRAINT fk_palco FOREIGN KEY (responsavel) REFERENCES funcionario(cpf),
	CONSTRAINT pk_palco PRIMARY KEY (cod,responsavel)
);
ALTER TABLE Funcionario ADD CONSTRAINT funcionario_fk FOREIGN KEY (palco) REFERENCES palco(cod);

CREATE TABLE Apresentacao(
	apresentador				integer,
	cod_palco 				integer,
	inicio					time,
	fim					time,
	dia					date,
	CONSTRAINT apresentacao_fk FOREIGN KEY (apresentador) REFERENCES Banda(cod),
	CONSTRAINT apresentacao_fk1 FOREIGN KEY (cod_palco) REFERENCES Palco(cod),
	CONSTRAINT apresentacao_pk PRIMARY KEY (apresentador,cod_palco,inicio,fim,dia)

);


CREATE TABLE Patrocina(
	patroc					integer,
	edicao					integer,
	CONSTRAINT fk_patr	 	FOREIGN KEY (patroc) REFERENCES patrocinador(cod),
	CONSTRAINT fk_edicao		FOREIGN KEY (edicao) REFERENCES edicao(numero),
	CONSTRAINT pk_patrocina 	PRIMARY KEY (patroc,edicao)	
);

CREATE TABLE Produz (
	midia					varchar(40),
	tipo					varchar(10),
	num_ed					integer,
	CONSTRAINT fk_edicao FOREIGN KEY (num_ed) REFERENCES edicao(numero),
	CONSTRAINT fk_tmidia FOREIGN KEY (tipo) REFERENCES midia(tipo),
	CONSTRAINT fk_nmidia FOREIGN KEY (midia) REFERENCES nidia(nome),
	CONSTRAINT pk_produz PRIMARY KEY (midia,tipo,num_ed)
);


CREATE TABLE Realizada(
	edi 					integer,
	apresentador				integer, 
	palco 					integer,
	inicio					time,
	fim					time,
	dia					date,
	CONSTRAINT fk_realiza 	FOREIGN KEY (ed) 				REFERENCES edicao(numero),
	CONSTRAINT fk_realiza1 	FOREIGN KEY (apresentador) 		REFERENCES apresentacao(apresentador),
	CONSTRAINT fk_realiza2 	FOREIGN KEY (palco) 			REFERENCES apresentacao(cod_palco),
	CONSTRAINT fk_realiza3 	FOREIGN KEY (inicio) 			REFERENCES apresentacao(inicio),
	CONSTRAINT fk_realiza4 	FOREIGN KEY (fim) 			REFERENCES apresentacao(fim),
	CONSTRAINT fk_realiza5 	FOREIGN KEY (dia) 			REFERENCES apresentacao(dia),
	CONSTRAINT pk_realiza  	PRIMARY KEY (edi,banda,apresentador, palco, inicio, fim,dia)
);

CREATE TABLE Utiliza(
	data_ap 				date,
	equipamento 				varchar(30),
	CONSTRAINT utiliza_pk 	PRIMARY KEY (data_ap,equipamento),
	CONSTRAINT utiliza_fk	FOREIGN KEY (data_ap) 		REFERENCES Apresentacao(dia),
	CONSTRAINT utiliza_fk1	FOREIGN KEY (equipamento) 	REFERENCES Equipamento(n_serie)

);

CREATE TABLE Toca_em(
	artista 			varchar(40),
	banda				integer,
	CONSTRAINT toca_em_pk 	PRIMARY KEY (artista,banda),
	CONSTRAINT toca_em_fk	FOREIGN KEY (artista) 	REFERENCES Artista(nome),
	CONSTRAINT toca_em_fk1	FOREIGN KEY (banda) 	REFERENCES Banda(cod)
	
);

CREATE TABLE Toca (
	artista				varchar(40),
	insts 				integer,
	CONSTRAINT toca_pk 	PRIMARY KEY (artista,insts),
	CONSTRAINT toca_fk	FOREIGN KEY (artista) 	REFERENCES Artista(nome),
	CONSTRAINT toca_fk1	FOREIGN KEY (insts) 	REFERENCES instrumento(cod)
);

CREATE TABLE Apresenta (
	banda 				integer,
	palco 				integer,
	apresentador			integer, 
	ap_palco 			integer,
	dia				date,
	inicio				time,
	fim				time,
	CONSTRAINT apresenta_pk	PRIMARY KEY (artista,banda,apresentador,dia,inicio,fim,palco),
	CONSTRAINT toca_em_fk1	FOREIGN KEY (banda) 		REFERENCES Banda(cod),
	CONSTRAINT toca_em_fk2	FOREIGN KEY (palco) 		REFERENCES Palco(cod),
	CONSTRAINT toca_em_fk3	FOREIGN KEY (apresentador) 	REFERENCES Apresentacao(apresentador),
	CONSTRAINT toca_em_fk4	FOREIGN KEY (ap_palco) 		REFERENCES Apresentacao(cod_palco),
	CONSTRAINT toca_em_fk5	FOREIGN KEY (dia) 		REFERENCES Apresentacao(dia),
	CONSTRAINT toca_em_fk6	FOREIGN KEY (inicio) 		REFERENCES Apresentacao(hora_inicio),
	CONSTRAINT toca_em_fk7	FOREIGN KEY (fim) 		REFERENCES Apresentacao(horafim)
);

CREATE TABLE Funcionario(
	cpf				varchar(11),
	nome				varchar(40),
	sexo				char,
	funcao				varchar(120),
	palco				integer,
	CONSTRAINT funcionario_fk 	FOREIGN KEY (palco) REFERENCES palco(cod),
	CONSTRAINT funcionario_pk	PRIMARY KEY (cpf),
	CONSTRAINT funcionario_pk1	PRIMARY KEY (palco)
);


CREATE TABLE Trabalha(
	palco				integer,
	cpf 				varchar(11),
	CONSTRAINT trabalha_pk 	PRIMARY KEY (palco,cpf),
	CONSTRAINT trabalha_fk 	FOREIGN KEY (palco) REFERENCES palco(cod),
	CONSTRAINT trabalha_fk 	FOREIGN KEY (cpf) REFERENCES funcionario(cpf)
);
