--CREATE USER AND DATABASE
create user thiago with password 'computacao@raiz' createdb;
CREATE DATABASE uvv OWNER thiago;
\c uvv thiago 

--CREATE SCHEMA
create schema hr authorization thiago;

--SET SEARCH_PATH 
set search_path to hr,'$user',public;

--CREATE TABLES AND CONSTRAINTS
CREATE TABLE hr.cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT id_cargo PRIMARY KEY (id_cargo)
);
COMMENT ON TABLE hr.cargos IS 'Tabela que armazena cargos dos empregados';
COMMENT ON COLUMN hr.cargos.id_cargo IS 'Identificador do cargo';
COMMENT ON COLUMN hr.cargos.cargo IS 'Nome do cargo';
COMMENT ON COLUMN hr.cargos.salario_minimo IS 'Salario mínimo do cargo';
COMMENT ON COLUMN hr.cargos.salario_maximo IS 'Salário máximo do cargo';


CREATE UNIQUE INDEX cargos_cargo_uniquekey
 ON hr.cargos
 ( cargo );

CREATE SEQUENCE hr.regioes_pk;

CREATE TABLE hr.regioes (
                id_regiao INTEGER NOT NULL DEFAULT nextval('hr.regioes_pk'),
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao PRIMARY KEY (id_regiao)
);

COMMENT ON TABLE hr.regioes IS 'Tabela que armazena regiões';
COMMENT ON COLUMN hr.regioes.id_regiao IS 'identificador da região';
COMMENT ON COLUMN hr.regioes.nome IS 'nome da região';


ALTER SEQUENCE hr.regioes_pk OWNED BY hr.regioes.id_regiao;

CREATE UNIQUE INDEX regioes_nome_uniquekey
 ON hr.regioes
 ( nome );

CREATE TABLE hr.paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INTEGER,
                CONSTRAINT id_pais PRIMARY KEY (id_pais)
);
COMMENT ON TABLE hr.paises IS 'Tabela que armazena paises';
COMMENT ON COLUMN hr.paises.id_pais IS 'Identificador do país';
COMMENT ON COLUMN hr.paises.nome IS 'nome do país';
COMMENT ON COLUMN hr.paises.id_regiao IS 'Chave estrangeira da tabela regiões que referencia';


CREATE UNIQUE INDEX paises_nome_uniquekey
 ON hr.paises
 ( nome );

CREATE TABLE hr.localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12) NOT NULL,
                cidade VARCHAR(50) NOT NULL,
                uf VARCHAR(25) NOT NULL,
                id_pais CHAR(2) NOT NULL,
                CONSTRAINT id_localizacao PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE hr.localizacoes IS 'Tabela que armazena localizações';
COMMENT ON COLUMN hr.localizacoes.id_localizacao IS 'Identificador da localização';
COMMENT ON COLUMN hr.localizacoes.cep IS 'Cep da localização';
COMMENT ON COLUMN hr.localizacoes.cidade IS 'Cidade da localização';
COMMENT ON COLUMN hr.localizacoes.uf IS 'UF da localização';
COMMENT ON COLUMN hr.localizacoes.id_pais IS 'Chave estrangeira da tabela paises que referencia um pais';


CREATE TABLE hr.departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(50),
                id_localizacao INTEGER,
                id_gerente INTEGER,
                CONSTRAINT id_departamento PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE hr.departamentos IS 'Tabela que armazena empregados';
COMMENT ON COLUMN hr.departamentos.id_departamento IS 'Identificador do departamento';
COMMENT ON COLUMN hr.departamentos.id_localizacao IS 'Chave estrangeira da tabela localização que referencia a localização do departamento';
COMMENT ON COLUMN hr.departamentos.id_gerente IS 'Chave estrangeira da tabela empregados que referencia o gerente do departamento';


CREATE UNIQUE INDEX departamentos_nome_uniquekey
 ON hr.departamentos
 ( nome );

CREATE TABLE hr.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                id_departamento INTEGER,
                id_supervisor INTEGER,
                CONSTRAINT id_empregado PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE hr.empregados IS 'Tabela de empregados';
COMMENT ON COLUMN hr.empregados.id_empregado IS 'Identificador do empregado';
COMMENT ON COLUMN hr.empregados.nome IS 'nome do empregado';
COMMENT ON COLUMN hr.empregados.email IS 'E-mail do empregado';
COMMENT ON COLUMN hr.empregados.telefone IS 'Telefone do empregado';
COMMENT ON COLUMN hr.empregados.data_contratacao IS 'Data de contratação do empregado';
COMMENT ON COLUMN hr.empregados.id_cargo IS 'Chave estrageira da tabela cargo que referencia o cargo do empregado';
COMMENT ON COLUMN hr.empregados.id_departamento IS 'Chave estrangeira referente a tabela departamento que referencia qual departamento o empregado pertence';
COMMENT ON COLUMN hr.empregados.id_supervisor IS 'Chave estrangeira da própria tabela (auto-relacionamento) que indica, caso tenha, o supervisor do empregado';


