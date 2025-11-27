USE PHospital;
GO

--- REBUILD para índices con fragmentacion > 30%
ALTER INDEX IDX_Pacientes_TipoSangre ON Pacientes.Pacientes REBUILD;
ALTER INDEX IDX_Pacientes_DUI ON Pacientes.Pacientes REBUILD;
GO

--- REORGANIZE para indices con fragmentacion entre 10-30%
ALTER INDEX IDX_Pacientes_Apellidos ON Pacientes.Pacientes REORGANIZE;
GO

--- Verificar fragmentacion despues del mantenimiento
SELECT 
    OBJECT_NAME(ips.object_id) AS Tabla,
    i.name AS Indice,
    ips.avg_fragmentation_in_percent AS Fragmentacion
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.database_id = DB_ID() AND i.name LIKE 'IDX_Pacientes%'
ORDER BY Fragmentacion DESC;