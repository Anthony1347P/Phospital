--- VERIFICACION COMPLETA DE AUDITORIAS

--- 1. Auditorias de servidor
SELECT 
    name AS Auditoria,
    type_desc AS Tipo,
    is_state_enabled AS Habilitada,
    queue_delay AS RetardoCola,
    on_failure_desc AS AccionError
FROM sys.server_audits
WHERE name LIKE '%PHospital%';
GO

--- 2. Especificaciones de auditoria de servidor
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

--- 3. Especificaciones de auditoria de BD
SELECT 
    das.name AS Especificacion,
    sa.name AS Auditoria,
    das.is_state_enabled AS Habilitada,
    dad.audit_action_name AS Accion,
    OBJECT_SCHEMA_NAME(dad.major_id) + '.' + OBJECT_NAME(dad.major_id) AS Objeto,
    dad.class_desc AS Clase
FROM sys.database_audit_specifications das
INNER JOIN sys.server_audits sa ON das.audit_guid = sa.audit_guid
INNER JOIN sys.database_audit_specification_details dad ON das.database_specification_id = dad.database_specification_id
WHERE sa.name LIKE '%PHospital%'
ORDER BY Objeto, Accion;
GO

--- 4. Ver ultimos 50 registros de auditoria
SELECT TOP 50
    event_time AS Fecha,
    action_id AS AccionID,
    succeeded AS Exitoso,
    session_server_principal_name AS Usuario,
    database_name AS BD,
    schema_name AS Esquema,
    object_name AS Objeto,
    statement AS Consulta
FROM sys.fn_get_audit_file('C:\ADMIN BDA\Phospital\AUDITORIAS\*.sqlaudit', DEFAULT, DEFAULT)
ORDER BY event_time DESC;
GO

--- 5. Resumen de configuracion
SELECT 'Auditorias Servidor' AS Tipo, 
       COUNT(*) AS Total, 
       SUM(CASE WHEN is_state_enabled = 1 THEN 1 ELSE 0 END) AS Habilitadas
FROM sys.server_audits
WHERE name LIKE '%PHospital%'
UNION ALL
SELECT 'Especificaciones Servidor', 
       COUNT(*),
       SUM(CASE WHEN sas.is_state_enabled = 1 THEN 1 ELSE 0 END)
FROM sys.server_audit_specifications sas
INNER JOIN sys.server_audits sa ON sas.audit_guid = sa.audit_guid
WHERE sa.name LIKE '%PHospital%'
UNION ALL
SELECT 'Especificaciones BD', 
       COUNT(*),
       SUM(CASE WHEN das.is_state_enabled = 1 THEN 1 ELSE 0 END)
FROM sys.database_audit_specifications das
INNER JOIN sys.server_audits sa ON das.audit_guid = sa.audit_guid
WHERE sa.name LIKE '%PHospital%';
GO