USE PHospital;
GO

--- INDICES PARA PACIENTES.PACIENTES
CREATE UNIQUE NONCLUSTERED INDEX IDX_Pacientes_DUI ON Pacientes.Pacientes(DUI) WHERE DUI IS NOT NULL;
CREATE NONCLUSTERED INDEX IDX_Pacientes_Apellidos ON Pacientes.Pacientes(Apellidos);
CREATE NONCLUSTERED INDEX IDX_Pacientes_TipoSangre ON Pacientes.Pacientes(idTipoDeSangre);
GO

--- INDICES PARA PERSONAL.MEDICOS
CREATE NONCLUSTERED INDEX IDX_Medicos_Especialidad ON Personal.Medicos(idEspecialidad);
GO

--- INDICES PARA SECRETARIA.CONSULTAS
CREATE NONCLUSTERED INDEX IDX_Consultas_Fecha ON Secretaria.Consultas(Fecha);
CREATE NONCLUSTERED INDEX IDX_Consultas_Estado ON Secretaria.Consultas(Estado);
CREATE NONCLUSTERED INDEX IDX_Consultas_Paciente ON Secretaria.Consultas(idPaciente);
CREATE NONCLUSTERED INDEX IDX_Consultas_Medico ON Secretaria.Consultas(idMedico);
CREATE NONCLUSTERED INDEX IDX_Consultas_Paciente_Fecha ON Secretaria.Consultas(idPaciente, Fecha);
GO

--- INDICES PARA TESORERIA.FACTURA
CREATE NONCLUSTERED INDEX IDX_Factura_Fecha ON Tesoreria.Factura(Fecha);
CREATE NONCLUSTERED INDEX IDX_Factura_Paciente ON Tesoreria.Factura(idPaciente);
CREATE NONCLUSTERED INDEX IDX_Factura_Estado ON Tesoreria.Factura(Estado);
GO

--- INDICES PARA SECRETARIA.TRATAMIENTOXCONSULTA
CREATE NONCLUSTERED INDEX IDX_TratamientoXConsulta_Consulta ON Secretaria.TratamientoXConsulta(idConsulta);
GO

--- ANALISIS DE FRAGMENTACION
SELECT 
    OBJECT_NAME(ips.object_id) AS Tabla,
    i.name AS Indice,
    ips.index_type_desc AS Tipo,
    ips.avg_fragmentation_in_percent AS Fragmentacion
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.database_id = DB_ID()
ORDER BY Fragmentacion DESC;
GO

--- MANTENIMIENTO: REBUILD si fragmentacion mayor a 30%
ALTER INDEX IDX_Pacientes_TipoSangre ON Pacientes.Pacientes REBUILD;
ALTER INDEX IDX_Pacientes_DUI ON Pacientes.Pacientes REBUILD;
GO

--- MANTENIMIENTO: REORGANIZE si fragmentacion entre 10% y 30%
ALTER INDEX IDX_Pacientes_Apellidos ON Pacientes.Pacientes REORGANIZE;
GO

--- PRUEBAS DE RENDIMIENTO
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT * FROM Pacientes.Pacientes WHERE DUI = 25102023;
SELECT * FROM Pacientes.Pacientes WHERE Apellidos LIKE 'Garcia%';
SELECT * FROM Secretaria.Consultas WHERE Fecha BETWEEN '20240101' AND '20241231';
SELECT * FROM Secretaria.Consultas WHERE idPaciente = 1 ORDER BY Fecha;
SELECT * FROM Tesoreria.Factura WHERE Fecha >= '20240101';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

--- CONSULTA DE USO DE INDICES
SELECT 
    OBJECT_NAME(ius.object_id) AS Tabla,
    i.name AS Indice,
    ius.user_seeks AS Busquedas,
    ius.user_scans AS Escaneos,
    ius.user_lookups AS Consultas,
    ius.user_updates AS Actualizaciones
FROM sys.dm_db_index_usage_stats AS ius
JOIN sys.indexes AS i ON i.object_id = ius.object_id AND i.index_id = ius.index_id
WHERE ius.database_id = DB_ID()
ORDER BY Tabla, Indice;
GO

--- RESUMEN DE INDICES CREADOS
SELECT 
    SCHEMA_NAME(t.schema_id) AS Esquema,
    OBJECT_NAME(i.object_id) AS Tabla,
    i.name AS Indice,
    i.type_desc AS Tipo
FROM sys.indexes AS i
JOIN sys.tables AS t ON i.object_id = t.object_id
WHERE t.schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
ORDER BY Esquema, Tabla, Tipo, Indice;











/*
CONFIGURACION OPTIMA: 10 indices 
(eliminarermos 3 indices redundantes)
Evitar exceso: No se indexaron campos de baja selectividad"
*/

--- Eliminar indices innecesarios
DROP INDEX IDX_Pacientes_TipoSangre ON Pacientes.Pacientes;
DROP INDEX IDX_Consultas_Paciente_Fecha ON Secretaria.Consultas;
DROP INDEX IDX_TratamientoXConsulta_Consulta ON Secretaria.TratamientoXConsulta;


