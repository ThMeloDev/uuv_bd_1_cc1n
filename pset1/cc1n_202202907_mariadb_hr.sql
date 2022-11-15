#CREATE USER AND DATABASE

CREATE USER 'thiago'@'localhost' IDENTIFIED BY 'computacao@raiz';

GRANT CREATE, ALTER, INSERT, SELECT on *.* TO 'thiago'@'localhost';
FLUSH PRIVILEGES;

CREATE DATABASE uvv;

#CHANGE USER
system mysql -u thiago -p;

#CHOOSE DATABASE
use uvv;

CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo DECIMAL(8,2),
                salario_maximo DECIMAL(8,2),
                PRIMARY KEY (id_cargo)
);

ALTER TABLE cargos COMMENT 'Tabela que armazena cargos dos empregados';

ALTER TABLE cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Identificador do cargo';

ALTER TABLE cargos MODIFY COLUMN cargo VARCHAR(35) COMMENT 'Nome do cargo';

ALTER TABLE cargos MODIFY COLUMN salario_minimo DECIMAL(8, 2) COMMENT 'Salario mínimo do cargo';

ALTER TABLE cargos MODIFY COLUMN salario_maximo DECIMAL(8, 2) COMMENT 'Salário máximo do cargo';


CREATE UNIQUE INDEX cargos_cargo_uniquekey
 ON cargos
 ( cargo );

CREATE TABLE regioes (
                id_regiao INT AUTO_INCREMENT NOT NULL,
                nome VARCHAR(25) NOT NULL,
                PRIMARY KEY (id_regiao)
);

ALTER TABLE regioes COMMENT 'Tabela que armazena regiões';

ALTER TABLE regioes MODIFY COLUMN id_regiao INTEGER COMMENT 'identificador da região';

ALTER TABLE regioes MODIFY COLUMN nome VARCHAR(25) COMMENT 'nome da região';


CREATE UNIQUE INDEX regioes_nome_uniquekey
 ON regioes
 ( nome );

CREATE TABLE paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INT,
                PRIMARY KEY (id_pais)
);

ALTER TABLE paises COMMENT 'Tabela que armazena paises';

ALTER TABLE paises MODIFY COLUMN id_pais CHAR(2) COMMENT 'Identificador do país';

ALTER TABLE paises MODIFY COLUMN nome VARCHAR(50) COMMENT 'nome do país';

ALTER TABLE paises MODIFY COLUMN id_regiao INTEGER COMMENT 'Chave estrangeira da tabela regiões que referencia';


CREATE UNIQUE INDEX paises_nome_uniquekey
 ON paises
 ( nome );

CREATE TABLE localizacoes (
                id_localizacao INT NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12) NOT NULL,
                cidade VARCHAR(50) NOT NULL,
                uf VARCHAR(25) NOT NULL,
                id_pais CHAR(2) NOT NULL,
                PRIMARY KEY (id_localizacao)
);

ALTER TABLE localizacoes COMMENT 'Tabela que armazena localizações';

ALTER TABLE localizacoes MODIFY COLUMN id_localizacao INTEGER COMMENT 'Identificador da localização';

ALTER TABLE localizacoes MODIFY COLUMN cep VARCHAR(12) COMMENT 'Cep da localização';

ALTER TABLE localizacoes MODIFY COLUMN cidade VARCHAR(50) COMMENT 'Cidade da localização';

ALTER TABLE localizacoes MODIFY COLUMN uf VARCHAR(25) COMMENT 'UF da localização';

ALTER TABLE localizacoes MODIFY COLUMN id_pais CHAR(2) COMMENT 'Chave estrangeira da tabela paises que referencia um pais';


CREATE TABLE departamentos (
                id_departamento INT NOT NULL,
                nome VARCHAR(50),
                id_localizacao INT,
                id_gerente INT,
                PRIMARY KEY (id_departamento)
);

ALTER TABLE departamentos COMMENT 'Tabela que armazena empregados';

ALTER TABLE departamentos MODIFY COLUMN id_departamento INTEGER COMMENT 'Identificador do departamento';

ALTER TABLE departamentos MODIFY COLUMN id_localizacao INTEGER COMMENT 'Chave estrangeira da tabela localização que referencia a localização do departamento';

ALTER TABLE departamentos MODIFY COLUMN id_gerente INTEGER COMMENT 'Chave estrangeira da tabela empregados que referencia o gerente do departamento';


CREATE UNIQUE INDEX departamentos_nome_uniquekey
 ON departamentos
 ( nome );

CREATE TABLE empregados (
                id_empregado INT NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario DECIMAL(8,2),
                comissao DECIMAL(4,2),
                id_departamento INT,
                id_supervisor INT,
                PRIMARY KEY (id_empregado)
);