CREATE UNIQUE INDEX empregados_email_uniquekey
 ON hr.empregados
 ( email );

CREATE TABLE hr.historico_cargos (
                data_inicial DATE NOT NULL,
                id_empregado INTEGER NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER,
                CONSTRAINT data_inicial PRIMARY KEY (data_inicial, id_empregado)
);
COMMENT ON TABLE hr.historico_cargos IS 'Tabela que armazena histórico do empregado em cada cargo';
COMMENT ON COLUMN hr.historico_cargos.data_inicial IS 'Data do inicial do histórico';
COMMENT ON COLUMN hr.historico_cargos.id_empregado IS 'Identificador do empregado';
COMMENT ON COLUMN hr.historico_cargos.data_final IS 'Data final do histórico';
COMMENT ON COLUMN hr.historico_cargos.id_cargo IS 'Chave estrageira da tabela cargo que referencia o cargo';
COMMENT ON COLUMN hr.historico_cargos.id_departamento IS 'Chave estrangeira da tabela departamentos que identifica o departamento que o empregado está/estava trabalhando';


--INSERTS regioes
INSERT INTO hr.regioes VALUES ( 1, 'Europe');
INSERT INTO hr.regioes VALUES ( 2, 'Americas');
INSERT INTO hr.regioes VALUES ( 3, 'Asia' );
INSERT INTO hr.regioes VALUES ( 4, 'Middle East and Africa' );

--INSERTS paises
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('AR', 2, 'Argentina');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('AU', 3, 'Australia');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('BE', 1, 'Belgium');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('BR', 2, 'Brazil');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('CA', 2, 'Canada');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('CH', 1, 'Switzerland');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('CN', 3, 'China');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('DE', 1, 'Germany');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('DK', 1, 'Denmark');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('EG', 4, 'Egypt');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('FR', 1, 'France');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('IL', 4, 'Israel');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('IN', 3, 'India');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('IT', 1, 'Italy');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('JP', 3, 'Japan');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('KW', 4, 'Kuwait');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('ML', 3, 'Malaysia');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('MX', 2, 'Mexico');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('NG', 4, 'Nigeria');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('NL', 1, 'Netherlands');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('SG', 3, 'Singapore');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('UK', 1, 'United Kingdom');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('US', 2, 'United States of America');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('ZM', 4, 'Zambia');
INSERT INTO hr.paises (id_pais, id_regiao, nome) VALUES ('ZW', 4, 'Zimbabwe');

--INSERTS localizacoes
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1000, '1297 Via Cola di Rie', '00989', 'Roma', '', 'IT');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1100, '93091 Calle della Testa', '10934', 'Venice', '', 'IT');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1300, '9450 Kamiya-cho', '6823', 'Hiroshima', '', 'JP');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (1900, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2000, '40-5-12 Laogianggen', '190518', 'Beijing', '', 'CN');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2300, '198 Clementi North', '540198', 'Singapore', '', 'SG');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2400, '8204 Arthur St', '', 'London', '', 'UK');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2600, '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2800, 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (3100, 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES (3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal,', 'MX');

--INSERTS cargos
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'AD_PRES', 'President', 20080, 40000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'FI_MGR', 'Finance Manager', 8200, 16000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'FI_ACCOUNT', 'Accountant', 4200, 9000  );
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'AC_MGR', 'Accounting Manager', 8200, 16000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'AC_ACCOUNT', 'Public Accountant', 4200, 9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'SA_MAN', 'Sales Manager', 10000, 20080 );
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'SA_REP', 'Sales Representative', 6000, 12008 );
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'PU_MAN', 'Purchasing Manager', 8000, 15000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES( 'PU_CLERK', 'Purchasing Clerk', 2500, 5500 );
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'ST_CLERK', 'Stock Clerk', 2008, 5000 );
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'SH_CLERK', 'Shipping Clerk', 2500, 5500);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'IT_PROG', 'Programmer', 4000, 10000 );
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'MK_MAN', 'Marketing Manager', 9000, 15000   );
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'MK_REP', 'Marketing Representative', 4000, 9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'HR_REP', 'Human Resources Representative', 4000, 9000 );
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ( 'PR_REP', 'Public Relations Representative', 4500, 10500 );

