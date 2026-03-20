-- ============================================================
-- PROYECTO 2: AGENDA DE CONTACTOS EMPRESARIAL
-- Nivel: BÁSICO
-- Motor: Oracle Database 19c+
-- Conceptos: Constraints avanzados, Índices, GROUP BY,
--            HAVING, funciones de texto y fecha Oracle
-- Autor: Luis Angel Tapias Madronero
-- ============================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE contacto_etiquetas CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE contactos CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE etiquetas CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE empresas CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_empresa';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_contacto';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_etiqueta';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE SEQUENCE seq_empresa  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_contacto START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_etiqueta START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE TABLE empresas (
    id_empresa  NUMBER        DEFAULT seq_empresa.NEXTVAL PRIMARY KEY,
    nombre      VARCHAR2(200) NOT NULL UNIQUE,
    nit         VARCHAR2(20)  UNIQUE,
    sector      VARCHAR2(100),
    ciudad      VARCHAR2(100),
    sitio_web   VARCHAR2(200),
    fecha_reg   DATE          DEFAULT SYSDATE NOT NULL
);

CREATE TABLE contactos (
    id_contacto NUMBER        DEFAULT seq_contacto.NEXTVAL PRIMARY KEY,
    nombre      VARCHAR2(100) NOT NULL,
    apellido    VARCHAR2(100) NOT NULL,
    email       VARCHAR2(150) NOT NULL,
    telefono    VARCHAR2(20),
    cargo       VARCHAR2(100),
    id_empresa  NUMBER,
    ciudad      VARCHAR2(100),
    notas       VARCHAR2(500),
    favorito    NUMBER(1)     DEFAULT 0 NOT NULL,
    fecha_reg   DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_contacto_empresa FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa),
    CONSTRAINT uq_contacto_email   UNIQUE (email),
    CONSTRAINT chk_favorito        CHECK (favorito IN (0,1)),
    CONSTRAINT chk_email_formato   CHECK (email LIKE '%@%.%')
);

CREATE TABLE etiquetas (
    id_etiqueta NUMBER        DEFAULT seq_etiqueta.NEXTVAL PRIMARY KEY,
    nombre      VARCHAR2(50)  NOT NULL UNIQUE,
    color_hex   VARCHAR2(7)   DEFAULT '#0000FF'
);

CREATE TABLE contacto_etiquetas (
    id_contacto NUMBER NOT NULL,
    id_etiqueta NUMBER NOT NULL,
    CONSTRAINT pk_cont_etiq PRIMARY KEY (id_contacto, id_etiqueta),
    CONSTRAINT fk_ce_contacto FOREIGN KEY (id_contacto) REFERENCES contactos(id_contacto),
    CONSTRAINT fk_ce_etiqueta FOREIGN KEY (id_etiqueta) REFERENCES etiquetas(id_etiqueta)
);

-- Índices para búsquedas comunes
CREATE INDEX idx_contacto_nombre   ON contactos(UPPER(nombre), UPPER(apellido));
CREATE INDEX idx_contacto_empresa  ON contactos(id_empresa);
CREATE INDEX idx_contacto_ciudad   ON contactos(ciudad);
CREATE INDEX idx_empresa_sector    ON empresas(sector);

-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================
INSERT INTO empresas (nombre, nit, sector, ciudad) VALUES ('Bancolombia S.A.',    '890903938-8', 'Financiero',    'Medellín');
INSERT INTO empresas (nombre, nit, sector, ciudad) VALUES ('Ecopetrol S.A.',      '899999068-1', 'Energía',       'Bogotá');
INSERT INTO empresas (nombre, nit, sector, ciudad) VALUES ('Grupo Éxito S.A.',    '860007650-3', 'Retail',        'Medellín');
INSERT INTO empresas (nombre, nit, sector, ciudad) VALUES ('Claro Colombia',      '800153993-9', 'Telecomunicaciones', 'Bogotá');
INSERT INTO empresas (nombre, nit, sector, ciudad) VALUES ('Rappi Colombia S.A.', '901081401-7', 'Tecnología',    'Bogotá');

