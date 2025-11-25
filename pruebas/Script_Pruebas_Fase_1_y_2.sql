--- SCRIPT DE PRUEBAS COMPLETO - FASE 1 Y FASE 2
--- Proyecto: PHospital - Sistema de Gestión Hospitalaria
--- Fecha: 2025-11-12
--- Este script prueba TODAS las funcionalidades implementadas

USE PHospital
GO

PRINT '========================================='
PRINT 'INICIANDO PRUEBAS COMPLETAS'
PRINT 'FASE 1 + FASE 2'
PRINT '========================================='
PRINT ''

---
--- SECCION 1: VERIFICAR ESTRUCTURA BASE
---

PRINT '--- SECCION 1: ESTRUCTURA BASE ---'
PRINT ''

--- Verificar esquemas
PRINT '1.1 Esquemas creados:'
SELECT name AS Esquema, USER_NAME(principal_id) AS Propietario 
FROM sys.schemas 
WHERE name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria')
PRINT ''

--- Verificar tablas por esquema
PRINT '1.2 Tablas por esquema:'
SELECT s.name AS Esquema, o.name AS Tabla
FROM sys.tables o
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE s.name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria')
ORDER BY s.name, o.name
PRINT ''

--- Verificar datos maestros
PRINT '1.3 Conteo de datos maestros:'
SELECT 'TipoDeSangre' AS Tabla, COUNT(*) AS Registros FROM Pacientes.TipoDeSangre
UNION ALL SELECT 'Aseguradora', COUNT(*) FROM Pacientes.Aseguradora
UNION ALL SELECT 'Especializacion', COUNT(*) FROM Personal.Especializacion
UNION ALL SELECT 'Tratamientos', COUNT(*) FROM Tesoreria.Tratamientos
PRINT ''

--- Verificar datos de prueba
PRINT '1.4 Conteo de datos de prueba:'
SELECT 'Pacientes' AS Tabla, COUNT(*) AS Registros FROM Pacientes.Pacientes
UNION ALL SELECT 'Medicos', COUNT(*) FROM Personal.Medicos
PRINT ''

---
--- SECCION 2: VERIFICAR OBJETOS CREADOS
---

PRINT '--- SECCION 2: OBJETOS DE BASE DE DATOS ---'
PRINT ''

--- Verificar vistas
PRINT '2.1 Vistas creadas:'
SELECT name AS Vista, SCHEMA_NAME(schema_id) AS Esquema 
FROM sys.views 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
ORDER BY Esquema, name
PRINT ''

--- Verificar funciones
PRINT '2.2 Funciones creadas:'
SELECT name AS Funcion, SCHEMA_NAME(schema_id) AS Esquema, type_desc AS Tipo 
FROM sys.objects 
WHERE type IN ('FN', 'IF', 'TF') 
AND schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
ORDER BY Esquema, name
PRINT ''

--- Verificar triggers
PRINT '2.3 Triggers creados:'
SELECT t.name AS NombreTrigger, SCHEMA_NAME(o.schema_id) AS Esquema, OBJECT_NAME(t.parent_id) AS Tabla 
FROM sys.triggers t
INNER JOIN sys.objects o ON t.parent_id = o.object_id
WHERE t.is_ms_shipped = 0
ORDER BY Esquema, Tabla
PRINT ''

--- Verificar procedimientos
PRINT '2.4 Procedimientos almacenados:'
SELECT name AS Procedimiento, SCHEMA_NAME(schema_id) AS Esquema 
FROM sys.procedures 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
ORDER BY Esquema, name
PRINT ''

---
--- SECCION 3: PRUEBAS DE PROCEDIMIENTOS ORIGINALES
---

PRINT '--- SECCION 3: PRUEBAS DE PROCEDIMIENTOS ORIGINALES ---'
PRINT ''

--- Prueba 1: CrearConsulta
PRINT '3.1 Probando CrearConsulta...'
EXEC Secretaria.CrearConsulta 
    @idPaciente = 1, 
    @idMedico = 1, 
    @idTratamiento = 1, 
    @Motivo = 'Prueba automatica - Consulta general', 
    @Estado = 'Finalizado', 
    @Cantidad = 1