--INSERTS empregados

INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                100,
                'Steven King',
                'SKING',
                '515.123.4567',
                TO_DATE('17-06-2003', 'dd-MM-yyyy'),
                'AD_PRES',
                24000,
                NULL,
                NULL,
                90
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                101,
                'Neena Kochhar',
                'NKOCHHAR',
                '515.123.4568',
                TO_DATE('21-09-2005', 'dd-MM-yyyy'),
                'AD_VP',
                17000,
                NULL,
                100,
                90
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                102,
                'Lex De Haan',
                'LDEHAAN',
                '515.123.4569',
                TO_DATE('13-01-2001', 'dd-MM-yyyy'),
                'AD_VP',
                17000,
                NULL,
                100,
                90
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                103,
                'Alexander Hunold',
                'AHUNOLD',
                '590.423.4567',
                TO_DATE('03-01-2006', 'dd-MM-yyyy'),
                'IT_PROG',
                9000,
                NULL,
                102,
                60
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                104,
                'Bruce Ernst',
                'BERNST',
                '590.423.4568',
                TO_DATE('21-05-2007', 'dd-MM-yyyy'),
                'IT_PROG',
                6000,
                NULL,
                103,
                60
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                105,
                'David Austin',
                'DAUSTIN',
                '590.423.4569',
                TO_DATE('25-06-2005', 'dd-MM-yyyy'),
                'IT_PROG',
                4800,
                NULL,
                103,
                60
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                106,
                'Valli Pataballa',
                'VPATABAL',
                '590.423.4560',
                TO_DATE('05-02-2006', 'dd-MM-yyyy'),
                'IT_PROG',
                4800,
                NULL,
                103,
                60
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                107,
                'Diana Lorentz',
                'DLORENTZ',
                '590.423.5567',
                TO_DATE('07-02-2007', 'dd-MM-yyyy'),
                'IT_PROG',
                4200,
                NULL,
                103,
                60
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                108,
                'Nancy Greenberg',
                'NGREENBE',
                '515.124.4569',
                TO_DATE('17-08-2002', 'dd-MM-yyyy'),
                'FI_MGR',
                12008,
                NULL,
                101,
                100
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                109,
                'Daniel Faviet',
                'DFAVIET',
                '515.124.4169',
                TO_DATE('16-08-2002', 'dd-MM-yyyy'),
                'FI_ACCOUNT',
                9000,
                NULL,
                108,
                100
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                110,
                'John Chen',
                'JCHEN',
                '515.124.4269',
                TO_DATE('28-09-2005', 'dd-MM-yyyy'),
                'FI_ACCOUNT',
                8200,
                NULL,
                108,
                100
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                111,
                'Ismael Sciarra',
                'ISCIARRA',
                '515.124.4369',
                TO_DATE('30-09-2005', 'dd-MM-yyyy'),
                'FI_ACCOUNT',
                7700,
                NULL,
                108,
                100
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                112,
                'Jose Manuel Urman',
                'JMURMAN',
                '515.124.4469',
                TO_DATE('07-03-2006', 'dd-MM-yyyy'),
                'FI_ACCOUNT',
                7800,
                NULL,
                108,
                100
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                113,
                'Luis Popp',
                'LPOPP',
                '515.124.4567',
                TO_DATE('07-12-2007', 'dd-MM-yyyy'),
                'FI_ACCOUNT',
                6900,
                NULL,
                108,
                100
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                114,
                'Den Raphaely',
                'DRAPHEAL',
                '515.127.4561',
                TO_DATE('07-12-2002', 'dd-MM-yyyy'),
                'PU_MAN',
                11000,
                NULL,
                100,
                30
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                115,
                'Alexander Khoo',
                'AKHOO',
                '515.127.4562',
                TO_DATE('18-05-2003', 'dd-MM-yyyy'),
                'PU_CLERK',
                3100,
                NULL,
                114,
                30
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                116,
                'Shelli Baida',
                'SBAIDA',
                '515.127.4563',
                TO_DATE('24-12-2005', 'dd-MM-yyyy'),
                'PU_CLERK',
                2900,
                NULL,
                114,
                30
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                117,
                'Sigal Tobias',
                'STOBIAS',
                '515.127.4564',
                TO_DATE('24-07-2005', 'dd-MM-yyyy'),
                'PU_CLERK',
                2800,
                NULL,
                114,
                30
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                118,
                'Guy Himuro',
                'GHIMURO',
                '515.127.4565',
                TO_DATE('15-11-2006', 'dd-MM-yyyy'),
                'PU_CLERK',
                2600,
                NULL,
                114,
                30
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                119,
                'Karen Colmenares',
                'KCOLMENA',
                '515.127.4566',
                TO_DATE('10-08-2007', 'dd-MM-yyyy'),
                'PU_CLERK',
                2500,
                NULL,
                114,
                30
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                120,
                'Matthew Weiss',
                'MWEISS',
                '650.123.1234',
                TO_DATE('18-07-2004', 'dd-MM-yyyy'),
                'ST_MAN',
                8000,
                NULL,
                100,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                121,
                'Adam Fripp',
                'AFRIPP',
                '650.123.2234',
                TO_DATE('10-04-2005', 'dd-MM-yyyy'),
                'ST_MAN',
                8200,
                NULL,
                100,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                122,
                'Payam Kaufling',
                'PKAUFLIN',
                '650.123.3234',
                TO_DATE('01-05-2003', 'dd-MM-yyyy'),
                'ST_MAN',
                7900,
                NULL,
                100,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                123,
                'Shanta Vollman',
                'SVOLLMAN',
                '650.123.4234',
                TO_DATE('10-10-2005', 'dd-MM-yyyy'),
                'ST_MAN',
                6500,
                NULL,
                100,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                124,
                'Kevin Mourgos',
                'KMOURGOS',
                '650.123.5234',
                TO_DATE('16-11-2007', 'dd-MM-yyyy'),
                'ST_MAN',
                5800,
                NULL,
                100,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                125,
                'Julia Nayer',
                'JNAYER',
                '650.124.1214',
                TO_DATE('16-07-2005', 'dd-MM-yyyy'),
                'ST_CLERK',
                3200,
                NULL,
                120,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                126,
                'Irene Mikkilineni',
                'IMIKKILI',
                '650.124.1224',
                TO_DATE('28-09-2006', 'dd-MM-yyyy'),
                'ST_CLERK',
                2700,
                NULL,
                120,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                127,
                'James Landry',
                'JLANDRY',
                '650.124.1334',
                TO_DATE('14-01-2007', 'dd-MM-yyyy'),
                'ST_CLERK',
                2400,
                NULL,
                120,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                128,
                'Steven Markle',
                'SMARKLE',
                '650.124.1434',
                TO_DATE('08-03-2008', 'dd-MM-yyyy'),
                'ST_CLERK',
                2200,
                NULL,
                120,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                129,
                'Laura Bissot',
                'LBISSOT',
                '650.124.5234',
                TO_DATE('20-08-2005', 'dd-MM-yyyy'),
                'ST_CLERK',
                3300,
                NULL,
                121,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                130,
                'Mozhe Atkinson',
                'MATKINSO',
                '650.124.6234',
                TO_DATE('30-10-2005', 'dd-MM-yyyy'),
                'ST_CLERK',
                2800,
                NULL,
                121,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                131,
                'James Marlow',
                'JAMRLOW',
                '650.124.7234',
                TO_DATE('16-02-2005', 'dd-MM-yyyy'),
                'ST_CLERK',
                2500,
                NULL,
                121,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                132,
                'TJ Olson',
                'TJOLSON',
                '650.124.8234',
                TO_DATE('10-04-2007', 'dd-MM-yyyy'),
                'ST_CLERK',
                2100,
                NULL,
                121,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                133,
                'Jason Mallin',
                'JMALLIN',
                '650.127.1934',
                TO_DATE('14-06-2004', 'dd-MM-yyyy'),
                'ST_CLERK',
                3300,
                NULL,
                122,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                134,
                'Michael Rogers',
                'MROGERS',
                '650.127.1834',
                TO_DATE('26-08-2006', 'dd-MM-yyyy'),
                'ST_CLERK',
                2900,
                NULL,
                122,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                135,
                'Ki Gee',
                'KGEE',
                '650.127.1734',
                TO_DATE('12-12-2007', 'dd-MM-yyyy'),
                'ST_CLERK',
                2400,
                NULL,
                122,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                136,
                'Hazel Philtanker',
                'HPHILTAN',
                '650.127.1634',
                TO_DATE('06-02-2008', 'dd-MM-yyyy'),
                'ST_CLERK',
                2200,
                NULL,
                122,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                137,
                'Renske Ladwig',
                'RLADWIG',
                '650.121.1234',
                TO_DATE('14-07-2003', 'dd-MM-yyyy'),
                'ST_CLERK',
                3600,
                NULL,
                123,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                138,
                'Stephen Stiles',
                'SSTILES',
                '650.121.2034',
                TO_DATE('26-10-2005', 'dd-MM-yyyy'),
                'ST_CLERK',
                3200,
                NULL,
                123,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                139,
                'John Seo',
                'JSEO',
                '650.121.2019',
                TO_DATE('12-02-2006', 'dd-MM-yyyy'),
                'ST_CLERK',
                2700,
                NULL,
                123,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                140,
                'Joshua Patel',
                'JPATEL',
                '650.121.1834',
                TO_DATE('06-04-2006', 'dd-MM-yyyy'),
                'ST_CLERK',
                2500,
                NULL,
                123,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                141,
                'Trenna Rajs',
                'TRAJS',
                '650.121.8009',
                TO_DATE('17-10-2003', 'dd-MM-yyyy'),
                'ST_CLERK',
                3500,
                NULL,
                124,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                142,
                'Curtis Davies',
                'CDAVIES',
                '650.121.2994',
                TO_DATE('29-01-2005', 'dd-MM-yyyy'),
                'ST_CLERK',
                3100,
                NULL,
                124,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                143,
                'Randall Matos',
                'RMATOS',
                '650.121.2874',
                TO_DATE('15-03-2006', 'dd-MM-yyyy'),
                'ST_CLERK',
                2600,
                NULL,
                124,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                144,
                'Peter Vargas',
                'PVARGAS',
                '650.121.2004',
                TO_DATE('09-07-2006', 'dd-MM-yyyy'),
                'ST_CLERK',
                2500,
                NULL,
                124,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                145,
                'John Russell',
                'JRUSSEL',
                '011.44.1344.429268',
                TO_DATE('01-10-2004', 'dd-MM-yyyy'),
                'SA_MAN',
                14000,
