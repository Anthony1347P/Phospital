--- FASE 1.3: INSERCION DE DATOS
--- Proyecto: PHospital - Sistema de Gestion Hospitalaria


USE PHospital
GO

--- Insertar 8 tipos de sangre
INSERT INTO Pacientes.TipoDeSangre (Tipo) VALUES
('A+'),
('O+'),
('B+'),
('AB+'),
('A-'),
('O-'),
('B-'),
('AB-')
GO

--- Insertar aseguradoras 
INSERT INTO Pacientes.Aseguradora (Aseguradora, codigo) VALUES
('ASESUISA', 1001),
('Seguros Sisa', 1002),
('Mapfre El Salvador', 1003),
('Seguros Vivir', 1004),
('BMI Seguros', 1005),
('Futuro Seguro', 1006)
GO

--- Insertar especialidades medicas 
INSERT INTO Personal.Especializacion (Especialidad) VALUES
('Pediatria'),
('Cardiologia'),
('Dermatologia'),
('Neurologia'),
('Oncologia'),
('Ginecologia'),
('Traumatologia'),
('Medicina General'),
('Oftalmologia')
GO

--- Insertar tratamientos 
INSERT INTO Tesoreria.Tratamientos (Tipo, Precio) VALUES
('Consulta General', 25),
('Medicamentos', 50),
('Examenes de Laboratorio', 75),
('Radiografia', 100),
('Fisioterapia', 40),
('Cirugia Menor', 250),
('Hospitalizacion', 150),
('Terapia Respiratoria', 60)
GO

--- Verificar datos maestros insertados
SELECT 'TipoDeSangre' AS Tabla, COUNT(*) AS Registros FROM Pacientes.TipoDeSangre
UNION ALL
SELECT 'Aseguradora', COUNT(*) FROM Pacientes.Aseguradora
UNION ALL
SELECT 'Especializacion', COUNT(*) FROM Personal.Especializacion
UNION ALL
SELECT 'Tratamientos', COUNT(*) FROM Tesoreria.Tratamientos
GO
