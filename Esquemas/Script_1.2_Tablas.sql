--- FASE 1.2: CREACION DE TABLAS EN ESQUEMAS
--- Proyecto: PHospital - Sistema de Gestion Hospitalaria

USE PHospital
GO

--- Tabla de tipos de sangre en esquema Pacientes
CREATE TABLE Pacientes.TipoDeSangre(
    idTipoDeSangre int PRIMARY KEY IDENTITY(1,1),
    Tipo varchar(5)
)
GO

--- Tabla de aseguradoras en esquema Pacientes
CREATE TABLE Pacientes.Aseguradora(
    idSeguro int PRIMARY KEY IDENTITY(1,1),
    Aseguradora varchar(30),
    codigo int
)
GO

--- Tabla de pacientes en esquema Pacientes
CREATE TABLE Pacientes.Pacientes(
    id int PRIMARY KEY IDENTITY(1,1),
    Nobres varchar(80),
    Apellidos varchar(80),
    Sexo varchar(1),
    edad int,
    idTipoDeSangre int,
    Celular int,
    Direccion varchar(150),
    DUI int,
    idSeguro int,
    FOREIGN KEY (idTipoDeSangre) REFERENCES Pacientes.TipoDeSangre(idTipoDeSangre),
    FOREIGN KEY (idSeguro) REFERENCES Pacientes.Aseguradora(idSeguro)
)
GO

--- Tabla de especializaciones en esquema Personal
CREATE TABLE Personal.Especializacion(
    id int PRIMARY KEY IDENTITY(1,1),
    Especialidad varchar(20)
)
GO

--- Tabla de medicos en esquema Personal
CREATE TABLE Personal.Medicos(
    id int PRIMARY KEY IDENTITY(1,1),
    Nombres varchar(80),
    Apellidos varchar(80),
    Sexo varchar(1),
    edad int,
    idEspecialidad int,
    celular int,
    FOREIGN KEY (idEspecialidad) REFERENCES Personal.Especializacion(id)
)
GO

--- Tabla de consultas en esquema Secretaria
CREATE TABLE Secretaria.Consultas(
    id int PRIMARY KEY IDENTITY(1,1),
    idPaciente int,
    idMedico int,
    Fecha DATETIME,
    Motivo varchar(100),
    Estado varchar(20),
    FOREIGN KEY (idPaciente) REFERENCES Pacientes.Pacientes(id),
    FOREIGN KEY (idMedico) REFERENCES Personal.Medicos(id)
)
GO

--- Tabla de tratamientos en esquema Tesoreria
CREATE TABLE Tesoreria.Tratamientos(
    id int PRIMARY KEY IDENTITY(1,1),
    Tipo varchar(30),
    Precio int
)
GO

--- Tabla de tratamientos por consulta en esquema Secretaria
CREATE TABLE Secretaria.TratamientoXConsulta(
    id int PRIMARY KEY IDENTITY(1,1),
    idTratamiento int,
    idConsulta int,
    Cantidad int,
    FOREIGN KEY (idConsulta) REFERENCES Secretaria.Consultas(id),
    FOREIGN KEY (idTratamiento) REFERENCES Tesoreria.Tratamientos(id)
)
GO

--- Tabla de facturas en esquema Tesoreria
CREATE TABLE Tesoreria.Factura(
    id int PRIMARY KEY IDENTITY(1,1),
    idPaciente int,
    Fecha DATETIME,
    Total int,
    Estado varchar(20),
    FOREIGN KEY (idPaciente) REFERENCES Pacientes.Pacientes(id)
)
GO

--- Tabla de detalle de facturas en esquema Tesoreria
CREATE TABLE Tesoreria.FacturaDetalle(
    id int PRIMARY KEY IDENTITY(1,1),
    idTratamiento int,
    idPaciente int,
    SubTotal int,
    FOREIGN KEY (idTratamiento) REFERENCES Tesoreria.Tratamientos(id),
    FOREIGN KEY (idPaciente) REFERENCES Pacientes.Pacientes(id)
)
GO

--- Verificar objetos creados en cada esquema
SELECT s.name AS Esquema, o.name AS Objeto, o.type_desc AS Tipo 
FROM sys.objects o 
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id 
WHERE s.name IN ('Pacientes', 'Personal', 'Tesoreria', 'Secretaria') 
ORDER BY s.name, o.type_desc
GO