PRINT 'Consulta creada exitosamente'
PRINT ''

--- Prueba 2: Crear otra consulta para el mismo paciente
PRINT '3.2 Creando segunda consulta para el mismo paciente...'
EXEC Secretaria.CrearConsulta 
    @idPaciente = 1, 
    @idMedico = 2, 
    @idTratamiento = 2, 
    @Motivo = 'Prueba automatica - Control', 
    @Estado = 'Finalizado', 
    @Cantidad = 2
PRINT 'Segunda consulta creada exitosamente'
PRINT ''

--- Prueba 3: CrearFactura
PRINT '3.3 Probando CrearFactura...'
EXEC Tesoreria.CrearFactura @idPaciente = 1, @Estado = 'Finalizado'
PRINT 'Factura creada exitosamente'
PRINT ''

--- Prueba 4: Ver_Historial_de_Facturas
PRINT '3.4 Probando Ver_Historial_de_Facturas...'
EXEC Tesoreria.Ver_Historial_de_Facturas @idPaciente = 1
PRINT ''

--- Prueba 5: Ver_Ultima_Factura
PRINT '3.5 Probando Ver_Ultima_Factura...'
EXEC Tesoreria.Ver_Ultima_Factura @idPaciente = 1
PRINT ''

--- Prueba 6: SangreCompatible
PRINT '3.6 Probando SangreCompatible...'
EXEC Pacientes.SangreCompatible @idPaciente = 1
PRINT ''

---
--- SECCION 4: PRUEBAS DE PROCEDIMIENTOS ADICIONALES
---

PRINT '--- SECCION 4: PRUEBAS DE PROCEDIMIENTOS ADICIONALES ---'
PRINT ''

--- Prueba 7: SP_Buscar_Paciente_Por_DUI
PRINT '4.1 Probando SP_Buscar_Paciente_Por_DUI...'
EXEC Pacientes.SP_Buscar_Paciente_Por_DUI @DUI = 123456789
PRINT ''

--- Prueba 8: SP_Reporte_Consultas_Por_Periodo
PRINT '4.2 Probando SP_Reporte_Consultas_Por_Periodo...'
EXEC Secretaria.SP_Reporte_Consultas_Por_Periodo 
    @FechaInicio = '2025-01-01', 
    @FechaFin = '2025-12-31'
PRINT ''

---
--- SECCION 5: PRUEBAS DE VISTAS
---

PRINT '--- SECCION 5: PRUEBAS DE VISTAS ---'
PRINT ''

--- Vista 1: Costo_de_Consulta_por_Medico (original)
PRINT '5.1 Vista: Costo_de_Consulta_por_Medico'
SELECT TOP 3 * FROM Secretaria.Costo_de_Consulta_por_Medico
ORDER BY CostoConsultaIndividual DESC
PRINT ''

--- Vista 2: Vista_Consultas_Detalladas
PRINT '5.2 Vista: Vista_Consultas_Detalladas'
SELECT TOP 3 * FROM Secretaria.Vista_Consultas_Detalladas
ORDER BY Fecha DESC
PRINT ''

--- Vista 3: Vista_Pacientes_Completa
PRINT '5.3 Vista: Vista_Pacientes_Completa'
SELECT TOP 3 * FROM Pacientes.Vista_Pacientes_Completa
ORDER BY id
PRINT ''

--- Vista 4: Vista_Medicos_Productividad
PRINT '5.4 Vista: Vista_Medicos_Productividad'
SELECT TOP 3 * FROM Personal.Vista_Medicos_Productividad
ORDER BY TotalConsultas DESC
PRINT ''

--- Vista 5: Vista_Facturacion_Mensual
PRINT '5.5 Vista: Vista_Facturacion_Mensual'
SELECT * FROM Tesoreria.Vista_Facturacion_Mensual
ORDER BY Anio DESC, Mes DESC
PRINT ''

