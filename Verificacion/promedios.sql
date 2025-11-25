USE PHospital
GO

--- Promedio de tratamientos por consulta finalizada

SELECT 
    COUNT(DISTINCT tc.idConsulta) AS ConsultasFinalizadas,
    COUNT(tc.id) AS TotalTratamientosAplicados,
    CAST(COUNT(tc.id) AS DECIMAL(10,2)) / COUNT(DISTINCT tc.idConsulta) AS PromedioTratamientosPorConsulta
FROM Secretaria.TratamientoXConsulta tc
INNER JOIN Secretaria.Consultas c ON tc.idConsulta = c.id
WHERE c.Estado = 'Finalizado'

--- Detalle: Distribucion de cantidad de tratamientos por consulta
SELECT 
    CantidadTratamientos,
    COUNT(*) AS ConsultasConEstaCantidad,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Porcentaje
FROM (
    SELECT 
        c.id AS idConsulta,
        COUNT(tc.id) AS CantidadTratamientos
    FROM Secretaria.Consultas c
    INNER JOIN Secretaria.TratamientoXConsulta tc ON c.id = tc.idConsulta
    WHERE c.Estado = 'Finalizado'
    GROUP BY c.id
) AS Conteo
GROUP BY CantidadTratamientos
ORDER BY CantidadTratamientos

--- Ver ejemplos de consultas con diferentes cantidades de tratamientos
SELECT TOP 5
    c.id AS idConsulta,
    p.Nobres + ' ' + p.Apellidos AS Paciente,
    m.Nombres + ' ' + m.Apellidos AS Medico,
    COUNT(tc.id) AS CantidadTratamientos,
    SUM(t.Precio * tc.Cantidad) AS CostoTotal
FROM Secretaria.Consultas c
INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
INNER JOIN Personal.Medicos m ON c.idMedico = m.id
INNER JOIN Secretaria.TratamientoXConsulta tc ON c.id = tc.idConsulta
INNER JOIN Tesoreria.Tratamientos t ON tc.idTratamiento = t.id
WHERE c.Estado = 'Finalizado'
GROUP BY c.id, p.Nobres, p.Apellidos, m.Nombres, m.Apellidos
ORDER BY COUNT(tc.id) DESC