ALTER TABLE empregados COMMENT 'Tabela de empregados';

ALTER TABLE empregados MODIFY COLUMN id_empregado INTEGER COMMENT 'Identificador do empregado';

ALTER TABLE empregados MODIFY COLUMN nome VARCHAR(75) COMMENT 'nome do empregado';

ALTER TABLE empregados MODIFY COLUMN email VARCHAR(35) COMMENT 'E-mail do empregado';

ALTER TABLE empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'Telefone do empregado';

ALTER TABLE empregados MODIFY COLUMN data_contratacao DATE COMMENT 'Data de contratação do empregado';

ALTER TABLE empregados MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Chave estrageira da tabela cargo que referencia o cargo do empregado';

ALTER TABLE empregados MODIFY COLUMN id_departamento INTEGER COMMENT 'Chave estrangeira referente a tabela departamento que referencia qual departamento o empregado pertence';

ALTER TABLE empregados MODIFY COLUMN id_supervisor INTEGER COMMENT 'Chave estrangeira da própria tabela (auto-relacionamento) que indica, caso tenha, o supervisor do empregado';


CREATE UNIQUE INDEX empregados_email_uniquekey
 ON empregados
 ( email );

CREATE TABLE historico_cargos (
                data_inicial DATE NOT NULL,
                id_empregado INT NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INT,
                PRIMARY KEY (data_inicial, id_empregado)
);

ALTER TABLE historico_cargos COMMENT 'Tabela que armazena histórico do empregado em cada cargo';

ALTER TABLE historico_cargos MODIFY COLUMN data_inicial DATE COMMENT 'Data do inicial do histórico';

ALTER TABLE historico_cargos MODIFY COLUMN id_empregado INTEGER COMMENT 'Identificador do empregado';

ALTER TABLE historico_cargos MODIFY COLUMN data_final DATE COMMENT 'Data final do histórico';

ALTER TABLE historico_cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Chave estrageira da tabela cargo que referencia o cargo';

ALTER TABLE historico_cargos MODIFY COLUMN id_departamento INTEGER COMMENT 'Chave estrangeira da tabela departamentos que identifica o departamento que o empregado está/estava trabalhando';

#INSERTS regioes
INSERT INTO regioes VALUES ( 1, 'Europe');
INSERT INTO regioes VALUES ( 2, 'Americas');
INSERT INTO regioes VALUES ( 3, 'Asia' );
INSERT INTO regioes VALUES ( 4, 'Middle East and Africa' );

#INSERTS paises
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('AR', 2, 'Argentina');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('AU', 3, 'Australia');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('BE', 1, 'Belgium');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('BR', 2, 'Brazil');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('CA', 2, 'Canada');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('CH', 1, 'Switzerland');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('CN', 3, 'China');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('DE', 1, 'Germany');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('DK', 1, 'Denmark');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('EG', 4, 'Egypt');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('FR', 1, 'France');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('IL', 4, 'Israel');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('IN', 3, 'India');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('IT', 1, 'Italy');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('JP', 3, 'Japan');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('KW', 4, 'Kuwait');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('ML', 3, 'Malaysia');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('MX', 2, 'Mexico');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('NG', 4, 'Nigeria');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('NL', 1, 'Netherlands');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('SG', 3, 'Singapore');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('UK', 1, 'United Kingdom');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('US', 2, 'United States of America');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('ZM', 4, 'Zambia');
INSERT INTO paises (id_pais, id_regiao, nome) VALUES ('ZW', 4, 'Zimbabwe');

#INSERTS localizacoes
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1000, '1297 Via Cola di Rie', '00989', 'Roma', '', 'IT');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1100, '93091 Calle della Testa', '10934', 'Venice', '', 'IT');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1300, '9450 Kamiya-cho', '6823', 'Hiroshima', '', 'JP');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1900, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2000, '40-5-12 Laogianggen', '190518', 'Beijing', '', 'CN');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2300, '198 Clementi North', '540198', 'Singapore', '', 'SG');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2400, '8204 Arthur St', '', 'London', '', 'UK');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2600, '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2800, 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (3100, 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal,', 'MX');

