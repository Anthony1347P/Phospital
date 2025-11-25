USE PHospital
GO

--- Dar permiso BACKUP DATABASE al rol_alumno
GRANT BACKUP DATABASE TO rol_alumno;
GO

--- Dar permiso BACKUP LOG al rol_alumno (opcional pero recomendado)
GRANT BACKUP LOG TO rol_alumno;
GO

--- Verificar permisos del rol
SELECT 
    dp.name AS Rol,
    p.permission_name AS Permiso,
    p.state_desc AS Estado
FROM sys.database_permissions p
INNER JOIN sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
WHERE dp.name = 'rol_alumno'
ORDER BY p.permission_name;
GO