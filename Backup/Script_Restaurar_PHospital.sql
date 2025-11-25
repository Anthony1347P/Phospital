USE master
GO


---  Cambiar esta ruta al archivo .bak 
DECLARE @RutaBackup VARCHAR(500) = 'C: Cambiar esta ruta al archivo .bak '



--- Verificar que el archivo existe
IF NOT EXISTS (SELECT 1 FROM sys.backup_devices WHERE name = @RutaBackup)
BEGIN
END


IF EXISTS (SELECT name FROM sys.databases WHERE name = 'PHospital')
BEGIN
    ALTER DATABASE PHospital SET SINGLE_USER WITH ROLLBACK IMMEDIATE  
    DROP DATABASE PHospital      
END

--- Restaurar el backup
PRINT 'Iniciando restauracion...'
PRINT 'Archivo: ' + @RutaBackup
PRINT ''

RESTORE DATABASE PHospital
FROM DISK = @RutaBackup
WITH 
    REPLACE,
    RECOVERY,
    STATS = 10
GO




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
