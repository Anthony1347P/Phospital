--- FASE 2: FUNCIONALIDADES ADICIONALES
--- Proyecto: PHospital - Sistema de Gestion Hospitalaria
--- Contiene: 5 Vistas, 5 Funciones, 5 Triggers, 2 Procedimientos adicionales

USE PHospital
GO

---
--- SECCION 1: VISTAS (5)
---

--- Vista 1: Consultas con información detallada de paciente y medico
CREATE VIEW Secretaria.Vista_Consultas_Detalladas AS
SELECT c.id, c.Fecha, c.Motivo, c.Estado,
       p.Nobres + ' ' + p.Apellidos AS NombrePaciente,
       m.Nombres + ' ' + m.Apellidos AS NombreMedico,
       e.Especialidad
FROM Secretaria.Consultas c
INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
INNER JOIN Personal.Medicos m ON c.idMedico = m.id
INNER JOIN Personal.Especializacion e ON m.idEspecialidad = e.id
GO

--- Vista 2: Pacientes con toda su informacion completa
CREATE VIEW Pacientes.Vista_Pacientes_Completa AS
SELECT p.id, p.Nobres, p.Apellidos, p.Sexo, p.edad, 
       ts.Tipo AS TipoSangre, p.Celular, p.Direccion, p.DUI,
       a.Aseguradora, a.codigo AS CodigoSeguro
FROM Pacientes.Pacientes p
INNER JOIN Pacientes.TipoDeSangre ts ON p.idTipoDeSangre = ts.idTipoDeSangre
INNER JOIN Pacientes.Aseguradora a ON p.idSeguro = a.idSeguro
GO

--- Vista 3: Medicos con cantidad de consultas atendidas
CREATE VIEW Personal.Vista_Medicos_Productividad AS
SELECT m.id, m.Nombres, m.Apellidos, e.Especialidad,
       COUNT(c.id) AS TotalConsultas
FROM Personal.Medicos m
INNER JOIN Personal.Especializacion e ON m.idEspecialidad = e.id
LEFT JOIN Secretaria.Consultas c ON m.id = c.idMedico
GROUP BY m.id, m.Nombres, m.Apellidos, e.Especialidad
GO

--- Vista 4: Facturacion mensual
CREATE VIEW Tesoreria.Vista_Facturacion_Mensual AS
SELECT YEAR(Fecha) AS Anio, MONTH(Fecha) AS Mes,
       COUNT(id) AS TotalFacturas,
       SUM(Total) AS TotalFacturado,
       AVG(Total) AS PromedioFactura
FROM Tesoreria.Factura
GROUP BY YEAR(Fecha), MONTH(Fecha)
GO

--- Vista 5: Tratamientos mas usados ordenados por frecuencia
CREATE VIEW Tesoreria.Vista_Tratamientos_Mas_Usados AS
SELECT t.id, t.Tipo, t.Precio, 
       COUNT(tc.id) AS CantidadUsos,
       SUM(tc.Cantidad) AS TotalAplicado
FROM Tesoreria.Tratamientos t
INNER JOIN Secretaria.TratamientoXConsulta tc ON t.id = tc.idTratamiento
GROUP BY t.id, t.Tipo, t.Precio
GO

---
--- SECCION 2: FUNCIONES (5)
---

--- Funcion 1: Calcular deuda total de un paciente
CREATE FUNCTION Tesoreria.FN_Calcular_Deuda_Paciente(@idPaciente int)
RETURNS int
AS
BEGIN
    DECLARE @Deuda int
    SELECT @Deuda = ISNULL(SUM(Total), 0)
    FROM Tesoreria.Factura
    WHERE idPaciente = @idPaciente AND Estado = 'Pendiente'
    RETURN @Deuda
END
GO

