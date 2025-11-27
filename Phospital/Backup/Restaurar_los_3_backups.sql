USE master
GO

--- Cerrar conexiones y eliminar BD si existe
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'PHospital')
BEGIN
    ALTER DATABASE PHospital SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE PHospital
END
GO

--- OPCION 1: Restaurar solo FULL
RESTORE DATABASE PHospital 
FROM DISK = 'C:\ADMIN BDA\Phospital\BACKUP\FULL\PHospital_FULL.bak'
WITH RECOVERY;
GO

/* 
--- OPCION 2: Restaurar FULL + DIFERENCIAL
RESTORE DATABASE PHospital 
FROM DISK = 'C:\ADMIN BDA\Phospital\BACKUP\FULL\PHospital_FULL.bak'
WITH NORECOVERY;

RESTORE DATABASE PHospital 
FROM DISK = 'C:\ADMIN BDA\Phospital\BACKUP\DIFERENCIAL\PHospital_DIFF.bak'
WITH RECOVERY;
GO
*/





/*
--- OPCION 3: Restaurar FULL + DIFERENCIAL + LOG
RESTORE DATABASE PHospital 
FROM DISK = 'C:\ADMIN BDA\Phospital\BACKUP\FULL\PHospital_FULL.bak'
WITH NORECOVERY;

RESTORE DATABASE PHospital 
FROM DISK = 'C:\ADMIN BDA\Phospital\BACKUP\DIFERENCIAL\PHospital_DIFF.bak'
WITH NORECOVERY;

RESTORE LOG PHospital 
FROM DISK = 'C:\ADMIN BDA\Phospital\BACKUP\LOG\PHospital_LOG.trn'
WITH RECOVERY;
GO
*/



--- Verificar restauracion
USE PHospital
GO

SELECT 'Pacientes' AS Tabla, COUNT(*) AS Registros FROM Pacientes.Pacientes
UNION ALL SELECT 'Medicos', COUNT(*) FROM Personal.Medicos
UNION ALL SELECT 'Consultas', COUNT(*) FROM Secretaria.Consultas
UNION ALL SELECT 'Facturas', COUNT(*) FROM Tesoreria.Factura;
GO