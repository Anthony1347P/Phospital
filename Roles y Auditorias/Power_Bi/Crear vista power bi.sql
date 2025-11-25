USE PHospital
GO

CREATE VIEW Secretaria.Vista_PowerBI AS
SELECT
    P.id AS idPaciente,
    P.Nobres AS NombrePaciente,
    P.Apellidos AS ApellidoPaciente,
    P.Sexo AS SexoPaciente,
    P.edad AS EdadPaciente,
    P.Celular AS CelularPaciente,
    P.Direccion AS DireccionPaciente,
    P.DUI AS DUIPaciente,
    TS.Tipo AS TipoDeSangre,
    A.Aseguradora AS NombreAseguradora,
    A.codigo AS CodigoAseguradora,
    C.id AS idConsulta,
    C.Fecha AS FechaConsulta,
    C.Motivo AS MotivoConsulta,
    C.Estado AS EstadoConsulta,
    M.id AS idMedico,
    M.Nombres AS NombreMedico,
    M.Apellidos AS ApellidoMedico,
    M.Sexo AS SexoMedico,
    M.edad AS EdadMedico,
    M.celular AS CelularMedico,
    E.Especialidad AS EspecialidadMedico,
    T.Tipo AS NombreTratamiento,
    T.Precio AS PrecioUnitarioTratamiento,
    TXC.Cantidad AS CantidadTratamiento,
    (TXC.Cantidad * T.Precio) AS SubtotalTratamientoXConsulta,
    F.id AS idFactura,
    F.Fecha AS FechaFactura,
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
LEFT JOIN Tesoreria.Factura F ON P.id = F.idPaciente;
GO