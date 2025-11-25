--- SCRIPT CARGA MASIVA SIN IDENTITY_INSERT
--- CSV SIN columna id, SQL Server genera IDs automaticamente
--- Archivos CSV en: C:\ADMIN BDA\CSV\

USE PHospital
GO

--- Ver estado inicial
SELECT 'Medicos' AS Tabla, COUNT(*) AS Registros_Actuales FROM Personal.Medicos
UNION ALL
SELECT 'Pacientes', COUNT(*) FROM Pacientes.Pacientes
UNION ALL
SELECT 'Consultas', COUNT(*) FROM Secretaria.Consultas
UNION ALL
SELECT 'Tratamientos', COUNT(*) FROM Secretaria.TratamientoXConsulta
GO

--- CARGAR 60 MEDICOS (SQL Server asigna IDs automaticamente)
BULK INSERT Personal.Medicos
FROM 'C:\ADMIN BDA\Medicos_CON_ID.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
)
GO

--- CARGAR 970 PACIENTES
ALTER TABLE Pacientes.Pacientes DISABLE TRIGGER TR_Validar_DUI
GO
ALTER TABLE Pacientes.Pacientes DISABLE TRIGGER TR_Validar_Celular_Paciente
GO
ALTER TABLE Pacientes.Pacientes DISABLE TRIGGER TR_Validar_Edad_Paciente
GO

BULK INSERT Pacientes.Pacientes
FROM 'C:\ADMIN BDA\CSV\Pacientes_CON_ID.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    KEEPNULLS
)
GO

ALTER TABLE Pacientes.Pacientes ENABLE TRIGGER TR_Validar_DUI
GO
ALTER TABLE Pacientes.Pacientes ENABLE TRIGGER TR_Validar_Celular_Paciente
GO
ALTER TABLE Pacientes.Pacientes ENABLE TRIGGER TR_Validar_Edad_Paciente
GO

--- CARGAR 8000 CONSULTAS
BULK INSERT Secretaria.Consultas
FROM 'C:\ADMIN BDA\CSV\Consultas_CON_ID.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
)
GO

--- CARGAR 9851 TRATAMIENTOS
BULK INSERT Secretaria.TratamientoXConsulta
FROM 'C:\ADMIN BDA\CSV\TratamientoXConsulta_CON_ID.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
)
GO

--- VERIFICACION
SELECT 'Medicos' AS Tabla, COUNT(*) AS Total_Registros, CASE WHEN COUNT(*) >= 70 THEN 'OK' ELSE 'ERROR' END AS Estado FROM Personal.Medicos
UNION ALL
SELECT 'Pacientes', COUNT(*), CASE WHEN COUNT(*) >= 1000 THEN 'OK' ELSE 'ERROR' END FROM Pacientes.Pacientes
UNION ALL
SELECT 'Consultas', COUNT(*), CASE WHEN COUNT(*) >= 8000 THEN 'OK' ELSE 'ERROR' END FROM Secretaria.Consultas
UNION ALL
SELECT 'Tratamientos', COUNT(*), CASE WHEN COUNT(*) >= 9000 THEN 'OK' ELSE 'ERROR' END FROM Secretaria.TratamientoXConsulta
GO

--- Estadisticas
SELECT Estado, COUNT(*) AS Cantidad
FROM Secretaria.Consultas
GROUP BY Estado
ORDER BY Cantidad DESC
GO

SELECT 
    CASE 
        WHEN edad BETWEEN 0 AND 4 THEN 'Infantes (0-4)'
        WHEN edad BETWEEN 5 AND 12 THEN 'Ninos (5-12)'
        WHEN edad BETWEEN 13 AND 19 THEN 'Adolescentes (13-19)'
        WHEN edad BETWEEN 20 AND 30 THEN 'Adultos jovenes (20-30)'
        WHEN edad BETWEEN 31 AND 60 THEN 'Adultos (31-60)'
        ELSE 'Adultos mayores (61+)'
    END AS GrupoEtario,
    COUNT(*) AS Cantidad
FROM Pacientes.Pacientes
GROUP BY 
    CASE 
        WHEN edad BETWEEN 0 AND 4 THEN 'Infantes (0-4)'
        WHEN edad BETWEEN 5 AND 12 THEN 'Ninos (5-12)'
        WHEN edad BETWEEN 13 AND 19 THEN 'Adolescentes (13-19)'
        WHEN edad BETWEEN 20 AND 30 THEN 'Adultos jovenes (20-30)'
        WHEN edad BETWEEN 31 AND 60 THEN 'Adultos (31-60)'
        ELSE 'Adultos mayores (61+)'
    END
GO