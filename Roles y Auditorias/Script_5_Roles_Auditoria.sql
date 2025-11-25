--- FASE 5: SEGURIDAD Y AUDITORIA
--- Proyecto: PHospital - Sistema de Gestion Hospitalaria
--- Incluye: 7 Roles, 7 Usuarios, Auditoria Servidor y BD

USE PHospital
GO


--- SECCION 1: ROLES PERSONALIZADOS Y PERMISOS (7 ROLES)



--- ROL 1: ADMINISTRADOR (Control total)
CREATE ROLE rol_administrador;
GRANT CONTROL ON SCHEMA::Pacientes TO rol_administrador;
GRANT CONTROL ON SCHEMA::Personal TO rol_administrador;
GRANT CONTROL ON SCHEMA::Tesoreria TO rol_administrador;
GRANT CONTROL ON SCHEMA::Secretaria TO rol_administrador;
GRANT BACKUP DATABASE TO rol_administrador;
GRANT BACKUP LOG TO rol_administrador;
GO

--- ROL 2: ALUMNO (Acceso limitado estudiante)
CREATE ROLE rol_alumno;
--- Dar CONTROL total a alumnos (somos los desarrolladores)
GRANT CONTROL ON SCHEMA::Pacientes TO rol_alumno;
GRANT CONTROL ON SCHEMA::Personal TO rol_alumno;
GRANT CONTROL ON SCHEMA::Tesoreria TO rol_alumno;
GRANT CONTROL ON SCHEMA::Secretaria TO rol_alumno;
GRANT BACKUP DATABASE TO rol_alumno;
GRANT BACKUP LOG TO rol_alumno;
GO

--- ROL 3: ANALISTA (Para Power BI y Reportes)
CREATE ROLE rol_analista;
GRANT SELECT ON OBJECT::Secretaria.Vista_PowerBI TO rol_analista;
GO



--- ROL 4: INVITADO (Solo vistas)
CREATE ROLE rol_invitado;
GRANT SELECT ON OBJECT::Secretaria.Vista_Consultas_Detalladas TO rol_invitado;
GRANT SELECT ON OBJECT::Pacientes.Vista_Pacientes_Completa TO rol_invitado;
GRANT SELECT ON OBJECT::Personal.Vista_Medicos_Productividad TO rol_invitado;
GRANT SELECT ON OBJECT::Tesoreria.Vista_Facturacion_Mensual TO rol_invitado;
GRANT SELECT ON OBJECT::Tesoreria.Vista_Tratamientos_Mas_Usados TO rol_invitado;
GRANT SELECT ON OBJECT::Secretaria.Costo_de_Consulta_por_Medico TO rol_invitado;
GO

--- ROL 5: PROFESOR (Acceso evaluacion del proyecto)
CREATE ROLE rol_profesor;
GRANT SELECT ON SCHEMA::Pacientes TO rol_profesor;
GRANT SELECT ON SCHEMA::Personal TO rol_profesor;
GRANT SELECT ON SCHEMA::Tesoreria TO rol_profesor;
GRANT SELECT ON SCHEMA::Secretaria TO rol_profesor;
GRANT VIEW DEFINITION ON SCHEMA::Pacientes TO rol_profesor;
GRANT VIEW DEFINITION ON SCHEMA::Personal TO rol_profesor;
GRANT VIEW DEFINITION ON SCHEMA::Tesoreria TO rol_profesor;
GRANT VIEW DEFINITION ON SCHEMA::Secretaria TO rol_profesor;
GO



--- SECCION 2: LOGINS Y USUARIOS (5 USUARIOS)

--- USUARIO 1: ADMINISTRADOR
CREATE LOGIN Login_Administrador WITH PASSWORD = 'Admin2025!', CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER DBAdmin FOR LOGIN Login_Administrador;
ALTER ROLE rol_administrador ADD MEMBER DBAdmin;
GO

--- USUARIO 2: ALUMNO
CREATE LOGIN Login_Alumno WITH PASSWORD = 'Alumno2025!', CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER Alumno FOR LOGIN Login_Alumno;
ALTER ROLE rol_alumno ADD MEMBER Alumno;
GO

--- USUARIO 3: ANALISTA
CREATE LOGIN Login_Analista WITH PASSWORD = 'Analista2025!', CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER Analista FOR LOGIN Login_Analista;
ALTER ROLE rol_analista ADD MEMBER Analista;
GO


--- USUARIO 4: INVITADO
CREATE LOGIN Login_Invitado WITH PASSWORD = 'Invitado2025!', CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER Invitado FOR LOGIN Login_Invitado;
ALTER ROLE rol_invitado ADD MEMBER Invitado;
GO

--- USUARIO 5: PROFESOR
CREATE LOGIN Login_Profesor WITH PASSWORD = 'Profesor2025!', CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER Profesor FOR LOGIN Login_Profesor;
ALTER ROLE rol_profesor ADD MEMBER Profesor;
GO



--- SECCION 3: AUDITORIA DE SERVIDOR


