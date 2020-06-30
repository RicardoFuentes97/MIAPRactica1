

/*1. Generar el script que crea cada una de las tablas que conforman la base de
datos propuesta por el Comité Olímpico.*/

CREATE TABLE PROFESION(
    cod_prof SERIAL NOT NULL ,
    nombre   VARCHAR(50)  NOT NULL,
    PRIMARY KEY (cod_prof),
    CONSTRAINT pr_nombre UNIQUE (nombre)
);

CREATE TABLE PAIS(
    cod_pais SERIAL NOT NULL,
    nombre VARCHAR(50)  NOT NULL,
    PRIMARY KEY (cod_pais),
    CONSTRAINT pa_nombre UNIQUE (nombre)
);

CREATE TABLE PUESTO(
    cod_puesto SERIAL NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (cod_puesto),
    CONSTRAINT pu_nombre UNIQUE (nombre)
);

CREATE TABLE DEPARTAMENTO(
    cod_depto SERIAL NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (cod_depto),
    CONSTRAINT de_nombre UNIQUE (nombre)
);

CREATE TABLE TIPO_MEDALLA(
    cod_tipo SERIAL NOT NULL,
    medalla VARCHAR(20)  NOT NULL,
    PRIMARY KEY (cod_tipo),
    CONSTRAINT tm_medalla UNIQUE (medalla)
);


CREATE TABLE DISCIPLINA(
    cod_disciplina SERIAL NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),
    PRIMARY KEY (cod_disciplina)
);

CREATE TABLE CATEGORIA(
    cod_categoria SERIAL NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY(cod_categoria)
);

CREATE TABLE TIPO_PARTICIPACION(
    cod_participacion SERIAL NOT NULL,
    tipo_participacion VARCHAR(100) NOT NULL,
    PRIMARY key (cod_participacion)
);

CREATE TABLE TELEVISORA(
    cod_televisora SERIAL NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (cod_televisora)
);

CREATE TABLE MIEMBRO(
    cod_miembro SERIAL NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    edad INTEGER NOT NULL,
    telefono INTEGER,
    residencia VARCHAR(100),
    PAIS_cod_pais INTEGER NOT NULL,
    PROFESION_cod_prof INTEGER NOT NULL,
    PRIMARY KEY (cod_miembro),
    CONSTRAINT MPAIS_cod_pais_fk FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS (cod_pais),
    CONSTRAINT MPROFESION_cod_prof_fk FOREIGN KEY (PROFESION_cod_prof) REFERENCES PROFESION (cod_prof)
);

CREATE TABLE PUESTO_MIEMBRO(
    MIEMBRO_cod_miembro INTEGER NOT NULL,
    PUESTO_cod_puesto INTEGER  NOT NULL,
    DEPARTEMENTO_cod_depto INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    PRIMARY KEY (MIEMBRO_cod_miembro,PUESTO_cod_puesto,DEPARTEMENTO_cod_depto),
    CONSTRAINT PMIEMBRO_cod_miembro_fk FOREIGN KEY (MIEMBRO_cod_miembro) REFERENCES MIEMBRO (cod_miembro),
    CONSTRAINT PPUESTO_cod_puesto_fk FOREIGN KEY (PUESTO_cod_puesto) REFERENCES PUESTO (cod_puesto),
    CONSTRAINT PDEPARTEMENTO_cod_depto_fk FOREIGN KEY (DEPARTEMENTO_cod_depto) REFERENCES DEPARTAMENTO (cod_depto)
);

CREATE TABLE MEDALLERO( 
    PAIS_cod_pais INTEGER NOT NULL,
    cantidad_medallas INTEGER NOT NULL,
    TIPO_MEDALLA_cod_tipo INTEGER NOT NULL,
    PRIMARY KEY (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo),
    CONSTRAINT MEPAIS_cod_pais_fk FOREIGN key (PAIS_cod_pais) REFERENCES  PAIS (cod_pais),
    CONSTRAINT METIPO_MEDALLA_cod_tipo_fk FOREIGN KEY (TIPO_MEDALLA_cod_tipo) REFERENCES TIPO_MEDALLA (cod_tipo)
);

