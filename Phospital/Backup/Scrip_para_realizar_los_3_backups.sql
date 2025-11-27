USE master
GO

--- Primero asegurar que la BD este en modo FULL para poder hacer backup de LOG
ALTER DATABASE PHospital SET RECOVERY FULL;
GO

--- BACKUP FULL
BACKUP DATABASE PHospital
TO DISK = 'C:\ADMIN BDA\Phospital\BACKUP\FULL\PHospital_FULL.bak'
WITH FORMAT, INIT, COMPRESSION;
GO

--- BACKUP DIFERENCIAL
BACKUP DATABASE PHospital
TO DISK = 'C:\ADMIN BDA\Phospital\BACKUP\DIFERENCIAL\PHospital_DIFF.bak'
WITH DIFFERENTIAL, INIT, COMPRESSION;
GO

--- BACKUP LOG
BACKUP LOG PHospital
TO DISK = 'C:\ADMIN BDA\Phospital\BACKUP\LOG\PHospital_LOG.trn'
WITH INIT, COMPRESSION;
GO

--- Verificar backups realizados
SELECT 
    database_name AS BD,
    backup_start_date AS Fecha,
    CASE type 
        WHEN 'D' THEN 'FULL' 
        WHEN 'I' THEN 'DIFERENCIAL' 
        WHEN 'L' THEN 'LOG' 
    END AS Tipo,
    CAST(backup_size/1024.0/1024.0 AS DECIMAL(10,2)) AS TamanoMB
FROM msdb.dbo.backupset
WHERE database_name = 'PHospital'
ORDER BY backup_start_date DESC;
GO