#INSERTS cargos
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'AD_PRES', 'President', 20080, 40000);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'FI_MGR', 'Finance Manager', 8200, 16000);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'FI_ACCOUNT', 'Accountant', 4200, 9000  );
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'AC_MGR', 'Accounting Manager', 8200, 16000);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'AC_ACCOUNT', 'Public Accountant', 4200, 9000);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'SA_MAN', 'Sales Manager', 10000, 20080 );
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'SA_REP', 'Sales Representative', 6000, 12008 );
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'PU_MAN', 'Purchasing Manager', 8000, 15000);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'PU_CLERK', 'Purchasing Clerk', 2500, 5500 );
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'ST_CLERK', 'Stock Clerk', 2008, 5000 );
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'SH_CLERK', 'Shipping Clerk', 2500, 5500);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'IT_PROG', 'Programmer', 4000, 10000 );
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'MK_MAN', 'Marketing Manager', 9000, 15000   );
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'MK_REP', 'Marketing Representative', 4000, 9000);
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'HR_REP', 'Human Resources Representative', 4000, 9000 );
INSERT INTO cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'PR_REP', 'Public Relations Representative', 4500, 10500 );

#INSERTS empregados

INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                100,
                'Steven King',
                'SKING',
                '515.123.4567',
                STR_TO_DATE('17,06,2003', '%d,%m,%Y'),
                'AD_PRES',
                24000,
                NULL,
                NULL,
                90
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                101,
                'Neena Kochhar',
                'NKOCHHAR',
                '515.123.4568',
                STR_TO_DATE('21,09,2005', '%d,%m,%Y'),
                'AD_VP',
                17000,
                NULL,
                100,
                90
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                102,
                'Lex De Haan',
                'LDEHAAN',
                '515.123.4569',
                STR_TO_DATE('13,01,2001', '%d,%m,%Y'),
                'AD_VP',
                17000,
                NULL,
                100,
                90
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                103,
                'Alexander Hunold',
                'AHUNOLD',
                '590.423.4567',
                STR_TO_DATE('03,01,2006', '%d,%m,%Y'),
                'IT_PROG',
                9000,
                NULL,
                102,
                60
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                104,
                'Bruce Ernst',
                'BERNST',
                '590.423.4568',
                STR_TO_DATE('21,05,2007', '%d,%m,%Y'),
                'IT_PROG',
                6000,
                NULL,
                103,
                60
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                105,
                'David Austin',
                'DAUSTIN',
                '590.423.4569',
                STR_TO_DATE('25,06,2005', '%d,%m,%Y'),
                'IT_PROG',
                4800,
                NULL,
                103,
                60
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                106,
                'Valli Pataballa',
                'VPATABAL',
                '590.423.4560',
                STR_TO_DATE('05,02,2006', '%d,%m,%Y'),
                'IT_PROG',
                4800,
                NULL,
                103,
                60
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                107,
                'Diana Lorentz',
                'DLORENTZ',
                '590.423.5567',
                STR_TO_DATE('07,02,2007', '%d,%m,%Y'),
                'IT_PROG',
                4200,
                NULL,
                103,
                60
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                108,
                'Nancy Greenberg',
                'NGREENBE',
                '515.124.4569',
                STR_TO_DATE('17,08,2002', '%d,%m,%Y'),
                'FI_MGR',
                12008,
                NULL,
                101,
                100
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                109,
                'Daniel Faviet',
                'DFAVIET',
                '515.124.4169',
                STR_TO_DATE('16,08,2002', '%d,%m,%Y'),
                'FI_ACCOUNT',
                9000,
                NULL,
                108,
                100
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                110,
                'John Chen',
                'JCHEN',
                '515.124.4269',
                STR_TO_DATE('28,09,2005', '%d,%m,%Y'),
                'FI_ACCOUNT',
                8200,
                NULL,
                108,
                100
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                111,
                'Ismael Sciarra',
                'ISCIARRA',
                '515.124.4369',
                STR_TO_DATE('30,09,2005', '%d,%m,%Y'),
                'FI_ACCOUNT',
                7700,
                NULL,
                108,
                100
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                112,
                'Jose Manuel Urman',
                'JMURMAN',
                '515.124.4469',
                STR_TO_DATE('07,03,2006', '%d,%m,%Y'),
                'FI_ACCOUNT',
                7800,
                NULL,
                108,
                100
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                113,
                'Luis Popp',
                'LPOPP',
                '515.124.4567',
                STR_TO_DATE('07,12,2007', '%d,%m,%Y'),
                'FI_ACCOUNT',
                6900,
                NULL,
                108,
                100
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                114,
                'Den Raphaely',
                'DRAPHEAL',
                '515.127.4561',
                STR_TO_DATE('07,12,2002', '%d,%m,%Y'),
                'PU_MAN',
                11000,
                NULL,
                100,
                30
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                115,
                'Alexander Khoo',
                'AKHOO',
                '515.127.4562',
                STR_TO_DATE('18,05,2003', '%d,%m,%Y'),
                'PU_CLERK',
                3100,
                NULL,
                114,
                30
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                116,
                'Shelli Baida',
                'SBAIDA',
                '515.127.4563',
                STR_TO_DATE('24,12,2005', '%d,%m,%Y'),
                'PU_CLERK',
                2900,
                NULL,
                114,
                30
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                117,
                'Sigal Tobias',
                'STOBIAS',
                '515.127.4564',
                STR_TO_DATE('24,07,2005', '%d,%m,%Y'),
                'PU_CLERK',
                2800,
                NULL,
                114,
                30
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                118,
                'Guy Himuro',
                'GHIMURO',
                '515.127.4565',
                STR_TO_DATE('15,11,2006', '%d,%m,%Y'),
                'PU_CLERK',
                2600,
                NULL,
                114,
                30
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                119,
                'Karen Colmenares',
                'KCOLMENA',
                '515.127.4566',
                STR_TO_DATE('10,08,2007', '%d,%m,%Y'),
                'PU_CLERK',
                2500,
                NULL,
                114,
                30
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                120,
                'Matthew Weiss',
                'MWEISS',
                '650.123.1234',
                STR_TO_DATE('18,07,2004', '%d,%m,%Y'),
                'ST_MAN',
                8000,
                NULL,
                100,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                121,
                'Adam Fripp',
                'AFRIPP',
                '650.123.2234',
                STR_TO_DATE('10,04,2005', '%d,%m,%Y'),
                'ST_MAN',
                8200,
                NULL,
                100,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                122,
                'Payam Kaufling',
                'PKAUFLIN',
                '650.123.3234',
                STR_TO_DATE('01,05,2003', '%d,%m,%Y'),
                'ST_MAN',
                7900,
                NULL,
                100,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                123,
                'Shanta Vollman',
                'SVOLLMAN',
                '650.123.4234',
                STR_TO_DATE('10,10,2005', '%d,%m,%Y'),
                'ST_MAN',
                6500,
                NULL,
                100,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                124,
                'Kevin Mourgos',
                'KMOURGOS',
                '650.123.5234',
                STR_TO_DATE('16,11,2007', '%d,%m,%Y'),
                'ST_MAN',
                5800,
                NULL,
                100,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                125,
                'Julia Nayer',
                'JNAYER',
                '650.124.1214',
                STR_TO_DATE('16,07,2005', '%d,%m,%Y'),
                'ST_CLERK',
                3200,
                NULL,
                120,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                126,
                'Irene Mikkilineni',
                'IMIKKILI',
                '650.124.1224',
                STR_TO_DATE('28,09,2006', '%d,%m,%Y'),
                'ST_CLERK',
                2700,
                NULL,
                120,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                127,
                'James Landry',
                'JLANDRY',
                '650.124.1334',
                STR_TO_DATE('14,01,2007', '%d,%m,%Y'),
                'ST_CLERK',
                2400,
                NULL,
                120,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                128,
                'Steven Markle',
                'SMARKLE',
                '650.124.1434',
                STR_TO_DATE('08,03,2008', '%d,%m,%Y'),
                'ST_CLERK',
                2200,
                NULL,
                120,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                129,
                'Laura Bissot',
                'LBISSOT',
                '650.124.5234',
                STR_TO_DATE('20,08,2005', '%d,%m,%Y'),
                'ST_CLERK',
                3300,
                NULL,
                121,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                130,
                'Mozhe Atkinson',
                'MATKINSO',
                '650.124.6234',
                STR_TO_DATE('30,10,2005', '%d,%m,%Y'),
                'ST_CLERK',
                2800,
                NULL,
                121,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                131,
                'James Marlow',
                'JAMRLOW',
                '650.124.7234',
                STR_TO_DATE('16,02,2005', '%d,%m,%Y'),
                'ST_CLERK',
                2500,
                NULL,
                121,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                132,
                'TJ Olson',
                'TJOLSON',
                '650.124.8234',
                STR_TO_DATE('10,04,2007', '%d,%m,%Y'),
                'ST_CLERK',
                2100,
                NULL,
                121,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                133,
                'Jason Mallin',
                'JMALLIN',
                '650.127.1934',
                STR_TO_DATE('14,06,2004', '%d,%m,%Y'),
                'ST_CLERK',
                3300,
                NULL,
                122,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                134,
                'Michael Rogers',
                'MROGERS',
                '650.127.1834',
                STR_TO_DATE('26,08,2006', '%d,%m,%Y'),
                'ST_CLERK',
                2900,
                NULL,
                122,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                135,
                'Ki Gee',
                'KGEE',
                '650.127.1734',
                STR_TO_DATE('12,12,2007', '%d,%m,%Y'),
                'ST_CLERK',
                2400,
                NULL,
                122,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                136,
                'Hazel Philtanker',
                'HPHILTAN',
                '650.127.1634',
                STR_TO_DATE('06,02,2008', '%d,%m,%Y'),
                'ST_CLERK',
                2200,
                NULL,
                122,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                137,
                'Renske Ladwig',
                'RLADWIG',
                '650.121.1234',
                STR_TO_DATE('14,07,2003', '%d,%m,%Y'),
                'ST_CLERK',
                3600,
                NULL,
                123,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                138,
                'Stephen Stiles',
                'SSTILES',
                '650.121.2034',
                STR_TO_DATE('26,10,2005', '%d,%m,%Y'),
                'ST_CLERK',
                3200,
                NULL,
                123,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                139,
                'John Seo',
                'JSEO',
                '650.121.2019',
                STR_TO_DATE('12,02,2006', '%d,%m,%Y'),
                'ST_CLERK',
                2700,
                NULL,
                123,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                140,
                'Joshua Patel',
                'JPATEL',
                '650.121.1834',
                STR_TO_DATE('06,04,2006', '%d,%m,%Y'),
                'ST_CLERK',
                2500,
                NULL,
                123,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                141,
                'Trenna Rajs',
                'TRAJS',
                '650.121.8009',
                STR_TO_DATE('17,10,2003', '%d,%m,%Y'),
                'ST_CLERK',
                3500,
                NULL,
                124,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                142,
                'Curtis Davies',
                'CDAVIES',
                '650.121.2994',
                STR_TO_DATE('29,01,2005', '%d,%m,%Y'),
                'ST_CLERK',
                3100,
                NULL,
                124,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                143,
                'Randall Matos',
                'RMATOS',
                '650.121.2874',
                STR_TO_DATE('15,03,2006', '%d,%m,%Y'),
                'ST_CLERK',
                2600,
                NULL,
                124,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                144,
                'Peter Vargas',
                'PVARGAS',
                '650.121.2004',
                STR_TO_DATE('09,07,2006', '%d,%m,%Y'),
                'ST_CLERK',
                2500,
                NULL,
                124,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                145,
                'John Russell',
                'JRUSSEL',
                '011.44.1344.429268',
                STR_TO_DATE('01,10,2004', '%d,%m,%Y'),
                'SA_MAN',
                14000,
