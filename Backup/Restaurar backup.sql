USE master
GO

--- eliminar base de datos
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'PHospital')
BEGIN
    ALTER DATABASE PHospital SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE PHospital
END
GO

--- Restaurar backup
RESTORE DATABASE PHospital 
FROM DISK = 'AQUI COPIAN LA RUTA DESDE C:' 
WITH RECOVERY;


--- Verificar la restauracion
USE PHospital
GO



--- Verificar esquemas
SELECT name AS Esquema FROM sys.schemas 
WHERE name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria')

--- Verificar tablas
SELECT s.name AS Esquema, o.name AS Tabla
FROM sys.tables o
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE s.name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria')
ORDER BY s.name

--- Verificar objetos creados en cada esquema
SELECT s.name AS Esquema, o.name AS Objeto, o.type_desc AS Tipo 
FROM sys.objects o 
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id 
WHERE s.name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria') 
ORDER BY s.name, o.type_desc
GO

--- Verificar datos
SELECT 'Pacientes' AS Tabla, COUNT(*) AS Registros FROM Pacientes.Pacientes
UNION ALL SELECT 'Medicos', COUNT(*) FROM Personal.Medicos
UNION ALL SELECT 'Consultas', COUNT(*) FROM Secretaria.Consultas
UNION ALL SELECT 'Facturas', COUNT(*) FROM Tesoreria.Factura


SELECT 'Vistas' AS Tipo, COUNT(*) AS Cantidad FROM sys.views 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
UNION ALL


SELECT 'Funciones', COUNT(*) FROM sys.objects 
WHERE type IN ('FN', 'IF', 'TF') 
AND schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
UNION ALL

SELECT 'Triggers', COUNT(*) FROM sys.triggers WHERE is_ms_shipped = 0
UNION ALL

SELECT 'Procedimientos', COUNT(*) FROM sys.procedures 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