.4,
                100,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                146,
                'Karen Partners',
                'KPARTNER',
                '011.44.1344.467268',
                TO_DATE('05-01-2005', 'dd-MM-yyyy'),
                'SA_MAN',
                13500,
.3,
                100,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                147,
                'Alberto Errazuriz',
                'AERRAZUR',
                '011.44.1344.429278',
                TO_DATE('10-03-2005', 'dd-MM-yyyy'),
                'SA_MAN',
                12000,
.3,
                100,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                148,
                'Gerald Cambrault',
                'GCAMBRAU',
                '011.44.1344.619268',
                TO_DATE('15-10-2007', 'dd-MM-yyyy'),
                'SA_MAN',
                11000,
.3,
                100,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                149,
                'Eleni Zlotkey',
                'EZLOTKEY',
                '011.44.1344.429018',
                TO_DATE('29-01-2008', 'dd-MM-yyyy'),
                'SA_MAN',
                10500,
.2,
                100,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                150,
                'Peter Tucker',
                'PTUCKER',
                '011.44.1344.129268',
                TO_DATE('30-01-2005', 'dd-MM-yyyy'),
                'SA_REP',
                10000,
.3,
                145,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                151,
                'David Bernstein',
                'DBERNSTE',
                '011.44.1344.345268',
                TO_DATE('24-03-2005', 'dd-MM-yyyy'),
                'SA_REP',
                9500,