.4,
                100,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                146,
                'Karen Partners',
                'KPARTNER',
                '011.44.1344.467268',
                STR_TO_DATE('05,01,2005', '%d,%m,%Y'),
                'SA_MAN',
                13500,
.3,
                100,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                147,
                'Alberto Errazuriz',
                'AERRAZUR',
                '011.44.1344.429278',
                STR_TO_DATE('10,03,2005', '%d,%m,%Y'),
                'SA_MAN',
                12000,
.3,
                100,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                148,
                'Gerald Cambrault',
                'GCAMBRAU',
                '011.44.1344.619268',
                STR_TO_DATE('15,10,2007', '%d,%m,%Y'),
                'SA_MAN',
                11000,
.3,
                100,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                149,
                'Eleni Zlotkey',
                'EZLOTKEY',
                '011.44.1344.429018',
                STR_TO_DATE('29,01,2008', '%d,%m,%Y'),
                'SA_MAN',
                10500,
.2,
                100,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                150,
                'Peter Tucker',
                'PTUCKER',
                '011.44.1344.129268',
                STR_TO_DATE('30,01,2005', '%d,%m,%Y'),
                'SA_REP',
                10000,
.3,
                145,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                151,
                'David Bernstein',
                'DBERNSTE',
                '011.44.1344.345268',
                STR_TO_DATE('24,03,2005', '%d,%m,%Y'),
                'SA_REP',
                9500,