--- NOTA: Copiar ruta de carpeta C:\ADMIN BDA\Phospital\AUDITORIAS
USE master
GO
--- Crear auditoria de servidor
CREATE SERVER AUDIT Auditoria_PHospital_Servidor
TO FILE 
(
    FILEPATH = 'C:\ADMIN BDA\Phospital\AUDITORIAS',
    MAXSIZE = 100 MB,
    MAX_ROLLOVER_FILES = 10,
    RESERVE_DISK_SPACE = OFF
)
WITH 
(
    QUEUE_DELAY = 1000,
    ON_FAILURE = CONTINUE
);
GO
--- Crear especificacion de auditoria de servidor
CREATE SERVER AUDIT SPECIFICATION Spec_Auditoria_Servidor_PHospital
FOR SERVER AUDIT Auditoria_PHospital_Servidor
ADD (FAILED_LOGIN_GROUP),
ADD (SUCCESSFUL_LOGIN_GROUP),
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
ADD (DATABASE_PERMISSION_CHANGE_GROUP);
GO
--- Habilitar auditoria y especificacion de servidor
ALTER SERVER AUDIT Auditoria_PHospital_Servidor WITH (STATE = ON);
ALTER SERVER AUDIT SPECIFICATION Spec_Auditoria_Servidor_PHospital WITH (STATE = ON);
GO




--- SECCION 4: AUDITORIA DE BASE DE DATOS PHOSPITAL
USE PHospital
GO
--- Crear especificacion de auditoria de base de datos
CREATE DATABASE AUDIT SPECIFICATION Spec_Auditoria_BD_PHospital
FOR SERVER AUDIT Auditoria_PHospital_Servidor
ADD (SELECT, INSERT, UPDATE, DELETE ON OBJECT::Pacientes.Pacientes BY public),
ADD (SELECT, INSERT, UPDATE ON OBJECT::Tesoreria.Factura BY public),
ADD (SELECT, INSERT, UPDATE, DELETE ON OBJECT::Secretaria.Consultas BY public),
ADD (EXECUTE ON OBJECT::Tesoreria.CrearFactura BY public),
ADD (EXECUTE ON OBJECT::Secretaria.CrearConsulta BY public);
GO
--- Habilitar especificacion de auditoria de BD
ALTER DATABASE AUDIT SPECIFICATION Spec_Auditoria_BD_PHospital WITH (STATE = ON);
GO



--- SECCION 5: VERIFICACIONES

--- Analista
SELECT 
    dp.name AS Rol,
    p.permission_name AS Permiso,
    OBJECT_SCHEMA_NAME(p.major_id) + '.' + OBJECT_NAME(p.major_id) AS Objeto
FROM sys.database_permissions p
INNER JOIN sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
WHERE dp.name = 'rol_analista';
GO

--- Verificar roles creados
SELECT name AS Rol, create_date AS FechaCreacion
FROM sys.database_principals
WHERE type = 'R' AND name LIKE 'rol_%'
ORDER BY name;
GO

--- Verificar usuarios y sus roles
SELECT 
    dp.name AS Usuario,
    r.name AS Rol,
    dp.create_date AS FechaCreacion
FROM sys.database_principals dp
LEFT JOIN sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
LEFT JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
WHERE dp.type = 'S' AND dp.name NOT IN ('dbo', 'guest', 'INFORMATION_SCHEMA', 'sys')
ORDER BY dp.name;
GO

--- Verificar permisos de cada rol
SELECT 
    dp.name AS Rol,
    p.permission_name AS Permiso,
    SCHEMA_NAME(o.schema_id) + '.' + o.name AS Objeto
FROM sys.database_permissions p
INNER JOIN sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
LEFT JOIN sys.objects o ON p.major_id = o.object_id
WHERE dp.type = 'R' AND dp.name LIKE 'rol_%'
ORDER BY dp.name, p.permission_name;
GO

--- Verificar auditorias de servidor
SELECT 
    name AS Auditoria,
    type_desc AS Tipo,
    is_state_enabled AS Habilitada
FROM sys.server_audits;
GO

--- Verificar especificaciones de auditoria de servidor
SELECT 
    name AS Especificacion,
    is_state_enabled AS Habilitada
FROM sys.server_audit_specifications;
GO

--- Verificar especificaciones de auditoria de BD
SELECT 
    name AS Especificacion,
    is_state_enabled AS Habilitada
FROM sys.database_audit_specifications;
GO

--- Consultar registros de auditoria
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

--- Resumen final
SELECT 'Roles creados' AS Concepto, COUNT(*) AS Total
FROM sys.database_principals
WHERE type = 'R' AND name LIKE 'rol_%'
UNION ALL
SELECT 'Usuarios creados', COUNT(*)
FROM sys.database_principals
WHERE type = 'S' AND name IN ('Analista', 'DBAdmin', 'Invitado', 'Profesor', 'Alumno')
UNION ALL
SELECT 'Auditorias servidor', COUNT(*)
FROM sys.server_audits
UNION ALL
SELECT 'Especificaciones servidor', COUNT(*)
FROM sys.server_audit_specifications
UNION ALL
SELECT 'Especificaciones BD', COUNT(*)
FROM sys.database_audit_specifications;
GO
