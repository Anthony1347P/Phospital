--- Vista mejorada con nombres más descriptivos
CREATE VIEW Secretaria.Vista_PowerBI_Completa AS
SELECT
    --- Dimensión Paciente
    P.id AS idPaciente,
    P.Nobres + ' ' + P.Apellidos AS NombreCompletoPaciente,
    P.Sexo AS SexoPaciente,
    P.edad AS EdadPaciente,
    CASE 
        WHEN P.edad < 5 THEN '0-4 Infantes'
        WHEN P.edad < 13 THEN '5-12 Niños'
        WHEN P.edad < 20 THEN '13-19 Adolescentes'
        WHEN P.edad < 31 THEN '20-30 Adultos Jóvenes'
        WHEN P.edad < 61 THEN '31-60 Adultos'
        ELSE '61+ Adultos Mayores'
    END AS RangoEdadPaciente,
    TS.Tipo AS TipoSangre,
    A.Aseguradora,
    
    --- Dimensión Médico
    M.id AS idMedico,
    M.Nombres + ' ' + M.Apellidos AS NombreCompletoMedico,
    E.Especialidad,
    
    --- Dimensión Temporal Consulta
    C.id AS idConsulta,
    C.Fecha AS FechaConsulta,
    YEAR(C.Fecha) AS AñoConsulta,
    MONTH(C.Fecha) AS MesConsulta,
    DATENAME(MONTH, C.Fecha) AS NombreMesConsulta,
    DATEPART(QUARTER, C.Fecha) AS TrimestreConsulta,
    C.Motivo AS MotivoConsulta,
    C.Estado AS EstadoConsulta,
    
    --- Hechos Tratamiento
    T.Tipo AS TipoTratamiento,
    T.Precio AS PrecioUnitario,
    ISNULL(TXC.Cantidad, 0) AS Cantidad,
    ISNULL(TXC.Cantidad * T.Precio, 0) AS SubtotalTratamiento,
    
    --- Dimensión Temporal Factura
    F.id AS idFactura,
    F.Fecha AS FechaFactura,
    YEAR(F.Fecha) AS AñoFactura,
    MONTH(F.Fecha) AS MesFactura,
    F.Total AS TotalFactura,
    F.Estado AS EstadoFactura

FROM Pacientes.Pacientes P
INNER JOIN Pacientes.TipoDeSangre TS ON P.idTipoDeSangre = TS.idTipoDeSangre
INNER JOIN Pacientes.Aseguradora A ON P.idSeguro = A.idSeguro
LEFT JOIN Secretaria.Consultas C ON P.id = C.idPaciente  
LEFT JOIN Personal.Medicos M ON C.idMedico = M.id      
LEFT JOIN Personal.Especializacion E ON M.idEspecialidad = E.id 
LEFT JOIN Secretaria.TratamientoXConsulta TXC ON C.id = TXC.idConsulta 
LEFT JOIN Tesoreria.Tratamientos T ON TXC.idTratamiento = T.id    
LEFT JOIN Tesoreria.Factura F ON P.id = F.idPaciente