.25,
                145,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                152,
                'Peter Hall',
                'PHALL',
                '011.44.1344.478968',
                STR_TO_DATE('20,08,2005', '%d,%m,%Y'),
                'SA_REP',
                9000,
.25,
                145,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                153,
                'Christopher Olsen',
                'COLSEN',
                '011.44.1344.498718',
                STR_TO_DATE('30,03,2006', '%d,%m,%Y'),
                'SA_REP',
                8000,
.2,
                145,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                154,
                'Nanette Cambrault',
                'NCAMBRAU',
                '011.44.1344.987668',
                STR_TO_DATE('09,12,2006', '%d,%m,%Y'),
                'SA_REP',
                7500,
.2,
                145,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                155,
                'Oliver Tuvault',
                'OTUVAULT',
                '011.44.1344.486508',
                STR_TO_DATE('23,11,2007', '%d,%m,%Y'),
                'SA_REP',
                7000,
.15,
                145,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                156,
                'Janette King',
                'JKING',
                '011.44.1345.429268',
                STR_TO_DATE('30,01,2004', '%d,%m,%Y'),
                'SA_REP',
                10000,
.35,
                146,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                157,
                'Patrick Sully',
                'PSULLY',
                '011.44.1345.929268',
                STR_TO_DATE('04,03,2004', '%d,%m,%Y'),
                'SA_REP',
                9500,