--- Funcion 2: Contar total de consultas de un paciente
CREATE FUNCTION Secretaria.FN_Total_Consultas_Paciente(@idPaciente int)
RETURNS int
AS
BEGIN
    DECLARE @Total int
    SELECT @Total = COUNT(*) FROM Secretaria.Consultas WHERE idPaciente = @idPaciente
    RETURN @Total
END
GO

--- Funcion 3: Calcular total gastado por un paciente
CREATE FUNCTION Tesoreria.FN_Total_Gastado_Paciente(@idPaciente int)
RETURNS int
AS
BEGIN
    DECLARE @Total int
    SELECT @Total = ISNULL(SUM(Total), 0)
    FROM Tesoreria.Factura
    WHERE idPaciente = @idPaciente
    RETURN @Total
END
GO

--- Funcion 4: Obtener tratamientos aplicados en una consulta
CREATE FUNCTION Secretaria.FN_Tratamientos_De_Consulta(@idConsulta int)
RETURNS TABLE
AS
RETURN (
    SELECT t.id, t.Tipo, t.Precio, tc.Cantidad, (t.Precio * tc.Cantidad) AS Subtotal
    FROM Secretaria.TratamientoXConsulta tc
    INNER JOIN Tesoreria.Tratamientos t ON tc.idTratamiento = t.id
    WHERE tc.idConsulta = @idConsulta
)
GO

--- Funcion 5: Verificar si un paciente tiene consultas pendientes
CREATE FUNCTION Secretaria.FN_Tiene_Consultas_Pendientes(@idPaciente int)
RETURNS bit
AS
BEGIN
    DECLARE @Tiene bit
    IF EXISTS(SELECT 1 FROM Secretaria.Consultas WHERE idPaciente = @idPaciente AND Estado = 'Pendiente')
        SET @Tiene = 1
    ELSE
        SET @Tiene = 0
    RETURN @Tiene
END
GO

---
--- SECCION 3: TRIGGERS (5)
---

--- Trigger 1: Validar formato DUI Salvadoreño en INSERT y UPDATE
CREATE TRIGGER Pacientes.TR_Validar_DUI
ON Pacientes.Pacientes
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE DUI < 10000000 OR DUI > 99999999
    )
    BEGIN
        RAISERROR('DUI inválido. Debe tener exactamente 8 dígitos', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

--- Trigger 2: Validar formato de celular Salvadoreño en INSERT y UPDATE
CREATE TRIGGER Pacientes.TR_Validar_Celular_Paciente
ON Pacientes.Pacientes
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE Celular < 60000000 OR Celular > 79999999
    )
    BEGIN
        RAISERROR('Celular invalido. Debe tener 8 digitos y comenzar con 6 o 7', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

--- Trigger 3: Evitar eliminar pacientes con consultas registradas
CREATE TRIGGER Pacientes.TR_Evitar_Eliminar_Paciente_Con_Consultas
ON Pacientes.Pacientes
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM deleted d
        INNER JOIN Secretaria.Consultas c ON d.id = c.idPaciente
    )
    BEGIN
        RAISERROR('No se puede eliminar el paciente porque tiene consultas registradas', 16, 1)
    END
    ELSE
    BEGIN
        DELETE FROM Pacientes.Pacientes WHERE id IN (SELECT id FROM deleted)
    END
END
GO

