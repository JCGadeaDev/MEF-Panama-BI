-- ============================================================
-- MINISTERIO DE ECONOMÍA Y FINANZAS — PANAMÁ
-- Script SQL: Modelo de Datos para Power BI
-- Base: SQL Server 2019+ / PostgreSQL 15+
-- Demo BI 2025
-- ============================================================

-- ============================================================
-- 1. ESQUEMA Y DIMENSIONES
-- ============================================================

CREATE SCHEMA IF NOT EXISTS mef;

-- DIM: Sectores
CREATE TABLE mef.dim_sector (
    id_sector     INT           PRIMARY KEY,
    nombre_sector VARCHAR(60)   NOT NULL,
    descripcion   VARCHAR(200),
    activo        BIT           DEFAULT 1
);

INSERT INTO mef.dim_sector VALUES
(1, 'Social',          'Educación, Salud, Vivienda y Seguridad Social', 1),
(2, 'Infraestructura', 'Obras Públicas y Transporte',                   1),
(3, 'Seguridad',       'Seguridad Pública y Defensa',                   1),
(4, 'Económico',       'Economía, Comercio, Agricultura y Ambiente',    1);

-- DIM: Ministerios / Entidades
CREATE TABLE mef.dim_ministerio (
    id_ministerio    INT          PRIMARY KEY,
    codigo_siaf      VARCHAR(20)  NOT NULL UNIQUE,
    nombre           VARCHAR(100) NOT NULL,
    nombre_corto     VARCHAR(40),
    id_sector        INT          REFERENCES mef.dim_sector(id_sector),
    titular          VARCHAR(100),
    activo           BIT          DEFAULT 1,
    fecha_creacion   DATE
);

INSERT INTO mef.dim_ministerio VALUES
(1,  'MEDUCA',      'Ministerio de Educación',                 'MEDUCA',     1, NULL, 1, '1904-11-03'),
(2,  'CSS',         'Caja de Seguro Social',                   'CSS',        1, NULL, 1, '1941-03-07'),
(3,  'MINSA',       'Ministerio de Salud',                     'MINSA',      1, NULL, 1, '1969-01-01'),
(4,  'MIVIOT',      'Ministerio de Vivienda y Ordenamiento',   'MIVIOT',     1, NULL, 1, '1973-01-01'),
(5,  'MOP',         'Ministerio de Obras Públicas',            'MOP',        2, NULL, 1, '1904-11-03'),
(6,  'MINSEG',      'Ministerio de Seguridad Pública',         'MINSEG',     3, NULL, 1, '2010-01-01'),
(7,  'MEF',         'Ministerio de Economía y Finanzas',       'MEF',        4, NULL, 1, '1998-01-01'),
(8,  'MICI',        'Ministerio de Comercio e Industrias',     'MICI',       4, NULL, 1, '1973-01-01'),
(9,  'MIDA',        'Ministerio de Desarrollo Agropecuario',   'MIDA',       4, NULL, 1, '1975-01-01'),
(10, 'MiAMBIENTE',  'Ministerio de Ambiente',                  'MiAMBIENTE', 4, NULL, 1, '2015-01-01');

-- DIM: Tiempo
CREATE TABLE mef.dim_tiempo (
    id_tiempo      INT         PRIMARY KEY,
    anio_fiscal    SMALLINT    NOT NULL,
    trimestre      TINYINT,
    mes            TINYINT,
    nombre_mes     VARCHAR(20),
    es_cierre      BIT         DEFAULT 0
);

INSERT INTO mef.dim_tiempo VALUES
(20221, 2022, 1, NULL, 'Anual', 1),
(20231, 2023, 1, NULL, 'Anual', 1),
(20241, 2024, 1, NULL, 'Anual', 1);

-- ============================================================
-- 2. TABLA DE HECHOS
-- ============================================================