.25,
                145,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                152,
                'Peter Hall',
                'PHALL',
                '011.44.1344.478968',
                TO_DATE('20-08-2005', 'dd-MM-yyyy'),
                'SA_REP',
                9000,
.25,
                145,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                153,
                'Christopher Olsen',
                'COLSEN',
                '011.44.1344.498718',
                TO_DATE('30-03-2006', 'dd-MM-yyyy'),
                'SA_REP',
                8000,
.2,
                145,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                154,
                'Nanette Cambrault',
                'NCAMBRAU',
                '011.44.1344.987668',
                TO_DATE('09-12-2006', 'dd-MM-yyyy'),
                'SA_REP',
                7500,
.2,
                145,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                155,
                'Oliver Tuvault',
                'OTUVAULT',
                '011.44.1344.486508',
                TO_DATE('23-11-2007', 'dd-MM-yyyy'),
                'SA_REP',
                7000,
.15,
                145,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                156,
                'Janette King',
                'JKING',
                '011.44.1345.429268',
                TO_DATE('30-01-2004', 'dd-MM-yyyy'),
                'SA_REP',
                10000,
.35,
                146,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                157,
                'Patrick Sully',
                'PSULLY',
                '011.44.1345.929268',
                TO_DATE('04-03-2004', 'dd-MM-yyyy'),
                'SA_REP',
                9500,
.35,
                146,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                158,
                'Allan McEwen',
                'AMCEWEN',
                '011.44.1345.829268',
                TO_DATE('01-08-2004', 'dd-MM-yyyy'),
                'SA_REP',
                9000,