INSERT INTO contactos (nombre, apellido, email, telefono, cargo, id_empresa, ciudad, favorito)
VALUES ('Santiago', 'Reyes',    'santiago.reyes@bancolombia.com',  '3001234567', 'Gerente TI',      1, 'Medellín', 1);
INSERT INTO contactos (nombre, apellido, email, telefono, cargo, id_empresa, ciudad, favorito)
VALUES ('Isabella', 'Moreno',   'i.moreno@ecopetrol.com',          '3012345678', 'Analista Datos',  2, 'Bogotá',   0);
INSERT INTO contactos (nombre, apellido, email, telefono, cargo, id_empresa, ciudad, favorito)
VALUES ('Alejandro','Vargas',   'a.vargas@exito.com',              '3023456789', 'Jefe Sistemas',   3, 'Medellín', 0);
INSERT INTO contactos (nombre, apellido, email, telefono, cargo, id_empresa, ciudad, favorito)
VALUES ('Natalia',  'Jiménez',  'n.jimenez@claro.com.co',          '3034567890', 'DBA Senior',      4, 'Bogotá',   1);
INSERT INTO contactos (nombre, apellido, email, telefono, cargo, id_empresa, ciudad, favorito)
VALUES ('Camilo',   'Herrera',  'c.herrera@rappi.com',             '3045678901', 'Dev Backend',     5, 'Bogotá',   0);
INSERT INTO contactos (nombre, apellido, email, telefono, cargo, id_empresa, ciudad, favorito)
VALUES ('Daniela',  'Castro',   'daniela.castro@freelance.co',     '3056789012', 'Consultora SQL',  NULL,'Cali',   1);

INSERT INTO etiquetas (nombre, color_hex) VALUES ('Cliente',    '#28A745');
INSERT INTO etiquetas (nombre, color_hex) VALUES ('Proveedor',  '#007BFF');
INSERT INTO etiquetas (nombre, color_hex) VALUES ('Colega',     '#FFC107');
INSERT INTO etiquetas (nombre, color_hex) VALUES ('Reclutador', '#DC3545');
INSERT INTO etiquetas (nombre, color_hex) VALUES ('Mentor',     '#6F42C1');

INSERT INTO contacto_etiquetas VALUES (1, 1);
INSERT INTO contacto_etiquetas VALUES (1, 3);
INSERT INTO contacto_etiquetas VALUES (2, 3);
INSERT INTO contacto_etiquetas VALUES (4, 5);
INSERT INTO contacto_etiquetas VALUES (5, 3);
INSERT INTO contacto_etiquetas VALUES (6, 2);
INSERT INTO contacto_etiquetas VALUES (6, 5);

COMMIT;

-- ============================================================
-- CONSULTAS AVANZADAS DE AGRUPACIÓN Y TEXTO
-- ============================================================

-- 1. Contactos favoritos con empresa y etiquetas
SELECT
    c.nombre || ' ' || c.apellido          AS contacto,
    c.cargo,
    NVL(e.nombre, 'Independiente')         AS empresa,
    c.ciudad,
    (SELECT LISTAGG(et.nombre, ', ')
            WITHIN GROUP (ORDER BY et.nombre)
     FROM contacto_etiquetas ce
     JOIN etiquetas et ON ce.id_etiqueta = et.id_etiqueta
     WHERE ce.id_contacto = c.id_contacto) AS etiquetas
FROM contactos c
LEFT JOIN empresas e ON c.id_empresa = e.id_empresa
WHERE c.favorito = 1
ORDER BY c.apellido;

-- 2. Contactos por ciudad con conteo
SELECT
    NVL(ciudad, 'Sin ciudad') AS ciudad,
    COUNT(*)                   AS total_contactos,
    SUM(favorito)              AS favoritos
FROM contactos
GROUP BY ciudad
HAVING COUNT(*) >= 1
ORDER BY total_contactos DESC;

-- 3. Empresas con más de 1 contacto
SELECT
    e.nombre AS empresa,
    e.sector,
    COUNT(c.id_contacto) AS num_contactos
FROM empresas e
INNER JOIN contactos c ON e.id_empresa = c.id_empresa
GROUP BY e.nombre, e.sector
HAVING COUNT(c.id_contacto) > 0
ORDER BY num_contactos DESC;

-- 4. Búsqueda por nombre (insensible a mayúsculas)
SELECT nombre, apellido, email, cargo
FROM contactos
WHERE UPPER(nombre || ' ' || apellido) LIKE UPPER('%santiago%');

-- 5. Contactos agregados en el último mes
SELECT nombre, apellido, cargo, TO_CHAR(fecha_reg, 'DD/MM/YYYY') AS fecha_registro
FROM contactos
WHERE fecha_reg >= ADD_MONTHS(SYSDATE, -1)
ORDER BY fecha_reg DESC;

-- 6. Reporte: etiquetas más usadas
SELECT
    e.nombre   AS etiqueta,
    e.color_hex,
    COUNT(ce.id_contacto) AS veces_usada
FROM etiquetas e
LEFT JOIN contacto_etiquetas ce ON e.id_etiqueta = ce.id_etiqueta
GROUP BY e.nombre, e.color_hex
ORDER BY veces_usada DESC;