.35,
                146,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                158,
                'Allan McEwen',
                'AMCEWEN',
                '011.44.1345.829268',
                STR_TO_DATE('01,08,2004', '%d,%m,%Y'),
                'SA_REP',
                9000,
.35,
                146,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                159,
                'Lindsey Smith',
                'LSMITH',
                '011.44.1345.729268',
                STR_TO_DATE('10,03,2005', '%d,%m,%Y'),
                'SA_REP',
                8000,
.3,
                146,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                160,
                'Louise Doran',
                'LDORAN',
                '011.44.1345.629268',
                STR_TO_DATE('15,12,2005', '%d,%m,%Y'),
                'SA_REP',
                7500,
.3,
                146,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                161,
                'Sarath Sewall',
                'SSEWALL',
                '011.44.1345.529268',
                STR_TO_DATE('03,11,2006', '%d,%m,%Y'),
                'SA_REP',
                7000,
.25,
                146,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                162,
                'Clara Vishney',
                'CVISHNEY',
                '011.44.1346.129268',
                STR_TO_DATE('11,11,2005', '%d,%m,%Y'),
                'SA_REP',
                10500,
.25,
                147,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                163,
                'Danielle Greene',
                'DGREENE',
                '011.44.1346.229268',
                STR_TO_DATE('19,03,2007', '%d,%m,%Y'),
                'SA_REP',
                9500,
.15,
                147,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                164,
                'Mattea Marvins',
                'MMARVINS',
                '011.44.1346.329268',
                STR_TO_DATE('24,01,2008', '%d,%m,%Y'),
                'SA_REP',
                7200,
.10,
                147,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                165,
                'David Lee',
                'DLEE',
                '011.44.1346.529268',
                STR_TO_DATE('23,02,2008', '%d,%m,%Y'),
                'SA_REP',
                6800,
.1,
                147,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                166,
                'Sundar Ande',
                'SANDE',
                '011.44.1346.629268',
                STR_TO_DATE('24,03,2008', '%d,%m,%Y'),
                'SA_REP',
                6400,
.10,
                147,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                167,
                'Amit Banda',
                'ABANDA',
                '011.44.1346.729268',
                STR_TO_DATE('21,04,2008', '%d,%m,%Y'),
                'SA_REP',
                6200,
.10,
                147,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                168,
                'Lisa Ozer',
                'LOZER',
                '011.44.1343.929268',
                STR_TO_DATE('11,03,2005', '%d,%m,%Y'),
                'SA_REP',
                11500,
.25,
                148,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                169,
                'Harrison Bloom',
                'HBLOOM',
                '011.44.1343.829268',
                STR_TO_DATE('23,03,2006', '%d,%m,%Y'),
                'SA_REP',
                10000,
.20,
                148,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                170,
                'Tayler Fox',
                'TFOX',
                '011.44.1343.729268',
                STR_TO_DATE('24,01,2006', '%d,%m,%Y'),
                'SA_REP',
                9600,
.20,
                148,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                171,
                'William Smith',
                'WSMITH',
                '011.44.1343.629268',
                STR_TO_DATE('23,02,2007', '%d,%m,%Y'),
                'SA_REP',
                7400,
.15,
                148,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                172,
                'Elizabeth Bates',
                'EBATES',
                '011.44.1343.529268',
                STR_TO_DATE('24,03,2007', '%d,%m,%Y'),
                'SA_REP',
                7300,
.15,
                148,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                173,
                'Sundita Kumar',
                'SKUMAR',
                '011.44.1343.329268',
                STR_TO_DATE('21,04,2008', '%d,%m,%Y'),
                'SA_REP',
                6100,
.10,
                148,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                174,
                'Ellen Abel',
                'EABEL',
                '011.44.1644.429267',
                STR_TO_DATE('11,05,2004', '%d,%m,%Y'),
                'SA_REP',
                11000,
.30,
                149,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                175,
                'Alyssa Hutton',
                'AHUTTON',
                '011.44.1644.429266',
                STR_TO_DATE('19,03,2005', '%d,%m,%Y'),
                'SA_REP',
                8800,
.25,
                149,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                176,
                'Jonathon Taylor',
                'JTAYLOR',
                '011.44.1644.429265',
                STR_TO_DATE('24,03,2006', '%d,%m,%Y'),
                'SA_REP',
                8600,
.20,
                149,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                177,
                'Jack Livingston',
                'JLIVINGS',
                '011.44.1644.429264',
                STR_TO_DATE('23,04,2006', '%d,%m,%Y'),
                'SA_REP',
                8400,