CREATE TABLE mef.fact_presupuesto (
    id_presupuesto        BIGINT       PRIMARY KEY IDENTITY(1,1),
    id_ministerio         INT          NOT NULL REFERENCES mef.dim_ministerio(id_ministerio),
    id_tiempo             INT          NOT NULL REFERENCES mef.dim_tiempo(id_tiempo),
    presupuesto_aprobado  DECIMAL(14,2) NOT NULL DEFAULT 0,
    monto_ejecutado       DECIMAL(14,2) NOT NULL DEFAULT 0,
    monto_comprometido    DECIMAL(14,2)          DEFAULT 0,
    estado                VARCHAR(20)  DEFAULT 'CERRADO',
    fecha_carga           DATETIME     DEFAULT GETDATE(),  -- SQL Server; usa NOW() en PG
    fuente_datos          VARCHAR(50)  DEFAULT 'SIAF'
);

-- ============================================================
-- 3. CARGA DE DATOS HISTÓRICOS
-- ============================================================

INSERT INTO mef.fact_presupuesto (id_ministerio, id_tiempo, presupuesto_aprobado, monto_ejecutado, estado) VALUES
-- 2022
(1,  20221, 1850.00, 1720.00, 'CERRADO'),
(2,  20221, 2200.00, 2150.00, 'CERRADO'),
(3,  20221,  980.00,  940.00, 'CERRADO'),
(4,  20221,  340.00,  298.00, 'CERRADO'),
(5,  20221,  750.00,  680.00, 'CERRADO'),
(6,  20221,  520.00,  498.00, 'CERRADO'),
(7,  20221,  420.00,  400.00, 'CERRADO'),
(8,  20221,  190.00,  178.00, 'CERRADO'),
(9,  20221,  280.00,  245.00, 'CERRADO'),
(10, 20221,  120.00,  108.00, 'CERRADO'),
-- 2023
(1,  20231, 1980.00, 1890.00, 'CERRADO'),
(2,  20231, 2350.00, 2290.00, 'CERRADO'),
(3,  20231, 1050.00, 1010.00, 'CERRADO'),
(4,  20231,  370.00,  335.00, 'CERRADO'),
(5,  20231,  820.00,  760.00, 'CERRADO'),
(6,  20231,  560.00,  541.00, 'CERRADO'),
(7,  20231,  450.00,  438.00, 'CERRADO'),
(8,  20231,  210.00,  198.00, 'CERRADO'),
(9,  20231,  300.00,  272.00, 'CERRADO'),
(10, 20231,  135.00,  122.00, 'CERRADO'),
-- 2024
(1,  20241, 2120.00, 2050.00, 'CERRADO'),
(2,  20241, 2520.00, 2460.00, 'CERRADO'),
(3,  20241, 1150.00, 1095.00, 'CERRADO'),
(4,  20241,  400.00,  368.00, 'CERRADO'),
(5,  20241,  910.00,  855.00, 'CERRADO'),
(6,  20241,  590.00,  570.00, 'CERRADO'),
(7,  20241,  490.00,  475.00, 'CERRADO'),
(8,  20241,  230.00,  219.00, 'CERRADO'),
(9,  20241,  320.00,  296.00, 'CERRADO'),
(10, 20241,  148.00,  135.00, 'CERRADO');

-- ============================================================
-- 4. VISTAS PARA POWER BI (DirectQuery)
-- ============================================================

-- Vista principal: ejecución con todos los atributos
CREATE OR REPLACE VIEW mef.vw_ejecucion_presupuestaria AS
SELECT
    f.id_presupuesto,
    m.codigo_siaf,
    m.nombre                                              AS nombre_ministerio,
    m.nombre_corto,
    s.nombre_sector                                       AS sector,
    t.anio_fiscal,
    f.presupuesto_aprobado,
    f.monto_ejecutado,
    f.presupuesto_aprobado - f.monto_ejecutado            AS saldo_no_ejecutado,
    ROUND(f.monto_ejecutado / NULLIF(f.presupuesto_aprobado,0) * 100, 2)
                                                          AS pct_ejecucion,
    f.estado
FROM mef.fact_presupuesto f
JOIN mef.dim_ministerio  m ON f.id_ministerio = m.id_ministerio
JOIN mef.dim_sector      s ON m.id_sector     = s.id_sector
JOIN mef.dim_tiempo      t ON f.id_tiempo     = t.id_tiempo;