.35,
                146,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                159,
                'Lindsey Smith',
                'LSMITH',
                '011.44.1345.729268',
                TO_DATE('10-03-2005', 'dd-MM-yyyy'),
                'SA_REP',
                8000,
.3,
                146,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                160,
                'Louise Doran',
                'LDORAN',
                '011.44.1345.629268',
                TO_DATE('15-12-2005', 'dd-MM-yyyy'),
                'SA_REP',
                7500,
.3,
                146,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                161,
                'Sarath Sewall',
                'SSEWALL',
                '011.44.1345.529268',
                TO_DATE('03-11-2006', 'dd-MM-yyyy'),
                'SA_REP',
                7000,
.25,
                146,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                162,
                'Clara Vishney',
                'CVISHNEY',
                '011.44.1346.129268',
                TO_DATE('11-11-2005', 'dd-MM-yyyy'),
                'SA_REP',
                10500,
.25,
                147,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                163,
                'Danielle Greene',
                'DGREENE',
                '011.44.1346.229268',
                TO_DATE('19-03-2007', 'dd-MM-yyyy'),
                'SA_REP',
                9500,
.15,
                147,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                164,
                'Mattea Marvins',
                'MMARVINS',
                '011.44.1346.329268',
                TO_DATE('24-01-2008', 'dd-MM-yyyy'),
                'SA_REP',
                7200,
.10,
                147,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                165,
                'David Lee',
                'DLEE',
                '011.44.1346.529268',
                TO_DATE('23-02-2008', 'dd-MM-yyyy'),
                'SA_REP',
                6800,
.1,
                147,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                166,
                'Sundar Ande',
                'SANDE',
                '011.44.1346.629268',
                TO_DATE('24-03-2008', 'dd-MM-yyyy'),
                'SA_REP',
                6400,
.10,
                147,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                167,
                'Amit Banda',
                'ABANDA',
                '011.44.1346.729268',
                TO_DATE('21-04-2008', 'dd-MM-yyyy'),
                'SA_REP',
                6200,
.10,
                147,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                168,
                'Lisa Ozer',
                'LOZER',
                '011.44.1343.929268',
                TO_DATE('11-03-2005', 'dd-MM-yyyy'),
                'SA_REP',
                11500,
.25,
                148,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                169,
                'Harrison Bloom',
                'HBLOOM',
                '011.44.1343.829268',
                TO_DATE('23-03-2006', 'dd-MM-yyyy'),
                'SA_REP',
                10000,
.20,
                148,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                170,
                'Tayler Fox',
                'TFOX',
                '011.44.1343.729268',
                TO_DATE('24-01-2006', 'dd-MM-yyyy'),
                'SA_REP',
                9600,
.20,
                148,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                171,
                'William Smith',
                'WSMITH',
                '011.44.1343.629268',
                TO_DATE('23-02-2007', 'dd-MM-yyyy'),
                'SA_REP',
                7400,
.15,
                148,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                172,
                'Elizabeth Bates',
                'EBATES',
                '011.44.1343.529268',
                TO_DATE('24-03-2007', 'dd-MM-yyyy'),
                'SA_REP',
                7300,
.15,
                148,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                173,
                'Sundita Kumar',
                'SKUMAR',
                '011.44.1343.329268',
                TO_DATE('21-04-2008', 'dd-MM-yyyy'),
                'SA_REP',
                6100,
.10,
                148,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                174,
                'Ellen Abel',
                'EABEL',
                '011.44.1644.429267',
                TO_DATE('11-05-2004', 'dd-MM-yyyy'),
                'SA_REP',
                11000,
.30,
                149,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                175,
                'Alyssa Hutton',
                'AHUTTON',
                '011.44.1644.429266',
                TO_DATE('19-03-2005', 'dd-MM-yyyy'),
                'SA_REP',
                8800,
.25,
                149,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                176,
                'Jonathon Taylor',
                'JTAYLOR',
                '011.44.1644.429265',
                TO_DATE('24-03-2006', 'dd-MM-yyyy'),
                'SA_REP',
                8600,
.20,
                149,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                177,
                'Jack Livingston',
                'JLIVINGS',
                '011.44.1644.429264',
                TO_DATE('23-04-2006', 'dd-MM-yyyy'),
                'SA_REP',
                8400,
.20,
                149,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                178,
                'Kimberely Grant',
                'KGRANT',
                '011.44.1644.429263',
                TO_DATE('24-05-2007', 'dd-MM-yyyy'),
                'SA_REP',
                7000,
.15,
                149,
                NULL
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                179,
                'Charles Johnson',
                'CJOHNSON',
                '011.44.1644.429262',
                TO_DATE('04-01-2008', 'dd-MM-yyyy'),
                'SA_REP',
                6200,