.20,
                149,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                178,
                'Kimberely Grant',
                'KGRANT',
                '011.44.1644.429263',
                STR_TO_DATE('24,05,2007', '%d,%m,%Y'),
                'SA_REP',
                7000,
.15,
                149,
                NULL
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                179,
                'Charles Johnson',
                'CJOHNSON',
                '011.44.1644.429262',
                STR_TO_DATE('04,01,2008', '%d,%m,%Y'),
                'SA_REP',
                6200,
.10,
                149,
                80
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                180,
                'Winston Taylor',
                'WTAYLOR',
                '650.507.9876',
                STR_TO_DATE('24,01,2006', '%d,%m,%Y'),
                'SH_CLERK',
                3200,
                NULL,
                120,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                181,
                'Jean Fleaur',
                'JFLEAUR',
                '650.507.9877',
                STR_TO_DATE('23,02,2006', '%d,%m,%Y'),
                'SH_CLERK',
                3100,
                NULL,
                120,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                182,
                'Martha Sullivan',
                'MSULLIVA',
                '650.507.9878',
                STR_TO_DATE('21,06,2007', '%d,%m,%Y'),
                'SH_CLERK',
                2500,
                NULL,
                120,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                183,
                'Girard Geoni',
                'GGEONI',
                '650.507.9879',
                STR_TO_DATE('03,02,2008', '%d,%m,%Y'),
                'SH_CLERK',
                2800,
                NULL,
                120,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                184,
                'Nandita Sarchand',
                'NSARCHAN',
                '650.509.1876',
                STR_TO_DATE('27,01,2004', '%d,%m,%Y'),
                'SH_CLERK',
                4200,
                NULL,
                121,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                185,
                'Alexis Bull',
                'ABULL',
                '650.509.2876',
                STR_TO_DATE('20,02,2005', '%d,%m,%Y'),
                'SH_CLERK',
                4100,
                NULL,
                121,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                186,
                'Julia Dellinger',
                'JDELLING',
                '650.509.3876',
                STR_TO_DATE('24,06,2006', '%d,%m,%Y'),
                'SH_CLERK',
                3400,
                NULL,
                121,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                187,
                'Anthony Cabrio',
                'ACABRIO',
                '650.509.4876',
                STR_TO_DATE('07,02,2007', '%d,%m,%Y'),
                'SH_CLERK',
                3000,
                NULL,
                121,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                188,
                'Kelly Chung',
                'KCHUNG',
                '650.505.1876',
                STR_TO_DATE('14,06,2005', '%d,%m,%Y'),
                'SH_CLERK',
                3800,
                NULL,
                122,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                189,
                'Jennifer Dilly',
                'JDILLY',
                '650.505.2876',
                STR_TO_DATE('13,08,2005', '%d,%m,%Y'),
                'SH_CLERK',
                3600,
                NULL,
                122,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                190,
                'Timothy Gates',
                'TGATES',
                '650.505.3876',
                STR_TO_DATE('11,07,2006', '%d,%m,%Y'),
                'SH_CLERK',
                2900,
                NULL,
                122,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                191,
                'Randall Perkins',
                'RPERKINS',
                '650.505.4876',
                STR_TO_DATE('19,12,2007', '%d,%m,%Y'),
                'SH_CLERK',
                2500,
                NULL,
                122,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                192,
                'Sarah Bell',
                'SBELL',
                '650.501.1876',
                STR_TO_DATE('04,02,2004', '%d,%m,%Y'),
                'SH_CLERK',
                4000,
                NULL,
                123,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                193,
                'Britney Everett',
                'BEVERETT',
                '650.501.2876',
                STR_TO_DATE('03,03,2005', '%d,%m,%Y'),
                'SH_CLERK',
                3900,
                NULL,
                123,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                194,
                'Samuel McCain',
                'SMCCAIN',
                '650.501.3876',
                STR_TO_DATE('01,07,2006', '%d,%m,%Y'),
                'SH_CLERK',
                3200,
                NULL,
                123,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                195,
                'Vance Jones',
                'VJONES',
                '650.501.4876',
                STR_TO_DATE('17,03,2007', '%d,%m,%Y'),
                'SH_CLERK',
                2800,
                NULL,
                123,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                196,
                'Alana Walsh',
                'AWALSH',
                '650.507.9811',
                STR_TO_DATE('24,04,2006', '%d,%m,%Y'),
                'SH_CLERK',
                3100,
                NULL,
                124,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                197,
                'Kevin Feeney',
                'KFEENEY',
                '650.507.9822',
                STR_TO_DATE('23,05,2006', '%d,%m,%Y'),
                'SH_CLERK',
                3000,
                NULL,
                124,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                198,
                'Donald OConnell',
                'DOCONNEL',
                '650.507.9833',
                STR_TO_DATE('21,06,2007', '%d,%m,%Y'),
                'SH_CLERK',
                2600,
                NULL,
                124,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                199,
                'Douglas Grant',
                'DGRANT',
                '650.507.9844',
                STR_TO_DATE('13,01,2008', '%d,%m,%Y'),
                'SH_CLERK',
                2600,
                NULL,
                124,
                50
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                200,
                'Jennifer Whalen',
                'JWHALEN',
                '515.123.4444',
                STR_TO_DATE('17,09,2003', '%d,%m,%Y'),
                'AD_ASST',
                4400,
                NULL,
                101,
                10
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                201,
                'Michael Hartstein',
                'MHARTSTE',
                '515.123.5555',
                STR_TO_DATE('17,02,2004', '%d,%m,%Y'),
                'MK_MAN',
                13000,
                NULL,
                100,
                20
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                202,
                'Pat Fay',
                'PFAY',
                '603.123.6666',
                STR_TO_DATE('17,08,2005', '%d,%m,%Y'),
                'MK_REP',
                6000,
                NULL,
                201,
                20
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                203,
                'Susan Mavris',
                'SMAVRIS',
                '515.123.7777',
                STR_TO_DATE('07,06,2002', '%d,%m,%Y'),
                'HR_REP',
                6500,
                NULL,
                101,
                40
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                204,
                'Hermann Baer',
                'HBAER',
                '515.123.8888',
                STR_TO_DATE('07,06,2002', '%d,%m,%Y'),
                'PR_REP',
                10000,
                NULL,
                101,
                70
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                205,
                'Shelley Higgins',
                'SHIGGINS',
                '515.123.8080',
                STR_TO_DATE('07,06,2002', '%d,%m,%Y'),
                'AC_MGR',
                12008,
                NULL,
                101,
                110
        );
