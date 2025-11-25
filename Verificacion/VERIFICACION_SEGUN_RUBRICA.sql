USE PHospital
GO

--- VERIFICACION COMPLETA PROYECTO PHOSPITAL
--- Fecha: 24 de Noviembre 2025


--- 1. Funciones Ventana
SELECT 
    SCHEMA_NAME(v.schema_id) AS Esquema,
    v.name AS Objeto,
    'Vista' AS Tipo,
    v.create_date AS FechaCreacion,
    CASE 
        WHEN OBJECT_DEFINITION(v.object_id) LIKE '%ROW_NUMBER%' THEN 'ROW_NUMBER'
        WHEN OBJECT_DEFINITION(v.object_id) LIKE '%RANK()%' THEN 'RANK'
        WHEN OBJECT_DEFINITION(v.object_id) LIKE '%LAG%' THEN 'LAG'
        WHEN OBJECT_DEFINITION(v.object_id) LIKE '%AVG%' AND OBJECT_DEFINITION(v.object_id) LIKE '%OVER%' THEN 'AVG(OVER)'
    END AS FuncionVentana
FROM sys.views v
WHERE OBJECT_DEFINITION(v.object_id) LIKE '%OVER%'
AND SCHEMA_NAME(v.schema_id) NOT IN ('sys', 'INFORMATION_SCHEMA')
UNION ALL
SELECT 
    SCHEMA_NAME(o.schema_id),
    o.name,
    'Funcion',
    o.create_date,
    CASE WHEN OBJECT_DEFINITION(o.object_id) LIKE '%RANK()%' THEN 'RANK' END
FROM sys.objects o
WHERE o.type IN ('FN', 'IF', 'TF')
AND OBJECT_DEFINITION(o.object_id) LIKE '%OVER%'
AND SCHEMA_NAME(o.schema_id) NOT IN ('sys', 'INFORMATION_SCHEMA')
ORDER BY Esquema, Tipo, Objeto;
GO

--- Contar total de funciones ventana
SELECT 
    COUNT(*) AS TotalFuncionesVentana
FROM (
    SELECT v.object_id FROM sys.views v 
    WHERE OBJECT_DEFINITION(v.object_id) LIKE '%OVER%'
    AND SCHEMA_NAME(v.schema_id) NOT IN ('sys', 'INFORMATION_SCHEMA')
    UNION
    SELECT o.object_id FROM sys.objects o 
    WHERE o.type IN ('FN', 'IF', 'TF')
    AND OBJECT_DEFINITION(o.object_id) LIKE '%OVER%'
    AND SCHEMA_NAME(o.schema_id) NOT IN ('sys', 'INFORMATION_SCHEMA')
) AS Total;
GO


--- 2. Facturas generadas
SELECT 
    COUNT(*) AS TotalFacturas,
    SUM(CASE WHEN Estado = 'Pagada' THEN 1 ELSE 0 END) AS Pagadas,
    SUM(CASE WHEN Estado = 'Pendiente' THEN 1 ELSE 0 END) AS Pendientes,
    SUM(Total) AS MontoTotal,
    COUNT(DISTINCT idPaciente) AS PacientesFacturados
FROM Tesoreria.Factura;
GO

--- Detalle de facturas
SELECT COUNT(*) AS TotalDetallesFactura
FROM Tesoreria.FacturaDetalle;
GO

--- Ultimas 5 facturas
SELECT TOP 5
    f.id,
    f.Fecha,
    p.Nobres + ' ' + p.Apellidos AS Paciente,
    f.Total,
    f.Estado
FROM Tesoreria.Factura f
INNER JOIN Pacientes.Pacientes p ON f.idPaciente = p.id
ORDER BY f.Fecha DESC;
GO


--- 3. Roles creados
SELECT 
    name AS Rol,
    create_date AS FechaCreacion
FROM sys.database_principals
WHERE type = 'R' AND name LIKE 'rol_%'
ORDER BY name;
GO

--- Usuarios creados
SELECT 
    name AS Usuario,
    create_date AS FechaCreacion,
    type_desc AS Tipo
FROM sys.database_principals
WHERE type = 'S' 
AND name IN ('Analista', 'DBAdmin', 'Invitado', 'Profesor', 'Alumno')
ORDER BY name;
GO

--- Permisos por rol
SELECT 
    dp.name AS Rol,
    p.permission_name AS Permiso,
    CASE 
        WHEN p.class = 0 THEN 'BD'
        WHEN p.class = 1 THEN OBJECT_SCHEMA_NAME(p.major_id) + '.' + OBJECT_NAME(p.major_id)
        WHEN p.class = 3 THEN SCHEMA_NAME(p.major_id)
        ELSE 'Otro'
    END AS Objeto