.10,
                149,
                80
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                180,
                'Winston Taylor',
                'WTAYLOR',
                '650.507.9876',
                TO_DATE('24-01-2006', 'dd-MM-yyyy'),
                'SH_CLERK',
                3200,
                NULL,
                120,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                181,
                'Jean Fleaur',
                'JFLEAUR',
                '650.507.9877',
                TO_DATE('23-02-2006', 'dd-MM-yyyy'),
                'SH_CLERK',
                3100,
                NULL,
                120,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                182,
                'Martha Sullivan',
                'MSULLIVA',
                '650.507.9878',
                TO_DATE('21-06-2007', 'dd-MM-yyyy'),
                'SH_CLERK',
                2500,
                NULL,
                120,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                183,
                'Girard Geoni',
                'GGEONI',
                '650.507.9879',
                TO_DATE('03-02-2008', 'dd-MM-yyyy'),
                'SH_CLERK',
                2800,
                NULL,
                120,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                184,
                'Nandita Sarchand',
                'NSARCHAN',
                '650.509.1876',
                TO_DATE('27-01-2004', 'dd-MM-yyyy'),
                'SH_CLERK',
                4200,
                NULL,
                121,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                185,
                'Alexis Bull',
                'ABULL',
                '650.509.2876',
                TO_DATE('20-02-2005', 'dd-MM-yyyy'),
                'SH_CLERK',
                4100,
                NULL,
                121,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                186,
                'Julia Dellinger',
                'JDELLING',
                '650.509.3876',
                TO_DATE('24-06-2006', 'dd-MM-yyyy'),
                'SH_CLERK',
                3400,
                NULL,
                121,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                187,
                'Anthony Cabrio',
                'ACABRIO',
                '650.509.4876',
                TO_DATE('07-02-2007', 'dd-MM-yyyy'),
                'SH_CLERK',
                3000,
                NULL,
                121,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                188,
                'Kelly Chung',
                'KCHUNG',
                '650.505.1876',
                TO_DATE('14-06-2005', 'dd-MM-yyyy'),
                'SH_CLERK',
                3800,
                NULL,
                122,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                189,
                'Jennifer Dilly',
                'JDILLY',
                '650.505.2876',
                TO_DATE('13-08-2005', 'dd-MM-yyyy'),
                'SH_CLERK',
                3600,
                NULL,
                122,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                190,
                'Timothy Gates',
                'TGATES',
                '650.505.3876',
                TO_DATE('11-07-2006', 'dd-MM-yyyy'),
                'SH_CLERK',
                2900,
                NULL,
                122,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                191,
                'Randall Perkins',
                'RPERKINS',
                '650.505.4876',
                TO_DATE('19-12-2007', 'dd-MM-yyyy'),
                'SH_CLERK',
                2500,
                NULL,
                122,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                192,
                'Sarah Bell',
                'SBELL',
                '650.501.1876',
                TO_DATE('04-02-2004', 'dd-MM-yyyy'),
                'SH_CLERK',
                4000,
                NULL,
                123,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                193,
                'Britney Everett',
                'BEVERETT',
                '650.501.2876',
                TO_DATE('03-03-2005', 'dd-MM-yyyy'),
                'SH_CLERK',
                3900,
                NULL,
                123,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                194,
                'Samuel McCain',
                'SMCCAIN',
                '650.501.3876',
                TO_DATE('01-07-2006', 'dd-MM-yyyy'),
                'SH_CLERK',
                3200,
                NULL,
                123,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                195,
                'Vance Jones',
                'VJONES',
                '650.501.4876',
                TO_DATE('17-03-2007', 'dd-MM-yyyy'),
                'SH_CLERK',
                2800,
                NULL,
                123,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                196,
                'Alana Walsh',
                'AWALSH',
                '650.507.9811',
                TO_DATE('24-04-2006', 'dd-MM-yyyy'),
                'SH_CLERK',
                3100,
                NULL,
                124,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                197,
                'Kevin Feeney',
                'KFEENEY',
                '650.507.9822',
                TO_DATE('23-05-2006', 'dd-MM-yyyy'),
                'SH_CLERK',
                3000,
                NULL,
                124,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                198,
                'Donald OConnell',
                'DOCONNEL',
                '650.507.9833',
                TO_DATE('21-06-2007', 'dd-MM-yyyy'),
                'SH_CLERK',
                2600,
                NULL,
                124,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                199,
                'Douglas Grant',
                'DGRANT',
                '650.507.9844',
                TO_DATE('13-01-2008', 'dd-MM-yyyy'),
                'SH_CLERK',
                2600,
                NULL,
                124,
                50
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                200,
                'Jennifer Whalen',
                'JWHALEN',
                '515.123.4444',
                TO_DATE('17-09-2003', 'dd-MM-yyyy'),
                'AD_ASST',
                4400,
                NULL,
                101,
                10
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                201,
                'Michael Hartstein',
                'MHARTSTE',
                '515.123.5555',
                TO_DATE('17-02-2004', 'dd-MM-yyyy'),
                'MK_MAN',
                13000,
                NULL,
                100,
                20
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                202,
                'Pat Fay',
                'PFAY',
                '603.123.6666',
                TO_DATE('17-08-2005', 'dd-MM-yyyy'),
                'MK_REP',
                6000,
                NULL,
                201,
                20
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                203,
                'Susan Mavris',
                'SMAVRIS',
                '515.123.7777',
                TO_DATE('07-06-2002', 'dd-MM-yyyy'),
                'HR_REP',
                6500,
                NULL,
                101,
                40
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                204,
                'Hermann Baer',
                'HBAER',
                '515.123.8888',
                TO_DATE('07-06-2002', 'dd-MM-yyyy'),
                'PR_REP',
                10000,
                NULL,
                101,
                70
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                205,
                'Shelley Higgins',
                'SHIGGINS',
                '515.123.8080',
                TO_DATE('07-06-2002', 'dd-MM-yyyy'),
                'AC_MGR',
                12008,
                NULL,
                101,
                110
        );
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_supervisor, id_departamento)
VALUES (
                206,
                'William Gietz',
                'WGIETZ',
                '515.123.8181',
                TO_DATE('07-06-2002', 'dd-MM-yyyy'),
                'AC_ACCOUNT',
                8300,
                NULL,
                205,
                110
        );
        
