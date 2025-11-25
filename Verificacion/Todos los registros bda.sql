USE PHospital
GO

--- VER TODOS LOS REGISTROS DE LA BASE DE DATOS PHOSPITAL

PRINT '========================================='
PRINT '     TABLAS MAESTRAS'
PRINT '========================================='

PRINT ''
PRINT '--- TIPOS DE SANGRE (8 registros esperados)'
SELECT * FROM Pacientes.TipoDeSangre ORDER BY idTipoDeSangre

PRINT ''
PRINT '--- ASEGURADORAS (6 registros esperados)'
SELECT * FROM Pacientes.Aseguradora ORDER BY idSeguro

PRINT ''
PRINT '--- ESPECIALIZACIONES (9 registros esperados)'
SELECT * FROM Personal.Especializacion ORDER BY id

PRINT ''
PRINT '--- TRATAMIENTOS (8 registros esperados)'
SELECT * FROM Tesoreria.Tratamientos ORDER BY id

PRINT ''
PRINT '========================================='
PRINT '     DATOS OPERACIONALES'
PRINT '========================================='

PRINT ''
PRINT '--- PACIENTES (1000 esperados)'
SELECT COUNT(*) AS TotalPacientes FROM Pacientes.Pacientes
SELECT TOP 20 * FROM Pacientes.Pacientes ORDER BY id

PRINT ''
PRINT '--- MEDICOS (70 esperados)'
SELECT COUNT(*) AS TotalMedicos FROM Personal.Medicos
SELECT TOP 20 * FROM Personal.Medicos ORDER BY id

PRINT ''
PRINT '--- CONSULTAS (8004 esperados)'
SELECT COUNT(*) AS TotalConsultas FROM Secretaria.Consultas
SELECT Estado, COUNT(*) AS Cantidad FROM Secretaria.Consultas GROUP BY Estado
SELECT TOP 20 * FROM Secretaria.Consultas ORDER BY id DESC

PRINT ''
PRINT '--- TRATAMIENTOS X CONSULTA (9855 esperados)'
SELECT COUNT(*) AS TotalTratamientos FROM Secretaria.TratamientoXConsulta
SELECT TOP 20 * FROM Secretaria.TratamientoXConsulta ORDER BY id DESC

PRINT ''
PRINT '--- FACTURAS'
SELECT COUNT(*) AS TotalFacturas FROM Tesoreria.Factura
SELECT Estado, COUNT(*) AS Cantidad FROM Tesoreria.Factura GROUP BY Estado
SELECT TOP 20 * FROM Tesoreria.Factura ORDER BY id DESC

PRINT ''
PRINT '--- DETALLE FACTURAS'
SELECT COUNT(*) AS TotalDetalles FROM Tesoreria.FacturaDetalle
SELECT TOP 20 * FROM Tesoreria.FacturaDetalle ORDER BY id DESC

PRINT ''
PRINT '========================================='
PRINT '     RESUMEN GENERAL'
PRINT '========================================='

SELECT 
    'TipoDeSangre' AS Tabla,
    COUNT(*) AS Registros,
    'Pacientes' AS Esquema
FROM Pacientes.TipoDeSangre
UNION ALL
SELECT 'Aseguradora', COUNT(*), 'Pacientes' FROM Pacientes.Aseguradora
UNION ALL
SELECT 'Pacientes', COUNT(*), 'Pacientes' FROM Pacientes.Pacientes
UNION ALL
SELECT 'Especializacion', COUNT(*), 'Personal' FROM Personal.Especializacion
UNION ALL
SELECT 'Medicos', COUNT(*), 'Personal' FROM Personal.Medicos
UNION ALL
SELECT 'Consultas', COUNT(*), 'Secretaria' FROM Secretaria.Consultas
UNION ALL
SELECT 'TratamientoXConsulta', COUNT(*), 'Secretaria' FROM Secretaria.TratamientoXConsulta
UNION ALL
SELECT 'Tratamientos', COUNT(*), 'Tesoreria' FROM Tesoreria.Tratamientos
UNION ALL
SELECT 'Factura', COUNT(*), 'Tesoreria' FROM Tesoreria.Factura
UNION ALL
SELECT 'FacturaDetalle', COUNT(*), 'Tesoreria' FROM Tesoreria.FacturaDetalle
ORDER BY Esquema, Tabla

PRINT ''
PRINT '--- VERIFICAR INTEGRIDAD REFERENCIAL'
SELECT 
    c.id AS idConsulta,
    c.idPaciente,
    c.idMedico,
    CASE WHEN p.id IS NULL THEN 'PACIENTE NO EXISTE' ELSE 'OK' END AS ValidacionPaciente,
    CASE WHEN m.id IS NULL THEN 'MEDICO NO EXISTE' ELSE 'OK' END AS ValidacionMedico
FROM Secretaria.Consultas c
LEFT JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
LEFT JOIN Personal.Medicos m ON c.idMedico = m.id
WHERE p.id IS NULL OR m.id IS NULL