INSERT INTO empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                206,
                'William Gietz',
                'WGIETZ',
                '515.123.8181',
                STR_TO_DATE('07,06,2002', '%d,%m,%Y'),
                'AC_ACCOUNT',
                8300,
                NULL,
                205,
                110
        );
        
#INSERTS departamentos
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (10, 'Administration', 1700, 200);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (20, 'Marketing', 1800, 201);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (30, 'Purchasing', 1700, 114);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (40, 'Human Resources', 2400, 203);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (50, 'Shipping', 1500, 121);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (60, 'IT', 1400, 103);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (70, 'Public Relations', 2700, 204);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (80, 'Sales', 2500, 145);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (90, 'Executive', 1700, 100);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (100, 'Finance', 1700, 108);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (110, 'Accounting', 1700, 205);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (120, 'Treasury', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (130, 'Corporate Tax', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (140, 'Control And Credit', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (150, 'Shareholder Services', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (160, 'Benefits', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (170, 'Manufacturing', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (180, 'Construction', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (190, 'Contracting', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (200, 'Operations', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (210, 'IT Support', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (220, 'NOC', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (230, 'IT Helpdesk', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (240, 'Government Sales', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (250, 'Retail Sales', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (260, 'Recruiting', 1700, null);
INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (270, 'Payroll', 1700, null);

#INSERTS historico_cargos
INSERT INTO historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2001-01-13', '102', '2006-07-24', 60, 'IT_PROG');
INSERT INTO historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2001-10-28', '101', '2005-03-15', 110, 'AC_MGR');
INSERT INTO historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2004-02-17', '201', '2007-12-19', 20, 'MK_REP');
INSERT INTO historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2006-03-24', '114', '2007-12-31', 50, 'ST_CLERK');
INSERT INTO historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2007-01-01', '122', '2007-12-31', 50, 'ST_CLERK');
INSERT INTO historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('1995-09-17', '200', '2001-06-17', 90, 'AD_ASST');
INSERT INTO historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2006-03-24', '176', '2006-12-31', 80, 'SA_REP');
INSERT INTO historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2007-01-01', '176', '2007-12-31', 80, 'SA_MAN');
INSERT INTO historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2002-07-01', '200', '2006-12-31', 90, 'AC_ACCOUNT');


#empregados Constraints
ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo);

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento);

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregado);

#historico_cargos contraints
ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo);

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento);

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado);

#paises constraints
ALTER TABLE paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao);

#localizacoes constraints
ALTER TABLE localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais);

#departamentos constraints
ALTER TABLE departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES localizacoes (id_localizacao);

ALTER TABLE departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_gerente)
REFERENCES empregados (id_empregado);

