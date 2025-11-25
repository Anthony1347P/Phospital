USE PHospital
GO

--- TABLA 1: RESUMEN DE REGISTROS POR TABLA
SELECT 
    'Pacientes' AS Tabla,
    COUNT(*) AS RegistrosActuales,
    'Se insertan segun la poblacion atendida' AS ComoCalcularlos
FROM Pacientes.Pacientes
UNION ALL
SELECT 
    'Medicos' AS Tabla,
    COUNT(*) AS RegistrosActuales,
    'Se insertan segun el personal medico disponible' AS ComoCalcularlos
FROM Personal.Medicos
UNION ALL
SELECT 
    'Consultas' AS Tabla,
    COUNT(*) AS RegistrosActuales,
    'Cada consulta registrada en el sistema' AS ComoCalcularlos
FROM Secretaria.Consultas
UNION ALL
SELECT 
    'Tratamientos' AS Tabla,
    COUNT(*) AS RegistrosActuales,
    'Catalogo de tratamientos disponibles en el hospital' AS ComoCalcularlos
FROM Tesoreria.Tratamientos
UNION ALL
SELECT 
    'Factura' AS Tabla,
    COUNT(*) AS RegistrosActuales,
    'Cada factura emitida a un paciente' AS ComoCalcularlos
FROM Tesoreria.Factura
UNION ALL
SELECT 
    'FacturaDetalle' AS Tabla,
    COUNT(*) AS RegistrosActuales,
    'Facturas x promedio de tratamientos (' + CAST(COUNT(*) AS VARCHAR) + ' registros)' AS ComoCalcularlos
FROM Tesoreria.FacturaDetalle
UNION ALL
SELECT 
    'TratamientoXConsulta' AS Tabla,
    COUNT(*) AS RegistrosActuales,
    'Consultas x promedio de tratamientos (' + CAST(COUNT(*) AS VARCHAR) + ' registros)' AS ComoCalcularlos
FROM Secretaria.TratamientoXConsulta

--- TABLA 2: DATOS MAESTROS DETALLADOS
SELECT 
    'TipoDeSangre' AS Tabla,
    COUNT(*) AS RegistrosNecesarios,
    'A+, A-, B+, B-, AB+, AB-, O+, O-' AS Detalle
FROM Pacientes.TipoDeSangre
UNION ALL
SELECT 
    'Especializacion' AS Tabla,
    COUNT(*) AS RegistrosNecesarios,
    'Ejemplos: Pediatria, Cardiologia, Ginecologia, Cirugia, Medicina Interna, etc.' AS Detalle
FROM Personal.Especializacion
UNION ALL
SELECT 
    'Aseguradora' AS Tabla,
    COUNT(*) AS RegistrosNecesarios,
    'Depende de las aseguradoras afiliadas al hospital' AS Detalle
FROM Pacientes.Aseguradora

--- DETALLE ESPECIFICO: TIPOS DE SANGRE
SELECT 'TIPOS DE SANGRE REGISTRADOS:' AS Informacion
SELECT idTipoDeSangre AS ID, Tipo FROM Pacientes.TipoDeSangre ORDER BY idTipoDeSangre

--- DETALLE ESPECIFICO: ESPECIALIZACIONES
SELECT 'ESPECIALIZACIONES REGISTRADAS:' AS Informacion
SELECT id AS ID, Especialidad FROM Personal.Especializacion ORDER BY id

--- DETALLE ESPECIFICO: ASEGURADORAS
SELECT 'ASEGURADORAS REGISTRADAS:' AS Informacion
SELECT idSeguro AS ID, Aseguradora, codigo FROM Pacientes.Aseguradora ORDER BY idSeguro

--- CALCULO DE PROMEDIOS
SELECT 
    'Promedio de tratamientos por consulta' AS Metrica,
    CAST(COUNT(tc.id) AS DECIMAL(10,2)) / COUNT(DISTINCT tc.idConsulta) AS Valor
FROM Secretaria.TratamientoXConsulta tc
INNER JOIN Secretaria.Consultas c ON tc.idConsulta = c.id
WHERE c.Estado = 'Finalizado'
UNION ALL
SELECT 
    'Promedio de detalles por factura' AS Metrica,
    CAST(COUNT(*) AS DECIMAL(10,2)) / (SELECT COUNT(*) FROM Tesoreria.Factura) AS Valor
FROM Tesoreria.FacturaDetalle