--- Trigger 4: Validar edad del paciente entre 0 y 120 años
CREATE TRIGGER Pacientes.TR_Validar_Edad_Paciente
ON Pacientes.Pacientes
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE edad < 0 OR edad > 120)
    BEGIN
        RAISERROR('Edad inválida. Debe estar entre 0 y 120 anos', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

--- Trigger 5: Validar que el precio de tratamiento sea mayor a cero
CREATE TRIGGER Tesoreria.TR_Validar_Precio_Tratamiento
ON Tesoreria.Tratamientos
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Precio <= 0)
    BEGIN
        RAISERROR('Precio inválido. Debe ser mayor a 0', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

---
--- SECCION 4: PROCEDIMIENTOS ADICIONALES (2)
---

--- Procedimiento 1: Buscar paciente por DUI
CREATE PROCEDURE Pacientes.SP_Buscar_Paciente_Por_DUI
    @DUI int
AS
BEGIN
    SELECT p.id, p.Nobres, p.Apellidos, p.Sexo, p.edad, 
           ts.Tipo AS TipoSangre, p.Celular, p.Direccion, p.DUI,
           a.Aseguradora
    FROM Pacientes.Pacientes p
    INNER JOIN Pacientes.TipoDeSangre ts ON p.idTipoDeSangre = ts.idTipoDeSangre
    INNER JOIN Pacientes.Aseguradora a ON p.idSeguro = a.idSeguro
    WHERE p.DUI = @DUI
END
GO

--- Procedimiento 2: Reporte de consultas por periodo de fechas
CREATE PROCEDURE Secretaria.SP_Reporte_Consultas_Por_Periodo
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    SELECT c.id, c.Fecha, c.Motivo, c.Estado,
           p.Nobres + ' ' + p.Apellidos AS Paciente,
           m.Nombres + ' ' + m.Apellidos AS Medico,
           e.Especialidad,
           SUM(t.Precio * tc.Cantidad) AS CostoTotal
    FROM Secretaria.Consultas c
    INNER JOIN Pacientes.Pacientes p ON c.idPaciente = p.id
    INNER JOIN Personal.Medicos m ON c.idMedico = m.id
    INNER JOIN Personal.Especializacion e ON m.idEspecialidad = e.id
    LEFT JOIN Secretaria.TratamientoXConsulta tc ON c.id = tc.idConsulta
    LEFT JOIN Tesoreria.Tratamientos t ON tc.idTratamiento = t.id
    WHERE c.Fecha BETWEEN @FechaInicio AND @FechaFin
    GROUP BY c.id, c.Fecha, c.Motivo, c.Estado, p.Nobres, p.Apellidos, 
             m.Nombres, m.Apellidos, e.Especialidad
    ORDER BY c.Fecha DESC
END
GO







---
--- VERIFICACIONES
---

--- Ver todas las vistas creadas
SELECT name AS Vista, SCHEMA_NAME(schema_id) AS Esquema 
FROM sys.views 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
ORDER BY Esquema, name
GO

--- Ver todas las funciones creadas
SELECT name AS Funcion, SCHEMA_NAME(schema_id) AS Esquema, type_desc AS Tipo 
FROM sys.objects 
WHERE type IN ('FN', 'IF', 'TF') 
AND schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
ORDER BY Esquema, name
GO

--- Ver todos los triggers creados
SELECT t.name AS NombreTrigger, SCHEMA_NAME(o.schema_id) AS Esquema, OBJECT_NAME(t.parent_id) AS Tabla 
FROM sys.triggers t
INNER JOIN sys.objects o ON t.parent_id = o.object_id
WHERE t.is_ms_shipped = 0
ORDER BY Esquema, Tabla
GO

--- Ver todos los procedimientos almacenados
SELECT name AS Procedimiento, SCHEMA_NAME(schema_id) AS Esquema 
FROM sys.procedures 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
ORDER BY Esquema, name
GO

--- Resumen de objetos creados 
SELECT 'Vistas' AS Tipo, COUNT(*) AS Cantidad FROM sys.views 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
UNION ALL
SELECT 'Funciones', COUNT(*) FROM sys.objects 
WHERE type IN ('FN', 'IF', 'TF') 
AND schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
UNION ALL
SELECT 'Triggers', COUNT(*) FROM sys.triggers WHERE is_ms_shipped = 0
UNION ALL
SELECT 'Procedimientos Adicionales', COUNT(*) FROM sys.procedures 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
AND name IN ('SP_Buscar_Paciente_Por_DUI', 'SP_Reporte_Consultas_Por_Periodo')
GO