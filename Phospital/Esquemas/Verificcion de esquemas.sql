USE PHospital;

--- Esquemas del sistema
SELECT 
    name AS Esquema,
    schema_id AS ID
FROM sys.schemas
WHERE name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria', 'dbo')
ORDER BY name;

--- Tablas por esquema
SELECT 
    SCHEMA_NAME(schema_id) AS Esquema,
    name AS Tabla,
    'Tabla' AS Tipo
FROM sys.tables
WHERE schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
ORDER BY Esquema, Tabla;

--- Vistas por esquema
SELECT 
    SCHEMA_NAME(schema_id) AS Esquema,
    name AS Vista,
    'Vista' AS Tipo
FROM sys.views
WHERE schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'), SCHEMA_ID('dbo'))
ORDER BY Esquema, Vista;

--- Funciones por esquema
SELECT 
    SCHEMA_NAME(schema_id) AS Esquema,
    name AS Funcion,
    CASE type
        WHEN 'FN' THEN 'Escalar'
        WHEN 'IF' THEN 'Tabla inline'
        WHEN 'TF' THEN 'Tabla'
    END AS TipoFuncion
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF')
AND schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'), SCHEMA_ID('dbo'))
ORDER BY Esquema, Funcion;

--- Procedimientos por esquema
SELECT 
    SCHEMA_NAME(schema_id) AS Esquema,
    name AS Procedimiento,
    'Procedimiento' AS Tipo
FROM sys.procedures
WHERE schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
ORDER BY Esquema, Procedimiento;

--- Triggers por tabla
SELECT 
    SCHEMA_NAME(t.schema_id) AS Esquema,
    OBJECT_NAME(tr.parent_id) AS Tabla,
    tr.name AS NombreTrigger,
    'Trigger' AS Tipo
FROM sys.triggers tr
JOIN sys.tables t ON tr.parent_id = t.object_id
WHERE t.schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
ORDER BY Esquema, Tabla, NombreTrigger;

--- Resumen total por esquema
SELECT 
    s.name AS Esquema,
    (SELECT COUNT(*) FROM sys.tables WHERE schema_id = s.schema_id) AS Tablas,
    (SELECT COUNT(*) FROM sys.views WHERE schema_id = s.schema_id) AS Vistas,
    (SELECT COUNT(*) FROM sys.objects WHERE type IN ('FN','IF','TF') AND schema_id = s.schema_id) AS Funciones,
    (SELECT COUNT(*) FROM sys.procedures WHERE schema_id = s.schema_id) AS Procedimientos,
    (SELECT COUNT(*) FROM sys.triggers tr JOIN sys.tables t ON tr.parent_id = t.object_id WHERE t.schema_id = s.schema_id) AS Triggers
FROM sys.schemas s
WHERE s.name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria', 'dbo')
ORDER BY s.name;