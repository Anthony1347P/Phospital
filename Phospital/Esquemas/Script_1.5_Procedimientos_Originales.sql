--- FASE 1.5: PROCEDIMIENTOS ALMACENADOS ORIGINALES
--- Proyecto: PHospital - Sistema de Gestion Hospitalaria


USE PHospital
GO

--- Procedimiento 1: Crear consulta y asignar tratamiento
CREATE PROCEDURE Secretaria.CrearConsulta 
    @idPaciente int,
    @idMedico int,
    @idTratamiento int,
    @Motivo varchar(100),
    @Estado varchar(20),
    @Cantidad int
AS
BEGIN
    DECLARE @IDConsulta int

    INSERT INTO Secretaria.Consultas(idPaciente, idMedico, Fecha, Motivo, Estado) VALUES
    (@idPaciente, @idMedico, GETDATE(), @Motivo, @Estado)

    SET @IDConsulta = SCOPE_IDENTITY()

    INSERT INTO Secretaria.TratamientoXConsulta(idConsulta, idTratamiento, Cantidad) VALUES
    (@IDConsulta, @idTratamiento, @Cantidad)
END
GO

--- Procedimiento 2: Crear factura para un paciente
CREATE PROCEDURE Tesoreria.CrearFactura
    @idPaciente int,
    @Estado varchar(20)
AS
BEGIN
    DECLARE @idFactura int
    DECLARE @Total int
    
    SELECT @Total = SUM(tc.Cantidad * t.Precio) 
    FROM Secretaria.Consultas c
    INNER JOIN Secretaria.TratamientoXConsulta tc ON tc.idConsulta = c.id
    INNER JOIN Tesoreria.Tratamientos t ON t.id = tc.idTratamiento
    WHERE c.idPaciente = @idPaciente

    INSERT INTO Tesoreria.Factura (idPaciente, Fecha, Total, Estado) 
    VALUES (@idPaciente, GETDATE(), @Total, @Estado)
    
    SET @idFactura = SCOPE_IDENTITY()

    INSERT INTO Tesoreria.FacturaDetalle (idTratamiento, idPaciente, SubTotal) 
    SELECT t.id, c.idPaciente, (tc.Cantidad * t.Precio) 
    FROM Secretaria.Consultas c
    INNER JOIN Secretaria.TratamientoXConsulta tc ON tc.idConsulta = c.id
    INNER JOIN Tesoreria.Tratamientos t ON t.id = tc.idTratamiento
    WHERE c.idPaciente = @idPaciente
END
GO

--- Procedimiento 3: Ver historial completo de facturas de un paciente
CREATE PROCEDURE Tesoreria.Ver_Historial_de_Facturas
    @idPaciente int
AS
BEGIN
    SELECT * FROM Tesoreria.Factura WHERE idPaciente = @idPaciente
    SELECT * FROM Tesoreria.FacturaDetalle WHERE idPaciente = @idPaciente
END
GO

--- Procedimiento 4: Ver ultima factura de un paciente
CREATE PROCEDURE Tesoreria.Ver_Ultima_Factura
    @idPaciente int
AS
BEGIN
    SELECT TOP 1 * FROM Tesoreria.Factura WHERE idPaciente = @idPaciente ORDER BY id DESC
    SELECT TOP 1 * FROM Tesoreria.FacturaDetalle WHERE idPaciente = @idPaciente ORDER BY id DESC
END
GO

--- Procedimiento 5: Buscar donantes de sangre compatibles
CREATE PROCEDURE Pacientes.SangreCompatible
    @idPaciente int
AS
BEGIN
    DECLARE @tipoPaciente varchar(5)

    SELECT @tipoPaciente = ts.Tipo
    FROM Pacientes.Pacientes p
    INNER JOIN Pacientes.TipoDeSangre ts ON p.idTipoDeSangre = ts.idTipoDeSangre
    WHERE p.id = @idPaciente

    SELECT p.id, p.Nobres, p.Apellidos, ts.Tipo
    FROM Pacientes.Pacientes p
    INNER JOIN Pacientes.TipoDeSangre ts ON p.idTipoDeSangre = ts.idTipoDeSangre
    WHERE ts.Tipo IN (
        SELECT TipoCompatible FROM (
            SELECT 'A+' AS Tipo, 'A+' AS TipoCompatible UNION
            SELECT 'A+', 'A-' UNION
            SELECT 'A+', 'O+' UNION
            SELECT 'A+', 'O-' UNION
            SELECT 'O+', 'O+' UNION
            SELECT 'O+', 'O-' UNION
            SELECT 'B+', 'B+' UNION
            SELECT 'B+', 'B-' UNION
            SELECT 'B+', 'O+' UNION
            SELECT 'B+', 'O-' UNION
            SELECT 'AB+', 'A+' UNION
            SELECT 'AB+', 'B+' UNION
            SELECT 'AB+', 'AB+' UNION
            SELECT 'AB+', 'O+' UNION
            SELECT 'AB+', 'A-' UNION
            SELECT 'AB+', 'B-' UNION
            SELECT 'AB+', 'AB-' UNION
            SELECT 'AB+', 'O-' UNION
            SELECT 'A-', 'A-' UNION
            SELECT 'A-', 'O-' UNION
            SELECT 'O-', 'O-' UNION
            SELECT 'B-', 'B-' UNION
            SELECT 'B-', 'O-' UNION
            SELECT 'AB-', 'A-' UNION
            SELECT 'AB-', 'B-' UNION
            SELECT 'AB-', 'AB-' UNION
            SELECT 'AB-', 'O-'
        ) AS Compatibles
        WHERE Tipo = @tipoPaciente
    )
    AND p.id != @idPaciente
END
GO

--- Crear vista: Costo de consulta por médico
CREATE VIEW Secretaria.Costo_de_Consulta_por_Medico AS
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

--- Ver todos los procedimientos creados
SELECT name AS Procedimiento, SCHEMA_NAME(schema_id) AS Esquema 
FROM sys.procedures 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Pacientes'))
GO

--- Ver vistas creadas
SELECT name AS Vista, SCHEMA_NAME(schema_id) AS Esquema 
FROM sys.views 
WHERE schema_id = SCHEMA_ID('Secretaria')
GO