CREATE TABLE EVENTO(
    cod_evento SERIAL NOT NULL,
    fecha DATE NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    hora DATE NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    TIPO_PARTICIPACION_cod_participacion INTEGER NOT NULL,
    CATEGORIA_cod_categoria INTEGER NOT NULL,
    PRIMARY KEY (cod_evento),
    CONSTRAINT EDISCIPLINA_cod_disciplina_fk FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA (cod_disciplina),
    CONSTRAINT ETIPO_PARTICIPACION_cod_participacion_fk FOREIGN KEY (TIPO_PARTICIPACION_cod_participacion) REFERENCES TIPO_PARTICIPACION (cod_participacion),
    CONSTRAINT ECATEGORIA_cod_categoria_fk FOREIGN KEY (CATEGORIA_cod_categoria) REFERENCES CATEGORIA (cod_categoria)
);

CREATE TABLE COSTO_EVENTO(
    EVENTO_cod_evento INTEGER NOT NULL,
    TELEVISORA_cod_televisora INTEGER NOT NULL,
    tarifa INTEGER NOT NULL,
    PRIMARY KEY (EVENTO_cod_evento,TELEVISORA_cod_televisora),
    CONSTRAINT CEVENTO_cod_evento_fk FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO (cod_evento),
    CONSTRAINT CTELEVISORA_cod_televisora_fk FOREIGN KEY (TELEVISORA_cod_televisora) REFERENCES TELEVISORA (cod_televisora)
);

CREATE TABLE ATLETA(
    cod_atleta SERIAL NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INTEGER NOT NULL,
    participaciones VARCHAR(100) NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    PAIS_cod_pais INTEGER NOT NULL,
    PRIMARY KEY (cod_atleta),
    CONSTRAINT ADISCIPLINA_cod_disciplina_fk FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA (cod_disciplina),
    CONSTRAINT APAIS_cod_pais_fk FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS (cod_pais)
);

CREATE TABLE EVENTO_ATLETA(
    ATLETA_cod_atleta INTEGER NOT NULL,
    EVENTO_cod_evento INTEGER NOT NULL,
    PRIMARY KEY (ATLETA_cod_atleta,EVENTO_cod_evento),
    CONSTRAINT EAATLETA_cod_atleta_fk FOREIGN KEY (ATLETA_cod_atleta) REFERENCES ATLETA (cod_atleta),
    CONSTRAINT EAEVENTO_cod_evento_fk FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO (cod_evento)
);

/*2. En la tabla “Evento” se decidió que la fecha y hora se trabajaría en una sola
columna.*/

ALTER TABLE EVENTO DROP hora;
ALTER TABLE EVENTO DROP fecha;


ALTER TABLE EVENTO ADD fecha_hora timestamp;


/*3.Todos los eventos de las olimpiadas deben ser programados del 24 de julio
de 2020 a partir de las 9:00:00 hasta el 09 de agosto de 2020 hasta las
20:00:00.*/

 ALTER TABLE EVENTO
 ADD CONSTRAINT fecha_programanda
 CHECK  (fecha_hora>='24/07/2020 9:00:00.00' AND fecha_hora<='09/08/2020 20:00:00.00') ;

/*4.Se decidió que las ubicación de los eventos se registrarán previamente en
una tabla y que en la tabla “Evento” sólo se almacenara la llave foránea
según el código del registro de la ubicación.*/