--- Vista 6: Vista_Tratamientos_Mas_Usados
PRINT '5.6 Vista: Vista_Tratamientos_Mas_Usados'
SELECT TOP 3 * FROM Tesoreria.Vista_Tratamientos_Mas_Usados
ORDER BY CantidadUsos DESC
PRINT ''

---
--- SECCION 6: PRUEBAS DE FUNCIONES
---

PRINT '--- SECCION 6: PRUEBAS DE FUNCIONES ---'
PRINT ''

--- Función 1: FN_Calcular_Deuda_Paciente
PRINT '6.1 Funcion: FN_Calcular_Deuda_Paciente'
SELECT id, Nobres, Apellidos, 
       Tesoreria.FN_Calcular_Deuda_Paciente(id) AS DeudaTotal
FROM Pacientes.Pacientes
WHERE id <= 5
ORDER BY id
PRINT ''

--- Función 2: FN_Total_Consultas_Paciente
PRINT '6.2 Funcion: FN_Total_Consultas_Paciente'
SELECT id, Nobres, Apellidos,
       Secretaria.FN_Total_Consultas_Paciente(id) AS TotalConsultas
FROM Pacientes.Pacientes
WHERE id <= 5
ORDER BY id
PRINT ''

--- Función 3: FN_Total_Gastado_Paciente
PRINT '6.3 Funcion: FN_Total_Gastado_Paciente'
SELECT id, Nobres, Apellidos,
       Tesoreria.FN_Total_Gastado_Paciente(id) AS TotalGastado
FROM Pacientes.Pacientes
WHERE id <= 5
ORDER BY id
PRINT ''

--- Función 4: FN_Tratamientos_De_Consulta
PRINT '6.4 Funcion: FN_Tratamientos_De_Consulta (consulta 1)'
SELECT * FROM Secretaria.FN_Tratamientos_De_Consulta(1)
PRINT ''

--- Función 5: FN_Tiene_Consultas_Pendientes
PRINT '6.5 Funcion: FN_Tiene_Consultas_Pendientes'
SELECT id, Nobres, Apellidos,
       CASE Secretaria.FN_Tiene_Consultas_Pendientes(id)
           WHEN 1 THEN 'SI'
           ELSE 'NO'
       END AS TieneConsultasPendientes
FROM Pacientes.Pacientes
WHERE id <= 5
ORDER BY id
PRINT ''

---
--- SECCION 7: PRUEBAS DE TRIGGERS (VALIDACIONES)
---

PRINT '--- SECCION 7: PRUEBAS DE TRIGGERS ---'
PRINT ''

--- Trigger 1: TR_Validar_DUI (debe fallar con DUI corto)
PRINT '7.1 Trigger: TR_Validar_DUI (probando con DUI invalido - debe fallar)'
BEGIN TRY
    INSERT INTO Pacientes.Pacientes (Nobres, Apellidos, Sexo, edad, idTipoDeSangre, Celular, Direccion, DUI, idSeguro)
    VALUES ('Test', 'DUI Invalido', 'M', 30, 1, 70001234, 'Test', 123, 1)
    PRINT 'ERROR: El trigger NO funciono correctamente'
END TRY
BEGIN CATCH
    PRINT 'CORRECTO: Trigger funciono - ' + ERROR_MESSAGE()
END CATCH
PRINT ''

--- Trigger 2: TR_Validar_Celular_Paciente (debe fallar con celular que no inicia con 6 o 7)
PRINT '7.2 Trigger: TR_Validar_Celular_Paciente (probando con celular invalido - debe fallar)'
BEGIN TRY
    INSERT INTO Pacientes.Pacientes (Nobres, Apellidos, Sexo, edad, idTipoDeSangre, Celular, Direccion, DUI, idSeguro)
    VALUES ('Test', 'Celular Invalido', 'M', 30, 1, 50001234, 'Test', 99999999, 1)
    PRINT 'ERROR: El trigger NO funciono correctamente'
END TRY
BEGIN CATCH
    PRINT 'CORRECTO: Trigger funciono - ' + ERROR_MESSAGE()
