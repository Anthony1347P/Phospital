USE PHospital;
GO


--- 3. Crear vista de Seguimiento Medico (LAG)
CREATE VIEW Secretaria.Vista_Seguimiento_Medico AS
SELECT
    p.Nobres + ' ' + p.Apellidos AS Paciente,
    c.Fecha AS FechaActual,
    c.Motivo,
    LAG(c.Fecha, 1) OVER (PARTITION BY c.idPaciente ORDER BY c.Fecha) AS FechaAnterior,
    DATEDIFF(DAY, LAG(c.Fecha, 1) OVER (PARTITION BY c.idPaciente ORDER BY c.Fecha), c.Fecha) AS DiasEntreSeguimiento,
    CASE
        WHEN DATEDIFF(DAY, LAG(c.Fecha, 1) OVER (PARTITION BY c.idPaciente ORDER BY c.Fecha), c.Fecha) > 180 THEN 'Seguimiento Tardio'
        WHEN DATEDIFF(DAY, LAG(c.Fecha, 1) OVER (PARTITION BY c.idPaciente ORDER BY c.Fecha), c.Fecha) > 90 THEN 'Seguimiento Regular'
        WHEN DATEDIFF(DAY, LAG(c.Fecha, 1) OVER (PARTITION BY c.idPaciente ORDER BY c.Fecha), c.Fecha) <= 90 THEN 'Seguimiento Frecuente'
        ELSE 'Primera Consulta'
    END AS TipoSeguimiento
FROM Secretaria.Consultas c
INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id;
GO

--- 4. Crear vista Historial de Paciente (ROW_NUMBER) - CORREGIDA
CREATE VIEW Secretaria.Vista_Historial_Paciente AS
SELECT
    ROW_NUMBER() OVER (PARTITION BY c.idPaciente ORDER BY c.Fecha) AS NumeroConsulta,
    p.Nobres + ' ' + p.Apellidos AS Paciente,
    p.DUI,
    m.Nombres + ' ' + m.Apellidos AS Medico,
    e.Especialidad,
    c.Fecha,
    c.Motivo,
    c.Estado
FROM Secretaria.Consultas c
INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
INNER JOIN Personal.Medicos m ON c.idMedico = m.id
INNER JOIN Personal.Especializacion e ON m.idEspecialidad = e.id;
GO

--- 6. Verificar todas las vistas con funciones ventana creadas
SELECT 
    SCHEMA_NAME(v.schema_id) AS Esquema,
    v.name AS NombreVista,
    v.create_date AS FechaCreacion,
    CASE 
        WHEN OBJECT_DEFINITION(v.object_id) LIKE '%OVER%' THEN 'Sí'
        ELSE 'No'
    END AS UsaFuncionesVentana
FROM sys.views v
WHERE SCHEMA_NAME(v.schema_id) IN ('Secretaria', 'dbo')
ORDER BY SCHEMA_NAME(v.schema_id), v.name;

--- 7. Verificar sin funciones ventana
SELECT 
    SCHEMA_NAME(o.schema_id) AS Esquema,
    o.name AS NombreFuncion,
    o.create_date AS FechaCreacion,
    CASE 
        WHEN OBJECT_DEFINITION(o.object_id) LIKE '%OVER%' THEN 'Sí'
        ELSE 'No'
    END AS UsaFuncionesVentana
FROM sys.objects o
WHERE o.type IN ('FN', 'IF', 'TF')
AND SCHEMA_NAME(o.schema_id) IN ('Secretaria', 'dbo', 'Tesoreria')
ORDER BY SCHEMA_NAME(o.schema_id), o.name;