CREATE TABLE SEDE(
    codigo SERIAL NOT NULL,
    sede VARCHAR(50) NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE EVENTO ALTER COLUMN ubicacion TYPE INTEGER USING (ubicacion::INTEGER);

ALTER TABLE EVENTO
    ADD CONSTRAINT FK_SEDE_codigo
    FOREIGN KEY (ubicacion)
    REFERENCES SEDE (codigo);


/*5. Se revisó la información de los miembros que se tienen actualmente y antes
de que se ingresen a la base de datos el Comité desea que a los miembros
que no tengan número telefónico se le ingrese el número por Default 0 al
momento de ser cargados a la base de datos. */

ALTER TABLE MIEMBRO ALTER COLUMN telefono SET DEFAULT 0;

/*6.Generar el script necesario para hacer la inserción de datos a las tablas
requeridas.*/

INSERT INTO PAIS (nombre) VALUES ('Guatemala');
INSERT INTO PAIS (nombre) VALUES ('Francia');
INSERT INTO PAIS (nombre) VALUES ('Argentina');
INSERT INTO PAIS (nombre) VALUES ('Alemania');
INSERT INTO PAIS (nombre) VALUES ('Italia');
INSERT INTO PAIS (nombre) VALUES ('Brasil');
INSERT INTO PAIS (nombre) VALUES ('Estados Unidos');
SELECT * FROM pais;

INSERT INTO PROFESION (nombre) VALUES ('Médico');
INSERT INTO PROFESION (nombre) VALUES ('Arquitecto');
INSERT INTO PROFESION (nombre) VALUES ('Ingeniero');
INSERT INTO PROFESION (nombre) VALUES ('Secretaria');
INSERT INTO PROFESION (nombre) VALUES ('Auditor');
SELECT * FROM profesion;

INSERT INTO MIEMBRO (nombre,apellido,edad,residencia,PAIS_cod_pais,PROFESION_cod_prof) VALUES ('Scott','Mitchell',32,'1092 Highland Drive Manitowoc, WI 54220',7,3);
INSERT INTO MIEMBRO (nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof) VALUES ('Fanette','Fanette',25,25075853,'49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY',2,4);
INSERT INTO MIEMBRO (nombre,apellido,edad,residencia,PAIS_cod_pais,PROFESION_cod_prof) VALUES ('Laura','Cunha Silva',55,'Rua Onze, 86 Uberaba-MG',6,5);
INSERT INTO MIEMBRO (nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof) VALUES ('Juan José','López',38,36985247,'26 calle 4-10 zona 11',1,2);
INSERT INTO MIEMBRO (nombre,apellido,edad,telefono,residencia,PAIS_cod_pais,PROFESION_cod_prof) VALUES ('Arcangela','Panicucci',39,391664921,'Via Santa Teresa, 114 90010-Geraci Siculo PA',5,1);
INSERT INTO MIEMBRO (nombre,apellido,edad,residencia,PAIS_cod_pais,PROFESION_cod_prof) VALUES ('Jeuel','Villalpando',31,'Acuña de Figeroa 6106',3,5);
SELECT * FROM miembro;

INSERT INTO DISCIPLINA (nombre,descripcion) VALUES ('Atletismo','Saltos de longitud y triples, de altura y con pértiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco.');
INSERT INTO DISCIPLINA (nombre) VALUES ('Bádminton');
INSERT INTO DISCIPLINA (nombre) VALUES ('Ciclismo');
INSERT INTO DISCIPLINA (nombre,descripcion) VALUES ('Judo','Es un arte marcial que se originó en Japón alrededor de 1880');
INSERT INTO DISCIPLINA (nombre) VALUES ('Lucha');
INSERT INTO DISCIPLINA (nombre) VALUES ('Tenis de Mesa');
INSERT INTO DISCIPLINA (nombre) VALUES ('Boxeo');
INSERT INTO DISCIPLINA (nombre,descripcion) VALUES ('Natación','Está presente como deporte en los Juegos desde la primera edición de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas.');
INSERT INTO DISCIPLINA (nombre) VALUES ('Esgrima');
INSERT INTO DISCIPLINA (nombre) VALUES ('Vela');
SELECT * FROM disciplina;

INSERT INTO TIPO_MEDALLA(medalla) VALUES ('Oro');
INSERT INTO TIPO_MEDALLA(medalla) VALUES ('Plata');
INSERT INTO TIPO_MEDALLA(medalla) VALUES ('Bronce');
INSERT INTO TIPO_MEDALLA(medalla) VALUES ('Platino');
SELECT * FROM tipo_medalla;

INSERT INTO CATEGORIA (categoria) VALUES ('Clasificatorio');
INSERT INTO CATEGORIA (categoria) VALUES ('Eliminatorio');
INSERT INTO CATEGORIA (categoria) VALUES ('Final');
SELECT * FROM categoria;

INSERT INTO TIPO_PARTICIPACION(tipo_participacion) VALUES ('Individual');
INSERT INTO TIPO_PARTICIPACION(tipo_participacion) VALUES ('Parejas');
INSERT INTO TIPO_PARTICIPACION(tipo_participacion) VALUES ('Equipos');
SELECT * FROM tipo_participacion;

INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES(5,1,3);
INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES(2,1,5);
INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES(6,3,4);
INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES(4,4,3);
INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES(7,3,10);
INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES(3,2,8);
INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES(1,1,2);
INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES(1,4,5);
INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES(5,2,7);
SELECT * FROM medallero;


INSERT INTO SEDE (sede) VALUES ('Gimnasio Metropolitano de Tokio');
INSERT INTO SEDE (sede) VALUES ('Jardín del Palacio Imperial de Tokio');
INSERT INTO SEDE (sede) VALUES ('Gimnasio Nacional Yoyogi');
INSERT INTO SEDE (sede) VALUES ('Nippon Budokan');
INSERT INTO SEDE (sede) VALUES ('Estadio Olímpico');
SELECT * FROM sede;

INSERT INTO EVENTO(fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_participacion,CATEGORIA_cod_categoria) VALUES ('24/07/2020 11:00:00.00',3,2,2,1);
INSERT INTO EVENTO(fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_participacion,CATEGORIA_cod_categoria) VALUES ('26/07/2020 10:30:00.00',1,6,1,3);
INSERT INTO EVENTO(fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_participacion,CATEGORIA_cod_categoria) VALUES ('30/07/2020 18:45:00.00',5,7,1,2);
INSERT INTO EVENTO(fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_participacion,CATEGORIA_cod_categoria) VALUES ('01/08/2020 12:15:00.00',2,1,1,1);
INSERT INTO EVENTO(fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_participacion,CATEGORIA_cod_categoria) VALUES ('08/08/2020 19:35:00.00',4,10,3,1);
SELECT * FROM evento;

/*7.Después de que se implementó el script el cuál creó todas las tablas de las
bases de datos, el Comité Olímpico Internacional tomó la decisión de
eliminar la restricción “UNIQUE” de las siguientes tablas: pais, tipo_medalla, departamento*/
ALTER TABLE PAIS DROP CONSTRAINT pa_nombre;
ALTER TABLE TIPO_MEDALLA DROP CONSTRAINT tm_medalla;
ALTER TABLE DEPARTAMENTO DROP CONSTRAINT de_nombre;

/*8.Después de un análisis más profundo se decidió que los Atletas pueden
participar en varias disciplinas y no sólo en una como está reflejado
actualmente en las tablas, por lo que se pide que realice lo siguiente.*/

ALTER TABLE ATLETA DROP CONSTRAINT ADISCIPLINA_cod_disciplina_fk;

CREATE TABLE Disciplina_Atleta(
    ATETLA_cod_atleta INTEGER NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    PRIMARY key (ATETLA_cod_atleta,DISCIPLINA_cod_disciplina),
    CONSTRAINT ATETLA_cod_atleta_FK FOREIGN KEY (ATETLA_cod_atleta) REFERENCES ATLETA (cod_atleta),
    CONSTRAINT DISCIPLINA_cod_disciplina_FK FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA (cod_disciplina)
);

/*9.En la tabla “Costo_Evento” se determinó que la columna “tarifa” no debe
ser entero sino un decimal con 2 cifras de precisión.*/

ALTER TABLE COSTO_EVENTO ALTER COLUMN tarifa TYPE NUMERIC(10,2) USING (tarifa::NUMERIC);

/*10.Generar el Script que borre de la tabla “Tipo_Medalla”, el registro siguiente*/
 DELETE FROM MEDALLERO WHERE TIPO_MEDALLA_cod_tipo=4;
 DELETE FROM TIPO_MEDALLA WHERE cod_tipo=4;
 SELECT * FROM tipo_medalla;

/*11.La fecha de las olimpiadas está cerca y los preparativos siguen, pero de
último momento se dieron problemas con las televisoras encargadas de
transmitir los eventos, ya que no hay tiempo de solucionar los problemas
que se dieron, se decidió no transmitir el evento a través de las televisoras
por lo que el Comité Olímpico pide generar el script que elimine la tabla
“TELEVISORAS” y “COSTO_EVENTO”. */
DROP TABLE COSTO_EVENTO;
DROP TABLE TELEVISORA;

/*12.El comité olímpico quiere replantear las disciplinas que van a llevarse a cabo,
por lo cual pide generar el script que elimine todos los registros contenidos
en la tabla “DISCIPLINA”.*/

DELETE FROM EVENTO;
DELETE FROM DISCIPLINA;
SELECT * FROM disciplina;

/*13.Los miembros que no tenían registrado su número de teléfono en sus
perfiles fueron notificados, por lo que se acercaron a las instalaciones de
Comité para actualizar sus datos.*/

update MIEMBRO set telefono=55464601 where cod_miembro=3;
update MIEMBRO set telefono=91514243 where cod_miembro=6;
update MIEMBRO set telefono=920686670 where cod_miembro=1;
SELECT * FROM miembro;

/*14.El Comité decidió que necesita la fotografía en la información de los atletas
para su perfil, por lo que se debe agregar la columna “Fotografía” a la tabla
Atleta, debido a que es un cambio de última hora este campo deberá ser
opcional.*/
ALTER TABLE ATLETA ADD FOTOGRAFIA VARCHAR(100);
SELECT * FROM atleta;

/*15.Todos los atletas que se registren deben cumplir con ser menores a 25 años.
De lo contrario no se debe poder registrar a un atleta en la base de datos.*/

 ALTER TABLE ATLETA
 ADD CONSTRAINT edad_restriccion
 CHECK  (edad<=25) ;
