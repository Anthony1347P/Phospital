USE PHospital;
GO

--- 1 Crear vista de Ranking Aseguradoras
CREATE FUNCTION Secretaria.FN_RankingAseguradoras()
RETURNS TABLE
AS
RETURN
(
    WITH FrecuenciaAseguradoras AS (
        SELECT
            a.Aseguradora,
            COUNT(F.id) AS TotalFacturas
        FROM Pacientes.Aseguradora AS a
        INNER JOIN Pacientes.Pacientes AS p ON a.idSeguro = p.idSeguro
        INNER JOIN Tesoreria.Factura AS f ON p.id = f.idPaciente
        GROUP BY a.Aseguradora
    )

    SELECT
        Aseguradora,
        TotalFacturas,
        RANK() OVER (ORDER BY TotalFacturas DESC) AS Ranking
    FROM FrecuenciaAseguradoras
);

GO

--- 2 Crear vista de Costo de Consulta por_Medico
CREATE VIEW Secretaria.Vista_Costo_de_Consulta_por_Medico AS
SELECT
    c.id AS idConsulta,
    m.Nombres + ' ' + m.Apellidos AS Medico,
    p.Nobres + ' ' + p.Apellidos AS Paciente,
    SUM(t.Precio * txc.Cantidad) AS CostoConsultaIndividual,
    AVG(SUM(t.Precio * txc.Cantidad)) OVER (PARTITION BY c.idMedico) AS PromedioGastoMedico
FROM Secretaria.Consultas c
INNER JOIN Secretaria.TratamientoXConsulta txc ON c.id = txc.idConsulta
INNER JOIN Tesoreria.Tratamientos t ON txc.idTratamiento = t.id
INNER JOIN Personal.Medicos m ON c.idMedico = m.id
INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
GROUP BY c.id, c.idMedico, m.Nombres, m.Apellidos, p.Nobres, p.Apellidos
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

--- 6. Verificar todas las vistas con y sin Funciones Ventana
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


--- 7. Verificar todas las funciones con y sin Funciones Ventana
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


