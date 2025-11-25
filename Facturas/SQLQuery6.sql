USE PHospital
GO

--- FASE 4: GENERAR FACTURAS PARA CONSULTAS FINALIZADAS
--- Basado en Guia 8 (Secuencias) - Procedimiento para facturar por consulta individual

--- Paso 1: Crear procedimiento para facturar UNA consulta especifica

CREATE PROCEDURE Tesoreria.CrearFacturaPorConsulta
    @idConsulta INT
AS
BEGIN
    DECLARE @idFactura INT
    DECLARE @idPaciente INT
    DECLARE @Total INT
    
    SELECT @idPaciente = idPaciente 
    FROM Secretaria.Consultas 
    WHERE id = @idConsulta
    
    SELECT @Total = SUM(tc.Cantidad * t.Precio)
    FROM Secretaria.TratamientoXConsulta tc
    INNER JOIN Tesoreria.Tratamientos t ON t.id = tc.idTratamiento
    WHERE tc.idConsulta = @idConsulta
    
    INSERT INTO Tesoreria.Factura (idPaciente, Fecha, Total, Estado)
    VALUES (@idPaciente, GETDATE(), @Total, 'Pagado')
    
    SET @idFactura = SCOPE_IDENTITY()
    
    INSERT INTO Tesoreria.FacturaDetalle (idTratamiento, idPaciente, SubTotal)
    SELECT t.id, @idPaciente, (tc.Cantidad * t.Precio)
    FROM Secretaria.TratamientoXConsulta tc
    INNER JOIN Tesoreria.Tratamientos t ON t.id = tc.idTratamiento
    WHERE tc.idConsulta = @idConsulta
END
GO

--- Paso 2: Generar facturas masivamente para todas las consultas finalizadas
DECLARE @idConsulta INT
DECLARE @contador INT = 0
DECLARE @total INT

SELECT @total = COUNT(*) 
FROM Secretaria.Consultas 
WHERE Estado = 'Finalizado'

DECLARE consultas_cursor CURSOR FOR
SELECT id FROM Secretaria.Consultas 
WHERE Estado = 'Finalizado' 
ORDER BY id

OPEN consultas_cursor
FETCH NEXT FROM consultas_cursor INTO @idConsulta

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        EXEC Tesoreria.CrearFacturaPorConsulta @idConsulta
        SET @contador = @contador + 1
        
        IF @contador % 500 = 0
            PRINT 'Facturas generadas: ' + CAST(@contador AS VARCHAR) + ' de ' + CAST(@total AS VARCHAR)
        
    END TRY
    BEGIN CATCH
        PRINT 'Error al generar factura para consulta ID: ' + CAST(@idConsulta AS VARCHAR)
        PRINT 'Mensaje: ' + ERROR_MESSAGE()
    END CATCH
    
    FETCH NEXT FROM consultas_cursor INTO @idConsulta
END

CLOSE consultas_cursor
DEALLOCATE consultas_cursor

PRINT ''
PRINT '=== PROCESO COMPLETADO ==='
PRINT 'Total de facturas generadas: ' + CAST(@contador AS VARCHAR)

--- Paso 3: Verificar resultados
SELECT 
    'Consultas finalizadas' AS Tipo,
    COUNT(*) AS Total
FROM Secretaria.Consultas 
WHERE Estado = 'Finalizado'
UNION ALL
SELECT 
    'Facturas generadas' AS Tipo,
    COUNT(*) AS Total
FROM Tesoreria.Factura
UNION ALL
SELECT 
    'Detalles de facturas' AS Tipo,
    COUNT(*) AS Total
FROM Tesoreria.FacturaDetalle

--- Paso 4: Ver primeras 10 facturas generadas
SELECT TOP 10 
    f.id,
    f.idPaciente,
    p.Nobres + ' ' + p.Apellidos AS Paciente,
    f.Fecha,
    f.Total,
    f.Estado
FROM Tesoreria.Factura f
INNER JOIN Pacientes.Pacientes p ON f.idPaciente = p.id
ORDER BY f.id DESC