END CATCH
PRINT ''

--- Trigger 3: TR_Validar_Edad_Paciente (debe fallar con edad > 120)
PRINT '7.3 Trigger: TR_Validar_Edad_Paciente (probando con edad invalida - debe fallar)'
BEGIN TRY
    INSERT INTO Pacientes.Pacientes (Nobres, Apellidos, Sexo, edad, idTipoDeSangre, Celular, Direccion, DUI, idSeguro)
    VALUES ('Test', 'Edad Invalida', 'M', 150, 1, 70001234, 'Test', 88888888, 1)
    PRINT 'ERROR: El trigger NO funciono correctamente'
END TRY
BEGIN CATCH
    PRINT 'CORRECTO: Trigger funciono - ' + ERROR_MESSAGE()
END CATCH
PRINT ''

--- Trigger 4: TR_Validar_Precio_Tratamiento (debe fallar con precio negativo)
PRINT '7.4 Trigger: TR_Validar_Precio_Tratamiento (probando con precio invalido - debe fallar)'
BEGIN TRY
    INSERT INTO Tesoreria.Tratamientos (Tipo, Precio)
    VALUES ('Test Precio', -10)
    PRINT 'ERROR: El trigger NO funciono correctamente'
END TRY
BEGIN CATCH
    PRINT 'CORRECTO: Trigger funciono - ' + ERROR_MESSAGE()
END CATCH
PRINT ''

--- Trigger 5: TR_Evitar_Eliminar_Paciente_Con_Consultas (debe fallar al eliminar paciente con consultas)
PRINT '7.5 Trigger: TR_Evitar_Eliminar_Paciente_Con_Consultas (debe fallar)'
BEGIN TRY
    DELETE FROM Pacientes.Pacientes WHERE id = 1
    PRINT 'ERROR: El trigger NO funciono correctamente'
END TRY
BEGIN CATCH
    PRINT 'CORRECTO: Trigger funciono - ' + ERROR_MESSAGE()
END CATCH
PRINT ''

---
--- SECCION 8: RESUMEN FINAL
---

PRINT '========================================='
PRINT 'RESUMEN FINAL DE PRUEBAS'
PRINT '========================================='
PRINT ''

--- Resumen de consultas y facturas creadas en las pruebas
PRINT 'Datos generados durante las pruebas:'
SELECT 'Consultas totales' AS Concepto, COUNT(*) AS Cantidad FROM Secretaria.Consultas
UNION ALL SELECT 'TratamientosXConsulta', COUNT(*) FROM Secretaria.TratamientoXConsulta
UNION ALL SELECT 'Facturas totales', COUNT(*) FROM Tesoreria.Factura
UNION ALL SELECT 'FacturaDetalle', COUNT(*) FROM Tesoreria.FacturaDetalle
PRINT ''

--- Resumen de objetos en la base de datos
PRINT 'Resumen de objetos en PHospital:'
SELECT 'Esquemas' AS Tipo, COUNT(*) AS Cantidad FROM sys.schemas 
WHERE name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria')
UNION ALL
SELECT 'Tablas', COUNT(*) FROM sys.tables 
WHERE schema_id IN (SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'), SCHEMA_ID('Secretaria'))
UNION ALL
SELECT 'Vistas', COUNT(*) FROM sys.views 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
UNION ALL
SELECT 'Funciones', COUNT(*) FROM sys.objects 
WHERE type IN ('FN', 'IF', 'TF') 
AND schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
UNION ALL
SELECT 'Triggers', COUNT(*) FROM sys.triggers WHERE is_ms_shipped = 0
UNION ALL
SELECT 'Procedimientos', COUNT(*) FROM sys.procedures 
WHERE schema_id IN (SCHEMA_ID('Secretaria'), SCHEMA_ID('Pacientes'), SCHEMA_ID('Personal'), SCHEMA_ID('Tesoreria'))
PRINT ''

PRINT '========================================='
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE'
PRINT 'FECHA: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