-- Vista: resumen por sector y año
CREATE OR REPLACE VIEW mef.vw_resumen_sector AS
SELECT
    s.nombre_sector,
    t.anio_fiscal,
    SUM(f.presupuesto_aprobado)                                    AS total_aprobado,
    SUM(f.monto_ejecutado)                                         AS total_ejecutado,
    SUM(f.presupuesto_aprobado - f.monto_ejecutado)                AS total_saldo,
    ROUND(SUM(f.monto_ejecutado) / NULLIF(SUM(f.presupuesto_aprobado),0) * 100, 2)
                                                                   AS pct_ejecucion
FROM mef.fact_presupuesto f
JOIN mef.dim_ministerio m ON f.id_ministerio = m.id_ministerio
JOIN mef.dim_sector     s ON m.id_sector     = s.id_sector
JOIN mef.dim_tiempo     t ON f.id_tiempo     = t.id_tiempo
GROUP BY s.nombre_sector, t.anio_fiscal;

-- Vista: variación interanual por entidad (LAG)
CREATE OR REPLACE VIEW mef.vw_variacion_anual AS
SELECT
    m.nombre_corto,
    s.nombre_sector,
    t.anio_fiscal,
    f.monto_ejecutado,
    LAG(f.monto_ejecutado) OVER (
        PARTITION BY f.id_ministerio ORDER BY t.anio_fiscal
    )                                                              AS ejecutado_anio_ant,
    ROUND(
        (f.monto_ejecutado - LAG(f.monto_ejecutado) OVER (
            PARTITION BY f.id_ministerio ORDER BY t.anio_fiscal))
        / NULLIF(LAG(f.monto_ejecutado) OVER (
            PARTITION BY f.id_ministerio ORDER BY t.anio_fiscal), 0) * 100, 2
    )                                                              AS variacion_pct
FROM mef.fact_presupuesto f
JOIN mef.dim_ministerio m ON f.id_ministerio = m.id_ministerio
JOIN mef.dim_sector     s ON m.id_sector     = s.id_sector
JOIN mef.dim_tiempo     t ON f.id_tiempo     = t.id_tiempo;

-- ============================================================
-- 5. MEDIDAS DAX SUGERIDAS PARA POWER BI
-- ============================================================
-- (Comentadas como referencia — pegar en Power BI Desktop)

/*
-- % Ejecución Total
Pct Ejecución =
    DIVIDE(SUM(fact_presupuesto[monto_ejecutado]),
           SUM(fact_presupuesto[presupuesto_aprobado]), 0)

-- Variación YoY Ejecutado
Var YoY Ejecutado =
    VAR AnioActual = SELECTEDVALUE(dim_tiempo[anio_fiscal])
    VAR AnioAnt    = AnioActual - 1
    VAR EjActual   = CALCULATE(SUM(fact_presupuesto[monto_ejecutado]),
                               dim_tiempo[anio_fiscal] = AnioActual)
    VAR EjAnt      = CALCULATE(SUM(fact_presupuesto[monto_ejecutado]),
                               dim_tiempo[anio_fiscal] = AnioAnt)
    RETURN DIVIDE(EjActual - EjAnt, EjAnt, BLANK())

-- Ranking por Ejecución
Ranking Ejecución =
    RANKX(ALL(dim_ministerio[nombre]),
          [Pct Ejecución], , DESC, Dense)

-- Saldo No Ejecutado
Saldo No Ejecutado =
    SUM(fact_presupuesto[presupuesto_aprobado]) -
    SUM(fact_presupuesto[monto_ejecutado])
*/

-- ============================================================
-- 6. ÍNDICES DE RENDIMIENTO
-- ============================================================

CREATE INDEX idx_fact_ministerio ON mef.fact_presupuesto(id_ministerio);
CREATE INDEX idx_fact_tiempo     ON mef.fact_presupuesto(id_tiempo);
CREATE INDEX idx_fact_estado     ON mef.fact_presupuesto(estado);

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================


---VERIFICAR TABLAS ----
USE MEF_Panama_Demo;
GO

SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'mef'
ORDER BY TABLE_TYPE, TABLE_NAME;