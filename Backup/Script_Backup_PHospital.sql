--- BACKUP COMPLETO DE PHOSPITAL 
--- Proyecto: PHospital - Sistema de Gestion Hospitalaria
USE master
GO

--- Crear carpeta de backup si no existe (requiere permisos)
DECLARE @Carpeta VARCHAR(500) = 'C:\ADMIN BDA\Phospital\BACKUP'
DECLARE @SQL VARCHAR(1000)

--- Backup FULL de la base de datos
DECLARE @FechaHora VARCHAR(50) = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 120), '-', ''), ':', ''), ' ', '_')
DECLARE @NombreArchivo VARCHAR(500) = @Carpeta + '\PHospital_FULL_' + @FechaHora + '.bak'

PRINT 'Iniciando BACKUP FULL...'
PRINT 'Archivo: ' + @NombreArchivo
PRINT ''

BACKUP DATABASE PHospital
TO DISK = @NombreArchivo
WITH 
    FORMAT,
    NAME = 'PHospital Full Backup - Fase 6',
    DESCRIPTION = 'Backup completo de PHospital roles y auditorias completados',
    COMPRESSION,
    STATS = 10
GO