FROM sys.database_permissions p
INNER JOIN sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
WHERE dp.type = 'R' AND dp.name LIKE 'rol_%'
ORDER BY dp.name, p.permission_name;
GO


--- 4. Auditorias de servidor
SELECT 
    name AS Auditoria,
    type_desc AS Tipo,
    is_state_enabled AS Habilitada
FROM sys.server_audits
WHERE name LIKE '%PHospital%';
GO

--- Especificaciones de auditoria de servidor
SELECT 
    sas.name AS Especificacion,
    sa.name AS Auditoria,
    sas.is_state_enabled AS Habilitada,
    sad.audit_action_name AS AccionAuditada
FROM sys.server_audit_specifications sas
INNER JOIN sys.server_audits sa ON sas.audit_guid = sa.audit_guid
INNER JOIN sys.server_audit_specification_details sad ON sas.server_specification_id = sad.server_specification_id
WHERE sa.name LIKE '%PHospital%'
ORDER BY sad.audit_action_name;
GO

--- Especificaciones de auditoria de BD
SELECT 
    das.name AS Especificacion,
    sa.name AS Auditoria,
    das.is_state_enabled AS Habilitada,
    dad.audit_action_name AS Accion,
    OBJECT_SCHEMA_NAME(dad.major_id) + '.' + OBJECT_NAME(dad.major_id) AS Objeto
FROM sys.database_audit_specifications das
INNER JOIN sys.server_audits sa ON das.audit_guid = sa.audit_guid
INNER JOIN sys.database_audit_specification_details dad ON das.database_specification_id = dad.database_specification_id
WHERE sa.name LIKE '%PHospital%'
ORDER BY Objeto, Accion;
GO

--- Ultimos 50 registros de auditoria
SELECT TOP 50
    event_time AS Fecha,
    succeeded AS Exitoso,
    session_server_principal_name AS Usuario,
    database_name AS BD,
    schema_name AS Esquema,
    object_name AS Objeto,
    statement AS Consulta
FROM sys.fn_get_audit_file('C:\ADMIN BDA\Phospital\AUDITORIAS\*.sqlaudit', DEFAULT, DEFAULT)
ORDER BY event_time DESC;
GO


--- 5. Backups realizados
SELECT TOP 10
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

/*     DIEGOOOO! 
--- Resumen de backups
SELECT 
    COUNT(*) AS TotalBackups,
    SUM(CASE WHEN type = 'D' THEN 1 ELSE 0 END) AS FULL,
    SUM(CASE WHEN type = 'I' THEN 1 ELSE 0 END) AS DIFERENCIAL,
    SUM(CASE WHEN type = 'L' THEN 1 ELSE 0 END) AS LOG
FROM msdb.dbo.backupset
WHERE database_name = 'PHospital';
GO
*/

--- 6. Objetos de base de datos
SELECT 'Tablas' AS Tipo, COUNT(*) AS Cantidad
FROM sys.tables
WHERE schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
UNION ALL
SELECT 'Vistas', COUNT(*)
FROM sys.views
WHERE schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'), SCHEMA_ID('dbo'))
UNION ALL
SELECT 'Funciones', COUNT(*)
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF')
AND schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'), SCHEMA_ID('dbo'))
UNION ALL
SELECT 'Procedimientos', COUNT(*)
FROM sys.procedures
WHERE schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
UNION ALL
SELECT 'Triggers', COUNT(*)
FROM sys.triggers
WHERE parent_class = 1;
GO


--- 7. Datos en tablas principales
SELECT 'Medicos' AS Tabla, COUNT(*) AS Registros FROM Personal.Medicos
UNION ALL SELECT 'Pacientes', COUNT(*) FROM Pacientes.Pacientes
UNION ALL SELECT 'Consultas', COUNT(*) FROM Secretaria.Consultas
UNION ALL SELECT 'Tratamientos', COUNT(*) FROM Secretaria.TratamientoXConsulta
UNION ALL SELECT 'Facturas', COUNT(*) FROM Tesoreria.Factura
UNION ALL SELECT 'Detalles Factura', COUNT(*) FROM Tesoreria.FacturaDetalle;
GO


--- 8. Indices creados
SELECT 
    SCHEMA_NAME(t.schema_id) AS Esquema,
    t.name AS Tabla,
    i.name AS Indice,
    i.type_desc AS Tipo,
    i.is_unique AS Unico
FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
WHERE t.schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
AND i.name IS NOT NULL
ORDER BY Esquema, Tabla;
GO

--- Total de indices
SELECT COUNT(*) AS TotalIndices
FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
WHERE t.schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
AND i.name IS NOT NULL;
GO