--INSERTS departamentos
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (10, 'Administration', 1700, 200);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (20, 'Marketing', 1800, 201);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (30, 'Purchasing', 1700, 114);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (40, 'Human Resources', 2400, 203);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (50, 'Shipping', 1500, 121);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (60, 'IT', 1400, 103);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (70, 'Public Relations', 2700, 204);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (80, 'Sales', 2500, 145);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (90, 'Executive', 1700, 100);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (100, 'Finance', 1700, 108);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (110, 'Accounting', 1700, 205);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (120, 'Treasury', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (130, 'Corporate Tax', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (140, 'Control And Credit', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (150, 'Shareholder Services', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (160, 'Benefits', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (170, 'Manufacturing', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (180, 'Construction', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (190, 'Contracting', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (200, 'Operations', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (210, 'IT Support', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (220, 'NOC', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (230, 'IT Helpdesk', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (240, 'Government Sales', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (250, 'Retail Sales', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (260, 'Recruiting', 1700, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES (270, 'Payroll', 1700, null);

--INSERTS historico_cargos
INSERT INTO hr.historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2001-01-13', '102', '2006-07-24', 60, 'IT_PROG');
INSERT INTO hr.historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2001-10-28', '101', '2005-03-15', 110, 'AC_MGR');
INSERT INTO hr.historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2004-02-17', '201', '2007-12-19', 20, 'MK_REP');
INSERT INTO hr.historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2006-03-24', '114', '2007-12-31', 50, 'ST_CLERK');
INSERT INTO hr.historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2007-01-01', '122', '2007-12-31', 50, 'ST_CLERK');
INSERT INTO hr.historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('1995-09-17', '200', '2001-06-17', 90, 'AD_ASST');
INSERT INTO hr.historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2006-03-24', '176', '2006-12-31', 80, 'SA_REP');
INSERT INTO hr.historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2007-01-01', '176', '2007-12-31', 80, 'SA_MAN');
INSERT INTO hr.historico_cargos (data_inicial, id_empregado, data_final, id_departamento, id_cargo) VALUES ('2002-07-01', '200', '2006-12-31', 90, 'AC_ACCOUNT');


--paises constraints
ALTER TABLE hr.paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.regioes (id_regiao);

--localizacoes constraints
ALTER TABLE hr.localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES hr.paises (id_pais);

--historico_cargos constraints
ALTER TABLE hr.historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo);

ALTER TABLE hr.historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento);

ALTER TABLE hr.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES hr.empregados (id_empregado);


--empregados Constraints

ALTER TABLE hr.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo);


ALTER TABLE hr.empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento);


ALTER TABLE hr.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.empregados (id_empregado);


--departamento constraints
ALTER TABLE hr.departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.localizacoes (id_localizacao);


ALTER TABLE hr.departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_gerente)
REFERENCES hr.empregados (id_empregado);


